///|
/// The templates a case may extend, include or import.
fn sample(name : String) -> String? {
  if name == "lib" {
    Some("{% macro m() %}lib{% endmacro %}")
  } else if name == "base" {
    Some("base:{% block a %}base{% endblock %}")
  } else {
    None
  }
}

///|
test "statements, blocks and loops" {
  // st-with
  assert_eq(
    r(
      "{% with a = 1, b = 2 %}{{ a }}{{ b }}{% endwith %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "12",
  )
  // st-with-empty
  assert_eq(
    r(
      "{% with %}{{ 1 }}{% endwith %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "1",
  )
  // st-set-block
  assert_eq(
    r(
      "{% set x %}a{{ 1 }}b{% endset %}{{ x }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "a1b",
  )
  // st-set-attr
  assert_eq(
    r(
      "{% set x.a = 1 %}{{ x.a }}",
      context="{\"x\": {}}",
      format=@moonpug.text,
      load=sample,
    ),
    "refused: <template>:1: cannot assign attribute on a non-namespace object",
  )
  // st-autoescape
  assert_eq(
    r(
      "{% autoescape false %}{{ '<b>' }}{% endautoescape %}",
      context="{}",
      format=@moonpug.html,
      load=sample,
    ),
    "<b>",
  )
  // st-autoescape-true
  assert_eq(
    r(
      "{% autoescape true %}{{ '<b>' }}{% endautoescape %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "&lt;b&gt;",
  )
  // st-filter-block
  assert_eq(
    r(
      "{% filter upper %}ab{% endfilter %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "AB",
  )
  // st-filter-chain
  assert_eq(
    r(
      "{% filter upper|lower %}ab{% endfilter %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "ab",
  )
  // st-do
  assert_eq(
    r(
      "{% set l = [] %}{% do l.append(1) %}{{ l }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "[1]",
  )
  // st-break
  assert_eq(
    r(
      "{% for x in range(5) %}{% if x == 2 %}{% break %}{% endif %}{{ x }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "01",
  )
  // st-continue
  assert_eq(
    r(
      "{% for x in range(4) %}{% if x == 1 %}{% continue %}{% endif %}{{ x }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "023",
  )
  // st-break-outside
  assert_eq(
    r("{% break %}", context="{}", format=@moonpug.text, load=sample),
    "",
  )
  // st-continue-outside
  assert_eq(
    r("{% continue %}", context="{}", format=@moonpug.text, load=sample),
    "",
  )
  // st-raw
  assert_eq(
    r(
      "{% raw %}{{ x }}{% endraw %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "{{ x }}",
  )
  // st-include-ignore
  assert_eq(
    r(
      "{% include 'nope' ignore missing %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "",
  )
  // st-include-ctx
  assert_eq(
    r(
      "{% include 'a' with context %}",
      context="{\"x\": 1}",
      format=@moonpug.text,
      load=sample,
    ),
    "refused: <template>:1: no template named a",
  )
  // st-include-noctx
  assert_eq(
    r(
      "{% include 'a' without context %}",
      context="{\"x\": 1}",
      format=@moonpug.text,
      load=sample,
    ),
    "refused: <template>:1: no template named a",
  )
  // st-once
  assert_eq(
    r(
      "{% once 'k' %}a{% endonce %}{% once 'k' %}b{% endonce %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "aa",
  )
  // st-once-nokey
  assert_eq(
    r(
      "{% once %}a{% endonce %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "a",
  )
  // st-show-true
  assert_eq(
    r(
      "{% show true %}<p>x</p>{% endshow %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "<p>x</p>",
  )
  // st-show-false
  assert_eq(
    r(
      "{% show false %}<p>x</p>{% endshow %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "<div style=\"display: none\"><p>x</p></div>",
  )
  // st-loop-prev
  assert_eq(
    r(
      "{% for x in [1, 2, 3] %}{{ loop.previtem }}{{ loop.nextitem }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "refused: <template>:1: there is no previous item is undefined",
  )
  // st-loop-depth
  assert_eq(
    r(
      "{% for x in [[1]] recursive %}{{ loop.depth }}{{ loop.depth0 }}{{ loop.length }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "101",
  )
  // st-loop-cycle
  assert_eq(
    r(
      "{% for x in [1, 2, 3] %}{{ loop.cycle('a', 'b') }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "aba",
  )
  // st-loop-changed
  assert_eq(
    r(
      "{% for x in [1, 1, 2] %}{{ loop.changed(x) }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "TrueFalseTrue",
  )
  // st-loop-first-last
  assert_eq(
    r(
      "{% for x in [1, 2] %}{{ loop.first }}{{ loop.last }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "TrueFalseFalseTrue",
  )
  // st-loop-else
  assert_eq(
    r(
      "{% for x in [] %}x{% else %}none{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "none",
  )
  // st-loop-filter
  assert_eq(
    r(
      "{% for x in [1, 2, 3] if x > 1 %}{{ x }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "23",
  )
  // st-loop-recursive
  assert_eq(
    r(
      "{% for x in [[1, [2]]] recursive %}{{ loop(x[1]) if x[1] }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "refused: <template>:1: 1 is undefined",
  )
  // st-loop-unpack
  assert_eq(
    r(
      "{% for a, b in [[1, 2]] %}{{ a }}{{ b }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "12",
  )
  // st-loop-unpack-bad
  assert_eq(
    r(
      "{% for a, b in [1] %}{{ a }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "refused: <template>:1: an integer cannot be iterated",
  )
  // st-loop-noname
  assert_eq(
    r(
      "{% for in [1] %}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "refused: <template>:1:8: expected a name to assign to",
  )
  // st-trans
  assert_eq(
    r(
      "{% trans %}hi{% endtrans %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "hi",
  )
  // st-trans-var
  assert_eq(
    r(
      "{% trans name='a' %}hi {{ name }}{% endtrans %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "hi a",
  )
  // st-trans-plural
  assert_eq(
    r(
      "{% trans count=2 %}one{% pluralize %}many{% endtrans %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "many",
  )
  // st-block-scoped
  assert_eq(
    r(
      "{% block a scoped %}{% endblock %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "",
  )
  // st-call-noend
  assert_eq(
    r(
      "{% macro m() %}{% endmacro %}{% call m() %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "refused: <template>:1:44: unexpected end of template; expected endcall",
  )
  // st-macro-in-loop
  assert_eq(
    r(
      "{% macro m(x) %}{{ x }}{% endmacro %}{% for i in [1, 2] %}{{ m(i) }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "12",
  )
  // st-nested-blocks
  assert_eq(
    r(
      "{% block a %}{% block b %}x{% endblock %}{% endblock %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "x",
  )
  // st-override
  assert_eq(
    r(
      "{% extends 'base' %}{% block a %}new{% endblock %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "base:new",
  )
  // st-super
  assert_eq(
    r(
      "{% extends 'base' %}{% block a %}{{ super() }}+{% endblock %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "base:base+",
  )
  // st-block-append
  assert_eq(
    r(
      "{% extends 'base' %}{% block a append %}!{% endblock %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "base:base!",
  )
  // st-block-prepend
  assert_eq(
    r(
      "{% extends 'base' %}{% block a prepend %}!{% endblock %}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "base:!base",
  )
  // st-import-as
  assert_eq(
    r(
      "{% import 'lib' as l %}{{ l.m() }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "lib",
  )
  // st-from-import
  assert_eq(
    r(
      "{% from 'lib' import m %}{{ m() }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "lib",
  )
  // st-from-import-as
  assert_eq(
    r(
      "{% from 'lib' import m as n %}{{ n() }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "lib",
  )
}

///|
test "values printed the way python prints them" {
  // dump-object
  assert_eq(
    r(
      "{{ ns|pprint }}",
      context="{\"ns\": {\"a\": 1}}",
      format=@moonpug.text,
      load=sample,
    ),
    "{'a': 1}",
  )
  // dump-tuple
  assert_eq(
    r("{{ (1, 'a')|pprint }}", context="{}", format=@moonpug.text, load=sample),
    "(1, 'a')",
  )
  // dump-float
  assert_eq(
    r(
      "{{ [1.0, 1e20, 0.0001, -0.0]|pprint }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "[1.0, 1e+20, 0.0001, -0.0]",
  )
  // dump-markup
  assert_eq(
    r(
      "{{ '<b>'|safe|pprint }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "Markup('<b>')",
  )
  // dump-undefined
  assert_eq(
    r("{{ nope|pprint }}", context="{}", format=@moonpug.text, load=sample, settings={
      ..@moonpug.settings,
      undefined: Lenient,
    }),
    "Undefined",
  )
  // dump-namespace
  assert_eq(
    r(
      "{{ namespace(a=1)|pprint }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "<Namespace {'a': 1}>",
  )
  // dump-nested
  assert_eq(
    r(
      "{{ {'a': [1, {'b': None}], 'c': True}|pprint }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "{'a': [1, {'b': None}], 'c': True}",
  )
  // dump-str-quotes
  assert_eq(
    r(
      "{{ [\"it's\", 'a\"b']|pprint }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "[\"it's\", 'a\"b']",
  )
  // dump-str-ctrl
  assert_eq(
    r(
      "{{ ['a\\tb', 'c\\nd']|pprint }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "['a\\tb', 'c\\nd']",
  )
}

///|
test "numbers through the numeric filters" {
  // num-round
  assert_eq(
    r(
      "{{ 2.5|round }}|{{ 3.5|round }}|{{ 1.2345|round(2) }}|{{ -0.5|round }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "2.0|4.0|1.23|-0.0",
  )
  // num-int
  assert_eq(
    r(
      "{{ '0x10'|int }}|{{ '1_0'|int }}|{{ '1.9'|int }}|{{ 'x'|int(5) }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "0|10|1|5",
  )
  // num-int-base
  assert_eq(
    r(
      "{{ 'ff'|int(0, 16) }}|{{ '0b11'|int(0, 0) }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "255|3",
  )
  // num-float-filter
  assert_eq(
    r(
      "{{ '1.5'|float }}|{{ 'x'|float(2) }}|{{ '1,5'|float }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "1.5|2|0.0",
  )
  // num-abs
  assert_eq(
    r(
      "{{ -3|abs }}|{{ -3.5|abs }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "3|3.5",
  )
}

///|
test "text filters on markup and on plain text" {
  // txt-title
  assert_eq(
    r(
      "{{ 'a b-c'|title }}|{{ 'x\\'y'|title }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "A B-C|X'y",
  )
  // txt-capitalize
  assert_eq(
    r("{{ 'aBC'|capitalize }}", context="{}", format=@moonpug.text, load=sample),
    "Abc",
  )
  // txt-center
  assert_eq(
    r(
      "{{ 'ab'|center(6) }}|{{ 'abcdef'|center(3) }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "  ab  |abcdef",
  )
  // txt-truncate
  assert_eq(
    r(
      "{{ 'a b c d'|truncate(5) }}|{{ 'abcdefgh'|truncate(5, true) }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "a b c d|abcdefgh",
  )
  // txt-truncate-leeway
  assert_eq(
    r(
      "{{ 'a bcdef'|truncate(5, false, 1) }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "a bcdef",
  )
  // txt-wordcount
  assert_eq(
    r(
      "{{ 'a b  c'|wordcount }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "3",
  )
  // txt-replace
  assert_eq(
    r(
      "{{ 'aaa'|replace('a', 'b', 2) }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "bba",
  )
  // txt-string
  assert_eq(
    r(
      "{{ 1|string }}|{{ none|string }}|{{ true|string }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "1|None|True",
  )
  // txt-safe
  assert_eq(
    r(
      "{{ '<b>'|safe }}|{{ '<b>'|escape }}|{{ '<b>'|forceescape }}",
      context="{}",
      format=@moonpug.html,
      load=sample,
    ),
    "<b>|&lt;b&gt;|&lt;b&gt;",
  )
  // txt-tojson
  assert_eq(
    r(
      "{{ {'a': '<b>'}|tojson }}",
      context="{}",
      format=@moonpug.html,
      load=sample,
    ),
    "{\"a\": \"\\u003cb\\u003e\"}",
  )
  // txt-list
  assert_eq(
    r(
      "{{ 'abc'|list }}|{{ {'a': 1}|list }}|{{ 5|list }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "refused: <template>:1: an integer cannot be iterated",
  )
  // txt-items
  assert_eq(
    r(
      "{{ {'a': 1}|items|list }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "[('a', 1)]",
  )
  // txt-attr
  assert_eq(
    r(
      "{{ {'a': 1}|attr('a') }}|{{ 'ab'|attr('upper')() }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "refused: <template>:1: a is undefined",
  )
  // txt-batch-zero
  assert_eq(
    r("{{ [1]|batch(0) }}", context="{}", format=@moonpug.text, load=sample),
    "refused: <template>:1: batch wants a positive line count",
  )
  // txt-slice-zero
  assert_eq(
    r("{{ [1]|slice(0) }}", context="{}", format=@moonpug.text, load=sample),
    "refused: <template>:1: slice wants a positive number of slices",
  )
}

///|
test "django filters on markup, missing values and plain arguments" {
  // dj-date-bad
  assert_eq(
    r(
      "{{ 'x'|date }}|{{ ''|date }}|{{ none|date }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "||",
  )
  // dj-time-letters
  assert_eq(
    r(
      "{{ '2026-03-05T14:07:09'|time('H:i:s') }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "14:07:09",
  )
  // dj-time-bad
  assert_eq(
    r(
      "{{ '2026-03-05'|time }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "",
  )
  // dj-date-epoch
  assert_eq(
    r(
      "{{ 0|date('Y-m-d') }}|{{ 1.5|date('Y-m-d H:i:s') }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "1970-01-01|1970-01-01 00:00:01",
  )
  // dj-timesince-bad
  assert_eq(
    r("{{ 'x'|timesince }}", context="{}", format=@moonpug.text, load=sample),
    "refused: <template>:1: timesince needs the moment to measure to, as timesince(now): templates read no clock",
  )
  // dj-timesince-now
  assert_eq(
    r(
      "{{ '2026-01-01'|timesince('2026-03-05') }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "2 months",
  )
  // dj-floatformat-x
  assert_eq(
    r(
      "{{ 'x'|floatformat }}|{{ 1.5|floatformat('x') }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "|1.5",
  )
  // dj-get-digit-x
  assert_eq(
    r(
      "{{ 123|get_digit('x') }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "123",
  )
  // dj-yesno-one
  assert_eq(
    r("{{ true|yesno('y') }}", context="{}", format=@moonpug.text, load=sample),
    "True",
  )
  // dj-pluralize-x
  assert_eq(
    r("{{ 'x'|pluralize }}", context="{}", format=@moonpug.text, load=sample),
    "",
  )
  // dj-truncatewords-x
  assert_eq(
    r(
      "{{ 'a b'|truncatewords('x') }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "a b",
  )
  // dj-ljust-markup
  assert_eq(
    r(
      "{{ 'a'|safe|rjust(3) }}",
      context="{}",
      format=@moonpug.html,
      load=sample,
    ),
    "  a",
  )
  // dj-escapejs-markup
  assert_eq(
    r("{{ \"a'b\"|escapejs }}", context="{}", format=@moonpug.html, load=sample),
    "a\\u0027b",
  )
  // dj-json-script-markup
  assert_eq(
    r(
      "{{ {'a': '<b>'}|json_script('x') }}",
      context="{}",
      format=@moonpug.html,
      load=sample,
    ),
    "<script id=\"x\" type=\"application/json\">{\"a\": \"\\u003Cb\\u003E\"}</script>",
  )
  // dj-urlize-empty
  assert_eq(
    r("{{ 'http://'|urlize }}", context="{}", format=@moonpug.text, load=sample),
    "http://",
  )
  // dj-adjust
  assert_eq(
    r(
      "{{ 1|add('2') }}|{{ [1]|add([2]) }}|{{ 1|add(none) }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "3|[1, 2]|",
  )
  // dj-linebreaks-markup
  assert_eq(
    r(
      "{{ 'a\\n\\nb'|safe|linebreaks }}",
      context="{}",
      format=@moonpug.html,
      load=sample,
    ),
    "<p>a</p>\n\n<p>b</p>",
  )
  // dj-spaceless
  assert_eq(
    r(
      "{{ '<p> a </p> <b> b </b>'|spaceless }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "<p> a </p><b> b </b>",
  )
  // dj-phone
  assert_eq(
    r(
      "{{ '1-800-COLLECT'|phone2numeric }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "1-800-2655328",
  )
  // dj-iriencode
  assert_eq(
    r("{{ '/a b'|iriencode }}", context="{}", format=@moonpug.text, load=sample),
    "/a%20b",
  )
  // dj-cut-semicolon
  assert_eq(
    r(
      "{{ 'a;b'|safe|cut(';') }}",
      context="{}",
      format=@moonpug.html,
      load=sample,
    ),
    "ab",
  )
  // dj-capfirst-markup
  assert_eq(
    r(
      "{{ 'a'|safe|capfirst }}",
      context="{}",
      format=@moonpug.html,
      load=sample,
    ),
    "A",
  )
  // dj-linenumbers
  assert_eq(
    r(
      "{{ 'a\\nb'|linenumbers }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "1. a\n2. b",
  )
  // dj-default-if-none
  assert_eq(
    r(
      "{{ none|default_if_none('x') }}|{{ 0|default_if_none('x') }}",
      context="{}",
      format=@moonpug.text,
      load=sample,
    ),
    "x|0",
  )
}
