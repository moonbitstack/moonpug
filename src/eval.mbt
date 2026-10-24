// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One expression evaluated against the scope stack. Filters and tests live
/// in their own files; this file walks the tree everything else builds.
fn eval(env : Env, expr : Expr) -> Value raise Fault {
  match expr {
    Lit(value) => value
    Name(name) => env.get(name)
    ListLit(items) | TupleLit(items) => {
      let out = []
      for item in items {
        out.push(eval(env, item))
      }
      Seq(out)
    }
    DictLit(pairs) => {
      let out : Map[String, Value] = Map([])
      for pair in pairs {
        let (key_expr, value_expr) = pair
        out.set(show_value(eval(env, key_expr)), eval(env, value_expr))
      }
      Dict(out)
    }
    Attr(target, field) => eval_attr(env, eval(env, target), field)
    Index(target, index) => eval_index(env, eval(env, target), eval(env, index))
    Slice(target, start, stop, step) => {
      let base = eval(env, target)
      let s = eval_optional(env, start)
      let e = eval_optional(env, stop)
      let st = eval_optional(env, step)
      eval_slice(base, s, e, st)
    }
    Call(target, args) => {
      let callee = eval(env, target)
      let (pos, kw) = eval_args(env, args)
      call_value(env, callee, pos, kw)
    }
    Unary(Not, inner) => Bool(!truthy(eval(env, inner)))
    Unary(Neg, inner) => negate(eval(env, inner))
    Binary(And, left, right) => {
      let l = eval(env, left)
      if truthy(l) {
        eval(env, right)
      } else {
        l
      }
    }
    Binary(Or, left, right) => {
      let l = eval(env, left)
      if truthy(l) {
        l
      } else {
        eval(env, right)
      }
    }
    Binary(op, left, right) => {
      let l = eval(env, left)
      let r = eval(env, right)
      eval_binary(env, op, l, r)
    }
    Ternary(cond, then, otherwise) =>
      if truthy(eval(env, cond)) {
        eval(env, then)
      } else {
        eval(env, otherwise)
      }
    Filter(target, name, args) => {
      let input = eval(env, target)
      let (pos, kw) = eval_args(env, args)
      match env.filters.get(name) {
        Some(found) => found.filter(context_of(env), input, pos, kw)
        None => raise Unknown(name~, kind="filter")
      }
    }
    Is(target, name, args, negated) => {
      // `defined` and `undefined` read the expression, not the value; they
      // belong to the engine and no registry sees them.
      let result = match name {
        "defined" => !is_absent(env, target)
        "undefined" => is_absent(env, target)
        _ => {
          let value = eval_plain(env, target)
          let (pos, _) = eval_args(env, args)
          match env.tests.get(name) {
            Some(found) => found.probe(value, pos)
            None => raise Unknown(name~, kind="test")
          }
        }
      }
      Bool(if negated { !result } else { result })
    }
  }
}

///|
fn eval_optional(env : Env, expr : Expr?) -> Value? raise Fault {
  match expr {
    Some(e) => Some(eval(env, e))
    None => None
  }
}

///|
fn eval_args(
  env : Env,
  args : Array[Arg],
) -> (Array[Value], Map[String, Value]) raise Fault {
  let pos = []
  let kw : Map[String, Value] = Map([])
  for arg in args {
    match arg {
      Pos(e) => pos.push(eval(env, e))
      Kw(name, e) => kw.set(name, eval(env, e))
    }
  }
  (pos, kw)
}

///|
/// `a.b`: a mapping's key, a macro's name and arguments, a namespace's field,
/// and the undefined the policy hands back for everything else.
fn eval_attr(env : Env, target : Value, field : String) -> Value raise Fault {
  // The sandbox blocks reaching into the context's objects; the loop object
  // stays reachable, a template cannot walk without it.
  if env.opts.sandbox {
    match target {
      Dict(fields) =>
        if !fields.contains("__loop__") {
          raise Wrong(
            because="sandbox: attribute access is off; use a subscript or a filter",
          )
        }
      _ =>
        raise Wrong(
          because="sandbox: attribute access is off; use a subscript or a filter",
        )
    }
  }
  match target {
    Dict(fields) =>
      match fields.get(field) {
        Some(value) => value
        None => env.absent(field)
      }
    Namespaced(fields) =>
      match fields.get(field) {
        Some(value) => value
        None => env.absent(field)
      }
    MacroV(m) =>
      match field {
        "name" => Text(m.name)
        "arguments" => {
          let names = []
          for p in m.params {
            names.push(Value::Text(p))
          }
          Seq(names)
        }
        "catch_kwargs" | "catch_varargs" | "caller" | "debug" => Bool(false)
        _ => env.absent(field)
      }
    CyclerV(state) =>
      match field {
        "next" | "reset" | "current" => cycler_method(state, field)
        _ => env.absent(field)
      }
    Absent(name) =>
      match env.policy {
        Chainable => Absent("\{name}.\{field}")
        Strict => raise Undefined(name~)
        Lenient => raise Wrong(because="undefined: \{name}")
      }
    _ => env.absent(field)
  }
}

///|
/// `a[b]`: a list by integer, a mapping by its key's text, a string by
/// character. Out of range is undefined, the way Jinja's getitem is.
fn eval_index(env : Env, target : Value, index : Value) -> Value raise Fault {
  match target {
    Absent(name) =>
      match env.policy {
        Chainable => Absent(name)
        Strict => raise Undefined(name~)
        Lenient => raise Wrong(because="undefined: \{name}")
      }
    Seq(items) => {
      let at = index_as_int(index)
      let n = items.length()
      let fixed = if at < 0 { at + n } else { at }
      if fixed < 0 || fixed >= n {
        return env.absent("out of range")
      }
      items[fixed]
    }
    Text(s) | Markup(s) => {
      let at = index_as_int(index)
      let n = s.length()
      let fixed = if at < 0 { at + n } else { at }
      if fixed < 0 || fixed >= n {
        return env.absent("out of range")
      }
      Text(s[fixed:fixed + 1].to_owned())
    }
    Dict(fields) => {
      let key = show_value(index)
      match fields.get(key) {
        Some(value) => value
        None => env.absent(key)
      }
    }
    _ => raise Wrong(because="\{kind_of(target)} cannot be subscripted")
  }
}

///|
fn index_as_int(index : Value) -> Int32 raise Fault {
  match index {
    Int(n) => n.to_int()
    Double(d) => d.to_int()
    _ => raise Wrong(because="a subscript must be a number")
  }
}

///|
/// Python slices: negative counts from the end, a step may skip or reverse.
fn eval_slice(
  target : Value,
  start : Value?,
  stop : Value?,
  step : Value?,
) -> Value raise Fault {
  let step_n = match step {
    Some(Int(n)) => n.to_int()
    Some(Double(d)) => d.to_int()
    Some(Absent(_)) | None => 1
    Some(_) => raise Wrong(because="a slice step must be a number")
  }
  if step_n == 0 {
    raise Wrong(because="a slice step cannot be zero")
  }
  match target {
    Seq(items) => {
      let n = items.length()
      let (from, till) = slice_bounds(start, stop, n, step_n)
      let out = []
      if step_n > 0 {
        let mut i = from
        while i < till {
          out.push(items[i])
          i = i + step_n
        }
      } else {
        let mut k = from
        while k > till && k < n {
          out.push(items[k])
          k = k + step_n
        }
      }
      Seq(out)
    }
    Text(s) | Markup(s) => {
      let n = s.length()
      let (from, till) = slice_bounds(start, stop, n, step_n)
      let out = StringBuilder()
      if step_n > 0 {
        let mut i = from
        while i < till {
          out.write_string(s[i:i + 1].to_owned())
          i = i + step_n
        }
      } else {
        let mut k = from
        while k > till && k < n {
          out.write_string(s[k:k + 1].to_owned())
          k = k + step_n
        }
      }
      Text(out.to_string())
    }
    _ => raise Wrong(because="\{kind_of(target)} cannot be sliced")
  }
}

///|
fn slice_bounds(
  start : Value?,
  stop : Value?,
  n : Int32,
  step : Int32,
) -> (Int32, Int32) {
  // Python slice arithmetic: negatives count from the end, and with a
  // negative step the defaults walk from the last element down to the first.
  let clamp = fn(v : Int32) -> Int32 {
    let w = if v < 0 { v + n } else { v }
    if w < 0 {
      0
    } else if w > n {
      n
    } else {
      w
    }
  }
  let from = match start {
    Some(Int(v)) => {
      let v = v.to_int()
      if step < 0 {
        let w = if v < 0 { v + n } else { v }
        if w >= n {
          n - 1
        } else if w < 0 {
          -1
        } else {
          w
        }
      } else {
        clamp(v)
      }
    }
    Some(Double(d)) => {
      let v = d.to_int()
      if step < 0 {
        let w = if v < 0 { v + n } else { v }
        if w >= n {
          n - 1
        } else if w < 0 {
          -1
        } else {
          w
        }
      } else {
        clamp(v)
      }
    }
    Some(Absent(_)) | None | Some(_) => if step < 0 { n - 1 } else { 0 }
  }
  let till = match stop {
    Some(Int(v)) => {
      let v = v.to_int()
      if step < 0 {
        if v < 0 {
          v + n
        } else {
          v
        }
      } else {
        clamp(v)
      }
    }
    Some(Double(d)) => {
      let v = d.to_int()
      if step < 0 {
        if v < 0 {
          v + n
        } else {
          v
        }
      } else {
        clamp(v)
      }
    }
    Some(Absent(_)) | None | Some(_) => if step < 0 { -1 } else { n }
  }
  (from, till)
}

///|
fn negate(value : Value) -> Value raise Fault {
  match value {
    Int(n) => Int(0L - n)
    Double(d) => Double(0.0 - d)
    _ => raise Wrong(because="\{kind_of(value)} cannot be negated")
  }
}

///|
fn eval_binary(
  _env : Env,
  op : Binop,
  l : Value,
  r : Value,
) -> Value raise Fault {
  match op {
    Eq => Bool(same_value(l, r))
    Ne => Bool(!same_value(l, r))
    Lt => Bool(compare_value(l, r) < 0)
    Gt => Bool(compare_value(l, r) > 0)
    Le => Bool(compare_value(l, r) <= 0)
    Ge => Bool(compare_value(l, r) >= 0)
    In => Bool(contains_value(r, l))
    NotIn => Bool(!contains_value(r, l))
    Concat => Text(show_value(l) + show_value(r))
    Add =>
      match (l, r) {
        (Seq(a), Seq(b)) => {
          let out = []
          for item in a {
            out.push(item)
          }
          for item in b {
            out.push(item)
          }
          Seq(out)
        }
        (Markup(a), Markup(b)) => Markup(a + b)
        (Int(_), Int(_))
        | (Int(_), Double(_))
        | (Double(_), Int(_))
        | (Double(_), Double(_)) => arith(Add, l, r)
        _ => Text(show_value(l) + show_value(r))
      }
    Sub | Mul | Div | FloorDiv | Mod | Pow => arith(op, l, r)
    And | Or => Bool(truthy(l)) // short-circuit handled earlier
  }
}

///|
/// Arithmetic with Python's typing: whole numbers stay whole, a fraction
/// anywhere makes a double, `/` always divides truly and `//` floors.
fn arith(op : Binop, l : Value, r : Value) -> Value raise Fault {
  match (l, r) {
    (Int(a), Int(b)) => {
      let a64 = a
      let b64 = b
      match op {
        Add => Int(a64 + b64)
        Sub => Int(a64 - b64)
        Mul => Int(a64 * b64)
        Div => Double(a64.to_double() / b64.to_double())
        FloorDiv =>
          Int(@double.floor(a64.to_double() / b64.to_double()).to_int64())
        Mod => Int(python_mod(a64, b64))
        Pow =>
          if b64 >= 0L {
            Int(int_pow(a64, b64))
          } else {
            Double(@math.pow(a64.to_double(), b64.to_double()))
          }
        _ => raise Wrong(because="not arithmetic")
      }
    }
    (Int(a), Double(b)) => float_arith(op, a.to_double(), b)
    (Double(a), Int(b)) => float_arith(op, a, b.to_double())
    (Double(a), Double(b)) => float_arith(op, a, b)
    _ =>
      raise Wrong(
        because="\{kind_of(l)} and \{kind_of(r)} do not do arithmetic",
      )
  }
}

///|
fn float_arith(op : Binop, a : Double, b : Double) -> Value raise Fault {
  match op {
    Add => Double(a + b)
    Sub => Double(a - b)
    Mul => Double(a * b)
    Div => Double(a / b)
    FloorDiv => Double(@double.floor(a / b))
    Mod => Double(a - b * @double.floor(a / b))
    Pow => Double(@math.pow(a, b))
    _ => raise Wrong(because="not arithmetic")
  }
}

///|
/// Python's modulo takes the divisor's sign.
fn python_mod(a : Int64, b : Int64) -> Int64 {
  let m = a % b
  if m != 0L && (m < 0L) != (b < 0L) {
    m + b
  } else {
    m
  }
}

///|
fn int_pow(base : Int64, exp : Int64) -> Int64 {
  let mut out = 1L
  let mut b = base
  let mut e = exp
  while e > 0L {
    if e % 2L == 1L {
      out = out * b
    }
    b = b * b
    e = e / 2L
  }
  out
}

///|
/// Calling a value: macros render, native functions run, and anything else is
/// refused with the value's kind in the message.
fn call_value(
  env : Env,
  callee : Value,
  pos : Array[Value],
  kw : Map[String, Value],
) -> Value raise Fault {
  match callee {
    Native(_, call) => call(pos)
    GlobalV(found) => found.call(context_of(env), pos, kw)
    JoinerV(state) =>
      if state.used {
        Text(state.sep)
      } else {
        state.used = true
        Text("")
      }
    MacroV(m) => {
      let rendered = invoke_macro(env, m, pos, kw, None)
      Markup(rendered)
    }
    Dict(fields) =>
      // A loop in a recursive `for` calls itself through the reserved key.
      match fields.get("__call__") {
        Some(Native(_, call)) => call(pos)
        _ => raise Wrong(because="a mapping is not callable")
      }
    Absent(name) =>
      match env.policy {
        Strict => raise Undefined(name~)
        _ => raise Wrong(because="undefined: \{name} is not callable")
      }
    _ => raise Wrong(because="\{kind_of(callee)} is not callable")
  }
}

///|
fn eval_plain(env : Env, expr : Expr) -> Value {
  eval(env, expr) catch {
    _ => Absent("undefined")
  }
}

///|
fn is_absent(env : Env, expr : Expr) -> Bool {
  match expr {
    Name(name) => env.find(name) is None && env.globals.get(name) is None
    Attr(inner, field) => {
      if is_absent(env, inner) {
        return true
      }
      match eval_plain(env, inner) {
        Dict(fields) =>
          match fields.get(field) {
            Some(value) => value is Absent(_)
            None => true
          }
        Namespaced(fields) =>
          match fields.get(field) {
            Some(value) => value is Absent(_)
            None => true
          }
        _ => true
      }
    }
    _ => eval_plain(env, expr) is Absent(_)
  }
}
