// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A builtin global: dispatch by name through the engine's own table.
priv struct Builtin {
  name : String
}

///|
impl Global for Builtin with fn call(
  self : Builtin,
  ctx : Context,
  pos : Array[Value],
  kw : Map[String, Value],
) -> Value raise Fault {
  native_global(ctx, self.name, pos, kw)
}

///|
/// The globals Jinja ships, registered through the same trait a caller
/// uses. Host knowledge — `url`, `static`, `csrf_token`, `now` — is not
/// here: the caller registers those, the way Flask registers `url_for`.
fn builtin_globals() -> Map[String, &Global] {
  let table : Map[String, &Global] = Map([])
  for
    name in [
      "range", "joiner", "cycler", "_", "gettext", "ngettext", "pgettext", "npgettext",
      "dict", "namespace", "lipsum",
    ] {
    let entry : Builtin = { name, }
    table.set(name, entry)
  }
  table
}

///|
fn native_global(
  ctx : Context,
  name : String,
  pos : Array[Value],
  kw : Map[String, Value],
) -> Value raise Fault {
  match name {
    "dict" => Dict(kw.copy())
    "namespace" => Value::Namespaced(kw.copy())
    "lipsum" => Value::Text(lipsum_text(pos))
    "range" => Value::Seq(range_values(pos))
    "joiner" =>
      Value::JoinerV({
        sep: if pos.is_empty() {
          ", "
        } else {
          show_value(pos[0])
        },
        used: false,
      })
    "cycler" =>
      if pos.is_empty() {
        Absent("cycler with nothing to cycle")
      } else {
        Value::CyclerV({ items: pos.copy(), at: 0, })
      }
    "_" | "gettext" =>
      Value::Text(
        gettext_of(
          ctx.translate,
          if pos.is_empty() {
            ""
          } else {
            show_value(pos[0])
          },
        ),
      )
    "ngettext" => {
      let singular = if 0 < pos.length() { show_value(pos[0]) } else { "" }
      let plural = if 1 < pos.length() { show_value(pos[1]) } else { singular }
      Value::Text(plural_of(ctx.translate, singular, plural, count_of(pos, 2)))
    }
    "pgettext" => {
      let context = if 0 < pos.length() { show_value(pos[0]) } else { "" }
      let msgid = if 1 < pos.length() { show_value(pos[1]) } else { "" }
      Value::Text(contextual_of(ctx.translate, msgid, context, None))
    }
    "npgettext" => {
      let context = if 0 < pos.length() { show_value(pos[0]) } else { "" }
      let singular = if 1 < pos.length() { show_value(pos[1]) } else { "" }
      let _plural = if 2 < pos.length() { show_value(pos[2]) } else { singular }
      Value::Text(
        contextual_of(ctx.translate, singular, context, Some(count_of(pos, 3))),
      )
    }
    other => raise Unknown(name=other, kind="global")
  }
}

///|
fn gettext_of(
  translate : ((String, String?, Int32?) -> String?)?,
  msgid : String,
) -> String {
  match translate {
    Some(seam) =>
      match seam(msgid, None, None) {
        Some(t) => t
        None => msgid
      }
    None => msgid
  }
}

///|
fn plural_of(
  translate : ((String, String?, Int32?) -> String?)?,
  singular : String,
  plural : String,
  n : Int32,
) -> String {
  match translate {
    Some(seam) =>
      match seam(singular, None, Some(n)) {
        Some(t) => t
        None => if n != 1 { plural } else { singular }
      }
    None => if n != 1 { plural } else { singular }
  }
}

///|
/// The plural branch keeps the singular when the seam stays silent and the
/// count is one; the context never changes the fallback text.
fn contextual_of(
  translate : ((String, String?, Int32?) -> String?)?,
  msgid : String,
  context : String,
  count : Int32?,
) -> String {
  let n = match count {
    Some(v) => v
    None => 1
  }
  match translate {
    Some(seam) =>
      match seam(msgid, Some(context), count) {
        Some(t) => t
        None => if n != 1 && count is Some(_) { msgid } else { msgid }
      }
    None => msgid
  }
}

///|
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
    out.push(
      joined[0:1].to_owned().to_upper() + joined[1:joined.length()].to_owned(),
    )
  }
  join_texts(out, "\n\n")
}

///|
/// A cycler's methods: `next()`, `reset()`, `current`.
fn cycler_method(state : CyclerState, verb : String) -> Value {
  Native(verb, fn(_args) {
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
