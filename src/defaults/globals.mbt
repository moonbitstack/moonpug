///|
/// The functions every template sees: `range`, `dict`, `lipsum`, `cycler`,
/// `joiner`, `namespace`, and the gettext family over the translation seam.
pub fn globals() -> Map[String, @spec.Value] {
  Map([
    ("range", @spec.Value::func("range", global_range)),
    ("dict", @spec.Value::func("dict", global_dict)),
    ("lipsum", @spec.Value::func("lipsum", global_lipsum)),
    ("cycler", @spec.Value::func("cycler", global_cycler)),
    ("joiner", @spec.Value::func("joiner", global_joiner)),
    ("namespace", @spec.Value::func("namespace", global_namespace)),
    ("gettext", @spec.Value::func("gettext", global_gettext)),
    ("_", @spec.Value::func("_", global_gettext)),
    ("ngettext", @spec.Value::func("ngettext", global_ngettext)),
    ("pgettext", @spec.Value::func("pgettext", global_pgettext)),
    ("npgettext", @spec.Value::func("npgettext", global_npgettext)),
  ])
}

///|
fn whole(value : @spec.Value, who : String) -> Int64 raise @spec.Refused {
  match value {
    Int(n) => n
    Bool(b) => if b { 1 } else { 0 }
    _ => raise @spec.invalid("\{who} wants integers, not \{value.kind()}")
  }
}

///|
/// Python's `range`, refused past the render's bound.
fn global_range(
  call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  if !named.is_empty() {
    raise @spec.invalid("range takes no named arguments")
  }
  let (start, stop, step) = match args {
    [stop] => (0L, whole(stop, "range"), 1L)
    [a, b] => (whole(a, "range"), whole(b, "range"), 1L)
    [a, b, c] => (whole(a, "range"), whole(b, "range"), whole(c, "range"))
    _ =>
      raise @spec.invalid(
        "range expected 1 to 3 arguments, got \{args.length()}",
      )
  }
  if step == 0 {
    raise @spec.invalid("range arg 3 must not be zero")
  }
  let count = if step > 0 {
    if stop > start {
      (stop - start + step - 1) / step
    } else {
      0L
    }
  } else if start > stop {
    (start - stop - step - 1) / -step
  } else {
    0L
  }
  if count > call.range.to_int64() {
    raise Exceeded(template="", line=0, limit=call.range, got=count.to_int())
  }
  let out = []
  let mut v = start
  for _ in 0L..<count {
    out.push(@spec.Value::Int(v))
    v += step
  }
  Seq(out)
}

///|
/// Python's `dict(mapping, **pairs)`.
fn global_dict(
  _call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let out = Map([])
  match args {
    [] => ()
    [Dict(fields)] =>
      for k, v in fields {
        out[k] = v
      }
    [Seq(items) | Tuple(items)] =>
      for item in items {
        match item {
          Seq([k, v]) | Tuple([k, v]) => out[k.to_string()] = v
          _ => raise @spec.invalid("dict wants pairs")
        }
      }
    _ => raise @spec.invalid("dict expected at most 1 positional argument")
  }
  for k, v in named {
    out[k] = v
  }
  Dict(out)
}

///|
let lorem_words : String = "a ac accumsan ad adipiscing aenean aliquam aliquet amet ante aptent arcu at auctor augue bibendum blandit class commodo condimentum congue consectetuer consequat conubia convallis cras cubilia cum curabitur curae cursus dapibus diam dictum dictumst dignissim dis dolor donec dui duis egestas eget eleifend elementum elit enim erat eros est et etiam eu euismod facilisi facilisis fames faucibus felis fermentum feugiat fringilla fusce gravida habitant habitasse hac hendrerit hymenaeos iaculis id imperdiet in inceptos integer interdum ipsum justo lacinia lacus laoreet lectus leo libero ligula litora lobortis lorem luctus maecenas magna magnis malesuada massa mattis mauris metus mi molestie mollis montes morbi mus nam nascetur natoque nec neque netus nibh nisi nisl non nonummy nostra nulla nullam nunc odio orci ornare parturient pede pellentesque penatibus per pharetra phasellus placerat platea porta porttitor posuere potenti praesent pretium primis proin pulvinar purus quam quis quisque rhoncus ridiculus risus rutrum sagittis sapien scelerisque sed sem semper senectus sit sociis sociosqu sodales sollicitudin suscipit suspendisse taciti tellus tempor tempus tincidunt torquent tortor tristique turpis ullamcorper ultrices ultricies urna ut varius vehicula vel velit venenatis vestibulum vitae vivamus viverra volutpat vulputate"

///|
/// A seeded generator for `lipsum`, so a page renders the same way twice.
priv struct Draws {
  mut state : UInt64
}

///|
fn Draws::below(self : Draws, n : Int32) -> Int32 {
  self.state = self.state * 6364136223846793005UL + 1442695040888963407UL
  ((self.state >> 33) % n.to_uint64()).to_int()
}

///|
/// Jinja's `generate_lorem_ipsum`: `n` paragraphs of `min` to `max` words,
/// with commas and full stops at the intervals Jinja draws them.
fn global_lipsum(
  call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("lipsum", ["n", "html", "min", "max"], args, named)
  let n = b.int("n", 5)
  let html = b.flag("html", true)
  let lo = b.int("min", 20)
  let hi = b.int("max", 100)
  if hi <= lo {
    raise @spec.invalid("lipsum wants max greater than min")
  }
  let words = lorem_words.split(" ").map(w => w.to_owned()).collect()
  let draws = Draws::{ state: call.draw().to_uint64() * 0x9E3779B97F4A7C15UL, }
  let paragraphs = []
  for _ in 0..<n {
    let mut capital = true
    let mut last_comma = 0
    let mut last_stop = 0
    let mut last = ""
    let p = []
    for idx in 0..<(lo + draws.below(hi - lo)) {
      let mut word = ""
      for ;; {
        word = words[draws.below(words.length())]
        if word != last {
          last = word
          break
        }
      }
      if capital {
        word = py_capitalize(word)
        capital = false
      }
      if idx - (3 + draws.below(5)) > last_comma {
        last_comma = idx
        last_stop += 2
        word = word + ","
      }
      if idx - (10 + draws.below(10)) > last_stop {
        last_comma = idx
        last_stop = idx
        word = word + "."
        capital = true
      }
      p.push(word)
    }
    let mut text = p.join(" ")
    if text.has_suffix(",") {
      text = text[:text.length() - 1].to_owned() + "."
    } else if !text.has_suffix(".") {
      text = text + "."
    }
    paragraphs.push(text)
  }
  if html {
    Markup(paragraphs.map(t => "<p>" + @spec.escape(t) + "</p>").join("\n"))
  } else {
    Text(paragraphs.join("\n\n"))
  }
}

///|
priv struct Cycler {
  items : Array[@spec.Value]
  mut pos : Int32
}

///|
impl @spec.Object for Cycler with fn kind(_) {
  "a cycler"
}

///|
impl @spec.Object for Cycler with fn attr(self, name) {
  match name {
    "current" => Some(self.items[self.pos])
    "next" =>
      Some(
        @spec.Value::func("next", (_, _, _) => {
          let v = self.items[self.pos]
          self.pos = (self.pos + 1) % self.items.length()
          v
        }),
      )
    "reset" =>
      Some(
        @spec.Value::func("reset", (_, _, _) => {
          self.pos = 0
          Null
        }),
      )
    "items" => Some(Tuple(self.items))
    _ => None
  }
}

///|
fn global_cycler(
  _call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  if !named.is_empty() {
    raise @spec.invalid("cycler takes no named arguments")
  }
  if args.is_empty() {
    raise @spec.invalid("at least one item has to be provided")
  }
  Object(Cycler::{ items: args.copy(), pos: 0, })
}

///|
priv struct Joiner {
  sep : String
  mut used : Bool
}

///|
impl @spec.Object for Joiner with fn kind(_) {
  "a joiner"
}

///|
impl @spec.Object for Joiner with fn callable(_) {
  true
}

///|
impl @spec.Object for Joiner with fn call(self, _, _, _) {
  if self.used {
    Text(self.sep)
  } else {
    self.used = true
    Text("")
  }
}

///|
fn global_joiner(
  call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("joiner", ["sep"], args, named)
  Object(Joiner::{ sep: b.text(call, "sep", ", "), used: false, })
}

///|
/// Jinja's `namespace`: attributes a template may assign to from inside a
/// loop or a block.
priv struct Namespace {
  fields : Map[String, @spec.Value]
}

///|
impl @spec.Object for Namespace with fn kind(_) {
  "a namespace"
}

///|
impl @spec.Object for Namespace with fn attr(self, name) {
  self.fields.get(name)
}

///|
impl @spec.Object for Namespace with fn assign(self, name, value) {
  self.fields[name] = value
}

///|
impl @spec.Object for Namespace with fn show(self) {
  "<Namespace " + @spec.Value::Dict(self.fields).repr() + ">"
}

///|
fn global_namespace(
  call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let fields = match global_dict(call, args, named) {
    Dict(f) => f
    _ => Map([])
  }
  Object(Namespace::{ fields, })
}

///|
/// gettext's result as Jinja's new-style gettext gives it: the translation
/// is a format string filled from the named values, and trusted markup when
/// output is escaped, with the values escaped into it.
fn translated(
  call : @spec.Call,
  text : String,
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let s = percent(call, text, Dict(named), escape=call.autoescape)
  if call.autoescape {
    Markup(s)
  } else {
    Text(s)
  }
}

///|
fn global_gettext(
  call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  guard args is [msg] else { raise @spec.invalid("gettext takes one message") }
  let msgid = call.text(msg)
  translated(call, call.translate(msgid).unwrap_or(msgid), named)
}

///|
fn global_ngettext(
  call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  guard args is [one, many, num] else {
    raise @spec.invalid("ngettext takes a singular, a plural and a number")
  }
  let n = whole(num, "ngettext").to_int()
  let singular = call.text(one)
  let fallback = if n == 1 { singular } else { call.text(many) }
  let vars = named.copy()
  if !vars.contains("num") {
    vars["num"] = num
  }
  translated(call, call.translate(singular, count=n).unwrap_or(fallback), vars)
}

///|
fn global_pgettext(
  call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  guard args is [ctx, msg] else {
    raise @spec.invalid("pgettext takes a context and a message")
  }
  let msgid = call.text(msg)
  let vars = named.copy()
  if !vars.contains("context") {
    vars["context"] = ctx
  }
  translated(
    call,
    call.translate(msgid, context=call.text(ctx)).unwrap_or(msgid),
    vars,
  )
}

///|
fn global_npgettext(
  call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  guard args is [ctx, one, many, num] else {
    raise @spec.invalid(
      "npgettext takes a context, a singular, a plural and a number",
    )
  }
  let n = whole(num, "npgettext").to_int()
  let singular = call.text(one)
  let fallback = if n == 1 { singular } else { call.text(many) }
  let vars = named.copy()
  if !vars.contains("context") {
    vars["context"] = ctx
  }
  if !vars.contains("num") {
    vars["num"] = num
  }
  translated(
    call,
    call
    .translate(singular, context=call.text(ctx), count=n)
    .unwrap_or(fallback),
    vars,
  )
}
