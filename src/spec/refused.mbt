///|
/// Why a template could not be read or rendered. Every variant names the
/// template and the one-based line it stopped at; a fault raised by an
/// extension carries an empty name and line `0` until the engine fills in
/// where it was called from.
pub(all) suberror Refused {
  /// The source is not well formed.
  Syntax(template~ : String, line~ : Int32, column~ : Int32, reason~ : String)
  /// A name that resolves to nothing: a variable under the strict policy,
  /// a filter, a test, a template, an attribute. `kind` says which.
  Unknown(template~ : String, line~ : Int32, kind~ : String, name~ : String)
  /// The source is well formed and the values do not fit: wrong arguments,
  /// a type an operation does not take.
  Invalid(template~ : String, line~ : Int32, reason~ : String)
  /// A bound in `Limits` was crossed.
  Exceeded(template~ : String, line~ : Int32, limit~ : Int32, got~ : Int32)
} derive(Eq, Debug)

///|
pub extend Refused with Eq::{equal, not_equal}

///|
pub extend Refused with Debug::{to_repr}

///|
pub extend Refused with Show::{output, to_string}

///|
pub impl Show for Refused with fn output(self, logger) {
  let (template, line) = self.place()
  if template != "" {
    logger.write_string(template)
    if line > 0 {
      logger.write_string(":\{line}")
    }
    match self {
      Syntax(column~, ..) if column > 0 => logger.write_string(":\{column}")
      _ => ()
    }
    logger.write_string(": ")
  }
  logger.write_string(
    match self {
      Syntax(reason~, ..) | Invalid(reason~, ..) => reason
      Unknown(kind="name", name~, ..) => "\{name} is undefined"
      Unknown(kind~, name~, ..) => "no \{kind} named \{name}"
      Exceeded(limit~, got~, ..) => "\{got} exceeds the limit of \{limit}"
    },
  )
}

///|
/// The template and line a fault names.
pub fn Refused::place(self : Refused) -> (String, Int32) {
  match self {
    Syntax(template~, line~, ..)
    | Unknown(template~, line~, ..)
    | Invalid(template~, line~, ..)
    | Exceeded(template~, line~, ..) => (template, line)
  }
}

///|
/// The same fault, placed at `template` and `line` if it has no place yet.
pub fn Refused::at(self : Refused, template : String, line : Int32) -> Refused {
  if self.place().0 != "" {
    return self
  }
  match self {
    Syntax(column~, reason~, ..) => Syntax(template~, line~, column~, reason~)
    Unknown(kind~, name~, ..) => Unknown(template~, line~, kind~, name~)
    Invalid(reason~, ..) => Invalid(template~, line~, reason~)
    Exceeded(limit~, got~, ..) => Exceeded(template~, line~, limit~, got~)
  }
}

///|
/// A fault an extension raises; the engine adds the template and line.
pub fn invalid(reason : String) -> Refused {
  Invalid(template="", line=0, reason~)
}

///|
/// A name that resolves to nothing, raised from an extension.
pub fn unknown(kind : String, name : String) -> Refused {
  Unknown(template="", line=0, kind~, name~)
}
