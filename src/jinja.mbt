// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One stretch of the brace surface between two tags. Statements carry their
/// inner text; the raw-bodied kinds — `trans`, `block lang=`, `raw` — are
/// resolved by the scanner itself.
priv enum Piece {
  PText(String)
  POut(Expr)
  PStmt(String, String, Int32) // word, inner text, source offset
  PTrans(TransSpec)
  PLang(String, String) // language, body
}

///|
priv struct Pieces {
  items : Array[Piece]
  mut at : Int32
}

///|
fn Pieces::next(self : Pieces) -> Piece? {
  if self.at < self.items.length() {
    let piece = self.items[self.at]
    self.at = self.at + 1
    Some(piece)
  } else {
    None
  }
}

///|
/// The brace surface: text with `{{ }}`, `{% %}` and `{# #}`, Jinja's
/// whitespace discipline, line statements when a prefix is set.
fn parse_braces(src : String, opts : ReadOpts) -> Array[Node] raise Fault {
  let source = if opts.keep_trailing_newline {
    src
  } else {
    strip_last_newline(src)
  }
  let ps : Pieces = { items: scan_braces(source, opts), at: 0, }
  let (nodes, stop, _) = parse_piece_block(ps, [])
  if stop != "" {
    raise lexical(0, "`\{stop}` closes nothing here")
  }
  nodes
}

///|
fn strip_last_newline(s : String) -> String {
  match s.strip_suffix("\r\n") {
    Some(without) => without.to_owned()
    None =>
      match s.strip_suffix("\n") {
        Some(without) => without.to_owned()
        None => s
      }
  }
}

///|
fn scan_braces(src : String, opts : ReadOpts) -> Array[Piece] raise Fault {
  let items : Array[Piece] = []
  let pending = StringBuilder()
  let mut skip_ws = false
  let c = Cur::make(src, 0, src.length())
  while c.at < c.end {
    let tag_at = c.at
    if c.eat("{{-") || c.eat("{{") {
      let left_trim = src.at(tag_at + 2) == 0x2D
      if left_trim {
        trim_pending_end(pending)
      }
      flush_text(items, pending, skip_ws)
      skip_ws = false
      let (expr, right_trim) = scan_output(src, c)
      items.push(POut(expr))
      if right_trim {
        skip_ws = true
      }
      continue
    }
    if c.eat("{#") {
      let left_trim = src.at(tag_at + 2) == 0x2D
      if left_trim {
        trim_pending_end(pending)
      }
      flush_text(items, pending, skip_ws)
      skip_ws = false
      match find_tag_end(src, c.at, "#}") {
        Some(at) => {
          let inner = src[c.at:at]
          c.at = at + 2
          if inner.has_suffix("-") {
            skip_ws = true
          }
        }
        None => raise lexical(c.base + c.at, "an unterminated comment")
      }
      continue
    }
    if c.eat("{%-") || c.eat("{%") {
      let left_trim = src.at(tag_at + 2) == 0x2D
      if left_trim {
        trim_pending_end(pending)
      } else if opts.lstrip_blocks {
        trim_pending_to_line_start(pending)
      }
      flush_text(items, pending, skip_ws)
      skip_ws = false
      scan_statement(items, src, c, opts, tag_at + c.base)
      continue
    }
    scan_plain_text(items, pending, c, opts, skip_ws)
    skip_ws = false
  }
  flush_text(items, pending, skip_ws)
  items
}

///|
/// One output `{{ … }}`; the cursor stands just past the opener.
fn scan_output(src : String, c : Cur) -> (Expr, Bool) raise Fault {
  let inner_end = match find_tag_end(src, c.at, "}}") {
    Some(at) => at
    None => raise lexical(c.base + c.at, "an unterminated output")
  }
  let inner = src[c.at:inner_end]
  let right_trim = inner.has_suffix("-")
  let body = if right_trim { inner[0:inner.length() - 1] } else { inner }
  c.at = inner_end + 2
  let sc = Cur::make(body.to_owned(), 0, body.length())
  sc.skip_ws()
  let expr = parse_expression(sc)
  sc.skip_ws()
  if sc.at != sc.end {
    raise lexical(sc.base + sc.at, "an output holds one expression")
  }
  (expr, right_trim)
}

///|
/// One statement tag, raw-bodied kinds included.
fn scan_statement(
  items : Array[Piece],
  src : String,
  c : Cur,
  opts : ReadOpts,
  _tag_at : Int32,
) -> Unit raise Fault {
  c.skip_ws()
  let word_start = c.at
  while c.at < c.end && is_name_part(c.peek()) {
    c.at = c.at + 1
  }
  let word = src[word_start:c.at]
  if word.is_empty() {
    raise lexical(c.base + c.at, "a statement needs a word after `{%`")
  }
  let inner_end = match find_tag_end(src, c.at, "%}") {
    Some(at) => at
    None => raise lexical(c.base + c.at, "`\{word}` is not closed by `%}`")
  }
  let inner = src[c.at:inner_end]
  let opener_right_trim = inner.has_suffix("-")
  let body = if opener_right_trim { inner[0:inner.length() - 1] } else { inner }
  // The body's own offset in the template: faults inside it must point at
  // the expression, not at the tag.
  let body_at = c.at +
    (inner.length() - body.trim_start(chars=ws_chars).length()) -
    (if opener_right_trim { 0 } else { 0 })
  let body = body.trim().to_owned()
  c.at = inner_end + 2
  if opts.trim_blocks && !opener_right_trim {
    if c.peek() == 0x0A {
      c.at = c.at + 1
    } else if c.peek() == 0x0D && c.peek_at(1) == 0x0A {
      c.at = c.at + 2
    }
  }
  match word {
    "raw" => {
      let (text, closer_left_trim) = scan_verbatim(c, "endraw")
      let trimmed_head = if opener_right_trim {
        text.trim_start(chars=ws_chars)
      } else {
        text
      }
      let trimmed_tail = if closer_left_trim {
        trimmed_head.trim_end(chars=ws_chars)
      } else {
        trimmed_head
      }
      items.push(PText(trimmed_tail.to_owned()))
      return
    }
    "comment" => {
      let (_, _) = scan_verbatim(c, "endcomment")
      return
    }
    "trans" => {
      scan_trans(items, src, c, body)
      return
    }
    "block" =>
      if body.has_prefix("lang=") || body.has_prefix("lang =") {
        let eq = body.find("=").unwrap_or(4)
        let lang = body[eq + 1:body.length()].trim().to_owned()
        scan_lang_block(items, src, c, opts, lang, opener_right_trim)
        return
      }
    _ => ()
  }
  items.push(PStmt(word.to_owned(), body.to_string(), c.base + body_at))
}

///|
let ws_chars : StringView = " \t\r\n"

///|
/// A verbatim body up to `{% end… %}` or `{%- end… %}`: the text between,
/// and whether the closer asked for the text trimmed.
fn scan_verbatim(c : Cur, closer : String) -> (StringView, Bool) raise Fault {
  let src = c.src
  let from = c.at
  // The closer may carry any spacing and an optional left trim.
  let mut i = from
  let mut at = -1
  let mut used_trim = false
  while i + 2 < src.length() {
    if src.at(i) == 0x7B && src.at(i + 1) == 0x25 {
      let mut j = i + 2
      if src.at(j) == 0x2D {
        j = j + 1
      }
      while j < src.length() && src.at(j) == 0x20 {
        j = j + 1
      }
      let word = view_sub(src, j, j + closer.length())
      if word == closer {
        let mut k = j + closer.length()
        while k < src.length() && src.at(k) == 0x20 {
          k = k + 1
        }
        if k + 1 < src.length() && src.at(k) == 0x25 && src.at(k + 1) == 0x7D {
          at = i
          used_trim = src.at(i + 2) == 0x2D
          break
        }
      }
    }
    i = i + 1
  }
  if at < 0 {
    raise lexical(from, "`\{closer}` never closes")
  }
  let body = src[from:at]
  let mut k = at + 2
  while k + 1 < src.length() && !(src.at(k) == 0x25 && src.at(k + 1) == 0x7D) {
    k = k + 1
  }
  c.at = k + 2
  (body, used_trim)
}

///|
/// Text up to the next tag, honouring a line-statement prefix.
fn scan_plain_text(
  items : Array[Piece],
  pending : StringBuilder,
  c : Cur,
  opts : ReadOpts,
  skip_ws : Bool,
) -> Unit {
  let start = c.at
  let mut i = c.at
  while i < c.end {
    let unit = c.src.at(i)
    if unit == 0x7B && i + 1 < c.end {
      let next = c.src.at(i + 1)
      if next == 0x7B || next == 0x25 || next == 0x23 {
        break
      }
    }
    i = i + 1
  }
  let text = c.src[start:i]
  c.at = i
  let body = if skip_ws { text.trim_start(chars=ws_chars) } else { text }
  match opts.line {
    Some(prefix) => scan_line_statements(items, pending, body, prefix)
    None => pending.write_string(body.to_owned())
  }
}

///|
/// Lines beginning with the prefix are statements; a doubled prefix comments
/// the line away.
fn scan_line_statements(
  items : Array[Piece],
  pending : StringBuilder,
  text : StringView,
  prefix : String,
) -> Unit {
  let n = text.length()
  let mut line_start = 0
  let mut i = 0
  while i <= n {
    if i == n || text.at(i) == 0x0A {
      let line = view_sub(text, line_start, i)
      let is_stmt = line.has_prefix(prefix)
      let is_comment = is_stmt && line.has_prefix(prefix + prefix)
      if is_stmt && !is_comment {
        flush_text(items, pending, false)
        let stmt = view_sub(line, prefix.length(), i)
        let mut word_end = 0
        while word_end < stmt.length() && is_name_part(stmt.at(word_end)) {
          word_end = word_end + 1
        }
        let word = view_sub(stmt, 0, word_end)
        let rest = view_sub(stmt, word_end, stmt.length()).trim()
        items.push(PStmt(word.to_owned(), rest.to_owned(), 0))
      } else {
        pending.write_string(line.to_owned())
      }
      line_start = i + 1
    }
    i = i + 1
  }
}

///|
fn trim_pending_end(pending : StringBuilder) -> Unit {
  let text = pending.to_string()
  pending.reset()
  pending.write_string(text.trim_end(chars=ws_chars).to_owned())
}

///|
fn trim_pending_to_line_start(pending : StringBuilder) -> Unit {
  let text = pending.to_string()
  pending.reset()
  match text.rev_find("\n") {
    Some(at) => pending.write_string(text[0:at + 1].to_owned())
    None => ()
  }
}

///|
fn flush_text(
  items : Array[Piece],
  pending : StringBuilder,
  skip_ws : Bool,
) -> Unit {
  let text = pending.to_string()
  pending.reset()
  let body = if skip_ws { text.trim_start(chars=ws_chars) } else { text }
  if !body.is_empty() {
    items.push(PText(body.to_owned()))
  }
}

///|
/// The end of a tag, skipping quoted strings so a `%}` inside text does not
/// close early.
fn find_tag_end(src : String, from : Int32, closer : String) -> Int32? {
  let n = src.length()
  let m = closer.length()
  let mut i = from
  while i < n {
    let unit = src.at(i)
    if unit == 0x27 || unit == 0x22 {
      let quote = unit
      i = i + 1
      while i < n {
        if src.at(i) == 0x5C {
          i = i + 2
          continue
        }
        if src.at(i) == quote {
          break
        }
        i = i + 1
      }
      i = i + 1
      continue
    }
    if unit == closer.at(0) && i + m <= n && src[i:i + m] == closer {
      return Some(i)
    }
    i = i + 1
  }
  None
}

///|
/// `{% trans %}`: bindings in the head, then raw singular text up to
/// `{% pluralize %}` and `{% endtrans %}`.
fn scan_trans(
  items : Array[Piece],
  src : String,
  c : Cur,
  head : String,
) -> Unit raise Fault {
  let head_cur = Cur::make(head, 0, head.length())
  let bindings = []
  let mut count_name : String? = None
  head_cur.skip_ws()
  while is_name_start(head_cur.peek()) {
    let name = head_cur.read_word()
    head_cur.skip_ws()
    if head_cur.peek() != 0x3D {
      count_name = Some(name)
      continue
    }
    head_cur.at = head_cur.at + 1
    head_cur.skip_ws()
    bindings.push((name, parse_expression(head_cur)))
    head_cur.skip_ws()
    if head_cur.peek() == 0x2C {
      head_cur.at = head_cur.at + 1
      head_cur.skip_ws()
    }
  }
  let (singular, plural, after) = scan_trans_body(src, c.at)
  c.at = after
  items.push(
    PTrans({
      singular: singular.to_owned(),
      plural: match plural {
        Some(p) => Some(p.to_owned())
        None => None
      },
      bindings,
      count_name,
    }),
  )
}

///|
fn scan_trans_body(
  src : String,
  from : Int32,
) -> (StringView, StringView?, Int32) raise Fault {
  let first = match find_trans_marker(src, from) {
    Some(found) => found
    None => raise lexical(from, "`trans` is never closed")
  }
  let (kind, at, after) = first
  if kind == "endtrans" {
    return (src[from:at].to_owned(), None, after)
  }
  // A pluralize: singular text ends here, plural text follows.
  let second = match find_trans_marker(src, after) {
    Some(found) => found
    None => raise lexical(after, "`pluralize` is never closed")
  }
  let (kind2, at2, after2) = second
  if kind2 != "endtrans" {
    raise lexical(at2, "a second `pluralize` where `endtrans` belongs")
  }
  (src[from:at], Some(src[after:at2].to_owned()), after2)
}

///|
fn find_trans_marker(src : String, from : Int32) -> (String, Int32, Int32)? {
  let n = src.length()
  let mut i = from
  while i < n {
    if src.at(i) == 0x7B && i + 1 < n && src.at(i + 1) == 0x25 {
      let word_start = i + 2
      if src.at(word_start) == 0x2D {
        i = word_start
        continue
      }
      let mut j = word_start
      while j < n && is_name_part(src.at(j)) {
        j = j + 1
      }
      let word = src[word_start:j]
      if word == "pluralize" || word == "endtrans" {
        let mut close = j
        while close + 1 < n &&
              !(src.at(close) == 0x25 && src.at(close + 1) == 0x7D) {
          close = close + 1
        }
        if close + 1 < n {
          return Some((word.to_owned(), i, close + 2))
        }
      }
      i = j
      continue
    }
    i = i + 1
  }
  None
}

///|
/// `{% block lang=pug %} … {% endblock %}`, nest-counted so an inner block of
/// either kind belongs to the body. Under `force`, a language this surface
/// will not take stays literal: the markers pass through and the body reads in
/// the outer language.
fn scan_lang_block(
  items : Array[Piece],
  src : String,
  c : Cur,
  opts : ReadOpts,
  lang : String,
  opener_right_trim : Bool,
) -> Unit raise Fault {
  let allowed = lang_allowed(opts.syntax, opts.force, lang)
  let mut depth = 1
  let mut i = c.at
  let mut body_end = -1
  let mut after = -1
  while i < src.length() {
    if src.at(i) == 0x7B && i + 1 < src.length() && src.at(i + 1) == 0x25 {
      let word_start = i + 2
      let mut j = word_start
      while j < src.length() && is_name_part(src.at(j)) {
        j = j + 1
      }
      let word = src[word_start:j]
      if word == "block" {
        depth = depth + 1
      } else if word == "endblock" {
        depth = depth - 1
        if depth == 0 {
          body_end = i
          let mut k = j
          while k + 1 < src.length() &&
                !(src.at(k) == 0x25 && src.at(k + 1) == 0x7D) {
            k = k + 1
          }
          after = k + 2
          break
        }
      }
      i = j
      continue
    }
    i = i + 1
  }
  if body_end < 0 {
    raise lexical(c.base + c.at, "`block lang=\{lang}` is never closed")
  }
  let body = src[c.at:body_end]
  c.at = after
  if allowed {
    items.push(PLang(lang, body.to_owned()))
  } else {
    items.push(PText("{% block lang=\{lang} %}\{body}{% endblock %}"))
  }
  ignore(opener_right_trim)
}

///|
/// Under `force` a surface takes its own language and the html fallback, and
/// nothing else: `lang=md` inside a forced pug template is raw.
fn lang_allowed(outer : Syntax, force : Bool, lang : String) -> Bool {
  if !force {
    return true
  }
  let inner = normalise_lang(lang)
  if inner == outer {
    return true
  }
  outer != Html && inner == Html
}

///|
fn normalise_lang(lang : String) -> Syntax {
  match lang {
    "pug" | "indent" => Pug
    "md" | "markdown" => Markdown
    _ => Html
  }
}

///|
/// One statement's inner text, parsed; bodies are read from the piece stream
/// that follows.
fn parse_statement(
  word : String,
  body : String,
  ps : Pieces,
  at : Int32,
) -> Node raise Fault {
  let c = Cur::from(body, 0, body.length(), at)
  c.skip_ws()
  match word {
    "for" => {
      let names = []
      names.push(c.read_word())
      c.skip_ws()
      while c.peek() == 0x2C {
        c.at = c.at + 1
        c.skip_ws()
        names.push(c.read_word())
        c.skip_ws()
      }
      if c.peek_name() != "in" {
        raise lexical(c.base + c.at, "`for` wants `in` after its names")
      }
      ignore(c.take_name())
      c.skip_ws()
      // The iterable stops at a bare `if` or `recursive`: those belong to the
      // statement, not the expression.
      let iter_end = find_clause_end(c, ["if", "recursive"])
      let iter = parse_expression(Cur::make(c.src, c.at, iter_end))
      c.at = iter_end
      c.skip_ws()
      let mut filter : Expr? = None
      let mut recursive = false
      let mut going = true
      while going {
        going = false
        if c.peek_name() == "if" {
          ignore(c.take_name())
          c.skip_ws()
          filter = Some(parse_expression(c))
          c.skip_ws()
          going = true
        } else if c.peek_name() == "recursive" {
          ignore(c.take_name())
          c.skip_ws()
          recursive = true
          going = true
        }
      }
      let (for_body, stop, _) = parse_piece_block(ps, ["else", "endfor"])
      let otherwise = if stop == "else" {
        let (else_body, stop2, _) = parse_piece_block(ps, ["endfor"])
        require(stop2, "endfor")
        else_body
      } else {
        []
      }
      For(
        names~,
        iter~,
        filter~,
        recursive~,
        swap=false,
        body=for_body,
        otherwise~,
      )
    }
    "if" => {
      let branches = []
      let mut cond = parse_expression(c)
      c.skip_ws()
      if c.at != c.end {
        raise lexical(c.base + c.at, "`if` holds one condition")
      }
      let (then_body, stop, stop_head) = parse_piece_block(ps, [
        "elif", "else", "endif",
      ])
      branches.push((cond, then_body))
      let mut stop_word = stop
      while stop_word == "elif" {
        let hc = Cur::make(stop_head, 0, stop_head.length())
        hc.skip_ws()
        cond = parse_expression(hc)
        hc.skip_ws()
        if hc.at != hc.end {
          raise lexical(hc.base + hc.at, "`elif` holds one condition")
        }
        let (next_body, stop2, _) = parse_piece_block(ps, [
          "elif", "else", "endif",
        ])
        branches.push((cond, next_body))
        stop_word = stop2
      }
      let otherwise = if stop_word == "else" {
        let (else_body, stop3, _) = parse_piece_block(ps, ["endif"])
        require(stop3, "endif")
        else_body
      } else {
        require(stop_word, "endif")
        []
      }
      If(branches, otherwise)
    }
    "set" => {
      c.skip_ws()
      let first = c.read_word()
      c.skip_ws()
      if c.peek() == 0x2E {
        // A dotted target: `set ns.attr = value`.
        let path = [first]
        while c.peek() == 0x2E {
          c.at = c.at + 1
          path.push(c.read_word())
          c.skip_ws()
        }
        if c.peek() != 0x3D {
          raise lexical(c.base + c.at, "a dotted `set` wants `=`")
        }
        c.at = c.at + 1
        c.skip_ws()
        SetPath(path, parse_expression(c))
      } else if c.peek() == 0x3D {
        c.at = c.at + 1
        c.skip_ws()
        SetVar([first], parse_expression(c, with_tuple=true))
      } else if c.at >= c.end {
        // Block assignment: `{% set x %} … {% endset %}`.
        let (block_body, stop, _) = parse_piece_block(ps, ["endset"])
        require(stop, "endset")
        SetBlock(first, block_body)
      } else {
        raise lexical(c.base + c.at, "`set` wants `=` or a block")
      }
    }
    "extends" => Extends(parse_expression(c))
    "block" => {
      let name = c.read_word()
      let mut scoped = false
      let mut required = false
      let mut mod : BlockMod = Override
      c.skip_ws()
      while c.at < c.end {
        match c.read_word() {
          "scoped" => scoped = true
          "required" => required = true
          "append" => mod = Append
          "prepend" => mod = Prepend
          other =>
            raise lexical(c.base + c.at, "`block` does not take `\{other}`")
        }
        c.skip_ws()
      }
      let (block_body, stop, _) = parse_piece_block(ps, ["endblock"])
      require(stop, "endblock")
      Block(name, { body: block_body, scoped, required, mod, })
    }
    "include" => {
      let target = parse_expression(c)
      c.skip_ws()
      let (ignore_missing, with_context) = read_context_flags(c, false, true)
      Include(target, ignore_missing, with_context)
    }
    "import" => {
      let target = parse_expression(c)
      c.skip_ws()
      if c.peek_name() != "as" {
        raise lexical(c.base + c.at, "`import` wants `as` and a name")
      }
      ignore(c.take_name())
      c.skip_ws()
      let as_name = c.read_word()
      c.skip_ws()
      let (_, with_context) = read_context_flags(c, false, false)
      Import(target, as_name, with_context)
    }
    "from" => {
      let target = parse_expression(c)
      c.skip_ws()
      if c.peek_name() != "import" {
        raise lexical(c.base + c.at, "`from` wants `import`")
      }
      ignore(c.take_name())
      c.skip_ws()
      let wanted = []
      let mut going = true
      while going {
        going = false
        let name = c.read_word()
        c.skip_ws()
        let as_name = if c.peek_name() == "as" {
          ignore(c.take_name())
          c.skip_ws()
          Some(c.read_word())
        } else {
          None
        }
        wanted.push((name, as_name))
        c.skip_ws()
        if c.peek() == 0x2C {
          c.at = c.at + 1
          c.skip_ws()
          going = true
        }
      }
      c.skip_ws()
      let (_, with_context) = read_context_flags(c, false, false)
      FromImport(target, wanted, with_context)
    }
    "macro" => {
      let name = c.read_word()
      c.skip_ws()
      let (params, defaults, rest) = parse_params(c)
      let (macro_body, stop, _) = parse_piece_block(ps, ["endmacro"])
      require(stop, "endmacro")
      MacroDef(name, {
        name,
        params,
        defaults,
        rest,
        body: macro_body,
        home: {},
      })
    }
    "call" => {
      let params = if c.peek() == 0x28 {
        c.at = c.at + 1
        let (p, d, r) = parse_params(c)
        ignore(d)
        ignore(r)
        p
      } else {
        []
      }
      c.skip_ws()
      let call = parse_expression(c)
      if !(call is Call(_, _)) {
        raise lexical(c.base + c.at, "a `call` block ends in a macro call")
      }
      let (call_body, stop, _) = parse_piece_block(ps, ["endcall"])
      require(stop, "endcall")
      CallBlock(params, call, call_body)
    }
    "filter" => {
      let chain = []
      let mut going = true
      while going {
        going = false
        let name = c.read_word()
        c.skip_ws()
        let args = if c.peek() == 0x28 {
          c.at = c.at + 1
          parse_call_args(c)
        } else {
          []
        }
        chain.push((name, args))
        c.skip_ws()
        if c.peek() == 0x7C {
          c.at = c.at + 1
          c.skip_ws()
          going = true
        }
      }
      let (filter_body, stop, _) = parse_piece_block(ps, ["endfilter"])
      require(stop, "endfilter")
      FilterBlock(chain, filter_body)
    }
    "with" => {
      let bindings = []
      c.skip_ws()
      while c.at < c.end {
        let name = c.read_word()
        c.skip_ws()
        if c.peek() != 0x3D {
          raise lexical(c.base + c.at, "`with` binds with `=`")
        }
        c.at = c.at + 1
        c.skip_ws()
        bindings.push((name, parse_expression(c)))
        c.skip_ws()
        if c.peek() == 0x2C {
          c.at = c.at + 1
          c.skip_ws()
        }
      }
      let (with_body, stop, _) = parse_piece_block(ps, ["endwith"])
      require(stop, "endwith")
      With(bindings, with_body)
    }
    "autoescape" => {
      let setting = match c.peek_name() {
        "on" => Lit(Bool(true))
        "off" => Lit(Bool(false))
        _ => parse_expression(c)
      }
      let (escape_body, stop, _) = parse_piece_block(ps, ["endautoescape"])
      require(stop, "endautoescape")
      Autoescape(setting, escape_body)
    }
    "do" => {
      let exprs = []
      exprs.push(parse_expression(c))
      c.skip_ws()
      while c.peek() == 0x2C {
        c.at = c.at + 1
        c.skip_ws()
        exprs.push(parse_expression(c))
        c.skip_ws()
      }
      Do(exprs)
    }
    "debug" => Debug
    "show" => {
      let cond = parse_expression(c)
      let (show_body, stop, _) = parse_piece_block(ps, ["endshow"])
      require(stop, "endshow")
      Show(cond, show_body)
    }
    "once" => {
      let key = ignore_key(c)
      let (once_body, stop, _) = parse_piece_block(ps, ["endonce"])
      require(stop, "endonce")
      Once(key, once_body)
    }
    "break" => Break
    "continue" => Continue
    "endfor"
    | "endif"
    | "endset"
    | "endblock"
    | "endmacro"
    | "endcall"
    | "endfilter"
    | "endwith"
    | "endautoescape"
    | "endshow"
    | "endonce"
    | "endraw"
    | "endtrans"
    | "endcomment"
    | "elif"
    | "else" => raise lexical(0, "`\{word}` closes nothing here")
    other => raise lexical(0, "no such statement: `\{other}`")
  }
}

///|
fn ignore_key(c : Cur) -> String? {
  let text = c.src[c.at:c.end].trim().to_owned()
  let stripped = match text.strip_prefix("\"") {
    Some(a) =>
      match a.strip_suffix("\"") {
        Some(b) => b.to_owned()
        None => text.to_string()
      }
    None => text.to_string()
  }
  if stripped.is_empty() {
    None
  } else {
    Some(stripped)
  }
}

///|
fn require(stop : String, wanted : String) -> Unit raise Fault {
  if stop != wanted {
    raise lexical(0, "expected `\{wanted}`")
  }
}

///|
/// Macro parameters: `name`, `name = default`, `...rest`.
fn parse_params(
  c : Cur,
) -> (Array[String], Array[(Int32, Expr)], String?) raise Fault {
  let params = []
  let defaults = []
  let mut rest : String? = None
  if c.peek() != 0x28 {
    return (params, defaults, rest)
  }
  c.at = c.at + 1
  c.skip_ws()
  if c.peek() == 0x29 {
    c.at = c.at + 1
    return (params, defaults, rest)
  }
  let mut going = true
  while going {
    going = false
    c.skip_ws()
    if c.peek() == 0x2E && c.peek_at(1) == 0x2E && c.peek_at(2) == 0x2E {
      c.at = c.at + 3
      c.skip_ws()
      rest = Some(c.read_word())
      c.skip_ws()
    } else {
      let name = c.read_word()
      params.push(name)
      c.skip_ws()
      if c.peek() == 0x3D {
        c.at = c.at + 1
        c.skip_ws()
        defaults.push((params.length() - 1, parse_expression(c)))
        c.skip_ws()
      }
    }
    if c.peek() == 0x2C {
      c.at = c.at + 1
      going = true
    } else if c.peek() == 0x29 {
      c.at = c.at + 1
    } else {
      raise lexical(c.base + c.at, "parameters end at `)`")
    }
  }
  (params, defaults, rest)
}

///|
/// `ignore missing`, `with context`, `without context`, in any order.
fn read_context_flags(
  c : Cur,
  default_missing : Bool,
  default_context : Bool,
) -> (Bool, Bool) raise Fault {
  let mut ignore_missing = default_missing
  let mut with_context = default_context
  let mut going = true
  while going {
    going = false
    match c.peek_name() {
      "ignore" => {
        ignore(c.take_name())
        c.skip_ws()
        if c.peek_name() == "missing" {
          ignore(c.take_name())
          ignore_missing = true
          c.skip_ws()
          going = true
        } else {
          raise lexical(c.base + c.at, "`ignore` is followed by `missing`")
        }
      }
      "with" => {
        ignore(c.take_name())
        c.skip_ws()
        if c.peek_name() == "context" {
          ignore(c.take_name())
          with_context = true
          c.skip_ws()
          going = true
        } else {
          raise lexical(c.base + c.at, "`with` is followed by `context`")
        }
      }
      "without" => {
        ignore(c.take_name())
        c.skip_ws()
        if c.peek_name() == "context" {
          ignore(c.take_name())
          with_context = false
          c.skip_ws()
          going = true
        } else {
          raise lexical(c.base + c.at, "`without` is followed by `context`")
        }
      }
      _ => ()
    }
  }
  (ignore_missing, with_context)
}

///|
/// Assemble nodes until one of the stop words arrives; the stop word itself
/// is returned for the enclosing construct to check.
fn parse_piece_block(
  ps : Pieces,
  stops : Array[String],
) -> (Array[Node], String, String) raise Fault {
  let nodes : Array[Node] = []
  let mut going = true
  while going {
    going = false
    match ps.next() {
      Some(PText(text)) => {
        nodes.push(Text(text))
        going = true
      }
      Some(POut(expr)) => {
        nodes.push(Out(expr))
        going = true
      }
      Some(PTrans(spec)) => {
        nodes.push(Trans(spec))
        going = true
      }
      Some(PLang(lang, body)) => {
        nodes.push(LangBlock(lang, body))
        going = true
      }
      Some(PStmt(word, body, at)) => {
        if stops.contains(word) {
          return (nodes, word, body)
        }
        let node = parse_statement(word, body, ps, at)
        nodes.push(node)
        going = true
      }
      None =>
        if stops.is_empty() {
          return (nodes, "", "")
        } else {
          raise lexical(
            0,
            "expected one of \{join_texts(stops, ", ")} before the end",
          )
        }
    }
  }
  (nodes, "", "")
}

///|
/// Where the current clause ends: the next occurrence of one of the words at
/// bracket depth zero.
fn find_clause_end(c : Cur, words : Array[String]) -> Int32 {
  let mut depth = 0
  let mut i = c.at
  while i < c.end {
    let unit = unit_at(c.src, i)
    match unit {
      0x28 | 0x5B | 0x7B => depth = depth + 1
      0x29 | 0x5D | 0x7D => if depth > 0 { depth = depth - 1 }
      _ => ()
    }
    if depth == 0 && is_name_start(unit) {
      let start = i
      let mut j = i
      while j < c.end && is_name_part(c.src.at(j)) {
        j = j + 1
      }
      let word = c.src[start:j]
      if words.contains(word.to_owned()) {
        return start
      }
      i = j
      continue
    }
    i = i + 1
  }
  c.end
}
