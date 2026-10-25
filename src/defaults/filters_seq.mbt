///|
/// Python's `sorted`: stable, with a comparison that may refuse, and with
/// `reverse` keeping equal items in their original order.
fn sorted(
  items : Array[@spec.Value],
  key : (@spec.Value) -> @spec.Value,
  reverse : Bool,
) -> Array[@spec.Value] raise @spec.Refused {
  let keyed = items.map(item => (key(item), item))
  let n = keyed.length()
  let mut src = keyed
  let mut width = 1
  while width < n {
    let dst = []
    let mut lo = 0
    while lo < n {
      let mid = (lo + width).min(n)
      let hi = (lo + 2 * width).min(n)
      let mut i = lo
      let mut j = mid
      while i < mid && j < hi {
        let order = src[j].0.compare(src[i].0)
        let take_right = if reverse { order > 0 } else { order < 0 }
        if take_right {
          dst.push(src[j])
          j += 1
        } else {
          dst.push(src[i])
          i += 1
        }
      }
      while i < mid {
        dst.push(src[i])
        i += 1
      }
      while j < hi {
        dst.push(src[j])
        j += 1
      }
      lo = hi
    }
    src = dst
    width *= 2
  }
  src.map(pair => pair.1)
}

///|
/// Lowercase a string key, Jinja's `ignore_case`.
fn ignore_case(value : @spec.Value) -> @spec.Value {
  match value {
    Text(s) => Text(@moonucd.lower(s))
    Markup(s) => Markup(@moonucd.lower(s))
    other => other
  }
}

///|
/// The steps of an `attribute=` argument: `a.b.0` splits at dots and a step
/// written in digits indexes.
fn attribute_parts(attribute : @spec.Value) -> Array[@spec.Value] {
  match attribute {
    Null => []
    Text(s) | Markup(s) =>
      s
      .split(".")
      .map(part => {
        let p = part.to_owned()
        if !p.is_empty() && p.iter().all(is_digit) {
          @spec.Value::Int(@string.parse_int64(p) catch { _ => 0L })
        } else {
          Text(p)
        }
      })
      .collect()
    other => [other]
  }
}

///|
/// Jinja's `make_attrgetter`: follow the steps by item lookup, falling back
/// to an undefined value, or to `default` when one is given.
fn attrgetter(
  attribute : @spec.Value,
  lowercase~ : Bool = false,
  default? : @spec.Value,
) -> (@spec.Value) -> @spec.Value {
  let parts = attribute_parts(attribute)
  item => {
    let mut at = item
    for part in parts {
      at = match at.item(part) {
        Some(v) => v
        None => Undefined(part.to_string())
      }
      if default is Some(d) && at is Undefined(_) {
        at = d
      }
    }
    if lowercase {
      ignore_case(at)
    } else {
      at
    }
  }
}

///|
/// Jinja's `make_multi_attrgetter`: several comma-separated attributes,
/// compared as a list.
fn multi_attrgetter(
  attribute : @spec.Value,
  lowercase : Bool,
) -> (@spec.Value) -> @spec.Value {
  let getters = match attribute {
    Text(s) | Markup(s) =>
      s
      .split(",")
      .map(part => attrgetter(Text(part.to_owned()), lowercase~))
      .collect()
    Null => [attrgetter(Null, lowercase~)]
    other => [attrgetter(other, lowercase~)]
  }
  item => Seq(getters.map(get => get(item)))
}

///|
fn list_of(
  call : @spec.Call,
  value : @spec.Value,
) -> Array[@spec.Value] raise @spec.Refused {
  call.items(value)
}

///|
fn filter_batch(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("batch", ["linecount", "fill_with"], args, named)
  let count = b.int("linecount", 0)
  if count <= 0 {
    raise @spec.invalid("batch wants a positive line count")
  }
  let fill = b.get("fill_with")
  let out = []
  let mut row = []
  for item in list_of(call, value) {
    if row.length() == count {
      out.push(@spec.Value::Seq(row))
      row = []
    }
    row.push(item)
  }
  if !row.is_empty() {
    if fill is Some(f) && !(f is Null) {
      while row.length() < count {
        row.push(f)
      }
    }
    out.push(Seq(row))
  }
  Seq(out)
}

///|
fn filter_slice(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("slice", ["slices", "fill_with"], args, named)
  let slices = b.int("slices", 0)
  if slices <= 0 {
    raise @spec.invalid("slice wants a positive number of slices")
  }
  let fill = b.get("fill_with")
  let seq = list_of(call, value)
  let length = seq.length()
  let per = length / slices
  let extra = length % slices
  let mut offset = 0
  let out = []
  for number in 0..<slices {
    let start = offset + number * per
    if number < extra {
      offset += 1
    }
    let end = offset + (number + 1) * per
    let part = seq[start:end].to_owned()
    if fill is Some(f) && !(f is Null) && number >= extra {
      part.push(f)
    }
    out.push(@spec.Value::Seq(part))
  }
  Seq(out)
}

///|
fn filter_dictsort(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("dictsort", ["case_sensitive", "by", "reverse"], args, named)
  let fields = match value {
    Dict(fields) => fields
    _ => raise @spec.invalid("dictsort wants a mapping, not \{value.kind()}")
  }
  let pos = match b.text(call, "by", "key") {
    "key" => 0
    "value" => 1
    _ => raise @spec.invalid("you can only sort by either key or value")
  }
  let case_sensitive = b.flag("case_sensitive", false)
  let pairs = fields
    .iter()
    .map(pair => @spec.Value::Tuple([Text(pair.0), pair.1]))
    .collect()
  let key = fn(pair : @spec.Value) -> @spec.Value {
    match pair {
      Tuple(p) => if case_sensitive { p[pos] } else { ignore_case(p[pos]) }
      other => other
    }
  }
  Seq(sorted(pairs, key, b.flag("reverse", false)))
}

///|
fn filter_sort(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("sort", ["reverse", "case_sensitive", "attribute"], args, named)
  let getter = multi_attrgetter(
    b.get("attribute").unwrap_or(Null),
    !b.flag("case_sensitive", false),
  )
  Seq(
    sorted(list_of(call, value), item => getter(item), b.flag("reverse", false)),
  )
}

///|
fn filter_unique(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("unique", ["case_sensitive", "attribute"], args, named)
  let getter = attrgetter(
    b.get("attribute").unwrap_or(Null),
    lowercase=!b.flag("case_sensitive", false),
  )
  let seen : Array[@spec.Value] = []
  let out = []
  for item in list_of(call, value) {
    let key = getter(item)
    if !seen.contains(key) {
      seen.push(key)
      out.push(item)
    }
  }
  Seq(out)
}

///|
fn min_or_max(
  call : @spec.Call,
  who : String,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
  larger : Bool,
) -> @spec.Value raise @spec.Refused {
  let b = bind(who, ["case_sensitive", "attribute"], args, named)
  let items = list_of(call, value)
  if items.is_empty() {
    return Undefined("no aggregated item, the sequence was empty")
  }
  let getter = attrgetter(
    b.get("attribute").unwrap_or(Null),
    lowercase=!b.flag("case_sensitive", false),
  )
  let mut best = items[0]
  let mut best_key = getter(best)
  for item in items[1:] {
    let key = getter(item)
    let order = key.compare(best_key)
    if (larger && order > 0) || (!larger && order < 0) {
      best = item
      best_key = key
    }
  }
  best
}

///|
fn filter_first(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("first", [], args, named))
  match list_of(call, value) {
    [] => Undefined("no first item, the sequence was empty")
    items => items[0]
  }
}

///|
fn filter_last(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("last", [], args, named))
  match list_of(call, value) {
    [] => Undefined("no last item, the sequence was empty")
    items => items[items.length() - 1]
  }
}

///|
fn filter_random(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("random", [], args, named))
  let items = list_of(call, value)
  if items.is_empty() {
    return Undefined("no random item, the sequence was empty")
  }
  let draw = call.draw()
  let seed = (draw.to_int64() * 2654435761L + items.length().to_int64()) %
    4294967296L
  items[(seed % items.length().to_int64()).to_int()]
}

///|
fn filter_length(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("length", [], args, named))
  let n = match value {
    Text(s) | Markup(s) => char_count(s)
    Seq(items) | Tuple(items) => items.length()
    Dict(fields) => fields.length()
    Undefined(name) =>
      if call.refuses(name) {
        raise @spec.unknown("name", name)
      } else {
        0
      }
    Object(obj) =>
      match obj.items() {
        Some(items) => items.length()
        None => raise @spec.invalid("\{obj.kind()} has no length")
      }
    _ => raise @spec.invalid("\{value.kind()} has no length")
  }
  Int(n.to_int64())
}

///|
fn filter_list(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("list", [], args, named))
  Seq(list_of(call, value))
}

///|
fn filter_items(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("items", [], args, named))
  match value {
    Undefined(name) =>
      if call.refuses(name) {
        raise @spec.unknown("name", name)
      } else {
        Seq([])
      }
    Dict(fields) =>
      Seq(
        fields
        .iter()
        .map(pair => @spec.Value::Tuple([Text(pair.0), pair.1]))
        .collect(),
      )
    _ => raise @spec.invalid("items can only get item pairs from a mapping")
  }
}

///|
fn filter_reverse(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  ignore(bind("reverse", [], args, named))
  match value {
    Text(s) => Text(String::from_array(s.iter().collect().rev()))
    Markup(s) => Markup(String::from_array(s.iter().collect().rev()))
    _ => Seq(list_of(call, value).rev())
  }
}

///|
fn filter_join(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("join", ["d", "attribute"], args, named)
  let mut items = list_of(call, value)
  match b.get("attribute") {
    Some(attr) if !(attr is Null) => {
      let get = attrgetter(attr)
      items = items.map(get)
    }
    _ => ()
  }
  let sep = b.get("d").unwrap_or(Text(""))
  if !call.autoescape {
    let parts = []
    for item in items {
      parts.push(call.text(item))
    }
    return Text(parts.join(call.text(sep)))
  }
  let markup = sep is Markup(_) || items.iter().any(item => item is Markup(_))
  if markup {
    let parts = []
    for item in items {
      parts.push(
        match item {
          Markup(s) => s
          other => @spec.escape(call.text(other))
        },
      )
    }
    Markup(parts.join(sep.markup()))
  } else {
    let parts = []
    for item in items {
      parts.push(call.text(item))
    }
    Text(parts.join(call.text(sep)))
  }
}

///|
fn filter_sum(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("sum", ["attribute", "start"], args, named)
  let mut items = list_of(call, value)
  match b.get("attribute") {
    Some(attr) if !(attr is Null) => items = items.map(attrgetter(attr))
    _ => ()
  }
  let mut total = b.get("start").unwrap_or(Int(0))
  for item in items {
    total = add_values(total, item)
  }
  total
}

///|
/// Python's `+` on the values `sum` meets: numbers, lists, tuples.
fn add_values(
  a : @spec.Value,
  b : @spec.Value,
) -> @spec.Value raise @spec.Refused {
  match (a, b) {
    (Int(x), Int(y)) => Int(x + y)
    (Seq(x), Seq(y)) => Seq(x + y)
    (Tuple(x), Tuple(y)) => Tuple(x + y)
    _ =>
      match (a.number(), b.number()) {
        (Some(x), Some(y)) =>
          if a is Double(_) || b is Double(_) {
            Double(x + y)
          } else {
            Int((x + y).to_int64())
          }
        _ => raise @spec.invalid("\{a.kind()} and \{b.kind()} cannot be added")
      }
  }
}

///|
fn filter_map(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  if !call.truthy(value) {
    return Seq([])
  }
  let items = list_of(call, value)
  if items.is_empty() {
    return Seq([])
  }
  if args.is_empty() && named.contains("attribute") {
    for name, _ in named {
      if name != "attribute" && name != "default" {
        raise @spec.invalid("map got an unexpected argument \{name}")
      }
    }
    let get = match named.get("default") {
      Some(d) if !(d is Null) =>
        attrgetter(named.get("attribute").unwrap(), default=d)
      _ => attrgetter(named.get("attribute").unwrap())
    }
    return Seq(items.map(get))
  }
  guard args.length() > 0 else {
    raise @spec.invalid("map requires a filter argument")
  }
  let name = call.text(args[0])
  let rest = args[1:].to_owned()
  let out = []
  for item in items {
    out.push(call.filter(name, item, rest, named))
  }
  Seq(out)
}

///|
/// `select`, `reject`, `selectattr` and `rejectattr`: keep the items whose
/// test (or truth, when no test is named) comes out `keep`.
fn select_or_reject(
  call : @spec.Call,
  who : String,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
  keep : Bool,
  attr : Bool,
) -> @spec.Value raise @spec.Refused {
  if !call.truthy(value) {
    return Seq([])
  }
  let items = list_of(call, value)
  if !named.is_empty() {
    raise @spec.invalid("\{who} takes no named arguments")
  }
  let (transform, off) : ((@spec.Value) -> @spec.Value, Int32) = if attr {
    guard args.length() > 0 else {
      raise @spec.invalid("\{who} is missing the attribute name")
    }
    (attrgetter(args[0]), 1)
  } else {
    (fn(x) { x }, 0)
  }
  let check = if args.length() > off {
    Some(call.text(args[off]))
  } else {
    None
  }
  let rest = if args.length() > off + 1 {
    args[off + 1:].to_owned()
  } else {
    []
  }
  let out = []
  for item in items {
    let probe = transform(item)
    let verdict = match check {
      Some(name) => call.check(name, probe, rest)
      None => call.truthy(probe)
    }
    if verdict == keep {
      out.push(item)
    }
  }
  Seq(out)
}

///|
/// What `groupby` gives: a group's key and its items, readable as a tuple
/// or by the names `grouper` and `list`.
priv struct Group {
  grouper : @spec.Value
  items : Array[@spec.Value]
}

///|
impl @spec.Object for Group with fn kind(_) {
  "a group"
}

///|
impl @spec.Object for Group with fn attr(self, name) {
  match name {
    "grouper" => Some(self.grouper)
    "list" => Some(Seq(self.items))
    _ => None
  }
}

///|
impl @spec.Object for Group with fn items(self) {
  Some([self.grouper, Seq(self.items)])
}

///|
impl @spec.Object for Group with fn show(self) {
  @spec.Value::Tuple([self.grouper, Seq(self.items)]).repr()
}

///|
fn filter_groupby(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind(
    "groupby",
    ["attribute", "default", "case_sensitive"],
    args,
    named,
  )
  let attribute = b.need("attribute")
  let case_sensitive = b.flag("case_sensitive", false)
  let default = match b.get("default") {
    Some(Null) | None => None
    some => some
  }
  let key = attrgetter(attribute, lowercase=!case_sensitive, default?)
  let real = attrgetter(attribute, default?)
  let ordered = sorted(list_of(call, value), item => key(item), false)
  let out = []
  let mut i = 0
  while i < ordered.length() {
    let k = key(ordered[i])
    let group = [ordered[i]]
    i += 1
    while i < ordered.length() && key(ordered[i]) == k {
      group.push(ordered[i])
      i += 1
    }
    let grouper = if case_sensitive { k } else { real(group[0]) }
    out.push(@spec.Value::Object(Group::{ grouper, items: group, }))
  }
  Seq(out)
}

///|
fn filter_attr(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("attr", ["name"], args, named)
  let name = call.text(b.need("name"))
  match value {
    Object(obj) =>
      match obj.attr(name) {
        Some(v) => v
        None => Undefined(name)
      }
    _ =>
      match attr(value, name) {
        Some(m) => m
        None => Undefined(name)
      }
  }
}

///|
fn filter_default(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("default", ["default_value", "boolean"], args, named)
  let fallback = b.get("default_value").unwrap_or(Text(""))
  if value is Undefined(_) || (b.flag("boolean", false) && !value.truthy()) {
    fallback
  } else {
    ignore(call)
    value
  }
}
