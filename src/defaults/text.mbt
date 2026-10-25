///|
/// Python's `str.isspace` for one character: category `Zs`, or bidi class
/// `WS`, `B` or `S`.
fn is_space(ch : Char) -> Bool {
  if ch.is_ascii() {
    return ch
      is (' '
      | '\t'
      | '\n'
      | '\r'
      | '\u{0B}'
      | '\u{0C}'
      | '\u{1C}'
      | '\u{1D}'
      | '\u{1E}'
      | '\u{1F}')
  }
  @moonucd.category(ch) == Zs || @moonucd.bidi(ch) is (WS | B | S)
}

///|
/// Python's `str.isalpha` for one character.
fn is_alpha(ch : Char) -> Bool {
  if ch.is_ascii() {
    return ch.is_ascii_alphabetic()
  }
  @moonucd.category(ch) is (Lu | Ll | Lt | Lm | Lo)
}

///|
/// Python's `str.isalnum` for one character.
fn is_alnum(ch : Char) -> Bool {
  if ch.is_ascii() {
    return ch.is_ascii_alphabetic() || ch.is_ascii_digit()
  }
  is_alpha(ch) || @moonucd.numeric(ch) is Some(_)
}

///|
/// A word character as Python's `re` reads `\w`: alphanumeric or `_`.
fn is_word(ch : Char) -> Bool {
  ch == '_' || is_alnum(ch)
}

///|
/// Python's `str.isdigit` for one character.
fn is_digit(ch : Char) -> Bool {
  if ch.is_ascii() {
    return ch.is_ascii_digit()
  }
  @moonucd.numeric(ch) is Some(Decimal | Digit)
}

///|
fn is_upper_char(ch : Char) -> Bool {
  if ch.is_ascii() {
    return ch.is_ascii_uppercase()
  }
  @moonucd.has(ch, Uppercase)
}

///|
fn is_lower_char(ch : Char) -> Bool {
  if ch.is_ascii() {
    return ch.is_ascii_lowercase()
  }
  @moonucd.has(ch, Lowercase)
}

///|
fn is_title_char(ch : Char) -> Bool {
  !ch.is_ascii() && @moonucd.category(ch) == Lt
}

///|
/// Python's `str.islower`: at least one cased character, none upper- or
/// titlecase.
fn py_islower(s : String) -> Bool {
  let mut cased = false
  for ch in s {
    if is_upper_char(ch) || is_title_char(ch) {
      return false
    }
    if !cased && is_lower_char(ch) {
      cased = true
    }
  }
  cased
}

///|
/// Python's `str.isupper`.
fn py_isupper(s : String) -> Bool {
  let mut cased = false
  for ch in s {
    if is_lower_char(ch) || is_title_char(ch) {
      return false
    }
    if !cased && is_upper_char(ch) {
      cased = true
    }
  }
  cased
}

///|
/// Python's `str.strip`: with no characters given, Unicode whitespace.
fn py_strip(s : String, chars : String?) -> String {
  let cs = s.iter().collect()
  let drop = match chars {
    Some(set) => {
      let members = set.iter().collect()
      (ch : Char) => members.contains(ch)
    }
    None => is_space
  }
  let mut a = 0
  let mut b = cs.length()
  while a < b && drop(cs[a]) {
    a += 1
  }
  while b > a && drop(cs[b - 1]) {
    b -= 1
  }
  String::from_array(cs[a:b])
}

///|
/// Python's `str.split()` with no separator: runs of whitespace.
fn py_split_ws(s : String) -> Array[String] {
  let out = []
  let word = StringBuilder()
  for ch in s {
    if is_space(ch) {
      if !word.is_empty() {
        out.push(word.to_string())
        word.reset()
      }
    } else {
      word.write_char(ch)
    }
  }
  if !word.is_empty() {
    out.push(word.to_string())
  }
  out
}

///|
/// Python's `str.splitlines`.
fn py_splitlines(s : String, keepends : Bool) -> Array[String] {
  let cs = s.iter().collect()
  let out = []
  let mut start = 0
  let mut i = 0
  while i < cs.length() {
    let ch = cs[i]
    if ch
      is ('\n'
      | '\r'
      | '\u{0B}'
      | '\u{0C}'
      | '\u{1C}'
      | '\u{1D}'
      | '\u{1E}'
      | '\u{85}'
      | '\u{2028}'
      | '\u{2029}') {
      let mut end = i + 1
      if ch == '\r' && i + 1 < cs.length() && cs[i + 1] == '\n' {
        end = i + 2
      }
      out.push(String::from_array(cs[start:if keepends { end } else { i }]))
      start = end
      i = end
    } else {
      i += 1
    }
  }
  if start < cs.length() {
    out.push(String::from_array(cs[start:]))
  }
  out
}

///|
/// Python's `str.capitalize`: the first character titlecased, the rest
/// lowercased in the context of the whole string.
fn py_capitalize(s : String) -> String {
  guard s.iter().head() is Some(first) else { return s }
  let whole = @moonucd.lower(s)
  let head = @moonucd.lower(first.to_string())
  @moonucd.title(first.to_string()) + whole[head.length():].to_owned()
}

///|
/// Python's `str.center`, which puts the odd space on the left when the
/// width is odd.
fn py_center(s : String, width : Int32) -> String {
  let len = s.iter().count()
  if len >= width {
    return s
  }
  let margin = width - len
  let left = margin / 2 + (margin & width & 1)
  " ".repeat(left) + s + " ".repeat(margin - left)
}

///|
/// Python's `str.replace`, with an empty `old` inserting `new` between
/// characters; `count < 0` replaces all.
fn py_replace(s : String, old : String, new : String, count : Int32) -> String {
  if old.is_empty() {
    let out = StringBuilder()
    let mut done = 0
    for ch in s {
      if count < 0 || done < count {
        out.write_string(new)
        done += 1
      }
      out.write_char(ch)
    }
    if count < 0 || done < count {
      out.write_string(new)
    }
    return out.to_string()
  }
  if count < 0 {
    return s.replace_all(old~, new~)
  }
  let out = StringBuilder()
  let mut rest = s[:]
  let mut done = 0
  while done < count {
    match rest.find(old) {
      Some(at) => {
        out.write_string(rest[:at].to_owned())
        out.write_string(new)
        rest = rest[at + old.length():]
        done += 1
      }
      None => break
    }
  }
  out.write_string(rest.to_owned())
  out.to_string()
}

///|
/// Jinja's `title`: words begin after `-`, whitespace or an opening
/// bracket; each word's first character goes up, the rest down.
fn jinja_title(s : String) -> String {
  let out = StringBuilder()
  let word : Array[Char] = []
  let flush = fn() {
    if !word.is_empty() {
      let text = String::from_array(word)
      out.write_string(@moonucd.upper(word[0].to_string()))
      out.write_string(@moonucd.lower(text[word[0].utf16_len():]))
      word.clear()
    }
  }
  for ch in s {
    if ch is ('-' | '(' | '{' | '[' | '<') || is_space(ch) {
      flush()
      out.write_char(ch)
    } else {
      word.push(ch)
    }
  }
  flush()
  out.to_string()
}

///|
/// The words Python's `\w+` finds.
fn words(s : String) -> Array[String] {
  let out = []
  let word = StringBuilder()
  for ch in s {
    if is_word(ch) {
      word.write_char(ch)
    } else if !word.is_empty() {
      out.push(word.to_string())
      word.reset()
    }
  }
  if !word.is_empty() {
    out.push(word.to_string())
  }
  out
}

///|
/// A string sliced by code points, as Python slices it.
fn chars_slice(s : String, from : Int32, till : Int32) -> String {
  let cs = s.iter().collect()
  let n = cs.length()
  let a = from.max(0).min(n)
  let b = till.max(a).min(n)
  String::from_array(cs[a:b])
}

///|
fn char_count(s : String) -> Int32 {
  s.iter().count()
}

///|
fn first_index(cs : ArrayView[Char], pred : (Char) -> Bool) -> Int32? {
  for i, c in cs {
    if pred(c) {
      return Some(i)
    }
  }
  None
}

///|
fn last_index(cs : ArrayView[Char], pred : (Char) -> Bool) -> Int32? {
  for i = cs.length() - 1; i >= 0; i = i - 1 {
    if pred(cs[i]) {
      return Some(i)
    }
  }
  None
}

///|
/// Python's `ascii()` of a repr: every character past ASCII as `\x`, `\u`
/// or `\U` with lowercase hex.
fn ascii_of(s : String) -> String {
  let out = StringBuilder()
  for c in s {
    let code = c.to_int()
    if code < 0x80 {
      out.write_char(c)
      continue
    }
    let (prefix, width) = if code <= 0xFF {
      ("\\x", 2)
    } else if code <= 0xFFFF {
      ("\\u", 4)
    } else {
      ("\\U", 8)
    }
    let hex = code.to_string(radix=16)
    out.write_string(prefix + "0".repeat(width - hex.length()) + hex)
  }
  out.to_string()
}
