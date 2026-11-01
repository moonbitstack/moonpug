///|
/// The templates a case may include, in either syntax.
fn probe_template(name : String) -> String? {
  if name == "lib" {
    Some("{% macro m() %}lib{% endmacro %}")
  } else if name == "part" || name == "part.pug" {
    Some("part {{ x|upper }}")
  } else {
    None
  }
}

///|
test "a macro body's reads, walked for varargs, kwargs and caller" {
  // mw-set
  assert_eq(
    r(
      "{% macro m() %}{% set y %}{{ 1 }}{% endset %}{{ y }}{% endmacro %}{{ m() }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "1",
  )
  // mw-with
  assert_eq(
    r(
      "{% macro m() %}{% with a = 1 %}{{ a }}{% endwith %}{% endmacro %}{{ m() }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "1",
  )
  // mw-autoescape
  assert_eq(
    r(
      "{% macro m() %}{% autoescape true %}x{% endautoescape %}{% endmacro %}{{ m() }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "x",
  )
  // mw-filterblock
  assert_eq(
    r(
      "{% macro m() %}{% filter upper %}x{% endfilter %}{% endmacro %}{{ m() }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "X",
  )
  // mw-trans
  assert_eq(
    r(
      "{% macro m() %}{% trans n=1 %}x{% endtrans %}{% endmacro %}{{ m() }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "x",
  )
  // mw-once
  assert_eq(
    r(
      "{% macro m() %}{% once 'k' %}o{% endonce %}{% endmacro %}{{ m() }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "o",
  )
  // mw-import
  assert_eq(
    r(
      "{% macro m() %}{% import 'lib' as l %}{{ l.m() }}{% endmacro %}{{ m() }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "lib",
  )
  // mw-expr-shapes
  assert_eq(
    r(
      "{% macro m() %}{{ [1, (2,)] }}{{ {'a': 1} }}{{ 1 }}{% endmacro %}{{ m() }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "[1, (2,)]{'a': 1}1",
  )
  // mw-callblock
  assert_eq(
    r(
      "{% macro m() %}{% macro inner() %}{% endmacro %}{% call inner() %}{% endcall %}{% endmacro %}{{ m() }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: macro 'inner' takes no keyword argument 'caller'",
  )
  // mw-kwarg
  assert_eq(
    r(
      "{% macro m(a) %}{{ a }}{% endmacro %}{{ m(a=1) }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "1",
  )
  // mw-pug-mixin
  assert_eq(
    r(
      "mixin m(a)\n  p= a\n+m(1)",
      context="{}",
      format=@moonpug.pug,
      load=probe_template,
    ),
    "<p>1</p>",
  )
}

///|
test "expressions at their edges" {
  // x-slice-zero
  assert_eq(
    r(
      "{{ [1, 2][::0] }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: slice step cannot be zero",
  )
  // x-slice-number
  assert_eq(
    r("{{ 1[1:] }}", context="{}", format=@moonpug.text, load=probe_template),
    "refused: <template>:1: an integer cannot be sliced",
  )
  // x-slice-tuple
  assert_eq(
    r(
      "{{ (1, 2, 3)[1:] }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "(2, 3)",
  )
  // x-slice-markup
  assert_eq(
    r(
      "{{ ('<b>'|safe)[1:] }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "b>",
  )
  // x-int-overflow
  assert_eq(
    r(
      "{{ 9223372036854775807 + 1 }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: integer result too large to hold in 64 bits",
  )
  // x-float-div-zero
  assert_eq(
    r("{{ 1.0 / 0 }}", context="{}", format=@moonpug.text, load=probe_template),
    "refused: <template>:1: float division by zero",
  )
  // x-float-mod-zero
  assert_eq(
    r("{{ 1.0 % 0 }}", context="{}", format=@moonpug.text, load=probe_template),
    "refused: <template>:1: float modulo by zero",
  )
  // x-concat-safe
  assert_eq(
    r(
      "{{ 'a' ~ '<b>'|safe }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "a<b>",
  )
  // x-mul-safe
  assert_eq(
    r(
      "{{ ('<b>'|safe) * 2 }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "<b><b>",
  )
  // x-add-safe
  assert_eq(
    r(
      "{{ ('<b>'|safe) + 'x' }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "<b>x",
  )
  // x-test-named
  assert_eq(
    r(
      "{{ 1 is eq(1) }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "True",
  )
  // x-in-object
  assert_eq(
    r(
      "{{ 'a' in cycler('a') }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: a cycler cannot be searched with in",
  )
  // x-object-index
  assert_eq(
    r("{{ ns[0] }}", context="{}", format=@moonpug.text, load=probe_template),
    "refused: <template>:1: ns is undefined",
  )
  // x-bool-plus
  assert_eq(
    r(
      "{{ true + 'a' }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: unsupported operand types for +: a boolean and a string",
  )
  // x-float-plus
  assert_eq(
    r(
      "{{ 1.5 + 'a' }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: unsupported operand types for +: a float and a string",
  )
  // x-list-plus-dict
  assert_eq(
    r("{{ [1] + {} }}", context="{}", format=@moonpug.text, load=probe_template),
    "refused: <template>:1: unsupported operand types for +: a list and a mapping",
  )
  // x-undef-cmp
  assert_eq(
    r(
      "{% for x in [1] %}{{ nope < 1 }}{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
      settings={ ..@moonpug.settings, undefined: Lenient, },
    ),
    "refused: <template>:1: nope, which is undefined, and an integer cannot be compared",
  )
  // x-undef-filter
  assert_eq(
    r(
      "{{ nope|upper }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
      settings={ ..@moonpug.settings, undefined: Lenient, },
    ),
    "",
  )
  // x-undef-test
  assert_eq(
    r(
      "{{ nope is odd }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: odd wants numbers, not nope, which is undefined, and an integer",
  )
  // x-undef-concat
  assert_eq(
    r(
      "{{ 'a' ~ nope }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
      settings={ ..@moonpug.settings, undefined: Lenient, },
    ),
    "a",
  )
  // x-undef-attr
  assert_eq(
    r("{{ nope.a }}", context="{}", format=@moonpug.text, load=probe_template, settings={
      ..@moonpug.settings,
      undefined: Lenient,
    }),
    "refused: <template>:1: nope is undefined",
  )
  // x-attr-splat
  assert_eq(
    r(
      "mixin m()\n  p&attributes(attributes)\n+m()&attributes({'a': 1})",
      context="{}",
      format=@moonpug.pug,
      load=probe_template,
    ),
    "<p a=\"1\"></p>",
  )
  // x-style-merge
  assert_eq(
    r(
      "p(style='a:b')(style='c:d')",
      context="{}",
      format=@moonpug.pug,
      load=probe_template,
    ),
    "<p style=\"a:b\" style=\"c:d\"></p>",
  )
  // x-class-merge
  assert_eq(
    r("p.a(class='b')", context="{}", format=@moonpug.pug, load=probe_template),
    "<p class=\"a b\"></p>",
  )
  // x-style-string
  assert_eq(
    r("p(style='a:b')", context="{}", format=@moonpug.pug, load=probe_template),
    "<p style=\"a:b\"></p>",
  )
}

///|
test "values compared, searched, sliced and printed" {
  // v-repr-escapes
  assert_eq(
    r(
      "{{ [\"a\\\\b\", \"c\\rd\", \"it's\", 'a\"b']|pprint }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "['a\\\\b', 'c\\rd', \"it's\", 'a\"b']",
  )
  // v-truthy-zero
  assert_eq(
    r(
      "{{ 0.0 or 'x' }}|{{ {} or 'x' }}|{{ [] or 'x' }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "x|x|x",
  )
  // v-path
  assert_eq(
    r(
      "{{ a.b.c }}",
      context="{\"a\": {\"b\": {\"c\": 3}}}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "3",
  )
  // v-path-index
  assert_eq(
    r(
      "{{ a.0.b }}",
      context="{\"a\": [{\"b\": 1}]}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "1",
  )
  // v-item-object
  assert_eq(
    r(
      "{{ ns['a'] }}",
      context="{\"ns\": {\"a\": 1}}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "1",
  )
  // v-of-json-obj
  assert_eq(
    r(
      "{{ x }}",
      context="{\"x\": {\"y\": [1, true]}}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "{'y': [1, True]}",
  )
  // v-kind-in-error
  assert_eq(
    r("{{ 1.5 in 2 }}", context="{}", format=@moonpug.text, load=probe_template),
    "refused: <template>:1: an integer cannot be searched with in",
  )
  // v-object-kind
  assert_eq(
    r(
      "{{ namespace() + 1 }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: unsupported operand types for +: a namespace and an integer",
  )
}

///|
test "text and web filters on awkward input" {
  // t-center-odd
  assert_eq(
    r(
      "{{ 'ab'|center(5) }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "  ab ",
  )
  // t-wordwrap-long
  assert_eq(
    r(
      "{{ 'a bbbbbbbb c'|wordwrap(3) }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "a b\nbbb\nbbb\nb c",
  )
  // t-truncate-word
  assert_eq(
    r(
      "{{ 'aaa bbb ccc'|truncate(7) }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "aaa bbb ccc",
  )
  // t-truncate-zero
  assert_eq(
    r(
      "{{ 'abc'|truncate(0) }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: truncate expects a length of at least 3, got 0",
  )
  // t-striptags-space
  assert_eq(
    r(
      "{{ '<p>a</p><p>b</p>'|striptags }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "ab",
  )
  // t-striptags-entity
  assert_eq(
    r(
      "{{ '&lt;b&gt;'|striptags }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "<b>",
  )
  // t-slug
  assert_eq(
    r(
      "{{ 'Hello, World! 2'|slugify }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "hello-world-2",
  )
  // t-title-apostrophe
  assert_eq(
    r(
      "{{ \"don't stop\"|title }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "Don't Stop",
  )
  // t-urlize-paren
  assert_eq(
    r(
      "{{ '(http://a.example)'|urlize }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "(<a href=\"http://a.example\" rel=\"noopener\">http://a.example</a>)",
  )
  // t-urlize-mail
  assert_eq(
    r(
      "{{ 'mail me@b.example now'|urlize }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "mail <a href=\"mailto:me@b.example\">me@b.example</a> now",
  )
  // t-urlize-noscheme
  assert_eq(
    r(
      "{{ 'a.example'|urlize }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "a.example",
  )
  // t-urlize-www
  assert_eq(
    r(
      "{{ 'www.a.example'|urlize }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "<a href=\"https://www.a.example\" rel=\"noopener\">www.a.example</a>",
  )
}

///|
test "the percent operator on awkward input" {
  // pc-star-width
  assert_eq(
    r(
      "{{ '%5s|%-5s|' % ['a', 'b'] }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: not enough arguments for format string",
  )
  // pc-hash
  assert_eq(
    r(
      "{{ '%#x|%#o' % [255, 8] }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: %d format: a number is required, not a list",
  )
  // pc-precision-str
  assert_eq(
    r(
      "{{ '%.1s' % 'abc' }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "a",
  )
  // pc-percent
  assert_eq(
    r(
      "{{ '100%%' % [] }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: not all arguments converted during string formatting",
  )
  // pc-mapping-missing
  assert_eq(
    r(
      "{{ '%(a)s' % {'b': 1} }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: a is undefined",
  )
  // pc-unknown
  assert_eq(
    r("{{ '%q' % 1 }}", context="{}", format=@moonpug.text, load=probe_template),
    "refused: <template>:1: unsupported format character q",
  )
  // pc-unclosed
  assert_eq(
    r("{{ '%' % 1 }}", context="{}", format=@moonpug.text, load=probe_template),
    "refused: <template>:1: incomplete format",
  )
  // pc-bool
  assert_eq(
    r(
      "{{ '%d' % true }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "1",
  )
  // pc-float-e
  assert_eq(
    r(
      "{{ '%E' % 1234.5 }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "1.234500E+03",
  )
}

///|
test "the indentation syntax, its includes and its refusals" {
  // p-eq-notag
  assert_eq(
    r("= 1", context="{}", format=@moonpug.pug, load=probe_template),
    "refused: <template>:1:1: a line of its own starting with = is written {{ … }} in this syntax",
  )
  // p-else-alone
  assert_eq(
    r("else\n  p x", context="{}", format=@moonpug.pug, load=probe_template),
    "refused: <template>:1:1: else follows an if",
  )
  // p-each-noblock
  assert_eq(
    r("each x in [1]", context="{}", format=@moonpug.pug, load=probe_template),
    "",
  )
  // p-case-noblock
  assert_eq(
    r("case 1", context="{}", format=@moonpug.pug, load=probe_template),
    "refused: <template>:1:7: case needs an indented block of when and default",
  )
  // p-mixin-nobody
  assert_eq(
    r("mixin m", context="{}", format=@moonpug.pug, load=probe_template),
    "refused: <template>:1:8: mixin m is declared without a body",
  )
  // p-when-alone
  assert_eq(
    r("when 1", context="{}", format=@moonpug.pug, load=probe_template),
    "refused: <template>:1:1: when and default belong inside a case",
  )
  // p-include-filter
  assert_eq(
    r(
      "include:upper part",
      context="{\"x\": \"a\"}",
      format=@moonpug.pug,
      load=probe_template,
    ),
    "PART {{ X|UPPER }}",
  )
  // p-include-args
  assert_eq(
    r(
      "include part",
      context="{\"x\": \"a\"}",
      format=@moonpug.pug,
      load=probe_template,
    ),
    "<part>A</part>",
  )
  // p-include-block
  assert_eq(
    r(
      "include part\n  p x",
      context="{\"x\": \"a\"}",
      format=@moonpug.pug,
      load=probe_template,
    ),
    "<part>A<p>x</p></part>",
  )
  // p-text-unclosed
  assert_eq(
    r("p.", context="{}", format=@moonpug.pug, load=probe_template),
    "<p></p>",
  )
  // p-tag-interp-unclosed
  assert_eq(
    r("p #[b", context="{}", format=@moonpug.pug, load=probe_template),
    "refused: <template>:1:6: the end of the line came with no ] closing the interpolation",
  )
  // p-bad-token
  assert_eq(
    r("p\n  ?", context="{}", format=@moonpug.pug, load=probe_template),
    "refused: <template>:2:3: unexpected text ?",
  )
  // p-indent-after-tag
  assert_eq(
    r("p\n    b x", context="{}", format=@moonpug.pug, load=probe_template),
    "<p><b>x</b></p>",
  )
  // p-attr-badname
  assert_eq(
    r("p(=1)", context="{}", format=@moonpug.pug, load=probe_template),
    "<p =\"1\"></p>",
  )
  // p-filter-args
  assert_eq(
    r(
      ":upper('a')\n  x",
      context="{}",
      format=@moonpug.pug,
      load=probe_template,
    ),
    "refused: <template>:1: upper got an unexpected argument a",
  )
  // p-filter-noname
  assert_eq(
    r(":", context="{}", format=@moonpug.pug, load=probe_template),
    "refused: <template>:1:1: unexpected text :",
  )
  // p-each-destructure
  assert_eq(
    r(
      "each [a, b] in [[1, 2]]\n  p= a",
      context="{}",
      format=@moonpug.pug,
      load=probe_template,
    ),
    "refused: <template>:1:1: each wants a name, then in and the items",
  )
  // p-mixin-default
  assert_eq(
    r(
      "mixin m(a=1)\n  p= a\n+m()",
      context="{}",
      format=@moonpug.pug,
      load=probe_template,
    ),
    "<p>1</p>",
  )
  // p-doctype-html
  assert_eq(
    r("doctype html", context="{}", format=@moonpug.pug, load=probe_template),
    "<!DOCTYPE html>",
  )
  // p-comment-html
  assert_eq(
    r("// x", context="{}", format=@moonpug.pug, load=probe_template),
    "<!-- x-->",
  )
  // p-plaintext-escape
  assert_eq(
    r(
      "p \\#{x}",
      context="{\"x\": 1}",
      format=@moonpug.pug,
      load=probe_template,
    ),
    "<p>#{x}</p>",
  )
  // p-interp-unescaped
  assert_eq(
    r(
      "p !{x}",
      context="{\"x\": \"<b>\"}",
      format=@moonpug.pug,
      load=probe_template,
    ),
    "<p><b></p>",
  )
  // p-attrs-multiline
  assert_eq(
    r(
      "p(a='1',\n  b='2')",
      context="{}",
      format=@moonpug.pug,
      load=probe_template,
    ),
    "<p a=\"1\" b=\"2\"></p>",
  )
  // p-attrs-brackets
  assert_eq(
    r("p[a='1']", context="{}", format=@moonpug.pug, load=probe_template),
    "<p a=\"1\"></p>",
  )
  // p-attrs-braces
  assert_eq(
    r("p{a='1'}", context="{}", format=@moonpug.pug, load=probe_template),
    "<p a=\"1\"></p>",
  )
  // p-tag-name-expr
  assert_eq(
    r("-#{'p'} x", context="{}", format=@moonpug.pug, load=probe_template),
    "refused: <template>:1:1: - lines run host code; write the statement as {% … %} and the output as {{ … }}",
  )
}

///|
test "the seams a render refuses at" {
  assert_eq(
    r(
      "{% for a, b in [[1]] %}x{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: not enough values to unpack (expected 2, got 1)",
  )
  assert_eq(
    r(
      "{% for a in [[1, 2]] %}x{% endfor %}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "x",
  )
  assert_eq(
    r(
      "{% call 1 %}{% endcall %}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1:11: a call block ends in a call",
  )
  assert_eq(
    r(
      "{% filter 1 %}x{% endfilter %}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1:11: expected a name, found 1",
  )
  assert_eq(
    r(
      "{% include 1 %}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: a template name must be a string, not an integer",
  )
  assert_eq(
    r(
      "{% include 'nope' %}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: no template named nope",
  )
  assert_eq(
    r(
      "{% import 'lib' as l %}{{ l }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "<Template module 'lib'>",
  )
  assert_eq(
    r("{{ self }}", context="{}", format=@moonpug.text, load=probe_template),
    "<the template's blocks>",
  )
  assert_eq(
    r("{{ range }}", context="{}", format=@moonpug.text, load=probe_template),
    "<function range>",
  )
  assert_eq(
    r(
      "{% include nope %}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: nope is undefined",
  )
  assert_eq(
    r(
      "{% set a, b = (1, 2) %}{{ a }}{{ b }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "12",
  )
  assert_eq(
    r(
      "{% set a, b = (1, 2, 3) %}{{ a }}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: too many values to unpack (expected 2)",
  )
  assert_eq(
    r(
      "{% show nope %}x{% endshow %}",
      context="{}",
      format=@moonpug.text,
      load=probe_template,
    ),
    "refused: <template>:1: nope is undefined",
  )
  // A context that is not a mapping is refused before the render starts.
  let template = @moonpug.Env::new().compile("x")
  let got = template.render(@json.parse("[1]")) catch { e => "refused: \{e}" }
  assert_eq(
    got, "refused: <template>: the context must be a mapping, not a list",
  )
}
