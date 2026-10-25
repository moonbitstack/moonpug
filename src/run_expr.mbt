///|
/// Refuse using an undefined value, naming it.
fn undefined_use(name : String) -> @spec.Refused {
  @spec.unknown("name", name)
}

///|
fn Run::eval(
  self : Run,
  expr : @syntax.Expr,
) -> @spec.Value raise @spec.Refused {
  match expr {
    Lit(v) => v
    Name(n) => self.lookup(n)
    List(items) => Seq(items.map(e => self.eval(e)))
    Tuple(items) => Tuple(items.map(e => self.eval(e)))
    Dict(pairs) => {
      let out = Map([])
      for pair in pairs {
        let key = self.eval(pair.0)
        out[self.call.text(key)] = self.eval(pair.1)
      }
      Dict(out)
    }
    Attr(target, name) => self.get_attr(self.eval(target), name)
    Item(target, Slice(a, b, c)) => {
      let base = self.eval(target)
      let start = self.eval_opt(a)
      let stop = self.eval_opt(b)
      let step = self.eval_opt(c)
      slice(base, start, stop, step)
    }
    Item(target, key) => self.get_item(self.eval(target), self.eval(key))
    Slice(_, _, _) => raise @spec.invalid("a slice belongs inside brackets")
    Call(target, args) => {
      let callee = self.eval(target)
      let (pos, named) = self.eval_args(args)
      self.invoke(callee, pos, named)
    }
    Not(e) => Bool(!self.call.truthy(self.eval(e)))
    Neg(e) =>
      match self.eval(e) {
        Int(n) => Int(-n)
        Double(d) => Double(-d)
        Bool(b) => Int(if b { -1 } else { 0 })
        Undefined(name) => raise undefined_use(name)
        v => raise @spec.invalid("bad operand type for unary -: \{v.kind()}")
      }
    Pos(e) =>
      match self.eval(e) {
        Int(_) | Double(_) as v => v
        Bool(b) => Int(if b { 1 } else { 0 })
        Undefined(name) => raise undefined_use(name)
        v => raise @spec.invalid("bad operand type for unary +: \{v.kind()}")
      }
    Binary(And, l, r) => {
      let left = self.eval(l)
      if self.call.truthy(left) {
        self.eval(r)
      } else {
        left
      }
    }
    Binary(Or, l, r) => {
      let left = self.eval(l)
      if self.call.truthy(left) {
        left
      } else {
        self.eval(r)
      }
    }
    Binary(op, l, r) => self.arith(op, self.eval(l), self.eval(r))
    Compare(first, ops) => {
      let mut left = self.eval(first)
      for pair in ops {
        let right = self.eval(pair.1)
        if !self.compare(pair.0, left, right) {
          return Bool(false)
        }
        left = right
      }
      Bool(true)
    }
    Concat(parts) => {
      let buf = StringBuilder()
      let mut markup = false
      let values = parts.map(p => self.eval(p))
      for v in values {
        if v is Markup(_) {
          markup = true
        }
      }
      for v in values {
        match v {
          Markup(s) => buf.write_string(s)
          other => {
            let t = self.call.text(other)
            buf.write_string(if markup { @spec.escape(t) } else { t })
          }
        }
      }
      if markup {
        Markup(buf.to_string())
      } else {
        Text(buf.to_string())
      }
    }
    Cond(c, then, otherwise) =>
      if self.call.truthy(self.eval(c)) {
        self.eval(then)
      } else {
        match otherwise {
          Some(e) => self.eval(e)
          None => Undefined("")
        }
      }
    Filter(input, name, args) => {
      let value = match input {
        Some(e) => self.eval(e)
        None => raise @spec.invalid("a filter needs a value")
      }
      let (pos, named) = self.eval_args(args)
      self.call.filter(name, value, pos, named)
    }
    Test(target, name, args) => {
      let value = self.eval(target)
      let (pos, named) = self.eval_args(args)
      if !named.is_empty() {
        raise @spec.invalid("tests take no named arguments")
      }
      Bool(self.call.check(name, value, pos))
    }
    Attributes(attrs, splats) => {
      let merged = Map([])
      for attr in attrs {
        let value = match attr.value {
          Some(e) => self.eval(e)
          None => Bool(true)
        }
        merge_attr(merged, attr.name, value)
      }
      for splat in splats {
        match self.eval(splat) {
          Dict(fields) =>
            for k, v in fields {
              merge_attr(merged, k, v)
            }
          Undefined(name) => raise undefined_use(name)
          v =>
            raise @spec.invalid("&attributes takes a mapping, not \{v.kind()}")
        }
      }
      Dict(merged)
    }
  }
}

///|
fn Run::eval_opt(
  self : Run,
  expr : @syntax.Expr?,
) -> @spec.Value? raise @spec.Refused {
  match expr {
    Some(e) => Some(self.eval(e))
    None => None
  }
}

///|
fn Run::eval_args(
  self : Run,
  args : Array[@syntax.Arg],
) -> (Array[@spec.Value], Map[String, @spec.Value]) raise @spec.Refused {
  let pos = []
  let named = Map([])
  for arg in args {
    match arg {
      Pos(e) => pos.push(self.eval(e))
      Named(k, e) => named[k] = self.eval(e)
      Spread(e) =>
        for v in self.call.items(self.eval(e)) {
          pos.push(v)
        }
      SpreadNamed(e) =>
        match self.eval(e) {
          Dict(fields) =>
            for k, v in fields {
              named[k] = v
            }
          v =>
            raise @spec.invalid(
              "argument after ** must be a mapping, not \{v.kind()}",
            )
        }
    }
  }
  (pos, named)
}

///|
/// `value.name`: a method of a string, list or mapping, an object's
/// attribute, else the item of that name; missing is undefined.
fn Run::get_attr(
  self : Run,
  value : @spec.Value,
  name : String,
) -> @spec.Value raise @spec.Refused {
  match value {
    Undefined(outer) =>
      match self.call.undefined {
        Chainable => Undefined(outer + "." + name)
        _ => raise undefined_use(outer)
      }
    Object(obj) =>
      match obj.attr(name) {
        Some(v) => v
        None => Undefined(name)
      }
    _ =>
      match @defaults.attr(value, name) {
        Some(m) => m
        None =>
          match value.item(Text(name)) {
            Some(v) => v
            None => Undefined(name)
          }
      }
  }
}

///|
/// `value[key]`: the item, else the attribute of that name; missing is
/// undefined.
fn Run::get_item(
  self : Run,
  value : @spec.Value,
  key : @spec.Value,
) -> @spec.Value raise @spec.Refused {
  match value {
    Undefined(outer) =>
      match self.call.undefined {
        Chainable => Undefined(outer)
        _ => raise undefined_use(outer)
      }
    _ =>
      match value.item(key) {
        Some(v) => v
        None =>
          match key {
            Text(name) => self.get_attr(value, name)
            _ => Undefined(key.to_string())
          }
      }
  }
}

///|
/// Call a value: objects take the call; anything else is refused.
fn Run::invoke(
  self : Run,
  callee : @spec.Value,
  pos : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  match callee {
    Object(obj) => obj.call(self.call, pos, named)
    Undefined(name) => raise undefined_use(name)
    v => raise @spec.invalid("\{v.kind()} is not callable")
  }
}

///|
/// A slice of a list, tuple or string, with Python's bounds and steps.
fn slice(
  value : @spec.Value,
  start : @spec.Value?,
  stop : @spec.Value?,
  step : @spec.Value?,
) -> @spec.Value raise @spec.Refused {
  let index = fn(v : @spec.Value?) -> Int32? raise @spec.Refused {
    match v {
      None | Some(Null) => None
      Some(x) =>
        match x.index() {
          Some(i) => Some(i)
          None => raise @spec.invalid("slice indices must be integers or None")
        }
    }
  }
  let st = index(step).unwrap_or(1)
  if st == 0 {
    raise @spec.invalid("slice step cannot be zero")
  }
  let pick = fn(n : Int32) -> Array[Int32] raise @spec.Refused {
    let clamp = fn(v : Int32?, default : Int32) {
      match v {
        None => default
        Some(i) => {
          let j = if i < 0 { i + n } else { i }
          if st > 0 {
            j.max(0).min(n)
          } else {
            j.max(-1).min(n - 1)
          }
        }
      }
    }
    let a = clamp(index(start), if st > 0 { 0 } else { n - 1 })
    let b = clamp(index(stop), if st > 0 { n } else { -1 })
    let out = []
    let mut i = a
    if st > 0 {
      while i < b {
        out.push(i)
        i += st
      }
    } else {
      while i > b {
        out.push(i)
        i += st
      }
    }
    out
  }
  match value {
    Seq(items) => Seq(pick(items.length()).map(i => items[i]))
    Tuple(items) => Tuple(pick(items.length()).map(i => items[i]))
    Text(s) | Markup(s) => {
      let cs = s.iter().collect()
      let picked = String::from_array(pick(cs.length()).map(i => cs[i]))
      if value is Markup(_) {
        Markup(picked)
      } else {
        Text(picked)
      }
    }
    Undefined(name) => raise undefined_use(name)
    v => raise @spec.invalid("\{v.kind()} cannot be sliced")
  }
}

///|
fn int_or_overflow(
  a : Int64,
  b : Int64,
  r : Int64,
  op : String,
) -> @spec.Value raise @spec.Refused {
  let ok = match op {
    "+" => !((a >= 0L) == (b >= 0L) && (r >= 0L) != (a >= 0L))
    "-" => !((a >= 0L) != (b >= 0L) && (r >= 0L) != (a >= 0L))
    _ =>
      a == 0L || (r / a == b && !(a == -1L && b == -9223372036854775807L - 1L))
  }
  if ok {
    Int(r)
  } else {
    raise @spec.invalid("integer result too large to hold in 64 bits")
  }
}

///|
/// The arithmetic operators with Python's meaning: numbers, string and list
/// concatenation and repetition, `%` formatting, safe text escaping the
/// plain side.
fn Run::arith(
  self : Run,
  op : @syntax.Op,
  l : @spec.Value,
  r : @spec.Value,
) -> @spec.Value raise @spec.Refused {
  match (l, r) {
    (Undefined(name), _) | (_, Undefined(name)) => raise undefined_use(name)
    _ => ()
  }
  match (op, l, r) {
    (Add, Markup(_), Text(_) | Markup(_)) | (Add, Text(_), Markup(_)) =>
      Markup(l.markup() + r.markup())
    (Add, Text(a), Text(b)) => Text(a + b)
    (Add, Seq(a), Seq(b)) => Seq(a + b)
    (Add, Tuple(a), Tuple(b)) => Tuple(a + b)
    (Mul, Text(s) | Markup(s), Int(n)) | (Mul, Int(n), Text(s) | Markup(s)) => {
      let rep = if n > 0L { s.repeat(n.to_int()) } else { "" }
      if l is Markup(_) || r is Markup(_) {
        Markup(rep)
      } else {
        Text(rep)
      }
    }
    (Mul, Seq(items), Int(n)) | (Mul, Int(n), Seq(items)) => {
      let out = []
      for _ in 0L..<n {
        out.append(items)
      }
      Seq(out)
    }
    (Mod, Text(s) | Markup(s), _) => {
      let markup = l is Markup(_)
      let formatted = @defaults.percent(self.call, s, r, escape=markup)
      if markup {
        Markup(formatted)
      } else {
        Text(formatted)
      }
    }
    _ => numeric(op, l, r)
  }
}

///|
fn as_int(v : @spec.Value) -> Int64? {
  match v {
    Int(n) => Some(n)
    Bool(b) => Some(if b { 1 } else { 0 })
    _ => None
  }
}

///|
fn numeric(
  op : @syntax.Op,
  l : @spec.Value,
  r : @spec.Value,
) -> @spec.Value raise @spec.Refused {
  let symbol = match op {
    Add => "+"
    Sub => "-"
    Mul => "*"
    Div => "/"
    FloorDiv => "//"
    Mod => "%"
    Pow => "**"
    _ => "?"
  }
  match (as_int(l), as_int(r)) {
    (Some(a), Some(b)) =>
      return match op {
        Add => int_or_overflow(a, b, a + b, "+")
        Sub => int_or_overflow(a, b, a - b, "-")
        Mul => int_or_overflow(a, b, a * b, "*")
        Div => {
          if b == 0L {
            raise @spec.invalid("division by zero")
          }
          Double(a.to_double() / b.to_double())
        }
        FloorDiv | Mod => {
          if b == 0L {
            raise @spec.invalid("integer division or modulo by zero")
          }
          let q = a / b
          let m = a % b
          let (q, m) = if m != 0L && (m < 0L) != (b < 0L) {
            (q - 1L, m + b)
          } else {
            (q, m)
          }
          if op == FloorDiv {
            Int(q)
          } else {
            Int(m)
          }
        }
        Pow =>
          if b < 0L {
            Double(@math.pow(a.to_double(), b.to_double()))
          } else {
            let mut result = 1L
            let mut base = a
            let mut e = b
            while e > 0L {
              if e % 2L == 1L {
                let next = result * base
                if base != 0L && next / base != result {
                  raise @spec.invalid(
                    "integer result too large to hold in 64 bits",
                  )
                }
                result = next
              }
              e = e / 2L
              if e > 0L {
                let sq = base * base
                if base != 0L && sq / base != base {
                  raise @spec.invalid(
                    "integer result too large to hold in 64 bits",
                  )
                }
                base = sq
              }
            }
            Int(result)
          }
        _ => raise @spec.invalid("unsupported operator")
      }
    _ => ()
  }
  match (l.number(), r.number()) {
    (Some(a), Some(b)) =>
      Double(
        match op {
          Add => a + b
          Sub => a - b
          Mul => a * b
          Div => {
            if b == 0.0 {
              raise @spec.invalid("float division by zero")
            }
            a / b
          }
          FloorDiv => {
            if b == 0.0 {
              raise @spec.invalid("float floor division by zero")
            }
            (a / b).floor()
          }
          Mod => {
            if b == 0.0 {
              raise @spec.invalid("float modulo by zero")
            }
            let m = a - b * (a / b).floor()
            m
          }
          Pow => @math.pow(a, b)
          _ => raise @spec.invalid("unsupported operator")
        },
      )
    _ =>
      raise @spec.invalid(
        "unsupported operand types for \{symbol}: \{l.kind()} and \{r.kind()}",
      )
  }
}

///|
fn Run::compare(
  self : Run,
  op : @syntax.Op,
  l : @spec.Value,
  r : @spec.Value,
) -> Bool raise @spec.Refused {
  match (l, r) {
    (Undefined(name), _) | (_, Undefined(name)) if self.call.refuses(name) =>
      raise undefined_use(name)
    _ => ()
  }
  match op {
    Eq => l == r
    Ne => l != r
    In => self.contains(r, l)
    NotIn => !self.contains(r, l)
    Lt => l.compare(r) < 0
    Gt => l.compare(r) > 0
    Le => l.compare(r) <= 0
    Ge => l.compare(r) >= 0
    _ => raise @spec.invalid("not a comparison")
  }
}

///|
fn Run::contains(
  self : Run,
  container : @spec.Value,
  item : @spec.Value,
) -> Bool raise @spec.Refused {
  match container {
    Undefined(name) =>
      if self.call.refuses(name) {
        raise undefined_use(name)
      } else {
        false
      }
    _ => container.contains(item)
  }
}

///|
/// Merge an attribute into a mapping the way an element merges `&attributes`:
/// classes gather into a list, styles join, anything else overrides.
fn merge_attr(
  into : Map[String, @spec.Value],
  name : String,
  value : @spec.Value,
) -> Unit {
  match (name, into.get(name)) {
    ("class", Some(before)) => {
      let items = match before {
        Seq(xs) => xs.copy()
        other => [other]
      }
      match value {
        Seq(more) => items.append(more)
        other => items.push(other)
      }
      into[name] = Seq(items)
    }
    ("style", Some(before)) => {
      let a = style_text(before)
      let b = style_text(value)
      let a = if a.is_empty() || a.has_suffix(";") { a } else { a + ";" }
      let b = if b.is_empty() || b.has_suffix(";") { b } else { b + ";" }
      into[name] = Text(a + b)
    }
    _ => into[name] = value
  }
}

///|
/// Pug's `style` attribute value: a mapping as `key:value;` pairs.
fn style_text(value : @spec.Value) -> String {
  match value {
    Dict(fields) => {
      let out = StringBuilder()
      for k, v in fields {
        out.write_string(k + ":" + v.to_string() + ";")
      }
      out.to_string()
    }
    Null | Undefined(_) | Bool(false) => ""
    other => other.to_string()
  }
}
