// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One physical line of the indentation surface: its level, its content
/// without the indent, and where in the source it began.
priv struct Line {
  level : Int32
  text : StringView
  at : Int32
}

///|
priv struct Lines {
  items : Array[Line]
  mut at : Int32
}

///|
/// The indentation surface: a line beginning with `<` is HTML, one beginning
/// with `{%` is a block directive, anything else is a Pug line; nesting is
/// indentation and HTML lines carry their own closing tags.
fn parse_pug(src : String, opts : ReadOpts) -> Array[Node] raise Fault {
  let lines = read_lines(src)
  let ls : Lines = { items: merge_continuations(lines), at: 0, }
  let nodes = pug_block(ls, 0, opts)
  if ls.at < ls.items.length() {
    let line = ls.items[ls.at]
    raise lexical(line.at, "this line indents further than anything around it")
  }
  nodes
}

///|
fn read_lines(src : String) -> Array[Line] raise Fault {
  let out = []
  let n = src.length()
  let mut i = 0
  let mut line_start = 0
  let mut tab_unit : Bool? = None
  let mut space_width = 0
  while i <= n {
    if i == n || src.at(i) == 0x0A {
      let raw = view_sub(src[:], line_start, i).to_owned()
      let content = raw
        .trim_end(chars=String::make(1, (0x0D).unsafe_to_char()))
        .to_owned()
      // Measure the indent; blank lines carry no level of their own.
      let mut j = 0
      let mut tabs = 0
      let mut spaces = 0
      let mut mixed = false
      while j < content.length() {
        match content.at(j) {
          0x09 => {
            tabs = tabs + 1
            if spaces > 0 {
              mixed = true
            }
          }
          0x20 => {
            spaces = spaces + 1
            if tabs > 0 {
              mixed = true
            }
          }
          _ => break
        }
        j = j + 1
      }
      if mixed {
        raise lexical(line_start, "tabs and spaces do not mix in the indent")
      }
      if j < content.length() {
        let uses_tabs = tabs > 0
        match tab_unit {
          None =>
            if uses_tabs || spaces > 0 {
              tab_unit = Some(uses_tabs)
              if !uses_tabs && space_width == 0 && spaces > 0 {
                space_width = spaces
              }
            }
          Some(tabs_first) =>
            if tabs_first != uses_tabs {
              raise lexical(
                line_start, "the indent switched between tabs and spaces",
              )
            }
        }
        let level = if uses_tabs {
          tabs
        } else if space_width > 0 {
          spaces / space_width
        } else {
          0
        }
        if !uses_tabs && space_width > 0 && spaces % space_width != 0 {
          raise lexical(line_start, "the indent is not a whole number of steps")
        }
        if !uses_tabs && tab_unit is None {
          space_width = spaces
        }
        out.push({ level, text: content[j:content.length()], at: line_start, })
      }
      line_start = i + 1
    }
    i = i + 1
  }
  out
}

///|
/// Attribute sections may wrap: while brackets stay open, deeper lines join
/// the one above them (Slim's reason for three kinds of bracket).
fn merge_continuations(items : Array[Line]) -> Array[Line] {
  let out = []
  let mut i = 0
  while i < items.length() {
    let first = items[i]
    let mut text = first.text.to_owned()
    let mut j = i + 1
    while j < items.length() &&
          bracket_depth(text) > 0 &&
          items[j].level > first.level {
      text = text + " " + items[j].text.to_owned()
      j = j + 1
    }
    out.push({ level: first.level, text: text[:], at: first.at, })
    i = j
  }
  out
}

///|
/// How many attribute brackets stand open at the end of the text.
fn bracket_depth(text : String) -> Int32 {
  let mut depth = 0
  let mut i = 0
  let mut quote : UInt16 = 0
  while i < text.length() {
    let unit = text.at(i)
    if quote != 0 {
      if unit == quote {
        quote = 0
      }
    } else {
      match unit {
        0x22 | 0x27 => quote = unit
        0x28 | 0x5B | 0x7B => depth = depth + 1
        0x29 | 0x5D | 0x7D => if depth > 0 { depth = depth - 1 }
        _ => ()
      }
    }
    i = i + 1
  }
  depth
}

///|
/// Lines deeper than `level`, as nodes, stopping when the indent comes back.
fn pug_block(
  ls : Lines,
  level : Int32,
  opts : ReadOpts,
) -> Array[Node] raise Fault {
  let nodes = []
  while ls.at < ls.items.length() && ls.items[ls.at].level >= level {
    if ls.items[ls.at].level > level {
      let line = ls.items[ls.at]
      raise lexical(
        line.at,
        "this line indents further than anything around it",
      )
    }
    let node = pug_line(ls, level, opts)
    nodes.push(node)
  }
  nodes
}

///|
/// The indented children under the line at `ls.at`, which is consumed first.
fn pug_children(
  ls : Lines,
  my_level : Int32,
  opts : ReadOpts,
) -> Array[Node] raise Fault {
  ls.at = ls.at + 1
  if ls.at >= ls.items.length() || ls.items[ls.at].level <= my_level {
    return []
  }
  let child_level = ls.items[ls.at].level
  pug_block(ls, child_level, opts)
}

///|
fn pug_line(ls : Lines, level : Int32, opts : ReadOpts) -> Node raise Fault {
  let line = ls.items[ls.at]
  let text = line.text
  if text.is_empty() {
    ls.at = ls.at + 1
    return Text("")
  }
  let first = text.at(0)
  // `{% … %}`: a block directive line, or the raw-bodied kinds.
  if first == 0x7B && text.length() > 1 && text.at(1) == 0x25 {
    return pug_directive(ls, level, opts)
  }
  // Literal HTML: an opaque line that closes its own tags.
  if first == 0x3C {
    ls.at = ls.at + 1
    if text.contains("#") || text.contains("!") || text.contains("{") {
      let nodes = split_interpolation(text)
      nodes.push(Text("\n"))
      return Group(nodes)
    }
    return Text("\{text}\n")
  }
  // Slim's line prefixes are refused: the vocabulary is Jinja's.
  if first == 0x2D || (first == 0x3D && blank_then(text, 1)) {
    raise lexical(
      line.at,
      "line prefixes `-` and `=` are Slim's spelling; this surface speaks `{% %}` and `{{ }}`",
    )
  }
  // `| text` and `||text`: a text line.
  if first == 0x7C {
    ls.at = ls.at + 1
    let rest = view_sub(text, 1, text.length())
    let content = if rest.length() > 0 && rest.at(0) == 0x20 {
      view_sub(rest, 1, rest.length())
    } else {
      rest
    }
    if content.contains("#") || content.contains("!") || content.contains("{") {
      let nodes = split_interpolation(content)
      nodes.push(Text("\n"))
      return Group(nodes)
    }
    return Text("\{content}\n")
  }
  // Comments: `//` visible, `//-` silent.
  if first == 0x2F && text.length() > 1 && text.at(1) == 0x2F {
    let silent = text.length() > 2 && text.at(2) == 0x2D
    let head = if silent {
      view_sub(text, 3, text.length())
    } else {
      view_sub(text, 2, text.length())
    }
    let head_trimmed = head.trim().to_owned()
    let children = pug_children(ls, level, opts)
    if silent {
      return Text("")
    }
    if children.is_empty() {
      return Text("<!-- \{head_trimmed} -->\n")
    }
    for child in children {
      ignore(child)
    }
    return Comment(true, [Text("\{head_trimmed}\n"), ..children])
  }
  if text.has_prefix("doctype") {
    ls.at = ls.at + 1
    let name = view_sub(text, 7, text.length()).trim().to_owned()
    return Doctype(name)
  }
  pug_construct(ls, level, opts)
}

///|
fn blank_then(text : StringView, from : Int32) -> Bool {
  let mut i = from
  while i < text.length() {
    match text.at(i) {
      0x20 | 0x09 => i = i + 1
      _ => return false
    }
  }
  true
}

///|

///|
/// The keyword constructs of the surface: control flow, layout, mixins.
fn pug_construct(
  ls : Lines,
  level : Int32,
  opts : ReadOpts,
) -> Node raise Fault {
  let line = ls.items[ls.at]
  let text = line.text
  let word = first_word(text)
  match word {
    "extends" => {
      ls.at = ls.at + 1
      let path = path_literal(rest_of(text, word))
      Extends(Lit(Text(path)))
    }
    "block" => {
      let after = rest_of(text, word).trim()
      let mut mod : BlockMod = Override
      let mut name = after.to_owned()
      if after.has_prefix("append") {
        mod = Append
        name = view_sub(after, 6, after.length()).trim().to_owned()
      } else if after.has_prefix("prepend") {
        mod = Prepend
        name = view_sub(after, 7, after.length()).trim().to_owned()
      }
      let children = pug_children(ls, level, opts)
      Block(name, { body: children, scoped: false, required: false, mod, })
    }
    "append" | "prepend" => {
      let mod = if word == "append" { Append } else { Prepend }
      let name = rest_of(text, word).trim().to_owned()
      let children = pug_children(ls, level, opts)
      Block(name, { body: children, scoped: false, required: false, mod, })
    }
    "include" => {
      ls.at = ls.at + 1
      let rest = rest_of(text, word).trim()
      if rest.length() > 0 && rest.at(0) == 0x3A {
        let filter_name = first_word(view_sub(rest, 1, rest.length())).to_owned()
        let path = path_literal(
          view_sub(rest, 1 + filter_name.length(), rest.length()),
        )
        FilterBlock([(filter_name, [])], [Include(Lit(Text(path)), false, true)])
      } else {
        Include(Lit(Text(path_literal(rest))), false, true)
      }
    }
    "mixin" => {
      let head = rest_of(text, word).trim()
      let name = first_word(head).to_owned()
      let params_src = view_sub(head, name.length(), head.length()).to_owned()
      let c = Cur::make(params_src, 0, params_src.length())
      c.skip_ws()
      let (params, defaults, rest) = parse_params(c)
      let children = pug_children(ls, level, opts)
      MacroDef(name, { name, params, defaults, rest, body: children, home: {}, })
    }
    "each" | "for" => {
      let head = rest_of(text, word).trim()
      let names : Array[StringView] = []
      names.push(first_word(head))
      let mut tail = view_sub(head, names[0].length(), head.length()).trim()
      if tail.length() > 0 && tail.at(0) == 0x2C {
        tail = view_sub(tail, 1, tail.length()).trim()
        names.push(first_word(tail))
        tail = view_sub(tail, names[1].length(), tail.length()).trim()
      }
      if !tail.has_prefix("in") {
        raise lexical(line.at, "`each` wants `in` after its names")
      }
      let iter_src = view_sub(tail, 2, tail.length()).trim().to_owned()
      let ic = Cur::make(iter_src, 0, iter_src.length())
      let iter = parse_expression(ic)
      let swap = names.length() == 2
      let owned = []
      for name in names {
        owned.push(name.to_owned())
      }
      let children = pug_children(ls, level, opts)
      For(
        names=owned,
        iter~,
        filter=None,
        recursive=false,
        swap~,
        body=children,
        otherwise=[],
      )
    }
    "if" | "unless" => {
      let negate = word == "unless"
      let head = rest_of(text, word).trim().to_owned()
      let branches = []
      let mut cond = condition_of(head, negate)
      let children = pug_children(ls, level, opts)
      branches.push((cond, children))
      let mut otherwise = []
      let mut going = true
      while going {
        going = false
        if ls.at < ls.items.length() && ls.items[ls.at].level == level {
          let next_text = ls.items[ls.at].text
          if next_text.has_prefix("else") {
            let after_else = view_sub(next_text, 4, next_text.length()).trim()
            ls.at = ls.at + 1
            if after_else.has_prefix("if") {
              let head2 = view_sub(after_else, 2, after_else.length())
                .trim()
                .to_owned()
              cond = parse_head_expression(head2)
              let children2 = pug_children(ls, level, opts)
              branches.push((cond, children2))
              going = true
            } else {
              otherwise = pug_children(ls, level, opts)
            }
          }
        }
      }
      If(branches, otherwise)
    }
    "case" => {
      let head = rest_of(text, word).trim().to_owned()
      let subject = parse_head_expression(head)
      ls.at = ls.at + 1
      let arms = []
      let mut otherwise = []
      while ls.at < ls.items.length() && ls.items[ls.at].level > level {
        if ls.items[ls.at].level != level + 1 &&
          ls.items[ls.at].level > level + 1 {
          let arm_line = ls.items[ls.at]
          raise lexical(arm_line.at, "`case` arms sit one step under `case`")
        }
        let arm_text = ls.items[ls.at].text
        if arm_text.has_prefix("when") {
          let values_src = view_sub(arm_text, 4, arm_text.length())
            .trim()
            .to_owned()
          let values = []
          let vc = Cur::make(values_src, 0, values_src.length())
          vc.skip_ws()
          while vc.at < vc.end {
            values.push(parse_expression(vc))
            vc.skip_ws()
            if vc.peek() == 0x2C {
              vc.at = vc.at + 1
              vc.skip_ws()
            }
          }
          let children = pug_children(ls, ls.items[ls.at].level, opts)
          arms.push({ values, body: children, })
        } else if arm_text.has_prefix("default") {
          ls.at = ls.at + 1
          otherwise = pug_children(ls, level + 1, opts)
        } else {
          let arm_line = ls.items[ls.at]
          raise lexical(arm_line.at, "`case` wants `when` or `default`")
        }
      }
      Case(subject, arms, otherwise)
    }
    "else" => raise lexical(line.at, "`else` follows an `if`")
    _ => pug_element_or_call(ls, level, opts)
  }
}

///|
fn condition_of(head : String, negate : Bool) -> Expr raise Fault {
  let expr = parse_head_expression(head)
  if negate {
    Unary(Not, expr)
  } else {
    expr
  }
}

///|
fn parse_head_expression(head : String) -> Expr raise Fault {
  let c = Cur::make(head, 0, head.length())
  c.skip_ws()
  parse_expression(c)
}

///|
/// A mixin call `+name(args)` — with an indented body it carries a caller,
/// without one it is a plain call in an output.
fn pug_element_or_call(
  ls : Lines,
  level : Int32,
  opts : ReadOpts,
) -> Node raise Fault {
  let line = ls.items[ls.at]
  let text = line.text
  if text.length() > 0 && text.at(0) == 0x2B {
    let call_src = view_sub(text, 1, text.length()).trim().to_owned()
    let c = Cur::make(call_src, 0, call_src.length())
    c.skip_ws()
    let name = c.read_word()
    c.skip_ws()
    let args = if c.peek() == 0x28 {
      c.at = c.at + 1
      parse_call_args(c)
    } else {
      []
    }
    let has_children = ls.at + 1 < ls.items.length() &&
      ls.items[ls.at + 1].level > level
    if has_children {
      let children = pug_children(ls, level, opts)
      CallBlock([], Call(Name(name), args), children)
    } else {
      ls.at = ls.at + 1
      Out(Call(Name(name), args))
    }
  } else {
    pug_element(ls, level, opts)
  }
}

///|
/// One element line: shorthand, attributes in any of the three brackets,
/// splats, a diff key, self-closing, inline output and text, and a `:` chain.
fn pug_element(ls : Lines, level : Int32, opts : ReadOpts) -> Node raise Fault {
  let line = ls.items[ls.at]
  let text = line.text
  let c = Cur::make(text.to_owned(), 0, text.length())
  let mut tag = ""
  if is_name_start(c.peek()) {
    tag = c.read_word()
    while c.peek() == 0x2D && is_name_start(c.peek_at(1)) {
      // A hyphenated tag name, or a `data-` style name.
      c.at = c.at + 1
      tag = tag + "-" + c.read_word()
    }
  }
  let mut id : String? = None
  let classes = []
  let attrs : Array[Attr] = []
  let splats = []
  let mut key : Expr? = None
  let mut shortcuts_left = true
  while shortcuts_left {
    shortcuts_left = false
    let unit = c.peek()
    if unit == 0x23 {
      c.at = c.at + 1
      id = Some(read_short_value(c))
      shortcuts_left = true
    } else if unit == 0x2E && is_name_start(c.peek_at(1)) {
      c.at = c.at + 1
      classes.push(read_short_value(c))
      shortcuts_left = true
    } else {
      match opts.shortcuts.get(short_char(unit)) {
        Some(_) => {
          c.at = c.at + 1
          let value = read_short_value(c)
          let attr_name = opts.shortcuts.get(short_char(unit)).unwrap_or("")
          attrs.push({ name: attr_name, value: Val(Lit(Text(value))), })
          shortcuts_left = true
        }
        None => ()
      }
    }
  }
  if tag.is_empty() {
    if id is None && classes.is_empty() && attrs.is_empty() {
      raise lexical(line.at, "a line needs a tag, text, or a construct")
    }
    tag = "div"
  }
  let mut self_close = false
  if c.peek() == 0x2F {
    self_close = true
    c.at = c.at + 1
  }
  let mut raw_text_block = false
  let mut going = true
  while going {
    going = false
    let unit = c.peek()
    if unit == 0x28 || unit == 0x5B || unit == 0x7B {
      read_attrs(c, attrs, splats, found => key = found)
      going = true
    } else if unit == 0x26 && c.peek_at(1) == 0x61 {
      // &attributes(…)
      c.at = c.at + 12
      c.skip_ws()
      splats.push(parse_expression(c))
      c.skip_ws()
      if c.peek() == 0x29 {
        c.at = c.at + 1
      }
      going = true
    }
  }
  c.skip_ws()
  // A trailing dot: the indented block below is raw text.
  if c.peek() == 0x2E && c.at + 1 >= c.end {
    raw_text_block = true
    c.at = c.at + 1
  }
  let mut out : Expr? = None
  let mut out_raw = false
  c.skip_ws()
  if c.peek() == 0x21 && c.peek_at(1) == 0x3D {
    c.at = c.at + 2
    c.skip_ws()
    out = Some(parse_expression(c))
    out_raw = true
  } else if c.peek() == 0x3D {
    c.at = c.at + 1
    c.skip_ws()
    out = Some(parse_expression(c))
  }
  // A `: child` chain nests the rest of the line; the chain mark also ends
  // whatever inline text came before it.
  let chain_at = find_chain(c.src, c.at, c.end)
  let inline_till = if chain_at >= 0 { chain_at } else { c.end }
  let inline_src = c.src[c.at:inline_till]
  let inline = if inline_src.trim().is_empty() {
    []
  } else {
    split_interpolation(inline_src.trim_start(chars=ws_chars))
  }
  let children = if raw_text_block {
    raw_children(ls, level)
  } else if ls.at + 1 < ls.items.length() && ls.items[ls.at + 1].level > level {
    pug_children(ls, level, opts)
  } else {
    ls.at = ls.at + 1
    []
  }
  let elem : Elem = {
    tag,
    id,
    classes,
    attrs,
    splats,
    key,
    self_close,
    inline,
    out,
    out_raw,
    children,
  }
  if chain_at >= 0 {
    let nested_src = c.src[chain_at + 1:c.end].trim_start(chars=ws_chars)
    let nested = one_element_line(nested_src, opts, line.at)
    elem.children.push(Element(nested))
  }
  Element(elem)
}

///|
/// Parse a single element line given as text, for `:` chains.
fn one_element_line(
  src : StringView,
  opts : ReadOpts,
  at : Int32,
) -> Elem raise Fault {
  let single : Lines = { items: [{ level: 0, text: src, at, }], at: 0, }
  match pug_element(single, 0, opts) {
    Element(elem) => elem
    _ => raise lexical(at, "a `:` chain holds one element")
  }
}

///|
/// Where a `:` block expansion starts, outside strings and attributes.
fn find_chain(src : String, from : Int32, end_ : Int32) -> Int32 {
  let mut i = from
  while i < end_ {
    if src.at(i) == 0x3A {
      return i
    }
    i = i + 1
  }
  -1
}

///|
fn read_short_value(c : Cur) -> String {
  let start = c.at
  while c.at < c.end {
    let unit = c.peek()
    if is_name_part(unit) || unit == 0x2D {
      c.at = c.at + 1
    } else {
      break
    }
  }
  c.src[start:c.at].to_owned()
}

///|
fn short_char(unit : UInt16) -> String {
  String::make(1, u16_char(unit))
}

///|
/// An attribute section between any of the three brackets: names with bare
/// expressions, strings with interpolation, booleans, and `:key`.
fn read_attrs(
  c : Cur,
  attrs : Array[Attr],
  splats : Array[Expr],
  key : (Expr?) -> Unit,
) -> Unit raise Fault {
  let open = c.peek()
  let close : Int32 = match open {
    0x28 => 0x29
    0x5B => 0x5D
    _ => 0x7D
  }
  c.at = c.at + 1
  c.skip_ws()
  let mut going = true
  while going {
    going = false
    if c.peek().to_int() == close {
      c.at = c.at + 1
      return
    }
    if c.peek() == 0x2B && c.peek_at(1) == 0x61 {
      // (+attributes(...)) — a splat inside the section.
      c.at = c.at + 12
      c.skip_ws()
      splats.push(parse_expression(c))
      c.skip_ws()
      if c.peek() == 0x29 {
        c.at = c.at + 1
      }
    } else {
      let name_start = c.at
      while c.at < c.end {
        let unit = c.peek()
        if is_name_part(unit) ||
          unit == 0x2D ||
          unit == 0x3A ||
          unit == 0x40 ||
          unit == 0x23 {
          c.at = c.at + 1
        } else {
          break
        }
      }
      let name = c.src[name_start:c.at]
      if name.is_empty() {
        raise lexical(c.at, "an attribute needs a name")
      }
      c.skip_ws()
      if c.peek() != 0x3D {
        attrs.push({ name: name.to_owned(), value: Bare, })
      } else {
        c.at = c.at + 1
        c.skip_ws()
        let value = read_attr_value(c, close)
        if name == "key" && c.src.at(name_start) == 0x3A {
          key(Some(value))
        } else if name == "class" {
          attrs.push({ name: "class", value: Val(value), })
        } else {
          attrs.push({ name: name.to_owned(), value: Val(value), })
        }
      }
    }
    c.skip_ws()
    if c.peek() == 0x2C {
      c.at = c.at + 1
      c.skip_ws()
      going = true
    } else if c.peek().to_int() == close {
      c.at = c.at + 1
      return
    } else if c.at >= c.end {
      raise lexical(c.at, "the attribute section is not closed")
    } else {
      going = true
    }
  }
}

///|
/// One attribute's value: a quoted string with interpolation folded into a
/// concatenation, or a bare expression.
fn read_attr_value(c : Cur, _close : Int32) -> Expr raise Fault {
  let unit = c.peek()
  if unit == 0x22 || unit == 0x27 {
    let quote = unit
    c.at = c.at + 1
    let pieces = []
    let mut run = c.at
    while c.at < c.end {
      let u = c.peek()
      if u == quote {
        break
      }
      if u == 0x5C && c.peek_at(1) == quote {
        c.at = c.at + 2
        continue
      }
      if u == 0x23 &&
        (c.peek_at(1) == 0x7B || c.peek_at(1) == 0x21) &&
        c.peek_at(2) == 0x7B {
        let raw = c.peek_at(1) == 0x21
        pieces.push(Node::Text(c.src[run:c.at].to_owned()))
        c.at = c.at + 3
        let inner_start = c.at
        while c.at < c.end && c.peek() != 0x7D {
          c.at = c.at + 1
        }
        let inner = c.src[inner_start:c.at]
        if c.peek() == 0x7D {
          c.at = c.at + 1
        }
        let ec = Cur::make(inner.to_owned(), 0, inner.length())
        ec.skip_ws()
        let expr = parse_expression(ec)
        pieces.push(if raw { Node::OutRaw(expr) } else { Node::Out(expr) })
        run = c.at
        continue
      }
      c.at = c.at + 1
    }
    pieces.push(Node::Text(c.src[run:c.at].to_owned()))
    if c.peek() == quote {
      c.at = c.at + 1
    }
    // Fold the pieces: plain text concatenates, outputs escape.
    return fold_attr_pieces(pieces)
  }
  // A bare expression: read it and stop at the comma or the closer.
  parse_expression(c)
}

///|
fn fold_attr_pieces(pieces : Array[Node]) -> Expr {
  // The renderer emits Out nodes escaped; an attribute value built here rides
  // as the concatenation of each piece's text.
  let parts : Array[Expr] = []
  for piece in pieces {
    match piece {
      Text(text) => parts.push(Lit(Text(text)))
      Out(expr) => parts.push(expr)
      OutRaw(expr) => parts.push(expr)
      _ => ()
    }
  }
  if parts.is_empty() {
    return Lit(Text(""))
  }
  let mut whole = parts[0]
  for i = 1; i < parts.length(); i = i + 1 {
    whole = Binary(Concat, whole, parts[i])
  }
  whole
}

///|
/// The raw-text block under a trailing dot: lines verbatim, one newline each,
/// at their own relative indent.
fn raw_children(ls : Lines, level : Int32) -> Array[Node] {
  ls.at = ls.at + 1
  let out = []
  if ls.at >= ls.items.length() || ls.items[ls.at].level <= level {
    return out
  }
  let child_level = ls.items[ls.at].level
  while ls.at < ls.items.length() && ls.items[ls.at].level >= child_level {
    let line = ls.items[ls.at]
    let step = if line.level > child_level {
      " ".repeat(line.level - child_level)
    } else {
      ""
    }
    out.push(Text("\{step}\{line.text}\n"))
    ls.at = ls.at + 1
  }
  out
}

///|
/// A `{% … %}` directive line. The head rides the line; the body is the
/// indented block, closed by a matching `{% end… %}` line at the same level.
fn pug_directive(
  ls : Lines,
  level : Int32,
  opts : ReadOpts,
) -> Node raise Fault {
  let line = ls.items[ls.at]
  let text = line.text
  let width = if text.has_suffix("%}") { 2 } else { 0 }
  let inner = view_sub(text, 2, text.length() - width).trim().to_owned()
  let word = first_word(inner[:])
  match word {
    "raw" => {
      ls.at = ls.at + 1
      let out = []
      while ls.at < ls.items.length() {
        let l = ls.items[ls.at]
        if l.level == level && l.text.trim() == "{% endraw %}" {
          ls.at = ls.at + 1
          break
        }
        out.push(
          Node::Text(l.text.to_owned() + String::make(1, (10).unsafe_to_char())),
        )
        ls.at = ls.at + 1
      }
      Group(out)
    }
    "endraw" => raise lexical(line.at, "`endraw` closes nothing here")
    "for" => {
      let head = rest_of(inner, word)
      let hc = Cur::make(head.to_owned(), 0, head.length())
      hc.skip_ws()
      let names = []
      names.push(hc.read_word())
      hc.skip_ws()
      while hc.peek() == 0x2C {
        hc.at = hc.at + 1
        hc.skip_ws()
        names.push(hc.read_word())
        hc.skip_ws()
      }
      if hc.peek_name() != "in" {
        raise lexical(line.at, "`for` wants `in` after its names")
      }
      ignore(hc.take_name())
      hc.skip_ws()
      let iter = parse_expression(hc)
      hc.skip_ws()
      let mut filter : Expr? = None
      let mut recursive = false
      let mut going = true
      while going {
        going = false
        if hc.peek_name() == "if" {
          ignore(hc.take_name())
          hc.skip_ws()
          filter = Some(parse_expression(hc))
          going = true
        } else if hc.peek_name() == "recursive" {
          ignore(hc.take_name())
          recursive = true
          going = true
        }
      }
      let children = pug_children(ls, level, opts)
      let mut otherwise = []
      if ls.at < ls.items.length() &&
        ls.items[ls.at].level == level &&
        ls.items[ls.at].text.trim() == "{% else %}" {
        ls.at = ls.at + 1
        otherwise = pug_children(ls, level, opts)
      }
      expect_end(ls, level, "endfor", line.at)
      For(
        names~,
        iter~,
        filter~,
        recursive~,
        swap=false,
        body=children,
        otherwise~,
      )
    }
    "if" => {
      let head = rest_of(inner, word).trim().to_owned()
      let branches = []
      let mut cond = parse_head_expression(head)
      let children = pug_children(ls, level, opts)
      branches.push((cond, children))
      let mut otherwise = []
      let mut going = true
      while going {
        going = false
        if ls.at < ls.items.length() && ls.items[ls.at].level == level {
          let next_text = ls.items[ls.at].text.trim()
          if next_text == "{% else %}" {
            ls.at = ls.at + 1
            otherwise = pug_children(ls, level, opts)
          } else if next_text.has_prefix("{% elif") {
            let elif_inner = directive_inner(ls.items[ls.at].text, "elif")
            cond = parse_head_expression(elif_inner)
            let children2 = pug_children(ls, level, opts)
            branches.push((cond, children2))
            going = true
          }
        }
      }
      expect_end(ls, level, "endif", line.at)
      If(branches, otherwise)
    }
    "set" => {
      let head = rest_of(inner, word).trim().to_owned()
      let sc = Cur::make(head, 0, head.length())
      sc.skip_ws()
      let first = sc.read_word()
      sc.skip_ws()
      if sc.peek() == 0x2E {
        let path = [first]
        while sc.peek() == 0x2E {
          sc.at = sc.at + 1
          path.push(sc.read_word())
          sc.skip_ws()
        }
        if sc.peek() != 0x3D {
          raise lexical(line.at, "a dotted `set` wants `=`")
        }
        sc.at = sc.at + 1
        sc.skip_ws()
        ls.at = ls.at + 1
        SetPath(path, parse_expression(sc))
      } else if sc.peek() == 0x3D {
        sc.at = sc.at + 1
        sc.skip_ws()
        ls.at = ls.at + 1
        SetVar([first], parse_expression(sc, with_tuple=true))
      } else {
        let children = pug_children(ls, level, opts)
        expect_end(ls, level, "endset", line.at)
        SetBlock(first, children)
      }
    }
    "block" => {
      if inner.has_prefix("block lang=") {
        return pug_lang_directive(ls, level, opts, inner, line.at)
      }
      let head = rest_of(inner, word).trim()
      let c2 = Cur::make(head.to_owned(), 0, head.length())
      let name = c2.read_word()
      let mut scoped = false
      let mut mod : BlockMod = Override
      c2.skip_ws()
      while c2.at < c2.end {
        match c2.read_word() {
          "scoped" => scoped = true
          "append" => mod = Append
          "prepend" => mod = Prepend
          _ => ()
        }
        c2.skip_ws()
      }
      let children = pug_children(ls, level, opts)
      expect_end(ls, level, "endblock", line.at)
      Block(name, { body: children, scoped, required: false, mod, })
    }
    "macro" => {
      let head = rest_of(inner, word).trim()
      let name = first_word(head).to_owned()
      let params_src = view_sub(head, name.length(), head.length()).to_owned()
      let pc = Cur::make(params_src, 0, params_src.length())
      pc.skip_ws()
      let (params, defaults, rest) = parse_params(pc)
      let children = pug_children(ls, level, opts)
      expect_end(ls, level, "endmacro", line.at)
      MacroDef(name, {
        name,
        params,
        defaults,
        rest,
        body: children,
        home: Map([]),
      })
    }
    "call" => {
      let head = rest_of(inner, word).trim().to_owned()
      let cc = Cur::make(head, 0, head.length())
      cc.skip_ws()
      let params = if cc.peek() == 0x28 {
        cc.at = cc.at + 1
        let (p, _, _) = parse_params(cc)
        p
      } else {
        []
      }
      cc.skip_ws()
      let call = parse_expression(cc)
      let children = pug_children(ls, level, opts)
      expect_end(ls, level, "endcall", line.at)
      CallBlock(params, call, children)
    }
    "filter" => {
      let head = rest_of(inner, word).trim().to_owned()
      let fc = Cur::make(head, 0, head.length())
      fc.skip_ws()
      let chain = []
      let mut going = true
      while going {
        going = false
        let fname = fc.read_word()
        fc.skip_ws()
        let args = if fc.peek() == 0x28 {
          fc.at = fc.at + 1
          parse_call_args(fc)
        } else {
          []
        }
        chain.push((fname, args))
        fc.skip_ws()
        if fc.peek() == 0x7C {
          fc.at = fc.at + 1
          fc.skip_ws()
          going = true
        }
      }
      let children = pug_children(ls, level, opts)
      expect_end(ls, level, "endfilter", line.at)
      FilterBlock(chain, children)
    }
    "with" => {
      let head = rest_of(inner, word).trim().to_owned()
      let bindings = parse_bindings(head, line.at)
      let children = pug_children(ls, level, opts)
      expect_end(ls, level, "endwith", line.at)
      With(bindings, children)
    }
    "autoescape" => {
      let head = rest_of(inner, word).trim().to_owned()
      let setting = match head {
        "on" => Lit(Bool(true))
        "off" => Lit(Bool(false))
        _ => parse_head_expression(head)
      }
      let children = pug_children(ls, level, opts)
      expect_end(ls, level, "endautoescape", line.at)
      Autoescape(setting, children)
    }
    "show" => {
      let head = rest_of(inner, word).trim().to_owned()
      let cond = parse_head_expression(head)
      let children = pug_children(ls, level, opts)
      expect_end(ls, level, "endshow", line.at)
      Show(cond, children)
    }
    "once" => {
      let head = rest_of(inner, word).trim().to_owned()
      let key = if head.is_empty() { None } else { Some(head) }
      let children = pug_children(ls, level, opts)
      expect_end(ls, level, "endonce", line.at)
      Once(key, children)
    }
    "extends" => {
      ls.at = ls.at + 1
      Extends(parse_head_expression(rest_of(inner, word).trim().to_owned()))
    }
    "include" => {
      ls.at = ls.at + 1
      Include(
        parse_head_expression(rest_of(inner, word).trim().to_owned()),
        false,
        true,
      )
    }
    "import" => {
      ls.at = ls.at + 1
      let head = rest_of(inner, word).trim().to_owned()
      let ic = Cur::make(head, 0, head.length())
      ic.skip_ws()
      let target = parse_expression(ic)
      ic.skip_ws()
      if ic.peek_name() != "as" {
        raise lexical(line.at, "`import` wants `as` and a name")
      }
      ignore(ic.take_name())
      ic.skip_ws()
      let as_name = ic.read_word()
      Import(target, as_name, false)
    }
    "from" => {
      ls.at = ls.at + 1
      let head = rest_of(inner, word).trim().to_owned()
      let fc2 = Cur::make(head, 0, head.length())
      fc2.skip_ws()
      let target = parse_expression(fc2)
      fc2.skip_ws()
      if fc2.peek_name() != "import" {
        raise lexical(line.at, "`from` wants `import`")
      }
      ignore(fc2.take_name())
      fc2.skip_ws()
      let wanted = []
      let mut going = true
      while going {
        going = false
        let name = fc2.read_word()
        fc2.skip_ws()
        let as_name = if fc2.peek_name() == "as" {
          ignore(fc2.take_name())
          fc2.skip_ws()
          Some(fc2.read_word())
        } else {
          None
        }
        wanted.push((name, as_name))
        fc2.skip_ws()
        if fc2.peek() == 0x2C {
          fc2.at = fc2.at + 1
          fc2.skip_ws()
          going = true
        }
      }
      FromImport(target, wanted, false)
    }
    "do" => {
      ls.at = ls.at + 1
      let head = rest_of(inner, word).trim().to_owned()
      let dc = Cur::make(head, 0, head.length())
      dc.skip_ws()
      let exprs = []
      exprs.push(parse_expression(dc))
      dc.skip_ws()
      while dc.peek() == 0x2C {
        dc.at = dc.at + 1
        dc.skip_ws()
        exprs.push(parse_expression(dc))
        dc.skip_ws()
      }
      Do(exprs)
    }
    "debug" => {
      ls.at = ls.at + 1
      Debug
    }
    "break" => {
      ls.at = ls.at + 1
      Break
    }
    "continue" => {
      ls.at = ls.at + 1
      Continue
    }
    "trans" => pug_trans(ls, level, inner, line.at)
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
    | "endtrans"
    | "endcomment"
    | "elif"
    | "else"
    | "pluralize"
    | "comment" => raise lexical(line.at, "`\{word}` closes nothing here")
    other => raise lexical(line.at, "no such statement: `\{other}`")
  }
}

///|
fn expect_end(
  ls : Lines,
  level : Int32,
  word : String,
  at : Int32,
) -> Unit raise Fault {
  if ls.at >= ls.items.length() || ls.items[ls.at].level != level {
    raise lexical(at, "`\{word}` never closes")
  }
  let text = ls.items[ls.at].text.trim()
  if text != "{% \{word} %}" && text != "{%\{word}%}" {
    raise lexical(at, "`\{word}` never closes")
  }
  ls.at = ls.at + 1
}

///|
fn directive_inner(text : StringView, word : StringView) -> String {
  let trimmed = text.trim().to_owned()
  let open = trimmed[2:trimmed.length() - 2]
  let inner = open.trim().to_owned()
  rest_of(inner, word).trim().to_owned()
}

///|
fn parse_bindings(
  head : String,
  at : Int32,
) -> Array[(String, Expr)] raise Fault {
  let c = Cur::make(head, 0, head.length())
  c.skip_ws()
  let bindings = []
  while c.at < c.end {
    let name = c.read_word()
    c.skip_ws()
    if c.peek() != 0x3D {
      raise lexical(at, "bindings join with `=`")
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
  bindings
}

///|
/// `{% block lang=pug %}` in the indentation surface: the body lines are
/// taken verbatim and re-read in that language.
fn pug_lang_directive(
  ls : Lines,
  level : Int32,
  opts : ReadOpts,
  inner : String,
  at : Int32,
) -> Node raise Fault {
  let eq = inner.find("=").unwrap_or(9)
  let lang = inner[eq + 1:inner.length()].trim().to_owned()
  ls.at = ls.at + 1
  let body = StringBuilder()
  let mut depth = 1
  while ls.at < ls.items.length() {
    let line = ls.items[ls.at]
    let trimmed = line.text.trim()
    if line.level == level {
      if trimmed.has_prefix("{% block") {
        depth = depth + 1
      } else if trimmed == "{% endblock %}" {
        depth = depth - 1
        if depth == 0 {
          ls.at = ls.at + 1
          break
        }
      }
    }
    body.write_string(line.text.to_owned())
    body.write_char('\n')
    ls.at = ls.at + 1
  }
  if depth != 0 {
    raise lexical(at, "`block lang=\{lang}` is never closed")
  }
  if lang_allowed(opts.syntax, opts.force, lang.to_string()) {
    LangBlock(lang.to_string(), body.to_string())
  } else {
    Text("{% block lang=\{lang} %}\{body}{% endblock %}")
  }
}

///|
/// `{% trans %}` in the indentation surface: child lines are the text.
fn pug_trans(
  ls : Lines,
  level : Int32,
  inner : String,
  at : Int32,
) -> Node raise Fault {
  let head = rest_of(inner, "trans").trim().to_owned()
  let bindings = parse_bindings(head, at)
  let mut count_name : String? = None
  for pair in bindings {
    if pair.0 == "count" {
      count_name = Some("count")
    }
  }
  ls.at = ls.at + 1
  let singular = StringBuilder()
  let plural = StringBuilder()
  let mut in_plural = false
  while ls.at < ls.items.length() {
    let line = ls.items[ls.at]
    if line.level == level {
      let trimmed = line.text.trim()
      if trimmed == "{% endtrans %}" {
        ls.at = ls.at + 1
        return Trans({
          singular: singular.to_string(),
          plural: if in_plural {
            Some(plural.to_string())
          } else {
            None
          },
          bindings,
          count_name,
        })
      }
      if trimmed.has_prefix("{% pluralize") {
        in_plural = true
        ls.at = ls.at + 1
        continue
      }
    }
    if in_plural {
      plural.write_string(line.text.to_owned())
      plural.write_char('\n')
    } else {
      singular.write_string(line.text.to_owned())
      singular.write_char('\n')
    }
    ls.at = ls.at + 1
  }
  raise lexical(at, "`trans` is never closed")
}

///|

///|
fn first_word(text : StringView) -> StringView {
  let mut i = 0
  while i < text.length() && is_name_part(text.at(i)) {
    i = i + 1
  }
  view_sub(text, 0, i)
}

///|
fn rest_of(text : StringView, word : StringView) -> StringView {
  view_sub(text, word.length(), text.length())
}

///|
fn path_literal(text : StringView) -> String {
  let trimmed = text.trim()
  match trimmed.strip_prefix("\"") {
    Some(a) =>
      match a.strip_suffix("\"") {
        Some(b) => b.to_owned()
        None => trimmed.to_owned()
      }
    None =>
      match trimmed.strip_prefix("'") {
        Some(a) =>
          match a.strip_suffix("'") {
            Some(b) => b.to_owned()
            None => trimmed.to_owned()
          }
        None => trimmed.to_owned()
      }
  }
}

///|
/// `#{expr}`, `!{expr}` and `{{ expr }}` inside text, as output nodes.
fn split_interpolation(text : StringView) -> Array[Node] {
  let pieces = []
  let n = text.length()
  let mut i = 0
  let mut run = 0
  while i < n {
    let unit = text.at(i)
    if unit == 0x23 && i + 1 < n && text.at(i + 1) == 0x7B {
      let close = find_closing_brace(text, i + 1)
      match close {
        Some(end) => {
          push_run(pieces, text, run, i)
          let inner = view_sub(text, i + 2, end)
          match parse_quiet_expression(inner) {
            Some(expr) => pieces.push(Out(expr))
            None => pieces.push(Text("#{\{inner}}"))
          }
          i = end + 1
          run = i
          continue
        }
        None => ()
      }
    }
    if unit == 0x21 && i + 1 < n && text.at(i + 1) == 0x7B {
      let close = find_closing_brace(text, i + 1)
      match close {
        Some(end) => {
          push_run(pieces, text, run, i)
          let inner = view_sub(text, i + 2, end)
          match parse_quiet_expression(inner) {
            Some(expr) => pieces.push(OutRaw(expr))
            None => pieces.push(Text("!{\{inner}}"))
          }
          i = end + 1
          run = i
          continue
        }
        None => ()
      }
    }
    if unit == 0x7B && i + 1 < n && text.at(i + 1) == 0x7B {
      let close = find_close(text, i + 1, "}}")
      match close {
        Some(end) => {
          push_run(pieces, text, run, i)
          let inner = view_sub(text, i + 2, end)
          match parse_quiet_expression(inner) {
            Some(expr) => pieces.push(Out(expr))
            None => pieces.push(Text("{{\{inner}}}"))
          }
          i = end + 2
          run = i
          continue
        }
        None => ()
      }
    }
    i = i + 1
  }
  push_run(pieces, text, run, n)
  pieces
}

///|
fn push_run(
  pieces : Array[Node],
  text : StringView,
  from : Int32,
  till : Int32,
) -> Unit {
  if till > from {
    pieces.push(Text(view_sub(text, from, till).to_owned()))
  }
}

///|
fn parse_quiet_expression(inner : StringView) -> Expr? {
  let c = Cur::make(inner.to_owned(), 0, inner.length())
  c.skip_ws()
  try {
    let expr = parse_expression(c)
    c.skip_ws()
    if c.at == c.end {
      Some(expr)
    } else {
      None
    }
  } catch {
    _ => None
  }
}

///|
fn find_closing_brace(text : StringView, open_at : Int32) -> Int32? {
  let mut i = open_at + 1
  while i < text.length() {
    if text.at(i) == 0x7D {
      return Some(i)
    }
    i = i + 1
  }
  None
}

///|
fn find_close(text : StringView, from : Int32, closer : String) -> Int32? {
  let n = text.length()
  let mut i = from
  while i < n {
    if text.at(i) == closer.at(0) && i + 1 < n && text.at(i + 1) == closer.at(1) {
      return Some(i)
    }
    i = i + 1
  }
  None
}
