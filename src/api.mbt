// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One filter: a value goes in, arguments ride along, a value comes out.
/// Register your own into `Settings.filters`; every filter this library
/// ships is registered through this same trait.
pub(open) trait Filter {
  fn filter(Self, Context, Value, Array[Value], Map[String, Value]) -> Value raise Fault
}

///|
/// One test: the left of `is`, the arguments in parentheses, a verdict.
/// `defined` and `undefined` belong to the engine alone — they read the
/// expression, not the value — and are not registrable.
pub(open) trait Test {
  fn probe(Self, Value, Array[Value]) -> Bool raise Fault
}

///|
/// One global function: `{{ now() }}`, `{{ url('home') }}`, or any callable
/// the caller cares to hand the template. Host knowledge — routes, clocks,
/// CSRF tokens — enters exactly this way, the way Flask's `url_for` does.
pub(open) trait Global {
  fn call(Self, Context, Array[Value], Map[String, Value]) -> Value raise Fault
}

///|
/// Where another template comes from. The engine opens no files: a loader
/// decides what a name means.
pub(open) trait Loader {
  fn load(Self, String) -> String?
}

///|
/// What an extension may ask of its surroundings: the registries it can
/// reach, the translation seam, and the render's call counter. Extensions
/// read; they do not steer the render.
pub(all) struct Context {
  filters : Map[String, &Filter]
  tests : Map[String, &Test]
  translate : ((String, String?, Int32?) -> String?)?
  tally : Tally
}

///|
/// The render's call counter: `random` and friends draw a different value
/// per call yet the same one on a second render of the same page.
pub(all) struct Tally {
  mut n : Int32
}

///|
/// Which side wins when a registered name meets a builtin of the same name.
/// The default follows the house priority: the caller's, being the more
/// specific, wins over the library preset.
pub(all) enum Wins {
  Base
  Extra
} derive(Eq, Debug)

///|
pub extend Wins with Eq::{equal, not_equal}

///|
pub extend Wins with Debug::{to_repr}

///|
pub extend Wins with Show::{output, to_string}

///|
pub impl Show for Wins with fn output(self, logger) {
  logger.write_string(
    match self {
      Base => "base"
      Extra => "extra"
    },
  )
}

///|
/// What happens when a caller's registry entry collides with a builtin of
/// the same name. `Ignore` takes the winner silently by `wins`; `Panic`
/// refuses the render; `Handle` receives both and returns the one that
/// stays. Keys inside one `Map` cannot repeat, so the only collision these
/// arbitrate is builtin against caller.
pub(all) enum OnClash[T] {
  Ignore
  Panic
  Handle((T, T) -> T)
}

///|
/// A registry entry: filters, tests and globals all merge by the same rule,
/// so they travel in one wrapper and one `clash` governs all three.
pub(all) enum Entry {
  FilterOf(&Filter)
  TestOf(&Test)
  GlobalOf(&Global)
}

///|
/// Every knob of a render, in one place. The `settings` preset is the
/// library's default; pass a record update for what differs.
pub(all) struct Settings {
  syntax : Syntax
  force : Bool
  autoescape : Bool
  undefined_policy : UndefinedPolicy
  trim_blocks : Bool
  lstrip_blocks : Bool
  keep_trailing_newline : Bool
  line : String? // line-statement prefix; None leaves it off
  shortcuts : Map[String, String]
  sandbox : Bool
  loader : &Loader? // how names resolve; None refuses every include
  translate : ((String, String?, Int32?) -> String?)?
  cache : ((String, () -> String raise Fault) -> String raise Fault)?
  filters : Map[String, &Filter]
  tests : Map[String, &Test]
  globals : Map[String, &Global]
}

///|
/// The library preset: Jinja's defaults, the family's rule that escaping is
/// on and undefined is strict unless asked otherwise, and the builtin
/// filters, tests and globals — registered through the same traits a caller
/// uses.
pub let preset : Settings = {
  syntax: Html,
  force: false,
  autoescape: true,
  undefined_policy: Strict,
  trim_blocks: false,
  lstrip_blocks: false,
  keep_trailing_newline: false,
  line: None,
  shortcuts: Map([]),
  sandbox: false,
  loader: None,
  translate: None,
  cache: None,
  filters: builtin_filters(),
  tests: builtin_tests(),
  globals: builtin_globals(),
}

///|
/// Merge one registry: builtin entries on one side, the caller's on the
/// other, `wins` picking the direction and `clash` arbitrating a collision.
fn[T] merge_registry(
  kind : String,
  base : Map[String, T],
  extra : Map[String, T],
  wrap : (T) -> Entry raise Fault,
  unwrap : (Entry) -> T,
  wins : Wins,
  clash : OnClash[Entry],
) -> Map[String, T] raise Fault {
  let merged : Map[String, T] = Map([])
  for name, value in base {
    merged.set(name, value)
  }
  for name, value in extra {
    if merged.contains(name) {
      let mine = merged.get_or_default(name, value)
      let kept = match clash {
        Ignore =>
          match wins {
            Extra => value
            Base => mine
          }
        Panic =>
          raise Wrong(
            because="a registered \{kind} collides with a builtin: \{name}",
          )
        Handle(choose) => unwrap(choose(wrap(mine), wrap(value)))
      }
      merged.set(name, kept)
    } else {
      merged.set(name, value)
    }
  }
  merged
}

///|
/// How a value prints, for extensions that build text from values.
pub fn show(value : Value) -> String {
  show_value(value)
}
