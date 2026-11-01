///|
test "strings formatted with python's own format method" {
  // f-empty
  assert_eq(r("{{ '{}'.format(1) }}", context="{}", format=@moonpug.text), "1")
  // f-pos
  assert_eq(
    r(
      "{{ '{0} {1} {0}'.format('a', 'b') }}",
      context="{}",
      format=@moonpug.text,
    ),
    "a b a",
  )
  // f-name
  assert_eq(
    r("{{ '{a}-{b}'.format(a=1, b=2) }}", context="{}", format=@moonpug.text),
    "1-2",
  )
  // f-conv
  assert_eq(
    r("{{ '{!r}|{!s}'.format('x', 'y') }}", context="{}", format=@moonpug.text),
    "'x'|y",
  )
  // f-conv-a
  assert_eq(
    r("{{ '{!a}'.format('é') }}", context="{}", format=@moonpug.text),
    "'\\xe9'",
  )
  // f-conv-bad
  assert_eq(
    r("{{ '{!z}'.format(1) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: unknown conversion specifier z",
  )
  // f-align
  assert_eq(
    r(
      "{{ '{:>5}|{:<5}|{:^5}'.format('a', 'b', 'c') }}",
      context="{}",
      format=@moonpug.text,
    ),
    "    a|b    |  c  ",
  )
  // f-fill
  assert_eq(
    r("{{ '{:*^7}'.format('ab') }}", context="{}", format=@moonpug.text),
    "**ab***",
  )
  // f-num
  assert_eq(
    r(
      "{{ '{:+d} {: d} {:05d}'.format(1, 2, -3) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "+1  2 -0003",
  )
  // f-float
  assert_eq(
    r(
      "{{ '{:.2f} {:e} {:g}'.format(3.14159, 1234.5, 0.0001) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "3.14 1.234500e+03 0.0001",
  )
  // f-percent
  assert_eq(
    r("{{ '{:.1%}'.format(0.256) }}", context="{}", format=@moonpug.text),
    "25.6%",
  )
  // f-group
  assert_eq(
    r("{{ '{:,}'.format(1234567) }}", context="{}", format=@moonpug.text),
    "1,234,567",
  )
  // f-hex
  assert_eq(
    r(
      "{{ '{:x} {:X} {:o} {:b}'.format(255, 255, 8, 5) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "ff FF 10 101",
  )
  // f-general
  assert_eq(
    r("{{ '{:.2}'.format(1234.5) }}", context="{}", format=@moonpug.text),
    "1.2e+03",
  )
  // f-int-general
  assert_eq(
    r("{{ '{:g}'.format(2.0) }}", context="{}", format=@moonpug.text),
    "2",
  )
  // f-spec-str
  assert_eq(
    r("{{ '{:d}'.format('a') }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: unknown format code d for object of type 'str'",
  )
  // f-precision-int
  assert_eq(
    r("{{ '{:.2d}'.format(1) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: precision not allowed in integer format specifier",
  )
  // f-brace-open
  assert_eq(
    r("{{ '{'.format() }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: expected '}' before end of string",
  )
  // f-brace-close
  assert_eq(
    r("{{ '}'.format() }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: single '}' encountered in format string",
  )
  // f-unclosed
  assert_eq(
    r("{{ '{0'.format(1) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: expected '}' before end of string",
  )
  // f-no-colon
  assert_eq(
    r("{{ '{0!r}'.format(1) }}", context="{}", format=@moonpug.text),
    "1",
  )
  // f-field-missing
  assert_eq(
    r("{{ '{0}'.format() }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: replacement index 0 out of range for positional args tuple",
  )
  // f-name-missing
  assert_eq(
    r("{{ '{a}'.format() }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: a is undefined",
  )
  // f-index
  assert_eq(
    r("{{ '{0[1]}'.format([1, 2]) }}", context="{}", format=@moonpug.text),
    "2",
  )
  // f-index-unclosed
  assert_eq(
    r("{{ '{0[1}'.format([1]) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: missing ']' in format string",
  )
  // f-attr
  assert_eq(
    r("{{ '{0.real}'.format(1) }}", context="{}", format=@moonpug.text),
    "1",
  )
  // f-bad-conv-after
  assert_eq(
    r("{{ '{!}'.format(1) }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: end of string while looking for conversion specifier",
  )
}

///|
test "operators on numbers, text and sequences" {
  // op-floordiv
  assert_eq(
    r(
      "{{ 7 // 2 }}|{{ -7 // 2 }}|{{ 7.5 // 2 }}",
      context="{}",
      format=@moonpug.text,
    ),
    "3|-4|3.0",
  )
  // op-mod
  assert_eq(
    r(
      "{{ 7 % 3 }}|{{ -7 % 3 }}|{{ 7 % -3 }}",
      context="{}",
      format=@moonpug.text,
    ),
    "1|2|-2",
  )
  // op-pow
  assert_eq(
    r(
      "{{ 2 ** 10 }}|{{ 2 ** -1 }}|{{ 4 ** 0.5 }}",
      context="{}",
      format=@moonpug.text,
    ),
    "1024|0.5|2.0",
  )
  // op-pow-complex
  assert_eq(r("{{ -8 ** (1 / 3) }}", context="{}", format=@moonpug.text), "nan")
  // op-div-zero
  assert_eq(
    r("{{ 1 / 0 }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: division by zero",
  )
  // op-floordiv-zero
  assert_eq(
    r("{{ 1 // 0 }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: integer division or modulo by zero",
  )
  // op-mod-zero
  assert_eq(
    r("{{ 1 % 0 }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: integer division or modulo by zero",
  )
  // op-mul-str
  assert_eq(
    r("{{ 'ab' * 2 }}|{{ 2 * 'ab' }}", context="{}", format=@moonpug.text),
    "abab|abab",
  )
  // op-mul-seq
  assert_eq(r("{{ [1] * 2 }}", context="{}", format=@moonpug.text), "[1, 1]")
  // op-add-seq
  assert_eq(
    r("{{ [1] + [2] }}|{{ (1,) + (2,) }}", context="{}", format=@moonpug.text),
    "[1, 2]|(1, 2)",
  )
  // op-add-mixed
  assert_eq(
    r("{{ 'a' + 1 }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: unsupported operand types for +: a string and an integer",
  )
  // op-sub-str
  assert_eq(
    r("{{ 'a' - 'b' }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: unsupported operand types for -: a string and a string",
  )
  // op-concat
  assert_eq(
    r("{{ 'a' ~ 1 ~ [2] }}", context="{}", format=@moonpug.text),
    "a1[2]",
  )
  // op-concat-none
  assert_eq(r("{{ 'a' ~ none }}", context="{}", format=@moonpug.text), "aNone")
  // op-neg
  assert_eq(
    r("{{ -1 }}|{{ -1.5 }}", context="{}", format=@moonpug.text),
    "-1|-1.5",
  )
  // op-neg-str
  assert_eq(
    r("{{ -'a' }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: bad operand type for unary -: a string",
  )
  // op-pos
  assert_eq(r("{{ +1 }}", context="{}", format=@moonpug.text), "1")
  // op-pos-str
  assert_eq(
    r("{{ +'a' }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: bad operand type for unary +: a string",
  )
  // op-not
  assert_eq(
    r("{{ not 0 }}|{{ not 'a' }}", context="{}", format=@moonpug.text),
    "True|False",
  )
  // op-chain
  assert_eq(
    r("{{ 1 < 2 < 3 }}|{{ 1 < 2 > 3 }}", context="{}", format=@moonpug.text),
    "True|False",
  )
  // op-in
  assert_eq(
    r(
      "{{ 'a' not in 'b' }}|{{ 3 in [1, 2] }}",
      context="{}",
      format=@moonpug.text,
    ),
    "True|False",
  )
  // op-mixed-cmp
  assert_eq(
    r("{{ 1 < 'a' }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: an integer and a string cannot be compared",
  )
  // op-none-cmp
  assert_eq(
    r("{{ none < 1 }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: none and an integer cannot be compared",
  )
  // op-cond
  assert_eq(
    r("{{ 1 if 0 else 2 }}|{{ 'a' if 1 }}", context="{}", format=@moonpug.text),
    "2|a",
  )
  // op-slice
  assert_eq(
    r(
      "{{ x[1:3] }}|{{ x[::2] }}|{{ x[::-1] }}|{{ x[5:] }}",
      context="{\"x\": [1, 2, 3, 4]}",
      format=@moonpug.text,
    ),
    "[2, 3]|[1, 3]|[4, 3, 2, 1]|[]",
  )
  // op-slice-str
  assert_eq(
    r(
      "{{ 'abcdef'[1:3] }}|{{ 'abc'[::-1] }}",
      context="{}",
      format=@moonpug.text,
    ),
    "bc|cba",
  )
  // op-slice-bad
  assert_eq(
    r("{{ [1][1.5:] }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: slice indices must be integers or None",
  )
  // op-index-neg
  assert_eq(
    r("{{ x[-1] }}", context="{\"x\": [1, 2]}", format=@moonpug.text),
    "2",
  )
  // op-index-bad
  assert_eq(
    r("{{ x['a'] }}", context="{\"x\": [1]}", format=@moonpug.text),
    "refused: <template>:1: a is undefined",
  )
  // op-index-missing
  assert_eq(
    r("{{ x[5] }}", context="{\"x\": [1]}", format=@moonpug.text),
    "refused: <template>:1: 5 is undefined",
  )
}

///|
test "sequence filters" {
  // seq-sort-attr
  assert_eq(
    r(
      "{{ x|sort(attribute='n')|map(attribute='n')|join(',') }}",
      context="{\"x\": [{\"n\": 2}, {\"n\": 1}]}",
      format=@moonpug.text,
    ),
    "1,2",
  )
  // seq-sort-reverse
  assert_eq(
    r(
      "{{ [2, 1]|sort(reverse=true)|join(',') }}",
      context="{}",
      format=@moonpug.text,
    ),
    "2,1",
  )
  // seq-sort-case
  assert_eq(
    r(
      "{{ ['B', 'a']|sort(case_sensitive=true)|join(',') }}",
      context="{}",
      format=@moonpug.text,
    ),
    "B,a",
  )
  // seq-map-attr
  assert_eq(
    r(
      "{{ x|map(attribute='n')|join(',') }}",
      context="{\"x\": [{\"n\": 1}, {\"n\": 2}]}",
      format=@moonpug.text,
    ),
    "1,2",
  )
  // seq-map-default
  assert_eq(
    r(
      "{{ x|map(attribute='n', default=0)|join(',') }}",
      context="{\"x\": [{\"n\": 1}, {}]}",
      format=@moonpug.text,
    ),
    "1,0",
  )
  // seq-map-filter
  assert_eq(
    r(
      "{{ ['a', 'b']|map('upper')|join(',') }}",
      context="{}",
      format=@moonpug.text,
    ),
    "A,B",
  )
  // seq-select-test
  assert_eq(
    r(
      "{{ [1, 2, 3]|select('odd')|join(',') }}",
      context="{}",
      format=@moonpug.text,
    ),
    "1,3",
  )
  // seq-reject-attr
  assert_eq(
    r(
      "{{ x|rejectattr('n')|length }}",
      context="{\"x\": [{\"n\": 1}, {\"n\": 0}]}",
      format=@moonpug.text,
    ),
    "1",
  )
  // seq-selectattr-eq
  assert_eq(
    r(
      "{{ x|selectattr('n', 'eq', 1)|length }}",
      context="{\"x\": [{\"n\": 1}, {\"n\": 2}]}",
      format=@moonpug.text,
    ),
    "1",
  )
  // seq-batch
  assert_eq(
    r("{{ [1, 2, 3]|batch(2) }}", context="{}", format=@moonpug.text),
    "[[1, 2], [3]]",
  )
  // seq-batch-fill
  assert_eq(
    r("{{ [1, 2, 3]|batch(2, 0) }}", context="{}", format=@moonpug.text),
    "[[1, 2], [3, 0]]",
  )
  // seq-slice
  assert_eq(
    r("{{ [1, 2, 3, 4]|slice(3)|list }}", context="{}", format=@moonpug.text),
    "[[1, 2], [3], [4]]",
  )
  // seq-slice-fill
  assert_eq(
    r("{{ [1, 2, 3, 4]|slice(3, 0)|list }}", context="{}", format=@moonpug.text),
    "[[1, 2], [3, 0], [4, 0]]",
  )
  // seq-dictsort
  assert_eq(
    r("{{ {'b': 1, 'a': 2}|dictsort }}", context="{}", format=@moonpug.text),
    "[('a', 2), ('b', 1)]",
  )
  // seq-dictsort-attr
  assert_eq(
    r(
      "{{ x|dictsort(by='value')|first }}",
      context="{\"x\": {\"b\": 1, \"a\": 2}}",
      format=@moonpug.text,
    ),
    "('b', 1)",
  )
  // seq-dictsort-case
  assert_eq(
    r(
      "{{ {'B': 1, 'a': 2}|dictsort(case_sensitive=true) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "[('B', 1), ('a', 2)]",
  )
  // seq-groupby
  assert_eq(
    r(
      "{{ x|groupby('n')|map(attribute='grouper')|join(',') }}",
      context="{\"x\": [{\"n\": 1}, {\"n\": 1}, {\"n\": 2}]}",
      format=@moonpug.text,
    ),
    "1,2",
  )
  // seq-sum-attr
  assert_eq(
    r(
      "{{ x|sum(attribute='n') }}",
      context="{\"x\": [{\"n\": 1}, {\"n\": 2}]}",
      format=@moonpug.text,
    ),
    "3",
  )
  // seq-sum-start
  assert_eq(
    r("{{ [1, 2]|sum(start=10) }}", context="{}", format=@moonpug.text),
    "13",
  )
  // seq-min-attr
  assert_eq(
    r(
      "{{ x|min(attribute='n')|string }}",
      context="{\"x\": [{\"n\": 2}, {\"n\": 1}]}",
      format=@moonpug.text,
    ),
    "{'n': 1}",
  )
  // seq-unique-attr
  assert_eq(
    r(
      "{{ x|unique(attribute='n')|length }}",
      context="{\"x\": [{\"n\": 1}, {\"n\": 1}]}",
      format=@moonpug.text,
    ),
    "1",
  )
  // seq-join-attr
  assert_eq(
    r(
      "{{ x|join(',', attribute='n') }}",
      context="{\"x\": [{\"n\": 1}, {\"n\": 2}]}",
      format=@moonpug.text,
    ),
    "1,2",
  )
  // seq-first-empty
  assert_eq(
    r("{{ []|first }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: no first item, the sequence was empty is undefined",
  )
  // seq-last-empty
  assert_eq(
    r("{{ []|last }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: no last item, the sequence was empty is undefined",
  )
  // seq-max-empty
  assert_eq(
    r("{{ []|max }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: no aggregated item, the sequence was empty is undefined",
  )
  // seq-map-noname
  assert_eq(
    r("{{ [1]|map() }}", context="{}", format=@moonpug.text),
    "refused: <template>:1: map requires a filter argument",
  )
}

///|
test "web and text filters" {
  // web-urlize
  assert_eq(
    r(
      "{{ 'see http://a.example/x?a=1 now'|urlize }}",
      context="{}",
      format=@moonpug.text,
    ),
    "see <a href=\"http://a.example/x?a=1\" rel=\"noopener\">http://a.example/x?a=1</a> now",
  )
  // web-urlize-nofollow
  assert_eq(
    r(
      "{{ 'http://a.example'|urlize(nofollow=true) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "<a href=\"http://a.example\" rel=\"nofollow noopener\">http://a.example</a>",
  )
  // web-urlize-target
  assert_eq(
    r(
      "{{ 'http://a.example'|urlize(target='_blank') }}",
      context="{}",
      format=@moonpug.text,
    ),
    "<a href=\"http://a.example\" rel=\"noopener\" target=\"_blank\">http://a.example</a>",
  )
  // web-urlize-trim
  assert_eq(
    r(
      "{{ 'http://a.example/averylongpath'|urlize(trim_url_limit=10) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "<a href=\"http://a.example/averylongpath\" rel=\"noopener\">http://a.e...</a>",
  )
  // web-striptags
  assert_eq(
    r(
      "{{ '<b>a</b> &amp; <i>b</i>'|striptags }}",
      context="{}",
      format=@moonpug.text,
    ),
    "a & b",
  )
  // web-xmlattr
  assert_eq(
    r(
      "{{ {'a': 1, 'b': none, 'c': 'x'}|xmlattr }}",
      context="{}",
      format=@moonpug.text,
    ),
    " a=\"1\" c=\"x\"",
  )
  // web-urlencode
  assert_eq(
    r("{{ 'a b/c?d'|urlencode }}", context="{}", format=@moonpug.text),
    "a%20b/c%3Fd",
  )
  // web-filesize
  assert_eq(
    r(
      "{{ 100|filesizeformat }}|{{ 1000|filesizeformat(true) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "100 Bytes|1000 Bytes",
  )
  // web-indent
  assert_eq(
    r("{{ 'a\\nb'|indent(2, true) }}", context="{}", format=@moonpug.text),
    "  a\n  b",
  )
  // web-indent-first
  assert_eq(
    r("{{ 'a\\nb'|indent(2, true, true) }}", context="{}", format=@moonpug.text),
    "  a\n  b",
  )
  // web-wordwrap
  assert_eq(
    r("{{ 'aaa bbb'|wordwrap(3) }}", context="{}", format=@moonpug.text),
    "aaa\nbbb",
  )
  // web-wordwrap-break
  assert_eq(
    r(
      "{{ 'aaaaa'|wordwrap(3, break_long_words=true) }}",
      context="{}",
      format=@moonpug.text,
    ),
    "aaa\naa",
  )
}

///|
test "the indentation syntax beyond the basics" {
  // pp-plaintext
  assert_eq(
    r("| plain #{x}", context="{\"x\": 1}", format=@moonpug.pug),
    "plain 1",
  )
  // pp-pipe
  assert_eq(
    r("p\n  | one\n  | two", context="{}", format=@moonpug.pug),
    "<p>one\ntwo</p>",
  )
  // pp-block-expand
  assert_eq(r("p: b x", context="{}", format=@moonpug.pug), "<p><b>x</b></p>")
  // pp-each-else
  assert_eq(
    r("each x in []\n  p= x\nelse\n  p none", context="{}", format=@moonpug.pug),
    "<p>none</p>",
  )
  // pp-mixin-rest
  assert_eq(
    r(
      "mixin m(a, ...rest)\n  p= rest\n+m(1, 2)",
      context="{}",
      format=@moonpug.pug,
    ),
    "<p>[2]</p>",
  )
  // pp-mixin-attrs
  assert_eq(
    r(
      "mixin m()\n  p&attributes(attributes)\n+m()(a='1')",
      context="{}",
      format=@moonpug.pug,
    ),
    "<p a=\"1\"></p>",
  )
  // pp-case-multi
  assert_eq(
    r("case 2\n  when 1, 2\n    p two", context="{}", format=@moonpug.pug),
    "<p>two</p>",
  )
  // pp-when-default
  assert_eq(
    r(
      "case 9\n  when 1\n    p one\n  default\n    p d",
      context="{}",
      format=@moonpug.pug,
    ),
    "<p>d</p>",
  )
  // pp-text-only
  assert_eq(
    r("p.\n  a\n\n  b", context="{}", format=@moonpug.pug),
    "<p>a\n\nb</p>",
  )
  // pp-tag-inline
  assert_eq(
    r("p a #[b c] d", context="{}", format=@moonpug.pug),
    "<p>a <b>c</b> d</p>",
  )
  // pp-comment-cond
  assert_eq(r("//- note\np x", context="{}", format=@moonpug.pug), "<p>x</p>")
  // pp-doctype-xml
  assert_eq(
    r("doctype xml", context="{}", format=@moonpug.pug),
    "<?xml version=\"1.0\" encoding=\"utf-8\" ?>",
  )
  // pp-attr-block-empty
  assert_eq(r("p&attributes({})", context="{}", format=@moonpug.pug), "<p></p>")
  // pp-bool-attr
  assert_eq(
    r("input(checked=true, disabled=false)", context="{}", format=@moonpug.pug),
    "<input checked=\"checked\"/>",
  )
  // pp-attr-null
  assert_eq(r("p(a=null)", context="{}", format=@moonpug.pug), "<p></p>")
  // pp-class-array
  assert_eq(
    r("p(class=['a', 'b'])", context="{}", format=@moonpug.pug),
    "<p class=\"a b\"></p>",
  )
  // pp-style
  assert_eq(
    r("p(style={'a': 'b'})", context="{}", format=@moonpug.pug),
    "<p style=\"a:b;\"></p>",
  )
}
