///|
/// The elements Django's parser leaves without a closing tag: HTML's void
/// set, which the indentation syntax writes as `<br>`, plus the two
/// deprecated ones it still knows, `frame` and `spacer`.
let void_elements : Array[String] = [
  "area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param",
  "source", "track", "wbr", "frame", "spacer",
]

///|
/// A cut in progress: the bound, what has been written, the tags still open
/// and whether the text ran out before the bound did.
priv struct Cut {
  by_words : Bool
  length : Int32
  raw_len : Int32
  suffix : String
  out : StringBuilder
  open : Array[String]
  mut remaining : Int32
  mut processed : Int32
  mut written : Int32
  mut done : Bool
}

///|
fn Cut::new(
  length : Int32,
  by_words : Bool,
  suffix : String,
  raw_len : Int32,
) -> Cut {
  {
    by_words,
    length,
    raw_len,
    suffix,
    out: StringBuilder(),
    open: [],
    remaining: if by_words {
      length
    } else {
      length - 1
    },
    processed: 0,
    written: 0,
    done: false,
  }
}

///|
fn Cut::emit(self : Cut, text : String) -> Unit {
  if text.is_empty() {
    return
  }
  self.out.write_string(text)
  self.written += text.iter().count()
}

///|
/// The text with the notice of a cut, unless it already ends with one.
fn Cut::noticed(self : Cut, text : String) -> String {
  if !self.suffix.is_empty() && text.has_suffix(self.suffix) {
    text
  } else {
    text + self.suffix
  }
}

///|
/// A run of text between tags: escaped, cut where the bound falls.
fn Cut::data(self : Cut, text : String) -> Unit {
  if self.done || text.is_empty() {
    return
  }
  let parts = if self.by_words { word_parts(text) } else { [] }
  let count = if self.by_words { parts.length() } else { text.iter().count() }
  let kept = if self.by_words {
    let take = self.remaining.max(0).min(parts.length())
    let pieces = if take == 0 { [] } else { parts[:take].to_owned() }
    @spec.escape(pieces.join(" "))
  } else {
    @spec.escape(prefix_of(text, self.remaining))
  }
  if !self.by_words {
    self.processed += count
    if self.processed == self.length && self.written + count == self.raw_len {
      // The bound falls exactly at the end of the text: nothing is cut, and
      // nothing in it is escaped, which is what Django writes here.
      self.emit(text)
      self.done = true
      return
    }
  }
  if self.remaining < count {
    self.remaining = 0
    self.emit(self.noticed(kept))
    self.done = true
  } else {
    self.remaining -= count
    self.emit(kept)
  }
}

///|
/// A start tag, as it was written, and the name that decides whether it
/// stays open.
fn Cut::start_tag(
  self : Cut,
  raw : String,
  name : String,
  empty : Bool,
) -> Unit {
  if self.done {
    return
  }
  self.emit(raw)
  if void_elements.contains(name) {
    return
  }
  if empty {
    self.emit("</" + name + ">")
  } else {
    self.open.push(name)
  }
}

///|
fn Cut::end_tag(self : Cut, name : String) -> Unit {
  if self.done || void_elements.contains(name) {
    return
  }
  self.emit("</" + name + ">")
  if !self.open.is_empty() && self.open[self.open.length() - 1] == name {
    ignore(self.open.pop())
  }
}

///|
/// The text. Tags the cut left open are closed only when the cut happened:
/// a text that ends before the bound is written as it stands.
fn Cut::finish(self : Cut) -> String {
  while self.done && !self.open.is_empty() {
    let name = self.open.pop().unwrap()
    self.out.write_string("</" + name + ">")
  }
  self.out.to_string()
}

///|
/// The first `n` characters of `text`.
fn prefix_of(text : String, n : Int32) -> String {
  if n <= 0 {
    return ""
  }
  let out = StringBuilder()
  for i, ch in text {
    if i >= n {
      break
    }
    out.write_char(ch)
  }
  out.to_string()
}

///|
/// Django's split of a run of text into words and the whitespace that
/// separates them, dropped as `re.split` drops it.
fn word_parts(text : String) -> Array[String] {
  let cs = text.iter().collect()
  let n = cs.length()
  let out = []
  let mut i = 0
  let mut run_start = 0
  while i < n {
    if is_space(cs[i]) {
      // A run of whitespace between two other characters separates words.
      let mut j = i
      while j < n && is_space(cs[j]) {
        j += 1
      }
      if i > run_start && j < n {
        out.push(String::from_array(cs[run_start:i]))
        run_start = j
      }
      i = j
    } else {
      i += 1
    }
  }
  if run_start < n {
    out.push(String::from_array(cs[run_start:]))
  }
  out
}

///|
/// Whether a character can begin a tag name.
fn is_tag_letter(ch : Char) -> Bool {
  (ch >= 'a' && ch <= 'z') || (ch >= 'A' && ch <= 'Z')
}

///|
/// The text from `at` up to the next tag that starts a construct of its
/// own; a `<` that starts nothing is text like the rest.
fn data_end(cs : Array[Char], at : Int32) -> Int32 {
  let n = cs.length()
  let mut i = at + 1
  while i < n {
    if cs[i] == '<' && starts_chars(cs, i, "<!--") {
      return i
    }
    if cs[i] == '<' &&
      i + 1 < n &&
      (
        cs[i + 1] == '!' ||
        cs[i + 1] == '?' ||
        (i + 2 < n && cs[i + 1] == '/' && is_tag_letter(cs[i + 2])) ||
        is_tag_letter(cs[i + 1])
      ) {
      return i
    }
    i += 1
  }
  n
}

///|
fn starts_chars(cs : Array[Char], at : Int32, word : String) -> Bool {
  let w = word.iter().collect()
  if at + w.length() > cs.length() {
    return false
  }
  for i, ch in w {
    if cs[at + i] != ch {
      return false
    }
  }
  true
}

///|
/// Where the `>` that ends a tag written from `at` sits, or `None` when the
/// text ends first.
fn tag_end(cs : Array[Char], at : Int32) -> Int32? {
  let n = cs.length()
  let mut i = at
  let mut quote : Char? = None
  while i < n {
    let ch = cs[i]
    match quote {
      Some(q) => if ch == q { quote = None }
      None =>
        if ch is ('"' | '\'') {
          quote = Some(ch)
        } else if ch == '>' {
          return Some(i)
        }
    }
    i += 1
  }
  None
}

///|
/// The name of the tag written from `at`, lowercased, and whether it ends
/// with `/` before its `>`.
fn tag_head(cs : Array[Char], at : Int32, end : Int32) -> (String, Bool, Int32) {
  let mut i = at
  while i < end && !is_space(cs[i]) && cs[i] != '/' && cs[i] != '>' {
    i += 1
  }
  let name = String::from_array(cs[at:i]).to_lower()
  let mut empty = false
  let mut j = end
  while j > i {
    if is_space(cs[j - 1]) {
      j -= 1
    } else {
      empty = cs[j - 1] == '/'
      break
    }
  }
  (name, empty, i)
}

///|
/// Truncate `text` the way Django's `Truncator` does, closing the elements
/// the cut leaves open.
fn cut_html(
  text : String,
  length : Int32,
  by_words : Bool,
  suffix : String,
) -> String {
  let cs = text.iter().collect()
  let n = cs.length()
  let cut = Cut::new(length, by_words, suffix, n)
  let mut i = 0
  while i < n && !cut.done {
    let ch = cs[i]
    if ch == '<' {
      if starts_chars(cs, i, "<!--") {
        match find_chars(cs, i + 4, "-->") {
          Some(at) => i = at + 3
          None => {
            cut.data(html_unescape(String::from_array(cs[i:])))
            i = n
          }
        }
        continue
      }
      if i + 1 < n && (cs[i + 1] == '!' || cs[i + 1] == '?') {
        match tag_end(cs, i) {
          Some(at) => i = at + 1
          None => {
            cut.data(html_unescape(String::from_array(cs[i:])))
            i = n
          }
        }
        continue
      }
      if i + 2 < n && cs[i + 1] == '/' && is_tag_letter(cs[i + 2]) {
        match tag_end(cs, i + 2) {
          Some(at) => {
            let (name, _, _) = tag_head(cs, i + 2, at)
            cut.end_tag(name)
            i = at + 1
          }
          None => {
            cut.data(html_unescape(String::from_array(cs[i:])))
            i = n
          }
        }
        continue
      }
      if i + 1 < n && is_tag_letter(cs[i + 1]) {
        match tag_end(cs, i + 1) {
          Some(at) => {
            let (name, empty, _) = tag_head(cs, i + 1, at)
            cut.start_tag(String::from_array(cs[i:at + 1]), name, empty)
            i = at + 1
          }
          None => {
            cut.data(html_unescape(String::from_array(cs[i:])))
            i = n
          }
        }
        continue
      }
    }
    let stop = data_end(cs, i)
    cut.data(html_unescape(String::from_array(cs[i:stop])))
    i = stop
  }
  cut.finish()
}

///|
fn find_chars(cs : Array[Char], at : Int32, word : String) -> Int32? {
  let n = cs.length()
  let mut i = at
  while i < n {
    if starts_chars(cs, i, word) {
      return Some(i)
    }
    i += 1
  }
  None
}

///|
/// A character Python's `\s` matches: ASCII whitespace and the separators
/// it also counts.
fn py_space(ch : Char) -> Bool {
  is_space(ch) || (ch.to_int() >= 0x1C && ch.to_int() <= 0x1F)
}

///|
/// Django's `slugify`: decomposed, ASCII only, lowercase, one dash for each
/// run of spaces and dashes, then no dash or underscore at either end.
fn filter_slugify(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("slugify", [], args, named))
  let ascii = StringBuilder()
  for ch in @normalize.normalize(NFKD, soft(call, value)) {
    if ch.to_int() < 0x80 {
      ascii.write_char(ch)
    }
  }
  let out = StringBuilder()
  let mut dash = false
  for ch in ascii.to_string().to_lower() {
    if ch == '-' || py_space(ch) {
      dash = true
      continue
    }
    if !(ch.is_ascii_alphabetic() || ch.is_ascii_digit() || ch == '_') {
      continue
    }
    if dash && !out.is_empty() {
      out.write_char('-')
    }
    dash = false
    out.write_char(ch)
  }
  let text = out.to_string().trim(chars="-_").to_owned()
  same_kind(value, text)
}

///|
/// Django's `Truncator.chars` on a plain string: composed first, combining
/// marks not counted, the last place left for the ellipsis.
fn cut_chars(text : String, length : Int32) -> String {
  let text = @normalize.normalize(NFC, text)
  let cs = text.iter().collect()
  let room = length - 1
  let mut count = 0
  let mut end = -1
  for i, ch in cs {
    if @normalize.combining(ch) != 0 {
      continue
    }
    count += 1
    if end < 0 && count > room {
      end = i
    }
    if count > length {
      return String::from_array(cs[:if end < 0 { 0 } else { end }]) + "…"
    }
  }
  text
}

///|
/// A length argument, or `None` when Django's `int()` would refuse it and
/// the filter leaves the value as it stands.
fn length_of(arg : @spec.Value) -> Int32? raise @spec.Refused {
  guard python_int(arg) is Some(n) else { return None }
  if n <= 0L {
    Some(0)
  } else if n > 1000000000L {
    Some(1000000000)
  } else {
    Some(n.to_int())
  }
}

///|
fn filter_truncatechars(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let arg = bind("truncatechars", ["arg"], args, named).need("arg")
  let text = soft(call, value)
  guard length_of(arg) is Some(length) else { return value }
  if length == 0 {
    return Text("")
  }
  same_kind(value, cut_chars(text, length))
}

///|
fn filter_truncatechars_html(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let arg = bind("truncatechars_html", ["arg"], args, named).need("arg")
  let text = soft(call, value)
  guard length_of(arg) is Some(length) else { return value }
  if length == 0 {
    return Text("")
  }
  let cut = cut_html(@normalize.normalize(NFC, text), length, false, "…")
  same_kind(value, cut)
}

///|
fn filter_truncatewords_html(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let arg = bind("truncatewords_html", ["arg"], args, named).need("arg")
  let text = soft(call, value)
  guard length_of(arg) is Some(length) else { return value }
  if length == 0 {
    return Text("")
  }
  same_kind(value, cut_html(text, length, true, " …"))
}
