///|
/// One token. Template text and the delimiters of the brace syntax sit in
/// the same stream as the tokens inside tags, as in Jinja's lexer.
pub(all) enum Tok {
  Data(String)
  VarBegin
  VarEnd
  BlockBegin
  BlockEnd
  Name(String)
  Str(String)
  Int(Int64)
  Float(Double)
  Op(String)
  /// A language block's language, its force if given, and its body.
  Lang(String, Bool?, String)
  Eof
} derive(Eq)

///|
pub extend Tok with Eq::{equal, not_equal}

///|
pub(all) struct Token {
  tok : Tok
  line : Int32
  column : Int32
}

///|
/// How the brace syntax reads whitespace and line-oriented tags.
pub(all) struct Options {
  trim_blocks : Bool
  lstrip_blocks : Bool
  keep_trailing_newline : Bool
  line_statement : String?
  line_comment : String?
}

///|
/// The operators a tag may hold, longest first so `//` wins over `/`.
let operators : Array[String] = [
  "**", "//", "==", "!=", ">=", "<=", "+", "-", "/", "*", "%", "~", "[", "]", "(",
  ")", "{", "}", ">", "<", "=", ".", ":", "|", ",", ";",
]

///|
/// A cursor over source text that knows its line and column.
pub(all) struct Lexer {
  src : String
  template : String
  mut pos : Int32
  mut line : Int32
  mut line_start : Int32
}

///|
pub fn Lexer::new(
  src : String,
  template : String,
  pos~ : Int32 = 0,
  line~ : Int32 = 1,
  line_start~ : Int32 = 0,
) -> Lexer {
  { src, template, pos, line, line_start, }
}

///|
pub fn Lexer::column(self : Lexer) -> Int32 {
  self.pos - self.line_start + 1
}

///|
pub fn Lexer::fail(self : Lexer, reason : String) -> @spec.Refused {
  Syntax(template=self.template, line=self.line, column=self.column(), reason~)
}

///|
fn Lexer::at_end(self : Lexer) -> Bool {
  self.pos >= self.src.length()
}

///|
fn Lexer::peek(self : Lexer, ahead~ : Int32 = 0) -> Int32 {
  let i = self.pos + ahead
  if i < self.src.length() {
    self.src.code_unit_at(i).to_int()
  } else {
    -1
  }
}

///|
fn Lexer::starts(self : Lexer, word : String) -> Bool {
  starts_at(self.src, word, self.pos)
}

///|
/// Whether `word` occurs in `src` at `at`.
fn starts_at(src : String, word : String, at : Int32) -> Bool {
  at >= 0 &&
  at + word.length() <= src.length() &&
  src[at:at + word.length()] == word
}

///|
/// Move to `to`, counting the newlines passed.
fn Lexer::advance(self : Lexer, to : Int32) -> Unit {
  for i in self.pos..<to {
    if self.src.code_unit_at(i) == '\n' {
      self.line += 1
      self.line_start = i + 1
    }
  }
  self.pos = to
}

///|
fn is_space(unit : Int32) -> Bool {
  unit == ' ' ||
  unit == '\t' ||
  unit == '\n' ||
  unit == '\r' ||
  unit == 0x0B ||
  unit == 0x0C
}

///|
fn is_digit(unit : Int32) -> Bool {
  unit >= '0' && unit <= '9'
}

///|
fn is_name_start(unit : Int32) -> Bool {
  (unit >= 'a' && unit <= 'z') ||
  (unit >= 'A' && unit <= 'Z') ||
  unit == '_' ||
  (unit >= 0x80 && !is_space(unit))
}

///|
fn is_name_part(unit : Int32) -> Bool {
  is_name_start(unit) || is_digit(unit)
}

///|
fn Lexer::skip_space(self : Lexer) -> Unit {
  let mut i = self.pos
  while i < self.src.length() && is_space(self.src.code_unit_at(i).to_int()) {
    i += 1
  }
  self.advance(i)
}

///|
/// The next token inside a tag. Whitespace between tokens is skipped; `Eof`
/// at the end of the text.
pub fn Lexer::token(self : Lexer) -> Token raise @spec.Refused {
  self.skip_space()
  let line = self.line
  let column = self.column()
  let tok = self.read_token()
  { tok, line, column, }
}

///|
fn Lexer::read_token(self : Lexer) -> Tok raise @spec.Refused {
  if self.at_end() {
    return Eof
  }
  let unit = self.peek()
  if is_digit(unit) {
    return self.read_number()
  }
  if is_name_start(unit) {
    let start = self.pos
    let mut i = start
    while i < self.src.length() &&
          is_name_part(self.src.code_unit_at(i).to_int()) {
      i += 1
    }
    self.advance(i)
    return Name(self.src[start:i].to_owned())
  }
  if unit == '\'' || unit == '"' {
    return Str(self.read_string())
  }
  for op in operators {
    if self.starts(op) {
      self.advance(self.pos + op.length())
      return Op(op)
    }
  }
  raise self.fail("unexpected character \{self.src[self.pos:self.pos + 1]}")
}

///|
/// An integer or float literal in Python's spelling: `0x`, `0o`, `0b`
/// prefixes and `_` between digits.
fn Lexer::read_number(self : Lexer) -> Tok raise @spec.Refused {
  let start = self.pos
  let src = self.src
  let n = src.length()
  let unit = self.peek()
  let next = self.peek(ahead=1)
  if unit == '0' && next >= 0 {
    let radix = match next {
      'x' | 'X' => 16
      'o' | 'O' => 8
      'b' | 'B' => 2
      _ => 0
    }
    if radix > 0 {
      let mut i = start + 2
      while i < n &&
            (
              is_digit_in(src.code_unit_at(i).to_int(), radix) ||
              src.code_unit_at(i) == '_'
            ) {
        i += 1
      }
      self.advance(i)
      let digits = src[start + 2:i].to_owned().replace_all(old="_", new="")
      return Int(@string.parse_int64(digits, base=radix)) catch {
        _ => raise self.fail("malformed number \{src[start:i]}")
      }
    }
  }
  let mut i = start
  while i < n &&
        (is_digit(src.code_unit_at(i).to_int()) || src.code_unit_at(i) == '_') {
    i += 1
  }
  let mut float = false
  let after_dot = start > 0 && src.code_unit_at(start - 1) == '.'
  if !after_dot &&
    i < n &&
    src.code_unit_at(i) == '.' &&
    i + 1 < n &&
    is_digit(src.code_unit_at(i + 1).to_int()) {
    float = true
    i += 1
    while i < n &&
          (is_digit(src.code_unit_at(i).to_int()) || src.code_unit_at(i) == '_') {
      i += 1
    }
  }
  if !after_dot &&
    i < n &&
    (src.code_unit_at(i) == 'e' || src.code_unit_at(i) == 'E') {
    let mut j = i + 1
    if j < n && (src.code_unit_at(j) == '+' || src.code_unit_at(j) == '-') {
      j += 1
    }
    if j < n && is_digit(src.code_unit_at(j).to_int()) {
      float = true
      while j < n &&
            (
              is_digit(src.code_unit_at(j).to_int()) ||
              src.code_unit_at(j) == '_'
            ) {
        j += 1
      }
      i = j
    }
  }
  let text = src[start:i].to_owned().replace_all(old="_", new="")
  if !float &&
    text.length() > 1 &&
    text.has_prefix("0") &&
    text.iter().any(ch => ch != '0') {
    raise self.fail("leading zeros are not allowed in \{text}")
  }
  let number = if float {
    Float(@string.parse_double(text)) catch {
      _ => raise self.fail("malformed number \{text}")
    }
  } else {
    Int(@string.parse_int64(text)) catch {
      _ => raise self.fail("integer out of range: \{text}")
    }
  }
  self.advance(i)
  number
}

///|
fn is_digit_in(unit : Int32, radix : Int32) -> Bool {
  match radix {
    16 =>
      is_digit(unit) ||
      (unit >= 'a' && unit <= 'f') ||
      (unit >= 'A' && unit <= 'F')
    8 => unit >= '0' && unit <= '7'
    _ => unit == '0' || unit == '1'
  }
}

///|
/// A quoted string with Python's escapes. It may span lines.
fn Lexer::read_string(self : Lexer) -> String raise @spec.Refused {
  let quote = self.peek()
  let line = self.line
  let column = self.column()
  let src = self.src
  let n = src.length()
  let out = StringBuilder()
  let mut i = self.pos + 1
  let mut run = i
  while i < n {
    let unit = src.code_unit_at(i).to_int()
    if unit == quote {
      out.write_string(src[run:i].to_owned())
      self.advance(i + 1)
      return out.to_string()
    }
    if unit == '\\' && i + 1 < n {
      out.write_string(src[run:i].to_owned())
      i = read_escape(src, i + 1, out)
      run = i
    } else {
      i += 1
    }
  }
  raise Syntax(
    template=self.template,
    line~,
    column~,
    reason="the string is never closed",
  )
}

///|
/// One escape after a backslash, written to `out`; returns where reading
/// continues. Unknown escapes keep their backslash, as Python does.
fn read_escape(src : String, at : Int32, out : StringBuilder) -> Int32 {
  let unit = src.code_unit_at(at).to_int()
  match unit {
    'n' => out.write_char('\n')
    't' => out.write_char('\t')
    'r' => out.write_char('\r')
    'a' => out.write_char('\u{07}')
    'b' => out.write_char('\u{08}')
    'f' => out.write_char('\u{0C}')
    'v' => out.write_char('\u{0B}')
    '\\' => out.write_char('\\')
    '\'' => out.write_char('\'')
    '"' => out.write_char('"')
    '\n' => ()
    'x' | 'u' | 'U' => {
      let width = match unit {
        'x' => 2
        'u' => 4
        _ => 8
      }
      match hex_value(src, at + 1, width) {
        Some(code) => {
          out.write_char(code.unsafe_to_char())
          return at + 1 + width
        }
        None => {
          out.write_char('\\')
          out.write_char(unit.unsafe_to_char())
        }
      }
    }
    _ if unit >= '0' && unit <= '7' => {
      let mut value = 0
      let mut i = at
      while i < at + 3 && i < src.length() {
        let d = src.code_unit_at(i).to_int()
        if d < '0' || d > '7' {
          break
        }
        value = value * 8 + (d - '0')
        i += 1
      }
      out.write_char(value.unsafe_to_char())
      return i
    }
    _ => {
      out.write_char('\\')
      out.write_char(unit.unsafe_to_char())
    }
  }
  at + 1
}

///|
fn hex_value(src : String, at : Int32, width : Int32) -> Int32? {
  if at + width > src.length() {
    return None
  }
  let mut value = 0
  for i in at..<(at + width) {
    let d = src.code_unit_at(i).to_int()
    let digit = if is_digit(d) {
      d - '0'
    } else if d >= 'a' && d <= 'f' {
      d - 'a' + 10
    } else if d >= 'A' && d <= 'F' {
      d - 'A' + 10
    } else {
      return None
    }
    value = value * 16 + digit
  }
  if value > 0x10FFFF {
    None
  } else {
    Some(value)
  }
}

///|
/// The tokens of one tag, up to the closer `ends` names: brackets must be
/// balanced before a closer counts, so `{{ {'a': 1} }}` reads as one
/// expression.
fn Lexer::tag(
  self : Lexer,
  out : Array[Token],
  ends : (Lexer) -> Bool,
) -> (Int32, Int32) raise @spec.Refused {
  let open : Array[String] = []
  for ;; {
    let (line, column) = (self.line, self.column())
    if open.is_empty() && ends(self) {
      return (line, column)
    }
    self.skip_space()
    let (line, column) = (self.line, self.column())
    if open.is_empty() && ends(self) {
      return (line, column)
    }
    let token = self.token()
    match token.tok {
      Eof => raise self.fail("the tag is never closed")
      Op("(") => open.push(")")
      Op("[") => open.push("]")
      Op("{") => open.push("}")
      Op(")" | "]" | "}" as close) =>
        match open.pop() {
          Some(want) if want == close => ()
          Some(want) =>
            raise Syntax(
              template=self.template,
              line=token.line,
              column=token.column,
              reason="unexpected \{close}, expected \{want}",
            )
          None =>
            raise Syntax(
              template=self.template,
              line=token.line,
              column=token.column,
              reason="unexpected \{close}",
            )
        }
      _ => ()
    }
    out.push(token)
  }
}

///|
/// The tokens of a bare expression, as the indentation syntax and
/// interpolation read them: everything to the end of the text.
pub fn lex_expression(
  src : String,
  template : String,
  line~ : Int32 = 1,
  column~ : Int32 = 1,
) -> Array[Token] raise @spec.Refused {
  let lexer = Lexer::new(src, template, line~, line_start=1 - column)
  let out = []
  ignore(lexer.tag(out, l => l.at_end()))
  out.push({ tok: Eof, line: lexer.line, column: lexer.column(), })
  out
}
