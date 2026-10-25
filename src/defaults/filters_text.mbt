///|
/// The same kind of text as `like`: safe stays safe.
fn same_kind(like : @spec.Value, text : String) -> @spec.Value {
  match like {
    Markup(_) => Markup(text)
    _ => Text(text)
  }
}

///|
/// Python's `soft_str`: safe text stays as written, anything else prints.
fn soft(call : @spec.Call, value : @spec.Value) -> String raise @spec.Refused {
  call.text(value)
}

///|
fn filter_upper(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("upper", [], args, named))
  same_kind(value, @moonucd.upper(soft(call, value)))
}

///|
fn filter_lower(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("lower", [], args, named))
  same_kind(value, @moonucd.lower(soft(call, value)))
}

///|
fn filter_capitalize(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("capitalize", [], args, named))
  same_kind(value, py_capitalize(soft(call, value)))
}

///|
fn filter_title(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("title", [], args, named))
  same_kind(value, jinja_title(soft(call, value)))
}

///|
fn filter_center(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("center", ["width"], args, named)
  same_kind(value, py_center(soft(call, value), b.int("width", 80)))
}

///|
fn filter_trim(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("trim", ["chars"], args, named)
  let chars = match b.get("chars") {
    Some(Null) | None => None
    Some(v) => Some(call.text(v))
  }
  same_kind(value, py_strip(soft(call, value), chars))
}

///|
fn filter_string(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("string", [], args, named))
  same_kind(value, soft(call, value))
}

///|
fn filter_safe(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("safe", [], args, named))
  Markup(soft(call, value))
}

///|
fn filter_escape(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("escape", [], args, named))
  match value {
    Markup(_) => value
    _ => Markup(@spec.escape(soft(call, value)))
  }
}

///|
fn filter_forceescape(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("forceescape", [], args, named))
  Markup(@spec.escape(soft(call, value)))
}

///|
fn filter_wordcount(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("wordcount", [], args, named))
  Int(words(soft(call, value)).length().to_int64())
}

///|
fn filter_replace(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("replace", ["old", "new", "count"], args, named)
  let old = b.need("old")
  let new = b.need("new")
  let count = b.int("count", -1)
  if !call.autoescape {
    return Text(
      py_replace(soft(call, value), call.text(old), call.text(new), count),
    )
  }
  let markup = old is Markup(_) || (new is Markup(_) && !(value is Markup(_)))
  if markup || value is Markup(_) {
    let base = value.markup()
    Markup(py_replace(base, old.markup(), new.markup(), count))
  } else {
    Text(py_replace(soft(call, value), call.text(old), call.text(new), count))
  }
}

///|
fn filter_truncate(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind(
    "truncate",
    ["length", "killwords", "end", "leeway"],
    args,
    named,
  )
  let s = soft(call, value)
  let length = b.int("length", 255)
  let killwords = b.flag("killwords", false)
  let end = b.text(call, "end", "...")
  let leeway = b.int("leeway", 5)
  let end_len = char_count(end)
  if length < end_len {
    raise @spec.invalid(
      "truncate expects a length of at least \{end_len}, got \{length}",
    )
  }
  if leeway < 0 {
    raise @spec.invalid(
      "truncate expects a leeway of at least 0, got \{leeway}",
    )
  }
  if char_count(s) <= length + leeway {
    return same_kind(value, s)
  }
  let head = chars_slice(s, 0, length - end_len)
  if killwords {
    return same_kind(value, head + end)
  }
  let kept = match head.rev_find(" ") {
    Some(at) => head[:at].to_owned()
    None => head
  }
  same_kind(value, kept + end)
}

///|
fn filter_indent(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("indent", ["width", "first", "blank"], args, named)
  let indention = match b.get("width") {
    Some(Text(w) | Markup(w)) => w
    _ => " ".repeat(b.int("width", 4))
  }
  let first = b.flag("first", false)
  let blank = b.flag("blank", false)
  let s = soft(call, value) + "\n"
  let lines = py_splitlines(s, false)
  let mut rv = if blank {
    lines.join("\n" + indention)
  } else if lines.is_empty() {
    ""
  } else {
    let rest = lines[1:].map(line => {
      if line.is_empty() {
        line
      } else {
        indention + line
      }
    })
    if rest.length() > 0 {
      lines[0] + "\n" + rest.join("\n")
    } else {
      lines[0]
    }
  }
  if first {
    rv = indention + rv
  }
  same_kind(value, rv)
}

///|
fn filter_wordwrap(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind(
    "wordwrap",
    ["width", "break_long_words", "wrapstring", "break_on_hyphens"],
    args,
    named,
  )
  let width = b.int("width", 79)
  let break_long = b.flag("break_long_words", true)
  let hyphens = b.flag("break_on_hyphens", true)
  let wrapstring = match b.get("wrapstring") {
    Some(Null) | None => "\n"
    Some(v) => call.text(v)
  }
  let paragraphs = py_splitlines(soft(call, value), false)
  Text(
    paragraphs
    .map(line => wrap(line, width, break_long, hyphens).join(wrapstring))
    .join(wrapstring),
  )
}

///|
fn filter_format(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  if !args.is_empty() && !named.is_empty() {
    raise @spec.invalid(
      "format cannot handle positional and named arguments at the same time",
    )
  }
  let template = soft(call, value)
  let result = if named.is_empty() {
    percent_format(call, template, Positional(args))
  } else {
    percent_format(call, template, Named(named))
  }
  same_kind(value, result)
}

///|
fn filter_striptags(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("striptags", [], args, named))
  Text(strip_tags(soft(call, value)))
}

///|
/// markupsafe's `striptags`: comments, then tags, removed; whitespace
/// collapsed; entities decoded.
fn strip_tags(text : String) -> String {
  let mut value = text
  for pair in [("<!--", "-->"), ("<", ">")] {
    let (open, close) = pair
    for ;; {
      match value.find(open) {
        Some(start) =>
          match value[start + open.length():].find(close) {
            Some(at) =>
              value = value[:start].to_owned() +
                value[start + open.length() + at + close.length():].to_owned()
            None => break
          }
        None => break
      }
    }
  }
  html_unescape(py_split_ws(value).join(" "))
}

///|
fn filter_abs(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("abs", [], args, named))
  ignore(call)
  match value {
    Int(n) => Int(if n < 0 { -n } else { n })
    Double(d) => Double(d.abs())
    Bool(b) => Int(if b { 1 } else { 0 })
    _ => raise @spec.invalid("abs wants a number, not \{value.kind()}")
  }
}

///|
fn filter_int(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("int", ["default", "base"], args, named)
  let default = b.get("default").unwrap_or(Int(0))
  let base = b.int("base", 10)
  ignore(call)
  match value {
    Int(_) => value
    Bool(flag) => Int(if flag { 1 } else { 0 })
    Double(d) =>
      if d.is_nan() || d.is_inf() {
        default
      } else {
        Int(truncate_int(d))
      }
    Text(s) | Markup(s) =>
      match parse_int(s, base) {
        Some(n) => Int(n)
        None =>
          match parse_float(s) {
            Some(d) if !d.is_nan() && !d.is_inf() => Int(truncate_int(d))
            _ => default
          }
      }
    _ => default
  }
}

///|
fn filter_float(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("float", ["default"], args, named)
  ignore(call)
  match to_float(value) {
    Some(d) => Double(d)
    None => b.get("default").unwrap_or(Double(0.0))
  }
}

///|
fn filter_round(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("round", ["precision", "method"], args, named)
  let precision = b.int("precision", 0)
  let mode = b.text(call, "method", "common")
  let number = match to_float(value) {
    Some(d) if !(value is (Text(_) | Markup(_))) => d
    _ => raise @spec.invalid("round wants a number, not \{value.kind()}")
  }
  match (mode, value) {
    ("common", Int(_) | Bool(_)) =>
      Int(round_int(value.number().unwrap().to_int64(), precision))
    ("common", _) => Double(python_round(number, precision))
    ("ceil" | "floor", _) => {
      let scale = @math.pow(10.0, precision.to_double())
      let scaled = number * scale
      let r = if mode == "ceil" { scaled.ceil() } else { scaled.floor() }
      Double(r / scale)
    }
    _ => raise @spec.invalid("method must be common, ceil or floor")
  }
}

///|
/// Python's `round` of an integer: unchanged for places at or past the
/// point, else to the nearest ten, hundred and so on, half to even.
fn round_int(n : Int64, places : Int32) -> Int64 {
  if places >= 0 {
    return n
  }
  if places < -18 {
    return 0L
  }
  let unit = @math.pow(10.0, (-places).to_double()).to_int64()
  let negative = n < 0L
  let m = if negative { -n } else { n }
  let q = m / unit
  let r = m % unit
  let q = if r * 2L > unit || (r * 2L == unit && q % 2L == 1L) {
    q + 1L
  } else {
    q
  }
  if negative {
    -(q * unit)
  } else {
    q * unit
  }
}

///|
fn filter_filesizeformat(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("filesizeformat", ["binary"], args, named)
  ignore(call)
  let bytes = match to_float(value) {
    Some(d) => d
    None =>
      raise @spec.invalid("filesizeformat wants a number, not \{value.kind()}")
  }
  let binary = b.flag("binary", false)
  let base = if binary { 1024.0 } else { 1000.0 }
  let prefixes = if binary {
    ["KiB", "MiB", "GiB", "TiB", "PiB", "EiB", "ZiB", "YiB"]
  } else {
    ["kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
  }
  if bytes == 1.0 {
    return Text("1 Byte")
  }
  if bytes < base {
    return Text("\{bytes.to_int64()} Bytes")
  }
  let mut unit = 0.0
  for i, prefix in prefixes {
    unit = @math.pow(base, (i + 2).to_double())
    if bytes < unit {
      return Text(fixed(base * bytes / unit, 1) + " " + prefix)
    }
  }
  Text(fixed(base * bytes / unit, 1) + " " + prefixes[prefixes.length() - 1])
}
