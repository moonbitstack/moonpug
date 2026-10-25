///|
/// A token stream and the way its syntax reads a statement's body. The
/// brace syntax reads on through the same stream; the indentation syntax
/// reads the indented lines and swaps in the tokens of the closing line.
pub(all) struct Parser {
  template : String
  mut tokens : Array[Token]
  mut at : Int32
  /// Read nodes until one of the end tags; on return the current token is
  /// the end tag's name.
  body : (Parser, Array[String]) -> Array[Node] raise @spec.Refused
}

///|
pub fn Parser::current(self : Parser) -> Token {
  self.tokens[self.at]
}

///|
fn Parser::look(self : Parser) -> Token {
  if self.at + 1 < self.tokens.length() {
    self.tokens[self.at + 1]
  } else {
    self.tokens[self.tokens.length() - 1]
  }
}

///|
pub fn Parser::next(self : Parser) -> Token {
  let token = self.tokens[self.at]
  if self.at + 1 < self.tokens.length() {
    self.at += 1
  }
  token
}

///|
pub fn Parser::fail(self : Parser, reason : String) -> @spec.Refused {
  let token = self.current()
  Syntax(template=self.template, line=token.line, column=token.column, reason~)
}

///|
fn Parser::is_op(self : Parser, op : String) -> Bool {
  self.current().tok is Op(o) && o == op
}

///|
fn Parser::is_name(self : Parser, name : String) -> Bool {
  self.current().tok is Name(n) && n == name
}

///|
fn Parser::skip_op(self : Parser, op : String) -> Bool {
  if self.is_op(op) {
    ignore(self.next())
    true
  } else {
    false
  }
}

///|
fn Parser::skip_name(self : Parser, name : String) -> Bool {
  if self.is_name(name) {
    ignore(self.next())
    true
  } else {
    false
  }
}

///|
fn Parser::expect_op(self : Parser, op : String) -> Unit raise @spec.Refused {
  if !self.skip_op(op) {
    raise self.fail("expected \{op}, found \{describe(self.current().tok)}")
  }
}

///|
fn Parser::expect_name(
  self : Parser,
  name? : String,
) -> String raise @spec.Refused {
  match (self.current().tok, name) {
    (Name(n), None) => {
      ignore(self.next())
      n
    }
    (Name(n), Some(want)) if n == want => {
      ignore(self.next())
      n
    }
    (tok, Some(want)) =>
      raise self.fail("expected \{want}, found \{describe(tok)}")
    (tok, None) => raise self.fail("expected a name, found \{describe(tok)}")
  }
}

///|
pub fn Parser::expect(self : Parser, tok : Tok) -> Unit raise @spec.Refused {
  if self.current().tok != tok {
    raise self.fail(
      "expected \{describe(tok)}, found \{describe(self.current().tok)}",
    )
  }
  ignore(self.next())
}

///|
fn describe(tok : Tok) -> String {
  match tok {
    Data(_) => "template text"
    VarBegin => "{{"
    VarEnd => "}}"
    BlockBegin => "{%"
    BlockEnd => "the end of the tag"
    Name(n) => n
    Str(s) => @spec.repr_text(s)
    Int(n) => n.to_string()
    Float(d) => @spec.python_float(d)
    Op(o) => o
    Lang(name, _, _) => "a \{name} block"
    Eof => "the end of the template"
  }
}

///|
/// The end of a tuple: the end of a tag, a closing parenthesis, or one of
/// the words a statement reserves after it (`in` after a loop's names).
fn Parser::tuple_end(self : Parser, extra : Array[String]) -> Bool {
  match self.current().tok {
    VarEnd | BlockEnd | Eof | Op(")") => true
    Name(n) => extra.contains(n)
    _ => false
  }
}

///|
/// An expression, or several separated by commas as a tuple.
pub fn Parser::parse_tuple(
  self : Parser,
  simplified~ : Bool = false,
  condexpr~ : Bool = true,
  extra~ : Array[String] = [],
  parenthesised~ : Bool = false,
) -> Expr raise @spec.Refused {
  let items = []
  let mut tuple = false
  for ;; {
    if !items.is_empty() {
      self.expect_op(",")
    }
    if self.tuple_end(extra) {
      break
    }
    items.push(
      if simplified {
        self.parse_primary()
      } else if condexpr {
        self.parse_expression()
      } else {
        self.parse_or()
      },
    )
    if self.is_op(",") {
      tuple = true
    } else {
      break
    }
  }
  if !tuple {
    if items.length() == 1 {
      return items[0]
    }
    if !parenthesised {
      raise self.fail(
        "expected an expression, found \{describe(self.current().tok)}",
      )
    }
  }
  Tuple(items)
}

///|
pub fn Parser::parse_expression(self : Parser) -> Expr raise @spec.Refused {
  let mut expr = self.parse_or()
  while self.skip_name("if") {
    let cond = self.parse_or()
    let otherwise = if self.skip_name("else") {
      Some(self.parse_expression())
    } else {
      None
    }
    expr = Cond(cond, expr, otherwise)
  }
  expr
}

///|
fn Parser::parse_or(self : Parser) -> Expr raise @spec.Refused {
  let mut left = self.parse_and()
  while self.skip_name("or") {
    left = Binary(Or, left, self.parse_and())
  }
  left
}

///|
fn Parser::parse_and(self : Parser) -> Expr raise @spec.Refused {
  let mut left = self.parse_not()
  while self.skip_name("and") {
    left = Binary(And, left, self.parse_not())
  }
  left
}

///|
fn Parser::parse_not(self : Parser) -> Expr raise @spec.Refused {
  if self.skip_name("not") {
    return Not(self.parse_not())
  }
  self.parse_compare()
}

///|
fn Parser::parse_compare(self : Parser) -> Expr raise @spec.Refused {
  let first = self.parse_math1()
  let ops = []
  for ;; {
    let op : Op? = match self.current().tok {
      Op("==") => Some(Eq)
      Op("!=") => Some(Ne)
      Op("<") => Some(Lt)
      Op(">") => Some(Gt)
      Op("<=") => Some(Le)
      Op(">=") => Some(Ge)
      Name("in") => Some(In)
      Name("not") if self.look().tok is Name("in") => {
        ignore(self.next())
        Some(NotIn)
      }
      _ => None
    }
    match op {
      Some(op) => {
        ignore(self.next())
        ops.push((op, self.parse_math1()))
      }
      None => break
    }
  }
  if ops.is_empty() {
    first
  } else {
    Compare(first, ops)
  }
}

///|
fn Parser::parse_math1(self : Parser) -> Expr raise @spec.Refused {
  let mut left = self.parse_concat()
  for ;; {
    let op : Op = match self.current().tok {
      Op("+") => Add
      Op("-") => Sub
      _ => break
    }
    ignore(self.next())
    left = Binary(op, left, self.parse_concat())
  }
  left
}

///|
fn Parser::parse_concat(self : Parser) -> Expr raise @spec.Refused {
  let parts = [self.parse_math2()]
  while self.skip_op("~") {
    parts.push(self.parse_math2())
  }
  if parts.length() == 1 {
    parts[0]
  } else {
    Concat(parts)
  }
}

///|
fn Parser::parse_math2(self : Parser) -> Expr raise @spec.Refused {
  let mut left = self.parse_pow()
  for ;; {
    let op : Op = match self.current().tok {
      Op("*") => Mul
      Op("/") => Div
      Op("//") => FloorDiv
      Op("%") => Mod
      _ => break
    }
    ignore(self.next())
    left = Binary(op, left, self.parse_pow())
  }
  left
}

///|
fn Parser::parse_pow(self : Parser) -> Expr raise @spec.Refused {
  let mut left = self.parse_unary()
  while self.skip_op("**") {
    left = Binary(Pow, left, self.parse_unary())
  }
  left
}

///|
fn Parser::parse_unary(
  self : Parser,
  filters~ : Bool = true,
) -> Expr raise @spec.Refused {
  let node = if self.skip_op("-") {
    Neg(self.parse_unary(filters=false))
  } else if self.skip_op("+") {
    Pos(self.parse_unary(filters=false))
  } else {
    self.parse_primary()
  }
  let node = self.parse_postfix(node)
  if filters {
    self.parse_filter_expr(node)
  } else {
    node
  }
}

///|
fn Parser::parse_primary(self : Parser) -> Expr raise @spec.Refused {
  let token = self.current()
  match token.tok {
    Name(n) => {
      ignore(self.next())
      match n {
        "true" | "True" => Lit(Bool(true))
        "false" | "False" => Lit(Bool(false))
        "none" | "None" => Lit(Null)
        _ => Name(n)
      }
    }
    Str(s) => {
      ignore(self.next())
      let buf = StringBuilder()
      buf.write_string(s)
      while self.current().tok is Str(more) {
        buf.write_string(more)
        ignore(self.next())
      }
      Lit(Text(buf.to_string()))
    }
    Int(n) => {
      ignore(self.next())
      Lit(Int(n))
    }
    Float(d) => {
      ignore(self.next())
      Lit(Double(d))
    }
    Op("(") => {
      ignore(self.next())
      let inner = self.parse_tuple(parenthesised=true)
      self.expect_op(")")
      inner
    }
    Op("[") => {
      ignore(self.next())
      let items = []
      while !self.is_op("]") {
        if !items.is_empty() {
          self.expect_op(",")
        }
        if self.is_op("]") {
          break
        }
        items.push(self.parse_expression())
      }
      self.expect_op("]")
      List(items)
    }
    Op("{") => {
      ignore(self.next())
      let pairs = []
      while !self.is_op("}") {
        if !pairs.is_empty() {
          self.expect_op(",")
        }
        if self.is_op("}") {
          break
        }
        let key = self.parse_expression()
        self.expect_op(":")
        pairs.push((key, self.parse_expression()))
      }
      self.expect_op("}")
      Dict(pairs)
    }
    tok => raise self.fail("unexpected \{describe(tok)}")
  }
}

///|
fn Parser::parse_postfix(
  self : Parser,
  node : Expr,
) -> Expr raise @spec.Refused {
  let mut node = node
  for ;; {
    match self.current().tok {
      Op("." | "[") => node = self.parse_subscript(node)
      Op("(") => node = Call(node, self.parse_call_args())
      _ => break
    }
  }
  node
}

///|
fn Parser::parse_filter_expr(
  self : Parser,
  node : Expr,
) -> Expr raise @spec.Refused {
  let mut node = node
  for ;; {
    match self.current().tok {
      Op("|") => node = self.parse_filter(Some(node))
      Name("is") => node = self.parse_test(node)
      Op("(") => node = Call(node, self.parse_call_args())
      _ => break
    }
  }
  node
}

///|
fn Parser::parse_subscript(
  self : Parser,
  node : Expr,
) -> Expr raise @spec.Refused {
  if self.skip_op(".") {
    let token = self.next()
    return match token.tok {
      Name(n) => Attr(node, n)
      Int(n) => Item(node, Lit(Int(n)))
      _ => raise self.fail("expected a name or a number after the dot")
    }
  }
  self.expect_op("[")
  let args = []
  while !self.is_op("]") {
    if !args.is_empty() {
      self.expect_op(",")
    }
    args.push(self.parse_subscribed())
  }
  self.expect_op("]")
  Item(node, if args.length() == 1 { args[0] } else { Tuple(args) })
}

///|
fn Parser::parse_subscribed(self : Parser) -> Expr raise @spec.Refused {
  let start = if self.skip_op(":") {
    None
  } else {
    let node = self.parse_expression()
    if !self.skip_op(":") {
      return node
    }
    Some(node)
  }
  let stop = if self.is_op(":") || self.is_op("]") || self.is_op(",") {
    None
  } else {
    Some(self.parse_expression())
  }
  let step = if self.skip_op(":") {
    if self.is_op("]") || self.is_op(",") {
      None
    } else {
      Some(self.parse_expression())
    }
  } else {
    None
  }
  Slice(start, stop, step)
}

///|
fn Parser::parse_call_args(self : Parser) -> Array[Arg] raise @spec.Refused {
  self.expect_op("(")
  let args = []
  let mut named = false
  let mut spread = false
  let mut spread_named = false
  while !self.is_op(")") {
    if !args.is_empty() {
      self.expect_op(",")
      if self.is_op(")") {
        break
      }
    }
    if self.skip_op("*") {
      if spread || spread_named {
        raise self.fail("invalid syntax for a call")
      }
      spread = true
      args.push(Spread(self.parse_expression()))
    } else if self.skip_op("**") {
      if spread_named {
        raise self.fail("invalid syntax for a call")
      }
      spread_named = true
      args.push(SpreadNamed(self.parse_expression()))
    } else if self.current().tok is Name(key) && self.look().tok is Op("=") {
      if spread_named {
        raise self.fail("invalid syntax for a call")
      }
      ignore(self.next())
      ignore(self.next())
      named = true
      args.push(Named(key, self.parse_expression()))
    } else {
      if spread || spread_named || named {
        raise self.fail("a positional argument follows a named one")
      }
      args.push(Pos(self.parse_expression()))
    }
  }
  self.expect_op(")")
  args
}

///|
/// `|name(args)`, chained; `input` is `None` for a filter block's head.
pub fn Parser::parse_filter(
  self : Parser,
  input : Expr?,
) -> Expr raise @spec.Refused {
  let mut node = input
  let mut first = input is None
  while self.is_op("|") || first {
    if !first {
      ignore(self.next())
    }
    first = false
    if self.is_op(":") {
      raise self.fail("filter arguments take parentheses, as in |truncate(3)")
    }
    let mut name = self.expect_name()
    while self.skip_op(".") {
      name = name + "." + self.expect_name()
    }
    if self.is_op(":") {
      raise self.fail("filter arguments take parentheses, as in |\{name}(…)")
    }
    let args = if self.is_op("(") { self.parse_call_args() } else { [] }
    node = Some(Filter(node, name, args))
  }
  node.unwrap()
}

///|
fn Parser::parse_test(self : Parser, node : Expr) -> Expr raise @spec.Refused {
  ignore(self.next())
  let negated = self.skip_name("not")
  let mut name = self.expect_name()
  while self.skip_op(".") {
    name = name + "." + self.expect_name()
  }
  let args = match self.current().tok {
    Op("(") => self.parse_call_args()
    Name("else" | "or" | "and") => []
    Name("is") => raise self.fail("tests cannot be chained with is")
    Name(_) | Str(_) | Int(_) | Float(_) | Op("[" | "{") => {
      let arg = self.parse_postfix(self.parse_primary())
      [Pos(arg)]
    }
    _ => []
  }
  let check = Test(node, name, args)
  if negated {
    Not(check)
  } else {
    check
  }
}

///|
/// Where a statement binds: a name, a tuple of targets, or `ns.attr`.
fn Parser::parse_target(
  self : Parser,
  extra~ : Array[String] = [],
  field~ : Bool = false,
) -> Target raise @spec.Refused {
  let items = []
  let mut tuple = false
  for ;; {
    if !items.is_empty() {
      self.expect_op(",")
    }
    if self.tuple_end(extra) {
      break
    }
    items.push(self.parse_target_atom(field~))
    if self.is_op(",") {
      tuple = true
    } else {
      break
    }
  }
  if !tuple && items.length() == 1 {
    return items[0]
  }
  if items.is_empty() {
    raise self.fail("expected a name to assign to")
  }
  Tuple(items)
}

///|
fn Parser::parse_target_atom(
  self : Parser,
  field~ : Bool,
) -> Target raise @spec.Refused {
  if self.skip_op("(") {
    let inner = self.parse_target(field~)
    self.expect_op(")")
    return inner
  }
  let name = self.expect_name()
  if name is ("true" | "false" | "none" | "True" | "False" | "None") {
    raise self.fail("cannot assign to \{name}")
  }
  if field && self.skip_op(".") {
    return Field(name, self.expect_name())
  }
  Name(name)
}

///|
/// The statements both syntaxes share. The current token is the name after
/// `{%`; on return it is the end of the tag.
pub fn Parser::parse_statement(
  self : Parser,
) -> Array[Node] raise @spec.Refused {
  let token = self.current()
  let word = match token.tok {
    Name(n) => n
    _ => raise self.fail("a statement starts with its name")
  }
  ignore(self.next())
  let node : Node = match word {
    "for" => self.parse_for()
    "if" => self.parse_if()
    "set" => self.parse_set()
    "block" => self.parse_block()
    "extends" => Extends(self.parse_expression())
    "include" => {
      let target = self.parse_expression()
      let missing = if self.is_name("ignore") &&
        self.look().tok is Name("missing") {
        ignore(self.next())
        ignore(self.next())
        true
      } else {
        false
      }
      Include(
        target,
        missing~,
        context=self.parse_context(true),
        raw=false,
        inline=false,
        block=[],
      )
    }
    "import" => {
      let target = self.parse_expression()
      ignore(self.expect_name(name="as"))
      let name = self.expect_name()
      Import(target, name, context=self.parse_context(false))
    }
    "from" => self.parse_from()
    "macro" => {
      let name = self.expect_name()
      let params = self.parse_signature()
      MacroDef({
        name,
        params,
        body: self.statements(["endmacro"], drop=true),
        pug: false,
      })
    }
    "call" => {
      let params = if self.is_op("(") { self.parse_signature() } else { [] }
      let call = self.parse_expression()
      if !(call is Call(_, _)) {
        raise self.fail("a call block ends in a call")
      }
      CallBlock(params, call, self.statements(["endcall"], drop=true))
    }
    "filter" => {
      let chain = self.parse_filter(None)
      FilterBlock(chain, self.statements(["endfilter"], drop=true))
    }
    "with" => {
      let pairs = []
      while self.current().tok != BlockEnd {
        if !pairs.is_empty() {
          self.expect_op(",")
        }
        let target = self.parse_target()
        self.expect_op("=")
        pairs.push((target, self.parse_expression()))
      }
      With(pairs, self.statements(["endwith"], drop=true))
    }
    "autoescape" => {
      let setting = self.parse_expression()
      Autoescape(setting, self.statements(["endautoescape"], drop=true))
    }
    "print" => {
      let items = []
      while self.current().tok != BlockEnd {
        if !items.is_empty() {
          self.expect_op(",")
        }
        items.push(self.parse_expression())
      }
      return [Line(token.line), ..items.map(item => Node::Out(item))]
    }
    "do" => Do(self.parse_tuple())
    "debug" => Debug
    "break" => Break
    "continue" => Continue
    "show" => {
      let cond = self.parse_expression()
      Show(cond, self.statements(["endshow"], drop=true))
    }
    "once" => {
      let key = if self.current().tok == BlockEnd {
        None
      } else {
        Some(self.parse_expression())
      }
      Once(key, self.statements(["endonce"], drop=true))
    }
    "trans" => self.parse_trans()
    _ =>
      raise Syntax(
        template=self.template,
        line=token.line,
        column=token.column,
        reason="unknown statement \{word}",
      )
  }
  [Line(token.line), node]
}

///|
/// `with context` or `without context`, else the default.
fn Parser::parse_context(self : Parser, default : Bool) -> Bool {
  if (self.is_name("with") || self.is_name("without")) &&
    self.look().tok is Name("context") {
    let with_ = self.next().tok is Name("with")
    ignore(self.next())
    with_
  } else {
    default
  }
}

///|
/// The body of a statement: the end of the head, then nodes up to one of
/// `ends`. With `drop`, the end tag's name is consumed.
pub fn Parser::statements(
  self : Parser,
  ends : Array[String],
  drop~ : Bool = false,
) -> Array[Node] raise @spec.Refused {
  ignore(self.skip_op(":"))
  self.expect(BlockEnd)
  let body = (self.body)(self, ends)
  if drop {
    ignore(self.next())
  }
  body
}

///|
fn Parser::parse_for(self : Parser) -> Node raise @spec.Refused {
  let target = self.parse_target(extra=["in"])
  ignore(self.expect_name(name="in"))
  let iter = self.parse_tuple(condexpr=false, extra=["recursive"])
  let cond = if self.skip_name("if") {
    Some(self.parse_expression())
  } else {
    None
  }
  let recursive = self.skip_name("recursive")
  let body = self.statements(["endfor", "else"])
  let otherwise = if self.next().tok is Name("endfor") {
    []
  } else {
    self.statements(["endfor"], drop=true)
  }
  For(target~, iter~, cond~, recursive~, each=false, body~, otherwise~)
}

///|
fn Parser::parse_if(self : Parser) -> Node raise @spec.Refused {
  let branches = []
  let mut otherwise = []
  for ;; {
    let cond = self.parse_tuple(condexpr=false)
    branches.push((cond, self.statements(["elif", "else", "endif"])))
    match self.next().tok {
      Name("elif") => continue
      Name("else") => {
        otherwise = self.statements(["endif"], drop=true)
        break
      }
      _ => break
    }
  }
  If(branches, otherwise)
}

///|
fn Parser::parse_set(self : Parser) -> Node raise @spec.Refused {
  let target = self.parse_target(field=true)
  if self.skip_op("=") {
    return Set(target, self.parse_tuple())
  }
  let filter = if self.skip_op("|") {
    Some(self.parse_filter(None))
  } else {
    None
  }
  SetBlock(target, filter, self.statements(["endset"], drop=true))
}

///|
fn Parser::parse_block(self : Parser) -> Node raise @spec.Refused {
  let name = self.expect_name()
  let scoped = self.skip_name("scoped")
  let required = self.skip_name("required")
  let placement = if self.skip_name("append") {
    Append
  } else if self.skip_name("prepend") {
    Prepend
  } else {
    Replace
  }
  if self.is_op("-") {
    raise self.fail(
      "block names have to be valid identifiers and may not contain hyphens",
    )
  }
  let body = self.statements(["endblock"], drop=true)
  if required && !body.iter().all(only_space) {
    raise self.fail("required blocks can only contain comments or whitespace")
  }
  ignore(self.skip_name(name))
  BlockDef({ name, body, scoped, required, placement, })
}

///|
fn only_space(node : Node) -> Bool {
  match node {
    Line(_) => true
    Text(t) => t.iter().all(ch => ch is (' ' | '\t' | '\n' | '\r'))
    _ => false
  }
}

///|
fn Parser::parse_from(self : Parser) -> Node raise @spec.Refused {
  let target = self.parse_expression()
  ignore(self.expect_name(name="import"))
  let names = []
  let mut context = false
  fn take_context() {
    if (self.is_name("with") || self.is_name("without")) &&
      self.look().tok is Name("context") {
      context = self.next().tok is Name("with")
      ignore(self.next())
      true
    } else {
      false
    }
  }
  for ;; {
    if !names.is_empty() {
      self.expect_op(",")
    }
    if take_context() {
      break
    }
    let name = self.expect_name()
    if name.has_prefix("_") {
      raise self.fail("names starting with an underscore cannot be imported")
    }
    let renamed = if self.skip_name("as") {
      Some(self.expect_name())
    } else {
      None
    }
    names.push((name, renamed))
    if take_context() || !self.is_op(",") {
      break
    }
  }
  FromImport(target, names, context~)
}

///|
/// `(a, b=1, ...rest)`; the rest parameter is the indentation syntax's.
pub fn Parser::parse_signature(
  self : Parser,
) -> Array[Param] raise @spec.Refused {
  self.expect_op("(")
  let params = []
  let mut defaults = false
  while !self.is_op(")") {
    if !params.is_empty() {
      self.expect_op(",")
      if self.is_op(")") {
        break
      }
    }
    if self.is_op(".") {
      for _ in 0..<3 {
        self.expect_op(".")
      }
      params.push({ name: self.expect_name(), default: None, rest: true, })
      continue
    }
    let name = self.expect_name()
    if params.iter().any(p => p.name == name) {
      raise self.fail("duplicate parameter \{name}")
    }
    let default = if self.skip_op("=") {
      defaults = true
      Some(self.parse_expression())
    } else if defaults {
      raise self.fail(
        "a parameter without a default follows one with a default",
      )
    } else {
      None
    }
    params.push({ name, default, rest: false, })
  }
  self.expect_op(")")
  params
}

///|
/// `{% trans %}`, as Jinja's i18n extension reads it.
fn Parser::parse_trans(self : Parser) -> Node raise @spec.Refused {
  let context = match self.current().tok {
    Str(s) => {
      ignore(self.next())
      Some(s)
    }
    _ => None
  }
  let vars : Array[(String, Expr)] = []
  let mut count : Expr? = None
  let mut trimmed : Bool? = None
  while self.current().tok != BlockEnd {
    if !vars.is_empty() {
      self.expect_op(",")
    }
    if self.skip_op(":") {
      break
    }
    let name = self.expect_name()
    if vars.iter().any(pair => pair.0 == name) {
      raise self.fail("translatable variable \{name} defined twice")
    }
    let value = if self.skip_op("=") {
      self.parse_expression()
    } else if trimmed is None && name is ("trimmed" | "notrimmed") {
      trimmed = Some(name == "trimmed")
      continue
    } else {
      Name(name)
    }
    vars.push((name, value))
    if count is None {
      count = Some(value)
    }
  }
  self.expect(BlockEnd)
  let (singular_names, singular) = self.trans_block(true)
  if count is None && !singular_names.is_empty() {
    count = Some(Name(singular_names[0]))
  }
  let mut plural = None
  let referenced = singular_names
  if self.skip_name("pluralize") {
    if self.current().tok != BlockEnd {
      let name = self.expect_name()
      match vars.iter().find_first(pair => pair.0 == name) {
        Some(pair) => count = Some(pair.1)
        None => raise self.fail("unknown variable \{name} for pluralisation")
      }
    }
    self.expect(BlockEnd)
    let (plural_names, text) = self.trans_block(false)
    plural = Some(text)
    referenced.append(plural_names)
  }
  ignore(self.next())
  for name in referenced {
    if !vars.iter().any(pair => pair.0 == name) {
      vars.push((name, Name(name)))
    }
  }
  if plural is Some(_) && count is None {
    raise self.fail("pluralize without variables")
  }
  let squeeze = fn(s : String) {
    if trimmed == Some(true) {
      s.split_whitespace()
    } else {
      s
    }
  }
  let escaped = !referenced.is_empty()
  let fix = fn(s : String) {
    if escaped {
      s
    } else {
      s.replace_all(old="%%", new="%")
    }
  }
  TransOut({
    context,
    singular: fix(squeeze(singular)),
    plural: plural.map(p => fix(squeeze(p))),
    vars,
    count: if plural is Some(_) {
      count
    } else {
      None
    },
  })
}

///|
/// The text of a translatable section up to `pluralize` or `endtrans`, with
/// each `{{ name }}` written as `%(name)s`. The current token is left on the
/// closing tag's name.
fn Parser::trans_block(
  self : Parser,
  pluralize : Bool,
) -> (Array[String], String) raise @spec.Refused {
  let names = []
  let buf = StringBuilder()
  for ;; {
    match self.current().tok {
      Data(text) => {
        buf.write_string(text.replace_all(old="%", new="%%"))
        ignore(self.next())
      }
      VarBegin => {
        ignore(self.next())
        let name = self.expect_name()
        names.push(name)
        buf.write_string("%(\{name})s")
        self.expect(VarEnd)
      }
      BlockBegin => {
        ignore(self.next())
        match self.current().tok {
          Name("endtrans") => break
          Name("pluralize") if pluralize => break
          Name("pluralize") =>
            raise self.fail(
              "a translatable section can have only one pluralize section",
            )
          Name("trans") =>
            raise self.fail(
              "trans blocks cannot be nested; did you mean endtrans?",
            )
          tok =>
            raise self.fail(
              "control structures in translatable sections are not allowed; saw \{describe(tok)}",
            )
        }
      }
      Eof => raise self.fail("the translation block is never closed")
      tok => raise self.fail("unexpected \{describe(tok)}")
    }
  }
  (names, buf.to_string())
}

///|
/// Collapse runs of whitespace to one space and trim the ends, as the
/// `trimmed` modifier does.
fn String::split_whitespace(self : String) -> String {
  let parts = []
  let word = StringBuilder()
  for ch in self {
    if ch is (' ' | '\t' | '\n' | '\r' | '\u{0B}' | '\u{0C}') {
      if !word.is_empty() {
        parts.push(word.to_string())
        word.reset()
      }
    } else {
      word.write_char(ch)
    }
  }
  if !word.is_empty() {
    parts.push(word.to_string())
  }
  parts.join(" ")
}
