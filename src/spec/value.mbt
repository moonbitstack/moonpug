///|
/// A value in a template. The context arrives as data; functions and host
/// objects enter as `Object`. `Markup` is text already safe to write as it
/// stands. `Undefined` is a name that resolved to nothing, carrying the name
/// for the message a later use may need.
pub(all) enum Value {
  Null
  Bool(Bool)
  Int(Int64)
  Double(Double)
  Text(String)
  Markup(String)
  Seq(Array[Value])
  Tuple(Array[Value])
  Dict(Map[String, Value])
  Undefined(String)
  Object(&Object)
}

///|
pub extend Value with Show::{output, to_string}

///|
pub extend Value with Eq::{equal, not_equal}

///|
pub extend Value with ToJson::{to_json}

///|
/// Data read from JSON. A number written without a fraction or exponent is
/// an `Int` when it fits, as Python reads it.
pub fn Value::of_json(json : Json) -> Value {
  match json {
    Null => Null
    True => Bool(true)
    False => Bool(false)
    Number(d, repr~) => {
      let whole = match repr {
        Some(written) =>
          !written.contains(".") &&
          !written.contains("e") &&
          !written.contains("E")
        None => d == d.floor()
      }
      if whole && d.abs() < 9.2e18 {
        Int(d.to_int64())
      } else {
        Double(d)
      }
    }
    String(s) => Text(s)
    Array(items) => Seq(items.map(Value::of_json))
    Object(fields) => {
      let out = Map([])
      for name, item in fields {
        out[name] = Value::of_json(item)
      }
      Dict(out)
    }
  }
}

///|
/// Objects cross as the text they print: nothing on the other side could
/// call them.
pub impl ToJson for Value with fn to_json(self) {
  match self {
    Null | Undefined(_) => Json::null()
    Bool(b) => Json::boolean(b)
    Int(n) => Json::number(n.to_double(), repr=n.to_string())
    Double(d) => Json::number(d)
    Text(s) | Markup(s) => Json::string(s)
    Seq(items) | Tuple(items) => Json::array(items.map(item => Json(item)))
    Dict(fields) => {
      let out = Map([])
      for name, field in fields {
        out[name] = Json(field)
      }
      Json::object(out)
    }
    Object(_) => Json::string(self.to_string())
  }
}

///|
/// The way `{{ value }}` prints before escaping: Python's `str`.
pub impl Show for Value with fn output(self, logger) {
  match self {
    Text(s) | Markup(s) => logger.write_string(s)
    Undefined(_) => ()
    Object(obj) => logger.write_string(obj.show())
    _ => logger.write_string(self.repr())
  }
}

///|
/// Python's `repr`: text quoted, lists and mappings with their elements in
/// `repr` form. `pprint` and the printing of containers use it.
pub fn Value::repr(self : Value) -> String {
  match self {
    Null => "None"
    Bool(b) => if b { "True" } else { "False" }
    Int(n) => n.to_string()
    Double(d) => python_float(d)
    Text(s) => repr_text(s)
    Markup(s) => "Markup(\{repr_text(s)})"
    Seq(items) => "[" + items.map(Value::repr).join(", ") + "]"
    Tuple([one]) => "(" + one.repr() + ",)"
    Tuple(items) => "(" + items.map(Value::repr).join(", ") + ")"
    Dict(fields) => {
      let parts = []
      for name, field in fields {
        parts.push(repr_text(name) + ": " + field.repr())
      }
      "{" + parts.join(", ") + "}"
    }
    Undefined(_) => "Undefined"
    Object(obj) => obj.show()
  }
}

///|
/// What a condition sees: empty, zero, `None` and undefined are false.
pub fn Value::truthy(self : Value) -> Bool {
  match self {
    Null | Undefined(_) => false
    Bool(b) => b
    Int(n) => n != 0
    Double(d) => d != 0.0
    Text(s) | Markup(s) => !s.is_empty()
    Seq(items) | Tuple(items) => !items.is_empty()
    Dict(fields) => !fields.is_empty()
    Object(_) => true
  }
}

///|
/// Python's equality: numbers across `Int`, `Double` and `Bool`, text across
/// plain and safe, containers element by element, objects by identity.
pub impl Eq for Value with fn equal(self, other) {
  match (self, other) {
    (Null, Null) | (Undefined(_), Undefined(_)) => true
    (Text(a) | Markup(a), Text(b) | Markup(b)) => a == b
    (Seq(a), Seq(b)) | (Tuple(a), Tuple(b)) => a == b
    (Dict(a), Dict(b)) =>
      a.length() == b.length() &&
      a.iter().all(pair => b.get(pair.0) is Some(v) && v == pair.1)
    (Object(a), Object(b)) => physical_equal(a, b)
    _ =>
      match (self.number(), other.number()) {
        (Some(a), Some(b)) => a == b
        _ => false
      }
  }
}

///|
/// A number as Python sees one: `Bool` counts, being an `int`.
pub fn Value::number(self : Value) -> Double? {
  match self {
    Bool(b) => Some(if b { 1.0 } else { 0.0 })
    Int(n) => Some(n.to_double())
    Double(d) => Some(d)
    _ => None
  }
}

///|
/// Python's ordering: numbers with numbers, text with text, sequences
/// element by element. Anything else has no order and is refused.
pub fn Value::compare(self : Value, other : Value) -> Int32 raise Refused {
  match (self, other) {
    (Int(a), Int(b)) => a.compare(b)
    (Text(a) | Markup(a), Text(b) | Markup(b)) => code_point_compare(a, b)
    (Seq(a), Seq(b)) | (Tuple(a), Tuple(b)) => {
      for i in 0..<a.length().min(b.length()) {
        let step = a[i].compare(b[i])
        if step != 0 {
          return step
        }
      }
      a.length().compare(b.length())
    }
    _ =>
      match (self.number(), other.number()) {
        (Some(a), Some(b)) => a.compare(b)
        _ =>
          raise invalid("\{self.kind()} and \{other.kind()} cannot be compared")
      }
  }
}

///|
/// Strings ordered by code point, as Python orders them.
pub fn code_point_compare(a : String, b : String) -> Int32 {
  let x = a.iter()
  let y = b.iter()
  for ;; {
    match (x.next(), y.next()) {
      (Some(p), Some(q)) => if p != q { return p.compare(q) }
      (None, None) => return 0
      (None, _) => return -1
      (_, None) => return 1
    }
  }
}

///|
/// The word a message uses for a value's type.
pub fn Value::kind(self : Value) -> String {
  match self {
    Null => "none"
    Bool(_) => "a boolean"
    Int(_) => "an integer"
    Double(_) => "a float"
    Text(_) => "a string"
    Markup(_) => "markup"
    Seq(_) => "a list"
    Tuple(_) => "a tuple"
    Dict(_) => "a mapping"
    Undefined("") => "an undefined value"
    Undefined(name) => "\{name}, which is undefined,"
    Object(obj) => obj.kind()
  }
}

///|
/// The items a loop walks: a list's elements, a mapping's keys in insertion
/// order, a string's characters, or what an object yields.
pub fn Value::iter(self : Value) -> Array[Value] raise Refused {
  match self {
    Seq(items) | Tuple(items) => items.copy()
    Dict(fields) => fields.keys().map(name => Value::Text(name)).collect()
    Text(s) | Markup(s) =>
      s.iter().map(ch => Value::Text(ch.to_string())).collect()
    Object(obj) =>
      match obj.items() {
        Some(items) => items
        None => raise invalid("\{obj.kind()} cannot be iterated")
      }
    _ => raise invalid("\{self.kind()} cannot be iterated")
  }
}

///|
/// `value[key]`: a mapping by key, a list or string by index (negative
/// counts from the end), an object by attribute. `None` when there is
/// nothing there.
pub fn Value::item(self : Value, key : Value) -> Value? {
  match (self, key) {
    (Dict(fields), _) => fields.get(key.to_string())
    (Seq(items) | Tuple(items), _) =>
      match key.index() {
        Some(i) => {
          let at = if i < 0 { i + items.length() } else { i }
          if at >= 0 && at < items.length() {
            Some(items[at])
          } else {
            None
          }
        }
        None => None
      }
    (Text(s) | Markup(s), _) =>
      match key.index() {
        Some(i) => {
          let chars = s.iter().collect()
          let at = if i < 0 { i + chars.length() } else { i }
          if at >= 0 && at < chars.length() {
            Some(Text(chars[at].to_string()))
          } else {
            None
          }
        }
        None => None
      }
    (Object(obj), Text(name)) => obj.attr(name)
    (Object(obj), _) =>
      match (obj.items(), key.index()) {
        (Some(items), Some(i)) => Tuple(items).item(Int(i.to_int64()))
        _ => None
      }
    _ => None
  }
}

///|
/// `value.name`: an object's attribute, else the item of that name.
pub fn Value::field(self : Value, name : String) -> Value? {
  match self {
    Object(obj) => obj.attr(name)
    _ => self.item(Text(name))
  }
}

///|
/// A dotted path such as `user.address.0`, each step a lookup by item; a
/// step written in digits indexes a list.
pub fn Value::path(self : Value, path : String) -> Value? {
  let mut at = self
  for part in path.split(".") {
    let key : Value = Int(@string.parse_int64(part)) catch {
      _ => Text(part.to_owned())
    }
    match at.item(key) {
      Some(next) => at = next
      None => return None
    }
  }
  Some(at)
}

///|
/// A whole number usable as an index.
pub fn Value::index(self : Value) -> Int32? {
  match self {
    Int(n) if n >= -2147483648 && n <= 2147483647 => Some(n.to_int())
    Bool(b) => Some(if b { 1 } else { 0 })
    _ => None
  }
}

///|
/// A float the way Python writes it: the shortest digits that read back the
/// same, fixed between `1e-4` and `1e16`, scientific outside.
pub fn python_float(d : Double) -> String {
  if d.is_nan() {
    return "nan"
  }
  if d.is_inf() {
    return if d > 0.0 { "inf" } else { "-inf" }
  }
  let sign = if d < 0.0 || (d == 0.0 && 1.0 / d < 0.0) { "-" } else { "" }
  let (digits, exponent) = shortest_digits(d.abs())
  let body = if exponent >= -4 && exponent < 16 {
    if exponent >= 0 {
      let whole = exponent + 1
      if digits.length() <= whole {
        digits + "0".repeat(whole - digits.length()) + ".0"
      } else {
        digits[:whole].to_owned() + "." + digits[whole:].to_owned()
      }
    } else {
      "0." + "0".repeat(-exponent - 1) + digits
    }
  } else {
    let mantissa = if digits.length() == 1 {
      digits
    } else {
      digits[:1].to_owned() + "." + digits[1:].to_owned()
    }
    let sign_e = if exponent < 0 { "-" } else { "+" }
    let e = exponent.abs()
    mantissa + "e" + sign_e + (if e < 10 { "0" } else { "" }) + e.to_string()
  }
  sign + body
}

///|
/// The shortest decimal digits of a non-negative finite double and the
/// exponent of the first digit, read off `Double::to_string`, which already
/// prints the shortest round trip.
fn shortest_digits(d : Double) -> (String, Int32) {
  if d == 0.0 {
    return ("0", 0)
  }
  let text = d.to_string()
  let (mantissa, shift) = match text.find("e") {
    Some(at) => {
      let e = @string.parse_int(text[at + 1:]) catch { _ => 0 }
      (text[:at].to_owned(), e)
    }
    None => (text, 0)
  }
  let (whole, fraction) = match mantissa.find(".") {
    Some(at) => (mantissa[:at].to_owned(), mantissa[at + 1:].to_owned())
    None => (mantissa, "")
  }
  let all = whole + fraction
  let mut lead = 0
  while lead < all.length() - 1 && all[lead] == '0' {
    lead += 1
  }
  let mut tail = all.length()
  while tail > lead + 1 && all[tail - 1] == '0' {
    tail -= 1
  }
  let digits = all[lead:tail].to_owned()
  (digits, whole.length() - 1 - lead + shift)
}

///|
/// Python's `repr` of a string: single quotes unless the text holds one and
/// no double quote, with the escapes Python writes.
pub fn repr_text(s : String) -> String {
  let quote = if s.contains("'") && !s.contains("\"") { '"' } else { '\'' }
  let out = StringBuilder()
  out.write_char(quote)
  for ch in s {
    match ch {
      '\\' => out.write_string("\\\\")
      '\n' => out.write_string("\\n")
      '\r' => out.write_string("\\r")
      '\t' => out.write_string("\\t")
      c if c == quote => {
        out.write_char('\\')
        out.write_char(c)
      }
      c if c.to_int() < 0x20 || c.to_int() == 0x7F => {
        let hex = c.to_int().to_string(radix=16)
        out.write_string(
          "\\x" + (if hex.length() < 2 { "0" } else { "" }) + hex,
        )
      }
      c => out.write_char(c)
    }
  }
  out.write_char(quote)
  out.to_string()
}

///|
/// Python's `item in self`: a substring of a string, an element of a list
/// or tuple, a key of a mapping, what an object yields.
pub fn Value::contains(self : Value, item : Value) -> Bool raise Refused {
  match self {
    Text(s) | Markup(s) =>
      match item {
        Text(t) | Markup(t) => s.contains(t)
        _ =>
          raise invalid(
            "'in <string>' requires a string as left operand, not \{item.kind()}",
          )
      }
    Seq(items) | Tuple(items) => items.contains(item)
    Dict(fields) =>
      match item {
        Text(k) | Markup(k) => fields.contains(k)
        Int(_) | Double(_) | Bool(_) | Null => fields.contains(item.to_string())
        _ => false
      }
    Object(obj) =>
      match obj.items() {
        Some(items) => items.contains(item)
        None => raise invalid("\{obj.kind()} cannot be searched with in")
      }
    _ => raise invalid("\{self.kind()} cannot be searched with in")
  }
}
