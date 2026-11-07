///|
/// The mark a held-back stretch leaves in the text around it: private-use
/// characters, which no Markdown reader makes anything of, with the number
/// of the piece held back between them.
let slot_open : String = "\u{E000}"

///|
let slot_close : String = "\u{E001}"

///|
fn slot_mark(index : Int32) -> String {
  slot_open + index.to_string() + slot_close
}

///|
/// Render a stretch of one language. What it writes goes through that
/// language's conversion, `Lang.finish`; when the stretch around it converts
/// its own text too, the result is held back under a mark, so the outer
/// conversion cannot touch it, and the marks are replaced once it is done.
fn Run::run_stretch(
  self : Run,
  reading : Reading,
  body : Array[@syntax.Node],
) -> Unit raise @spec.Refused {
  let finish = reading.lang.finish
  if finish is None && self.slots.is_empty() {
    self.run_nodes(body)
    return
  }
  let (text, held) = self.capture_slots(reading, () => self.run_nodes(body))
  let converted = match finish {
    Some(f) => f(text, reading)
    None => text
  }
  let result = if held.is_empty() {
    converted
  } else {
    restore(converted, held)
  }
  if self.slots.is_empty() {
    self.write(result)
  } else {
    let outer = self.slots[self.slots.length() - 1]
    let index = outer.length()
    outer.push(result)
    let block = self.at_line_start
    if block {
      self.write("\n")
    }
    self.write(slot_mark(index))
    if block {
      self.write("\n\n")
    }
  }
}

///|
/// Run `body` in the reading `reading` with output going to a fresh buffer
/// and a slot table of its own, and return what it wrote with what nested
/// stretches held back.
fn Run::capture_slots(
  self : Run,
  reading : Reading,
  body : () -> Unit raise @spec.Refused,
) -> (String, Array[String]) raise @spec.Refused {
  let outer_out = self.out
  let written = self.written
  let extended = self.extended
  let at_line_start = self.at_line_start
  let current = self.current
  let held : Array[String] = []
  self.out = StringBuilder()
  self.written = 0
  self.extended = false
  self.at_line_start = true
  self.current = Some(reading)
  self.slots.push(held)
  defer {
    ignore(self.slots.pop())
    self.out = outer_out
    self.written = written
    self.extended = extended
    self.at_line_start = at_line_start
    self.current = current
  }
  body()
  (self.out.to_string(), held)
}

///|
/// The number a mark carries, or `None` when the marks do not hold one.
fn slot_number(digits : StringView) -> Int32? {
  if digits.is_empty() || digits.length() > 9 {
    return None
  }
  let mut n = 0
  for i in 0..<digits.length() {
    let c = digits[i]
    if c < '0' || c > '9' {
      return None
    }
    n = n * 10 + (c.to_int() - '0'.to_int())
  }
  Some(n)
}

///|
/// Put the held-back pieces back where their marks stand. A mark that came
/// out as a paragraph of its own takes the paragraph with it: a block of HTML
/// belongs between the blocks around it, not inside a `<p>`.
fn restore(text : String, held : Array[String]) -> String {
  let out = StringBuilder()
  let mut cursor = 0
  let mut base = 0
  let mut rest : StringView = text[:]
  while rest.find(slot_open) is Some(at) {
    let head = base + at
    let tail = rest[at + slot_open.length():]
    guard tail.find(slot_close) is Some(width) else { break }
    let end = head + slot_open.length() + width + slot_close.length()
    match slot_number(tail[:width]) {
      Some(index) if index >= 0 && index < held.length() => {
        let mut from = head
        let mut to = end
        if from >= 3 &&
          text[from - 3:from] == "<p>" &&
          to + 4 <= text.length() &&
          text[to:to + 4] == "</p>" {
          from -= 3
          to += 4
          // The paragraph's own newline and the block's are the same one.
          if to + 1 <= text.length() &&
            text[to:to + 1] == "\n" &&
            held[index].has_suffix("\n") {
            to += 1
          }
        }
        out.write_view(text[cursor:from])
        out.write_string(held[index])
        cursor = to
      }
      _ => ()
    }
    rest = rest[end - base:]
    base = end
  }
  out.write_view(text[cursor:])
  out.to_string()
}
