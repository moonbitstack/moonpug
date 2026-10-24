// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The parsing choices a surface carries, so a nested read — an included
/// file, a language block — parses the way its surroundings did.
priv struct ReadOpts {
  syntax : Syntax
  force : Bool
  trim_blocks : Bool
  lstrip_blocks : Bool
  keep_trailing_newline : Bool
  line : String?
  shortcuts : Map[String, String]
  sandbox : Bool
}

///|
/// Everything a render walks with: the output buffer, the scope stack, the
/// seams the caller fed, and the block registry the `extends` chain filled.
priv struct Env {
  mut out : StringBuilder
  mut stack : Array[Map[String, Value]]
  mut blocks : Map[String, Array[BlockDef]]
  filters : Map[String, &Filter]
  tests : Map[String, &Test]
  globals : Map[String, &Global]
  once : Map[String, String]
  tally : Tally
  load : ((String) -> String?)?
  translate : ((String, String?, Int32?) -> String?)?
  cache_fn : ((String, () -> String raise Fault) -> String raise Fault)?
  opts : ReadOpts
  policy : UndefinedPolicy
  mut autoescape : Bool
  mut braking : Bool // a `break` is waiting for the innermost loop
  mut skipping : Bool // a `continue` is
}

///|
fn Env::push(env : Env, scope : Map[String, Value]) -> Unit {
  env.stack.push(scope)
}

///|
fn Env::pop(env : Env) -> Unit {
  ignore(env.stack.pop())
}

///|
/// The innermost scope a name is bound in, or none.
fn Env::find(env : Env, name : String) -> Map[String, Value]? {
  let mut i = env.stack.length() - 1
  while i >= 0 {
    let scope = env.stack[i]
    if scope.contains(name) {
      return Some(scope)
    }
    i = i - 1
  }
  None
}

///|
/// A name as a statement sees it: bound, or the undefined value the policy
/// hands back. Strict refuses on the spot; the other two carry the name for
/// the day someone asks `is defined`.
fn Env::get(env : Env, name : String) -> Value raise Fault {
  match env.find(name) {
    Some(scope) => scope.get_or_default(name, Absent(name))
    None =>
      match env.globals.get(name) {
        Some(call) => GlobalV(call)
        None =>
          match env.policy {
            Strict => raise Undefined(name~)
            _ => Absent(name)
          }
      }
  }
}

///|
fn Env::set(env : Env, name : String, value : Value) -> Unit {
  env.stack[env.stack.length() - 1].set(name, value)
}

///|
/// Every name visible right now, flattened innermost-wins. Blocks with
/// `scoped`, `include` with context, and macros capturing their module all
/// read the world through this.
fn Env::flatten(env : Env) -> Map[String, Value] {
  let flat : Map[String, Value] = Map([])
  for scope in env.stack {
    for name, value in scope {
      flat.set(name, value)
    }
  }
  flat
}

///|
/// Render a section into a string of its own: macros, block assignments,
/// `show` and `once` all borrow the buffer this way.
fn Env::capture(env : Env, body : () -> Unit raise Fault) -> String raise Fault {
  let outer = env.out
  env.out = StringBuilder()
  errdefer {
    env.out = outer
  }
  body()
  let taken = env.out.to_string()
  env.out = outer
  taken
}

///|
/// What an output node writes: trusted text as it stands, plain text escaped
/// when autoescaping is on, everything else the way it prints.
fn Env::emit(env : Env, value : Value) -> Unit {
  match value {
    Markup(text) => env.out.write_string(text)
    Text(text) =>
      if env.autoescape {
        env.out.write_string(escape_text(text))
      } else {
        env.out.write_string(text)
      }
    other => {
      let shown = show_value(other)
      if env.autoescape {
        env.out.write_string(escape_text(shown))
      } else {
        env.out.write_string(shown)
      }
    }
  }
}

///|
/// Output that never escapes, the indentation surface's `!=` and `!{…}`.
fn Env::emit_raw(env : Env, value : Value) -> Unit {
  env.out.write_string(show_value(value))
}

///|
/// The undefined value for a name that did not resolve, after the policy has
/// had its say. Attribute and subscript misses land here too.
fn Env::absent(env : Env, name : String) -> Value raise Fault {
  match env.policy {
    Strict => raise Undefined(name~)
    _ => Absent(name)
  }
}

///|
/// The context an extension sees, gathered from the render in flight.
fn context_of(env : Env) -> Context {
  {
    filters: env.filters,
    tests: env.tests,
    translate: env.translate,
    tally: env.tally,
  }
}
