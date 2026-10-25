///|
fn main {
  let data : Json = { "title": "Notes", "items": ["ink", "paper"] }
  let html = "<h1>{{ title }}</h1>{% for i in items %}<p>{{ i }}</p>{% endfor %}"
  let pug = "h1= title\neach i in items\n  p= i"
  let md =
    #|# {{ title }}
    #|{% for i in items %}
    #|- {{ i }}
    #|{% endfor %}
  let mixed =
    #|<section>
    #|{% block lang=pug %}
    #|ul
    #|  each i in items
    #|    li= i
    #|{% endblock %}
    #|</section>
  let show = fn(label : String, out : String) { println("\{label}\n\{out}\n") }
  try {
    show("html", @moonpug.render(html, data))
    show("pug", @moonpug.render(pug, data, format=@moonpug.pug))
    show("md", @moonpug.render(md, data, format=@moonpug.markdown))
    show("a pug block inside html", @moonpug.render(mixed, data))
    show(
      "the same, forced to read html only",
      @moonpug.render(mixed, data, force=true),
    )
  } catch {
    e => println("refused: \{e}")
  }
}
