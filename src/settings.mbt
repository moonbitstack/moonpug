///|
/// What a template writes, and so how it reads: the name of its language,
/// whether output is escaped, and how whitespace around tags is handled.
pub(all) struct Format {
  lang : String
  autoescape : Bool
  trim_blocks : Bool
  lstrip_blocks : Bool
  keep_trailing_newline : Bool
}

///|
/// HTML in the brace syntax, escaped.
pub let html : Format = {
  lang: "html",
  autoescape: true,
  trim_blocks: false,
  lstrip_blocks: false,
  keep_trailing_newline: false,
}

///|
/// Pug, escaped.
pub let pug : Format = { ..html, lang: "pug", }

///|
/// Markdown in the brace syntax: nothing escaped, and a tag on a line of its
/// own leaves no blank line behind.
pub let markdown : Format = {
  lang: "md",
  autoescape: false,
  trim_blocks: true,
  lstrip_blocks: true,
  keep_trailing_newline: true,
}

///|
/// Plain text in the brace syntax: nothing escaped.
pub let text : Format = { ..html, autoescape: false, }

///|
/// The format a template's name implies: `.pug` and `.pg` are Pug, `.html`,
/// `.htm`, `.xml`, `.svg` and `.xhtml` are escaped HTML, `.md` and
/// `.markdown` are Markdown, anything else is text.
pub fn format_of(name : String) -> Format {
  let ext = match name.rev_find(".") {
    Some(at) => name[at + 1:].to_lower()
    None => ""
  }
  match ext {
    "pug" | "pg" => pug
    "html" | "htm" | "xml" | "svg" | "xhtml" => html
    "md" | "markdown" => markdown
    _ => text
  }
}

///|
/// Bounds on what one render may do.
pub(all) struct Limits {
  /// Nested macro calls, includes, extends and recursive loops.
  depth : Int32
  /// The longest sequence `range` builds.
  range : Int32
}

///|
/// A thousand levels, as Python allows; a hundred thousand items, Jinja's
/// sandbox bound on `range`.
pub let limits : Limits = { depth: 1000, range: 100000, }

///|
/// Everything an environment is configured with.
pub(all) struct Settings {
  /// The format of a source compiled without a name.
  format : Format
  /// The format of a template from its name.
  formats : (String) -> Format
  /// Whether a template reads only its own language, leaving blocks in
  /// another as text.
  force : Bool
  /// What using an undefined name does.
  undefined : Undefined
  /// A prefix that makes a whole line a statement, as `# for x in y`.
  line_statement : String?
  /// A prefix that makes the rest of a line a comment.
  line_comment : String?
  limits : Limits
}

///|
/// HTML for an unnamed source, the format by extension for a named one,
/// every language read, undefined names refused, no line prefixes.
pub let settings : Settings = {
  format: html,
  formats: format_of,
  force: false,
  undefined: Strict,
  line_statement: None,
  line_comment: None,
  limits,
}
