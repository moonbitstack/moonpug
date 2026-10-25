///|
/// A language a template or a `{% block lang=… %}` is read in: its name,
/// the other names it answers to, how its brace tags treat whitespace, and
/// the reader that turns its source into the tree. The three built in are
/// registered the same way a user's own is.
pub(all) struct Lang {
  name : String
  aliases : Array[String]
  options : Options
  read : (String, Reading) -> Array[Node] raise @spec.Refused
}

///|
/// Where a reader stands: the language and whether it is forced, the
/// template and the line the source starts on, the brace options in effect,
/// and the languages a block may name.
pub(all) struct Reading {
  lang : Lang
  force : Bool
  template : String
  line : Int32
  options : Options
  langs : (String) -> Lang?
}

///|
/// Whether a block in `inner` is read inside this stretch. A forced stretch
/// reads its own language and, outside HTML, HTML; any other block stays
/// text, markers and all.
pub fn Reading::allows(self : Reading, inner : Lang) -> Bool {
  !self.force ||
  inner.name == self.lang.name ||
  (self.lang.name != "html" && inner.name == "html")
}

///|
/// The reading inside a block starting at `line`: its own language and
/// options, and its own force when it gives one, else the enclosing
/// stretch's. A block in the stretch's own language keeps its options; line
/// prefixes carry through.
pub fn Reading::inside(
  self : Reading,
  lang : Lang,
  force : Bool?,
  line : Int32,
) -> Reading {
  let options = if lang.name == self.lang.name {
    self.options
  } else {
    {
      ..lang.options,
      line_statement: self.options.line_statement,
      line_comment: self.options.line_comment,
    }
  }
  { ..self, lang, force: force.unwrap_or(self.force), line, options, }
}

///|
/// A block in the language named `name`, read into the tree; a reader of a
/// user's own language calls this for the blocks it finds.
pub fn Reading::block(
  self : Reading,
  source : String,
  name : String,
  force : Bool?,
  line : Int32,
) -> Array[Node] raise @spec.Refused {
  match (self.langs)(name) {
    Some(lang) => read(source, self.inside(lang, force, line))
    None => raise Unknown(template=self.template, line~, kind="language", name~)
  }
}

///|
/// A source read in the reading's language.
pub fn read(
  source : String,
  reading : Reading,
) -> Array[Node] raise @spec.Refused {
  (reading.lang.read)(source, reading)
}

///|
/// Brace options with nothing trimmed and no line prefixes.
pub let options : Options = {
  trim_blocks: false,
  lstrip_blocks: false,
  keep_trailing_newline: false,
  line_statement: None,
  line_comment: None,
}

///|
/// HTML: text with `{{ }}`, `{% %}` and `{# #}`.
pub let html : Lang = { name: "html", aliases: [], options, read: read_braces, }

///|
/// Markdown: the brace syntax, with a tag on a line of its own leaving no
/// blank line behind.
pub let markdown : Lang = {
  name: "md",
  aliases: ["markdown"],
  options: {
    ..options,
    trim_blocks: true,
    lstrip_blocks: true,
    keep_trailing_newline: true,
  },
  read: read_braces,
}

///|
/// Pug: elements by indentation, `<` lines passed through, `{% %}` lines as
/// statements.
pub let pug : Lang = {
  name: "pug",
  aliases: ["pg"],
  options,
  read: read_indent,
}

///|
/// A language block found in the source: the name it gives, its force if
/// any, its body, the line of its head, and the offsets of the body and of
/// the end of the closing tag.
priv struct LangBlock {
  name : String
  force : Bool?
  body : String
  line : Int32
  body_at : Int32
  after : Int32
  close_sign : Char?
}

///|
/// The language a found block is read in, or `None` when the stretch is
/// forced and the block stays text. A name no language answers to is
/// refused.
fn Reading::admit(
  self : Reading,
  block : LangBlock,
) -> Lang? raise @spec.Refused {
  match (self.langs)(block.name) {
    Some(lang) => if self.allows(lang) { Some(lang) } else { None }
    None =>
      raise Unknown(
        template=self.template,
        line=block.line,
        kind="language",
        name=block.name,
      )
  }
}

///|
fn skip_blanks(src : String, at : Int32) -> Int32 {
  let mut i = at
  while i < src.length() && is_space(src.code_unit_at(i).to_int()) {
    i += 1
  }
  i
}

///|
fn word_at(src : String, at : Int32) -> (String, Int32) {
  let mut i = at
  while i < src.length() && is_name_part(src.code_unit_at(i).to_int()) {
    i += 1
  }
  (src[at:i].to_owned(), i)
}

///|
/// Where the tag whose contents end at `at` closes: past `%}`, `-%}` or
/// `+%}`, with the sign.
fn tag_close(src : String, at : Int32) -> (Int32, Char?)? {
  if starts_at(src, "-%}", at) {
    Some((at + 3, Some('-')))
  } else if starts_at(src, "+%}", at) {
    Some((at + 3, Some('+')))
  } else if starts_at(src, "%}", at) {
    Some((at + 2, None))
  } else {
    None
  }
}

///|
/// `{% block lang=… force=… %}` whose contents begin at `at`, through its
/// matching `{% endblock %}`; inheritance blocks inside are counted so their
/// end tags stay theirs. `None` when the tag is not a language block.
fn lang_block(
  src : String,
  at : Int32,
  template : String,
  first_line : Int32,
) -> LangBlock? raise @spec.Refused {
  let (word, i) = word_at(src, skip_blanks(src, at))
  if word != "block" {
    return None
  }
  let i = skip_blanks(src, i)
  if !starts_at(src, "lang=", i) {
    return None
  }
  let (name, i) = word_at(src, i + 5)
  if name.is_empty() {
    raise lang_syntax(src, i, template, first_line, "lang= names no language")
  }
  let mut i = skip_blanks(src, i)
  let mut force = None
  if starts_at(src, "force=", i) {
    let (value, j) = word_at(src, i + 6)
    force = match value {
      "true" => Some(true)
      "false" => Some(false)
      _ =>
        raise lang_syntax(
          src,
          i,
          template,
          first_line,
          "force takes true or false, not \{value}",
        )
    }
    i = skip_blanks(src, j)
  }
  guard tag_close(src, i) is Some((body_at, open_sign)) else {
    raise lang_syntax(
      src, i, template, first_line, "expected %} after the language block's head",
    )
  }
  let mut depth = 1
  let mut k = body_at
  while k < src.length() {
    if !starts_at(src, "{%", k) {
      k += 1
      continue
    }
    let mut j = k + 2
    let sign = if j < src.length() && src.code_unit_at(j) is ('-' | '+') {
      j += 1
      src.code_unit_at(j - 1).to_int().to_char()
    } else {
      None
    }
    let (inner, j) = word_at(src, skip_blanks(src, j))
    match inner {
      "block" => depth += 1
      "endblock" => {
        depth -= 1
        if depth == 0 {
          let mut end = skip_blanks(src, j)
          while end < src.length() && tag_close(src, end) is None {
            end += 1
          }
          guard tag_close(src, end) is Some((after, close_sign)) else { break }
          let mut body = src[body_at:k].to_owned()
          if open_sign == Some('-') {
            body = body.trim_start(chars=" \t\n\r\u{0B}\u{0C}").to_owned()
          }
          if sign == Some('-') {
            body = body.trim_end(chars=" \t\n\r\u{0B}\u{0C}").to_owned()
          }
          let line = line_of(src, at) + first_line - 1
          return Some({ name, force, body, line, body_at, after, close_sign, })
        }
      }
      _ => ()
    }
    k = j
  }
  raise lang_syntax(
    src,
    at,
    template,
    first_line,
    "the \{name} block is never closed with endblock",
  )
}

///|
fn line_of(src : String, at : Int32) -> Int32 {
  let mut line = 1
  for i in 0..<at {
    if src.code_unit_at(i) == '\n' {
      line += 1
    }
  }
  line
}

///|
fn lang_syntax(
  src : String,
  at : Int32,
  template : String,
  first_line : Int32,
  reason : String,
) -> @spec.Refused {
  let line = line_of(src, at) + first_line - 1
  let start = match src[:at].rev_find("\n") {
    Some(n) => n + 1
    None => 0
  }
  Syntax(template~, line~, column=at - start + 1, reason~)
}
