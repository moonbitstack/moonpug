///|
/// A block definition and the template it came from.
priv struct Frame {
  block : @syntax.Block
  template : String
}

///|
/// One render in flight: the output, the scopes, the block definitions the
/// inheritance chain filed, and where in which template it stands.
priv struct Run {
  env : Env
  mut call : @spec.Call
  mut out : StringBuilder
  mut written : Int32
  mut scopes : Array[Map[String, @spec.Value]]
  mut template : String
  mut line : Int32
  mut terse : Bool
  mut xml : Bool
  depth : Ref[Int32]
  once : Map[String, String]
  mut blocks : Map[String, Array[Frame]]
  mut braking : Bool
  mut skipping : Bool
  mut extended : Bool
  mut parents : Array[Template]
}

///|
fn Run::new(
  env : Env,
  template : String,
  autoescape : Bool,
  context : Map[String, @spec.Value],
) -> Run {
  {
    env,
    call: env.call(autoescape),
    out: StringBuilder(),
    written: 0,
    scopes: [context],
    template,
    line: 1,
    terse: false,
    xml: false,
    depth: Ref(0),
    once: Map([]),
    blocks: Map([]),
    braking: false,
    skipping: false,
    extended: false,
    parents: [],
  }
}

///|
fn Run::autoescape(self : Run) -> Bool {
  self.call.autoescape
}

///|
fn Run::set_autoescape(self : Run, on : Bool) -> Unit {
  self.call = self.call.escaping(on)
}

///|
/// The value a name has here: innermost scope first, then the globals,
/// else undefined.
fn Run::lookup(self : Run, name : String) -> @spec.Value {
  for i = self.scopes.length() - 1; i >= 0; i = i - 1 {
    match self.scopes[i].get(name) {
      Some(v) => return v
      None => ()
    }
  }
  match self.env.globals.get(name) {
    Some(v) => v
    None => Undefined(name)
  }
}

///|
fn Run::bind(self : Run, name : String, value : @spec.Value) -> Unit {
  self.scopes[self.scopes.length() - 1][name] = value
}

///|
fn Run::push(self : Run, scope : Map[String, @spec.Value]) -> Unit {
  self.scopes.push(scope)
}

///|
fn Run::pop(self : Run) -> Unit {
  ignore(self.scopes.pop())
}

///|
/// Run `body` inside a new scope.
fn Run::scoped(
  self : Run,
  scope : Map[String, @spec.Value],
  body : () -> Unit raise @spec.Refused,
) -> Unit raise @spec.Refused {
  self.push(scope)
  defer self.pop()
  body()
}

///|
/// Every name visible here, innermost winning.
fn Run::visible(self : Run) -> Map[String, @spec.Value] {
  let flat = Map([])
  for scope in self.scopes {
    for k, v in scope {
      flat[k] = v
    }
  }
  flat
}

///|
/// Run `body` with output going to a fresh buffer, and return what it wrote.
/// Each buffer counts what is written into it on its own, so text carried
/// from one buffer to another is counted where it lands, not twice.
fn Run::capture(
  self : Run,
  body : () -> Unit raise @spec.Refused,
) -> String raise @spec.Refused {
  let outer = self.out
  let written = self.written
  let extended = self.extended
  self.out = StringBuilder()
  self.written = 0
  self.extended = false
  defer {
    self.out = outer
    self.written = written
    self.extended = extended
  }
  body()
  self.out.to_string()
}

///|
/// Count one more level of nesting, refused past the bound.
fn Run::enter(self : Run) -> Unit raise @spec.Refused {
  self.depth.val += 1
  let limit = self.env.settings.limits.depth
  if self.depth.val > limit {
    let got = self.depth.val
    self.depth.val -= 1
    raise Exceeded(template="", line=0, limit~, got~)
  }
}

///|
fn Run::leave(self : Run) -> Unit {
  self.depth.val -= 1
}

///|
/// Write output, refused past what one render may write. The count is of
/// code units, which is a character for everything in the basic plane.
fn Run::write(self : Run, text : String) -> Unit raise @spec.Refused {
  self.written += text.length()
  let limit = self.env.settings.limits.write
  if self.written > limit {
    raise Exceeded(
      template=self.template,
      line=self.line,
      limit~,
      got=self.written,
    )
  }
  self.out.write_string(text)
}

///|
/// Write a value as output: escaped when escaping is on and it is not
/// already safe.
fn Run::emit(self : Run, value : @spec.Value) -> Unit raise @spec.Refused {
  match value {
    Markup(s) => self.write(s)
    _ => {
      let text = self.call.text(value)
      self.write(if self.autoescape() { @spec.escape(text) } else { text })
    }
  }
}

///|
/// Text built from rendered output: safe when escaping is on.
fn Run::rendered(self : Run, text : String) -> @spec.Value {
  if self.autoescape() {
    Markup(text)
  } else {
    Text(text)
  }
}
