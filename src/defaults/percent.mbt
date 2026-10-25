///|
/// What the right-hand side of Python's `%` supplies.
priv enum Supply {
  Positional(Array[@spec.Value])
  Named(Map[String, @spec.Value])
}

///|
/// Python's `str % value`: a tuple supplies positional values, a mapping
/// supplies `%(name)s` keys, anything else is one positional value. With
/// `escape`, values are escaped as they go in, as `Markup % value` does.
pub fn percent(
  call : @spec.Call,
  template : String,
  value : @spec.Value,
  escape~ : Bool = false,
) -> String raise @spec.Refused {
  let supply = match value {
    Tuple(items) => Positional(items)
    Dict(fields) => Named(fields)
    other => Positional([other])
  }
  percent_format(call, template, supply, escape~)
}

///|
fn percent_format(
  call : @spec.Call,
  template : String,
  supply : Supply,
  escape~ : Bool = false,
) -> String raise @spec.Refused {
  let cs = template.iter().collect()
  let out = StringBuilder()
  let mut next = 0
  let mut i = 0
  let take = fn() raise @spec.Refused {
    match supply {
      Positional(items) => {
        if next >= items.length() {
          raise @spec.invalid("not enough arguments for format string")
        }
        next += 1
        items[next - 1]
      }
      Named(_) as named =>
        if next == 0 {
          next = 1
          Dict(
            match named {
              Named(f) => f
              _ => Map([])
            },
          )
        } else {
          raise @spec.invalid("not enough arguments for format string")
        }
    }
  }
  let mut used_key = false
  while i < cs.length() {
    let ch = cs[i]
    if ch != '%' {
      out.write_char(ch)
      i += 1
      continue
    }
    i += 1
    if i >= cs.length() {
      raise @spec.invalid("incomplete format")
    }
    let mut key : String? = None
    if cs[i] == '(' {
      let mut depth = 1
      let start = i + 1
      i += 1
      while i < cs.length() && depth > 0 {
        if cs[i] == '(' {
          depth += 1
        } else if cs[i] == ')' {
          depth -= 1
        }
        i += 1
      }
      if depth > 0 {
        raise @spec.invalid("incomplete format key")
      }
      key = Some(String::from_array(cs[start:i - 1]))
    }
    let mut left = false
    let mut plus = false
    let mut space = false
    let mut zero = false
    let mut alternate = false
    while i < cs.length() && cs[i] is ('-' | '+' | ' ' | '0' | '#') {
      match cs[i] {
        '-' => left = true
        '+' => plus = true
        ' ' => space = true
        '0' => zero = true
        _ => alternate = true
      }
      i += 1
    }
    let mut width = 0
    if i < cs.length() && cs[i] == '*' {
      width = number_of(take())
      if width < 0 {
        left = true
        width = -width
      }
      i += 1
    } else {
      while i < cs.length() && cs[i].is_ascii_digit() {
        width = width * 10 + (cs[i].to_int() - '0'.to_int())
        i += 1
      }
    }
    let mut precision : Int32? = None
    if i < cs.length() && cs[i] == '.' {
      i += 1
      if i < cs.length() && cs[i] == '*' {
        precision = Some(number_of(take()))
        i += 1
      } else {
        let mut p = 0
        while i < cs.length() && cs[i].is_ascii_digit() {
          p = p * 10 + (cs[i].to_int() - '0'.to_int())
          i += 1
        }
        precision = Some(p)
      }
    }
    while i < cs.length() && cs[i] is ('h' | 'l' | 'L') {
      i += 1
    }
    if i >= cs.length() {
      raise @spec.invalid("incomplete format")
    }
    let conv = cs[i]
    i += 1
    if conv == '%' {
      out.write_char('%')
      continue
    }
    let arg = match key {
      Some(k) => {
        used_key = true
        match supply {
          Named(fields) =>
            match fields.get(k) {
              Some(v) => v
              None => raise @spec.unknown("name", k)
            }
          Positional(_) => raise @spec.invalid("format requires a mapping")
        }
      }
      None => take()
    }
    let body = convert(
      call, conv, arg, precision, plus, space, alternate, escape,
    )
    let negative = body.has_prefix("-")
    let numeric = conv
      is ('d' | 'i' | 'u' | 'f' | 'F' | 'e' | 'E' | 'g' | 'G' | 'x' | 'X' | 'o')
    let pad = width - char_count(body)
    if pad <= 0 {
      out.write_string(body)
    } else if left {
      out.write_string(body)
      out.write_string(" ".repeat(pad))
    } else if zero && numeric {
      let (sign, digits) = if negative ||
        body.has_prefix("+") ||
        body.has_prefix(" ") {
        (body[:1].to_owned(), body[1:].to_owned())
      } else {
        ("", body)
      }
      let (prefix, rest) = if alternate &&
        digits.length() > 1 &&
        digits[0] == '0' &&
        digits[1] is ('x' | 'X' | 'o') {
        (digits[:2].to_owned(), digits[2:].to_owned())
      } else {
        ("", digits)
      }
      out.write_string(sign + prefix + "0".repeat(pad) + rest)
    } else {
      out.write_string(" ".repeat(pad))
      out.write_string(body)
    }
  }
  match supply {
    Positional(items) if next < items.length() =>
      raise @spec.invalid(
        "not all arguments converted during string formatting",
      )
    _ => ()
  }
  ignore(used_key)
  out.to_string()
}

///|
fn number_of(value : @spec.Value) -> Int32 raise @spec.Refused {
  match value {
    Int(n) => n.to_int()
    Bool(b) => if b { 1 } else { 0 }
    _ => raise @spec.invalid("* wants an integer")
  }
}

///|
/// One conversion: the text of `arg` under `conv`.
fn convert(
  call : @spec.Call,
  conv : Char,
  arg : @spec.Value,
  precision : Int32?,
  plus : Bool,
  space : Bool,
  alternate : Bool,
  escape : Bool,
) -> String raise @spec.Refused {
  let sign = fn(negative : Bool, body : String) {
    if negative {
      "-" + body
    } else if plus {
      "+" + body
    } else if space {
      " " + body
    } else {
      body
    }
  }
  match conv {
    's' | 'r' | 'a' => {
      let text = match conv {
        's' => call.text(arg)
        'r' => arg.repr()
        _ => ascii_of(arg.repr())
      }
      let cut = match precision {
        Some(p) => chars_slice(text, 0, p)
        None => text
      }
      if escape && !(arg is Markup(_)) {
        @spec.escape(cut)
      } else {
        cut
      }
    }
    'd' | 'i' | 'u' => {
      let n = integer_of(arg)
      sign(n < 0, (if n < 0 { -n } else { n }).to_string())
    }
    'x' | 'X' | 'o' => {
      let n = integer_of(arg)
      let radix = if conv == 'o' { 8 } else { 16 }
      let mut digits = (if n < 0 { -n } else { n }).to_string(radix~)
      if conv == 'X' {
        digits = digits.to_upper()
      }
      if alternate {
        digits = (if conv == 'o' {
            "0o"
          } else if conv == 'X' {
            "0X"
          } else {
            "0x"
          }) +
          digits
      }
      sign(n < 0, digits)
    }
    'f' | 'F' | 'e' | 'E' | 'g' | 'G' => {
      let d = match to_float(arg) {
        Some(d) if !(arg is (Text(_) | Markup(_))) => d
        _ =>
          raise @spec.invalid(
            "%\{conv} format: a real number is required, not \{arg.kind()}",
          )
      }
      let p = precision.unwrap_or(6)
      let negative = d < 0.0 || (d == 0.0 && 1.0 / d < 0.0)
      let magnitude = d.abs()
      let body = match conv {
        'f' | 'F' => {
          let t = fixed(magnitude, p)
          let t = if alternate && p == 0 { t + "." } else { t }
          if conv == 'F' {
            t.to_upper()
          } else {
            t
          }
        }
        'e' | 'E' => scientific(magnitude, p, conv == 'E')
        _ => general(magnitude, p, conv == 'G', alternate)
      }
      sign(negative && !d.is_nan(), body)
    }
    'c' =>
      match arg {
        Int(n) => code_point(n).to_string()
        Text(s) | Markup(s) if char_count(s) == 1 => s
        _ => raise @spec.invalid("%c requires an integer or a single character")
      }
    _ => raise @spec.invalid("unsupported format character \{conv}")
  }
}

///|
fn integer_of(value : @spec.Value) -> Int64 raise @spec.Refused {
  match value {
    Int(n) => n
    Bool(b) => if b { 1 } else { 0 }
    Double(d) => truncate_int(d)
    _ =>
      raise @spec.invalid(
        "%d format: a number is required, not \{value.kind()}",
      )
  }
}
