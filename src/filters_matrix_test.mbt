// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The 51 Jinja filters, one case each, plus the shape of their arguments.
/// Table-driven: the filter name, the template fragment around it, the
/// context, the expected text.
fn one(template : String, context : String) -> String {
  @moonpug.render(template, @json.parse(context)) catch {
    fault => "F:\{fault}"
  }
}

///|
test "the Jinja filters, one case each" {
  let cases : Array[(String, String, String)] = [
    // abs
    ("{{ (-5)|abs }}|{{ (-5.5)|abs }}|{{ -5.5|abs }}", "{}", "5|5.5|-5.5"),
    // attr
    ("{{ ns|attr('a') }}", "{ \"ns\": { \"a\": 1 } }", "1"),
    // batch
    ("{{ [1,2,3,4]|batch(3, 0)|list }}", "{}", "[[1, 2, 3], [4, 0, 0]]"),
    // capitalize
    ("{{ 'hELLO'|capitalize }}", "{}", "Hello"),
    // center
    ("{{ 'hi'|center(6) }}", "{}", "  hi  "),
    // default is covered with the lenient policy below; under strict the
    // undefined name refuses before the filter sees it
    // dictsort
    // the printed repr escapes like MarkupSafe does, quotes included
    (
      "{{ { b: 2, a: 1 }|dictsort }}", "{}", "[[&#39;a&#39;, 1], [&#39;b&#39;, 2]]",
    ),
    // escape
    ("{{ '<b>'|escape }}", "{}", "&lt;b&gt;"),
    // filesizeformat
    (
      "{{ 1000|filesizeformat }}|{{ 1000000|filesizeformat }}", "{}", "1.0 kB|1.0 MB",
    ),
    // first
    ("{{ [1,2]|first }}|{{ 'ab'|first }}", "{}", "1|a"),
    // float
    ("{{ '4.5'|float }}|{{ 'x'|float(9) }}", "{}", "4.5|9.0"),
    // forceescape
    ("{{ ('<i>'|safe)|forceescape }}", "{}", "&lt;i&gt;"),
    // format
    ("{{ '%s=%d'|format('k', 3) }}", "{}", "k=3"),
    // groupby
    (
      "{{ people|groupby('city')|map(attribute='grouper')|join(',') }}", "{ \"people\": [{\"city\":\"R\"},{\"city\":\"P\"},{\"city\":\"R\"}] }",
      "P,R",
    ),
    // indent
    ("{{ 'a\nb'|indent(2) }}", "{}", "a\n  b"),
    // int
    ("{{ '42'|int }}|{{ 3.9|int }}|{{ 'zz'|int(7) }}", "{}", "42|3|7"),
    // items
    ("{{ { a: 1 }|items }}", "{}", "[[&#39;a&#39;, 1]]"),
    // join
    (
      "{{ [1,2]|join('-') }}|{{ users|join(', ', attribute='name') }}", "{ \"users\": [{\"name\":\"a\"},{\"name\":\"b\"}] }",
      "1-2|a, b",
    ),
    // last
    ("{{ [1,2]|last }}|{{ 'ab'|last }}", "{}", "2|b"),
    // length
    ("{{ [1,2]|length }}|{{ 'ab'|length }}|{{ {a:1}|length }}", "{}", "2|2|1"),
    // list
    ("{{ 'ab'|list }}", "{}", "[&#39;a&#39;, &#39;b&#39;]"),
    // lower
    ("{{ 'AB'|lower }}", "{}", "ab"),
    // map
    (
      "{{ users|map(attribute='name')|join(',') }}|{{ [1.2, 2.7]|map('round')|join(',') }}",
      "{ \"users\": [{\"name\":\"x\"},{\"name\":\"y\"}] }", "x,y|1,3",
    ),
    // max / min
    (
      "{{ [3,1,2]|max }}|{{ [3,1,2]|min }}|{{ users|max(attribute='age') }}", "{ \"users\": [{\"age\":4},{\"age\":9}] }",
      "3|1|{&#39;age&#39;: 9}",
    ),
    // pprint
    ("{{ [1, 'a']|pprint }}", "{}", "[1, &#39;a&#39;]"),
    // random is not deterministic by contract; covered separately
    // reject / select
    (
      "{{ [1,2,3,4]|select('even')|list }}|{{ [1,2,3,4]|reject('even')|list }}",
      "{}", "[2, 4]|[1, 3]",
    ),
    // rejectattr / selectattr
    (
      "{{ users|selectattr('on')|map(attribute='n')|join }}", "{ \"users\": [{\"n\":\"a\",\"on\":true},{\"n\":\"b\",\"on\":false}] }",
      "a",
    ),
    // replace
    (
      "{{ 'aaa'|replace('a', 'b', 2) }}|{{ 'aaa'|replace('aa', 'X') }}", "{}", "bba|Xa",
    ),
    // reverse
    ("{{ [1,2]|reverse|list }}|{{ 'ab'|reverse }}", "{}", "[2, 1]|ba"),
    // round
    (
      "{{ 4.7|round }}|{{ 4.2|round }}|{{ 4.5|round(0, 'ceil') }}", "{}", "5|4|5",
    ),
    // safe
    ("{{ '<b>'|safe }}", "{}", "<b>"),
    // slice
    ("{{ [1,2,3,4]|slice(2)|list }}", "{}", "[[1, 2], [3, 4]]"),
    // sort
    (
      "{{ [3,1,2]|sort|list }}|{{ ['B','a']|sort|list }}|{{ users|sort(attribute='age')|map(attribute='n')|join }}",
      "{ \"users\": [{\"n\":\"x\",\"age\":9},{\"n\":\"y\",\"age\":1}] }", "[1, 2, 3]|[&#39;a&#39;, &#39;B&#39;]|yx",
    ),
    // string
    ("{{ 42|string }}", "{}", "42"),
    // striptags
    ("{{ '<p>a <b>b</b></p>'|striptags }}", "{}", "a b"),
    // sum
    (
      "{{ [1,2,3]|sum }}|{{ items|sum(attribute='v') }}", "{ \"items\": [{\"v\":2},{\"v\":3}] }",
      "6|5",
    ),
    // title
    ("{{ 'hello world'|title }}", "{}", "Hello World"),
    ("{{ { a: '<i>' }|tojson }}", "{}", "{\"a\":\"\\u003ci\\u003e\"}"),
    // trim
    ("{{ '  a  '|trim }}", "{}", "a"),
    // truncate
    (
      "{{ 'foo bar baz qux'|truncate(9) }}|{{ 'foo bar baz qux'|truncate(9, true) }}",
      "{}", "foo ...|foo ba...",
    ),
    // unique
    ("{{ [1,2,1]|unique|list }}", "{}", "[1, 2]"),
    // upper
    ("{{ 'ab'|upper }}", "{}", "AB"),
    // urlencode
    ("{{ 'a b&c'|urlencode }}", "{}", "a%20b%26c"),
    // urlize
    (
      "{{ 'see http://x.example now'|urlize }}", "{}", "see <a href=\"http://x.example\">http://x.example</a> now",
    ),
    // wordcount
    ("{{ 'one two  three'|wordcount }}", "{}", "3"),
    // wordwrap
    ("{{ 'a b c d'|wordwrap(3) }}", "{}", "a b\nc d"),
    // xmlattr
    ("<span{{ { a: 1, b: 'x' }|xmlattr }}>", "{}", "<span a=\"1\" b=\"x\">"),
    // count alias
    ("{{ [1]|count }}", "{}", "1"),
    // e alias
    ("{{ '<i>'|e }}", "{}", "&lt;i&gt;"),
  ]
  for case in cases {
    let (template, context, want) = case
    let got = one(template, context)
    if got != want {
      abort("filter case failed: \{template} -> \{got}, wanted \{want}")
    }
  }
}

///|

///|
fn one_lenient(template : String, context : String) -> String {
  @moonpug.render(template, @json.parse(context), undefined_policy=Lenient) catch {
    fault => "F:\{fault}"
  }
}

///|
test "default over the lenient policy, refused under the strict one" {
  assert_eq(
    one_lenient(
      "{{ ghost|default('no') }}|{{ ''|default('no', boolean=true) }}|{{ 0|default('no') }}",
      "{}",
    ),
    "no|no|0",
  )
  assert_eq(one("{{ ghost|default('no') }}", "{}"), "F:undefined: ghost")
}

///|
test "random varies within one render" {
  let seen : Map[String, Bool] = Map([])
  let picks = one(
    "{% for i in range(200) %}{{ [1, 2, 3]|random }};{% endfor %}", "{}",
  )
  for part in picks.split(";") {
    if !part.is_empty() {
      seen.set(part.to_owned(), true)
    }
  }
  assert_true(seen.contains("1") && seen.contains("2") && seen.contains("3"))
}
