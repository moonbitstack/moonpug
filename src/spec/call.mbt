///|
/// A filter: the value left of `|`, the arguments in parentheses.
pub type Filter = (Call, Value, Array[Value], Map[String, Value]) -> Value raise Refused

///|
/// A test: the value left of `is`, the arguments after the name.
pub type Test = (Call, Value, Array[Value]) -> Bool raise Refused

///|
/// What happens when an undefined value is used, Jinja's three answers:
/// `Lenient` prints nothing and iterates as empty but refuses attribute
/// access; `Chainable` also lets attributes of it be undefined in turn;
/// `Strict` refuses every use except asking whether it is defined.
pub(all) enum Undefined {
  Lenient
  Chainable
  Strict
} derive(Eq)

///|
pub extend Undefined with Eq::{equal, not_equal}

///|
/// What an extension can reach of the render in flight: whether output is
/// being escaped, the undefined policy, the other filters and tests, the
/// translation seam, and the bound on `range`.
pub struct Call {
  /// Whether `{{ }}` escapes here; a filter that builds markup reads it.
  autoescape : Bool
  /// How an undefined value behaves when used.
  undefined : Undefined
  /// The largest sequence `range` may build.
  range : Int32
  priv filters : Map[String, Filter]
  priv tests : Map[String, Test]
  priv translate : ((String, String?, Int32?) -> String?)?
  priv draws : Ref[Int32]
}

///|
/// The engine builds one per render; a test of an extension builds its own.
pub fn Call::new(
  autoescape~ : Bool = true,
  undefined~ : Undefined = Strict,
  range~ : Int32 = 100000,
  filters~ : Map[String, Filter] = Map([]),
  tests~ : Map[String, Test] = Map([]),
  translate? : (String, String?, Int32?) -> String?,
) -> Call {
  { autoescape, undefined, range, filters, tests, translate, draws: Ref(0), }
}

///|
/// The same render with escaping turned on or off.
pub fn Call::escaping(self : Call, autoescape : Bool) -> Call {
  { ..self, autoescape, }
}

///|
/// Apply the filter registered under `name`.
pub fn Call::filter(
  self : Call,
  name : String,
  value : Value,
  args : Array[Value],
  named : Map[String, Value],
) -> Value raise Refused {
  match self.filters.get(name) {
    Some(run) => run(self, value, args, named)
    None => raise unknown("filter", name)
  }
}

///|
/// Apply the test registered under `name`; `test` itself is a keyword.
pub fn Call::check(
  self : Call,
  name : String,
  value : Value,
  args : Array[Value],
) -> Bool raise Refused {
  match self.tests.get(name) {
    Some(run) => run(self, value, args)
    None => raise unknown("test", name)
  }
}

///|
/// Whether a filter is registered under `name`.
pub fn Call::has_filter(self : Call, name : String) -> Bool {
  self.filters.contains(name)
}

///|
/// Whether a test is registered under `name`.
pub fn Call::has_test(self : Call, name : String) -> Bool {
  self.tests.contains(name)
}

///|
/// Ask the translation seam for `msgid` in `context`, plural form for
/// `count`. `None` when there is no seam or it has no translation.
pub fn Call::translate(
  self : Call,
  msgid : String,
  context? : String,
  count? : Int32,
) -> String? {
  match self.translate {
    Some(seam) => seam(msgid, context, count)
    None => None
  }
}

///|
/// A number that differs from call to call within a render and repeats on
/// the next render, for filters such as `random` that must give the same
/// page twice.
pub fn Call::draw(self : Call) -> Int32 {
  self.draws.val += 1
  self.draws.val
}

///|
/// A value as text, Python's `str`: an undefined value is empty, or
/// refused under the strict policy.
pub fn Call::text(self : Call, value : Value) -> String raise Refused {
  match value {
    Undefined(name) if self.refuses(name) => raise unknown("name", name)
    _ => value.to_string()
  }
}

///|
/// Whether using an undefined value of this name is refused. The strict
/// policy refuses a name that was looked up and missing; the implicit else
/// of an inline `if` has no name and is never refused.
pub fn Call::refuses(self : Call, name : String) -> Bool {
  self.undefined == Strict && name != ""
}

///|
/// The items a loop over the value walks; an undefined value is empty, or
/// refused under the strict policy.
pub fn Call::items(self : Call, value : Value) -> Array[Value] raise Refused {
  match value {
    Undefined(name) =>
      if self.refuses(name) {
        raise unknown("name", name)
      } else {
        []
      }
    _ => value.iter()
  }
}

///|
/// Whether the value counts as true; an undefined value is false, or
/// refused under the strict policy.
pub fn Call::truthy(self : Call, value : Value) -> Bool raise Refused {
  match value {
    Undefined(name) if self.refuses(name) => raise unknown("name", name)
    _ => value.truthy()
  }
}
