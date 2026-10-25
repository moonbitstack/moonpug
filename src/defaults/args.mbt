///|
/// A call's arguments bound the way Python binds them to a signature:
/// positional first, then by name, each name at most once.
priv struct Bound {
  who : String
  values : Map[String, @spec.Value]
}

///|
/// Bind `args` and `named` to `params`; extra positional arguments and
/// unknown names are refused.
fn bind(
  who : String,
  params : Array[String],
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> Bound raise @spec.Refused {
  let values = Map([])
  for i, arg in args {
    if i >= params.length() {
      raise @spec.invalid(
        "\{who} takes at most \{params.length()} positional arguments, \{args.length()} given",
      )
    }
    values[params[i]] = arg
  }
  for name, value in named {
    if !params.contains(name) {
      raise @spec.invalid("\{who} got an unexpected argument \{name}")
    }
    if values.contains(name) {
      raise @spec.invalid("\{who} got two values for \{name}")
    }
    values[name] = value
  }
  { who, values, }
}

///|
fn Bound::get(self : Bound, name : String) -> @spec.Value? {
  self.values.get(name)
}

///|
fn Bound::need(self : Bound, name : String) -> @spec.Value raise @spec.Refused {
  match self.values.get(name) {
    Some(v) => v
    None => raise @spec.invalid("\{self.who} is missing the argument \{name}")
  }
}

///|
/// An integer argument; a bool counts as 0 or 1, a float is truncated, as
/// Python's `int()` coercion of an `int` parameter would not but Jinja's
/// filters receive what templates write.
fn Bound::int(
  self : Bound,
  name : String,
  default : Int32,
) -> Int32 raise @spec.Refused {
  match self.values.get(name) {
    None | Some(Null) => default
    Some(v) =>
      match v {
        Int(n) => n.to_int()
        Bool(b) => if b { 1 } else { 0 }
        Double(d) => d.to_int()
        _ =>
          raise @spec.invalid(
            "\{self.who} wants an integer for \{name}, not \{v.kind()}",
          )
      }
  }
}

///|
fn Bound::flag(self : Bound, name : String, default : Bool) -> Bool {
  match self.values.get(name) {
    Some(v) => v.truthy()
    None => default
  }
}

///|
fn Bound::text(
  self : Bound,
  call : @spec.Call,
  name : String,
  default : String,
) -> String raise @spec.Refused {
  match self.values.get(name) {
    Some(v) => call.text(v)
    None => default
  }
}

///|
/// A number as Python's `float()` reads it: numbers and bools directly,
/// strings in Python's spelling.
fn to_float(value : @spec.Value) -> Double? {
  match value {
    Int(n) => Some(n.to_double())
    Double(d) => Some(d)
    Bool(b) => Some(if b { 1.0 } else { 0.0 })
    Text(s) | Markup(s) => parse_float(s)
    _ => None
  }
}

///|
/// Python's `float(str)`: surrounding whitespace, a sign, digits with `_`
/// between them, `inf`, `infinity` and `nan` in any case.
fn parse_float(text : String) -> Double? {
  let s = py_strip(text, None)
  let lower = s.to_lower()
  let (sign, body) = if lower.has_prefix("-") {
    (-1.0, lower[1:].to_owned())
  } else if lower.has_prefix("+") {
    (1.0, lower[1:].to_owned())
  } else {
    (1.0, lower)
  }
  match body {
    "inf" | "infinity" => return Some(sign * @double.infinity)
    "nan" => return Some(@double.not_a_number)
    _ => ()
  }
  if body.is_empty() || !valid_underscores(body) {
    return None
  }
  let digits = body.replace_all(old="_", new="")
  if digits
    .iter()
    .any(ch => !(ch.is_ascii_digit() || ch is ('.' | 'e' | '+' | '-'))) {
    return None
  }
  Some(sign * (@string.parse_double(digits) catch { _ => return None }))
}

///|
/// Underscores only between digits, as Python allows them.
fn valid_underscores(s : String) -> Bool {
  let chars = s.iter().collect()
  for i, ch in chars {
    if ch == '_' &&
      (
        i == 0 ||
        i == chars.length() - 1 ||
        !chars[i - 1].is_ascii_digit() ||
        !chars[i + 1].is_ascii_digit()
      ) {
      return false
    }
  }
  true
}

///|
/// Python's `int(str, base)`: whitespace, a sign, digits of the base with
/// `_` between them; base 0 reads the prefix, and a `0x`-style prefix
/// matching the base is allowed.
fn parse_int(text : String, base : Int32) -> Int64? raise @spec.Refused {
  let s = py_strip(text, None).to_lower()
  let (negative, body) = if s.has_prefix("-") {
    (true, s[1:].to_owned())
  } else if s.has_prefix("+") {
    (false, s[1:].to_owned())
  } else {
    (false, s)
  }
  let (radix, digits) = match (base, body) {
    (0 | 16, b) if b.has_prefix("0x") => (16, b[2:].to_owned())
    (0 | 8, b) if b.has_prefix("0o") => (8, b[2:].to_owned())
    (0 | 2, b) if b.has_prefix("0b") => (2, b[2:].to_owned())
    (0, b) => {
      if b.length() > 1 &&
        b.has_prefix("0") &&
        b.iter().any(ch => ch != '0' && ch != '_') {
        return None
      }
      (10, b)
    }
    (r, b) => (r, b)
  }
  if radix < 2 ||
    radix > 36 ||
    digits.is_empty() ||
    !valid_underscores_any(digits) {
    return None
  }
  let mut value = 0L
  for ch in digits {
    if ch == '_' {
      continue
    }
    let d = if ch.is_ascii_digit() {
      ch.to_int() - '0'.to_int()
    } else if ch >= 'a' && ch <= 'z' {
      ch.to_int() - 'a'.to_int() + 10
    } else {
      return None
    }
    if d >= radix {
      return None
    }
    let floor = (int64_min + d.to_int64()) / radix.to_int64()
    if value < floor {
      raise too_wide(text)
    }
    value = value * radix.to_int64() - d.to_int64()
  }
  if negative {
    Some(value)
  } else if value == int64_min {
    raise too_wide(text)
  } else {
    Some(-value)
  }
}

///|
let int64_min : Int64 = -9223372036854775807L - 1L

///|
/// Integers are 64 bits wide; a wider one is refused rather than wrapped.
fn too_wide(text : String) -> @spec.Refused {
  @spec.invalid("\{text.trim()} does not fit in a 64-bit integer")
}

///|
fn truncate_int(d : Double) -> Int64 raise @spec.Refused {
  if d.abs() >= 9.223372036854775808e18 {
    raise too_wide(d.to_string())
  }
  d.to_int64()
}

///|
fn valid_underscores_any(s : String) -> Bool {
  !s.has_prefix("_") && !s.has_suffix("_") && !s.contains("__")
}

///|
/// The character `%c` and `{:c}` write for an integer. Python also allows a
/// lone surrogate, which no `Char` can hold, so that is refused here.
fn code_point(n : Int64) -> Char raise @spec.Refused {
  if n < 0L || n > 0x10FFFFL {
    raise @spec.invalid("%c arg not in range(0x110000)")
  }
  if n >= 0xD800L && n <= 0xDFFFL {
    raise @spec.invalid("a lone surrogate \{n} cannot be written")
  }
  n.to_int().unsafe_to_char()
}
