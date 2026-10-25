///|
priv struct PugParser {
  tokens : Array[PugToken]
  mut at : Int32
  template : String
  mut mixins : Int32
  reading : Reading
}

///|
/// A source in the indentation syntax, read into the tree: the reader of
/// `pug`.
pub fn read_indent(
  source : String,
  reading : Reading,
) -> Array[Node] raise @spec.Refused {
  let template = reading.template
  let parser : PugParser = {
    tokens: lex_pug(source, template, reading, line=reading.line),
    at: 0,
    template,
    mixins: 0,
    reading,
  }
  let nodes : Array[Node] = []
  while !(parser.peek().tok is Eos) {
    match parser.peek().tok {
      Newline => parser.skip()
      TextHtml(_) => nodes.append(parser.text_html())
      _ => nodes.append(parser.expr())
    }
  }
  nodes
}

///|
fn PugParser::peek(self : PugParser) -> PugToken {
  self.tokens[self.at]
}

///|
fn PugParser::skip(self : PugParser) -> Unit {
  if self.at + 1 < self.tokens.length() {
    self.at += 1
  }
}

///|
fn PugParser::advance(self : PugParser) -> PugToken {
  let token = self.peek()
  self.skip()
  token
}

///|
fn PugParser::fail(self : PugParser, reason : String) -> @spec.Refused {
  let token = self.peek()
  Syntax(template=self.template, line=token.line, column=token.column, reason~)
}

///|
fn PugParser::src(self : PugParser, src : Src) -> Parser raise @spec.Refused {
  {
    template: self.template,
    tokens: lex_expression(
      src.text,
      self.template,
      line=src.line,
      column=src.column,
    ),
    at: 0,
    body: no_body,
  }
}

///|
/// An expression written in a line of the indentation syntax.
fn PugParser::expression(
  self : PugParser,
  src : Src,
) -> Expr raise @spec.Refused {
  let p = self.src(src)
  let expr = p.parse_expression()
  if !(p.current().tok is Eof) {
    raise p.fail("unexpected \{describe(p.current().tok)} after the expression")
  }
  expr
}

///|
fn PugParser::expr(self : PugParser) -> Array[Node] raise @spec.Refused {
  let token = self.peek()
  let line = Node::Line(token.line)
  let node : Node = match token.tok {
    Tag(name) => {
      self.skip()
      self.tag(Lit(Text(name)))
    }
    InterpTag(src) => {
      self.skip()
      self.tag(self.expression(src))
    }
    Id(_) | Class(_) => self.tag(Lit(Text("div")))
    Mixin(name, args) => {
      self.skip()
      self.mixin_def(name, args)
    }
    Call(name, args) => {
      self.skip()
      self.call(name, args)
    }
    Block(name, placement) => {
      self.skip()
      let body = if self.peek().tok is Indent { self.block() } else { [] }
      BlockDef({ name, body, scoped: false, required: false, placement, })
    }
    MixinBlock => {
      self.skip()
      if self.mixins == 0 {
        raise Syntax(
          template=self.template,
          line=token.line,
          column=token.column,
          reason="an anonymous block belongs inside a mixin",
        )
      }
      If([(Name("block"), [Out(Call(Name("block"), []))])], [])
    }
    Case(src) => {
      self.skip()
      self.case_(src)
    }
    Extends(path) => {
      self.skip()
      Extends(Lit(Text(resolve(self.template, path, line=token.line))))
    }
    Include(_) => self.include_file()
    Doctype(name) => {
      self.skip()
      Doctype(name)
    }
    Filter(_) => self.filter()
    Comment(text, buffer) => {
      self.skip()
      let block = self.text_block()
      if !buffer {
        return []
      }
      match block {
        Some(nodes) => Comment([Text(text), ..nodes])
        None => Comment([Text(text)])
      }
    }
    Text(_) | Interp(_, _) | StartTagInterp =>
      return [line, ..self.text(block=true)]
    TextHtml(_) => return self.text_html()
    Dot => {
      self.skip()
      return [line, ..self.text_block().unwrap_or([])]
    }
    Each(value, key, src) => {
      self.skip()
      let target : Target = match key {
        Some(k) => Tuple([Name(value), Name(k)])
        None => Name(value)
      }
      let iter = self.expression(src)
      let body = if self.peek().tok is Indent { self.block() } else { [] }
      let otherwise = if self.peek().tok is Else {
        self.skip()
        if self.peek().tok is Indent {
          self.block()
        } else {
          []
        }
      } else {
        []
      }
      For(
        target~,
        iter~,
        cond=None,
        recursive=false,
        each=true,
        body~,
        otherwise~,
      )
    }
    If(src, negate) => {
      self.skip()
      self.conditional(src, negate)
    }
    Stmt(src) => return self.statement(src)
    Yield => {
      self.skip()
      return [Yield]
    }
    Lang(name, force, src) => {
      self.skip()
      return [
        Line(src.line),
        ..self.reading.block(src.text, name, force, src.line),
      ]
    }
    Code(_, _) => raise self.fail("an output line needs a tag before =")
    Else | ElseIf(_) => raise self.fail("else follows an if")
    When(_) | Default =>
      raise self.fail("when and default belong inside a case")
    tok => raise self.fail("unexpected \{describe_pug(tok)}")
  }
  [line, node]
}

///|
fn describe_pug(tok : PugTok) -> String {
  match tok {
    Indent => "indentation"
    Outdent => "the end of the indented block"
    Newline => "a new line"
    Eos => "the end of the template"
    Colon => ":"
    Slash => "/"
    Attrs(_) => "attributes"
    _ => "this token"
  }
}

///|
/// `indent node* outdent`.
fn PugParser::block(self : PugParser) -> Array[Node] raise @spec.Refused {
  if !(self.advance().tok is Indent) {
    raise self.fail("expected an indented block")
  }
  let nodes : Array[Node] = []
  while !(self.peek().tok is Outdent) {
    match self.peek().tok {
      Newline => self.skip()
      TextHtml(_) => nodes.append(self.text_html())
      Eos => raise self.fail("unexpected end of the template")
      _ => nodes.append(self.expr())
    }
  }
  self.skip()
  nodes
}

///|
/// The rest of a tag: shorthand, attributes, then text, an output, a `:`
/// expansion or `/`, then the indented block.
fn PugParser::tag(self : PugParser, tag : Expr) -> Node raise @spec.Refused {
  let (attrs, splats) = self.attributes()
  let mut text_only = false
  if self.peek().tok is Dot {
    text_only = true
    self.skip()
  }
  let body = []
  let mut self_close = false
  match self.peek().tok {
    Text(_) | Interp(_, _) | StartTagInterp =>
      body.append(self.text(block=false))
    Code(src, escape) => {
      self.skip()
      let expr = self.expression(src)
      body.push(if escape { Out(expr) } else { Raw(expr) })
    }
    Colon => {
      self.skip()
      body.append(self.expr())
    }
    Slash => {
      self.skip()
      self_close = true
    }
    Newline | Indent | Outdent | Eos | StartPipeless | EndTagInterp => ()
    tok => raise self.fail("unexpected \{describe_pug(tok)} after a tag")
  }
  while self.peek().tok is Newline {
    self.skip()
  }
  if text_only {
    body.append(self.text_block().unwrap_or([]))
  } else if self.peek().tok is Indent {
    body.append(self.block())
  }
  Element({ tag, attrs, splats, self_close, body, })
}

///|
/// Shorthand ids and classes, attribute lists and `&attributes`, in the
/// order written.
fn PugParser::attributes(
  self : PugParser,
) -> (Array[Attr], Array[Expr]) raise @spec.Refused {
  let attrs : Array[Attr] = []
  let splats : Array[Expr] = []
  let mut seen_id = false
  for ;; {
    match self.peek().tok {
      Id(name) => {
        if seen_id {
          raise self.fail("a duplicate id attribute is not allowed")
        }
        seen_id = true
        self.skip()
        attrs.push(Attr::{
          name: "id",
          value: Some(Lit(Text(name))),
          escape: false,
        })
      }
      Class(name) => {
        self.skip()
        attrs.push(Attr::{
          name: "class",
          value: Some(Lit(Text(name))),
          escape: false,
        })
      }
      Attrs(list) => {
        self.skip()
        for attr in list {
          if attr.name == "id" {
            if seen_id {
              raise self.fail("a duplicate id attribute is not allowed")
            }
            seen_id = true
          }
          let name = if attr.name == ":key" { "data-key" } else { attr.name }
          let value = match attr.value {
            Some(src) => Some(self.expression(src))
            None => None
          }
          attrs.push(Attr::{ name, value, escape: attr.escape, })
        }
      }
      AttrBlock(src) => {
        self.skip()
        splats.push(self.expression(src))
      }
      _ => break
    }
  }
  (attrs, splats)
}

///|
/// Text, interpolations and tag interpolations on one line; in a block,
/// consecutive text lines join with a newline.
fn PugParser::text(
  self : PugParser,
  block~ : Bool,
) -> Array[Node] raise @spec.Refused {
  let nodes : Array[Node] = []
  for ;; {
    let token = self.peek()
    match token.tok {
      Text(t) => {
        self.skip()
        nodes.push(Text(t))
      }
      Interp(src, escape) => {
        self.skip()
        let expr = self.expression(src)
        nodes.push(if escape { Out(expr) } else { Raw(expr) })
      }
      StartTagInterp => {
        self.skip()
        nodes.append(self.expr())
        if !(self.advance().tok is EndTagInterp) {
          raise self.fail("expected ] closing the tag interpolation")
        }
      }
      Newline if block => {
        self.skip()
        if self.peek().tok is (Text(_) | Interp(_, _)) {
          nodes.push(Text("\n"))
        }
      }
      _ => break
    }
  }
  nodes
}

///|
/// Consecutive HTML lines, joined with newlines, and the blocks indented
/// under them.
fn PugParser::text_html(self : PugParser) -> Array[Node] raise @spec.Refused {
  let nodes : Array[Node] = []
  let mut html_open = false
  for ;; {
    let token = self.peek()
    match token.tok {
      TextHtml(t) => {
        self.skip()
        if html_open {
          nodes.push(Text("\n"))
        }
        nodes.push(Text(t))
        html_open = true
        while self.peek().tok is (Interp(_, _) | TextHtml(_)) &&
              self.peek().line == token.line {
          match self.advance().tok {
            Interp(src, escape) => {
              let expr = self.expression(src)
              nodes.push(if escape { Out(expr) } else { Raw(expr) })
            }
            TextHtml(more) => nodes.push(Text(more))
            _ => ()
          }
        }
      }
      Interp(src, escape) => {
        self.skip()
        let expr = self.expression(src)
        nodes.push(if escape { Out(expr) } else { Raw(expr) })
      }
      Indent => {
        let inner = self.block()
        if inner.iter().any(n => n is Text(_)) && html_open {
          nodes.push(Text("\n"))
        }
        nodes.append(inner)
      }
      Newline => self.skip()
      _ => break
    }
  }
  nodes
}

///|
/// The text block of a `.`, a comment or a filter.
fn PugParser::text_block(self : PugParser) -> Array[Node]? raise @spec.Refused {
  if !(self.peek().tok is StartPipeless) {
    return None
  }
  self.skip()
  let nodes : Array[Node] = []
  for ;; {
    let token = self.advance()
    match token.tok {
      EndPipeless => break
      Text(t) => nodes.push(Text(t))
      Newline => nodes.push(Text("\n"))
      Interp(src, escape) => {
        let expr = self.expression(src)
        nodes.push(if escape { Out(expr) } else { Raw(expr) })
      }
      StartTagInterp => {
        nodes.append(self.expr())
        if !(self.advance().tok is EndTagInterp) {
          raise self.fail("expected ] closing the tag interpolation")
        }
      }
      Eos => raise self.fail("the text block is never closed")
      tok => raise self.fail("unexpected \{describe_pug(tok)} in a text block")
    }
  }
  Some(nodes)
}

///|
fn PugParser::raw_text(self : PugParser) -> String raise @spec.Refused {
  match self.text_block() {
    Some(nodes) => {
      let buf = StringBuilder()
      for node in nodes {
        if node is Text(t) {
          buf.write_string(t)
        }
      }
      buf.to_string()
    }
    None => ""
  }
}

///|
fn PugParser::conditional(
  self : PugParser,
  src : Src,
  negate : Bool,
) -> Node raise @spec.Refused {
  let first = self.expression(src)
  let cond = if negate { Not(first) } else { first }
  let branches = [
    (cond, if self.peek().tok is Indent { self.block() } else { [] }),
  ]
  let mut otherwise = []
  for ;; {
    match self.peek().tok {
      Newline => self.skip()
      ElseIf(src) => {
        self.skip()
        let cond = self.expression(src)
        branches.push(
          (cond, if self.peek().tok is Indent { self.block() } else { [] }),
        )
      }
      Else => {
        self.skip()
        if self.peek().tok is Indent {
          otherwise = self.block()
        }
        break
      }
      _ => break
    }
  }
  If(branches, otherwise)
}

///|
/// `case`: arms with `when` and `default`; a `when` with no block falls
/// through to the next.
fn PugParser::case_(self : PugParser, src : Src) -> Node raise @spec.Refused {
  let subject = self.expression(src)
  if !(self.advance().tok is Indent) {
    raise self.fail("case needs an indented block of when and default")
  }
  let arms = []
  let mut pending = []
  let mut otherwise = []
  while !(self.peek().tok is Outdent) {
    match self.peek().tok {
      Newline | Comment(_, _) => {
        self.skip()
        ignore(self.text_block())
      }
      When(src) => {
        self.skip()
        let p = self.src(src)
        for ;; {
          pending.push(p.parse_expression())
          if !p.skip_op(",") {
            break
          }
        }
        if !(p.current().tok is Eof) {
          raise p.fail(
            "unexpected \{describe(p.current().tok)} after the expression",
          )
        }
        if !(self.peek().tok is Newline) {
          let body = self.expansion()
          arms.push((pending, body))
          pending = []
        }
      }
      Default => {
        self.skip()
        otherwise = self.expansion()
      }
      _ => raise self.fail("expected when, default or a new line")
    }
  }
  self.skip()
  if !pending.is_empty() {
    arms.push((pending, []))
  }
  Case(subject, arms, otherwise)
}

///|
/// `: node` on the same line, or an indented block.
fn PugParser::expansion(self : PugParser) -> Array[Node] raise @spec.Refused {
  if self.peek().tok is Colon {
    self.skip()
    self.expr()
  } else if self.peek().tok is Indent {
    self.block()
  } else {
    []
  }
}

///|
fn PugParser::mixin_def(
  self : PugParser,
  name : String,
  args : Src?,
) -> Node raise @spec.Refused {
  let params = match args {
    Some(src) => self.src(src).parse_signature()
    None => []
  }
  if !(self.peek().tok is Indent) {
    raise self.fail("mixin \{name} is declared without a body")
  }
  self.mixins += 1
  let body = self.block()
  self.mixins -= 1
  MacroDef({ name, params, body, pug: true, })
}

///|
/// `+name(args)(attributes)`: a call, with the attributes passed as
/// `attributes` and an indented block passed as the caller.
fn PugParser::call(
  self : PugParser,
  name : String,
  args : Src?,
) -> Node raise @spec.Refused {
  let call_args = match args {
    Some(src) => self.src(src).parse_call_args()
    None => []
  }
  let (attrs, splats) = self.attributes()
  if !attrs.is_empty() || !splats.is_empty() {
    call_args.push(Named("attributes", Attributes(attrs, splats)))
  }
  let call = Expr::Call(Name(name), call_args)
  let body = []
  match self.peek().tok {
    Text(_) | Interp(_, _) | StartTagInterp =>
      body.append(self.text(block=false))
    Code(src, escape) => {
      self.skip()
      let expr = self.expression(src)
      body.push(if escape { Out(expr) } else { Raw(expr) })
    }
    Colon => {
      self.skip()
      body.append(self.expr())
    }
    Dot => {
      self.skip()
      body.append(self.text_block().unwrap_or([]))
    }
    _ => ()
  }
  while self.peek().tok is Newline {
    self.skip()
  }
  if self.peek().tok is Indent {
    body.append(self.block())
  }
  if body.is_empty() {
    Out(call)
  } else {
    CallBlock([], call, body)
  }
}

///|
/// `include path` and `include:filter path`. A template file is read as a
/// template; anything else, or a filtered include, as text.
fn PugParser::include_file(self : PugParser) -> Node raise @spec.Refused {
  self.skip()
  let filters = []
  while self.peek().tok is Filter(name) {
    self.skip()
    filters.push((name, self.filter_args()))
  }
  let path = match self.advance().tok {
    Include(path) => path
    _ => raise self.fail("missing path for include")
  }
  let name = resolve(self.template, path, line=self.peek().line)
  let raw = !filters.is_empty() || !name.has_suffix(".pug")
  let block = if !raw && self.peek().tok is Indent { self.block() } else { [] }
  let mut node : Node = Include(
    Lit(Text(name)),
    missing=false,
    context=true,
    raw~,
    inline=true,
    block~,
  )
  for i = filters.length() - 1; i >= 0; i = i - 1 {
    let (fname, args) = filters[i]
    node = FilterBlock(Filter(None, fname, args), [node])
  }
  if self.peek().tok is Indent {
    raise self.fail("an include cannot carry a block")
  }
  node
}

///|
fn PugParser::filter_args(self : PugParser) -> Array[Arg] raise @spec.Refused {
  match self.peek().tok {
    Attrs(list) => {
      self.skip()
      let args = []
      for attr in list {
        let value = match attr.value {
          Some(src) => self.expression(src)
          None => Lit(Bool(true))
        }
        args.push(Named(attr.name, value))
      }
      args
    }
    _ => []
  }
}

///|
/// `:name(options)` with inline text, a nested filter, or a text block.
fn PugParser::filter(self : PugParser) -> Node raise @spec.Refused {
  let name = match self.advance().tok {
    Filter(n) => n
    _ => raise self.fail("expected a filter")
  }
  let args = self.filter_args()
  let body : Array[Node] = match self.peek().tok {
    Text(t) => {
      self.skip()
      [Text(t)]
    }
    Filter(_) => [self.filter()]
    _ => [Text(self.raw_text())]
  }
  FilterBlock(Filter(None, name, args), body)
}

///|
/// A `{% … %}` line: the statement reads its body from the indented lines
/// under it, closed by its end tag at the same level or by the indentation
/// coming back.
fn PugParser::statement(
  self : PugParser,
  src : Src,
) -> Array[Node] raise @spec.Refused {
  self.skip()
  let head = src.text.trim(chars=" \t")
  let word = head[2:].trim_start(chars=" -+")
  if word.has_prefix("trans") {
    return self.trans(src)
  }
  if word.has_prefix("raw") {
    let text = self.raw_text()
    self.closing("endraw")
    return [Line(src.line), Text(text)]
  }
  let tokens = lex_line(src, self.template)
  let parser : Parser = {
    template: self.template,
    tokens,
    at: 1,
    body: (p, ends) => self.statement_body(p, ends),
  }
  let nodes = parser.parse_statement()
  parser.expect(BlockEnd)
  nodes
}

///|
fn lex_line(src : Src, template : String) -> Array[Token] raise @spec.Refused {
  let lexer = Lexer::new(
    src.text,
    template,
    line=src.line,
    line_start=1 - src.column,
  )
  let out : Array[Token] = []
  lexer.skip_space()
  if !lexer.starts("{%") {
    raise lexer.fail("expected {%")
  }
  out.push(Token::{ tok: BlockBegin, line: lexer.line, column: lexer.column(), })
  lexer.advance(lexer.pos + 2)
  if lexer.starts("-") || lexer.starts("+") {
    lexer.advance(lexer.pos + 1)
  }
  let (line, column) = lexer.tag(out, l => l.close_block(false))
  out.push(Token::{ tok: BlockEnd, line, column, })
  lexer.skip_space()
  if !lexer.at_end() {
    raise lexer.fail("a statement line holds one tag")
  }
  out.push(Token::{ tok: Eof, line: lexer.line, column: lexer.column(), })
  out
}

///|
/// The body of a statement line: its indented block; then either the next
/// line at the same level is one of `ends` and its tokens take over, or the
/// statement closes where the indentation ended.
fn PugParser::statement_body(
  self : PugParser,
  p : Parser,
  ends : Array[String],
) -> Array[Node] raise @spec.Refused {
  let nodes = if self.peek().tok is Indent { self.block() } else { [] }
  while self.peek().tok is Newline {
    self.skip()
  }
  match self.peek().tok {
    Stmt(next) => {
      let tokens = lex_line(next, self.template)
      if tokens.length() > 1 &&
        tokens[1].tok is Name(word) &&
        ends.contains(word) {
        self.skip()
        p.tokens = tokens
        p.at = 1
        return nodes
      }
    }
    _ => ()
  }
  let closing = ends
    .iter()
    .find_first(w => w.has_prefix("end"))
    .unwrap_or(ends[0])
  let line = self.peek().line
  p.tokens = [
    Token::{ tok: BlockBegin, line, column: 1, },
    { tok: Name(closing), line, column: 1, },
    { tok: BlockEnd, line, column: 1, },
    { tok: Eof, line, column: 1, },
  ]
  p.at = 1
  nodes
}

///|
/// An optional `{% word %}` closing line.
fn PugParser::closing(
  self : PugParser,
  word : String,
) -> Unit raise @spec.Refused {
  while self.peek().tok is Newline {
    self.skip()
  }
  if self.peek().tok is Stmt(next) {
    let tokens = lex_line(next, self.template)
    if tokens.length() > 1 && tokens[1].tok is Name(w) && w == word {
      self.skip()
    }
  }
}

///|
/// `{% trans %}` with its text in the indented lines, `{% pluralize %}` and
/// `{% endtrans %}` at the same level; read the way the brace syntax reads
/// it.
fn PugParser::trans(
  self : PugParser,
  head : Src,
) -> Array[Node] raise @spec.Refused {
  let source = StringBuilder()
  source.write_string(head.text.trim(chars=" \t").to_owned())
  source.write_string(self.raw_text())
  while self.peek().tok is Newline {
    self.skip()
  }
  if self.peek().tok is Stmt(next) && next.text.contains("pluralize") {
    self.skip()
    source.write_string(next.text.trim(chars=" \t").to_owned())
    source.write_string(self.raw_text())
  }
  self.closing("endtrans")
  source.write_string("{% endtrans %}")
  let options = {
    trim_blocks: false,
    lstrip_blocks: false,
    keep_trailing_newline: true,
    line_statement: None,
    line_comment: None,
  }
  let tokens = lex_template(source.to_string(), options, self.template)
  for i, token in tokens {
    tokens[i] = { ..token, line: token.line + head.line - 1, }
  }
  let parser : Parser = {
    template: self.template,
    tokens,
    at: 1,
    body: no_body,
  }
  let nodes = parser.parse_statement()
  parser.expect(BlockEnd)
  nodes
}

///|
/// A path the indentation syntax names, relative to the template naming it
/// unless it starts with `/`; `.pug` is added when there is no extension.
pub fn resolve(
  template : String,
  path : String,
  line~ : Int32 = 0,
) -> String raise @spec.Refused {
  let path = path.trim(chars=" \t").to_owned()
  let joined = if path.has_prefix("/") {
    path[1:].to_owned()
  } else {
    match template.rev_find("/") {
      Some(at) => template[:at + 1].to_owned() + path
      None => path
    }
  }
  let parts : Array[String] = []
  for part in joined.split("/") {
    match part {
      "" | "." => ()
      ".." =>
        if parts.pop() is None {
          raise Unknown(template~, line~, kind="template", name=path)
        }
      p => parts.push(p.to_owned())
    }
  }
  let name = parts.join("/")
  let base = match name.rev_find("/") {
    Some(at) => name[at + 1:]
    None => name[:]
  }
  if base.contains(".") {
    name
  } else {
    name + ".pug"
  }
}
