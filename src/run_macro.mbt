///|
/// A macro, a mixin, or the caller of a call block: its parameters, body,
/// and the scopes its names resolve in.
priv struct Macro {
  run : Run
  name : String
  params : Array[@syntax.Param]
  body : Array[@syntax.Node]
  home : Array[Map[String, @spec.Value]]
  template : String
  pug : Bool
  caller : Bool?
  varargs : Bool
  kwargs : Bool
}

///|
impl @spec.Object for Macro with fn kind(self) {
  "the macro \{self.name}"
}

///|
impl @spec.Object for Macro with fn attr(self, name) {
  match name {
    "name" => Some(Text(self.name))
    "arguments" =>
      Some(
        Tuple(
          self.params.filter(p => !p.rest).map(p => @spec.Value::Text(p.name)),
        ),
      )
    "catch_varargs" => Some(Bool(self.varargs))
    "catch_kwargs" => Some(Bool(self.kwargs))
    "caller" => Some(Bool(self.caller.unwrap_or(false)))
    _ => None
  }
}

///|
impl @spec.Object for Macro with fn callable(_) {
  true
}

///|
impl @spec.Object for Macro with fn show(self) {
  "<Macro \{@spec.repr_text(self.name)}>"
}

///|
impl @spec.Object for Macro with fn call(self, _, args, named) {
  self.run.invoke_macro(self, args, named)
}

///|
/// Whether a name is read anywhere in the nodes; macros take `varargs`,
/// `kwargs` and `caller` only when their body reads them.
fn reads(nodes : Array[@syntax.Node], name : String) -> Bool {
  let found = Ref(false)
  fn expr(e : @syntax.Expr) -> Unit {
    if found.val {
      return
    }
    match e {
      Name(n) => if n == name { found.val = true }
      Lit(_) => ()
      List(xs) | Tuple(xs) | Concat(xs) => xs.each(expr)
      Dict(ps) =>
        ps.each(p => {
          expr(p.0)
          expr(p.1)
        })
      Attr(t, _) | Not(t) | Neg(t) | Pos(t) => expr(t)
      Item(t, k) => {
        expr(t)
        expr(k)
      }
      Slice(a, b, c) => [a, b, c].each(o => if o is Some(x) { expr(x) })
      Call(t, args) | Test(t, _, args) => {
        expr(t)
        args.each(a => {
          match a {
            Pos(e) | Named(_, e) | Spread(e) | SpreadNamed(e) => expr(e)
          }
        })
      }
      Filter(t, _, args) => {
        if t is Some(x) {
          expr(x)
        }
        args.each(a => {
          match a {
            Pos(e) | Named(_, e) | Spread(e) | SpreadNamed(e) => expr(e)
          }
        })
      }
      Binary(_, l, r) => {
        expr(l)
        expr(r)
      }
      Compare(f, ops) => {
        expr(f)
        ops.each(p => expr(p.1))
      }
      Cond(a, b, c) => {
        expr(a)
        expr(b)
        if c is Some(x) {
          expr(x)
        }
      }
      Attributes(attrs, splats) => {
        attrs.each(a => if a.value is Some(x) { expr(x) })
        splats.each(expr)
      }
    }
  }
  fn walk(ns : Array[@syntax.Node]) -> Unit {
    for n in ns {
      if found.val {
        return
      }
      match n {
        Out(e) | Raw(e) | Extends(e) | Do(e) => expr(e)
        For(iter~, cond~, body~, otherwise~, ..) => {
          expr(iter)
          if cond is Some(c) {
            expr(c)
          }
          walk(body)
          walk(otherwise)
        }
        If(bs, o) => {
          bs.each(b => {
            expr(b.0)
            walk(b.1)
          })
          walk(o)
        }
        Set(_, e) => expr(e)
        SetBlock(_, f, b) => {
          if f is Some(x) {
            expr(x)
          }
          walk(b)
        }
        CallBlock(_, c, b) => {
          expr(c)
          walk(b)
        }
        FilterBlock(c, b) => {
          expr(c)
          walk(b)
        }
        BlockDef(b) => walk(b.body)
        Include(e, block~, ..) => {
          expr(e)
          walk(block)
        }
        Import(e, _, ..) | FromImport(e, _, ..) => expr(e)
        With(ps, b) => {
          ps.each(p => expr(p.1))
          walk(b)
        }
        Autoescape(e, b) | Show(e, b) => {
          expr(e)
          walk(b)
        }
        Once(k, b) => {
          if k is Some(x) {
            expr(x)
          }
          walk(b)
        }
        TransOut(t) => t.vars.each(v => expr(v.1))
        Element(el) => {
          expr(el.tag)
          el.attrs.each(a => if a.value is Some(x) { expr(x) })
          el.splats.each(expr)
          walk(el.body)
        }
        Comment(b) => walk(b)
        Case(s, arms, o) => {
          expr(s)
          arms.each(a => {
            a.0.each(expr)
            walk(a.1)
          })
          walk(o)
        }
        MacroDef(_)
        | Line(_)
        | Text(_)
        | Debug
        | Break
        | Continue
        | Doctype(_)
        | Yield => ()
      }
    }
  }
  walk(nodes)
  found.val
}

///|
fn Run::make_macro(self : Run, m : @syntax.Macro) -> @spec.Value {
  Object(Macro::{
    run: self,
    name: m.name,
    params: m.params,
    body: m.body,
    home: self.scopes.copy(),
    template: self.template,
    pug: m.pug,
    caller: Some(reads(m.body, "caller")),
    varargs: reads(m.body, "varargs"),
    kwargs: reads(m.body, "kwargs"),
  })
}

///|
/// Call a macro: parameters from the positional arguments, then by name,
/// then their defaults; a parameter given none of these is undefined.
fn Run::invoke_macro(
  self : Run,
  m : Macro,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  self.enter()
  defer self.leave()
  let scope : Map[String, @spec.Value] = Map([])
  let rest_named = named.copy()
  let takes_caller = m.caller.unwrap_or(false)
  let caller = rest_named.get("caller")
  if takes_caller || m.pug {
    rest_named.remove("caller")
  }
  let attributes = if m.pug { rest_named.get("attributes") } else { None }
  if m.pug {
    rest_named.remove("attributes")
  }
  let saved_scopes = self.scopes
  let saved_template = self.template
  self.scopes = [..m.home, scope]
  self.template = m.template
  defer {
    self.scopes = saved_scopes
    self.template = saved_template
  }
  let mut used = 0
  for i, p in m.params {
    if p.rest {
      scope[p.name] = Seq(
        if used < args.length() {
          args[used:].to_owned()
        } else {
          []
        },
      )
      used = args.length()
      continue
    }
    if i < args.length() {
      if rest_named.contains(p.name) {
        raise @spec.invalid(
          "macro \{@spec.repr_text(m.name)} got multiple values for argument \{@spec.repr_text(p.name)}",
        )
      }
      scope[p.name] = args[i]
      used = i + 1
    } else if rest_named.contains(p.name) {
      scope[p.name] = rest_named.get(p.name).unwrap()
      rest_named.remove(p.name)
    } else {
      scope[p.name] = match p.default {
        Some(e) => self.eval(e)
        None => Undefined(p.name)
      }
    }
  }
  for p in m.params {
    rest_named.remove(p.name)
  }
  if used < args.length() {
    if m.varargs {
      scope["varargs"] = Tuple(args[used:].to_owned())
    } else {
      raise @spec.invalid(
        "macro \{@spec.repr_text(m.name)} takes not more than \{m.params.length()} argument(s)",
      )
    }
  } else if m.varargs {
    scope["varargs"] = Tuple([])
  }
  if !rest_named.is_empty() {
    if m.kwargs {
      scope["kwargs"] = Dict(rest_named)
    } else {
      let first = rest_named.keys().collect()[0]
      raise @spec.invalid(
        "macro \{@spec.repr_text(m.name)} takes no keyword argument \{@spec.repr_text(first)}",
      )
    }
  } else if m.kwargs {
    scope["kwargs"] = Dict(Map([]))
  }
  if takes_caller {
    scope["caller"] = caller.unwrap_or(Undefined("caller"))
  }
  if m.pug {
    scope["attributes"] = attributes.unwrap_or(Dict(Map([])))
    scope["block"] = caller.unwrap_or(Bool(false))
  }
  let text = self.capture(() => self.run_nodes(m.body))
  self.rendered(text)
}
