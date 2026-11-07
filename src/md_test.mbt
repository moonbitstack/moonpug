///|
test "a markdown template writes HTML5" {
  let data : Json = { "title": "Notes", "items": ["ink", "paper"] }
  assert_eq(
    @moonpug.render("# {{ title }}", data, format=@moonpug.markdown),
    "<h1>Notes</h1>\n",
  )
  assert_eq(
    @moonpug.render(
      (
        #|## {{ title }}
        #|
        #|{% for i in items %}
        #|- {{ i }}
        #|{% endfor %}
      ),
      data,
      format=@moonpug.markdown,
    ),
    "<h2>Notes</h2>\n<ul>\n<li>ink</li>\n<li>paper</li>\n</ul>\n",
  )
  assert_eq(
    @moonpug.render("*em* and `code`", data, format=@moonpug.markdown),
    "<p><em>em</em> and <code>code</code></p>\n",
  )
  assert_eq(
    @moonpug.render("```mbt\nlet x = 1\n```", data, format=@moonpug.markdown),
    "<pre><code class=\"language-mbt\">let x = 1\n</code></pre>\n",
  )
}

///|
test "a markdown template is named by its extension" {
  let env = @moonpug.Env::new()
  assert_eq(
    env.compile("# T", name="a.md").render(Json::object(Map([]))),
    "<h1>T</h1>\n",
  )
  assert_eq(
    env.compile("# T", name="a.markdown").render(Json::object(Map([]))),
    "<h1>T</h1>\n",
  )
}

///|
test "a value is escaped before it enters the page" {
  let data : Json = { "bad": "<script>alert(1)</script>", "amp": "a & b" }
  assert_eq(
    @moonpug.render("# {{ bad }}", data, format=@moonpug.markdown),
    "<h1>&lt;script&gt;alert(1)&lt;/script&gt;</h1>\n",
  )
  assert_eq(
    @moonpug.render("{{ bad }}", data, format=@moonpug.markdown),
    "<p>&lt;script&gt;alert(1)&lt;/script&gt;</p>\n",
  )
  assert_eq(
    @moonpug.render("# {{ amp }}", data, format=@moonpug.markdown),
    "<h1>a &amp; b</h1>\n",
  )
  assert_eq(
    @moonpug.render("# {{ bad|safe }}", data, format=@moonpug.markdown),
    "<h1>&lt;script&gt;alert(1)&lt;/script&gt;</h1>\n",
  )
}

///|
test "escaping is decided before the text enters Markdown" {
  let data : Json = {
    "v": "*em*",
    "bad": "<script>x</script>",
    "b": "<b>x</b>",
  }
  assert_eq(
    @moonpug.render("{{ v }}", data, format=@moonpug.markdown),
    "<p><em>em</em></p>\n",
  )
  assert_eq(
    @moonpug.render("{{ bad }}", data, format=@moonpug.markdown),
    "<p>&lt;script&gt;x&lt;/script&gt;</p>\n",
  )
  let open = { ..@moonpug.markdown, safe: false, }
  assert_eq(
    @moonpug.render("{{ bad }}", data, format=open),
    "<p>&lt;script&gt;x&lt;/script&gt;</p>\n",
  )
  // Emphatically not a page: a script tag stays out even here.
  assert_eq(
    @moonpug.render(
      "{% autoescape false %}{{ bad }}{% endautoescape %}",
      data,
      format=open,
    ),
    "&lt;script>x&lt;/script>\n",
  )
  assert_eq(
    @moonpug.render(
      "{% autoescape false %}{{ b }}{% endautoescape %}",
      data,
      format=open,
    ),
    "<p><b>x</b></p>\n",
  )
}

///|
test "the author's own HTML is escaped unless the stretch allows it" {
  let data : Json = { "n": 1 }
  let page = "x <span>y</span>"
  let open = { ..@moonpug.markdown, safe: false, }
  assert_eq(
    @moonpug.render(page, data, format=@moonpug.markdown),
    "<p>x &lt;span&gt;y&lt;/span&gt;</p>\n",
  )
  assert_eq(
    @moonpug.render(page, data, format=open),
    "<p>x <span>y</span></p>\n",
  )
  assert_eq(
    @moonpug.render(
      "{% block lang=md safe=false %}x <span>y</span>{% endblock %}", data,
    ),
    "<p>x <span>y</span></p>\n",
  )
  assert_eq(
    @moonpug.render(
      "{% block lang=md safe=true %}x <span>y</span>{% endblock %}",
      data,
      format=open,
    ),
    "<p>x &lt;span&gt;y&lt;/span&gt;</p>\n",
  )
}

///|
test "a language block inside Markdown is not converted again" {
  let data : Json = { "n": 2 }
  assert_eq(
    @moonpug.render(
      (
        #|# T
        #|
        #|{% block lang=pug %}
        #|p= n
        #|{% endblock %}
        #|
        #|tail
      ),
      data,
      format=@moonpug.markdown,
    ),
    "<h1>T</h1>\n<p>2</p>\n<p>tail</p>\n",
  )
  assert_eq(
    @moonpug.render(
      "*a {% block lang=pug %}em x{% endblock %} b*",
      data,
      format=@moonpug.markdown,
    ),
    "<p><em>a <em>x</em> b</em></p>\n",
  )
}

///|
test "language blocks nest through Markdown" {
  assert_eq(
    @moonpug.render(
      (
        #|# A
        #|
        #|{% block lang=pug %}
        #|div
        #|  {% block lang=md %}
        #|  *deep*
        #|  {% endblock %}
        #|{% endblock %}
      ),
      Json::object(Map([])),
      format=@moonpug.markdown,
    ),
    "<h1>A</h1>\n<div><p><em>deep</em></p>\n</div>\n",
  )
}

///|
test "the markdown filter and the colon form run the same conversion" {
  let data : Json = { "n": 1 }
  assert_eq(
    @moonpug.render("{% filter markdown %}\n# Hi\n{% endfilter %}", data),
    "<h1>Hi</h1>\n",
  )
  assert_eq(
    @moonpug.render("div\n  :markdown\n    # Hi\n", data, format=@moonpug.pug),
    "<div><h1>Hi</h1>\n</div>",
  )
  assert_eq(@moonpug.render("{{ '# Hi'|markdown }}", data), "<h1>Hi</h1>\n")
  assert_eq(
    @moonpug.render("{{ 'x <span>y</span>'|markdown }}", data),
    "<p>x &lt;span&gt;y&lt;/span&gt;</p>\n",
  )
  assert_eq(
    @moonpug.render("{{ 'x <span>y</span>'|markdown(safe=false) }}", data),
    "<p>x <span>y</span></p>\n",
  )
}

///|
test "a text template writes Markdown as it stands" {
  let data : Json = { "n": 2 }
  assert_eq(
    @moonpug.render("# T\n{{ n }}", data, format=@moonpug.text),
    "# T\n2",
  )
  let env = @moonpug.Env::new()
  assert_eq(env.compile("# T\n", name="a.txt").render(data), "# T")
  assert_eq(
    env
    .compile("# T\n{% block lang=md %}*x*{% endblock %}", name="a.txt")
    .render(data),
    "# T\n<p><em>x</em></p>\n",
  )
}

///|
test "an included Markdown template becomes HTML where it stands" {
  let files = { "a.md": "*in*" }
  let env = @moonpug.Env::new(load=name => files.get(name))
  assert_eq(
    env
    .compile("p before\n{% include 'a.md' %}\np after")
    .render(Json::object(Map([]))),
    "p before\n<p><em>in</em></p>\n\np after",
  )
  assert_eq(
    env
    .compile("- x\n\n{% include 'a.md' %}\n", format=@moonpug.markdown)
    .render(Json::object(Map([]))),
    "<ul>\n<li>x</li>\n</ul>\n<p><em>in</em></p>\n",
  )
}

///|
test "a block written in Markdown becomes HTML in an HTML layout" {
  let files = {
    "layout.html": "<main>{% block body %}{% endblock %}</main>",
    "page.md": "{% extends 'layout.html' %}\n{% block body %}\n# Hi\n{% endblock %}\n",
    "layout.md": "# Site\n\n{% block body %}{% endblock %}\n",
    "page2.md": "{% extends 'layout.md' %}\n{% block body %}\n- a\n- b\n{% endblock %}\n",
  }
  let env = @moonpug.Env::new(load=name => files.get(name))
  let data : Json = Json::object(Map([]))
  assert_eq(env.template("page.md").render(data), "<main><h1>Hi</h1>\n</main>")
  assert_eq(
    env.template("page2.md").render(data),
    "<h1>Site</h1>\n<ul>\n<li>a</li>\n<li>b</li>\n</ul>\n",
  )
}

///|
test "a refusal inside Markdown names the template and the line" {
  assert_eq(
    r("# T\n\n{{ nope }}", format=@moonpug.markdown),
    "refused: <template>:3: nope is undefined",
  )
  assert_eq(
    r("{% block lang=md %}{{ nope }}{% endblock %}", context="{\"n\": 1}"),
    "refused: <template>:1: nope is undefined",
  )
}

///|
test "a language of your own ends with its own conversion" {
  let env = @moonpug.Env::new()
  env.add_lang({
    name: "aside",
    aliases: ["note"],
    options: @syntax.options,
    read: @syntax.read_braces,
    finish: Some((text, reading) => {
      let kind = if reading.safe { "note" } else { "bare" }
      "<aside class=\"" + kind + "\">" + text + "</aside>"
    }),
  })
  let data : Json = { "n": 1 }
  assert_eq(
    env.compile("{% block lang=aside %}a {{ n }}{% endblock %}").render(data),
    "<aside class=\"note\">a 1</aside>",
  )
  assert_eq(
    env.compile("{% block lang=note safe=false %}b{% endblock %}").render(data),
    "<aside class=\"bare\">b</aside>",
  )
  assert_eq(
    env
    .compile("{{ n }}", format={
      ..@moonpug.markdown,
      lang: "aside",
      safe: false,
    })
    .render(data),
    "<aside class=\"bare\">1</aside>",
  )
  assert_eq(
    env
    .compile(
      "# T\n\n{% block lang=aside %}a{% endblock %}\n",
      format=@moonpug.markdown,
    )
    .render(data),
    "<h1>T</h1>\n<aside class=\"note\">a</aside>\n",
  )
}
