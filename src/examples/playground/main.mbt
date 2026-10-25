///|
/// What the documentation page calls: a template, its data as JSON text,
/// the language to read it in, and whether to read only that language. A
/// refusal comes back as text starting with `refused: `.
pub fn render_page(
  source : String,
  context : String,
  lang : String,
  force : Bool,
) -> String {
  let format = match lang {
    "pug" => @moonpug.pug
    "md" => @moonpug.markdown
    _ => @moonpug.html
  }
  let data = @json.parse(context) catch {
    e => return "refused: the data is not JSON: \{e}"
  }
  @moonpug.render(source, data, format~, force~) catch {
    e => "refused: \{e}"
  }
}

///|
/// The built-in filters, tests and globals, as JSON, for the reference.
pub fn names() -> String {
  let sorted = (keys : Array[String]) => {
    keys.sort_by((a, b) => a.lexical_compare(b))
    keys
  }
  let doc : Json = {
    "filters": Json(sorted(@defaults.filters().keys().collect())),
    "tests": Json(sorted(@defaults.tests().keys().collect())),
    "globals": Json(sorted(@defaults.globals().keys().collect())),
  }
  doc.stringify()
}
