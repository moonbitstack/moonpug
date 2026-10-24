// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Evaluation for tests: a fault counts as undefined rather than fatal, the
/// way `x.y is defined` must behave when `x` itself is nothing.

///|
/// A builtin test: dispatch by name into the engine's own table.
priv struct BuiltinTest {
  name : String
}

///|
impl Test for BuiltinTest with fn probe(
  self : BuiltinTest,
  input : Value,
  pos : Array[Value],
) -> Bool raise Fault {
  builtin_test(self.name, input, pos)
}

///|
/// The value-level builtin tests. `defined` and `undefined` live in the
/// evaluator: they read expressions, not values.
fn builtin_test(
  name : String,
  input : Value,
  pos : Array[Value],
) -> Bool raise Fault {
  match name {
    "boolean" => input is Bool(_)
    "callable" =>
      input is Native(_, _) ||
      input is NativeKw(_, _) ||
      input is GlobalV(_) ||
      input is MacroV(_)
    "divisibleby" => {
      let by = match pos[0] {
        Int(n) => n
        Double(d) => @double.trunc(d).to_int64()
        _ => raise Wrong(because="divisibleby wants a number")
      }
      if by == 0L {
        raise Wrong(because="divisibleby cannot divide by zero")
      }
      match input {
        Int(n) => n % by == 0L
        Double(d) => @double.trunc(d).to_int64() % by == 0L
        _ => false
      }
    }
    "eq" | "equalto" | "==" => same_value(input, arg_or(pos, 0))
    "ne" | "!=" => !same_value(input, arg_or(pos, 0))
    "gt" | "greaterthan" | ">" => compare_value(input, arg_or(pos, 0)) > 0
    "ge" | ">=" => compare_value(input, arg_or(pos, 0)) >= 0
    "lt" | "lessthan" | "<" => compare_value(input, arg_or(pos, 0)) < 0
    "le" | "<=" => compare_value(input, arg_or(pos, 0)) <= 0
    "escaped" => input is Markup(_)
    "even" =>
      match input {
        Int(n) => n % 2L == 0L
        Double(d) => @double.trunc(d).to_int64() % 2L == 0L
        other =>
          raise Wrong(because="even wants a number, not \{kind_of(other)}")
      }
    "odd" =>
      match input {
        Int(n) => n % 2L != 0L
        Double(d) => @double.trunc(d).to_int64() % 2L != 0L
        other =>
          raise Wrong(because="odd wants a number, not \{kind_of(other)}")
      }
    "false" => input is Bool(false)
    "true" => input is Bool(true)
    // Filter and test objects are not template values in this engine,
    // so no value satisfies these; the registry holds them.
    "filter" | "test" => false
    "float" => input is Double(_)
    "integer" => input is Int(_)
    "number" => input is Int(_) || input is Double(_) || input is Bool(_)
    "in" => contains_value(arg_or(pos, 0), input)
    "iterable" =>
      input is Seq(_) ||
      input is Text(_) ||
      input is Markup(_) ||
      input is Dict(_) ||
      input is Value::Namespaced(_)
    "mapping" => input is Dict(_) || input is Value::Namespaced(_)
    "sequence" => input is Seq(_) || input is Text(_) || input is Markup(_)
    "string" => input is Text(_) || input is Markup(_)
    "lower" =>
      match input {
        Text(s) | Markup(s) => s == s.to_lower()
        _ => false
      }
    "upper" =>
      match input {
        Text(s) | Markup(s) => s == s.to_upper()
        _ => false
      }
    "none" => input is Null
    "sameas" =>
      match (input, arg_or(pos, 0)) {
        (Null, Null) => true
        (Bool(a), Bool(b)) => a == b
        (Int(a), Int(b)) => a == b
        _ => false
      }
    other => raise Unknown(name=other, kind="test")
  }
}

///|
fn arg_or(pos : Array[Value], i : Int32) -> Value {
  if i < pos.length() {
    pos[i]
  } else {
    Null
  }
}

///|
/// The 30 Jinja tests, registered through the same trait a caller uses.
fn builtin_tests() -> Map[String, &Test] {
  let table : Map[String, &Test] = Map([])
  for
    name in [
      "boolean", "callable", "divisibleby", "eq", "equalto", "ne", "gt", "greaterthan",
      "ge", "lt", "lessthan", "le", "escaped", "even", "odd", "false", "true", "filter",
      "test", "float", "integer", "number", "in", "iterable", "mapping", "sequence",
      "string", "lower", "upper", "none", "sameas",
    ] {
    let entry : BuiltinTest = { name, }
    table.set(name, entry)
  }
  table
}
