///|
let entities : Ref[Map[String, String]?] = Ref(None)

///|
fn entity_table() -> Map[String, String] {
  match entities.val {
    Some(table) => table
    None => {
      let table = Map([])
      for line in entity_data.split("\n") {
        match line.find("\t") {
          Some(at) => table[line[:at].to_owned()] = line[at + 1:].to_owned()
          None => ()
        }
      }
      entities.val = Some(table)
      table
    }
  }
}

///|
/// Python's `html.unescape`: named references (the longest name that
/// matches, with or without its semicolon where HTML allows), decimal and
/// hexadecimal references with HTML's replacements for the invalid ones.
fn html_unescape(s : String) -> String {
  if !s.contains("&") {
    return s
  }
  let cs = s.iter().collect()
  let n = cs.length()
  let out = StringBuilder()
  let mut i = 0
  while i < n {
    if cs[i] != '&' {
      out.write_char(cs[i])
      i += 1
      continue
    }
    match charref(cs, i + 1) {
      Some((text, after)) => {
        out.write_string(text)
        i = after
      }
      None => {
        out.write_char('&')
        i += 1
      }
    }
  }
  out.to_string()
}

///|
/// The reference after an `&` at `at`: its text and where reading resumes.
fn charref(cs : Array[Char], at : Int32) -> (String, Int32)? {
  let n = cs.length()
  if at >= n {
    return None
  }
  if cs[at] == '#' {
    let hex = at + 1 < n && cs[at + 1] is ('x' | 'X')
    let start = if hex { at + 2 } else { at + 1 }
    let mut j = start
    while j < n &&
          (if hex { cs[j].is_ascii_hexdigit() } else { cs[j].is_ascii_digit() }) {
      j += 1
    }
    if j == start {
      return None
    }
    let digits = String::from_array(cs[start:j])
    let after = if j < n && cs[j] == ';' { j + 1 } else { j }
    let num = @bigint.BigInt::from_string(
      digits,
      radix=if hex { 16 } else { 10 },
    )
    let text = if num.compare_int(0x10FFFF) > 0 {
      "\u{FFFD}"
    } else {
      let cp = num.to_int()
      match charref_replacements.iter().find_first(pair => pair.0 == cp) {
        Some((_, replacement)) => replacement
        None =>
          if cp >= 0xD800 && cp <= 0xDFFF {
            "\u{FFFD}"
          } else if charref_dropped.contains(cp) {
            ""
          } else {
            cp.unsafe_to_char().to_string()
          }
      }
    }
    return Some((text, after))
  }
  let mut j = at
  while j < n &&
        j - at < 32 &&
        !(cs[j] is ('\t' | '\n' | '\u{0C}' | ' ' | '<' | '&' | '#' | ';')) {
    j += 1
  }
  if j == at {
    return None
  }
  let semicolon = j < n && cs[j] == ';'
  let name = String::from_array(cs[at:j]) + (if semicolon { ";" } else { "" })
  let table = entity_table()
  match table.get(name) {
    Some(text) => return Some((text, if semicolon { j + 1 } else { j }))
    None => ()
  }
  let chars = name.iter().collect()
  for x = chars.length() - 1; x > 1; x = x - 1 {
    let prefix = String::from_array(chars[:x])
    match table.get(prefix) {
      Some(text) => return Some((text, at + x))
      None => ()
    }
  }
  Some(("&" + name, if semicolon { j + 1 } else { j }))
}
