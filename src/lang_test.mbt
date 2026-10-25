///|
test "a language block reads its body in that language" {
  assert_eq(
    r(
      "{{ n }}|{% block lang=pug %}p= n * 2{% endblock %}",
      context="{\"n\": 21}",
    ),
    "21|<p>42</p>",
  )
  assert_eq(r("{% block lang=pg %}em x{% endblock %}"), "<em>x</em>")
  assert_eq(
    r(
      "p a\n{% block lang=html %}<b>{{ 1 + 1 }}</b>{% endblock %}",
      format=@moonpug.pug,
    ),
    "<p>a</p><b>2</b>",
  )
  assert_eq(
    r(
      "{% block lang=markdown %}\n{% if true %}\n# T\n{% endif %}\n{% endblock %}",
    ),
    "\n# T\n",
  )
}

///|
test "language blocks nest and keep the variables around them" {
  let src = "{% set x = 3 %}{% block lang=pug %}div\n  {% block lang=html %}<i>{{ x }}</i>{% endblock %}{% endblock %}"
  assert_eq(r(src), "<div><i>3</i></div>")
  assert_eq(
    r(
      "{% block content %}{% block lang=pug %}em {{ n }}{% endblock %}{% endblock %}",
      context="{\"n\": 1}",
    ),
    "<em>1</em>",
  )
}

///|
test "force reads only the template's own language" {
  let forced = { ..@moonpug.settings, force: true, }
  assert_eq(
    r(
      "{% block lang=md %}*x*{% endblock %}",
      format=@moonpug.pug,
      settings=forced,
    ),
    "{% block lang=md %}*x*{% endblock %}",
  )
  assert_eq(
    r(
      "{{ 1 }}{% block lang=pug %}p{% endblock %}{% block lang=md %}m{% endblock %}",
      settings=forced,
    ),
    "1{% block lang=pug %}p{% endblock %}{% block lang=md %}m{% endblock %}",
  )
  assert_eq(
    r(
      "{% block lang=html %}<b>{{ 2 }}</b>{% endblock %}",
      format=@moonpug.pug,
      settings=forced,
    ),
    "<b>2</b>",
  )
  assert_eq(
    r("{% block lang=html %}{{ 2 }}{% endblock %}", settings=forced),
    "2",
  )
}

///|
test "a block's own force overrides the enclosing one" {
  assert_eq(
    r(
      "{% block lang=html force=true %}{% block lang=pug %}p{% endblock %}{% endblock %}",
    ),
    "{% block lang=pug %}p{% endblock %}",
  )
  let forced = { ..@moonpug.settings, force: true, }
  assert_eq(
    r(
      "{% block lang=html force=false %}{% block lang=pug %}p{% endblock %}{% endblock %}",
      settings=forced,
    ),
    "<p></p>",
  )
  assert_eq(
    r(
      "{% block lang=pug force=true %}\np x\n{% block lang=md %}*y*{% endblock %}\n{% endblock %}",
    ),
    "<p>x</p>{% block lang=md %}*y*{% endblock %}",
  )
}

///|
test "render's force overrides the settings" {
  let src = "{% block lang=pug %}p{% endblock %}"
  assert_eq(@moonpug.render(src, Json::object(Map([])), force=true), src)
  let forced = { ..@moonpug.settings, force: true, }
  assert_eq(
    @moonpug.render(src, Json::object(Map([])), settings=forced, force=false),
    "<p></p>",
  )
}

///|
test "a user's own language is registered by name and aliases" {
  let env = @moonpug.Env::new()
  env.add_lang({
    name: "shout",
    aliases: ["loud"],
    options: @syntax.options,
    read: (source, reading) => @syntax.read_braces(source.to_upper(), reading),
  })
  let ctx = @json.parse("{\"X\": 1}")
  assert_eq(
    env.compile("{% block lang=shout %}a{{ x }}{% endblock %}").render(ctx),
    "A1",
  )
  assert_eq(
    env.compile("{% block lang=loud %}b{% endblock %}").render(ctx),
    "B",
  )
  let as_format = { ..@moonpug.html, lang: "loud", }
  assert_eq(env.compile("c{{ x }}", format=as_format).render(ctx), "C1")
}

///|
test "a user's reader can embed blocks in other languages" {
  let env = @moonpug.Env::new()
  env.add_lang({
    name: "wrap",
    aliases: [],
    options: @syntax.options,
    read: (source, reading) => {
      let inner = reading.block(source, "pug", None, reading.line)
      [@syntax.Node::Text("["), ..inner, Text("]")]
    },
  })
  assert_eq(
    env
    .compile("{% block lang=wrap %}em x{% endblock %}")
    .render(Json::object(Map([]))),
    "[<em>x</em>]",
  )
}

///|
test "language names that answer to nothing are refused" {
  assert_eq(
    r("{% block lang=xml %}x{% endblock %}"),
    "refused: <template>:1: no language named xml",
  )
  assert_eq(
    r("x", format={ ..@moonpug.html, lang: "nope", }),
    "refused: <template>: no language named nope",
  )
  assert_eq(
    r("p a\n{% block lang=klingon %}x{% endblock %}", format=@moonpug.pug),
    "refused: <template>:2: no language named klingon",
  )
}

///|
test "malformed language blocks are refused where they start" {
  assert_eq(
    r("ab\n{% block lang=pug %}p"),
    "refused: <template>:2:3: the pug block is never closed with endblock",
  )
  assert_eq(
    r("{% block lang=pug force=maybe %}p{% endblock %}"),
    "refused: <template>:1:19: force takes true or false, not maybe",
  )
  assert_eq(
    r("{% block lang=pug x %}p{% endblock %}"),
    "refused: <template>:1:19: expected %} after the language block's head",
  )
  assert_eq(
    r("{% block lang= %}p{% endblock %}"),
    "refused: <template>:1:15: lang= names no language",
  )
}

///|
test "whitespace control around language blocks" {
  assert_eq(r("a {%- block lang=pug -%}  p  {%- endblock -%}  b"), "a<p></p>b")
  let trimmed = { ..@moonpug.html, trim_blocks: true, }
  assert_eq(r("{% block lang=html %}x{% endblock %}\ny", format=trimmed), "xy")
}

///|
test "the format of a name picks the language" {
  assert_eq(@moonpug.format_of("a.pug").lang, "pug")
  assert_eq(@moonpug.format_of("a.PG").lang, "pug")
  assert_eq(@moonpug.format_of("a.md").lang, "md")
  assert_eq(@moonpug.format_of("a.markdown").autoescape, false)
  assert_eq(@moonpug.format_of("x/y.svg").autoescape, true)
  assert_eq(@moonpug.format_of("notes.txt").autoescape, false)
  assert_eq(@moonpug.format_of("README").lang, "html")
}
