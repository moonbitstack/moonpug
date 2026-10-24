// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// A value in flight while a template renders.
///
/// The context arrives as `Json` and leaves as text; everything between —
/// arithmetic, macros, cyclers — lives here. `Markup` is text already escaped
/// or authored by hand: output writes it as it stands, and that is the whole of
/// the `|safe` story. `Absent` is a name that did not resolve; the undefined
/// policy decides what happens next.
pub(all) enum Value {
  Null
  Bool(Bool)
  Int(Int64)
  Double(Double)
  Text(String)
  Markup(String)
  Seq(Array[Value])
  Dict(Map[String, Value])
  Absent(String)
  Native(String, (Array[Value]) -> Value raise Fault)
  NativeKw(String, (Array[Value], Map[String, Value]) -> Value raise Fault)
  GlobalV(&Global)
  CyclerV(CyclerState)
  JoinerV(JoinerState)
  Namespaced(Map[String, Value])
  MacroV(Macro)
}

///|
pub(all) struct CyclerState {
  items : Array[Value]
  mut at : Int32
}

///|
pub(all) struct JoinerState {
  sep : String
  mut used : Bool
}

///|
/// A value read in from the caller's `Json`.
///
/// A number written whole is an `Int` and one written with a fraction or
/// exponent is a `Double`; when the caller's parser kept no spelling, a whole
/// value stands in for the integer it so plainly is.
fn to_value(json : Json) -> Value {
  match json {
    Null => Null
    True => Bool(true)
    False => Bool(false)
    Number(d, repr~) => {
      let written_whole = match repr {
        Some(spelling) =>
          !spelling.contains(".") &&
          !spelling.contains("e") &&
          !spelling.contains("E")
        None => d == @double.floor(d) && d.abs() <= 9007199254740992.0
      }
      if written_whole && d.abs() <= 9223372036854775807.0 {
        Int(d.to_int64())
      } else {
        Double(d)
      }
    }
    String(s) => Text(s)
    Array(items) => {
      let out = []
      for item in items {
        out.push(to_value(item))
      }
      Seq(out)
    }
    Object(fields) => {
      let out : Map[String, Value] = Map([])
      for name, item in fields {
        out.set(name, to_value(item))
      }
      Dict(out)
    }
  }
}

///|
/// A value handed back out to the caller as `Json`. Machinery values cross
/// this seam as the text they print, since a macro cannot survive a boundary
/// the other side of which there is nothing to call it.
fn to_json(value : Value) -> Json {
  match value {
    Null | Absent(_) => null_json()
    Bool(b) => Json::boolean(b)
    Int(n) => number_json(n.to_string())
    Double(d) => number_json(show_double(d))
    Text(s) | Markup(s) => Json::Json(s)
    Seq(items) => {
      let out = []
      for item in items {
        out.push(to_json(item))
      }
      Json::array(out)
    }
    Dict(fields) => {
      let out : Map[String, Json] = Map([])
      for name, field in fields {
        out.set(name, to_json(field))
      }
      Json::Json(out)
    }
    _ => Json::Json(show_value(value))
  }
}

///|
/// What a condition sees. Everything empty or zero is false, as in Python.
fn truthy(value : Value) -> Bool {
  match value {
    Null | Absent(_) => false
    Bool(b) => b
    Int(n) => n != 0L
    Double(d) => d != 0.0
    Text(s) | Markup(s) => !s.is_empty()
    Seq(items) => !items.is_empty()
    Dict(fields) => !fields.is_empty()
    _ => true
  }
}

///|
/// Structural equality. Numbers compare across `Int` and `Double`, text
/// compares across escaped and trusted, and two names that did not resolve are
/// equal the way two undefineds are in Jinja.
fn same_value(left : Value, right : Value) -> Bool {
  match (left, right) {
    (Null, Null) | (Absent(_), Absent(_)) => true
    (Bool(a), Bool(b)) => a == b
    (Int(a), Int(b)) => a == b
    (Double(a), Double(b)) => a == b
    (Int(a), Double(b)) | (Double(b), Int(a)) => a.to_double() == b
    (Text(a), Text(b))
    | (Markup(a), Markup(b))
    | (Text(a), Markup(b))
    | (Markup(a), Text(b)) => a == b
    (Seq(a), Seq(b)) =>
      a.length() == b.length() &&
      ({
        let mut same = true
        for i = 0; i < a.length(); i = i + 1 {
          if !same_value(a[i], b[i]) {
            same = false
            break
          }
        }
        same
      })
    (Dict(a), Dict(b)) =>
      a.length() == b.length() &&
      ({
        let mut same = true
        for name, field in a {
          match b.get(name) {
            Some(other) =>
              if !same_value(field, other) {
                same = false
                break
              }
            None => {
              same = false
              break
            }
          }
        }
        same
      })
    _ => false
  }
}

///|
/// Ordering: numbers, text and sequences, the three Python can order. Anything
/// else is refused rather than guessed at.
fn compare_value(left : Value, right : Value) -> Int32 raise Fault {
  match (left, right) {
    (Int(a), Int(b)) => compare_int64(a, b)
    (Double(a), Double(b)) => if a < b { -1 } else if a > b { 1 } else { 0 }
    (Int(a), Double(b)) => compare_int64_double(a, b)
    (Double(a), Int(b)) => -compare_int64_double(b, a)
    (Bool(a), Bool(b)) => {
      let ai = if a { 1 } else { 0 }
      let bi = if b { 1 } else { 0 }
      ai - bi
    }
    (Text(a), Text(b))
    | (Markup(a), Markup(b))
    | (Text(a), Markup(b))
    | (Markup(a), Text(b)) => if a < b { -1 } else if a > b { 1 } else { 0 }
    (Seq(a), Seq(b)) => {
      let n = if a.length() < b.length() { a.length() } else { b.length() }
      for i = 0; i < n; i = i + 1 {
        let step = compare_value(a[i], b[i])
        if step != 0 {
          return step
        }
      }
      a.length() - b.length()
    }
    _ =>
      raise Wrong(because="cannot order \{kind_of(left)} and \{kind_of(right)}")
  }
}

///|
fn compare_int64(a : Int64, b : Int64) -> Int32 {
  if a < b {
    -1
  } else if a > b {
    1
  } else {
    0
  }
}

///|
fn compare_int64_double(a : Int64, b : Double) -> Int32 {
  let d = a.to_double()
  if d < b {
    -1
  } else if d > b {
    1
  } else {
    0
  }
}

///|
/// The names error messages use, one per kind of value.
fn kind_of(value : Value) -> String {
  match value {
    Null => "none"
    Absent(_) => "an undefined name"
    Bool(_) => "a boolean"
    Int(_) => "an integer"
    Double(_) => "a number"
    Text(_) => "text"
    Markup(_) => "markup"
    Seq(_) => "a list"
    Dict(_) => "a mapping"
    Native(name, _) | NativeKw(name, _) => "the function \{name}"
    GlobalV(_) => "a function"
    CyclerV(_) => "a cycler"
    JoinerV(_) => "a joiner"
    Namespaced(_) => "a namespace"
    MacroV(_) => "a macro"
  }
}

///|
/// A double the way Python prints it: `3.0`, not `3`, and `NaN` and `inf`
/// spelled as Jinja's host would spell them.
fn show_double(d : Double) -> String {
  if d.is_nan() {
    return "nan"
  }
  if d == @double.infinity || d == -@double.infinity {
    return if d > 0.0 { "inf" } else { "-inf" }
  }
  let text = d.to_string()
  if text.contains(".") || text.contains("e") || text.contains("E") {
    text
  } else {
    text + ".0"
  }
}

///|
/// What `{{ x }}` writes before escaping gets a look: the way Jinja's `str`
/// prints a value, lists and mappings included.
fn show_value(value : Value) -> String {
  match value {
    Null => "None"
    Absent(_) => ""
    Bool(b) => if b { "True" } else { "False" }
    Int(n) => n.to_string()
    Double(d) => show_double(d)
    Text(s) | Markup(s) => s
    Seq(items) => "[" + repr_join(items) + "]"
    Dict(fields) => {
      let parts = []
      for name in sorted_keys(fields) {
        parts.push(
          "'\{name}': " + repr_value(fields.get_or_default(name, Null)),
        )
      }
      "{" + join_texts(parts, ", ") + "}"
    }
    Native(name, _) | NativeKw(name, _) => "<function \{name}>"
    GlobalV(_) => "<function>"
    CyclerV(_) => "<cycler>"
    JoinerV(_) => "<joiner>"
    Namespaced(_) => "<namespace>"
    MacroV(def) => "<macro \{def.name}>"
  }
}

///|
/// The way a value sits inside a list or mapping: Python's `repr`, so text
/// carries quotes and escapes them.
fn repr_value(value : Value) -> String {
  match value {
    Text(s) | Markup(s) => repr_text(s)
    Seq(items) => "[" + repr_join(items) + "]"
    Dict(fields) => {
      let parts = []
      for name in sorted_keys(fields) {
        parts.push(
          "'\{name}': " + repr_value(fields.get_or_default(name, Null)),
        )
      }
      "{" + join_texts(parts, ", ") + "}"
    }
    _ => show_value(value)
  }
}

///|
fn repr_join(items : Array[Value]) -> String {
  let parts = []
  for item in items {
    parts.push(repr_value(item))
  }
  join_texts(parts, ", ")
}

///|
fn repr_text(s : String) -> String {
  "'" +
  s.replace_all(old="\\", new="\\\\").replace_all(old="'", new="\\'") +
  "'"
}

///|
/// Object fields in a stable order: a hash map's whims must not reach the
/// output, so everything that iterates a mapping sorts first.
fn sorted_keys(fields : Map[String, Value]) -> Array[String] {
  let names = []
  for name, _ in fields {
    names.push(name)
  }
  names.sort()
  names
}

///|
/// Membership as `in` sees it: a substring, a member, a key.
fn contains_value(haystack : Value, needle : Value) -> Bool raise Fault {
  match haystack {
    Absent(name) => raise Undefined(name~)
    Text(s) | Markup(s) => {
      let part = show_value(needle)
      s.contains(part)
    }
    Seq(items) => {
      for item in items {
        if same_value(item, needle) {
          return true
        }
      }
      false
    }
    Dict(fields) => {
      let key = show_value(needle)
      fields.contains(key)
    }
    _ => raise Wrong(because="\{kind_of(haystack)} holds nothing to be in")
  }
}

///|
/// Core has no join of its own; every filter that glues texts goes through
/// this one.
fn join_texts(parts : Array[String], sep : String) -> String {
  let out = StringBuilder()
  for i = 0; i < parts.length(); i = i + 1 {
    if i > 0 {
      out.write_string(sep)
    }
    out.write_string(parts[i])
  }
  out.to_string()
}

///|
/// Core sorts with a plain comparator; ours can refuse, and a comparison that
/// will not happen simply does not order.
fn[T] cmp_or_equal(
  left : T,
  right : T,
  of : (T, T) -> Int32 raise Fault,
) -> Int32 {
  of(left, right) catch {
    _ => 0
  }
}

///|
fn[T] reverse_in_place(items : Array[T]) -> Array[T] {
  let out = []
  for i = items.length() - 1; i >= 0; i = i - 1 {
    out.push(items[i])
  }
  out
}

///|
/// A word character as `title` and `wordcount` see it: anything that is not
/// space or punctuation-shaped.
fn is_word_char(ch : Char) -> Bool {
  if ch.is_ascii() {
    return ch.is_ascii_alphabetic() || ch.is_ascii_digit()
  }
  !ch.is_whitespace() && !ch.is_control()
}

///|
fn char_upper(ch : Char) -> Char {
  if ch.is_ascii() {
    return ch.to_ascii_uppercase()
  }
  let raised = ch.to_string().to_upper()
  match raised.get_char(0) {
    Some(first) => first
    None => ch
  }
}

///|
fn char_lower(ch : Char) -> Char {
  if ch.is_ascii() {
    return ch.to_ascii_lowercase()
  }
  let lowered = ch.to_string().to_lower()
  match lowered.get_char(0) {
    Some(first) => first
    None => ch
  }
}

///|
fn[T] rev_in_place(items : Array[T]) -> Unit {
  let n = items.length()
  for i = 0; i < n / 2; i = i + 1 {
    let mirror = n - 1 - i
    let left = items[i]
    items[i] = items[mirror]
    items[mirror] = left
  }
}

///|
/// Core's `Json` is read-only outside its own package, so a number with its
/// spelling rides through the parser — the one place a repr survives.
fn number_json(spelling : String) -> Json {
  @json.parse(spelling) catch {
    _ => null_json()
  }
}

///|
fn null_json() -> Json {
  @json.parse("null") catch {
    _ => Json::boolean(false)
  }
}

///|
/// A code unit as a character, with a stand-in for the lone surrogates.
fn u16_char(unit : UInt16) -> Char {
  match unit.to_char() {
    Some(c) => c
    None => '?'
  }
}

///|
/// A macro as a value: the read-side of a definition. Templates call it;
/// callers pass it around and read its name and arguments.
pub(all) struct Macro {
  name : String
  params : Array[String]
  rest : String?
  body : Array[Node]
  defaults : Array[(Int32, Expr)]
  mut home : Map[String, Value]
}

///|
/// The read-side a caller sees: a macro's name, its parameters, and whether
/// it takes a rest parameter. The body stays the engine's.
pub fn Macro::of_name_params(def : Macro) -> (String, Array[String], String?) {
  (def.name, def.params, def.rest)
}
