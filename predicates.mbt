// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One test applied. `defined` and `undefined` receive the expression
/// un-evaluated: asking whether a name resolves must not resolve it.
fn apply_test(
  env : Env,
  name : String,
  target : Expr,
  args : Array[Arg],
) -> Bool raise Fault {
  match name {
    "defined" => !is_absent(env, target)
    "undefined" => is_absent(env, target)
    "boolean" => eval_plain(env, target) is Bool(_)
    "callable" =>
      eval_plain(env, target) is Native(_, _) ||
      eval_plain(env, target) is MacroV(_)
    "divisibleby" => {
      let value = eval_plain(env, target)
      let by = match eval_args(env, args) {
        (pos, _) =>
          match pos[0] {
            Int(n) => n
            Double(d) => @double.trunc(d).to_int64()
            _ => raise Wrong(because="divisibleby wants a number")
          }
      }
      if by == 0L {
        raise Wrong(because="divisibleby cannot divide by zero")
      }
      match value {
        Int(n) => n % by == 0L
        Double(d) => @double.trunc(d).to_int64() % by == 0L
        _ => false
      }
    }
    "eq" | "equalto" | "==" =>
      same_value(eval_plain(env, target), test_arg(env, args, 0, name))
    "ne" | "!=" =>
      !same_value(eval_plain(env, target), test_arg(env, args, 0, name))
    "gt" | "greaterthan" | ">" =>
      compare_value(eval_plain(env, target), test_arg(env, args, 0, name)) > 0
    "ge" | ">=" =>
      compare_value(eval_plain(env, target), test_arg(env, args, 0, name)) >= 0
    "lt" | "lessthan" | "<" =>
      compare_value(eval_plain(env, target), test_arg(env, args, 0, name)) < 0
    "le" | "<=" =>
      compare_value(eval_plain(env, target), test_arg(env, args, 0, name)) <= 0
    "escaped" => eval_plain(env, target) is Markup(_)
    "even" => {
      let n = test_number(env, target, name)
      @double.trunc(n) % 2.0 == 0.0
    }
    "odd" => {
      let n = test_number(env, target, name)
      @double.trunc(n) % 2.0 != 0.0
    }
    "false" => eval_plain(env, target) is Bool(false)
    "true" => eval_plain(env, target) is Bool(true)
    "filter" | "test" => eval_plain(env, target) is Native(_, _)
    "float" => eval_plain(env, target) is Double(_)
    "integer" => eval_plain(env, target) is Int(_)
    "number" => {
      let value = eval_plain(env, target)
      value is Int(_) || value is Double(_) || value is Bool(_)
    }
    "in" => {
      let (pos, _) = eval_args(env, args)
      if pos.length() != 1 {
        raise Wrong(because="in wants one container")
      }
      contains_value(pos[0], eval_plain(env, target))
    }
    "iterable" => {
      let value = eval_plain(env, target)
      value is Seq(_) ||
      value is Text(_) ||
      value is Markup(_) ||
      value is Dict(_) ||
      value is Namespaced(_)
    }
    "mapping" => {
      let value = eval_plain(env, target)
      value is Dict(_) || value is Namespaced(_)
    }
    "sequence" => {
      let value = eval_plain(env, target)
      value is Seq(_) || value is Text(_) || value is Markup(_)
    }
    "string" => {
      let value = eval_plain(env, target)
      value is Text(_) || value is Markup(_)
    }
    "lower" => {
      let value = eval_plain(env, target)
      match value {
        Text(s) | Markup(s) => s == s.to_lower()
        _ => false
      }
    }
    "upper" => {
      let value = eval_plain(env, target)
      match value {
        Text(s) | Markup(s) => s == s.to_upper()
        _ => false
      }
    }
    "none" => eval_plain(env, target) is Null
    "sameas" => {
      let value = eval_plain(env, target)
      let other = test_arg(env, args, 0, name)
      match (value, other) {
        (Null, Null) => true
        (Bool(a), Bool(b)) => a == b
        (Int(a), Int(b)) => a == b
        _ => false
      }
    }
    _ => raise Unknown(name~, kind="test")
  }
}

///|
fn test_arg(
  env : Env,
  args : Array[Arg],
  i : Int32,
  name : String,
) -> Value raise Fault {
  let (pos, _) = eval_args(env, args)
  if i < pos.length() {
    pos[i]
  } else {
    raise Wrong(because="the \{name} test wants an argument")
  }
}

///|
fn test_number(env : Env, target : Expr, name : String) -> Double raise Fault {
  match eval_plain(env, target) {
    Int(n) => n.to_double()
    Double(d) => d
    other =>
      raise Wrong(because="\{name} wants a number, not \{kind_of(other)}")
  }
}

///|
/// Evaluation for tests: a fault counts as undefined rather than fatal, the
/// way `x.y is defined` must behave when `x` itself is nothing.
fn eval_plain(env : Env, expr : Expr) -> Value {
  eval(env, expr) catch {
    _ => Absent("undefined")
  }
}

///|
fn is_absent(env : Env, expr : Expr) -> Bool {
  match expr {
    Name(name) => env.find(name) is None && env.natives.get(name) is None
    Attr(inner, field) => {
      if is_absent(env, inner) {
        return true
      }
      match eval_plain(env, inner) {
        Dict(fields) =>
          match fields.get(field) {
            Some(value) => value is Absent(_)
            None => true
          }
        Namespaced(fields) =>
          match fields.get(field) {
            Some(value) => value is Absent(_)
            None => true
          }
        _ => true
      }
    }
    _ => eval_plain(env, expr) is Absent(_)
  }
}
