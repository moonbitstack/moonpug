// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The globals Jinja ships, plus the gettext family wired to the translate
/// seam. Host knowledge — `url`, `static`, `now` — is not here: those the
/// caller registers, the way Flask registers `url_for`.
fn builtin_natives(
  translate : ((String, String?, Int32?) -> String?)?,
) -> Map[String, Callable] {
  let table : Map[String, Callable] = Map([])
  table.set("range", Simple(args => Value::Seq(range_values(args))))
  table.set(
    "joiner",
    Simple(fn(args) {
      let sep = if args.is_empty() { ", " } else { show_value(args[0]) }
      Value::JoinerV({ sep, used: false, })
    }),
  )
  table.set(
    "cycler",
    Simple(fn(args) {
      if args.is_empty() {
        return Absent("cycler with nothing to cycle")
      }
      Value::CyclerV({ items: args.copy(), at: 0, })
    }),
  )
  // The gettext family: the seam when the caller fed one, identity otherwise.
  fn gettext(msgid : String) -> String {
    match translate {
      Some(seam) =>
        match seam(msgid, None, None) {
          Some(t) => t
          None => msgid
        }
      None => msgid
    }
  }
  fn choose_plural(singular : String, plural : String, n : Int32) -> String {
    match translate {
      Some(seam) =>
        match seam(singular, None, Some(n)) {
          Some(t) => t
          None => if n != 1 { plural } else { singular }
        }
      None => if n != 1 { plural } else { singular }
    }
  }
  fn count_of(args : Array[Value], at : Int32) -> Int32 {
    if at < args.length() {
      match args[at] {
        Int(n) => n.to_int()
        Double(d) => d.to_int()
        _ => 1
      }
    } else {
      1
    }
  }
  table.set(
    "_",
    Simple(fn(args) {
      if args.is_empty() {
        return Value::Text(gettext(""))
      }
      Value::Text(gettext(show_value(args[0])))
    }),
  )
  table.set(
    "gettext",
    Simple(fn(args) {
      if args.is_empty() {
        return Value::Text(gettext(""))
      }
      Value::Text(gettext(show_value(args[0])))
    }),
  )
  table.set(
    "ngettext",
    Simple(fn(args) {
      let singular = if 0 < args.length() { show_value(args[0]) } else { "" }
      let plural = if 1 < args.length() {
        show_value(args[1])
      } else {
        singular
      }
      Value::Text(choose_plural(singular, plural, count_of(args, 2)))
    }),
  )
  table.set(
    "pgettext",
    Simple(fn(args) {
      let context = if 0 < args.length() { show_value(args[0]) } else { "" }
      let msgid = if 1 < args.length() { show_value(args[1]) } else { "" }
      match translate {
        Some(seam) =>
          match seam(msgid, Some(context), None) {
            Some(t) => Value::Text(t)
            None => Value::Text(msgid)
          }
        None => Value::Text(msgid)
      }
    }),
  )
  table.set(
    "npgettext",
    Simple(fn(args) {
      let context = if 0 < args.length() { show_value(args[0]) } else { "" }
      let singular = if 1 < args.length() { show_value(args[1]) } else { "" }
      let plural = if 2 < args.length() {
        show_value(args[2])
      } else {
        singular
      }
      let n = count_of(args, 3)
      match translate {
        Some(seam) =>
          match seam(singular, Some(context), Some(n)) {
            Some(t) => Value::Text(t)
            None => Value::Text(if n != 1 { plural } else { singular })
          }
        None => Value::Text(if n != 1 { plural } else { singular })
      }
    }),
  )
  table
}

///|
/// The two natives that need named arguments — `dict(a=1)` and
/// `namespace(x=0)` — take the names with them; `lipsum` sits here because it
/// reads its shape the same way.
fn kw_natives() -> Map[
  String,
  (Array[Value], Map[String, Value]) -> Value raise Fault,
] {
  let table : Map[
    String,
    (Array[Value], Map[String, Value]) -> Value raise Fault,
  ] = Map([])
  table.set("dict", fn(_pos, kw) { Dict(kw.copy()) })
  table.set("namespace", fn(_pos, kw) { Value::Namespaced(kw.copy()) })
  table.set("lipsum", fn(pos, _kw) { Value::Text(lipsum_text(pos)) })
  table
}

///|
fn range_values(args : Array[Value]) -> Array[Value] raise Fault {
  let (start, stop, step) = match args.length() {
    1 => {
      let stop = as_index(args[0], "range")
      (0, stop, 1)
    }
    2 => {
      let start = as_index(args[0], "range")
      let stop = as_index(args[1], "range")
      (start, stop, 1)
    }
    3 => {
      let start = as_index(args[0], "range")
      let stop = as_index(args[1], "range")
      let step = as_index(args[2], "range")
      if step == 0 {
        raise Wrong(because="range cannot step by zero")
      }
      (start, stop, step)
    }
    _ => raise Wrong(because="range takes one to three numbers")
  }
  let out = []
  if step > 0 {
    let mut i = start
    while i < stop {
      out.push(Int(i.to_int64()))
      i = i + step
    }
  } else {
    let mut i = start
    while i > stop {
      out.push(Int(i.to_int64()))
      i = i + step
    }
  }
  out
}

///|
fn as_index(value : Value, who : String) -> Int32 raise Fault {
  match value {
    Int(n) => n.to_int()
    Double(d) => @double.trunc(d).to_int()
    _ => raise Wrong(because="\{who} wants numbers")
  }
}

///|
/// Lorem ipsum words in the traditional order. Deterministic: the same call
/// gives the same text, because a template that renders twice must give the
/// same page twice.
fn lipsum_text(args : Array[Value]) -> String {
  let words : Array[StringView] = "lorem ipsum dolor sit amet consectetur adipiscing elit sed do eiusmod tempor incididunt ut labore et dolore magna aliqua enim ad minim veniam quis nostrud exercitation ullamco laboris nisi aliquip ex ea commodo consequat duis aute irure in reprehenderit voluptate velit esse cillum eu fugiat nulla pariatur excepteur sint occaecat cupidatat non proident sunt culpa qui officia deserunt mollit anim id est laborum"
    .split(" ")
    .to_array()
  let paragraphs = if 0 < args.length() {
    match args[0] {
      Int(n) => n.to_int()
      _ => 5
    }
  } else {
    5
  }
  let mut state = 191821L
  fn next_word() -> String {
    state = (state * 6364136223846793005L + 1442695040888963407L) % 4294967296L
    let picked = (state.reinterpret_as_uint64() % words.length().to_uint64()).to_int()
    words[picked].to_owned()
  }
  let out = []
  for p = 0; p < paragraphs; p = p + 1 {
    let sentences = []
    for s = 0; s < 4; s = s + 1 {
      let parts = []
      for w = 0; w < 12; w = w + 1 {
        parts.push(next_word())
      }
      let sentence = join_texts(parts, " ")
      sentences.push(head_upper(sentence) + ".")
    }
    let joined = join_texts(sentences, " ")
    let head = joined[0:1].to_owned()
    out.push(head.to_upper() + joined[1:joined.length()].to_owned())
  }
  join_texts(out, "\n\n")
}

///|
/// A cycler's methods: `next()`, `reset()`, `current`.
fn cycler_method(state : CyclerState, verb : String) -> Value {
  Native(verb, _args => {
    match verb {
      "next" => {
        let picked = state.items[state.at % state.items.length()]
        state.at = state.at + 1
        picked
      }
      "reset" => {
        state.at = 0
        Null
      }
      "current" => state.items[state.at % state.items.length()]
      _ => Absent(verb)
    }
  })
}
