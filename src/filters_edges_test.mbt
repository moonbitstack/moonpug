///|
test "urlize, the address it finds and the text it leaves" {
  // u-ipv6
  assert_eq(
    r("{{ 'http://[::1]:8000/x'|urlize }}", context="{}", format=@moonpug.text),
    "<a href=\"http://[::1]:8000/x\" rel=\"noopener\">http://[::1]:8000/x</a>",
  )
  // u-port
  assert_eq(
    r(
      "{{ 'http://a.example:8080/x'|urlize }}",
      context="{}",
      format=@moonpug.text,
    ),
    "<a href=\"http://a.example:8080/x\" rel=\"noopener\">http://a.example:8080/x</a>",
  )
  // u-puny
  assert_eq(
    r(
      "{{ 'http://xn--bcher-kva.example/x'|urlize }}",
      context="{}",
      format=@moonpug.text,
    ),
    "<a href=\"http://xn--bcher-kva.example/x\" rel=\"noopener\">http://xn--bcher-kva.example/x</a>",
  )
  // u-punct
  assert_eq(
    r(
      "{{ 'see http://a.example/x, and http://b.example/y.'|urlize }}",
      context="{}",
      format=@moonpug.text,
    ),
    "see <a href=\"http://a.example/x\" rel=\"noopener\">http://a.example/x</a>, and <a href=\"http://b.example/y\" rel=\"noopener\">http://b.example/y</a>.",
  )
  // u-auth
  assert_eq(
    r(
      "{{ 'https://user:pw@a.example/x'|urlize }}",
      context="{}",
      format=@moonpug.text,
    ),
    "https://user:pw@a.example/x",
  )
  // u-short
  assert_eq(
    r("{{ 'http://a'|urlize }}", context="{}", format=@moonpug.text),
    "http://a",
  )
  // u-ftp
  assert_eq(
    r("{{ 'ftp://a.example/x'|urlize }}", context="{}", format=@moonpug.text),
    "ftp://a.example/x",
  )
  // u-inlink
  assert_eq(
    r(
      "{{ '<a href=\"http://a.example\">http://a.example</a>'|urlize }}",
      context="{}",
      format=@moonpug.text,
    ),
    "&lt;a href=&#34;http://a.example&#34;&gt;http://a.example&lt;/a&gt;",
  )
  // u-mail-bad
  assert_eq(r("{{ 'a@b'|urlize }}", context="{}", format=@moonpug.text), "a@b")
  // u-quote
  assert_eq(
    r("{{ '\"http://a.example\"'|urlize }}", context="{}", format=@moonpug.text),
    "&#34;http://a.example&#34;",
  )
  // u-angle
  assert_eq(
    r("{{ '<http://a.example>'|urlize }}", context="{}", format=@moonpug.text),
    "&lt;<a href=\"http://a.example\" rel=\"noopener\">http://a.example</a>&gt;",
  )
  // u-semicolon
  assert_eq(
    r("{{ 'http://a.example/x;y'|urlize }}", context="{}", format=@moonpug.text),
    "<a href=\"http://a.example/x;y\" rel=\"noopener\">http://a.example/x;y</a>",
  )
  // u-brackets
  assert_eq(
    r("{{ '[http://a.example]'|urlize }}", context="{}", format=@moonpug.text),
    "[http://a.example]",
  )
  // u-hash
  assert_eq(
    r("{{ 'http://a.example/#x'|urlize }}", context="{}", format=@moonpug.text),
    "<a href=\"http://a.example/#x\" rel=\"noopener\">http://a.example/#x</a>",
  )
  // u-upper
  assert_eq(
    r("{{ 'HTTP://A.EXAMPLE/X'|urlize }}", context="{}", format=@moonpug.text),
    "<a href=\"HTTP://A.EXAMPLE/X\" rel=\"noopener\">HTTP://A.EXAMPLE/X</a>",
  )
  // u-nested
  assert_eq(
    r(
      "{{ 'http://a.example/http://b.example'|urlize }}",
      context="{}",
      format=@moonpug.text,
    ),
    "<a href=\"http://a.example/http://b.example\" rel=\"noopener\">http://a.example/http://b.example</a>",
  )
  // u-mailto
  assert_eq(
    r("{{ 'mailto:a@b.example'|urlize }}", context="{}", format=@moonpug.text),
    "<a href=\"mailto:a@b.example\">a@b.example</a>",
  )
}

///|
test "attributes and queries built from a value" {
  // xml-bad
  assert_eq(
    r("{{ [1]|xmlattr }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: xmlattr wants a mapping, not a list",
  )
}

///|
test "attributes and queries built from a value (2)" {
  // url-encode-bad
  assert_eq(
    r("{{ [1]|urlencode }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: urlencode wants a mapping or a sequence of pairs",
  )
}

///|
test "values printed the way python prints them, at length" {
  // d-empty
  assert_eq(
    r("{{ []|pprint }}|{{ {}|pprint }}", context="{}", format=@moonpug.text),
    "[]|{}",
  )
  // d-inf
  assert_eq(
    r(
      "{{ [10.0 ** 400, -(10.0 ** 400)]|pprint }}",
      context="{}",
      format=@moonpug.text,
    ),
    "[inf, -inf]",
  )
  // d-nan
  assert_eq(
    r(
      "{{ [(10.0 ** 400) - (10.0 ** 400)]|pprint }}",
      context="{}",
      format=@moonpug.text,
    ),
    "[nan]",
  )
  // d-tuple1
  assert_eq(r("{{ (1,)|pprint }}", context="{}", format=@moonpug.text), "(1,)")
  // d-escapes
  assert_eq(
    r(
      "{{ ['a\\bb', 'a\\fb', '\\u{1}b', 'é']|pprint }}",
      context="{}",
      format=@moonpug.text,
    ),
    "['a\\x08b', 'a\\x0cb', '\\\\u{1}b', 'é']",
  )
  // d-long
  assert_eq(
    r(
      "{{ ['aaaaaaaaaa', 'bbbbbbbbbb', 'cccccccccc', 'dddddddddd', 'eeeeeeeeee', 'ffffffffff', 'gggggggggg']|pprint }}",
      context="{}",
      format=@moonpug.text,
    ),
    "['aaaaaaaaaa',\n 'bbbbbbbbbb',\n 'cccccccccc',\n 'dddddddddd',\n 'eeeeeeeeee',\n 'ffffffffff',\n 'gggggggggg']",
  )
  // d-longdict
  assert_eq(
    r(
      "{{ {'aaaaaaaaaa': 1, 'bbbbbbbbbb': 2, 'cccccccccc': 3, 'dddddddddd': 4, 'eeeeeeeeee': 5}|pprint }}",
      context="{}",
      format=@moonpug.text,
    ),
    "{'aaaaaaaaaa': 1,\n 'bbbbbbbbbb': 2,\n 'cccccccccc': 3,\n 'dddddddddd': 4,\n 'eeeeeeeeee': 5}",
  )
}

///|
test "arguments bound the way python binds them" {
  // a-two-values
  assert_eq(
    r("{{ 'a'|truncate(3, length=3) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: truncate got two values for length",
  )
  // a-missing
  assert_eq(
    r("{{ 'a'|cut }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: cut is missing the argument arg",
  )
  // a-int-bool
  assert_eq(
    r("{{ 'a'|indent(true) }}", context="{}", format=@moonpug.text),
    "a",
  )
  // a-int-double
  assert_eq(r("{{ 'a'|indent(2.7) }}", context="{}", format=@moonpug.text), "a")
  // a-int-bad
  assert_eq(r("{{ 'a'|indent('x') }}", context="{}", format=@moonpug.text), "a")
  // a-float-sign
  assert_eq(
    r(
      "{{ '+1.5'|float }}|{{ '-1.5'|float }}",
      context="{}",
      format=@moonpug.text,
    ),
    "1.5|-1.5",
  )
  // a-float-bad
  assert_eq(
    r("{{ '1_0'|float }}|{{ 'in'|float }}", context="{}", format=@moonpug.text),
    "10.0|0.0",
  )
  // a-int-sign
  assert_eq(r("{{ '+5'|int }}", context="{}", format=@moonpug.text), "5")
  // a-int-octal
  assert_eq(r("{{ '0o17'|int }}", context="{}", format=@moonpug.text), "0")
  // a-int-leading
  assert_eq(r("{{ '010'|int }}", context="{}", format=@moonpug.text), "10")
  // a-int-baddigit
  assert_eq(
    r("{{ '12a'|int(0, 10) }}", context="{}", format=@moonpug.text),
    "0",
  )
  // a-int-huge
  assert_eq(
    r("{{ '99999999999999999999'|int }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: 99999999999999999999 does not fit in a 64-bit integer",
  )
  // a-int-huge-neg
  assert_eq(
    r("{{ '-99999999999999999999'|int }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: -99999999999999999999 does not fit in a 64-bit integer",
  )
  // a-int-double-huge
  assert_eq(
    r("{{ 1e19|int }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: 10000000000000000000 does not fit in a 64-bit integer",
  )
  // a-int-underscore
  assert_eq(
    r("{{ '1__0'|int }}|{{ '_1'|int }}", context="{}", format=@moonpug.text),
    "0|0",
  )
}

///|
test "the percent operator on awkward input" {
  // p-named-width
  assert_eq(
    r("{{ '%(a)5s|%(a)-5s' % {'a': 'x'} }}", context="{}", format=@moonpug.text),
    "    x|x    ",
  )
  // p-star
  assert_eq(
    r("{{ '%*d|%-*d' % [4, 1, 4, 1] }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: * wants an integer",
  )
  // p-star-bad
  assert_eq(
    r("{{ '%*d' % ['x', 1] }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: * wants an integer",
  )
  // p-zero-flag
  assert_eq(
    r(
      "{{ '%05.1f|%+d|% d' % [1.5, 2, 3] }}",
      context="{}",
      format=@moonpug.text,
    ),
    "refused: <template>:1: %f format: a real number is required, not a list",
  )
  // p-hash-o
  assert_eq(r("{{ '%#o' % 8 }}", context="{}", format=@moonpug.text), "0o10")
  // p-c-str
  assert_eq(
    r("{{ '%c' % 'ab' }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: %c requires an integer or a single character",
  )
  // p-c-list
  assert_eq(
    r("{{ '%c' % [1] }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: %c requires an integer or a single character",
  )
  // p-map-incomplete
  assert_eq(
    r("{{ '%(a' % {'a': 1} }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: incomplete format key",
  )
  // p-map-needed
  assert_eq(
    r("{{ '%s' % {'a': 1} }}", context="{}", format=@moonpug.text),
    "{'a': 1}",
  )
  // p-lone-percent
  assert_eq(
    r("{{ 'a%' % 'x' }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: incomplete format",
  )
  // p-nested-paren
  assert_eq(
    r("{{ '%(a(b))s' % {'a(b)': 1} }}", context="{}", format=@moonpug.text),
    "1",
  )
  // p-r
  assert_eq(r("{{ '%r' % 'a' }}", context="{}", format=@moonpug.text), "'a'")
  // p-u
  assert_eq(r("{{ '%u' % 5 }}", context="{}", format=@moonpug.text), "5")
}

///|
test "text filters on markup and on empty text" {
  // tx-wrap-tabs
  assert_eq(
    r("{{ 'a\\tb c'|wordwrap(3) }}", context="{}", format=@moonpug.text),
    "a\tb\nc",
  )
  // tx-indent-empty
  assert_eq(r("{{ ''|indent(2) }}", context="{}", format=@moonpug.text), "")
  // tx-truncate-markup
  assert_eq(
    r("{{ '<b>x</b>'|safe|truncate(5) }}", context="{}", format=@moonpug.html),
    "<b>x</b>",
  )
  // tx-wordcount-markup
  assert_eq(
    r("{{ '<b>a b</b>'|safe|wordcount }}", context="{}", format=@moonpug.html),
    "4",
  )
  // tx-striptags-bad
  assert_eq(
    r("{{ '<b>a'|striptags }}", context="{}", format=@moonpug.text),
    "a",
  )
  // tx-striptags-comment
  assert_eq(
    r("{{ 'a<!-- x -->b'|striptags }}", context="{}", format=@moonpug.text),
    "ab",
  )
  // tx-capitalize-empty
  assert_eq(r("{{ ''|capitalize }}", context="{}", format=@moonpug.text), "")
  // tx-title-num
  assert_eq(
    r("{{ 'a1b CD'|title }}", context="{}", format=@moonpug.text),
    "A1b Cd",
  )
}

///|
test "dates read from text, with and without a zone" {
  // dt-week
  assert_eq(
    r("{{ '2026-03-05'|date('W o') }}", context="{}", format=@moonpug.text),
    "10 2026",
  )
  // dt-year-pad
  assert_eq(
    r("{{ '0044-03-05'|date('Y') }}", context="{}", format=@moonpug.text),
    "0044",
  )
  // dt-named
  assert_eq(
    r(
      "{{ '2026-03-05'|date('SHORT_DATETIME_FORMAT') }}",
      context="{}",
      format=@moonpug.text,
    ),
    "refused: <template>:1: the format for a date may not contain time letters, found P",
  )
  // dt-utc
  assert_eq(
    r(
      "{{ '2026-03-05T14:07:09+02:00'|date('H:i T O Z') }}",
      context="{}",
      format=@moonpug.text,
    ),
    "12:07 UTC +0000 0",
  )
  // dt-micro
  assert_eq(
    r(
      "{{ '2026-03-05T14:07:09.000123'|date('u') }}",
      context="{}",
      format=@moonpug.text,
    ),
    "000123",
  )
  // dt-lenient-letters
  assert_eq(
    r(
      "{{ '2026-03-05'|date('N j, Y \\\\a\\\\t H') }}",
      context="{}",
      format=@moonpug.text,
    ),
    "refused: <template>:1: the format for a date may not contain time letters, found H",
  )
}

///|
test "the globals every template sees" {
  // g-range2
  assert_eq(
    r("{{ range(1, 3)|list }}", context="{}", format=@moonpug.text),
    "[1, 2]",
  )
  // g-range3
  assert_eq(
    r("{{ range(0, 6, 2)|list }}", context="{}", format=@moonpug.text),
    "[0, 2, 4]",
  )
  // g-range-neg
  assert_eq(
    r("{{ range(3, 0, -1)|list }}", context="{}", format=@moonpug.text),
    "[3, 2, 1]",
  )
  // g-range-zero
  assert_eq(
    r("{{ range(1, 5, 0) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: range arg 3 must not be zero",
  )
  // g-range-args
  assert_eq(
    r("{{ range() }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: range expected 1 to 3 arguments, got 0",
  )
  // g-range-named
  assert_eq(
    r("{{ range(stop=2) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: range takes no named arguments",
  )
  // g-dict
  assert_eq(
    r("{{ dict({'a': 1}, b=2) }}", context="{}", format=@moonpug.text),
    "{'a': 1, 'b': 2}",
  )
  // g-dict-pairs
  assert_eq(
    r("{{ dict([['a', 1]]) }}", context="{}", format=@moonpug.text),
    "{'a': 1}",
  )
  // g-dict-bad
  assert_eq(
    r("{{ dict([1]) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: dict wants pairs",
  )
  // g-dict-args
  assert_eq(
    r("{{ dict(1) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: dict expected at most 1 positional argument",
  )
  // g-lipsum-bad
  assert_eq(
    r("{{ lipsum(1, true, 5, 5) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: lipsum wants max greater than min",
  )
  // g-lipsum-text
  assert_eq(
    r(
      "{{ lipsum(1, false, 3, 4)|wordcount }}",
      context="{}",
      format=@moonpug.text,
    ),
    "3",
  )
  // g-cycler-empty
  assert_eq(
    r("{{ cycler() }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: at least one item has to be provided",
  )
  // g-cycler-named
  assert_eq(
    r("{{ cycler(a=1) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: cycler takes no named arguments",
  )
  // g-cycler-reset
  assert_eq(
    r(
      "{% set c = cycler('a', 'b') %}{{ c.next() }}{{ c.reset() }}{{ c.next() }}{{ c.items }}",
      context="{}",
      format=@moonpug.text,
    ),
    "aNonea('a', 'b')",
  )
  // g-joiner
  assert_eq(
    r(
      "{% set j = joiner('-') %}{{ j() }}{{ j() }}",
      context="{}",
      format=@moonpug.text,
    ),
    "-",
  )
  // g-namespace-pprint
  assert_eq(
    r("{{ namespace(a=1) }}", context="{}", format=@moonpug.text),
    "<Namespace {'a': 1}>",
  )
  // g-gettext-nocat
  assert_eq(
    r(
      "{{ gettext('a') }}|{{ ngettext('a', 'b', 2) }}|{{ pgettext('c', 'a') }}|{{ npgettext('c', 'a', 'b', 2) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "a|b|a|b",
  )
  // g-set-attr-ns
  assert_eq(
    r(
      "{% set ns = namespace() %}{% set ns.a = 1 %}{{ ns.a }}",
      context="{}",
      format=@moonpug.text,
    ),
    "1",
  )
}

///|
test "a template rendered in one call" {
  // m-template-name
  assert_eq(r("{{ 1 }}", context="{}", format=@moonpug.text), "1")
}

///|
test "html cut where the text ends, and format strings at their edges" {
  // c-unclosed-comment
  assert_eq(
    r(
      "{{ \"<p>a<!-- x\"|truncatechars_html(5) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "<p>a&lt;!-…</p>",
  )
  // c-unclosed-decl
  assert_eq(
    r(
      "{{ \"<p>a<!doctype\"|truncatechars_html(5) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "<p>a&lt;!d…</p>",
  )
  // c-unclosed-end
  assert_eq(
    r(
      "{{ \"<p>a</p\"|truncatechars_html(5) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "<p>a&lt;/p",
  )
  // c-unclosed-start
  assert_eq(
    r(
      "{{ \"<p>a<b\"|truncatechars_html(5) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "<p>a&lt;b",
  )
  // c-unclosed-pi
  assert_eq(
    r(
      "{{ \"<p>a<?x\"|truncatechars_html(5) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "<p>a&lt;?x",
  )
  // c-empty-tag
  assert_eq(
    r("{{ \"<>\"|truncatechars_html(5) }}", context="{}", format=@moonpug.text),
    "&lt;&gt;",
  )
  // c-comment-then
  assert_eq(
    r(
      "{{ \"a<!-- b -->c\"|truncatechars_html(5) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "ac",
  )
  // c-decl
  assert_eq(
    r(
      "{{ \"a<!DOCTYPE html>b\"|truncatechars_html(5) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "ab",
  )
  // c-void-close
  assert_eq(
    r(
      "{{ \"a<br></br>b\"|truncatechars_html(5) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "a<br>b",
  )
  // c-self-close-div
  assert_eq(
    r(
      "{{ \"a<div/>b\"|truncatechars_html(5) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "a<div/></div>b",
  )
  // c-big-length
  assert_eq(
    r(
      "{{ \"abcdef\"|truncatechars_html(5) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "abcd…",
  )
  // s-format-markup
  assert_eq(
    r("{{ '{}'.format('<b>'|safe) }}", context="{}", format=@moonpug.text),
    "<b>",
  )
  // s-attr-unknown
  assert_eq(
    r("{{ '{0.nope}'.format(1) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: no attribute named nope",
  )
  // s-name-unknown
  assert_eq(
    r("{{ '{nope}'.format() }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: nope is undefined",
  )
  // s-spec-noprecision
  assert_eq(
    r("{{ '{:.}'.format(1.5) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: format specifier missing precision",
  )
  // s-spec-invalid
  assert_eq(
    r("{{ '{:@{'.format(1) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: expected '}' before end of string",
  )
  // s-gen-float
  assert_eq(
    r("{{ '{:g}'.format(1e20) }}", context="{}", format=@moonpug.text),
    "1e+20",
  )
  // s-int-upper
  assert_eq(
    r("{{ '{:X}'.format(255) }}", context="{}", format=@moonpug.text),
    "FF",
  )
  // s-gen-comma
  assert_eq(
    r("{{ '{:,.2f}'.format(1234.5) }}", context="{}", format=@moonpug.text),
    "1,234.50",
  )
  // s-unsupported
  assert_eq(
    r("{{ '{:d}'.format(none) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: unsupported format string passed to none",
  )
  // s-empty-spec
  assert_eq(r("{{ '{:}'.format(1) }}", context="{}", format=@moonpug.text), "1")
  // s-nested-braces
  assert_eq(
    r("{{ '{{}}'.format() }}", context="{}", format=@moonpug.text),
    "{}",
  )
  // s-index-oob
  assert_eq(
    r("{{ '{1}'.format(1) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: replacement index 1 out of range for positional args tuple",
  )
  // s-conv-and-spec
  assert_eq(
    r("{{ '{0!r:>5}'.format('a') }}", context="{}", format=@moonpug.text),
    "  'a'",
  )
}
