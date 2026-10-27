///|
/// The smallest realistic generator: a few pages built from one engine, each
/// template compiled once and rendered with its own data. A builder would
/// write `out` to disk; here we print it with the path it would take, to show
/// the whole pipeline in one place.
let index_src =
  #|<h1>{{ site }}</h1>
  #|<ul>{% for p in pages %}<li><a href="{{ p.url }}">{{ p.title }}</a></li>{% endfor %}</ul>

///|
let page_src =
  #|<article><h1>{{ title }}</h1><p>{{ body }}</p></article>

///|
let pages : Map[String, String] = Map([
  ("index.html", index_src),
  ("page.html", page_src),
])

///|
fn main {
  let env = @moonpug.Env::new()
  try {
    for (path, source) in pages {
      let t = env.compile(source)
      let data : Json = if path == "index.html" {
        @json.parse(
          "{\"site\":\"Notes\",\"pages\":[{\"url\":\"/\",\"title\":\"Home\"},{\"url\":\"/about\",\"title\":\"About\"}]}",
        )
      } else {
        @json.parse("{\"title\":\"About\",\"body\":\"A small static site.\"}")
      }
      println("// \{path}\n" + t.render(data) + "\n")
    }
  } catch {
    e => println("refused: \{e}")
  }
}
