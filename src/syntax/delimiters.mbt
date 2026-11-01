///|
/// The strings that open and close a tag of the brace syntax: an output, a
/// statement and a comment each have their own pair.
pub(all) struct Delimiters {
  variable_start : String
  variable_end : String
  block_start : String
  block_end : String
  comment_start : String
  comment_end : String
}

///|
/// `{{ }}`, `{% %}` and `{# #}`.
pub let delimiters : Delimiters = {
  variable_start: "{{",
  variable_end: "}}",
  block_start: "{%",
  block_end: "%}",
  comment_start: "{#",
  comment_end: "#}",
}

///|
/// How many characters of a tag's opening sit at `at`, if one does.
fn Delimiters::opening(self : Delimiters, src : String, at : Int32) -> Int32 {
  let mut width = 0
  for start in [self.block_start, self.variable_start, self.comment_start] {
    if starts_at(src, start, at) && start.length() > width {
      width = start.length()
    }
  }
  width
}

///|
/// Where a comment ends and the sign it carries, the way the brace lexer
/// reads `-#}`, `+#}` and `#}`.
fn Delimiters::close_comment_at(
  self : Delimiters,
  src : String,
  at : Int32,
) -> (Int32, Char?)? {
  let end = self.comment_end
  if starts_at(src, "-" + end, at) {
    Some((at + 1 + end.length(), Some('-')))
  } else if starts_at(src, "+" + end, at) {
    Some((at + 1 + end.length(), Some('+')))
  } else if starts_at(src, end, at) {
    Some((at + end.length(), None))
  } else {
    None
  }
}

///|
/// Where a statement tag ends and the sign it carries, the way `-%}`, `+%}`
/// and `%}` read with the usual delimiters.
fn Delimiters::close_block_at(
  self : Delimiters,
  src : String,
  at : Int32,
) -> (Int32, Char?)? {
  let end = self.block_end
  if starts_at(src, "+" + end, at) {
    Some((at + 1 + end.length(), Some('+')))
  } else if starts_at(src, "-" + end, at) {
    Some((at + 1 + end.length(), Some('-')))
  } else if starts_at(src, end, at) {
    Some((at + end.length(), None))
  } else {
    None
  }
}
