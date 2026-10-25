///|
test "macros expose their shape and refuse wrong calls" {
  let m = "{% macro row(a, b=2) %}{{ a }}{{ b }}{{ varargs }}{{ kwargs }}{{ caller() if caller }}{% endmacro %}"
  assert_eq(
    r(
      m +
      "{{ row.name }}|{{ row.arguments }}|{{ row.catch_varargs }}|{{ row.catch_kwargs }}|{{ row.caller }}|{{ row }}",
    ),
    "row|(&#39;a&#39;, &#39;b&#39;)|True|True|True|&lt;Macro &#39;row&#39;&gt;",
  )
  assert_eq(
    r(m + "{{ row(1, 3, 4, k=5) }}"),
    "refused: <template>:1: caller is undefined",
  )
  assert_eq(r(m + "{% call row(1) %}in{% endcall %}"), "12(){}in")
  assert_eq(
    r("{% macro f(a) %}{% endmacro %}{{ f(1, a=2) }}"),
    "refused: <template>:1: macro 'f' got multiple values for argument 'a'",
  )
  assert_eq(
    r("{% macro f(a) %}{% endmacro %}{{ f(1, 2) }}"),
    "refused: <template>:1: macro 'f' takes not more than 1 argument(s)",
  )
  assert_eq(
    r("{% macro f() %}{% endmacro %}{{ f(z=1) }}"),
    "refused: <template>:1: macro 'f' takes no keyword argument 'z'",
  )
  assert_eq(
    r("{% macro f() %}x{% endmacro %}{% call f() %}y{% endcall %}"),
    "refused: <template>:1: macro 'f' takes no keyword argument 'caller'",
  )
}

///|
test "a call block passes arguments to its caller" {
  let src = "{% macro each(xs) %}{% for x in xs %}[{{ caller(x, loop.index) }}]{% endfor %}{% endmacro %}{% call(v, i) each([7, 8]) %}{{ i }}={{ v }}{% endcall %}"
  assert_eq(r(src), "[1=7][2=8]")
}

///|
test "macros see the names around their definition, not their call" {
  assert_eq(
    r(
      "{% set x = 1 %}{% macro f() %}{{ x }}{% endmacro %}{% set x = 2 %}{{ f() }}",
    ),
    "2",
  )
  assert_eq(
    r(
      "{% macro f() %}{{ y }}{% endmacro %}{% with y = 3 %}{{ f() }}{% endwith %}",
    ),
    "refused: <template>:1: y is undefined",
  )
}

///|
test "imports with and without context" {
  let lib = files([
    (
      "lib", "{% macro hi(n) %}hi {{ n }}{{ who|default('') }}{% endmacro %}{% set version = 3 %}",
    ),
  ])
  assert_eq(
    r("{% import 'lib' as l %}{{ l.hi(1) }} {{ l.version }}", load=lib),
    "hi 1 3",
  )
  assert_eq(
    r("{% from 'lib' import hi, version as v %}{{ hi(2) }} {{ v }}", load=lib),
    "hi 2 3",
  )
  assert_eq(
    r(
      "{% set who = '!' %}{% from 'lib' import hi with context %}{{ hi(3) }}",
      load=lib,
    ),
    "hi 3!",
  )
  assert_eq(
    r("{% from 'lib' import nope %}", load=lib),
    "refused: <template>:1: the template does not export the requested name nope",
  )
}

///|
test "once caches through the seam" {
  let store : Map[String, String] = Map([])
  let cache = (key : String, run : () -> String raise @moonpug.Refused) => {
    match store.get(key) {
      Some(v) => v
      None => {
        let v = run()
        store[key] = v
        v
      }
    }
  }
  let env = @moonpug.Env::new(cache~)
  let t = env.compile("{% once 'k' %}{{ n }}{% endonce %}")
  assert_eq(t.render(@json.parse("{\"n\": 1}")), "1")
  assert_eq(t.render(@json.parse("{\"n\": 2}")), "1")
  assert_eq(
    @moonpug.render("{% once %}{{ n }}{% endonce %}", @json.parse("{\"n\": 5}")),
    "5",
  )
}

///|
test "show renders hidden content with a style" {
  assert_eq(
    r("{% show flag %}<b>x</b>{% endshow %}", context="{\"flag\": true}"),
    "<b>x</b>",
  )
  assert_eq(
    r("{% show flag %}<b>x</b>{% endshow %}", context="{\"flag\": false}"),
    "<div style=\"display: none\"><b>x</b></div>",
  )
}

///|
test "debug lists what a template can see" {
  let got = r("{% set a = 1 %}{% debug %}", context="{\"b\": 2}")
  assert_true(got.contains("&#39;a&#39;: 1"))
  assert_true(got.contains("&#39;b&#39;: 2"))
  assert_true(got.contains("filters"))
}

///|
test "lipsum writes paragraphs within the bounds" {
  let text = r("{{ lipsum(2, false, 5, 8) }}")
  let paras = text.split("\n\n").collect()
  assert_eq(paras.length(), 2)
  for p in paras {
    let words = p.split(" ").collect().length()
    assert_true(words >= 5 && words <= 8)
  }
  let html = r("{{ lipsum(1) }}")
  assert_true(html.has_prefix("<p>") && html.has_suffix("</p>"))
}

///|
test "markup in attributes, the Pug way" {
  let ctx = "{\"n\": 2, \"f\": 1.5, \"list\": [1, \"a\"], \"map\": {\"k\": true}, \"none\": null, \"q\": \"say \\\"hi\\\"\"}"
  assert_eq(
    r(
      "div(data-n=n data-f=f data-l=list data-m=map data-x=none)",
      context=ctx,
      format=@moonpug.pug,
    ),
    "<div data-n=\"2\" data-f=\"1.5\" data-l=\"[1,&#34;a&#34;]\" data-m=\"{&#34;k&#34;:true}\"></div>",
  )
  assert_eq(
    r("div(data-l!=list)", context=ctx, format=@moonpug.pug),
    "<div data-l='[1,\"a\"]'></div>",
  )
  assert_eq(
    r("div(class={'a': true, 'b': false})", format=@moonpug.pug),
    "<div class=\"a\"></div>",
  )
  assert_eq(
    r("div(style={'color': 'red', 'margin': 0})", format=@moonpug.pug),
    "<div style=\"color:red;margin:0;\"></div>",
  )
  assert_eq(
    r(
      "div&attributes({'style': {'a': 'b'}, 'class': ['x', 'y'], 'hidden': true})",
      format=@moonpug.pug,
    ),
    "<div class=\"x y\" style=\"a:b;\" hidden=\"hidden\"></div>",
  )
  assert_eq(
    r("div&attributes(missing)", format=@moonpug.pug),
    "refused: <template>:1: missing is undefined",
  )
  assert_eq(
    r("div&attributes(3)", format=@moonpug.pug),
    "refused: <template>:1: &attributes takes a mapping, not an integer",
  )
  assert_eq(
    r("p(title=q)", context=ctx, format=@moonpug.pug),
    "<p title=\"say &#34;hi&#34;\"></p>",
  )
}

///|
test "Pug statements in braces and the extensions" {
  assert_eq(
    r(
      "ul\n  {% for x in [1, 2] %}\n    li= x\n  {% endfor %}",
      format=@moonpug.pug,
    ),
    "<ul><li>1</li><li>2</li></ul>",
  )
  assert_eq(
    r("{% if true %}\n  p yes\n{% else %}\n  p no", format=@moonpug.pug),
    "<p>yes</p>",
  )
  assert_eq(
    r("div[class='a' title='t'] x", format=@moonpug.pug),
    "<div class=\"a\" title=\"t\">x</div>",
  )
  assert_eq(
    r("div{data-x='1'} y", format=@moonpug.pug),
    "<div data-x=\"1\">y</div>",
  )
  assert_eq(
    r("li(:key='k1') z", format=@moonpug.pug),
    "<li data-key=\"k1\">z</li>",
  )
  assert_eq(
    r(
      "case n\n  when 1, 2\n    p small\n  default\n    p big",
      context="{\"n\": 2}",
      format=@moonpug.pug,
    ),
    "<p>small</p>",
  )
  assert_eq(
    r("{% raw %}\n  {{ kept }}\n{% endraw %}", format=@moonpug.pug),
    "{{ kept }}",
  )
  assert_eq(
    r("{% trans %}\n  Hello\n{% endtrans %}", format=@moonpug.pug),
    "Hello",
  )
  assert_eq(
    r("p.\n  {{ 1 + 1 }} and #{2 + 2}", format=@moonpug.pug),
    "<p>2 and 4</p>",
  )
}

///|
test "Pug includes with blocks and yield" {
  let lib = files([
    ("box.pug", ".box\n  yield\n  p after"),
    ("plain.pug", ".plain\n  p inner"),
    ("mix.pug", "mixin hi\n  b hi"),
  ])
  assert_eq(
    r("include box.pug\n  em in", format=@moonpug.pug, load=lib),
    "<div class=\"box\"><em>in</em><p>after</p></div>",
  )
  assert_eq(
    r("include plain.pug\n  em in", format=@moonpug.pug, load=lib),
    "<div class=\"plain\"><p>inner</p><em>in</em></div>",
  )
  assert_eq(
    r("include mix.pug\n+hi", format=@moonpug.pug, load=lib),
    "<b>hi</b>",
  )
  assert_eq(
    r("include ../up.pug", format=@moonpug.pug, load=lib),
    "refused: <template>:1: no template named ../up.pug",
  )
}
