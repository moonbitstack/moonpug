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
  let data = @jsontext.loads(context) catch {
    e => return "refused: the data is not JSON: " + e.message()
  }
  @moonpug.render(source, data, format~, force~) catch {
    e => "refused: \{e}"
  }
}

///|
/// One page written three ways, for the home page: each language, the source
/// it is written in, and what it renders to. The page is the shelf the
/// playground shows, so the three panes and the bench agree.
pub fn three_ways(context : String) -> String {
  let data = @jsontext.loads(context) catch {
    e => return "refused: the data is not JSON: " + e.message()
  }
  let pages : Array[(String, String, @moonpug.Format)] = [
    (
      "html",
      (
        #|<h2>{{ shelf }}</h2>
        #|<ul>
        #|{% for b in books %}
        #|<li><strong>{{ b.title }}</strong>, {{ b.year }}</li>
        #|{% endfor %}
        #|</ul>
      ),
      @moonpug.html,
    ),
    (
      "pug",
      (
        #|h2= shelf
        #|ul
        #|  each b in books
        #|    li
        #|      strong= b.title
        #|      | , #{b.year}
      ),
      @moonpug.pug,
    ),
    (
      "md",
      (
        #|## {{ shelf }}
        #|
        #|{% for b in books %}
        #|- **{{ b.title }}**, {{ b.year }}
        #|{% endfor %}
      ),
      @moonpug.markdown,
    ),
  ]
  let out : Array[Json] = []
  for page in pages {
    let (lang, source, format) = page
    let rendered = @moonpug.render(source, data, format~) catch {
      e => "refused: \{e}"
    }
    out.push(
      Json::object(
        Map([
          ("lang", Json::string(lang)),
          ("source", Json::string(source)),
          ("out", Json::string(rendered)),
        ]),
      ),
    )
  }
  @jsontext.dumps(Json::array(out))
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
  @jsontext.dumps(doc)
}
