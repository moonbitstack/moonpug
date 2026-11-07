///|
/// What a template writes, and so how it reads: the name of its language,
/// whether output is escaped, whether HTML the author wrote is written as
/// it stands, and how whitespace around tags is handled.
pub(all) struct Format {
  lang : String
  autoescape : Bool
  /// Whether HTML the template's author wrote reaches the page as it
  /// stands. Off, a converter escapes it, the way a Markdown page leaves
  /// `html: false`; `{% block lang=md safe=false %}` turns it off for one
  /// stretch.
  safe : Bool
  trim_blocks : Bool
  lstrip_blocks : Bool
  keep_trailing_newline : Bool
}

///|
/// HTML in the brace syntax, escaped.
pub let html : Format = {
  lang: "html",
  autoescape: true,
  safe: true,
  trim_blocks: false,
  lstrip_blocks: false,
  keep_trailing_newline: false,
}

///|
/// Pug, escaped.
pub let pug : Format = { ..html, lang: "pug", }

///|
/// Markdown: the brace syntax, escaped, then read as Markdown and written as
/// HTML; a tag on a line of its own leaves no blank line behind.
pub let markdown : Format = {
  lang: "md",
  autoescape: true,
  safe: true,
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
/// `.markdown` are Markdown and so write HTML, anything else is text.
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
  /// Characters one buffer may take: the page being written, or a block
  /// captured for a macro, a filter or `set`. Each buffer counts on its own
  /// and the text carried between them is counted where it lands, so the
  /// number is the length of the longest stretch written at once.
  write : Int32
}

///|
/// A thousand levels, as Python allows; a hundred thousand items, Jinja's
/// sandbox bound on `range`; eight mebibytes of output, past which a
/// template is looping rather than rendering a page.
pub let limits : Limits = { depth: 1000, range: 100000, write: 8388608, }

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
  /// The strings that open and close a tag.
  delimiters : Delimiters
  /// The indentation syntax's shorthand prefixes and the attribute each
  /// one names: `.` writes a class, `#` an id, and a prefix of your own
  /// writes whatever attribute you give it.
  shortcuts : Map[String, String]
  limits : Limits
}

///|
/// HTML for an unnamed source, the format by extension for a named one,
/// every language read, undefined names refused, no line prefixes, `{{ }}`
/// for tags, `.` for a class and `#` for an id.
pub let settings : Settings = {
  format: html,
  formats: format_of,
  force: false,
  undefined: Strict,
  line_statement: None,
  line_comment: None,
  delimiters,
  shortcuts: Map([(".", "class"), ("#", "id")]),
  limits,
}
