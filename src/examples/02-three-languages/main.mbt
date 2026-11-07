///|
/// One page, three spellings, one output. The `md` frontend renders the
/// template to Markdown and then reads that Markdown as Markdown, so all
/// three write HTML5, and the same HTML at that.
fn main {
  let data : Json = { "title": "Notes", "items": ["ink", "paper"] }
  let html =
    #|<h1>{{ title }}</h1><ul>{% for i in items %}<li>{{ i }}</li>{% endfor %}</ul>
  let pug =
    #|h1= title
    #|ul
    #|  each i in items
    #|    li= i
  let md =
    #|# {{ title }}
    #|
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
  let show = fn(label : String, out : String) {
    println("\{label}\n  \{out}\n")
  }
  try {
    let a = @moonpug.render(html, data)
    let b = @moonpug.render(pug, data, format=@moonpug.pug)
    let c = @moonpug.render(md, data, format=@moonpug.markdown)
    show("html", a)
    show("pug", b)
    show("md", c)
    println("html and pug are the same text: \{a == b}")
    println("md is the same page, written as Markdown: \{c}\n")
    show("a pug block inside html", @moonpug.render(mixed, data))
    show(
      "the same, forced to read html only",
      @moonpug.render(mixed, data, force=true),
    )
  } catch {
    e => println("refused: \{e}")
  }
}
