// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Why a template could not be read or written.
///
/// A template is data, so every fault names the place in it that went wrong
/// rather than unwinding a host stack the caller cannot see.
pub(all) suberror Fault {
  /// The source is not the syntax it claims: the byte offset is where reading
  /// stopped, the reason is what was found there.
  Lexical(at~ : Int32, because~ : String)
  /// A name this engine does not know: a filter, a test, a global, a template.
  Unknown(name~ : String, kind~ : String)
  /// A name that is not defined, under the strict undefined policy.
  Undefined(name~ : String)
  /// The syntax parsed and the types did not meet: a filter given a list, a
  /// macro called with the wrong arity, an operand that cannot be ordered.
  Wrong(because~ : String)
} derive(Eq, Debug)

///|
pub extend Fault with Eq::{equal, not_equal}

///|
pub extend Fault with Debug::{to_repr}

///|
pub extend Fault with Show::{output, to_string}

///|
pub impl Show for Fault with fn output(self, logger) {
  logger.write_string(
    match self {
      Lexical(at~, because~) => "at byte \{at}: \{because}"
      Unknown(name~, kind~) => "no such \{kind}: \{name}"
      Undefined(name~) => "undefined: \{name}"
      Wrong(because~) => because
    },
  )
}

///|
fn lexical(at : Int32, because : String) -> Fault {
  Lexical(at~, because~)
}
