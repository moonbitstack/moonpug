///|
priv enum Opening {
  Var
  Block
  Comment
  /// `raw` or `comment`: the body is taken as it stands.
  Verbatim(String)
  Lang(LangBlock)
  LineStatement
  LineComment
}

///|
/// The source with `\r\n` and `\r` read as `\n` and, unless the options keep
/// it, one trailing newline dropped.
fn normalise(source : String, keep_trailing_newline : Bool) -> String {
  let out = source
    .replace_all(old="\r\n", new="\n")
    .replace_all(old="\r", new="\n")
  if !keep_trailing_newline && out.has_suffix("\n") {
    out[:out.length() - 1].to_owned()
  } else {
    out
  }
}

///|
/// The token stream of a template in the brace syntax: template text and
/// tags in order, ending in `Eof`.
pub fn lex_template(
  source : String,
  options : Options,
  template : String,
  reading? : Reading,
  first_line~ : Int32 = 1,
) -> Array[Token] raise @spec.Refused {
  let src = normalise(source, options.keep_trailing_newline)
  let lx = Lexer::new(src, template, line=first_line)
  let out : Array[Token] = []
  let mut line_starting = true
  while !lx.at_end() {
    let start = lx.pos
    let line = lx.line
    let column = lx.column()
    match find_opening(lx, options, first_line) {
      None => {
        out.push({ tok: Data(src[start:].to_owned()), line, column, })
        lx.advance(src.length())
      }
      Some((at, opening, sign, inner)) => {
        let text = strip_before(
          src[start:at].to_owned(),
          sign,
          opening,
          options.lstrip_blocks,
          line_starting,
        )
        if !text.is_empty() {
          out.push({ tok: Data(text), line, column, })
        }
        lx.advance(at)
        let tag_line = lx.line
        let tag_column = lx.column()
        lx.advance(inner)
        match opening {
          Var => {
            out.push({ tok: VarBegin, line: tag_line, column: tag_column, })
            let (line, column) = lx.tag(out, l => l.close_var())
            out.push({ tok: VarEnd, line, column, })
          }
          Block => {
            out.push({ tok: BlockBegin, line: tag_line, column: tag_column, })
            let (line, column) = lx.tag(out, l => {
              l.close_block(options.trim_blocks)
            })
            out.push({ tok: BlockEnd, line, column, })
          }
          LineStatement => {
            out.push({ tok: BlockBegin, line: tag_line, column: tag_column, })
            let (line, column) = lx.tag(out, l => l.close_line())
            out.push({ tok: BlockEnd, line, column, })
          }
          Comment => lx.close_comment(options.trim_blocks)
          LineComment => {
            let mut i = lx.pos
            while i < src.length() && src.code_unit_at(i) != '\n' {
              i += 1
            }
            lx.advance(i)
          }
          Lang(block) => {
            let lang = match reading {
              Some(r) => r.admit(block)
              None => None
            }
            if lang is Some(l) {
              lx.advance(block.body_at)
              out.push({
                tok: Lang(l.name, block.force, block.body),
                line: lx.line,
                column: tag_column,
              })
            } else {
              out.push({
                tok: Data(src[at:block.after].to_owned()),
                line: tag_line,
                column: tag_column,
              })
            }
            lx.advance(block.after)
            if block.close_sign == Some('-') {
              lx.skip_space()
            } else if block.close_sign is None &&
              options.trim_blocks &&
              lx.starts("\n") {
              lx.advance(lx.pos + 1)
            }
          }
          Verbatim(word) => {
            let body_line = lx.line
            let body_column = lx.column()
            let (body, end_sign, end_at, after) = lx.verbatim(
              "end" + word,
              options.trim_blocks,
            )
            match word {
              "raw" => {
                let body = strip_before(
                  body,
                  end_sign,
                  Block,
                  options.lstrip_blocks,
                  false,
                )
                if !body.is_empty() {
                  out.push({
                    tok: Data(body),
                    line: body_line,
                    column: body_column,
                  })
                }
              }
              _ => ()
            }
            lx.advance(end_at)
            lx.advance(after)
          }
        }
      }
    }
    line_starting = lx.pos > 0 && src.code_unit_at(lx.pos - 1) == '\n'
  }
  out.push({ tok: Eof, line: lx.line, column: lx.column(), })
  out
}

///|
/// The next tag at or after the cursor: where it starts, what it is, its
/// whitespace sign, and where its contents begin.
fn find_opening(
  lx : Lexer,
  options : Options,
  first_line : Int32,
) -> (Int32, Opening, Char?, Int32)? raise @spec.Refused {
  let src = lx.src
  let n = src.length()
  for i in lx.pos..<n {
    let line_start = i == 0 || src.code_unit_at(i - 1) == '\n'
    if options.line_statement is Some(prefix) && line_start {
      let mut j = i
      while j < n && src.code_unit_at(j) is (' ' | '\t' | '\u{0B}') {
        j += 1
      }
      if starts_at(src, prefix, j) {
        return Some((i, LineStatement, None, j + prefix.length()))
      }
    }
    if options.line_comment is Some(prefix) &&
      (line_start || !is_space(src.code_unit_at(i - 1).to_int())) {
      let mut j = i
      while j < n && src.code_unit_at(j) is (' ' | '\t' | '\u{0B}' | '\u{0C}') {
        j += 1
      }
      if starts_at(src, prefix, j) {
        return Some((i, LineComment, None, j + prefix.length()))
      }
    }
    if src.code_unit_at(i) != '{' || i + 1 >= n {
      continue
    }
    let opening : Opening = match src.code_unit_at(i + 1) {
      '{' => Var
      '%' => Block
      '#' => Comment
      _ => continue
    }
    let sign = if i + 2 < n && src.code_unit_at(i + 2) is ('-' | '+') {
      src.code_unit_at(i + 2).to_int().to_char()
    } else {
      None
    }
    let inner = i + 2 + (if sign is Some(_) { 1 } else { 0 })
    if opening is Block {
      match lang_block(src, inner, lx.template, first_line) {
        Some(block) => return Some((i, Lang(block), sign, inner))
        None => ()
      }
      match verbatim_head(src, inner) {
        Some((word, after)) => return Some((i, Verbatim(word), sign, after))
        None => ()
      }
    }
    return Some((i, opening, sign, inner))
  }
  None
}

///|
/// Whether the block tag whose contents begin at `at` is `raw` or
/// `comment`, and where its body begins.
fn verbatim_head(src : String, at : Int32) -> (String, Int32)? {
  let n = src.length()
  let mut i = at
  while i < n && is_space(src.code_unit_at(i).to_int()) {
    i += 1
  }
  for word in ["raw", "comment"] {
    if !starts_at(src, word, i) {
      continue
    }
    let mut j = i + word.length()
    if j < n && is_name_part(src.code_unit_at(j).to_int()) {
      continue
    }
    while j < n && is_space(src.code_unit_at(j).to_int()) {
      j += 1
    }
    if starts_at(src, "-%}", j) {
      j += 3
      while j < n && is_space(src.code_unit_at(j).to_int()) {
        j += 1
      }
      return Some((word, j))
    }
    if starts_at(src, "%}", j) {
      return Some((word, j + 2))
    }
  }
  None
}

///|
/// Jinja's whitespace control on the text before a tag: `-` strips all
/// trailing whitespace; otherwise, with `lstrip_blocks`, the indentation
/// before a block or comment tag that starts its line goes.
fn strip_before(
  text : String,
  sign : Char?,
  opening : Opening,
  lstrip_blocks : Bool,
  line_starting : Bool,
) -> String {
  if sign == Some('-') {
    return text.trim_end(chars=" \t\n\r\u{0B}\u{0C}").to_owned()
  }
  if sign == Some('+') || !lstrip_blocks || opening is Var {
    return text
  }
  let l_pos = match text.rev_find("\n") {
    Some(at) => at + 1
    None => 0
  }
  if (l_pos > 0 || line_starting) &&
    l_pos < text.length() &&
    text[l_pos:].iter().all(ch => is_space(ch.to_int())) {
    text[:l_pos].to_owned()
  } else {
    text
  }
}

///|
/// `-}}` with the whitespace after it, or `}}`.
fn Lexer::close_var(self : Lexer) -> Bool {
  if self.starts("-}}") {
    self.advance(self.pos + 3)
    self.skip_space()
    true
  } else if self.starts("}}") {
    self.advance(self.pos + 2)
    true
  } else {
    false
  }
}

///|
/// `+%}`, `-%}` with the whitespace after it, or `%}` with one newline when
/// `trim_blocks` is on.
fn Lexer::close_block(self : Lexer, trim_blocks : Bool) -> Bool {
  if self.starts("+%}") {
    self.advance(self.pos + 3)
    true
  } else if self.starts("-%}") {
    self.advance(self.pos + 3)
    self.skip_space()
    true
  } else if self.starts("%}") {
    self.advance(self.pos + 2)
    if trim_blocks && self.starts("\n") {
      self.advance(self.pos + 1)
    }
    true
  } else {
    false
  }
}

///|
/// The end of a line statement: whitespace up to the last newline before
/// the next text, or to the end; blank lines after it are dropped.
fn Lexer::close_line(self : Lexer) -> Bool {
  let src = self.src
  let mut end = self.pos
  let mut newline = -1
  while end < src.length() && is_space(src.code_unit_at(end).to_int()) {
    if src.code_unit_at(end) == '\n' {
      newline = end
    }
    end += 1
  }
  if end >= src.length() {
    self.advance(end)
    true
  } else if newline >= 0 {
    self.advance(newline + 1)
    true
  } else {
    false
  }
}

///|
fn Lexer::close_comment(
  self : Lexer,
  trim_blocks : Bool,
) -> Unit raise @spec.Refused {
  let src = self.src
  for i in self.pos..<src.length() {
    if starts_at(src, "+#}", i) {
      self.advance(i + 3)
      return
    }
    if starts_at(src, "-#}", i) {
      self.advance(i + 3)
      self.skip_space()
      return
    }
    if starts_at(src, "#}", i) {
      self.advance(i + 2)
      if trim_blocks && self.starts("\n") {
        self.advance(self.pos + 1)
      }
      return
    }
  }
  raise self.fail("missing end of comment tag")
}

///|
/// The body of a `raw` or `comment` block up to its end tag: the text, the
/// end tag's sign, where the end tag starts, and where reading continues.
fn Lexer::verbatim(
  self : Lexer,
  word : String,
  trim_blocks : Bool,
) -> (String, Char?, Int32, Int32) raise @spec.Refused {
  let src = self.src
  let n = src.length()
  for i in self.pos..<n {
    if !starts_at(src, "{%", i) {
      continue
    }
    let mut j = i + 2
    let sign = if j < n && src.code_unit_at(j) is ('-' | '+') {
      j += 1
      src.code_unit_at(j - 1).to_int().to_char()
    } else {
      None
    }
    while j < n && is_space(src.code_unit_at(j).to_int()) {
      j += 1
    }
    if !starts_at(src, word, j) {
      continue
    }
    j += word.length()
    while j < n && is_space(src.code_unit_at(j).to_int()) {
      j += 1
    }
    let after = if starts_at(src, "+%}", j) {
      j + 3
    } else if starts_at(src, "-%}", j) {
      let mut k = j + 3
      while k < n && is_space(src.code_unit_at(k).to_int()) {
        k += 1
      }
      k
    } else if starts_at(src, "%}", j) {
      if trim_blocks && starts_at(src, "\n", j + 2) {
        j + 3
      } else {
        j + 2
      }
    } else {
      continue
    }
    return (src[self.pos:i].to_owned(), sign, i, after)
  }
  raise self.fail("missing \{word}")
}

///|
/// A source in the brace syntax, read into the tree: the reader of `html`
/// and `md`.
pub fn read_braces(
  source : String,
  reading : Reading,
) -> Array[Node] raise @spec.Refused {
  let template = reading.template
  let parser : Parser = {
    template,
    tokens: lex_template(
      source,
      reading.options,
      template,
      reading~,
      first_line=reading.line,
    ),
    at: 0,
    body: (p, ends) => brace_body(p, ends, reading),
  }
  let nodes = brace_body(parser, [], reading)
  if !(parser.current().tok is Eof) {
    raise parser.fail("unexpected end tag \{describe(parser.current().tok)}")
  }
  nodes
}

///|
/// Template text, outputs and statements up to one of `ends`, as Jinja's
/// `subparse` reads them. With no ends, up to the end of the template.
fn brace_body(
  parser : Parser,
  ends : Array[String],
  reading : Reading,
) -> Array[Node] raise @spec.Refused {
  let nodes = []
  for ;; {
    let token = parser.current()
    match token.tok {
      Data(text) => {
        ignore(parser.next())
        nodes.push(Line(token.line))
        nodes.push(Text(text))
      }
      VarBegin => {
        ignore(parser.next())
        let expr = parser.parse_tuple()
        parser.expect(VarEnd)
        nodes.push(Line(token.line))
        nodes.push(Out(expr))
      }
      BlockBegin => {
        ignore(parser.next())
        if parser.current().tok is Name(word) && ends.contains(word) {
          return nodes
        }
        nodes.append(parser.parse_statement())
        parser.expect(BlockEnd)
      }
      Lang(name, force, body) => {
        ignore(parser.next())
        nodes.push(Line(token.line))
        nodes.append(reading.block(body, name, force, token.line))
      }
      Eof => {
        if !ends.is_empty() {
          raise parser.fail(
            "unexpected end of template; expected \{ends.join(" or ")}",
          )
        }
        return nodes
      }
      tok => raise parser.fail("unexpected \{describe(tok)}")
    }
  }
}
