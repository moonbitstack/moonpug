///|
fn wrap_space(ch : Char) -> Bool {
  ch is ('\t' | '\n' | '\u{0B}' | '\u{0C}' | '\r' | ' ')
}

///|
/// `[^\d\W]`: a word character that is not a decimal digit.
fn wrap_letter(ch : Char) -> Bool {
  is_word(ch) && !(@moonucd.numeric(ch) is Some(Decimal))
}

///|
/// `[\w!"'&.,?]`.
fn wrap_punct(ch : Char) -> Bool {
  is_word(ch) || ch is ('!' | '"' | '\'' | '&' | '.' | ',' | '?')
}

///|
/// The chunks `textwrap` splits a line into: whitespace runs, em-dashes
/// between words, and words, split after a hyphen between letters when
/// `hyphens` is on.
fn wrap_chunks(cs : Array[Char], hyphens : Bool) -> Array[Array[Char]] {
  let n = cs.length()
  let out = []
  let mut i = 0
  let at = fn(k : Int32) { if k >= 0 && k < n { Some(cs[k]) } else { None } }
  let dashes_from = fn(k : Int32) {
    let mut j = k
    while j < n && cs[j] == '-' {
      j += 1
    }
    j - k
  }
  while i < n {
    if wrap_space(cs[i]) {
      let mut j = i
      while j < n && wrap_space(cs[j]) {
        j += 1
      }
      out.push(cs[i:j].to_owned())
      i = j
      continue
    }
    if !hyphens {
      let mut j = i
      while j < n && !wrap_space(cs[j]) {
        j += 1
      }
      out.push(cs[i:j].to_owned())
      i = j
      continue
    }
    if cs[i] == '-' && i > 0 && wrap_punct(cs[i - 1]) {
      let d = dashes_from(i)
      if d >= 2 && at(i + d) is Some(c) && is_word(c) {
        out.push(cs[i:i + d].to_owned())
        i += d
        continue
      }
    }
    let mut j = i + 1
    let mut end = -1
    while j <= n {
      let last = cs[j - 1]
      if wrap_space(last) {
        break
      }
      if last == '-' {
        let two_letters = j >= 3 &&
          wrap_letter(cs[j - 3]) &&
          wrap_letter(cs[j - 2])
        let alternating = j >= 4 &&
          wrap_letter(cs[j - 4]) &&
          cs[j - 3] == '-' &&
          wrap_letter(cs[j - 2])
        let ahead = match (at(j), at(j + 1), at(j + 2)) {
          (Some(a), Some('-'), Some(b)) => wrap_letter(a) && wrap_letter(b)
          (Some(a), Some(b), _) => wrap_letter(a) && wrap_letter(b)
          _ => false
        }
        if (two_letters || alternating) && ahead {
          end = j
          break
        }
      }
      if j == n || wrap_space(cs[j]) {
        end = j
        break
      }
      if wrap_punct(last) &&
        dashes_from(j) >= 2 &&
        at(j + dashes_from(j)) is Some(c) &&
        is_word(c) {
        end = j
        break
      }
      j += 1
    }
    if end < 0 {
      end = j.min(n)
    }
    out.push(cs[i:end].to_owned())
    i = end
  }
  out
}

///|
fn blank_chunk(chunk : Array[Char]) -> Bool {
  chunk.iter().all(is_space)
}

///|
/// Python's `textwrap.wrap` with tabs and whitespace left as they are.
fn wrap(
  line : String,
  width : Int32,
  break_long : Bool,
  hyphens : Bool,
) -> Array[String] raise @spec.Refused {
  if width <= 0 {
    raise @spec.invalid("invalid width \{width} (must be > 0)")
  }
  let chunks = wrap_chunks(line.iter().collect(), hyphens).rev()
  let lines = []
  while !chunks.is_empty() {
    let current : Array[Array[Char]] = []
    let mut length = 0
    if blank_chunk(chunks[chunks.length() - 1]) && !lines.is_empty() {
      ignore(chunks.pop())
    }
    while !chunks.is_empty() {
      let l = chunks[chunks.length() - 1].length()
      if length + l <= width {
        current.push(chunks.pop().unwrap())
        length += l
      } else {
        break
      }
    }
    if !chunks.is_empty() && chunks[chunks.length() - 1].length() > width {
      let space_left = if width < 1 { 1 } else { width - length }
      if break_long {
        let chunk = chunks[chunks.length() - 1]
        let mut end = space_left
        if hyphens && chunk.length() > space_left {
          let mut hyphen = -1
          for k in 0..<space_left.min(chunk.length()) {
            if chunk[k] == '-' {
              hyphen = k
            }
          }
          if hyphen > 0 && chunk[:hyphen].iter().any(c => c != '-') {
            end = hyphen + 1
          }
        }
        current.push(chunk[:end].to_owned())
        chunks[chunks.length() - 1] = chunk[end:].to_owned()
      } else if current.is_empty() {
        current.push(chunks.pop().unwrap())
      }
      length = current.fold(init=0, (acc, c) => acc + c.length())
    }
    if !current.is_empty() && blank_chunk(current[current.length() - 1]) {
      length -= current[current.length() - 1].length()
      ignore(current.pop())
    }
    if !current.is_empty() {
      lines.push(String::from_array(current.fold(init=[], (acc, c) => acc + c)))
    }
  }
  lines
}
