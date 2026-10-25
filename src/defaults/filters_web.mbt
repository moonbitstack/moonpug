///|
/// Python's `urllib.parse.quote` over UTF-8: letters, digits and `_.-~`
/// stay, so does `/` unless `query`; in a query a space becomes `+`.
fn url_quote(text : String, query : Bool) -> String {
  let out = StringBuilder()
  for byte in @utf8.encode(text) {
    let ch = byte.to_int()
    if (ch >= 'A' && ch <= 'Z') ||
      (ch >= 'a' && ch <= 'z') ||
      (ch >= '0' && ch <= '9') ||
      ch is ('_' | '.' | '-' | '~') ||
      (!query && ch == '/') {
      out.write_char(ch.unsafe_to_char())
    } else if query && ch == ' ' {
      out.write_char('+')
    } else {
      let hex = ch.to_string(radix=16).to_upper()
      out.write_string("%" + (if hex.length() < 2 { "0" } else { "" }) + hex)
    }
  }
  out.to_string()
}

///|
fn filter_urlencode(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("urlencode", [], args, named))
  let pairs : Array[(@spec.Value, @spec.Value)] = match value {
    Text(_) | Markup(_) | Int(_) | Double(_) | Bool(_) | Null =>
      return Text(url_quote(call.text(value), false))
    Dict(fields) =>
      fields.iter().map(p => (@spec.Value::Text(p.0), p.1)).collect()
    _ => {
      let out = []
      for item in call.items(value) {
        match item {
          Seq([k, v]) | Tuple([k, v]) => out.push((k, v))
          _ =>
            raise @spec.invalid(
              "urlencode wants a mapping or a sequence of pairs",
            )
        }
      }
      out
    }
  }
  let parts = []
  for pair in pairs {
    parts.push(
      url_quote(call.text(pair.0), true) +
      "=" +
      url_quote(call.text(pair.1), true),
    )
  }
  Text(parts.join("&"))
}

///|
fn filter_xmlattr(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("xmlattr", ["autospace"], args, named)
  let fields = match value {
    Dict(fields) => fields
    _ => raise @spec.invalid("xmlattr wants a mapping, not \{value.kind()}")
  }
  let items = []
  for key, item in fields {
    if item is (Null | Undefined(_)) {
      continue
    }
    if key.iter().any(ch => is_space(ch) || ch is ('/' | '>' | '=')) {
      raise @spec.invalid(
        "invalid character in attribute name: \{@spec.repr_text(key)}",
      )
    }
    items.push(@spec.escape(key) + "=\"" + item.markup() + "\"")
  }
  let mut rv = items.join(" ")
  if b.flag("autospace", true) && !rv.is_empty() {
    rv = " " + rv
  }
  if call.autoescape {
    Markup(rv)
  } else {
    Text(rv)
  }
}

///|
fn filter_tojson(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("tojson", ["indent"], args, named)
  let indent = match b.get("indent") {
    Some(Null) | None => None
    Some(_) => Some(b.int("indent", 0))
  }
  ignore(call)
  Markup(
    json_dumps(value, indent)
    .replace_all(old="<", new="\\u003c")
    .replace_all(old=">", new="\\u003e")
    .replace_all(old="&", new="\\u0026")
    .replace_all(old="'", new="\\u0027"),
  )
}

///|
fn filter_pprint(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("pprint", [], args, named))
  ignore(call)
  Text(pformat(value))
}

///|
fn filter_urlize(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind(
    "urlize",
    ["trim_url_limit", "nofollow", "target", "rel", "extra_schemes"],
    args,
    named,
  )
  let limit = match b.get("trim_url_limit") {
    Some(Null) | None => None
    Some(_) => Some(b.int("trim_url_limit", 0))
  }
  let rel_parts : Array[String] = match b.get("rel") {
    Some(Null) | None => []
    Some(v) => py_split_ws(call.text(v))
  }
  if b.flag("nofollow", false) {
    rel_parts.push("nofollow")
  }
  rel_parts.push("noopener")
  let unique = []
  for part in rel_parts {
    if !unique.contains(part) {
      unique.push(part)
    }
  }
  unique.sort_by((a, c) => @spec.code_point_compare(a, c))
  let rel = unique.join(" ")
  let target = match b.get("target") {
    Some(Null) | None => None
    Some(v) => Some(call.text(v))
  }
  let schemes = match b.get("extra_schemes") {
    Some(Null) | None => []
    Some(v) => {
      let out = []
      for s in call.items(v) {
        let scheme = call.text(s)
        if !valid_scheme(scheme) {
          raise @spec.invalid(
            "\{@spec.repr_text(scheme)} is not a valid URI scheme prefix",
          )
        }
        out.push(scheme)
      }
      out
    }
  }
  let rv = urlize(soft(call, value), limit, rel, target, schemes)
  if call.autoescape {
    Markup(rv)
  } else {
    Text(rv)
  }
}

///|
/// `^([\w.+-]{2,}:(/){0,2})$`.
fn valid_scheme(s : String) -> Bool {
  let cs = s.iter().collect()
  let mut i = 0
  while i < cs.length() && (is_word(cs[i]) || cs[i] is ('.' | '+' | '-')) {
    i += 1
  }
  if i < 2 || i >= cs.length() || cs[i] != ':' {
    return false
  }
  let slashes = cs.length() - i - 1
  slashes <= 2 && cs[i + 1:].iter().all(c => c == '/')
}

///|
/// Jinja's `urlize`, over text it escapes first.
fn urlize(
  text : String,
  limit : Int32?,
  rel : String,
  target : String?,
  schemes : Array[String],
) -> String {
  let trim = fn(x : String) {
    match limit {
      Some(n) if char_count(x) > n => chars_slice(x, 0, n) + "..."
      _ => x
    }
  }
  let rel_attr = if rel.is_empty() {
    ""
  } else {
    " rel=\"" + @spec.escape(rel) + "\""
  }
  let target_attr = match target {
    Some(t) if !t.is_empty() => " target=\"" + @spec.escape(t) + "\""
    _ => ""
  }
  let out = StringBuilder()
  for word in split_keeping_space(@spec.escape(text)) {
    if word.iter().head().map(is_space).unwrap_or(true) {
      out.write_string(word)
      continue
    }
    let mut middle = word
    let mut head = ""
    for ;; {
      if middle.has_prefix("(") || middle.has_prefix("<") {
        head = head + middle[:1].to_owned()
        middle = middle[1:].to_owned()
      } else if middle.has_prefix("&lt;") {
        head = head + "&lt;"
        middle = middle[4:].to_owned()
      } else {
        break
      }
    }
    let mut tail = ""
    for ;; {
      if middle.has_suffix("&gt;") {
        tail = "&gt;" + tail
        middle = middle[:middle.length() - 4].to_owned()
      } else if middle.length() > 0 &&
        middle[middle.length() - 1] is (')' | '>' | '.' | ',' | '\n') {
        tail = middle[middle.length() - 1:].to_owned() + tail
        middle = middle[:middle.length() - 1].to_owned()
      } else {
        break
      }
    }
    for pair in [("(", ")"), ("<", ">"), ("&lt;", "&gt;")] {
      let (open, close) = pair
      let opens = count_of(middle, open)
      if opens <= count_of(middle, close) {
        continue
      }
      for _ in 0..<opens.min(count_of(tail, close)) {
        let end = tail.find(close).unwrap() + close.length()
        middle = middle + tail[:end].to_owned()
        tail = tail[end:].to_owned()
      }
    }
    if http_match(middle) {
      let href = if middle.to_lower().has_prefix("https://") ||
        middle.to_lower().has_prefix("http://") {
        middle
      } else {
        "https://" + middle
      }
      middle = "<a href=\"\{href}\"\{rel_attr}\{target_attr}>\{trim(middle)}</a>"
    } else if middle.has_prefix("mailto:") && email_match(middle[7:].to_owned()) {
      middle = "<a href=\"\{middle}\">\{middle[7:]}</a>"
    } else if middle.contains("@") &&
      !middle.has_prefix("www.") &&
      !middle.has_prefix("@") &&
      !middle.contains(":") &&
      email_match(middle) {
      middle = "<a href=\"mailto:\{middle}\">\{middle}</a>"
    } else {
      for scheme in schemes {
        if middle != scheme && middle.has_prefix(scheme) {
          middle = "<a href=\"\{middle}\"\{rel_attr}\{target_attr}>\{middle}</a>"
        }
      }
    }
    out.write_string(head + middle + tail)
  }
  out.to_string()
}

///|
fn count_of(s : String, part : String) -> Int32 {
  let mut n = 0
  let mut rest = s[:]
  while rest.find(part) is Some(at) {
    n += 1
    rest = rest[at + part.length():]
  }
  n
}

///|
/// `re.split(r"(\s+)", text)`: words and the whitespace between them.
fn split_keeping_space(text : String) -> Array[String] {
  let out = []
  let current = StringBuilder()
  let mut in_space = false
  for ch in text {
    let space = is_space(ch)
    if space != in_space && !current.is_empty() {
      out.push(current.to_string())
      current.reset()
    }
    in_space = space
    current.write_char(ch)
  }
  if !current.is_empty() {
    out.push(current.to_string())
  }
  out
}

///|
/// The rest of a URL after its host: an optional port of one to five digits,
/// then optionally a path, query or fragment.
fn url_rest(cs : Array[Char], at : Int32) -> Bool {
  let mut i = at
  if i < cs.length() && cs[i] == ':' {
    let start = i + 1
    i = start
    while i < cs.length() && cs[i].is_ascii_digit() {
      i += 1
    }
    if i == start || i - start > 5 {
      return false
    }
  }
  i == cs.length() || cs[i] is ('/' | '?' | '#')
}

///|
/// Jinja's `_http_re`.
fn http_match(s : String) -> Bool {
  let cs = s.iter().collect()
  let lower = s.to_lower()
  let scheme = if lower.has_prefix("https://") {
    8
  } else if lower.has_prefix("http://") {
    7
  } else {
    0
  }
  let mut end = 0
  while end < cs.length() && !(cs[end] is (':' | '/' | '?' | '#')) {
    end += 1
  }
  if scheme > 0 && cs.length() > scheme && cs[scheme] == '[' {
    match first_index(cs[scheme:], c => c == ']') {
      Some(at) =>
        if ipv6(cs[scheme + 1:scheme + at].to_owned()) &&
          url_rest(cs, scheme + at + 1) {
          return true
        }
      None => ()
    }
  }
  let mut host_end = scheme
  while host_end < cs.length() && !(cs[host_end] is (':' | '/' | '?' | '#')) {
    host_end += 1
  }
  if scheme > 0 &&
    ipv4(cs[scheme:host_end].to_owned()) &&
    url_rest(cs, host_end) {
    return true
  }
  let www = scheme == 0 && lower.has_prefix("www.")
  if scheme > 0 || www {
    let start = if www { 4 } else { scheme }
    let labels = String::from_array(cs[start:host_end])
      .split(".")
      .map(l => l.to_owned())
      .collect()
    if url_rest(cs, host_end) && labels.length() >= 1 {
      let tld = labels[labels.length() - 1]
      let ok_labels = labels[:labels.length() - 1]
        .iter()
        .all(l => {
          !l.is_empty() && l.iter().all(c => is_word(c) || c is ('%' | '-'))
        })
      let tl = tld.iter().collect()
      let ok_tld = (
          tl.length() >= 2 &&
          tl.length() <= 63 &&
          tl.iter().all(c => c.is_ascii_alphabetic())
        ) ||
        (
          tld.to_lower().has_prefix("xn--") &&
          tl.length() >= 6 &&
          tl.length() <= 63 &&
          tl[4:].iter().all(c => is_word(c) || c == '%')
        )
      if ok_labels && ok_tld {
        return true
      }
    }
  }
  if scheme == 0 {
    let labels = String::from_array(cs[:end])
      .split(".")
      .map(l => l.to_owned())
      .collect()
    if labels.length() >= 2 && url_rest(cs, end) {
      let tld = labels[labels.length() - 1].to_lower()
      let ok = ["com", "net", "int", "edu", "gov", "org", "info", "mil"].contains(
          tld,
        ) &&
        labels[:labels.length() - 1]
        .iter()
        .all(l => {
          let n = char_count(l)
          n >= 2 && n <= 63 && l.iter().all(c => is_word(c) || c is ('%' | '-'))
        })
      if ok {
        return true
      }
    }
  }
  false
}

///|
fn ipv4(cs : Array[Char]) -> Bool {
  let parts = String::from_array(cs).split(".").collect()
  parts.length() == 4 &&
  parts
  .iter()
  .all(p => {
    p.length() >= 1 && p.length() <= 3 && p.iter().all(c => c.is_ascii_digit())
  })
}

///|
/// `([\da-f]{0,4}:){2}([\da-f]{0,4}:?){1,6}`, case-insensitive: two groups
/// ending in a colon, then the rest cut into at most six groups of up to
/// four hex digits, each with an optional colon.
fn ipv6(cs : Array[Char]) -> Bool {
  if !cs.iter().all(c => c.is_ascii_hexdigit() || c == ':') {
    return false
  }
  let mut i = 0
  for _ in 0..<2 {
    let start = i
    while i < cs.length() && i - start < 4 && cs[i].is_ascii_hexdigit() {
      i += 1
    }
    if i >= cs.length() || cs[i] != ':' {
      return false
    }
    i += 1
  }
  let pieces = String::from_array(cs[i:])
    .split(":")
    .map(p => p.length())
    .collect()
  let mut groups = 0
  for k, len in pieces {
    let last = k == pieces.length() - 1
    groups += if last { (len + 3) / 4 } else { ((len + 3) / 4).max(1) }
  }
  groups <= 6
}

///|
/// Jinja's `_email_re`: `^\S+@\w[\w.-]*\.\w+$`.
fn email_match(s : String) -> Bool {
  let cs = s.iter().collect()
  for at = cs.length() - 1; at >= 1; at = at - 1 {
    if cs[at] != '@' {
      continue
    }
    if cs[:at].iter().any(is_space) {
      continue
    }
    let domain = cs[at + 1:].to_owned()
    if domain.length() < 3 || !is_word(domain[0]) {
      continue
    }
    if !domain.iter().all(c => is_word(c) || c is ('.' | '-')) {
      continue
    }
    match last_index(domain[:], c => c == '.') {
      Some(dot) if dot >= 1 &&
        dot < domain.length() - 1 &&
        domain[dot + 1:].iter().all(is_word) => return true
      _ => ()
    }
  }
  false
}
