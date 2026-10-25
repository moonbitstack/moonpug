///|
/// The tree both syntaxes read into. Nothing after reading knows which
/// syntax a template was written in.
pub(all) enum Expr {
  Lit(@spec.Value)
  Name(String)
  List(Array[Expr])
  Tuple(Array[Expr])
  Dict(Array[(Expr, Expr)])
  Attr(Expr, String)
  Item(Expr, Expr)
  /// A slice as a subscript: `a[1:2]` is `Item(a, Slice(1, 2, None))`.
  Slice(Expr?, Expr?, Expr?)
  Call(Expr, Array[Arg])
  Not(Expr)
  Neg(Expr)
  Pos(Expr)
  Binary(Op, Expr, Expr)
  Compare(Expr, Array[(Op, Expr)])
  Concat(Array[Expr])
  Cond(Expr, Expr, Expr?)
  Filter(Expr?, String, Array[Arg])
  Test(Expr, String, Array[Arg])
  /// The attributes of a mixin call, merged the way an element merges its
  /// own: classes gather, `&attributes` splats override.
  Attributes(Array[Attr], Array[Expr])
}

///|
pub(all) enum Op {
  Add
  Sub
  Mul
  Div
  FloorDiv
  Mod
  Pow
  And
  Or
  Eq
  Ne
  Lt
  Gt
  Le
  Ge
  In
  NotIn
} derive(Eq)

///|
pub extend Op with Eq::{equal, not_equal}

///|
/// An argument: positional, named, or spread with `*` and `**`.
pub(all) enum Arg {
  Pos(Expr)
  Named(String, Expr)
  Spread(Expr)
  SpreadNamed(Expr)
}

///|
/// Where an assignment or a loop binds.
pub(all) enum Target {
  Name(String)
  Tuple(Array[Target])
  Field(String, String)
}

///|
/// A macro or call-block parameter.
pub(all) struct Param {
  name : String
  default : Expr?
  rest : Bool
}

///|

///|
/// A macro, or a mixin of the indentation syntax: a mixin also receives the
/// call's attributes as `attributes` and its block as `block`.
pub(all) struct Macro {
  name : String
  params : Array[Param]
  body : Array[Node]
  pug : Bool
}

///|
pub(all) enum Placement {
  Replace
  Append
  Prepend
} derive(Eq)

///|
pub extend Placement with Eq::{equal, not_equal}

///|
pub(all) struct Block {
  name : String
  body : Array[Node]
  scoped : Bool
  required : Bool
  placement : Placement
}

///|
/// A `{% trans %}`: message ids with `%(name)s` placeholders, the values
/// those names take, the plural count, and the message context.
pub(all) struct Trans {
  context : String?
  singular : String
  plural : String?
  vars : Array[(String, Expr)]
  count : Expr?
}

///|
/// An attribute of an element in the indentation syntax. `None` is a bare
/// attribute such as `checked`.
pub(all) struct Attr {
  name : String
  value : Expr?
  escape : Bool
}

///|
pub(all) struct Element {
  tag : Expr
  attrs : Array[Attr]
  splats : Array[Expr]
  self_close : Bool
  body : Array[Node]
}

///|
pub(all) enum Node {
  /// The line in the template where the following node starts.
  Line(Int32)
  Text(String)
  Out(Expr)
  /// Output never escaped: the indentation syntax's `!=` and `!{…}`.
  Raw(Expr)
  /// A loop. `each` is the indentation syntax's: with two names the value
  /// binds first, then the index or key.
  For(
    target~ : Target,
    iter~ : Expr,
    cond~ : Expr?,
    recursive~ : Bool,
    each~ : Bool,
    body~ : Array[Node],
    otherwise~ : Array[Node]
  )
  If(Array[(Expr, Array[Node])], Array[Node])
  Set(Target, Expr)
  SetBlock(Target, Expr?, Array[Node])
  MacroDef(Macro)
  CallBlock(Array[Param], Expr, Array[Node])
  FilterBlock(Expr, Array[Node])
  Extends(Expr)
  BlockDef(Block)
  /// `raw` includes the text as it stands, as the indentation syntax does
  /// for a file that is not a template. `inline` renders the file in place,
  /// as the indentation syntax does: what it defines stays defined and its
  /// blocks take part in inheritance. `block` is the indentation syntax's
  /// body under an include, rendered where the included file says `yield`.
  Include(
    Expr,
    missing~ : Bool,
    context~ : Bool,
    raw~ : Bool,
    inline~ : Bool,
    block~ : Array[Node]
  )
  /// Where an include's block goes.
  Yield
  Import(Expr, String, context~ : Bool)
  FromImport(Expr, Array[(String, String?)], context~ : Bool)
  With(Array[(Target, Expr)], Array[Node])
  Autoescape(Expr, Array[Node])
  Do(Expr)
  Debug
  Show(Expr, Array[Node])
  Once(Expr?, Array[Node])
  TransOut(Trans)
  Break
  Continue
  Element(Element)
  Doctype(String)
  Comment(Array[Node])
  Case(Expr, Array[(Array[Expr], Array[Node])], Array[Node])
}
