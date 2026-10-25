///|
/// A host value a template can use. Each method is optional: an object
/// that only has attributes implements `attr`, a function only `call`.
/// Cyclers, macros, namespaces and the loop variable are objects too.
pub(open) trait Object {
  /// What messages call it: `"a cycler"`, `"the macro row"`.
  fn kind(Self) -> String
  /// `obj.name`; `None` when there is no such attribute.
  fn attr(Self, String) -> Value? = _
  /// `obj(args)`.
  fn call(Self, Call, Array[Value], Map[String, Value]) -> Value raise Refused = _
  /// Whether `call` does anything; the `callable` test asks this.
  fn callable(Self) -> Bool = _
  /// `{% set obj.name = value %}`.
  fn assign(Self, String, Value) -> Unit raise Refused = _
  /// What `{{ obj }}` prints.
  fn show(Self) -> String = _
  /// What a loop over it walks; `None` when it cannot be iterated.
  fn items(Self) -> Array[Value]? = _
}

///|
impl Object with fn attr(_, _) {
  None
}

///|
impl Object with fn call(self, _, _, _) {
  raise invalid("\{self.kind()} cannot be called")
}

///|
impl Object with fn callable(_) {
  false
}

///|
impl Object with fn assign(self, name, _) {
  raise invalid("\{self.kind()} does not take assignments to \{name}")
}

///|
impl Object with fn show(self) {
  "<\{self.kind()}>"
}

///|
impl Object with fn items(_) {
  None
}

///|
/// What a function receives: what the engine knows about the render in
/// flight, positional arguments, named arguments.
pub type Func = (Call, Array[Value], Map[String, Value]) -> Value raise Refused

///|
priv struct Function {
  name : String
  run : Func
}

///|
impl Object for Function with fn kind(self) {
  "the function \{self.name}"
}

///|
impl Object for Function with fn call(self, call, args, named) {
  (self.run)(call, args, named)
}

///|
impl Object for Function with fn callable(_) {
  true
}

///|
impl Object for Function with fn show(self) {
  "<function \{self.name}>"
}

///|
/// A function as a template value: `env.global("now", Value::func("now", …))`.
pub fn Value::func(name : String, run : Func) -> Value {
  Object(Function::{ name, run, })
}
