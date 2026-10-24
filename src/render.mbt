// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Mutable state one loop owns: what `cycle` last handed out and what
/// `changed` last compared against.
priv struct LoopCtl {
  mut cycle_at : Int32
  mut last_args : Array[Value]?
}

///|
fn run_nodes(env : Env, nodes : Array[Node]) -> Unit raise Fault {
  for node in nodes {
    run_node(env, node)
    if env.braking || env.skipping {
      return
    }
  }
}

///|
fn run_node(env : Env, node : Node) -> Unit raise Fault {
  match node {
    Text(text) => env.out.write_string(text)
    Group(inner) => run_nodes(env, inner)
    Out(expr) => env.emit(eval(env, expr))
    OutRaw(expr) => env.emit_raw(eval(env, expr))
    For(names~, iter~, filter~, recursive~, swap~, body~, otherwise~) => {
      let raw = materialise(eval(env, iter))
      let items = match filter {
        Some(cond) => filter_items(env, names, raw, cond)
        None => raw
      }
      if items.is_empty() {
        run_nodes(env, otherwise)
        return
      }
      // Pug's two-name each: over a list the second name is the index, over a
      // mapping it is the key and the first the value.
      let swap_pairs = swap && names.length() == 2
      let items = if swap_pairs {
        match eval(env, iter) {
          Dict(fields) => {
            let pairs = []
            for key in sorted_keys(fields) {
              pairs.push(Seq([Text(key), fields.get_or_default(key, Null)]))
            }
            pairs
          }
          other => materialise(other)
        }
      } else {
        items
      }
      let ctl = { cycle_at: 0, last_args: None, }
      env.push({})
      loop_pass(env, names, body, recursive, items, 0, ctl, swap_pairs)
      env.braking = false
      env.skipping = false
      env.pop()
    }
    If(branches, otherwise) => {
      let mut taken = false
      for branch in branches {
        let (cond, body) = branch
        if !taken && truthy(eval(env, cond)) {
          taken = true
          run_nodes(env, body)
        }
      }
      if !taken {
        run_nodes(env, otherwise)
      }
    }
    SetVar(names, expr) => {
      let value = eval(env, expr)
      if names.length() == 1 {
        env.set(names[0], value)
      } else {
        match value {
          Seq(parts) => {
            if parts.length() != names.length() {
              raise Wrong(
                because="\{names.length()} names cannot unpack \{parts.length()} values",
              )
            }
            for i = 0; i < names.length(); i = i + 1 {
              env.set(names[i], parts[i])
            }
          }
          _ => raise Wrong(because="only a list can unpack into several names")
        }
      }
    }
    SetPath(path, expr) => {
      let value = eval(env, expr)
      match env.find(path[0]) {
        Some(scope) =>
          match scope.get_or_default(path[0], Absent(path[0])) {
            Namespaced(fields) => {
              let mut bag = fields
              let last = path.length() - 1
              for i = 1; i < last; i = i + 1 {
                match bag.get_or_default(path[i], Absent(path[i])) {
                  Namespaced(inner) => bag = inner
                  _ => raise Wrong(because="\{path[i]} is not a namespace")
                }
              }
              bag.set(path[last], value)
            }
            _ => raise Wrong(because="\{path[0]} is not a namespace")
          }
        None => raise Undefined(name=path[0])
      }
    }
    SetBlock(name, body) => {
      let captured = env.capture(() => run_nodes(env, body))
      let value = if env.autoescape { Markup(captured) } else { Text(captured) }
      env.set(name, value)
    }
    MacroDef(name, def) => {
      def.home = env.stack[0].copy()
      env.set(name, MacroV(def))
    }
    CallBlock(params, call, body) => {
      let caller : Macro = {
        name: "caller",
        params,
        defaults: [],
        rest: None,
        body,
        home: env.stack[0].copy(),
      }
      match call {
        Call(target, args) => {
          let callee = eval(env, target)
          let (pos, kw) = eval_args(env, args)
          env.emit(call_value_with(env, callee, pos, kw, Some(caller)))
        }
        _ => raise Wrong(because="a call block needs a macro call")
      }
    }
    FilterBlock(filters, body) => {
      let captured = env.capture(() => run_nodes(env, body))
      let mut current : Value = if env.autoescape {
        Markup(captured)
      } else {
        Text(captured)
      }
      for step in filters {
        let (name, args) = step
        let (pos, kw) = eval_args(env, args)
        current = match env.filters.get(name) {
          Some(found) => found.filter(context_of(env), current, pos, kw)
          None => raise Unknown(name~, kind="filter")
        }
      }
      env.emit(current)
    }
    Extends(_) => () // consumed while the chain was entered
    Block(name, own) => render_block(env, name, own)
    Include(name_expr, ignore_missing, with_context) => {
      let name = show_value(eval(env, name_expr))
      let found = match env.load {
        Some(loader) => loader(name)
        None => None
      }
      match found {
        None => if !ignore_missing { raise Unknown(name~, kind="template") }
        Some(source) => {
          let saved = env.blocks
          env.blocks = Map([])
          let nodes = parse_template(source, opts_for_name(env.opts, name))
          let outer = enter_chain(env, nodes)
          let stack = env.stack
          if with_context {
            env.stack = stack.copy()
            env.stack.push({})
          } else {
            env.stack = [{}]
          }
          run_nodes(env, outer)
          env.stack = stack
          env.blocks = saved
        }
      }
    }
    Import(name_expr, as_name, with_context) => {
      let ns = import_module(env, name_expr, with_context)
      env.set(as_name, Namespaced(ns))
    }
    FromImport(name_expr, wanted, with_context) => {
      let ns = import_module(env, name_expr, with_context)
      for entry in wanted {
        let (name, as_name) = entry
        match ns.get(name) {
          Some(value) =>
            env.set(
              match as_name {
                Some(as_name) => as_name
                None => name
              },
              value,
            )
          None => raise Unknown(name~, kind="import")
        }
      }
    }
    With(bindings, body) => {
      let scope : Map[String, Value] = Map([])
      for pair in bindings {
        let (name, expr) = pair
        scope.set(name, eval(env, expr))
      }
      env.push(scope)
      run_nodes(env, body)
      env.pop()
    }
    Autoescape(setting, body) => {
      let before = env.autoescape
      let value = eval(env, setting)
      env.autoescape = truthy(value)
      errdefer {
        env.autoescape = before
      }
      run_nodes(env, body)
      env.autoescape = before
    }
    Do(exprs) =>
      for expr in exprs {
        ignore(eval(env, expr))
      }
    Debug => {
      let flat = env.flatten()
      let parts = []
      for name in sorted_keys(flat) {
        parts.push("'\{name}': " + repr_value(flat.get_or_default(name, Null)))
      }
      env.emit(Text("{" + join_texts(parts, ", ") + "}"))
    }
    Show(cond, body) => {
      let captured = env.capture(() => run_nodes(env, body))
      if truthy(eval(env, cond)) {
        env.out.write_string(captured)
      } else {
        env.out.write_string("<div style=\"display: none\">\{captured}</div>")
      }
    }
    Once(key, body) => {
      let ctx_tally = env.tally
      let slot = match key {
        Some(k) => k
        None => {
          ctx_tally.n = ctx_tally.n + 1
          "once-\{ctx_tally.n}"
        }
      }
      match env.once.get(slot) {
        Some(cached) => env.out.write_string(cached)
        None => {
          fn take() -> String raise Fault {
            let taken = env.capture(() => run_nodes(env, body))
            env.once.set(slot, taken)
            taken
          }
          match env.cache_fn {
            Some(store) => env.out.write_string(store(slot, take))
            None => env.out.write_string(take())
          }
        }
      }
    }
    Trans(spec) => run_trans(env, spec)
    Break => env.braking = true
    Continue => env.skipping = true
    LangBlock(lang, source) => {
      let opts = opts_for_lang(env.opts, lang)
      run_nodes(env, parse_template(source, opts))
    }
    Element(elem) => render_element(env, elem)
    Doctype(name) => env.out.write_string(doctype_of(name))
    Comment(visible, children) =>
      if visible {
        let inner = env.capture(() => run_nodes(env, children))
        env.out.write_string("<!--\{inner}-->")
      }
    Case(subject, arms, otherwise) => {
      let value = eval(env, subject)
      let mut matched = false
      for arm in arms {
        if !matched && arm.values.is_empty() {
          matched = true
          run_nodes(env, arm.body)
        } else if !matched {
          for value_expr in arm.values {
            if same_value(eval(env, value_expr), value) {
              matched = true
              run_nodes(env, arm.body)
              break
            }
          }
        }
      }
      if !matched {
        run_nodes(env, otherwise)
      }
    }
  }
}

///|
/// A loop's iterable, as a flat list: a list as it stands, a mapping by its
/// sorted keys, a string by its characters.
fn materialise(value : Value) -> Array[Value] raise Fault {
  match value {
    Seq(items) => items.copy()
    Dict(fields) => {
      let keys = []
      for name in sorted_keys(fields) {
        keys.push(Value::Text(name))
      }
      keys
    }
    Text(s) | Markup(s) => {
      let chars = []
      for ch in s {
        chars.push(Value::Text(ch.to_string()))
      }
      chars
    }
    Absent(name) => raise Undefined(name~)
    _ => raise Wrong(because="\{kind_of(value)} cannot be iterated")
  }
}

///|
/// A filtered `for`: the condition sees the names and a loop that knows how
/// far the kept items have come; `last` and `nextitem` are not knowable yet
/// and stay undefined. The pass that follows sees the whole truth.
fn filter_items(
  env : Env,
  names : Array[String],
  raw : Array[Value],
  cond : Expr,
) -> Array[Value] raise Fault {
  let kept = []
  env.push({})
  for i = 0; i < raw.length(); i = i + 1 {
    bind_names(env, names, raw[i])
    let loop_dict = loop_dict_of(raw, i, 0, None, None)
    env.set("loop", Dict(loop_dict))
    if truthy(eval(env, cond)) {
      kept.push(raw[i])
    }
  }
  env.pop()
  kept
}

///|
fn bind_names(
  env : Env,
  names : Array[String],
  item : Value,
) -> Unit raise Fault {
  if names.length() == 1 {
    env.set(names[0], item)
    return
  }
  match item {
    Seq(parts) => {
      if parts.length() != names.length() {
        raise Wrong(
          because="\{names.length()} names cannot unpack \{parts.length()} values",
        )
      }
      for i = 0; i < names.length(); i = i + 1 {
        env.set(names[i], parts[i])
      }
    }
    _ => raise Wrong(because="only a list can unpack into several names")
  }
}

///|
/// One whole pass of a loop, or of a recursive `loop(...)` call inside it.
fn loop_pass(
  env : Env,
  names : Array[String],
  body : Array[Node],
  recursive : Bool,
  items : Array[Value],
  depth0 : Int32,
  ctl : LoopCtl,
  swap_pairs : Bool,
) -> Unit raise Fault {
  for i = 0; i < items.length(); i = i + 1 {
    if swap_pairs {
      match items[i] {
        Seq(pair) if pair.length() == 2 => {
          // A key-and-value pair from a mapping: Pug binds value first.
          env.set(names[0], pair[1])
          env.set(names[1], pair[0])
        }
        plain => {
          env.set(names[0], plain)
          env.set(names[1], Int(i.to_int64()))
        }
      }
    } else {
      bind_names(env, names, items[i])
    }
    let prev = if i > 0 { Some(items[i - 1]) } else { None }
    let next = if i + 1 < items.length() { Some(items[i + 1]) } else { None }
    let dict = loop_dict_of(items, i, depth0, prev, next)
    dict.set("cycle", Native("cycle", args => cycle_step(ctl, args)))
    dict.set("changed", Native("changed", args => changed_step(ctl, args)))
    if recursive {
      // The loop is a mapping and a callable at once: the call rides behind
      // a reserved key the caller never names.
      dict.set(
        "__call__",
        Native("loop", sub => {
          // `sub` carries the arguments; the sequence to walk is the first.
          let seq = if sub.is_empty() { [] } else { materialise(sub[0]) }
          let taken = env.capture(() => {
            env.push({})
            loop_pass(
              env,
              names,
              body,
              recursive,
              seq,
              depth0 + 1,
              { cycle_at: 0, last_args: None, },
              swap_pairs,
            )
            env.pop()
          })
          Markup(taken)
        }),
      )
    }
    env.set("loop", Dict(dict))
    run_nodes(env, body)
    if env.braking {
      env.braking = false
      break
    }
    if env.skipping {
      env.skipping = false
      continue
    }
  }
  ignore(env)
}

///|
fn cycle_step(ctl : LoopCtl, args : Array[Value]) -> Value raise Fault {
  if args.is_empty() {
    raise Wrong(because="loop.cycle() needs at least one value")
  }
  let picked = args[ctl.cycle_at % args.length()]
  ctl.cycle_at = ctl.cycle_at + 1
  picked
}

///|
fn changed_step(ctl : LoopCtl, args : Array[Value]) -> Value {
  let changed = match ctl.last_args {
    None => true
    Some(before) => {
      let same = before.length() == args.length() &&
        ({
          let mut ok = true
          for i = 0; i < args.length(); i = i + 1 {
            if !same_value(before[i], args[i]) {
              ok = false
              break
            }
          }
          ok
        })
      !same
    }
  }
  ctl.last_args = Some(args.copy())
  Bool(changed)
}

///|
/// The `loop` object, rebuilt every iteration: the counts, the neighbours,
/// and the two stateful methods.
fn loop_dict_of(
  items : Array[Value],
  i : Int32,
  depth0 : Int32,
  prev : Value?,
  next : Value?,
) -> Map[String, Value] {
  let n = items.length()
  let dict : Map[String, Value] = Map([])
  dict.set("index0", Int(i.to_int64()))
  dict.set("index", Int((i + 1).to_int64()))
  dict.set("revindex0", Int((n - i - 1).to_int64()))
  dict.set("revindex", Int((n - i).to_int64()))
  dict.set("first", Bool(i == 0))
  dict.set("last", Bool(i == n - 1))
  dict.set("length", Int(n.to_int64()))
  dict.set("depth", Int((depth0 + 1).to_int64()))
  dict.set("depth0", Int(depth0.to_int64()))
  dict.set("__loop__", Bool(true))
  dict.set(
    "previtem",
    match prev {
      Some(v) => v
      None => Absent("loop.previtem")
    },
  )
  dict.set(
    "nextitem",
    match next {
      Some(v) => v
      None => Absent("loop.nextitem")
    },
  )
  dict
}

///|
/// A macro rendered: defaults filled from its own module, extra positional
/// arguments into its rest parameter or `varargs`, and a caller bound when a
/// call block came along.
fn invoke_macro(
  env : Env,
  def : Macro,
  pos : Array[Value],
  kw : Map[String, Value],
  caller : Macro?,
) -> String raise Fault {
  let scope : Map[String, Value] = Map([])
  for i = 0; i < def.params.length(); i = i + 1 {
    let param = def.params[i]
    let mut value : Value? = None
    if i < pos.length() {
      value = Some(pos[i])
    } else if kw.contains(param) {
      value = kw.get(param)
    } else {
      for pair in def.defaults {
        let (at, default_expr) = pair
        if at == i {
          value = Some(eval(env, default_expr))
        }
      }
    }
    match value {
      Some(v) => scope.set(param, v)
      None => raise Wrong(because="\{def.name}() is missing \{param}")
    }
  }
  if pos.length() > def.params.length() {
    let extras = []
    for i = def.params.length(); i < pos.length(); i = i + 1 {
      extras.push(pos[i])
    }
    match def.rest {
      Some(rest) => scope.set(rest, Seq(extras))
      None => scope.set("varargs", Seq(extras))
    }
  }
  for name, value in kw {
    if !def.params.contains(name) {
      ignore(value)
      raise Wrong(because="\{def.name}() takes no \{name}")
    }
  }
  match caller {
    Some(caller_def) => {
      scope.set("caller", MacroV(caller_def))
      scope.set("block", MacroV(caller_def))
    }
    None => ()
  }
  let stack = env.stack
  env.stack = [def.home]
  env.push(scope)
  let taken = env.capture(() => run_nodes(env, def.body))
  env.stack = stack
  taken
}

///|
fn call_value_with(
  env : Env,
  callee : Value,
  pos : Array[Value],
  kw : Map[String, Value],
  caller : Macro?,
) -> Value raise Fault {
  match callee {
    Native(_, call) => call(pos)
    MacroV(m) => Markup(invoke_macro(env, m, pos, kw, caller))
    _ => call_value(env, callee, pos, kw)
  }
}

///|
/// Walk the tree filing every `{% block %}` under its name.
fn collect_blocks(nodes : Array[Node], found : Map[String, BlockDef]) -> Unit {
  for node in nodes {
    match node {
      Block(name, def) => {
        found.set(name, def)
        collect_blocks(def.body, found)
      }
      For(body~, otherwise~, ..) => {
        collect_blocks(body, found)
        collect_blocks(otherwise, found)
      }
      If(branches, otherwise) => {
        for branch in branches {
          collect_blocks(branch.1, found)
        }
        collect_blocks(otherwise, found)
      }
      SetBlock(_, body) => collect_blocks(body, found)
      CallBlock(_, _, body) => collect_blocks(body, found)
      FilterBlock(_, body) => collect_blocks(body, found)
      With(_, body) => collect_blocks(body, found)
      Autoescape(_, body) => collect_blocks(body, found)
      Show(_, body) => collect_blocks(body, found)
      Once(_, body) => collect_blocks(body, found)
      Comment(_, children) => collect_blocks(children, found)
      Element(elem) => collect_blocks(elem.children, found)
      _ => ()
    }
  }
}

///|
/// Follow `extends` to the outermost ancestor, registering definitions with
/// the ancestor lowest and the child highest: the child is what a block
/// renders, `super()` the ones beneath it.
fn enter_chain(env : Env, nodes : Array[Node]) -> Array[Node] raise Fault {
  let own : Map[String, BlockDef] = Map([])
  collect_blocks(nodes, own)
  let parent = find_extends(nodes)
  match parent {
    Some(expr) => {
      let name = show_value(eval(env, expr))
      let source = match env.load {
        Some(loader) => loader(name)
        None => None
      }
      match source {
        None => raise Unknown(name~, kind="template")
        Some(text) => {
          let parent_nodes = parse_template(text, opts_for_name(env.opts, name))
          let outer = enter_chain(env, parent_nodes)
          for name_, def in own {
            push_block(env, name_, def)
          }
          outer
        }
      }
    }
    None => {
      for name_, def in own {
        push_block(env, name_, def)
      }
      nodes
    }
  }
}

///|
fn push_block(env : Env, name : String, def : BlockDef) -> Unit raise Fault {
  if def.required && !env.blocks.contains(name) {
    raise Wrong(
      because="block \{name} is required but no parent template defines it",
    )
  }
  match env.blocks.get(name) {
    Some(stack) => stack.push(def)
    None => env.blocks.set(name, [def])
  }
}

///|
fn find_extends(nodes : Array[Node]) -> Expr? {
  for node in nodes {
    match node {
      Extends(expr) => return Some(expr)
      _ => ()
    }
  }
  None
}

///|
/// A block renders the top of its definition stack — the child-most — with
/// Pug's `append` and `prepend` placing the ancestor's rendering around it.
/// The block sees the shared context and, with `scoped`, the names around the
/// place it was called from.
fn render_block(env : Env, name : String, own : BlockDef) -> Unit raise Fault {
  let defs = match env.blocks.get(name) {
    Some(stack) => stack
    None => [own]
  }
  let top = defs.length() - 1
  match defs[top].mod {
    Override => render_block_def(env, name, defs, top)
    Append => {
      for i = 0; i < top; i = i + 1 {
        render_block_def(env, name, defs, i)
      }
      render_block_def(env, name, defs, top)
    }
    Prepend => {
      render_block_def(env, name, defs, top)
      for i = 0; i < top; i = i + 1 {
        render_block_def(env, name, defs, i)
      }
    }
  }
}

///|
fn render_block_def(
  env : Env,
  name : String,
  defs : Array[BlockDef],
  at : Int32,
) -> Unit raise Fault {
  let def = defs[at]
  let stack = env.stack
  env.stack = [stack[0]]
  if def.scoped {
    let extras = env.flatten()
    for extra_name, value in extras {
      env.stack[0].set(extra_name, value)
    }
  }
  env.push({})
  if at > 0 {
    env.set(
      "super",
      Native("super", _args => {
        let taken = env.capture(() => {
          for i = 0; i < at; i = i + 1 {
            render_block_def(env, name, defs, i)
          }
        })
        Markup(taken)
      }),
    )
  }
  run_nodes(env, def.body)
  env.stack = stack
}

///|
/// An imported module: its template runs to completion in a room of its own,
/// and what its top level left behind — macros, sets, imports — is the
/// namespace the caller keeps.
fn import_module(
  env : Env,
  name_expr : Expr,
  with_context : Bool,
) -> Map[String, Value] raise Fault {
  let name = show_value(eval(env, name_expr))
  let source = match env.load {
    Some(loader) => loader(name)
    None => None
  }
  match source {
    None => raise Unknown(name~, kind="template")
    Some(text) => {
      let inner : Env = {
        out: StringBuilder(),
        stack: [Map([])],
        blocks: Map([]),
        filters: env.filters,
        tests: env.tests,
        globals: env.globals,
        once: env.once,
        tally: env.tally,
        load: env.load,
        translate: env.translate,
        cache_fn: env.cache_fn,
        opts: env.opts,
        policy: env.policy,
        autoescape: env.autoescape,
        braking: false,
        skipping: false,
      }
      if with_context {
        inner.stack[0] = env.flatten()
      }
      let nodes = parse_template(text, opts_for_name(env.opts, name))
      let outer = enter_chain(inner, nodes)
      run_nodes(inner, outer)
      inner.stack[0]
    }
  }
}

///|
/// `{% trans %}`: bindings evaluated, the count read, the translation seam
/// asked, and the `%(name)s` placeholders filled from the bindings.
fn run_trans(env : Env, spec : TransSpec) -> Unit raise Fault {
  let bound : Map[String, Value] = Map([])
  for pair in spec.bindings {
    let (name, expr) = pair
    bound.set(name, eval(env, expr))
  }
  let count : Int32? = match spec.count_name {
    Some(counter) =>
      match bound.get(counter) {
        Some(Int(n)) => Some(n.to_int())
        Some(Double(d)) => Some(d.to_int())
        _ => None
      }
    None => None
  }
  let plural_wanted = match count {
    Some(n) => n != 1
    None => false
  }
  match env.translate {
    Some(seam) => {
      // The msgid carries %(name)s where the template wrote {{ name }}.
      let singular = msgid_of(spec.singular, bound)
      let msgid = if plural_wanted && spec.plural is Some(_) {
        msgid_of(spec.plural.unwrap(), bound)
      } else {
        singular
      }
      let message = match seam(msgid, None, count) {
        Some(translated) => translated
        None =>
          if plural_wanted && spec.plural is Some(plural) {
            plural
          } else {
            singular
          }
      }
      env.emit(Text(fill_placeholders(message, bound)))
    }
    None => {
      // No seam: the body renders as a template with the bindings in scope.
      let raw = if plural_wanted && spec.plural is Some(plural) {
        plural
      } else {
        spec.singular
      }
      env.push(bound)
      let nodes = parse_template(raw, env.opts)
      run_nodes(env, nodes)
      env.pop()
    }
  }
}

///|
/// `{{ name }}` in a trans body becomes `%(name)s` for the translation seam.
fn msgid_of(text : String, bound : Map[String, Value]) -> String {
  let out = StringBuilder()
  let n = text.length()
  let mut i = 0
  while i < n {
    if text.at(i) == 0x7B &&
      i + 2 < n &&
      text.at(i + 1) == 0x7B &&
      text.at(i + 2) == 0x20 {
      let mut j = i + 3
      while j < n && is_name_part(text.at(j)) {
        j = j + 1
      }
      let name = text[i + 3:j].to_owned()
      if j + 2 < n &&
        text.at(j) == 0x20 &&
        text.at(j + 1) == 0x7D &&
        text.at(j + 2) == 0x7D &&
        bound.contains(name) {
        out.write_string("%(" + name + ")s")
        i = j + 3
        continue
      }
    }
    out.write_char(u16_char(text.at(i)))
    i = i + 1
  }
  out.to_string()
}

///|
/// `%(name)s` and `%(name)d`, filled with each binding's text.
fn fill_placeholders(message : String, bound : Map[String, Value]) -> String {
  let out = StringBuilder()
  let src = message
  let n = src.length()
  let mut i = 0
  let mut run = 0
  while i < n {
    if src.at(i) == 0x25 && i + 1 < n && src.at(i + 1) == 0x28 {
      let mut j = i + 2
      let mut name = ""
      while j < n && is_name_part(src.at(j)) {
        j = j + 1
      }
      name = src[i + 2:j].to_owned()
      if j < n && src.at(j) == 0x29 && j + 1 < n {
        let letter = src.at(j + 1)
        if letter == 0x73 || letter == 0x64 {
          out.write_string(src[run:i].to_owned())
          match bound.get(name) {
            Some(value) => out.write_string(show_value(value))
            None => out.write_string("%(\{name})s")
          }
          i = j + 2
          run = i
          continue
        }
      }
    }
    i = i + 1
  }
  out.write_string(src[run:n].to_owned())
  out.to_string()
}

///|
/// An element of the indentation surface, written out: shorthand first, then
/// attributes in the order they were written, then `&attributes` splats
/// replacing or appending, then the diff key.
fn render_element(env : Env, elem : Elem) -> Unit raise Fault {
  let out = env.out
  out.write_string("<")
  out.write_string(elem.tag)
  if elem.id is Some(id) {
    out.write_string(" id=\"\{escape_text(id)}\"")
  }
  let classes : Array[String] = []
  for name in elem.classes {
    classes.push(name)
  }
  let attrs : Array[Attr] = []
  for attr in elem.attrs {
    match attr.value {
      other => attrs.push({ name: attr.name, value: other, })
    }
  }
  for splat in elem.splats {
    match eval(env, splat) {
      Dict(fields) =>
        for name in sorted_keys(fields) {
          let value = fields.get_or_default(name, Null)
          let mut replaced = false
          for attr in attrs {
            if attr.name == name {
              attr.value = Val(Lit(value))
              replaced = true
              break
            }
          }
          if !replaced {
            attrs.push({ name, value: Val(Lit(value)), })
          }
        }
      Absent(name) => raise Undefined(name~)
      _ => raise Wrong(because="&attributes takes a mapping")
    }
  }
  if elem.key is Some(key_expr) {
    attrs.push({ name: "data-key", value: Val(Lit(eval(env, key_expr))), })
  }
  if !classes.is_empty() {
    let joined = join_texts(classes, " ")
    out.write_string(" class=\"\{escape_text(joined)}\"")
  }
  for attr in attrs {
    match attr.value {
      Bare => out.write_string(" \{attr.name}")
      Val(expr) => {
        // Pug's boolean attributes: true is bare, false is absent. A bare
        // identifier that resolves nowhere reads as the word itself, which
        // is how the surface writes `target=_blank`.
        let value = eval(env, expr) catch {
          Undefined(_) =>
            match expr {
              Name(word) => Text(word)
              _ => raise Undefined(name=attr.name)
            }
          fault => raise fault
        }
        match value {
          Bool(true) => out.write_string(" \{attr.name}")
          Bool(false) => ()
          other =>
            out.write_string(
              " \{attr.name}=\"\{escape_text(show_value(other))}\"",
            )
        }
      }
    }
  }
  if elem.self_close {
    out.write_string("/>")
    return
  }
  if is_void_element(elem.tag) {
    out.write_string(">")
    return
  }
  out.write_string(">")
  run_element_body(env, elem, true)
}

///|
fn run_element_body(env : Env, elem : Elem, closing : Bool) -> Unit raise Fault {
  for node in elem.inline {
    run_node(env, node)
  }
  match elem.out {
    Some(expr) => {
      let value = eval(env, expr)
      if elem.out_raw {
        env.emit_raw(value)
      } else {
        env.out.write_string(escape_text(show_value(value)))
      }
    }
    None => ()
  }
  for node in elem.children {
    run_node(env, node)
  }
  if closing {
    env.out.write_string("</\{elem.tag}>")
  }
}
