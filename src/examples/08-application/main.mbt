///|
/// A small but complete application: a page built from a layout it extends,
/// component macros it imports, an include for the footer, a host object that
/// supplies navigation and content, a translation seam for the words, and a
/// cached block so the footer is rendered once per key.
let sources : Map[String, String] = Map([
  (
    "layout.html",
    "<!doctype html><html lang=\"zh\"><head><title>{% block title %}站点{% endblock %}</title></head><body>{% block body %}{% endblock %}</body></html>",
  ),
  (
    "ui.html",
    "{% macro nav(items) %}<nav>{% for it in items %}<a href=\"{{ it.url }}\">{{ it.label }}</a>{% endfor %}</nav>{% endmacro %}\n{% macro card(head, body) %}<article class=\"card\"><h2>{{ head }}</h2><p>{{ body }}</p></article>{% endmacro %}",
  ),
  (
    "footer.html",
    "<footer>{% trans %}Made with moonpug{% endtrans %}</footer>",
  ),
  (
    "page.html",
    "{% extends 'layout.html' %}\n{% import 'ui.html' as ui %}\n{% block title %}{{ title }} · {{ _('Site') }}{% endblock %}\n{% block body %}\n{{ ui.nav(site.links) }}\n<main>\n{% for p in site.pages %}{{ ui.card(p.title, p.body) }}{% endfor %}\n</main>\n{% once 'foot' %}{% include 'footer.html' %}{% endonce %}\n{% endblock %}",
  ),
])

///|
/// The navigation and the content, handed to the template as a host object so a
/// template can read fields, loop, and use them as data would.
struct Site {
  links : Array[@moonpug.Value]
  pages : Array[@moonpug.Value]
}

///|
impl @moonpug.Object for Site with fn kind(_) {
  "the site"
}

///|
impl @moonpug.Object for Site with fn attr(self, name) {
  match name {
    "links" => Some(@moonpug.Value::Seq(self.links))
    "pages" => Some(@moonpug.Value::Seq(self.pages))
    _ => None
  }
}

///|
fn main {
  let link = fn(url : String, label : String) -> @moonpug.Value {
    @moonpug.Value::Dict(
      Map([("url", Text(url)), ("label", Text(label))]),
    )
  }
  let page = fn(title : String, body : String) -> @moonpug.Value {
    @moonpug.Value::Dict(
      Map([("title", Text(title)), ("body", Text(body))]),
    )
  }
  let site = Site::{
    links: [link("/", "首页"), link("/about", "关于")],
    pages: [
      page("欢迎", "这是用 moonpug 写的第一页。"),
      page("功能", "模板、过滤器与语句都在这里。"),
    ],
  }

  // A translation seam and a cache, so the footer is rendered once and the
  // words come back in Chinese where a translation exists.
  let catalogue : Map[String, String] = Map([
    ("Made with moonpug", "用 moonpug 制作"),
    ("Site", "站点"),
  ])
  let cached : Map[String, String] = Map([])
  let env = @moonpug.Env::new(
    load=name => sources.get(name),
    translate=(message, _, _) => catalogue.get(message),
    cache=(key, render) => {
      match cached.get(key) {
        Some(text) => text
        None => {
          let text = render()
          cached.set(key, text)
          text
        }
      }
    },
  )

  try {
    let out = env
      .template("page.html")
      .render_values(
        Map([("title", Text("首页")), ("site", Object(site))]),
      )
    println(out)
  } catch {
    e => println("refused: \{e}")
  }
}
