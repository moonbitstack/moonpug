///|
/// Python's `int()` of a value, as Django's `add` and `get_digit` try it.
fn python_int(value : @spec.Value) -> Int64? raise @spec.Refused {
  match value {
    Int(n) => Some(n)
    Bool(b) => Some(if b { 1 } else { 0 })
    Double(d) =>
      if d.is_nan() || d.is_inf() {
        None
      } else {
        Some(truncate_int(d))
      }
    Text(s) | Markup(s) => parse_int(s, 10)
    _ => None
  }
}

///|
fn filter_add(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let arg = bind("add", ["arg"], args, named).need("arg")
  match (python_int(value), python_int(arg)) {
    (Some(a), Some(b)) => return Int(a + b)
    _ => ()
  }
  ignore(call)
  match (value, arg) {
    (Text(a) | Markup(a), Text(b) | Markup(b)) => Text(a + b)
    (Seq(a), Seq(b)) => Seq(a + b)
    (Tuple(a), Tuple(b)) => Tuple(a + b)
    (Int(_) | Double(_) | Bool(_), Int(_) | Double(_) | Bool(_)) =>
      Double(value.number().unwrap() + arg.number().unwrap())
    _ => Text("")
  }
}

///|
fn filter_addslashes(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("addslashes", [], args, named))
  let text = soft(call, value)
    .replace_all(old="\\", new="\\\\")
    .replace_all(old="\"", new="\\\"")
    .replace_all(old="'", new="\\'")
  if value is Markup(_) {
    Markup(text)
  } else {
    Text(text)
  }
}

///|
fn filter_capfirst(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("capfirst", [], args, named))
  let text = soft(call, value)
  let out = match text.iter().head() {
    Some(first) =>
      @moonucd.upper(first.to_string()) +
      text.view(start_offset=first.utf16_len()).to_owned()
    None => text
  }
  if value is Markup(_) {
    Markup(out)
  } else {
    Text(out)
  }
}

///|
fn filter_cut(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let arg = call.text(bind("cut", ["arg"], args, named).need("arg"))
  let out = soft(call, value).replace_all(old=arg, new="")
  match value {
    Markup(_) if arg != ";" => Markup(out)
    _ => Text(out)
  }
}

///|
fn filter_default_if_none(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let arg = bind("default_if_none", ["arg"], args, named).need("arg")
  ignore(call)
  if value is Null {
    arg
  } else {
    value
  }
}

///|
/// What Django's `escapejs` writes for a character, or `None` to keep it.
fn js_escape(ch : Char) -> String? {
  let code = ch.to_int()
  match ch {
    '\\'
    | '\''
    | '"'
    | '>'
    | '<'
    | '&'
    | '='
    | '-'
    | ';'
    | '`'
    | '\u{2028}'
    | '\u{2029}' => ()
    _ => if !(code < 32 || (code >= 0x7F && code < 0xA0)) { return None }
  }
  let hex = "0123456789ABCDEF"
  let digits = StringBuilder()
  for shift in [12, 8, 4, 0] {
    digits.write_char(hex[(code >> shift) & 0xF].to_int().unsafe_to_char())
  }
  Some("\\u" + digits.to_string())
}

///|
fn filter_escapejs(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("escapejs", [], args, named))
  let out = StringBuilder()
  for ch in soft(call, value) {
    match js_escape(ch) {
      Some(e) => out.write_string(e)
      None => out.write_char(ch)
    }
  }
  Markup(out.to_string())
}

///|
fn filter_get_digit(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let arg = bind("get_digit", ["arg"], args, named).need("arg")
  ignore(call)
  guard python_int(arg) is Some(place) && python_int(value) is Some(n) else {
    return value
  }
  if place < 1L {
    return Int(n)
  }
  let digits = n.to_string()
  let at = digits.length() - place.to_int()
  if at < 0 {
    return Int(0)
  }
  let digit = digits[at:at + 1].to_owned()
  Int(parse_int(digit, 10).unwrap_or(0))
}

///|
/// The characters Django's `iri_to_uri` leaves as they are, besides letters,
/// digits and `_.-~`.
let iri_safe : String = "/#%[]=:;$&()+,!?*@'~"

///|
fn filter_iriencode(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("iriencode", [], args, named))
  let hex = "0123456789ABCDEF"
  let out = StringBuilder()
  for byte in @utf8.encode(soft(call, value)) {
    let b = byte.to_int()
    let ch = b.unsafe_to_char()
    if b < 0x80 &&
      (
        ch.is_ascii_alphabetic() ||
        ch.is_ascii_digit() ||
        "_.-~".contains_char(ch) ||
        iri_safe.contains_char(ch)
      ) {
      out.write_char(ch)
    } else {
      out.write_char('%')
      out.write_char(hex[b >> 4].to_int().unsafe_to_char())
      out.write_char(hex[b & 0xF].to_int().unsafe_to_char())
    }
  }
  Text(out.to_string())
}

///|
fn filter_json_script(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("json_script", ["element_id"], args, named)
  let json = json_dumps(value, None, sort=false)
    .replace_all(old=">", new="\\u003E")
    .replace_all(old="<", new="\\u003C")
    .replace_all(old="&", new="\\u0026")
  let id = match b.get("element_id") {
    Some(Null) | None => ""
    Some(Markup(s)) => s
    Some(v) => @spec.escape(call.text(v))
  }
  Markup(
    if id.is_empty() {
      "<script type=\"application/json\">\{json}</script>"
    } else {
      "<script id=\"\{id}\" type=\"application/json\">\{json}</script>"
    },
  )
}

///|
/// Text with `\r\n` and `\r` read as `\n`.
fn normalise_newlines(s : String) -> String {
  s.replace_all(old="\r\n", new="\n").replace_all(old="\r", new="\n")
}

///|
/// The text of a value for a filter that builds markup: escaped when
/// escaping is on and the value is not trusted already.
fn markup_input(
  call : @spec.Call,
  value : @spec.Value,
) -> String raise @spec.Refused {
  match value {
    Markup(s) => s
    _ =>
      if call.autoescape {
        @spec.escape(soft(call, value))
      } else {
        soft(call, value)
      }
  }
}

///|
fn filter_linebreaks(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("linebreaks", [], args, named))
  let text = normalise_newlines(soft(call, value))
  let escape = call.autoescape && !(value is Markup(_))
  let paras = []
  let mut start = 0
  let mut i = 0
  while i < text.length() {
    if text.code_unit_at(i) == '\n' &&
      i + 1 < text.length() &&
      text.code_unit_at(i + 1) == '\n' {
      paras.push(text[start:i].to_owned())
      while i < text.length() && text.code_unit_at(i) == '\n' {
        i += 1
      }
      start = i
    } else {
      i += 1
    }
  }
  paras.push(text[start:].to_owned())
  let out = paras.map(p => {
    let body = if escape { @spec.escape(p) } else { p }
    "<p>" + body.replace_all(old="\n", new="<br>") + "</p>"
  })
  Markup(out.join("\n\n"))
}

///|
fn filter_linebreaksbr(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("linebreaksbr", [], args, named))
  let text = normalise_newlines(markup_input(call, value))
  Markup(text.replace_all(old="\n", new="<br>"))
}

///|
fn filter_linenumbers(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("linenumbers", [], args, named))
  let lines = soft(call, value).split("\n").map(l => l.to_owned()).collect()
  let width = lines.length().to_string().length()
  let escape = call.autoescape && !(value is Markup(_))
  let out = lines.mapi((i, line) => {
    let n = (i + 1).to_string()
    let padded = "0000000000"[:(width - n.length()).max(0)].to_owned() + n
    padded + ". " + (if escape { @spec.escape(line) } else { line })
  })
  Markup(out.join("\n"))
}

///|
fn justify(
  who : String,
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
  left : Bool,
) -> @spec.Value raise @spec.Refused {
  let width = bind(who, ["arg"], args, named).int("arg", 0)
  let text = soft(call, value)
  let length = text.iter().count()
  if length >= width {
    return if value is Markup(_) { Markup(text) } else { Text(text) }
  }
  let pad = " ".repeat(width - length)
  let out = if left { text + pad } else { pad + text }
  if value is Markup(_) {
    Markup(out)
  } else {
    Text(out)
  }
}

///|
fn filter_ljust(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  justify("ljust", call, value, args, named, true)
}

///|
fn filter_rjust(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  justify("rjust", call, value, args, named, false)
}

///|
/// The keypad digit of each letter.
let keypad : String = "22233344455566677778889999"

///|
fn filter_phone2numeric(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("phone2numeric", [], args, named))
  let out = StringBuilder()
  for ch in @moonucd.lower(soft(call, value)) {
    if ch >= 'a' && ch <= 'z' {
      out.write_char(
        keypad[ch.to_int() - 'a'.to_int()].to_int().unsafe_to_char(),
      )
    } else {
      out.write_char(ch)
    }
  }
  if value is Markup(_) {
    Markup(out.to_string())
  } else {
    Text(out.to_string())
  }
}

///|
fn filter_pluralize(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let arg = bind("pluralize", ["arg"], args, named).text(call, "arg", "s")
  let spec = if arg.contains(",") { arg } else { "," + arg }
  let bits = spec.split(",").map(b => b.to_owned()).collect()
  if bits.length() > 2 {
    return Text("")
  }
  let (one, many) = (bits[0], bits[1])
  let count = match value {
    Int(_) | Double(_) | Bool(_) => value.number()
    Text(s) | Markup(s) =>
      match parse_float(s) {
        Some(d) => Some(d)
        None => return Text("")
      }
    Seq(items) | Tuple(items) => Some(items.length().to_double())
    Dict(fields) => Some(fields.length().to_double())
    _ => None
  }
  Text(
    match count {
      Some(n) => if n == 1.0 { one } else { many }
      None => ""
    },
  )
}

///|
fn filter_spaceless(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("spaceless", [], args, named))
  let text = soft(call, value).trim().to_owned()
  let out = StringBuilder()
  let mut i = 0
  while i < text.length() {
    let unit = text.code_unit_at(i)
    out.write_char(unit.to_int().unsafe_to_char())
    i += 1
    if unit == '>' {
      let mut j = i
      while j < text.length() &&
            is_space(text.code_unit_at(j).to_int().unsafe_to_char()) {
        j += 1
      }
      if j > i && j < text.length() && text.code_unit_at(j) == '<' {
        i = j
      }
    }
  }
  match value {
    Markup(_) => Markup(out.to_string())
    _ => Text(out.to_string())
  }
}

///|
fn filter_truncatewords(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let arg = bind("truncatewords", ["arg"], args, named).need("arg")
  let text = soft(call, value)
  guard python_int(arg) is Some(length) else { return Text(text) }
  if length <= 0L {
    return Text("")
  }
  let all = py_split_ws(text)
  if all.length().to_int64() > length {
    let kept = all[:length.to_int()].to_owned().join(" ")
    Text(if kept.has_suffix(" …") { kept } else { kept + " …" })
  } else {
    Text(all.join(" "))
  }
}

///|
/// Django's `_walk_items`: each item with the list that follows it, if one
/// does, as its children.
fn walk_items(
  items : Array[@spec.Value],
) -> Array[(@spec.Value, Array[@spec.Value]?)] {
  let out = []
  let mut i = 0
  while i < items.length() {
    let item = items[i]
    match items.get(i + 1) {
      Some(Seq(children) | Tuple(children)) => {
        out.push((item, Some(children)))
        i += 2
      }
      _ => {
        out.push((item, None))
        i += 1
      }
    }
  }
  out
}

///|
fn filter_unordered_list(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("unordered_list", [], args, named))
  fn format(
    items : Array[@spec.Value],
    tabs : Int32,
  ) -> String raise @spec.Refused {
    let indent = "\t".repeat(tabs)
    let out = []
    for pair in walk_items(items) {
      let (item, children) = pair
      let sublist = match children {
        Some(c) if !c.is_empty() =>
          "\n\{indent}<ul>\n\{format(c, tabs + 1)}\n\{indent}</ul>\n\{indent}"
        _ => ""
      }
      let text = match item {
        Markup(s) => s
        _ =>
          if call.autoescape {
            @spec.escape(item.to_string())
          } else {
            item.to_string()
          }
      }
      out.push("\{indent}<li>\{text}\{sublist}</li>")
    }
    out.join("\n")
  }
  Markup(format(call.items(value), 1))
}

///|
fn filter_yesno(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let arg = bind("yesno", ["arg"], args, named).text(
    call, "arg", "yes,no,maybe",
  )
  let bits = arg.split(",").map(b => b.to_owned()).collect()
  if bits.length() < 2 {
    return value
  }
  let (yes, no, maybe) = if bits.length() == 3 {
    (bits[0], bits[1], bits[2])
  } else {
    (bits[0], bits[1], bits[1])
  }
  Text(
    match value {
      Null => maybe
      _ => if value.truthy() { yes } else { no }
    },
  )
}

///|
/// A number written as Python's `Decimal` reads it: sign, digits and
/// exponent; `None` for anything else, the infinities and NaN included.
fn decimal_of(text : String) -> (Bool, String, Int32)? {
  let s = text
    .trim(chars=" \t\n\r\u{0B}\u{0C}")
    .to_owned()
    .replace_all(old="_", new="")
  let cs = s.iter().collect()
  let mut i = 0
  let negative = if i < cs.length() && (cs[i] == '-' || cs[i] == '+') {
    i += 1
    cs[i - 1] == '-'
  } else {
    false
  }
  let digits = StringBuilder()
  let mut seen = false
  let mut exponent = 0
  while i < cs.length() && cs[i].is_ascii_digit() {
    digits.write_char(cs[i])
    seen = true
    i += 1
  }
  if i < cs.length() && cs[i] == '.' {
    i += 1
    while i < cs.length() && cs[i].is_ascii_digit() {
      digits.write_char(cs[i])
      exponent -= 1
      seen = true
      i += 1
    }
  }
  if !seen {
    return None
  }
  if i < cs.length() && (cs[i] == 'e' || cs[i] == 'E') {
    i += 1
    let sign = if i < cs.length() && (cs[i] == '-' || cs[i] == '+') {
      i += 1
      if cs[i - 1] == '-' {
        -1
      } else {
        1
      }
    } else {
      1
    }
    let start = i
    let mut e = 0
    while i < cs.length() && cs[i].is_ascii_digit() {
      e = e * 10 + (cs[i].to_int() - '0'.to_int())
      i += 1
    }
    if i == start {
      return None
    }
    exponent += sign * e
  }
  if i != cs.length() {
    return None
  }
  let d = digits.to_string().trim_start(chars="0").to_owned()
  Some((negative, if d.is_empty() { "0" } else { d }, exponent))
}

///|
/// Thousands grouped by commas, the integer part of `number` only.
fn group_thousands(number : String) -> String {
  let (sign, rest) = if number.has_prefix("-") {
    ("-", number[1:].to_owned())
  } else {
    ("", number)
  }
  let (int_part, dec_part) = match rest.find(".") {
    Some(at) => (rest[:at].to_owned(), rest[at:].to_owned())
    None => (rest, "")
  }
  sign + group_digits(int_part, ',', 3) + dec_part
}

///|
fn filter_floatformat(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("floatformat", ["arg"], args, named)
  let mut arg = match b.get("arg") {
    Some(Int(n)) => n.to_string()
    Some(v) => call.text(v)
    None => "-1"
  }
  let mut grouping = false
  if arg.has_suffix("gu") || arg.has_suffix("ug") {
    grouping = false
    arg = arg[:arg.length() - 2].to_owned()
  } else if arg.has_suffix("g") {
    grouping = true
    arg = arg[:arg.length() - 1].to_owned()
  } else if arg.has_suffix("u") {
    arg = arg[:arg.length() - 1].to_owned()
  }
  if arg.is_empty() {
    arg = "-1"
  }
  let input = match value {
    Double(d) => @spec.python_float(d)
    _ => soft(call, value)
  }
  let parsed = match decimal_of(input) {
    Some(d) => Some(d)
    None =>
      match parse_float(input) {
        Some(f) if !f.is_nan() && !f.is_inf() =>
          decimal_of(@spec.python_float(f))
        Some(_) => return Text(input)
        None => None
      }
  }
  guard parsed is Some((negative, digits, exponent)) else { return Text("") }
  guard parse_int(arg, 10) is Some(p64) else { return Text(input) }
  if digits.length() + exponent.abs() > 200 {
    return Text(input)
  }
  let p = p64.to_int()
  let fraction = exponent < 0 &&
    digits.length() > 0 &&
    digits[(digits.length() + exponent).max(0):].iter().any(c => c != '0')
  let finish = (number : String) => {
    @spec.Value::Markup(if grouping { group_thousands(number) } else { number })
  }
  if !fraction && p <= 0 {
    let whole = if exponent >= 0 {
      digits + "0".repeat(exponent)
    } else if digits.length() + exponent > 0 {
      digits[:digits.length() + exponent].to_owned()
    } else {
      "0"
    }
    let whole = whole.trim_start(chars="0").to_owned()
    let whole = if whole.is_empty() { "0" } else { whole }
    return finish(if negative && whole != "0" { "-" + whole } else { whole })
  }
  let places = p.abs()
  let coefficient = @bigint.BigInt::from_string(digits)
  let scaled = if exponent >= -places {
    coefficient * ten_to(exponent + places)
  } else {
    let unit = ten_to(-places - exponent)
    let q = coefficient / unit
    let r = coefficient % unit
    if r * 2N >= unit {
      q + 1N
    } else {
      q
    }
  }
  let mut text = scaled.to_string()
  while text.length() <= places {
    text = "0" + text
  }
  let number = if places == 0 {
    text
  } else {
    text[:text.length() - places].to_owned() +
    "." +
    text[text.length() - places:].to_owned()
  }
  finish(if negative && scaled != 0N { "-" + number } else { number })
}
