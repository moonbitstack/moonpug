///|
/// A token of the indentation syntax. Expressions stay as source text with
/// their position and are read with the expression parser once the
/// structure is known.
priv enum PugTok {
  Indent
  Outdent
  Newline
  Eos
  Tag(String)
  InterpTag(Src)
  Id(String)
  Class(String)
  Attrs(Array[PugAttr])
  AttrBlock(Src)
  Dot
  Colon
  Slash
  Text(String)
  TextHtml(String)
  Interp(Src, Bool)
  StartTagInterp
  EndTagInterp
  Code(Src, Bool)
  Comment(String, Bool)
  StartPipeless
  EndPipeless
  Doctype(String)
  Case(Src)
  When(Src)
  Default
  Extends(String)
  Include(String)
  Filter(String)
  Block(String, Placement)
  MixinBlock
  Mixin(String, Src?)
  Call(String, Src?)
  If(Src, Bool)
  ElseIf(Src)
  Else
  Each(String, String?, Src)
  Stmt(Src)
  Lang(String, Bool?, Src)
  Yield
}

///|
/// Source text of an expression and where it starts.
priv struct Src {
  text : String
  line : Int32
  column : Int32
}

///|
priv struct PugAttr {
  name : String
  value : Src?
  escape : Bool
}

///|
priv struct PugToken {
  tok : PugTok
  line : Int32
  column : Int32
}

///|
priv struct PugLexer {
  src : String
  template : String
  mut pos : Int32
  mut line : Int32
  mut column : Int32
  tokens : Array[PugToken]
  indents : Array[Int32]
  mut tabs : Bool?
  interpolated : Bool
  mut interpolation : Bool
  mut ended : Bool
  reading : Reading?
}

///|
fn PugLexer::new(
  src : String,
  template : String,
  line~ : Int32 = 1,
  column~ : Int32 = 1,
  interpolated~ : Bool = false,
  reading? : Reading,
) -> PugLexer {
  {
    src,
    template,
    pos: 0,
    line,
    column,
    tokens: [],
    indents: [0],
    tabs: None,
    interpolated,
    interpolation: true,
    ended: false,
    reading,
  }
}

///|
fn PugLexer::fail(self : PugLexer, reason : String) -> @spec.Refused {
  Syntax(template=self.template, line=self.line, column=self.column, reason~)
}

///|
fn PugLexer::rest(self : PugLexer) -> StringView {
  self.src[self.pos:]
}

///|
fn PugLexer::unit(self : PugLexer, ahead~ : Int32 = 0) -> Int32 {
  let i = self.pos + ahead
  if i < self.src.length() {
    self.src.code_unit_at(i).to_int()
  } else {
    -1
  }
}

///|
fn PugLexer::starts(self : PugLexer, word : String) -> Bool {
  starts_at(self.src, word, self.pos)
}

///|
/// Move on `n` code units, counting lines and columns.
fn PugLexer::consume(self : PugLexer, n : Int32) -> Unit {
  for i in self.pos..<(self.pos + n) {
    if self.src.code_unit_at(i) == '\n' {
      self.line += 1
      self.column = 1
    } else {
      self.column += 1
    }
  }
  self.pos += n
}

///|
fn PugLexer::push(
  self : PugLexer,
  tok : PugTok,
  line? : Int32,
  column? : Int32,
) -> Unit {
  self.tokens.push({
    tok,
    line: line.unwrap_or(self.line),
    column: column.unwrap_or(self.column),
  })
}

///|
fn PugLexer::src_here(self : PugLexer, text : String) -> Src {
  { text, line: self.line, column: self.column, }
}

///|
/// The tokens of a template in the indentation syntax.
fn lex_pug(
  source : String,
  template : String,
  reading : Reading,
  line~ : Int32 = 1,
) -> Array[PugToken] raise @spec.Refused {
  let src = source
    .replace_all(old="\r\n", new="\n")
    .replace_all(old="\r", new="\n")
  let src = if src.has_prefix("\u{FEFF}") { src[1:].to_owned() } else { src }
  let lexer = PugLexer::new(src, template, line~, reading~)
  lexer.run()
  lexer.tokens
}

///|
fn PugLexer::run(self : PugLexer) -> Unit raise @spec.Refused {
  while !self.ended {
    self.advance()
  }
}

///|
fn PugLexer::advance(self : PugLexer) -> Unit raise @spec.Refused {
  if self.blank() ||
    self.eos() ||
    self.end_interpolation() ||
    self.statement() ||
    self.doctype() ||
    self.interpolation() ||
    self.case_() ||
    self.when_() ||
    self.default_() ||
    self.extends_() ||
    self.yield_() ||
    self.append_or_prepend() ||
    self.block_() ||
    self.mixin_block() ||
    self.include_() ||
    self.mixin_() ||
    self.call_() ||
    self.conditional() ||
    self.each_() ||
    self.tag() ||
    self.filter(false) ||
    self.code() ||
    self.id() ||
    self.dot() ||
    self.class_name() ||
    self.attrs() ||
    self.attribute_block() ||
    self.indent() ||
    self.text() ||
    self.text_html() ||
    self.comment() ||
    self.slash() ||
    self.colon() {
    return
  }
  let near = self.rest()
  raise self.fail(
    "unexpected text \{near[:if near.length() > 5 { 5 } else { near.length() }]}",
  )
}

///|
fn PugLexer::blank(self : PugLexer) -> Bool {
  if self.unit() != '\n' {
    return false
  }
  let mut i = self.pos + 1
  while i < self.src.length() && self.src.code_unit_at(i) is (' ' | '\t') {
    i += 1
  }
  if i < self.src.length() && self.src.code_unit_at(i) == '\n' {
    self.consume(i - self.pos)
    true
  } else {
    false
  }
}

///|
fn PugLexer::eos(self : PugLexer) -> Bool raise @spec.Refused {
  if self.pos < self.src.length() {
    return false
  }
  if self.interpolated {
    raise self.fail(
      "the end of the line came with no ] closing the interpolation",
    )
  }
  for level in self.indents {
    if level > 0 {
      self.push(Outdent)
    }
  }
  self.push(Eos)
  self.ended = true
  true
}

///|
fn PugLexer::end_interpolation(self : PugLexer) -> Bool {
  if self.interpolated && self.unit() == ']' {
    self.consume(1)
    self.ended = true
    true
  } else {
    false
  }
}

///|
/// A keyword followed by the end of the line, a `:`, or nothing; on a match
/// returns the captured rest and leaves the cursor after trailing blanks.
fn PugLexer::end_of_line(self : PugLexer, word : String) -> String? {
  if !self.starts(word) {
    return None
  }
  let after = self.pos + word.length()
  if after < self.src.length() &&
    is_name_part(self.src.code_unit_at(after).to_int()) {
    return None
  }
  let mut i = after
  if i < self.src.length() && self.src.code_unit_at(i) == ':' {
    self.consume(word.length())
    return Some("")
  }
  while i < self.src.length() && self.src.code_unit_at(i) is (' ' | '\t') {
    i += 1
  }
  if i >= self.src.length() || self.src.code_unit_at(i) == '\n' {
    self.consume(i - self.pos)
    Some("")
  } else {
    None
  }
}

///|
/// The rest of the line after the cursor.
fn PugLexer::line_rest(self : PugLexer, from : Int32) -> String {
  let mut i = from
  while i < self.src.length() && self.src.code_unit_at(i) != '\n' {
    i += 1
  }
  self.src[from:i].to_owned()
}

///|
/// `{% … %}` on a line of its own: a statement of the brace syntax. The
/// bodies of `trans`, `pluralize` and `raw` are text, read as it stands.
fn PugLexer::statement(self : PugLexer) -> Bool raise @spec.Refused {
  if !self.starts("{%") {
    return false
  }
  let contents = self.pos +
    2 +
    (if self.unit(ahead=2) is ('-' | '+') { 1 } else { 0 })
  match
    lang_block(
      self.src,
      contents,
      self.template,
      self.line - line_of(self.src, self.pos) + 1,
    ) {
    Some(block) => {
      let line = self.line
      let column = self.column
      let lang = match self.reading {
        Some(r) => r.admit(block)
        None => None
      }
      match lang {
        Some(l) => {
          let start = self.pos
          self.consume(block.body_at - start)
          self.push(
            Lang(l.name, block.force, self.src_here(block.body)),
            line~,
            column~,
          )
        }
        None =>
          self.push(
            Text(self.src[self.pos:block.after].to_owned()),
            line~,
            column~,
          )
      }
      self.consume(block.after - self.pos)
      let rest = self.line_rest(self.pos)
      if rest.iter().all(ch => ch == ' ' || ch == '\t') {
        self.consume(rest.length())
      }
      return true
    }
    None => ()
  }
  let text = self.line_rest(self.pos)
  let src = self.src_here(text)
  self.push(Stmt(src))
  self.consume(text.length())
  let word = text[2:].trim_start(chars=" \t-+")
  if word.has_prefix("trans") ||
    word.has_prefix("pluralize") ||
    word.has_prefix("raw") {
    self.interpolation = false
    ignore(self.pipeless())
  }
  true
}

///|
fn PugLexer::doctype(self : PugLexer) -> Bool {
  if !self.starts("doctype") ||
    (self.unit(ahead=7) != -1 && !(self.unit(ahead=7) is (' ' | '\n'))) {
    return false
  }
  let line = self.line
  let column = self.column
  let text = self.line_rest(self.pos + 7).trim(chars=" ").to_owned()
  self.consume(self.line_rest(self.pos).length())
  self.push(Doctype(text), line~, column~)
  true
}

///|
/// `#{expr}` where a tag name belongs.
fn PugLexer::interpolation(self : PugLexer) -> Bool raise @spec.Refused {
  if !self.starts("#{") {
    return false
  }
  let line = self.line
  let column = self.column
  let close = self.bracket(self.pos + 1)
  self.consume(2)
  let src = self.src_here(self.src[self.pos:close].to_owned())
  self.consume(close + 1 - self.pos)
  self.push(InterpTag(src), line~, column~)
  true
}

///|
/// Where the bracket at `open` closes, skipping strings and nested
/// brackets.
fn PugLexer::bracket(
  self : PugLexer,
  open : Int32,
) -> Int32 raise @spec.Refused {
  match matching_bracket(self.src, open) {
    Some(close) => close
    None => raise self.fail("no closing bracket for \{self.src[open:open + 1]}")
  }
}

///|
fn matching_bracket(src : String, open : Int32) -> Int32? {
  let stack : Array[Int32] = []
  let mut quote = -1
  let mut i = open
  while i < src.length() {
    let unit = src.code_unit_at(i).to_int()
    if quote >= 0 {
      if unit == '\\' {
        i += 2
        continue
      }
      if unit == quote {
        quote = -1
      }
    } else {
      match unit {
        '\'' | '"' | '`' => quote = unit
        '(' => stack.push(')')
        '[' => stack.push(']')
        '{' => stack.push('}')
        ')' | ']' | '}' =>
          match stack.pop() {
            Some(want) if want == unit => if stack.is_empty() { return Some(i) }
            _ => return None
          }
        _ => ()
      }
    }
    i += 1
  }
  None
}

///|
fn PugLexer::keyword_rest(self : PugLexer, word : String) -> String? {
  if !self.starts(word) {
    return None
  }
  let mut i = self.pos + word.length()
  if i >= self.src.length() || self.src.code_unit_at(i) != ' ' {
    return None
  }
  while i < self.src.length() && self.src.code_unit_at(i) == ' ' {
    i += 1
  }
  let rest = self.line_rest(i)
  if rest.is_empty() {
    None
  } else {
    Some(rest)
  }
}

///|
fn PugLexer::case_(self : PugLexer) -> Bool {
  match self.keyword_rest("case") {
    Some(text) => {
      let line = self.line
      let column = self.column
      let at = self.line_rest(self.pos).length() - text.length()
      self.consume(at)
      let src = self.src_here(text.trim_end(chars=" \t").to_owned())
      self.consume(text.length())
      self.push(Case(src), line~, column~)
      true
    }
    None => false
  }
}

///|
fn PugLexer::when_(self : PugLexer) -> Bool {
  if !self.starts("when ") {
    return false
  }
  let line = self.line
  let column = self.column
  let mut i = self.pos + 5
  while i < self.src.length() && self.src.code_unit_at(i) == ' ' {
    i += 1
  }
  let start = i
  let stack = []
  let mut quote = -1
  while i < self.src.length() {
    let unit = self.src.code_unit_at(i).to_int()
    if unit == '\n' {
      break
    }
    if quote >= 0 {
      if unit == '\\' {
        i += 2
        continue
      }
      if unit == quote {
        quote = -1
      }
    } else if unit is ('\'' | '"') {
      quote = unit
    } else if unit is ('(' | '[' | '{') {
      stack.push(unit)
    } else if unit is (')' | ']' | '}') {
      ignore(stack.pop())
    } else if unit == ':' && stack.is_empty() {
      break
    }
    i += 1
  }
  self.consume(start - self.pos)
  let src = self.src_here(self.src[start:i].trim_end(chars=" \t").to_owned())
  self.consume(i - self.pos)
  self.push(When(src), line~, column~)
  true
}

///|
fn PugLexer::default_(self : PugLexer) -> Bool {
  let line = self.line
  let column = self.column
  match self.end_of_line("default") {
    Some(_) => {
      self.push(Default, line~, column~)
      true
    }
    None => false
  }
}

///|
fn PugLexer::extends_(self : PugLexer) -> Bool raise @spec.Refused {
  for word in ["extends", "extend"] {
    if self.starts(word) &&
      (
        self.unit(ahead=word.length()) is (' ' | '\n') ||
        self.unit(ahead=word.length()) == -1
      ) {
      let line = self.line
      let column = self.column
      let path = self
        .line_rest(self.pos + word.length())
        .trim(chars=" \t")
        .to_owned()
      if path.is_empty() {
        raise self.fail("missing path for extends")
      }
      self.consume(self.line_rest(self.pos).length())
      self.push(Extends(path), line~, column~)
      return true
    }
  }
  false
}

///|
/// `yield` on a line of its own.
fn PugLexer::yield_(self : PugLexer) -> Bool {
  if !self.starts("yield") {
    return false
  }
  let rest = self.line_rest(self.pos + 5)
  if !rest.iter().all(ch => ch == ' ' || ch == '\t') {
    return false
  }
  self.push(Yield)
  self.consume(5 + rest.length())
  true
}

///|
/// `block append name`, `append name` and the `prepend` pair.
fn PugLexer::append_or_prepend(self : PugLexer) -> Bool {
  for mode in [("append", Append), ("prepend", Prepend)] {
    let (word, placement) = mode
    for prefix in ["block " + word + " ", word + " "] {
      if self.starts(prefix) {
        match self.block_name(self.pos + prefix.length()) {
          Some(name) => {
            self.push(Block(name, placement))
            self.consume(self.line_rest(self.pos).length())
            return true
          }
          None => ()
        }
      }
    }
  }
  false
}

///|
fn PugLexer::block_(self : PugLexer) -> Bool {
  if !self.starts("block ") {
    return false
  }
  match self.block_name(self.pos + 6) {
    Some(name) => {
      self.push(Block(name, Replace))
      self.consume(self.line_rest(self.pos).length())
      true
    }
    None => false
  }
}

///|
/// A block's name: the rest of the line, a trailing `//` comment dropped.
fn PugLexer::block_name(self : PugLexer, from : Int32) -> String? {
  let rest = self.line_rest(from)
  let name = match rest.find("//") {
    Some(at) => rest[:at].to_owned()
    None => rest
  }
  let name = name.trim(chars=" \t").to_owned()
  if name.is_empty() {
    None
  } else {
    Some(name)
  }
}

///|
fn PugLexer::mixin_block(self : PugLexer) -> Bool {
  let line = self.line
  let column = self.column
  match self.end_of_line("block") {
    Some(_) => {
      self.push(MixinBlock, line~, column~)
      true
    }
    None => false
  }
}

///|
fn PugLexer::include_(self : PugLexer) -> Bool raise @spec.Refused {
  if !self.starts("include") {
    return false
  }
  let next = self.unit(ahead=7)
  if !(next is (':' | ' ' | '\n') || next == -1) {
    return false
  }
  self.push(Include(""))
  self.consume(7)
  while self.filter(true) {

  }
  if self.unit() == ' ' {
    let path = self.line_rest(self.pos).trim(chars=" \t").to_owned()
    if !path.is_empty() {
      self.push(Include(path))
      self.consume(self.line_rest(self.pos).length())
      return true
    }
  }
  raise self.fail("missing path for include")
}

///|
fn PugLexer::mixin_(self : PugLexer) -> Bool raise @spec.Refused {
  if !self.starts("mixin ") {
    return false
  }
  let line = self.line
  let column = self.column
  let mut i = self.pos + 6
  while i < self.src.length() && self.src.code_unit_at(i) == ' ' {
    i += 1
  }
  let start = i
  while i < self.src.length() &&
        (
          is_name_part(self.src.code_unit_at(i).to_int()) ||
          self.src.code_unit_at(i) == '-'
        ) {
    i += 1
  }
  if i == start {
    return false
  }
  let name = self.src[start:i].to_owned()
  let mut j = i
  while j < self.src.length() && self.src.code_unit_at(j) == ' ' {
    j += 1
  }
  self.consume(j - self.pos)
  let args = if self.unit() == '(' {
    let close = self.bracket(self.pos)
    let src = {
      text: self.src[self.pos:close + 1].to_owned(),
      line: self.line,
      column: self.column,
    }
    self.consume(close + 1 - self.pos)
    Some(src)
  } else {
    None
  }
  while self.unit() == ' ' {
    self.consume(1)
  }
  self.push(Mixin(name, args), line~, column~)
  true
}

///|
/// `+name`, `+name(args)`; attributes after the arguments are read by the
/// tag rules that follow.
fn PugLexer::call_(self : PugLexer) -> Bool raise @spec.Refused {
  if self.unit() != '+' {
    return false
  }
  let line = self.line
  let column = self.column
  let mut i = self.pos + 1
  while i < self.src.length() &&
        is_space(self.src.code_unit_at(i).to_int()) &&
        self.src.code_unit_at(i) != '\n' {
    i += 1
  }
  let start = i
  while i < self.src.length() &&
        (
          is_name_part(self.src.code_unit_at(i).to_int()) ||
          self.src.code_unit_at(i) == '-'
        ) {
    i += 1
  }
  if i == start {
    return false
  }
  let name = self.src[start:i].to_owned()
  self.consume(i - self.pos)
  let mut args = None
  let mut j = self.pos
  while j < self.src.length() && self.src.code_unit_at(j) == ' ' {
    j += 1
  }
  if j < self.src.length() && self.src.code_unit_at(j) == '(' {
    let close = self.bracket(j)
    let inner = self.src[j + 1:close].to_owned()
    if !looks_like_attributes(inner) {
      self.consume(j - self.pos)
      args = Some({
        text: "(" + inner + ")",
        line: self.line,
        column: self.column,
      })
      self.consume(close + 1 - self.pos)
    }
  }
  self.push(Call(name, args), line~, column~)
  true
}

///|
/// `(href='/')` after a mixin's name is attributes, not arguments.
fn looks_like_attributes(inner : String) -> Bool {
  let text = inner.trim_start(chars=" \t\n")
  let mut i = 0
  while i < text.length() &&
        (
          is_name_part(text.code_unit_at(i).to_int()) ||
          text.code_unit_at(i) == '-'
        ) {
    i += 1
  }
  if i == 0 {
    return false
  }
  while i < text.length() && text.code_unit_at(i) == ' ' {
    i += 1
  }
  i < text.length() &&
  text.code_unit_at(i) == '=' &&
  !(i + 1 < text.length() && text.code_unit_at(i + 1) == '=')
}

///|
fn PugLexer::conditional(self : PugLexer) -> Bool raise @spec.Refused {
  let line = self.line
  let column = self.column
  for word in ["else if", "if", "unless", "else"] {
    if !self.starts(word) {
      continue
    }
    let after = self.pos + word.length()
    if after < self.src.length() &&
      is_name_part(self.src.code_unit_at(after).to_int()) {
      continue
    }
    let rest = self.line_rest(after)
    let cond = rest.trim(chars=" \t").to_owned()
    let lead = rest.length() - rest.trim_start(chars=" \t").length()
    self.consume(word.length() + lead)
    let src = self.src_here(cond)
    self.consume(rest.length() - lead)
    let tok : PugTok = match word {
      "if" => If(src, false)
      "unless" => If(src, true)
      "else if" => ElseIf(src)
      _ => {
        if !cond.is_empty() {
          raise self.fail(
            "else cannot have a condition; perhaps you meant else if",
          )
        }
        Else
      }
    }
    if word != "else" && cond.is_empty() {
      raise self.fail("\{word} needs a condition")
    }
    self.push(tok, line~, column~)
    return true
  }
  false
}

///|
/// `each value, key in items` (also `for`, and `of` for `in`).
fn PugLexer::each_(self : PugLexer) -> Bool raise @spec.Refused {
  let word = if self.starts("each ") {
    "each"
  } else if self.starts("for ") {
    "for"
  } else {
    return false
  }
  let line = self.line
  let column = self.column
  let rest = self.line_rest(self.pos + word.length())
  let lx = Lexer::new(rest, self.template)
  let names = []
  let mut key = None
  let tokens = []
  ignore(lx.tag(tokens, l => l.at_end()))
  let mut at = 0
  fn name_at(i : Int32) -> String? {
    if i < tokens.length() && tokens[i].tok is Name(n) {
      Some(n)
    } else {
      None
    }
  }
  match name_at(at) {
    Some(n) => {
      names.push(n)
      at += 1
    }
    None => raise self.fail("\{word} wants a name, then in and the items")
  }
  if at < tokens.length() && tokens[at].tok is Op(",") {
    match name_at(at + 1) {
      Some(n) => {
        key = Some(n)
        at += 2
      }
      None => raise self.fail("\{word} wants a name after the comma")
    }
  }
  if !(name_at(at) is Some("in" | "of")) {
    raise self.fail("\{word} statements take the form \{word} VALUE in ITEMS")
  }
  let iter_start = tokens[at].column + 2
  let code = rest[iter_start:].trim(chars=" \t").to_owned()
  let lead = rest[iter_start:].length() -
    rest[iter_start:].trim_start(chars=" \t").length()
  self.consume(word.length() + iter_start + lead)
  let src = self.src_here(code)
  self.consume(code.length())
  while self.unit() is (' ' | '\t') {
    self.consume(1)
  }
  self.push(Each(names[0], key, src), line~, column~)
  true
}

///|
fn PugLexer::tag(self : PugLexer) -> Bool {
  let start = self.pos
  if !is_word(self.unit()) {
    return false
  }
  let mut i = start + 1
  let mut last_word = i
  while i < self.src.length() {
    let unit = self.src.code_unit_at(i).to_int()
    if is_word(unit) {
      i += 1
      last_word = i
    } else if unit is ('-' | ':') {
      i += 1
    } else {
      break
    }
  }
  let name = self.src[start:last_word].to_owned()
  let line = self.line
  let column = self.column
  self.consume(last_word - start)
  self.push(Tag(name), line~, column~)
  true
}

///|
fn is_word(unit : Int32) -> Bool {
  (unit >= 'a' && unit <= 'z') ||
  (unit >= 'A' && unit <= 'Z') ||
  (unit >= '0' && unit <= '9') ||
  unit == '_'
}

///|
fn PugLexer::filter(
  self : PugLexer,
  in_include : Bool,
) -> Bool raise @spec.Refused {
  if self.unit() != ':' ||
    !(is_word(self.unit(ahead=1)) || self.unit(ahead=1) == '-') {
    return false
  }
  let line = self.line
  let column = self.column
  let mut i = self.pos + 1
  while i < self.src.length() &&
        (
          is_word(self.src.code_unit_at(i).to_int()) ||
          self.src.code_unit_at(i) == '-'
        ) {
    i += 1
  }
  let name = self.src[self.pos + 1:i].to_owned()
  self.consume(i - self.pos)
  self.push(Filter(name), line~, column~)
  ignore(self.attrs())
  if !in_include {
    self.interpolation = false
    ignore(self.pipeless())
  }
  true
}

///|
/// `=`, `!=` with an expression; a bare `-` line is refused, its code
/// being the host language's.
fn PugLexer::code(self : PugLexer) -> Bool raise @spec.Refused {
  let (width, escape) = if self.starts("!=") {
    (2, false)
  } else if self.unit() == '=' {
    (1, true)
  } else if self.unit() == '-' {
    raise self.fail(
      "- lines run host code; write the statement as {% … %} and the output as {{ … }}",
    )
  } else {
    return false
  }
  let line = self.line
  let column = self.column
  let mut i = self.pos + width
  while i < self.src.length() && self.src.code_unit_at(i) is (' ' | '\t') {
    i += 1
  }
  if self.tokens.is_empty() ||
    self.tokens[self.tokens.length() - 1].tok is (Newline | Indent | Outdent) {
    raise self.fail(
      "a line of its own starting with = is written {{ … }} in this syntax",
    )
  }
  let text = if self.interpolated {
    let rest = self.line_rest(i)
    match rest.find("]") {
      Some(at) => rest[:at].to_owned()
      None => rest
    }
  } else {
    self.line_rest(i)
  }
  self.consume(i - self.pos)
  let src = self.src_here(text)
  self.consume(text.length())
  self.push(Code(src, escape), line~, column~)
  true
}

///|
fn PugLexer::id(self : PugLexer) -> Bool raise @spec.Refused {
  if self.unit() != '#' {
    return false
  }
  let mut i = self.pos + 1
  while i < self.src.length() &&
        (
          is_word(self.src.code_unit_at(i).to_int()) ||
          self.src.code_unit_at(i) == '-'
        ) {
    i += 1
  }
  if i == self.pos + 1 {
    raise self.fail("an id needs a name after #")
  }
  let line = self.line
  let column = self.column
  let name = self.src[self.pos + 1:i].to_owned()
  self.consume(i - self.pos)
  self.push(Id(name), line~, column~)
  true
}

///|
fn PugLexer::dot(self : PugLexer) -> Bool raise @spec.Refused {
  if self.unit() != '.' {
    return false
  }
  let mut i = self.pos + 1
  while i < self.src.length() && self.src.code_unit_at(i) is (' ' | '\t') {
    i += 1
  }
  if i < self.src.length() && self.src.code_unit_at(i) != '\n' {
    return false
  }
  let line = self.line
  let column = self.column
  self.consume(i - self.pos)
  self.push(Dot, line~, column~)
  ignore(self.pipeless())
  true
}

///|
fn PugLexer::class_name(self : PugLexer) -> Bool raise @spec.Refused {
  if self.unit() != '.' {
    return false
  }
  let mut i = self.pos + 1
  let mut letter = false
  while i < self.src.length() {
    let unit = self.src.code_unit_at(i).to_int()
    if (unit >= 'a' && unit <= 'z') ||
      (unit >= 'A' && unit <= 'Z') ||
      unit == '_' {
      letter = true
    } else if !((unit >= '0' && unit <= '9') || unit == '-') {
      break
    }
    i += 1
  }
  if i == self.pos + 1 {
    raise self.fail("a class needs a name after the dot")
  }
  if !letter {
    raise self.fail(
      "class names must contain at least one letter or underscore",
    )
  }
  let line = self.line
  let column = self.column
  let name = self.src[self.pos + 1:i].to_owned()
  self.consume(i - self.pos)
  self.push(Class(name), line~, column~)
  true
}

///|
/// An attribute section: `( … )`, or right after an element `[ … ]` or
/// `{ … }`, whichever reads best when the section wraps.
fn PugLexer::attrs(self : PugLexer) -> Bool raise @spec.Refused {
  let after_element = match self.tokens.last() {
    Some(
      {
        tok: Tag(_)
        | InterpTag(_)
        | Id(_)
        | Class(_)
        | Attrs(_)
        | Call(_, _),
        ..
      }
    ) => true
    _ => false
  }
  if !(self.unit() == '(' || (after_element && self.unit() is ('[' | '{'))) {
    return false
  }
  let line = self.line
  let column = self.column
  let close = self.bracket(self.pos)
  self.consume(1)
  let out = []
  while self.pos < close {
    match self.attribute(close) {
      Some(attr) => out.push(attr)
      None => break
    }
  }
  self.consume(close + 1 - self.pos)
  self.push(Attrs(out), line~, column~)
  true
}

///|
/// One attribute inside `( … )`, `[ … ]` or `{ … }`, which ends at `close`.
fn PugLexer::attribute(self : PugLexer, close : Int32) -> PugAttr? {
  while self.pos < close && is_space(self.unit()) {
    self.consume(1)
  }
  if self.pos >= close {
    return None
  }
  let key = StringBuilder()
  let quote = self.unit()
  if quote is ('\'' | '"') {
    self.consume(1)
    while self.pos < close && self.unit() != quote {
      key.write_char(self.unit().unsafe_to_char())
      self.consume(1)
    }
    self.consume(1)
  } else {
    while self.pos < close &&
          !(is_space(self.unit()) || self.unit() is ('!' | '=' | ',')) {
      key.write_char(self.unit().unsafe_to_char())
      self.consume(1)
    }
  }
  let name = key.to_string()
  let mut i = self.pos
  while i < close && is_space(self.src.code_unit_at(i).to_int()) {
    i += 1
  }
  let mut escape = true
  let mut value = None
  let has_value = if i < close &&
    self.src.code_unit_at(i) == '!' &&
    i + 1 < close &&
    self.src.code_unit_at(i + 1) == '=' {
    escape = false
    i += 2
    true
  } else if i < close && self.src.code_unit_at(i) == '=' {
    i += 1
    true
  } else {
    false
  }
  if has_value {
    while i < close && is_space(self.src.code_unit_at(i).to_int()) {
      i += 1
    }
    self.consume(i - self.pos)
    let line = self.line
    let column = self.column
    let end = attribute_value_end(self.src, self.pos, close, self.template)
    value = Some({ text: self.src[self.pos:end].to_owned(), line, column, })
    self.consume(end - self.pos)
  }
  while self.pos < close && is_space(self.unit()) {
    self.consume(1)
  }
  if self.pos < close && self.unit() == ',' {
    self.consume(1)
  }
  Some({ name, value, escape, })
}

///|
/// Where an attribute's value ends: at a comma, or at whitespace once what
/// came before is a whole expression and what follows does not continue it.
fn attribute_value_end(
  src : String,
  start : Int32,
  close : Int32,
  template : String,
) -> Int32 {
  let stack = []
  let mut quote = -1
  let mut i = start
  while i < close {
    let unit = src.code_unit_at(i).to_int()
    if quote >= 0 {
      if unit == '\\' {
        i += 2
        continue
      }
      if unit == quote {
        quote = -1
      }
      i += 1
      continue
    }
    if stack.is_empty() {
      if is_space(unit) {
        let mut x = i
        while x < close && is_space(src.code_unit_at(x).to_int()) {
          x += 1
        }
        if x >= close {
          return i
        }
        let next = src.code_unit_at(x).to_int()
        let continues = is_punctuator(next) &&
          !(next is ('\'' | '"' | ':')) &&
          !starts_at(src, "...", x)
        if !continues && whole_expression(src[start:i].to_owned(), template) {
          return i
        }
      }
      if unit == ',' && whole_expression(src[start:i].to_owned(), template) {
        return i
      }
    }
    match unit {
      '\'' | '"' | '`' => quote = unit
      '(' | '[' | '{' => stack.push(unit)
      ')' | ']' | '}' => ignore(stack.pop())
      _ => ()
    }
    i += 1
  }
  close
}

///|
fn is_punctuator(unit : Int32) -> Bool {
  unit
  is ('.'
  | ','
  | ';'
  | ':'
  | '?'
  | '('
  | ')'
  | '['
  | ']'
  | '{'
  | '}'
  | '+'
  | '-'
  | '*'
  | '/'
  | '%'
  | '&'
  | '|'
  | '^'
  | '!'
  | '~'
  | '<'
  | '>'
  | '=')
}

///|
fn whole_expression(text : String, template : String) -> Bool {
  let parsed = try {
    let tokens = lex_expression(text, template)
    let parser : Parser = { template, tokens, at: 0, body: no_body, }
    ignore(parser.parse_expression())
    parser.current().tok is Eof
  } catch {
    _ => false
  }
  parsed
}

///|
fn no_body(
  parser : Parser,
  _ends : Array[String],
) -> Array[Node] raise @spec.Refused {
  raise parser.fail("a statement body does not belong here")
}

///|
fn PugLexer::attribute_block(self : PugLexer) -> Bool raise @spec.Refused {
  if !self.starts("&attributes") {
    return false
  }
  let line = self.line
  let column = self.column
  self.consume(11)
  if self.unit() != '(' {
    raise self.fail("&attributes takes its value in parentheses")
  }
  let close = self.bracket(self.pos)
  self.consume(1)
  let src = self.src_here(self.src[self.pos:close].to_owned())
  self.consume(close + 1 - self.pos)
  self.push(AttrBlock(src), line~, column~)
  true
}

///|
/// The indentation of the next line, if the cursor stands on a newline.
fn PugLexer::indentation(self : PugLexer) -> Int32? raise @spec.Refused {
  if self.unit() != '\n' {
    return None
  }
  let mut i = self.pos + 1
  let mut tabs = 0
  let mut spaces = 0
  while i < self.src.length() && self.src.code_unit_at(i) == '\t' {
    tabs += 1
    i += 1
  }
  while i < self.src.length() && self.src.code_unit_at(i) == ' ' {
    spaces += 1
    i += 1
  }
  match self.tabs {
    Some(true) => Some(tabs)
    Some(false) => {
      if tabs > 0 {
        raise self.fail("invalid indentation: tabs and spaces cannot be mixed")
      }
      Some(spaces)
    }
    None =>
      if tabs > 0 {
        self.tabs = Some(true)
        Some(tabs)
      } else {
        if spaces > 0 {
          self.tabs = Some(false)
        }
        Some(spaces)
      }
  }
}

///|
fn PugLexer::indent(self : PugLexer) -> Bool raise @spec.Refused {
  let levels = match self.indentation() {
    Some(n) => n
    None => return false
  }
  self.consume(1 + levels)
  if self.unit() is (' ' | '\t') {
    raise self.fail("invalid indentation: tabs and spaces cannot be mixed")
  }
  if self.unit() == '\n' {
    self.interpolation = true
    self.push(Newline)
    return true
  }
  if levels < self.indents[0] {
    let mut outdents = 0
    while self.indents[0] > levels {
      if self.indents.length() > 1 && self.indents[1] < levels {
        raise self.fail(
          "inconsistent indentation: expecting either \{self.indents[1]} or \{self.indents[0]}",
        )
      }
      outdents += 1
      self.indents.remove(0) |> ignore
    }
    for _ in 0..<outdents {
      self.push(Outdent)
    }
  } else if levels > 0 && levels != self.indents[0] {
    self.push(Indent)
    self.indents.insert(0, levels)
  } else {
    self.push(Newline)
  }
  self.interpolation = true
  true
}

///|
/// The text block under a `.`, a comment or a filter: the lines indented
/// further than the current level, their extra indentation kept.
fn PugLexer::pipeless(
  self : PugLexer,
  indents? : Int32,
) -> Bool raise @spec.Refused {
  while self.blank() {

  }
  let start_pos = self.pos
  let start_line = self.line
  let start_column = self.column
  let found = match indents {
    Some(n) => n
    None =>
      match self.indentation() {
        Some(n) => n
        None => return false
      }
  }
  if found <= self.indents[0] {
    return false
  }
  self.push(StartPipeless)
  let lines = []
  let matched = []
  let mut ptr = self.pos
  for ;; {
    if ptr >= self.src.length() {
      break
    }
    let next_nl = match self.src[ptr + 1:].find("\n") {
      Some(at) => ptr + 1 + at
      None => self.src.length()
    }
    let line = self.src[ptr + 1:next_nl].to_owned()
    let mut level = 0
    while level < line.length() && line.code_unit_at(level) is (' ' | '\t') {
      level += 1
    }
    let deep = level >= found
    let empty = line.trim(chars=" \t").is_empty()
    if deep || empty {
      matched.push(deep)
      lines.push(
        if line.length() >= found {
          line[found:].to_owned()
        } else {
          ""
        },
      )
      ptr = next_nl
    } else if level > self.indents[0] {
      self.tokens.pop() |> ignore
      self.pos = start_pos
      self.line = start_line
      self.column = start_column
      return self.pipeless(indents=level)
    } else {
      break
    }
  }
  self.consume(ptr - self.pos)
  if self.pos >= self.src.length() {
    while !lines.is_empty() && lines[lines.length() - 1] == "" {
      lines.pop() |> ignore
    }
  }
  let base_line = start_line + 1
  for i, text in lines {
    if i > 0 {
      self.push(Newline, line=base_line + i, column=1)
    }
    self.add_text(
      text,
      line=base_line + i,
      column=found + 1,
      html=false,
      start=-1,
    )
  }
  self.push(EndPipeless)
  true
}

///|
fn PugLexer::text(self : PugLexer) -> Bool raise @spec.Refused {
  let line = self.line
  let column = self.column
  let entry = self.pos
  let start = if self.unit() == '|' {
    if self.unit(ahead=1) == ' ' {
      entry + 2
    } else {
      entry + 1
    }
  } else if self.unit() == ' ' {
    entry + 1
  } else {
    return false
  }
  let text = self.line_rest(start)
  self.consume(start - entry + text.length())
  if text.is_empty() {
    self.push(Text(""), line~, column~)
  } else {
    self.add_text(
      text,
      line~,
      column=column + start - entry,
      html=false,
      start~,
    )
  }
  true
}

///|
fn PugLexer::text_html(self : PugLexer) -> Bool raise @spec.Refused {
  if self.unit() != '<' {
    return false
  }
  let line = self.line
  let column = self.column
  let start = self.pos
  let text = self.line_rest(self.pos)
  self.consume(text.length())
  self.add_text(text, line~, column~, html=true, start~)
  true
}

///|
/// Text with `#{}`, `!{}`, `{{ }}` and `#[ ]` read out of it; a backslash
/// before `#{`, `!{` or `#[` keeps it as written. `start` is where `value`
/// begins in the source, so a `]` closing a tag interpolation can stop the
/// lexer right after itself.
fn PugLexer::add_text(
  self : PugLexer,
  value : String,
  line~ : Int32,
  column~ : Int32,
  html~ : Bool,
  start~ : Int32,
) -> Unit raise @spec.Refused {
  let buf = StringBuilder()
  let mut i = 0
  let n = value.length()
  let flush = fn(at : Int32) {
    if !buf.is_empty() {
      self.push(
        if html {
          TextHtml(buf.to_string())
        } else {
          Text(buf.to_string())
        },
        line~,
        column=column + at,
      )
      buf.reset()
    }
  }
  let mut run_start = 0
  while i < n {
    let unit = value.code_unit_at(i).to_int()
    if self.interpolated && unit == ']' {
      flush(run_start)
      if start >= 0 {
        self.pos = start + i + 1
        self.column = column + i + 1
      }
      self.ended = true
      return
    }
    if !self.interpolation {
      buf.write_char(unit.unsafe_to_char())
      i += 1
      continue
    }
    if unit == '\\' &&
      i + 2 < n &&
      (
        (
          value.code_unit_at(i + 1) is ('#' | '!') &&
          value.code_unit_at(i + 2) == '{'
        ) ||
        (value.code_unit_at(i + 1) == '#' && value.code_unit_at(i + 2) == '[')
      ) {
      buf.write_string(value[i + 1:i + 3].to_owned())
      i += 3
      continue
    }
    if unit is ('#' | '!') && i + 1 < n && value.code_unit_at(i + 1) == '{' {
      let close = match matching_bracket(value, i + 1) {
        Some(c) => c
        None => raise self.fail("no closing } for the interpolation")
      }
      flush(run_start)
      let src = {
        text: value[i + 2:close].to_owned(),
        line,
        column: column + i + 2,
      }
      self.push(Interp(src, unit == '#'), line~, column=column + i)
      i = close + 1
      run_start = i
      continue
    }
    if unit == '{' && i + 1 < n && value.code_unit_at(i + 1) == '{' {
      match value[i + 2:].find("}}") {
        Some(at) => {
          flush(run_start)
          let src = {
            text: value[i + 2:i + 2 + at].to_owned(),
            line,
            column: column + i + 2,
          }
          self.push(Interp(src, true), line~, column=column + i)
          i = i + 2 + at + 2
          run_start = i
          continue
        }
        None => ()
      }
    }
    if unit == '#' && i + 1 < n && value.code_unit_at(i + 1) == '[' {
      flush(run_start)
      self.push(StartTagInterp, line~, column=column + i)
      let child = PugLexer::new(
        value[i + 2:].to_owned(),
        self.template,
        line~,
        column=column + i + 2,
        interpolated=true,
      )
      child.run()
      for token in child.tokens {
        self.tokens.push(token)
      }
      self.push(EndTagInterp, line~, column=child.column)
      let consumed = child.pos
      i = i + 2 + consumed
      run_start = i
      continue
    }
    buf.write_char(unit.unsafe_to_char())
    i += 1
  }
  flush(run_start)
}

///|
fn PugLexer::comment(self : PugLexer) -> Bool raise @spec.Refused {
  if !self.starts("//") {
    return false
  }
  let line = self.line
  let column = self.column
  let buffer = !self.starts("//-")
  let text = self.line_rest(self.pos + (if buffer { 2 } else { 3 }))
  self.consume(self.line_rest(self.pos).length())
  self.push(Comment(text, buffer), line~, column~)
  self.interpolation = buffer
  ignore(self.pipeless())
  true
}

///|
fn PugLexer::slash(self : PugLexer) -> Bool {
  if self.unit() == '/' {
    self.push(Slash)
    self.consume(1)
    true
  } else {
    false
  }
}

///|
fn PugLexer::colon(self : PugLexer) -> Bool {
  if self.unit() == ':' && self.unit(ahead=1) == ' ' {
    self.push(Colon)
    let mut i = self.pos + 1
    while i < self.src.length() && self.src.code_unit_at(i) == ' ' {
      i += 1
    }
    self.consume(i - self.pos)
    true
  } else {
    false
  }
}
