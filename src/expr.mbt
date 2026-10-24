// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A cursor over the template's bytes. Both frontends and the expression
/// parser read through this one type, so every fault can name the byte where
/// reading stopped.
priv struct Cur {
  src : String
  end : Int32
  mut at : Int32
  base : Int32 // where position 0 of src sits in the template
}

///|
fn Cur::make(src : String, start : Int32, end_ : Int32) -> Cur {
  { src, end: end_, at: start, base: 0, }
}

///|
fn unit_at(s : String, i : Int32) -> UInt16 {
  s.at(i)
}

///|
fn Cur::peek(self : Cur) -> UInt16 {
  if self.at < self.end {
    unit_at(self.src, self.at)
  } else {
    0xFFFF
  }
}

///|
fn Cur::peek_at(self : Cur, ahead : Int32) -> UInt16 {
  let i = self.at + ahead
  if i < self.end {
    unit_at(self.src, i)
  } else {
    0xFFFF
  }
}

///|
fn Cur::eat(self : Cur, word : String) -> Bool {
  let n = word.length()
  if self.at + n <= self.end && self.src[self.at:self.at + n] == word {
    self.at = self.at + n
    return true
  }
  false
}

///|
fn is_digit(unit : UInt16) -> Bool {
  unit >= 0x30 && unit <= 0x39
}

///|
fn is_name_start(unit : UInt16) -> Bool {
  (unit >= 0x61 && unit <= 0x7A) ||
  (unit >= 0x41 && unit <= 0x5A) ||
  unit == 0x5F
}

///|
fn is_name_part(unit : UInt16) -> Bool {
  is_name_start(unit) || is_digit(unit)
}

///|
fn Cur::read_word(self : Cur) -> String {
  let start = self.at
  while self.at < self.end && is_name_part(self.peek()) {
    self.at = self.at + 1
  }
  self.src[start:self.at].to_owned()
}

///|
fn Cur::skip_ws(self : Cur) -> Unit {
  while self.at < self.end {
    match self.peek() {
      0x20 | 0x09 | 0x0A | 0x0D => self.at = self.at + 1
      _ => break
    }
  }
}

///|
pub enum Unop {
  Neg
  Not
}

///|
pub enum Binop {
  Add
  Sub
  Mul
  Div
  FloorDiv
  Mod
  Pow
  Concat
  Eq
  Ne
  Lt
  Gt
  Le
  Ge
  In
  NotIn
  And
  Or
}

///|
/// An argument in a call or a filter: positional or named.
pub enum Arg {
  Pos(Expr)
  Kw(String, Expr)
}

///|
/// The expression language, Jinja's whole of it: literals, collections,
/// subscripting and slicing, attribute and call, arithmetic and comparison,
/// filters, tests, and the inline conditional.
pub enum Expr {
  Lit(Value)
  Name(String)
  ListLit(Array[Expr])
  TupleLit(Array[Expr])
  DictLit(Array[(Expr, Expr)])
  Attr(Expr, String)
  Index(Expr, Expr)
  Slice(Expr, Expr?, Expr?, Expr?)
  Call(Expr, Array[Arg])
  Unary(Unop, Expr)
  Binary(Binop, Expr, Expr)
  Ternary(Expr, Expr, Expr)
  Filter(Expr, String, Array[Arg])
  Is(Expr, String, Array[Arg], Bool)
}

///|
/// The first place `needle` occurs at or after `from`, if it occurs.
fn find_from(src : String, needle : String, from : Int32) -> Int32? {
  let n = src.length()
  let m = needle.length()
  let mut i = from
  while i + m <= n {
    if src[i:i + m] == needle {
      return Some(i)
    }
    i = i + 1
  }
  None
}

///|
/// A stretch of a view, as a view; `substring` belongs to `String` alone.
fn view_sub(v : StringView, from : Int32, till : Int32) -> StringView {
  v.view(start_offset=from, end_offset=till)
}

///|
/// The next bare word, or "" when the cursor does not stand on one.
fn Cur::peek_name(self : Cur) -> String {
  if !is_name_start(self.peek()) {
    return ""
  }
  let start = self.at
  let mut end = self.at
  while end < self.end && is_name_part(unit_at(self.src, end)) {
    end = end + 1
  }
  self.src[start:end].to_owned()
}

///|
fn Cur::take_name(self : Cur) -> String {
  let word = self.peek_name()
  self.at = self.at + word.length()
  word
}

///|
/// An expression, comma tuples included where a statement allows them
/// (`{% set t = 1, 2 %}`).
fn parse_expression(c : Cur, with_tuple~ : Bool = false) -> Expr raise Fault {
  let first = parse_condexpr(c)
  if with_tuple {
    c.skip_ws()
    if c.peek() == 0x2C {
      let parts = [first]
      while c.peek() == 0x2C {
        c.at = c.at + 1
        c.skip_ws()
        parts.push(parse_condexpr(c))
        c.skip_ws()
      }
      return TupleLit(parts)
    }
  }
  first
}

///|
fn parse_condexpr(c : Cur) -> Expr raise Fault {
  let value = parse_or(c)
  c.skip_ws()
  if c.peek_name() == "if" {
    ignore(c.take_name())
    c.skip_ws()
    let cond = parse_or(c)
    c.skip_ws()
    if c.peek_name() == "else" {
      ignore(c.take_name())
      c.skip_ws()
      let otherwise = parse_condexpr(c)
      return Ternary(cond, value, otherwise)
    }
    raise lexical(c.base + c.at, "an inline if needs an else")
  }
  value
}

///|
fn parse_or(c : Cur) -> Expr raise Fault {
  let mut left = parse_and(c)
  let mut going = true
  while going {
    going = false
    c.skip_ws()
    if c.peek_name() == "or" {
      ignore(c.take_name())
      c.skip_ws()
      left = Binary(Or, left, parse_and(c))
      going = true
    }
  }
  left
}

///|
fn parse_and(c : Cur) -> Expr raise Fault {
  let mut left = parse_not(c)
  let mut going = true
  while going {
    going = false
    c.skip_ws()
    if c.peek_name() == "and" {
      ignore(c.take_name())
      c.skip_ws()
      left = Binary(And, left, parse_not(c))
      going = true
    }
  }
  left
}

///|
fn parse_not(c : Cur) -> Expr raise Fault {
  c.skip_ws()
  if c.peek_name() == "not" {
    ignore(c.take_name())
    c.skip_ws()
    return Unary(Not, parse_not(c))
  }
  parse_compare(c)
}

///|
/// Comparisons, `in` and `is`, one precedence level in Jinja. Python's chains
/// (`a < b < c`) fold into an `and` of consecutive comparisons.
fn parse_compare(c : Cur) -> Expr raise Fault {
  let left = parse_math1(c)
  let ops : Array[CompareOp] = []
  let rights : Array[Expr] = []
  let mut going = true
  while going {
    going = false
    c.skip_ws()
    match parse_compare_op(c) {
      Some(IsTest(negated)) => {
        c.skip_ws()
        let (name, args) = parse_test_call(c)
        let operand = fold_compare(left, ops, rights)
        return Is(operand, name, args, negated)
      }
      Some(Cmp(op)) => {
        c.skip_ws()
        ops.push(Cmp(op))
        rights.push(parse_math1(c))
        going = true
      }
      None => ()
    }
  }
  fold_compare(left, ops, rights)
}

///|
priv enum CompareOp {
  Cmp(Binop)
  IsTest(Bool)
}

///|
/// One comparison, or an `and` of the chain Python would allow.
fn fold_compare(
  left : Expr,
  ops : Array[CompareOp],
  rights : Array[Expr],
) -> Expr {
  let mut whole : Expr? = None
  let mut current = left
  for i = 0; i < ops.length(); i = i + 1 {
    let op = match ops[i] {
      Cmp(op) => op
      IsTest(_) => continue
    }
    let comparison = Binary(op, current, rights[i])
    whole = match whole {
      Some(before) => Some(Binary(And, before, comparison))
      None => Some(comparison)
    }
    current = rights[i]
  }
  match whole {
    Some(one) => one
    None => left
  }
}

///|
fn parse_compare_op(c : Cur) -> CompareOp? {
  let unit = c.peek()
  if unit == 0x3D && c.peek_at(1) == 0x3D {
    c.at = c.at + 2
    return Some(Cmp(Eq))
  }
  if unit == 0x21 && c.peek_at(1) == 0x3D {
    c.at = c.at + 2
    return Some(Cmp(Ne))
  }
  if unit == 0x3C && c.peek_at(1) == 0x3D {
    c.at = c.at + 2
    return Some(Cmp(Le))
  }
  if unit == 0x3E && c.peek_at(1) == 0x3D {
    c.at = c.at + 2
    return Some(Cmp(Ge))
  }
  if unit == 0x3C {
    c.at = c.at + 1
    return Some(Cmp(Lt))
  }
  if unit == 0x3E {
    c.at = c.at + 1
    return Some(Cmp(Gt))
  }
  let word = c.peek_name()
  if word == "in" {
    ignore(c.take_name())
    return Some(Cmp(In))
  }
  if word == "not" {
    let save = c.at
    ignore(c.take_name())
    c.skip_ws()
    if c.peek_name() == "in" {
      ignore(c.take_name())
      return Some(Cmp(NotIn))
    }
    c.at = save
    return None
  }
  if word == "is" {
    ignore(c.take_name())
    c.skip_ws()
    if c.peek_name() == "not" {
      ignore(c.take_name())
      c.skip_ws()
      return Some(IsTest(true))
    }
    return Some(IsTest(false))
  }
  None
}

///|
/// A test and its arguments: `is divisibleby` or `is divisibleby(3)`.
fn parse_test_call(c : Cur) -> (String, Array[Arg]) raise Fault {
  if !is_name_start(c.peek()) {
    raise lexical(c.base + c.at, "a test needs a name after `is`")
  }
  let name = c.read_word()
  c.skip_ws()
  if c.peek() == 0x3A {
    raise lexical(
      c.at,
      "test arguments take parentheses, as in `is divisibleby(3)`",
    )
  }
  if c.peek() == 0x28 {
    c.at = c.at + 1
    let args = parse_call_args(c)
    return (name, args)
  }
  (name, [])
}

///|
fn parse_math1(c : Cur) -> Expr raise Fault {
  let mut left = parse_concat(c)
  let mut going = true
  while going {
    going = false
    c.skip_ws()
    if c.peek() == 0x2B {
      c.at = c.at + 1
      c.skip_ws()
      left = Binary(Add, left, parse_concat(c))
      going = true
    } else if c.peek() == 0x2D {
      c.at = c.at + 1
      c.skip_ws()
      left = Binary(Sub, left, parse_concat(c))
      going = true
    }
  }
  left
}

///|
fn parse_concat(c : Cur) -> Expr raise Fault {
  let mut left = parse_math2(c)
  let mut going = true
  while going {
    going = false
    c.skip_ws()
    if c.peek() == 0x7E {
      c.at = c.at + 1
      c.skip_ws()
      left = Binary(Concat, left, parse_math2(c))
      going = true
    }
  }
  left
}

///|
fn parse_math2(c : Cur) -> Expr raise Fault {
  let mut left = parse_pow(c)
  let mut going = true
  while going {
    going = false
    c.skip_ws()
    if c.peek() == 0x2A {
      c.at = c.at + 1
      c.skip_ws()
      left = Binary(Mul, left, parse_pow(c))
      going = true
    } else if c.peek() == 0x2F && c.peek_at(1) == 0x2F {
      c.at = c.at + 2
      c.skip_ws()
      left = Binary(FloorDiv, left, parse_pow(c))
      going = true
    } else if c.peek() == 0x2F {
      c.at = c.at + 1
      c.skip_ws()
      left = Binary(Div, left, parse_pow(c))
      going = true
    } else if c.peek() == 0x25 {
      c.at = c.at + 1
      c.skip_ws()
      left = Binary(Mod, left, parse_pow(c))
      going = true
    }
  }
  left
}

///|
fn parse_pow(c : Cur) -> Expr raise Fault {
  let mut left = parse_unary(c)
  let mut going = true
  while going {
    going = false
    c.skip_ws()
    if c.peek() == 0x2A && c.peek_at(1) == 0x2A {
      c.at = c.at + 2
      c.skip_ws()
      left = Binary(Pow, left, parse_unary(c))
      going = true
    }
  }
  left
}

///|
/// Unary minus, then the postfix chain Jinja allows on any primary:
/// attribute, subscript, slice, call, and filters — interleaved.
fn parse_unary(c : Cur) -> Expr raise Fault {
  c.skip_ws()
  if c.peek() == 0x2D {
    c.at = c.at + 1
    c.skip_ws()
    return Unary(Neg, parse_unary(c))
  }
  if c.peek() == 0x2B {
    c.at = c.at + 1
    c.skip_ws()
    return parse_unary(c)
  }
  let mut node = parse_primary(c)
  let mut going = true
  while going {
    going = false
    c.skip_ws()
    if c.peek() == 0x2E && is_name_start(c.peek_at(1)) {
      c.at = c.at + 1
      node = Attr(node, c.read_word())
      going = true
    } else if c.peek() == 0x5B {
      c.at = c.at + 1
      c.skip_ws()
      node = parse_subscript(c, node)
      going = true
    } else if c.peek() == 0x28 {
      c.at = c.at + 1
      node = Call(node, parse_call_args(c))
      going = true
    } else if c.peek() == 0x7C {
      c.at = c.at + 1
      c.skip_ws()
      if !is_name_start(c.peek()) {
        raise lexical(c.base + c.at, "a filter needs a name after `|`")
      }
      let name = c.read_word()
      c.skip_ws()
      if c.peek() == 0x3A {
        raise lexical(
          c.at,
          "filter arguments take parentheses, as in `|truncate(3)`; the colon spelling is Django's",
        )
      }
      let args = if c.peek() == 0x28 {
        c.at = c.at + 1
        parse_call_args(c)
      } else {
        []
      }
      node = Filter(node, name, args)
      going = true
    }
  }
  node
}

///|
/// The inside of `a[ … ]`: one subscript or a slice.
fn parse_subscript(c : Cur, target : Expr) -> Expr raise Fault {
  if c.peek() == 0x3A {
    c.at = c.at + 1
    c.skip_ws()
    return finish_slice(c, target, None)
  }
  let inner = parse_expression(c)
  c.skip_ws()
  if c.peek() == 0x3A {
    c.at = c.at + 1
    c.skip_ws()
    return finish_slice(c, target, Some(inner))
  }
  if c.peek() != 0x5D {
    raise lexical(c.base + c.at, "expected `]`")
  }
  c.at = c.at + 1
  Index(target, inner)
}

///|
fn finish_slice(c : Cur, target : Expr, start : Expr?) -> Expr raise Fault {
  let stop = if c.peek() == 0x3A || c.peek() == 0x5D {
    None
  } else {
    Some(parse_expression(c))
  }
  c.skip_ws()
  let step = if c.peek() == 0x3A {
    c.at = c.at + 1
    c.skip_ws()
    if c.peek() == 0x5D {
      None
    } else {
      Some(parse_expression(c))
    }
  } else {
    None
  }
  c.skip_ws()
  if c.peek() != 0x5D {
    raise lexical(c.base + c.at, "expected `]`")
  }
  c.at = c.at + 1
  Slice(target, start, stop, step)
}

///|
/// The inside of `( … )`: positional and named arguments, commas between.
fn parse_call_args(c : Cur) -> Array[Arg] raise Fault {
  let args = []
  c.skip_ws()
  if c.peek() == 0x29 {
    c.at = c.at + 1
    return args
  }
  let mut going = true
  while going {
    going = false
    c.skip_ws()
    if is_name_start(c.peek()) {
      let save = c.at
      let name = c.read_word()
      c.skip_ws()
      if c.peek() == 0x3D && c.peek_at(1) != 0x3D {
        c.at = c.at + 1
        c.skip_ws()
        args.push(Kw(name, parse_expression(c)))
      } else {
        c.at = save
        args.push(Pos(parse_expression(c)))
      }
    } else {
      args.push(Pos(parse_expression(c)))
    }
    c.skip_ws()
    if c.peek() == 0x2C {
      c.at = c.at + 1
      going = true
    } else if c.peek() == 0x29 {
      c.at = c.at + 1
    } else {
      raise lexical(c.base + c.at, "expected `,` or `)`")
    }
  }
  args
}

///|
fn parse_primary(c : Cur) -> Expr raise Fault {
  c.skip_ws()
  let unit = c.peek()
  if unit == 0x28 {
    c.at = c.at + 1
    c.skip_ws()
    if c.peek() == 0x29 {
      c.at = c.at + 1
      return TupleLit([])
    }
    let inner = parse_expression(c, with_tuple=true)
    c.skip_ws()
    if c.peek() != 0x29 {
      raise lexical(c.base + c.at, "expected `)`")
    }
    c.at = c.at + 1
    inner
  } else if unit == 0x5B {
    c.at = c.at + 1
    let items = []
    c.skip_ws()
    while c.peek() != 0x5D {
      items.push(parse_expression(c))
      c.skip_ws()
      if c.peek() == 0x2C {
        c.at = c.at + 1
        c.skip_ws()
      } else if c.peek() != 0x5D {
        raise lexical(c.base + c.at, "expected `,` or `]`")
      }
    }
    c.at = c.at + 1
    ListLit(items)
  } else if unit == 0x7B {
    c.at = c.at + 1
    let pairs = []
    c.skip_ws()
    while c.peek() != 0x7D {
      let key = parse_dict_key(c)
      c.skip_ws()
      if c.peek() != 0x3A {
        raise lexical(
          c.base + c.at,
          "a mapping literal needs `:` after its key",
        )
      }
      c.at = c.at + 1
      c.skip_ws()
      pairs.push((key, parse_expression(c)))
      c.skip_ws()
      if c.peek() == 0x2C {
        c.at = c.at + 1
        c.skip_ws()
      } else if c.peek() != 0x7D {
        raise lexical(c.base + c.at, "expected `,` or `}`")
      }
    }
    c.at = c.at + 1
    DictLit(pairs)
  } else if unit == 0x27 || unit == 0x22 {
    Lit(Text(read_string_literal(c)))
  } else if is_digit(unit) {
    Lit(read_number_literal(c))
  } else if is_name_start(unit) {
    let word = c.read_word()
    match word {
      "true" | "True" => Lit(Bool(true))
      "false" | "False" => Lit(Bool(false))
      "none" | "None" => Lit(Null)
      _ => Name(word)
    }
  } else {
    raise lexical(c.base + c.at, "an expression cannot start here")
  }
}

///|
/// A mapping key: a name standing for itself, a string, a number, or a
/// parenthesised expression.
fn parse_dict_key(c : Cur) -> Expr raise Fault {
  let unit = c.peek()
  if is_name_start(unit) {
    return Lit(Text(c.read_word()))
  }
  if unit == 0x27 || unit == 0x22 {
    return Lit(Text(read_string_literal(c)))
  }
  if unit == 0x28 {
    c.at = c.at + 1
    c.skip_ws()
    let inner = parse_expression(c)
    c.skip_ws()
    if c.peek() != 0x29 {
      raise lexical(c.base + c.at, "expected `)`")
    }
    c.at = c.at + 1
    return inner
  }
  parse_primary(c)
}

///|
/// A quoted string with Python's escapes, read in runs so astral characters
/// stay whole.
fn read_string_literal(c : Cur) -> String raise Fault {
  let quote = c.peek()
  c.at = c.at + 1
  let out = StringBuilder()
  let mut run = c.at
  while c.at < c.end {
    let unit = c.peek()
    if unit == quote {
      out.write_string(c.src[run:c.at].to_owned())
      c.at = c.at + 1
      return out.to_string()
    }
    if unit == 0x5C {
      out.write_string(c.src[run:c.at].to_owned())
      c.at = c.at + 1
      out.write_char(read_escape(c))
      run = c.at
    } else {
      c.at = c.at + 1
    }
  }
  raise lexical(c.base + c.at, "an unterminated string")
}

///|
fn read_escape(c : Cur) -> Char raise Fault {
  let unit = c.peek()
  c.at = c.at + 1
  match unit {
    0x6E => '\n'
    0x74 => '\t'
    0x72 => '\r'
    0x62 => '\b'
    0x66 => '\f'
    0x76 => (0x0B).unsafe_to_char()
    0x30 => (0).unsafe_to_char()
    0x78 => read_hex(c, 2).unsafe_to_char()
    0x75 => read_hex(c, 4).unsafe_to_char()
    other =>
      match other.to_char() {
        Some(c) => c
        None => '?'
      }
  }
}

///|
fn read_hex(c : Cur, count : Int32) -> Int32 raise Fault {
  let mut value = 0
  for i = 0; i < count; i = i + 1 {
    let unit = c.peek()
    let digit = if unit >= 0x30 && unit <= 0x39 {
      unit.to_int() - 0x30
    } else if unit >= 0x61 && unit <= 0x66 {
      unit.to_int() - 0x61 + 10
    } else if unit >= 0x41 && unit <= 0x46 {
      unit.to_int() - 0x41 + 10
    } else {
      raise lexical(
        c.base + c.at,
        "a \\x or \\u escape needs hexadecimal digits",
      )
    }
    value = value * 16 + digit
    c.at = c.at + 1
  }
  value
}

///|
/// A number literal: whole digits name an integer, a point or an exponent
/// names a double. `_` separates groups, as in Python.
fn read_number_literal(c : Cur) -> Value {
  let start = c.at
  let mut seen_point = false
  let mut seen_exponent = false
  while is_digit(c.peek()) || c.peek() == 0x5F {
    c.at = c.at + 1
  }
  if c.peek() == 0x2E && is_digit(c.peek_at(1)) {
    seen_point = true
    c.at = c.at + 1
    while is_digit(c.peek()) || c.peek() == 0x5F {
      c.at = c.at + 1
    }
  }
  if (c.peek() == 0x65 || c.peek() == 0x45) &&
    ({
      let after = c.peek_at(1)
      is_digit(after) ||
      ((after == 0x2B || after == 0x2D) && is_digit(c.peek_at(2)))
    }) {
    seen_exponent = true
    c.at = c.at + 1
    if c.peek() == 0x2B || c.peek() == 0x2D {
      c.at = c.at + 1
    }
    while is_digit(c.peek()) || c.peek() == 0x5F {
      c.at = c.at + 1
    }
  }
  let text = c.src[start:c.at].replace_all(old="_", new="")
  if !seen_point && !seen_exponent {
    try {
      return Int(@string.parse_int64(text))
    } catch {
      _ => ()
    }
  }
  Double(@string.parse_double(text)) catch {
    _ => Int(0L)
  }
}

///|
fn Cur::from(src : String, start : Int32, end_ : Int32, base : Int32) -> Cur {
  { src, end: end_, at: start, base, }
}
