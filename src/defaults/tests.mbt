///|
/// The tests every template sees, under the names Jinja gives them.
pub fn tests() -> Map[String, @spec.Test] {
  let compare = fn(op : (Int32) -> Bool) -> @spec.Test {
    fn(_call, value, args) raise @spec.Refused {
      op(value.compare(arg(args, 0, "compare")))
    }
  }
  let eq : @spec.Test = fn(_call, value, args) raise @spec.Refused {
    value == arg(args, 0, "eq")
  }
  let ne : @spec.Test = fn(_call, value, args) raise @spec.Refused {
    value != arg(args, 0, "ne")
  }
  let gt = compare(o => o > 0)
  let ge = compare(o => o >= 0)
  let lt = compare(o => o < 0)
  let le = compare(o => o <= 0)
  Map([
    ("odd", test_odd),
    ("even", test_even),
    ("divisibleby", test_divisibleby),
    ("defined", (_, v, _) => !(v is Undefined(_))),
    ("undefined", (_, v, _) => v is Undefined(_)),
    ("filter", (c, v, a) => test_filter(c, v, a)),
    ("test", (c, v, a) => test_test(c, v, a)),
    ("none", (_, v, _) => v is Null),
    ("boolean", (_, v, _) => v is Bool(_)),
    ("false", (_, v, _) => v is Bool(false)),
    ("true", (_, v, _) => v is Bool(true)),
    ("integer", (_, v, _) => v is Int(_)),
    ("float", (_, v, _) => v is Double(_)),
    ("lower", test_lower),
    ("upper", test_upper),
    ("string", (_, v, _) => v is (Text(_) | Markup(_))),
    ("mapping", (_, v, _) => v is Dict(_)),
    ("number", (_, v, _) => v is (Int(_) | Double(_) | Bool(_))),
    ("sequence", (c, v, a) => test_sequence(c, v, a)),
    ("iterable", test_iterable),
    ("callable", (_, v, _) => v is Object(obj) && obj.callable()),
    ("sameas", test_sameas),
    ("escaped", (_, v, _) => v is Markup(_)),
    ("in", test_in),
    ("==", eq),
    ("eq", eq),
    ("equalto", eq),
    ("!=", ne),
    ("ne", ne),
    (">", gt),
    ("gt", gt),
    ("greaterthan", gt),
    (">=", ge),
    ("ge", ge),
    ("<", lt),
    ("lt", lt),
    ("lessthan", lt),
    ("<=", le),
    ("le", le),
  ])
}

///|
fn arg(
  args : Array[@spec.Value],
  i : Int32,
  who : String,
) -> @spec.Value raise @spec.Refused {
  if i < args.length() {
    args[i]
  } else {
    raise @spec.invalid("the \{who} test is missing an argument")
  }
}

///|
/// Python's `value % n` for the numbers a test meets.
fn modulo(
  value : @spec.Value,
  n : @spec.Value,
  who : String,
) -> Double raise @spec.Refused {
  match (value.number(), n.number()) {
    (Some(a), Some(b)) => {
      if b == 0.0 {
        raise @spec.invalid("\{who}: integer division or modulo by zero")
      }
      let m = a - b * (a / b).floor()
      m
    }
    _ =>
      raise @spec.invalid(
        "\{who} wants numbers, not \{value.kind()} and \{n.kind()}",
      )
  }
}

///|
fn test_odd(
  _call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
) -> Bool raise @spec.Refused {
  ignore(args)
  modulo(value, Int(2), "odd") == 1.0
}

///|
fn test_even(
  _call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
) -> Bool raise @spec.Refused {
  ignore(args)
  modulo(value, Int(2), "even") == 0.0
}

///|
fn test_divisibleby(
  _call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
) -> Bool raise @spec.Refused {
  modulo(value, arg(args, 0, "divisibleby"), "divisibleby") == 0.0
}

///|
fn test_filter(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
) -> Bool {
  ignore(args)
  value is (Text(name) | Markup(name)) && call.has_filter(name)
}

///|
fn test_test(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
) -> Bool {
  ignore(args)
  value is (Text(name) | Markup(name)) && call.has_test(name)
}

///|
fn test_lower(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
) -> Bool raise @spec.Refused {
  ignore(args)
  py_islower(call.text(value))
}

///|
fn test_upper(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
) -> Bool raise @spec.Refused {
  ignore(args)
  py_isupper(call.text(value))
}

///|
fn test_sequence(
  _call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
) -> Bool {
  ignore(args)
  match value {
    Text(_) | Markup(_) | Seq(_) | Tuple(_) | Dict(_) => true
    Object(obj) => obj.items() is Some(_)
    _ => false
  }
}

///|
fn test_iterable(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
) -> Bool raise @spec.Refused {
  ignore(args)
  match value {
    Text(_) | Markup(_) | Seq(_) | Tuple(_) | Dict(_) => true
    Undefined(name) =>
      if call.refuses(name) {
        raise @spec.unknown("name", name)
      } else {
        true
      }
    Object(obj) => obj.items() is Some(_)
    _ => false
  }
}

///|
/// Python's `is`: the same object. `None` and the booleans are singletons;
/// lists, mappings and objects compare by identity; numbers and strings,
/// which carry no identity here, by value.
fn test_sameas(
  _call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
) -> Bool raise @spec.Refused {
  let other = arg(args, 0, "sameas")
  match (value, other) {
    (Seq(a), Seq(b)) | (Tuple(a), Tuple(b)) => physical_equal(a, b)
    (Dict(a), Dict(b)) => physical_equal(a, b)
    (Object(a), Object(b)) => physical_equal(a, b)
    (Null, Null) => true
    (Bool(a), Bool(b)) => a == b
    (Int(a), Int(b)) => a == b
    (Double(a), Double(b)) => a == b
    (Text(a), Text(b)) | (Markup(a), Markup(b)) => a == b
    _ => false
  }
}

///|
fn test_in(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
) -> Bool raise @spec.Refused {
  let container = arg(args, 0, "in")
  match container {
    Undefined(name) =>
      if call.refuses(name) {
        raise @spec.unknown("name", name)
      } else {
        false
      }
    _ => container.contains(value)
  }
}
