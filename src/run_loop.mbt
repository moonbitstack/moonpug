///|
/// The `loop` variable: where an iteration stands, its neighbours, and the
/// `cycle` and `changed` helpers; in a recursive loop, a callable that
/// renders the body again one level deeper.
priv struct Loop {
  items : Array[@spec.Value]
  mut index0 : Int32
  depth0 : Int32
  mut last_changed : Array[@spec.Value]?
  again : ((Array[@spec.Value], Map[String, @spec.Value]) -> @spec.Value raise @spec.Refused)?
}

///|
impl @spec.Object for Loop with fn kind(_) {
  "the loop"
}

///|
impl @spec.Object for Loop with fn attr(self, name) {
  let n = self.items.length()
  let i = self.index0
  match name {
    "index0" => Some(Int(i.to_int64()))
    "index" => Some(Int((i + 1).to_int64()))
    "revindex0" => Some(Int((n - i - 1).to_int64()))
    "revindex" => Some(Int((n - i).to_int64()))
    "first" => Some(Bool(i == 0))
    "last" => Some(Bool(i == n - 1))
    "length" => Some(Int(n.to_int64()))
    "depth0" => Some(Int(self.depth0.to_int64()))
    "depth" => Some(Int((self.depth0 + 1).to_int64()))
    "previtem" =>
      Some(
        if i > 0 {
          self.items[i - 1]
        } else {
          Undefined("there is no previous item")
        },
      )
    "nextitem" =>
      Some(
        if i + 1 < n {
          self.items[i + 1]
        } else {
          Undefined("there is no next item")
        },
      )
    "cycle" =>
      Some(
        @spec.Value::func("cycle", (_, args, _) => {
          if args.is_empty() {
            raise @spec.invalid("no items for cycling given")
          }
          args[self.index0 % args.length()]
        }),
      )
    "changed" =>
      Some(
        @spec.Value::func("changed", (_, args, _) => {
          let different = match self.last_changed {
            Some(before) => before != args
            None => true
          }
          if different {
            self.last_changed = Some(args.copy())
          }
          Bool(different)
        }),
      )
    _ => None
  }
}

///|
impl @spec.Object for Loop with fn callable(self) {
  self.again is Some(_)
}

///|
impl @spec.Object for Loop with fn call(self, _, args, named) {
  match self.again {
    Some(run) => run(args, named)
    None =>
      raise @spec.invalid("the loop is not recursive, so it cannot be called")
  }
}

///|
impl @spec.Object for Loop with fn show(self) {
  "<LoopContext \{self.index0 + 1}/\{self.items.length()}>"
}

///|
/// The items a loop walks. Jinja's loop walks a mapping's keys; the
/// indentation syntax's `each` walks its values, or value and key with two
/// names, and value and index over a list.
fn Run::loop_items(
  self : Run,
  target : @syntax.Target,
  iterable : @spec.Value,
  each : Bool,
) -> Array[@spec.Value] raise @spec.Refused {
  let pairs = each && target is Tuple([_, _])
  match (each, iterable) {
    (true, Dict(fields)) =>
      if pairs {
        fields.iter().map(p => @spec.Value::Tuple([p.1, Text(p.0)])).collect()
      } else {
        fields.values().collect()
      }
    (true, _) if pairs => {
      let items = self.call.items(iterable)
      items.mapi((i, v) => @spec.Value::Tuple([v, Int(i.to_int64())]))
    }
    _ => self.call.items(iterable)
  }
}

///|
fn Run::run_for(
  self : Run,
  target : @syntax.Target,
  iterable : @spec.Value,
  cond : @syntax.Expr?,
  recursive : Bool,
  each : Bool,
  body : Array[@syntax.Node],
  otherwise : Array[@syntax.Node],
  depth0 : Int32,
) -> Unit raise @spec.Refused {
  let all = self.loop_items(target, iterable, each)
  let items = match cond {
    None => all
    Some(check) => {
      let kept = []
      for item in all {
        let keep = Ref(false)
        self.scoped(Map([]), () => {
          self.assign(target, item)
          keep.val = self.call.truthy(self.eval(check))
        })
        if keep.val {
          kept.push(item)
        }
      }
      kept
    }
  }
  if items.is_empty() {
    self.run_nodes(otherwise)
    return
  }
  let again = if recursive {
    Some(fn(
      args : Array[@spec.Value],
      _named : Map[String, @spec.Value],
    ) raise @spec.Refused {
      guard args is [inner] else {
        raise @spec.invalid("a recursive loop takes one iterable")
      }
      self.enter()
      defer self.leave()
      let text = self.capture(() => {
        self.run_for(target, inner, cond, recursive, each, body, [], depth0 + 1)
      })
      self.rendered(text)
    })
  } else {
    None
  }
  let state = Loop::{ items, index0: 0, depth0, last_changed: None, again, }
  for i, item in items {
    state.index0 = i
    self.scoped(Map([]), () => {
      self.assign(target, item)
      self.bind("loop", Object(state))
      self.run_nodes(body)
    })
    if self.braking {
      self.braking = false
      break
    }
    self.skipping = false
  }
}
