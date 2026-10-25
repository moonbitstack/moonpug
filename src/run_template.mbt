///|
/// The template a value names: a name for the loader, or a list of names
/// of which the first that exists wins.
fn Run::resolve(
  self : Run,
  value : @spec.Value,
  missing_ok : Bool,
) -> Template? raise @spec.Refused {
  match value {
    Text(name) | Markup(name) =>
      if missing_ok {
        self.env.find(name)
      } else {
        Some(self.env.template(name))
      }
    Seq(names) | Tuple(names) => {
      for n in names {
        match self.env.find(self.call.text(n)) {
          Some(t) => return Some(t)
          None => ()
        }
      }
      if missing_ok {
        None
      } else {
        raise @spec.unknown(
          "template",
          names.map(n => n.to_string()).join(", "),
        )
      }
    }
    Undefined(name) => raise undefined_use(name)
    v =>
      raise @spec.invalid("a template name must be a string, not \{v.kind()}")
  }
}

///|
/// File every block a template defines, behind the ones already filed: a
/// child's blocks come first, then its parent's.
fn Run::file_blocks(
  self : Run,
  nodes : Array[@syntax.Node],
  template : String,
) -> Unit {
  for node in nodes {
    match node {
      BlockDef(b) => {
        match self.blocks.get(b.name) {
          Some(frames) =>
            if !frames.iter().any(f => f.template == template) {
              frames.push({ block: b, template, })
            }
          None => self.blocks[b.name] = [{ block: b, template, }]
        }
        self.file_blocks(b.body, template)
      }
      For(body~, otherwise~, ..) => {
        self.file_blocks(body, template)
        self.file_blocks(otherwise, template)
      }
      If(branches, otherwise) => {
        for b in branches {
          self.file_blocks(b.1, template)
        }
        self.file_blocks(otherwise, template)
      }
      With(_, body)
      | Autoescape(_, body)
      | FilterBlock(_, body)
      | Show(_, body)
      | Once(_, body)
      | Comment(body) => self.file_blocks(body, template)
      Element(el) => self.file_blocks(el.body, template)
      MacroDef(m) => self.file_blocks(m.body, template)
      SetBlock(_, _, body) | CallBlock(_, _, body) =>
        self.file_blocks(body, template)
      Case(_, arms, otherwise) => {
        for arm in arms {
          self.file_blocks(arm.1, template)
        }
        self.file_blocks(otherwise, template)
      }
      _ => ()
    }
  }
}

///|
/// `{% extends %}`: what follows writes nothing outside blocks, and the
/// parent renders when this template is done.
fn Run::set_parent(self : Run, value : @spec.Value) -> Unit raise @spec.Refused {
  if self.extended {
    raise @spec.invalid("extended multiple times")
  }
  match self.resolve(value, false) {
    Some(parent) => {
      self.extended = true
      self.parents.push(parent)
    }
    None => ()
  }
}

///|
/// Render a template's nodes and, if it extends another, the ancestors in
/// turn, each with its blocks filed behind the child's.
fn Run::render_chain(
  self : Run,
  nodes : Array[@syntax.Node],
) -> Unit raise @spec.Refused {
  self.file_blocks(nodes, self.template)
  self.run_nodes(nodes)
  while self.parents.pop() is Some(parent) {
    self.enter()
    self.extended = false
    self.template = parent.name
    self.file_blocks(parent.nodes, parent.name)
    self.run_nodes(parent.nodes)
    self.leave()
  }
}

///|
/// Render the block filed under `name` at `level`; `super()` renders the
/// next one down, and Pug's `append` and `prepend` place it around this one.
fn Run::render_block_at(
  self : Run,
  name : String,
  level : Int32,
  scoped : Bool,
) -> Unit raise @spec.Refused {
  let frames = self.blocks.get(name).unwrap_or([])
  if level >= frames.length() {
    return
  }
  let frame = frames[level]
  if frame.block.required &&
    level == frames.length() - 1 &&
    frames.length() == 1 {
    raise @spec.invalid("required block \{@spec.repr_text(name)} not found")
  }
  self.enter()
  defer self.leave()
  let saved_scopes = self.scopes
  let saved_template = self.template
  self.scopes = if scoped { self.scopes.copy() } else { [self.scopes[0]] }
  self.template = frame.template
  self.push(Map([]))
  defer {
    self.scopes = saved_scopes
    self.template = saved_template
  }
  if level + 1 < frames.length() {
    self.bind(
      "super",
      @spec.Value::func("super", (_, _, _) => {
        let text = self.capture(() => {
          self.render_block_at(name, level + 1, scoped)
        })
        self.rendered(text)
      }),
    )
  }
  match frame.block.placement {
    Replace => self.run_nodes(frame.block.body)
    Append => {
      self.render_block_at(name, level + 1, scoped)
      self.run_nodes(frame.block.body)
    }
    Prepend => {
      self.run_nodes(frame.block.body)
      self.render_block_at(name, level + 1, scoped)
    }
  }
}

///|
fn Run::render_block(
  self : Run,
  name : String,
  scoped~ : Bool = false,
) -> Unit raise @spec.Refused {
  self.render_block_at(name, 0, scoped)
}

///|
/// `self`: each block of the template, callable by name.
priv struct Blocks {
  run : Run
}

///|
impl @spec.Object for Blocks with fn kind(_) {
  "the template's blocks"
}

///|
impl @spec.Object for Blocks with fn attr(self, name) {
  if self.run.blocks.contains(name) {
    Some(
      @spec.Value::func(name, (_, _, _) => {
        let text = self.run.capture(() => self.run.render_block(name))
        self.run.rendered(text)
      }),
    )
  } else {
    None
  }
}

///|
/// `{% include %}`: render another template here, with the variables in
/// scope or without them; a `raw` include writes the file as it stands.
fn Run::include_template(
  self : Run,
  value : @spec.Value,
  missing~ : Bool,
  context~ : Bool,
  raw~ : Bool,
  inline~ : Bool,
  block~ : Array[@syntax.Node],
) -> Unit raise @spec.Refused {
  if raw {
    let name = self.call.text(value)
    match self.env.source(name) {
      Some(text) => self.out.write_string(text)
      None => if !missing { raise @spec.unknown("template", name) }
    }
    return
  }
  let template = match self.resolve(value, missing) {
    Some(t) => t
    None => return
  }
  self.enter()
  defer self.leave()
  let saved = (
    self.scopes,
    self.template,
    self.blocks,
    self.extended,
    self.parents,
  )
  if !inline {
    self.scopes = if context { [self.visible(), Map([])] } else { [Map([])] }
  }
  if !inline || template.nodes.iter().any(n => n is Extends(_)) {
    self.blocks = Map([])
  }
  self.template = template.name
  self.extended = false
  self.parents = []
  defer {
    self.scopes = saved.0
    self.template = saved.1
    self.blocks = saved.2
    self.extended = saved.3
    self.parents = saved.4
  }
  let before = self.autoescape()
  self.set_autoescape(template.format.autoescape)
  defer self.set_autoescape(before)
  self.render_chain(
    if block.is_empty() {
      template.nodes
    } else {
      apply_yield(template.nodes, block)
    },
  )
}

///|
/// An included template with the include's block in place of each `yield`;
/// with no `yield`, the block goes at the end of the innermost last element,
/// as Pug places it.
fn apply_yield(
  nodes : Array[@syntax.Node],
  block : Array[@syntax.Node],
) -> Array[@syntax.Node] {
  let found = Ref(false)
  fn swap(ns : Array[@syntax.Node]) -> Array[@syntax.Node] {
    let out = []
    for n in ns {
      match n {
        Yield => {
          found.val = true
          out.append(block)
        }
        Element(el) => out.push(Element({ ..el, body: swap(el.body), }))
        For(target~, iter~, cond~, recursive~, each~, body~, otherwise~) =>
          out.push(
            For(
              target~,
              iter~,
              cond~,
              recursive~,
              each~,
              body=swap(body),
              otherwise=swap(otherwise),
            ),
          )
        If(branches, otherwise) =>
          out.push(If(branches.map(b => (b.0, swap(b.1))), swap(otherwise)))
        BlockDef(b) => out.push(BlockDef({ ..b, body: swap(b.body), }))
        other => out.push(other)
      }
    }
    out
  }
  let swapped = swap(nodes)
  if found.val {
    return swapped
  }
  fn last(ns : Array[@syntax.Node]) -> Array[@syntax.Node] {
    let out = ns.copy()
    for i = out.length() - 1; i >= 0; i = i - 1 {
      match out[i] {
        Element(el) if el.body.iter().any(n => !(n is (Line(_) | Text(_)))) => {
          out[i] = Element({ ..el, body: last(el.body), })
          return out
        }
        For(target~, iter~, cond~, recursive~, each~, body~, otherwise~) if !body.is_empty() => {
          out[i] = For(
            target~,
            iter~,
            cond~,
            recursive~,
            each~,
            body=last(body),
            otherwise~,
          )
          return out
        }
        Line(_) | Text(_) => continue
        _ => break
      }
    }
    out.append(block)
    out
  }
  last(swapped)
}

///|
/// A template imported as a module: the names its top level defines.
priv struct Module {
  name : String
  fields : Map[String, @spec.Value]
}

///|
impl @spec.Object for Module with fn kind(self) {
  "the template \{self.name}"
}

///|
impl @spec.Object for Module with fn attr(self, name) {
  if name.has_prefix("_") {
    None
  } else {
    self.fields.get(name)
  }
}

///|
impl @spec.Object for Module with fn show(self) {
  "<Template module \{@spec.repr_text(self.name)}>"
}

///|
fn Run::import_module(
  self : Run,
  value : @spec.Value,
  context : Bool,
) -> @spec.Value raise @spec.Refused {
  let template = match self.resolve(value, false) {
    Some(t) => t
    None => raise @spec.unknown("template", value.to_string())
  }
  self.enter()
  defer self.leave()
  let top : Map[String, @spec.Value] = if context {
    self.visible()
  } else {
    Map([])
  }
  let module_run = Run::new(
    self.env,
    template.name,
    template.format.autoescape,
    top,
  )
  let module_run = { ..module_run, depth: self.depth, }
  let own : Map[String, @spec.Value] = Map([])
  module_run.scopes.push(own)
  module_run.scopes[0]["self"] = Object(Blocks::{ run: module_run, })
  module_run.render_chain(template.nodes)
  let fields = Map([])
  for k, v in own {
    if !k.has_prefix("_") {
      fields[k] = v
    }
  }
  Object(Module::{ name: template.name, fields, })
}
