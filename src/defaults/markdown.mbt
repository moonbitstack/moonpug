///|
/// Markdown read into HTML. This is the conversion the `md` frontend ends
/// with, so `{% filter markdown %}`, the indentation syntax's `:markdown`
/// and a whole `.md` template all produce the same page, and no one has to
/// register it. The result is markup: escaping it would show the tags.
///
/// `safe=false` lets HTML in the text through; by default it is escaped,
/// as an `md` template escapes the HTML its author wrote.
fn filter_markdown(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let bound = bind("markdown", ["safe"], args, named)
  let safe = bound.flag("safe", true)
  Markup(@moonmd.parse(call.text(value)).html(safe~))
}
