///|
/// Templates by name, as a server keeps them: a layout, a page that extends
/// it, and macros imported from a library file.
let sources : Map[String, String] = Map([
  (
    "layout.html", "<title>{% block title %}Site{% endblock %}</title><main>{% block body %}{% endblock %}</main>",
  ),
  (
    "page.html", "{% extends 'layout.html' %}{% import 'ui.html' as ui %}{% block title %}{{ name }} · {{ super() }}{% endblock %}{% block body %}{{ ui.card(name, note) }}{% endblock %}",
  ),
  (
    "ui.html", "{% macro card(head, text) %}<article><h2>{{ head }}</h2><p>{{ text }}</p></article>{% endmacro %}",
  ),
  ("nav.pug", "nav\n  each l in links\n    a(href=l.url)= l.label"),
])

///|
fn main {
  let env = @moonpug.Env::new(load=name => sources.get(name))
  try {
    let page = env.template("page.html")
    println(
      page.render(
        @json.parse("{\"name\": \"Ada\", \"note\": \"<first program>\"}"),
      ),
    )
    println(
      page.render(@json.parse("{\"name\": \"Grace\", \"note\": \"compilers\"}")),
    )
    let nav = env.template("nav.pug")
    println(
      nav.render(
        @json.parse(
          "{\"links\": [{\"url\": \"/\", \"label\": \"Home\"}, {\"url\": \"/about\", \"label\": \"About\"}]}",
        ),
      ),
    )
  } catch {
    e => println("refused: \{e}")
  }
}
