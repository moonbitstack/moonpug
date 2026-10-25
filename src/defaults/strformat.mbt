///|
/// Python's `str.format`: `{}` and `{0}` take positional values in turn or
/// by index, `{name}` named ones; `.attr` and `[key]` reach inside; `!r`,
/// `!s` and `!a` convert; `:spec` formats, with nested `{}` in the spec.
/// `escape` is markup's `format`: each field escaped unless it is markup.
fn str_format(
  call : @spec.Call,
  template : String,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
  escape~ : Bool = false,
) -> String raise @spec.Refused {
  let cs = template.iter().collect()
  let out = StringBuilder()
  let auto = Ref(0)
  let mut i = 0
  while i < cs.length() {
    let ch = cs[i]
    if ch == '{' && i + 1 < cs.length() && cs[i + 1] == '{' {
      out.write_char('{')
      i += 2
      continue
    }
    if ch == '}' && i + 1 < cs.length() && cs[i + 1] == '}' {
      out.write_char('}')
      i += 2
      continue
    }
    if ch == '}' {
      raise @spec.invalid("single '}' encountered in format string")
    }
    if ch != '{' {
      out.write_char(ch)
      i += 1
      continue
    }
    let mut depth = 1
    let start = i + 1
    i += 1
    while i < cs.length() && depth > 0 {
      if cs[i] == '{' {
        depth += 1
      } else if cs[i] == '}' {
        depth -= 1
      }
      i += 1
    }
    if depth > 0 {
      raise @spec.invalid("expected '}' before end of string")
    }
    let field = String::from_array(cs[start:i - 1])
    out.write_string(replacement(call, field, args, named, auto, escape))
  }
  out.to_string()
}

///|
fn replacement(
  call : @spec.Call,
  field : String,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
  auto : Ref[Int32],
  escape : Bool,
) -> String raise @spec.Refused {
  let cs = field.iter().collect()
  let mut i = 0
  let mut bracket = 0
  while i < cs.length() && (bracket > 0 || !(cs[i] is ('!' | ':'))) {
    if cs[i] == '[' {
      bracket += 1
    } else if cs[i] == ']' {
      bracket -= 1
    }
    i += 1
  }
  let name = String::from_array(cs[:i])
  let mut conversion : Char? = None
  if i < cs.length() && cs[i] == '!' {
    if i + 1 >= cs.length() {
      raise @spec.invalid(
        "end of string while looking for conversion specifier",
      )
    }
    conversion = Some(cs[i + 1])
    i += 2
  }
  let spec = if i < cs.length() && cs[i] == ':' {
    str_format(call, String::from_array(cs[i + 1:]), args, named)
  } else if i < cs.length() {
    raise @spec.invalid("expected ':' after conversion specifier")
  } else {
    ""
  }
  let value = field_value(call, name, args, named, auto)
  let converted = match conversion {
    None => value
    Some('s') => Text(call.text(value))
    Some('r') => Text(value.repr())
    Some('a') => Text(ascii_of(value.repr()))
    Some(c) => raise @spec.invalid("unknown conversion specifier \{c}")
  }
  let text = format_value(call, converted, spec)
  if escape && !(converted is Markup(_)) {
    @spec.escape(text)
  } else {
    text
  }
}

///|
fn field_value(
  call : @spec.Call,
  name : String,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
  auto : Ref[Int32],
) -> @spec.Value raise @spec.Refused {
  let cs = name.iter().collect()
  let mut i = 0
  while i < cs.length() && !(cs[i] is ('.' | '[')) {
    i += 1
  }
  let first = String::from_array(cs[:i])
  let mut value = if first.is_empty() {
    if auto.val < 0 {
      raise @spec.invalid(
        "cannot switch from manual field specification to automatic field numbering",
      )
    }
    let k = auto.val
    auto.val += 1
    match args.get(k) {
      Some(v) => v
      None =>
        raise @spec.invalid(
          "replacement index \{k} out of range for positional args tuple",
        )
    }
  } else if first.iter().all(c => c.is_ascii_digit()) {
    if auto.val > 0 {
      raise @spec.invalid(
        "cannot switch from automatic field numbering to manual field specification",
      )
    }
    auto.val = -1
    let k = @string.parse_int(first) catch { _ => -1 }
    match args.get(k) {
      Some(v) => v
      None =>
        raise @spec.invalid(
          "replacement index \{k} out of range for positional args tuple",
        )
    }
  } else {
    match named.get(first) {
      Some(v) => v
      None => raise @spec.unknown("name", first)
    }
  }
  while i < cs.length() {
    if cs[i] == '.' {
      let start = i + 1
      i = start
      while i < cs.length() && !(cs[i] is ('.' | '[')) {
        i += 1
      }
      let name = String::from_array(cs[start:i])
      value = match value.field(name) {
        Some(v) => v
        None =>
          match attr(value, name) {
            Some(m) => m
            None => raise @spec.unknown("attribute", name)
          }
      }
    } else if cs[i] == '[' {
      let start = i + 1
      while i < cs.length() && cs[i] != ']' {
        i += 1
      }
      if i >= cs.length() {
        raise @spec.invalid("missing ']' in format string")
      }
      let key = String::from_array(cs[start:i])
      i += 1
      let k : @spec.Value = if !key.is_empty() &&
        key.iter().all(c => c.is_ascii_digit()) {
        Int(@string.parse_int64(key) catch { _ => 0L })
      } else {
        Text(key)
      }
      value = match value.item(k) {
        Some(v) => v
        None => raise @spec.unknown("name", key)
      }
    } else {
      raise @spec.invalid(
        "only '.' or '[' may follow ']' in format field specifier",
      )
    }
  }
  ignore(call)
  value
}

///|
/// The parts of a format spec: `[[fill]align][sign][z][#][0][width][,_][.precision][type]`.
priv struct Spec {
  fill : Char
  align : Char?
  sign : Char
  coerce : Bool
  alternate : Bool
  width : Int32
  grouping : Char?
  precision : Int32?
  kind : Char?
}

///|
fn parse_spec(text : String) -> Spec raise @spec.Refused {
  let cs = text.iter().collect()
  let mut i = 0
  let mut fill = ' '
  let mut align : Char? = None
  if cs.length() >= 2 && cs[1] is ('<' | '>' | '=' | '^') {
    fill = cs[0]
    align = Some(cs[1])
    i = 2
  } else if cs.length() >= 1 && cs[0] is ('<' | '>' | '=' | '^') {
    align = Some(cs[0])
    i = 1
  }
  let mut sign = '-'
  if i < cs.length() && cs[i] is ('+' | '-' | ' ') {
    sign = cs[i]
    i += 1
  }
  let mut coerce = false
  if i < cs.length() && cs[i] == 'z' {
    coerce = true
    i += 1
  }
  let mut alternate = false
  if i < cs.length() && cs[i] == '#' {
    alternate = true
    i += 1
  }
  if i < cs.length() && cs[i] == '0' {
    if align is None {
      fill = '0'
      align = Some('=')
    }
    i += 1
  }
  let mut width = 0
  while i < cs.length() && cs[i].is_ascii_digit() {
    width = width * 10 + (cs[i].to_int() - '0'.to_int())
    i += 1
  }
  let mut grouping : Char? = None
  if i < cs.length() && cs[i] is (',' | '_') {
    grouping = Some(cs[i])
    i += 1
  }
  let mut precision : Int32? = None
  if i < cs.length() && cs[i] == '.' {
    i += 1
    let start = i
    let mut p = 0
    while i < cs.length() && cs[i].is_ascii_digit() {
      p = p * 10 + (cs[i].to_int() - '0'.to_int())
      i += 1
    }
    if i == start {
      raise @spec.invalid("format specifier missing precision")
    }
    precision = Some(p)
  }
  let kind = if i < cs.length() { Some(cs[i]) } else { None }
  if i + 1 < cs.length() {
    raise @spec.invalid("invalid format specifier")
  }
  { fill, align, sign, coerce, alternate, width, grouping, precision, kind, }
}

///|
/// `format(value, spec)`.
fn format_value(
  call : @spec.Call,
  value : @spec.Value,
  spec_text : String,
) -> String raise @spec.Refused {
  if spec_text.is_empty() {
    return call.text(value)
  }
  let spec = parse_spec(spec_text)
  match value {
    Text(s) | Markup(s) => {
      if spec.kind is Some(k) && k != 's' {
        raise @spec.invalid("unknown format code \{k} for object of type 'str'")
      }
      if spec.sign != '-' || spec.alternate || spec.grouping is Some(_) {
        raise @spec.invalid(
          "this option is not allowed in string format specifier",
        )
      }
      let body = match spec.precision {
        Some(p) => chars_slice(s, 0, p)
        None => s
      }
      pad(body, spec, '<', "")
    }
    Int(_) | Bool(_) =>
      match spec.kind {
        Some('e' | 'E' | 'f' | 'F' | 'g' | 'G' | '%') =>
          format_float(value.number().unwrap(), spec)
        _ => format_int(integer_of(value), spec)
      }
    Double(d) => format_float(d, spec)
    _ =>
      raise @spec.invalid("unsupported format string passed to \{value.kind()}")
  }
}

///|
fn group_digits(digits : String, sep : Char, every : Int32) -> String {
  let cs = digits.iter().collect()
  let out = []
  for i, c in cs {
    if i > 0 && (cs.length() - i) % every == 0 {
      out.push(sep)
    }
    out.push(c)
  }
  String::from_array(out)
}

///|
fn format_int(n : Int64, spec : Spec) -> String raise @spec.Refused {
  if spec.precision is Some(_) {
    raise @spec.invalid("precision not allowed in integer format specifier")
  }
  let magnitude = if n < 0 { -n } else { n }
  let (digits, prefix) = match spec.kind {
    None | Some('d') | Some('n') => (magnitude.to_string(), "")
    Some('b') => (magnitude.to_string(radix=2), "0b")
    Some('o') => (magnitude.to_string(radix=8), "0o")
    Some('x') => (magnitude.to_string(radix=16), "0x")
    Some('X') => (magnitude.to_string(radix=16).to_upper(), "0X")
    Some('c') => return pad(code_point(n).to_string(), spec, '<', "")
    Some(k) =>
      raise @spec.invalid("unknown format code \{k} for object of type 'int'")
  }
  let sign = if n < 0 {
    "-"
  } else if spec.sign == '+' {
    "+"
  } else if spec.sign == ' ' {
    " "
  } else {
    ""
  }
  let lead = sign + (if spec.alternate { prefix } else { "" })
  let grouped = match spec.grouping {
    Some(sep) => {
      let every = if spec.kind is Some('b' | 'o' | 'x' | 'X') { 4 } else { 3 }
      grouped_digits(digits, sep, every, spec, spec.width - char_count(lead))
    }
    None => digits
  }
  pad(grouped, spec, '>', lead)
}

///|
fn format_float(d : Double, spec : Spec) -> String raise @spec.Refused {
  let negative = d < 0.0 || (d == 0.0 && 1.0 / d < 0.0)
  let magnitude = d.abs()
  let mut body = match spec.kind {
    Some('f' | 'F') => fixed(magnitude, spec.precision.unwrap_or(6))
    Some('e' | 'E') =>
      scientific(magnitude, spec.precision.unwrap_or(6), spec.kind == Some('E'))
    Some('g' | 'G' | 'n') =>
      general(
        magnitude,
        spec.precision.unwrap_or(6),
        spec.kind == Some('G'),
        spec.alternate,
      )
    Some('%') => fixed(magnitude * 100.0, spec.precision.unwrap_or(6)) + "%"
    None =>
      match spec.precision {
        Some(p) => {
          let g = general(magnitude, p, false, spec.alternate)
          if g.contains(".") ||
            g.contains("e") ||
            g.contains("n") ||
            g.contains("i") {
            g
          } else {
            g + ".0"
          }
        }
        None => @spec.python_float(magnitude)
      }
    Some(k) =>
      raise @spec.invalid("unknown format code \{k} for object of type 'float'")
  }
  if spec.kind is Some('F') {
    body = body.to_upper()
  }
  if spec.alternate &&
    !body.contains(".") &&
    body.iter().all(c => c.is_ascii_digit()) {
    body = body + "."
  }
  let negative = negative &&
    !(spec.coerce &&
    body.iter().all(c => c is ('0' | '.' | '%' | 'e' | 'E' | '+')))
  let sign = if negative && !d.is_nan() {
    "-"
  } else if spec.sign == '+' {
    "+"
  } else if spec.sign == ' ' {
    " "
  } else {
    ""
  }
  match spec.grouping {
    Some(sep) => {
      let cut = first_index(body.iter().collect()[:], c => !c.is_ascii_digit()).unwrap_or(
        char_count(body),
      )
      let rest = chars_slice(body, cut, char_count(body))
      body = grouped_digits(
          chars_slice(body, 0, cut),
          sep,
          3,
          spec,
          spec.width - char_count(sign) - char_count(rest),
        ) +
        rest
    }
    None => ()
  }
  pad(body, spec, '>', sign)
}

///|
/// Digits with separators every `every`. Zero padding after the sign goes
/// into the digits, separators and all, up to `width`, as Python fills
/// `0,` and `0_` widths; it never starts with a separator.
fn grouped_digits(
  digits : String,
  sep : Char,
  every : Int32,
  spec : Spec,
  width : Int32,
) -> String {
  let mut grouped = group_digits(digits, sep, every)
  if spec.fill != '0' || spec.align != Some('=') {
    return grouped
  }
  let mut padded = digits
  while char_count(grouped) < width {
    padded = "0" + padded
    grouped = group_digits(padded, sep, every)
  }
  if grouped.has_prefix(sep.to_string()) {
    "0" + grouped
  } else {
    grouped
  }
}

///|
/// Fill to the width: `<` `>` `^` place the text, `=` puts the fill after
/// the sign.
fn pad(body : String, spec : Spec, default : Char, sign : String) -> String {
  let len = char_count(body) + char_count(sign)
  if len >= spec.width {
    return sign + body
  }
  let gap = spec.width - len
  let fill = spec.fill.to_string()
  match spec.align.unwrap_or(default) {
    '<' => sign + body + fill.repeat(gap)
    '^' => fill.repeat(gap / 2) + sign + body + fill.repeat(gap - gap / 2)
    '=' => sign + fill.repeat(gap) + body
    _ => fill.repeat(gap) + sign + body
  }
}
