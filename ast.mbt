// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// How a macro remembers its parameters: the names in order, and the default
/// expression for whichever of them carry one.
priv struct MacroDef {
  name : String
  params : Array[String]
  defaults : Array[(Int32, Expr)]
  rest : String?
  body : Array[Node]
  mut home : Map[String, Value]
}

///|
/// One attribute of an element: bare (`disabled`), a value, or a condition
/// that decides bare-or-absent.
priv enum AttrVal {
  Bare
  Val(Expr)
}

///|
priv struct Attr {
  name : String
  mut value : AttrVal
}

///|
/// An element in the indentation surface: the tag with its shorthand, its
/// attributes, and what sits inside it.
priv struct Elem {
  tag : String
  id : String?
  classes : Array[String]
  attrs : Array[Attr]
  splats : Array[Expr]
  key : Expr?
  self_close : Bool
  inline : Array[Node]
  out : Expr?
  out_raw : Bool
  children : Array[Node]
}

///|
/// How a `case` arm matches: several values, or the default arm.
priv struct WhenArm {
  values : Array[Expr]
  body : Array[Node]
}

///|
priv enum BlockMod {
  Override
  Append
  Prepend
}

///|
/// A `{% block %}` as the renderer files it: its body and the way a child
/// template combining with a parent wants it placed.
priv struct BlockDef {
  body : Array[Node]
  scoped : Bool
  required : Bool
  mod : BlockMod
}

///|
/// A `{% trans %}`: the singular text, the plural text when there is one, the
/// bindings visible to the placeholders, and which binding counts.
priv struct TransSpec {
  singular : String
  plural : String?
  bindings : Array[(String, Expr)]
  count_name : String?
}

///|
/// The tree both frontends build. One tree, one evaluator: the surfaces differ
/// only in how they spell, never in what a node means.
priv enum Node {
  Text(String)
  Group(Array[Node])
  Out(Expr)
  OutRaw(Expr)
  For(
    names~ : Array[String],
    iter~ : Expr,
    filter~ : Expr?,
    recursive~ : Bool,
    swap~ : Bool,
    body~ : Array[Node],
    otherwise~ : Array[Node]
  )
  If(Array[(Expr, Array[Node])], Array[Node])
  SetVar(Array[String], Expr)
  SetPath(Array[String], Expr)
  SetBlock(String, Array[Node])
  MacroDef(String, MacroDef)
  CallBlock(Array[String], Expr, Array[Node])
  FilterBlock(Array[(String, Array[Arg])], Array[Node])
  Extends(Expr)
  Block(String, BlockDef)
  Include(Expr, Bool, Bool)
  Import(Expr, String, Bool)
  FromImport(Expr, Array[(String, String?)], Bool)
  With(Array[(String, Expr)], Array[Node])
  Autoescape(Expr, Array[Node])
  Do(Array[Expr])
  Debug
  Show(Expr, Array[Node])
  Once(String?, Array[Node])
  Trans(TransSpec)
  Break
  Continue
  LangBlock(String, String)
  Element(Elem)
  Doctype(String)
  Comment(Bool, Array[Node])
  Case(Expr, Array[WhenArm], Array[Node])
}
