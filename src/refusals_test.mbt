///|
test "format strings through the percent operator" {
  // fmt-f
  assert_eq(r("{{ '%5.2f'|format(3.14159) }}", context="{}"), " 3.14")
  // fmt-d-float
  assert_eq(r("{{ '%d'|format(1.5) }}", context="{}"), "1")
  // fmt-sr
  assert_eq(r("{{ '%s %r'|format('a', 'b') }}", context="{}"), "a &#39;b&#39;")
  // fmt-named
  assert_eq(r("{{ '%(a)s %(b)d'|format(a='x', b=2) }}", context="{}"), "x 2")
  // fmt-pad
  assert_eq(
    r("{{ '%05d|%-4d|%+d'|format(-3, 7, 2) }}", context="{}"),
    "-0003|7   |+2",
  )
  // fmt-hex
  assert_eq(
    r(
      "{{ '%x %X %o %e %g'|format(255, 255, 8, 1234.5, 0.0001) }}",
      context="{}",
    ),
    "ff FF 10 1.234500e+03 0.0001",
  )
  // fmt-c
  assert_eq(r("{{ '%c%c'|format(65, 'b') }}", context="{}"), "Ab")
  // fmt-c-bad
  assert_eq(
    r("{{ '%c'|format(1114112) }}", context="{}"),
    "refused: <template>:1: %c arg not in range(0x110000)",
  )
  // fmt-c-surrogate
  assert_eq(
    r("{{ '%c'|format(55296) }}", context="{}"),
    "refused: <template>:1: a lone surrogate 55296 cannot be written",
  )
  // fmt-unknown
  assert_eq(
    r("{{ '%z'|format(1) }}", context="{}"),
    "refused: <template>:1: unsupported format character z",
  )
  // fmt-star
  assert_eq(r("{{ '%*d'|format(4, 1) }}", context="{}"), "   1")
  // fmt-star-float
  assert_eq(r("{{ '%.*f'|format(2, 1.5) }}", context="{}"), "1.50")
  // fmt-too-few
  assert_eq(
    r("{{ '%s %s'|format('a') }}", context="{}"),
    "refused: <template>:1: not enough arguments for format string",
  )
}

///|
test "the percent operator on text" {
  // pct-s
  assert_eq(r("{{ 'a %s b' % 'x' }}", context="{}"), "a x b")
  // pct-tuple
  assert_eq(
    r("{{ '%s-%s' % ['a', 'b'] }}", context="{}"),
    "refused: <template>:1: not enough arguments for format string",
  )
  // pct-dict
  assert_eq(r("{{ '%(k)s!' % {'k': 'v'} }}", context="{}"), "v!")
  // pct-int
  assert_eq(r("{{ '%d apples' % 3 }}", context="{}"), "3 apples")
  // pct-float-d
  assert_eq(r("{{ '%d' % 1.9 }}", context="{}"), "1")
  // pct-bad
  assert_eq(
    r("{{ '%d' % 'x' }}", context="{}"),
    "refused: <template>:1: %d format: a number is required, not a string",
  )
  // pct-too-many
  assert_eq(
    r("{{ '%s' % ['a', 'b'] }}", context="{}"),
    "[&#39;a&#39;, &#39;b&#39;]",
  )
}

///|
test "string methods" {
  // str-split
  assert_eq(
    r("{{ 'a b  c'.split() }}", context="{}"),
    "[&#39;a&#39;, &#39;b&#39;, &#39;c&#39;]",
  )
  // str-split-sep
  assert_eq(
    r("{{ 'a,b,,c'.split(',') }}", context="{}"),
    "[&#39;a&#39;, &#39;b&#39;, &#39;&#39;, &#39;c&#39;]",
  )
  // str-split-max
  assert_eq(
    r("{{ 'a,b,c'.split(',', 1) }}", context="{}"),
    "[&#39;a&#39;, &#39;b,c&#39;]",
  )
  // str-rsplit
  assert_eq(
    r("{{ 'a,b,c'.rsplit(',', 1) }}", context="{}"),
    "[&#39;a,b&#39;, &#39;c&#39;]",
  )
  // str-splitlines
  assert_eq(
    r("{{ 'a\\nb\\r\\nc'.splitlines() }}", context="{}"),
    "[&#39;a&#39;, &#39;b&#39;, &#39;c&#39;]",
  )
  // str-splitlines-keep
  assert_eq(
    r("{{ 'a\\nb\\n'.splitlines(true) }}", context="{}"),
    "[&#39;a\\n&#39;, &#39;b\\n&#39;]",
  )
  // str-partition
  assert_eq(
    r("{{ 'a=b=c'.partition('=') }}", context="{}"),
    "(&#39;a&#39;, &#39;=&#39;, &#39;b=c&#39;)",
  )
  // str-rpartition
  assert_eq(
    r("{{ 'a=b=c'.rpartition('=') }}", context="{}"),
    "(&#39;a=b&#39;, &#39;=&#39;, &#39;c&#39;)",
  )
  // str-strip
  assert_eq(
    r("{{ '  a  '.strip() }}|{{ 'xxaxx'.strip('x') }}", context="{}"),
    "a|a",
  )
  // str-lstrip-rstrip
  assert_eq(r("{{ '  a'.lstrip() }}|{{ 'a  '.rstrip() }}", context="{}"), "a|a")
  // str-replace-count
  assert_eq(r("{{ 'aaa'.replace('a', 'b', 2) }}", context="{}"), "bba")
  // str-startswith
  assert_eq(
    r("{{ 'abc'.startswith('ab') }}|{{ 'abc'.endswith('c') }}", context="{}"),
    "True|True",
  )
  // str-startswith-tuple
  assert_eq(r("{{ 'abc'.startswith(('x', 'a')) }}", context="{}"), "True")
  // str-find
  assert_eq(
    r(
      "{{ 'abc'.find('c') }}|{{ 'abc'.rfind('a') }}|{{ 'abc'.find('z') }}",
      context="{}",
    ),
    "2|0|-1",
  )
  // str-index
  assert_eq(
    r("{{ 'abc'.index('z') }}", context="{}"),
    "refused: <template>:1: substring not found",
  )
  // str-rindex
  assert_eq(
    r("{{ 'abcabc'.rindex('z') }}", context="{}"),
    "refused: <template>:1: substring not found",
  )
  // str-count
  assert_eq(r("{{ 'aa'.count('a') }}", context="{}"), "2")
  // str-zfill
  assert_eq(
    r("{{ '7'.zfill(3) }}|{{ '-7'.zfill(3) }}", context="{}"),
    "007|-07",
  )
  // str-expandtabs
  assert_eq(r("{{ 'a\\tb'.expandtabs(4) }}", context="{}"), "a   b")
  // str-expandtabs-bad
  assert_eq(
    r("{{ 'a'.expandtabs('x') }}", context="{}"),
    "refused: <template>:1: expandtabs takes one integer",
  )
  // str-format-map
  assert_eq(r("{{ '{a}'.format_map({'a': 1}) }}", context="{}"), "1")
  // str-format-map-bad
  assert_eq(
    r("{{ '{a}'.format_map(1) }}", context="{}"),
    "refused: <template>:1: format_map takes one mapping",
  )
  // str-isalpha
  assert_eq(
    r(
      "{{ 'ab'.isalpha() }}|{{ '1'.isdigit() }}|{{ ' '.isspace() }}",
      context="{}",
    ),
    "True|True|True",
  )
  // str-join
  assert_eq(r("{{ '-'.join(['a', 'b']) }}", context="{}"), "a-b")
  // str-upper-method
  assert_eq(r("{{ 'a'.upper() }}|{{ 'A'.lower() }}", context="{}"), "A|a")
}

///|
test "dict methods" {
  // dict-pop
  assert_eq(
    r("{% set d = {'a': 1} %}{{ d.pop('a') }}{{ d }}", context="{}"),
    "1{}",
  )
  // dict-pop-default
  assert_eq(r("{{ {'a': 1}.pop('z', 9) }}", context="{}"), "9")
  // dict-pop-missing
  assert_eq(
    r("{{ {'a': 1}.pop('z') }}", context="{}"),
    "refused: <template>:1: no key named z",
  )
  // dict-pop-args
  assert_eq(
    r("{{ {'a': 1}.pop() }}", context="{}"),
    "refused: <template>:1: pop expected one or two arguments",
  )
  // dict-setdefault
  assert_eq(
    r(
      "{% set d = {} %}{{ d.setdefault('a', 1) }}{{ d.setdefault('a', 2) }}",
      context="{}",
    ),
    "11",
  )
  // dict-setdefault-args
  assert_eq(
    r("{{ {}.setdefault() }}", context="{}"),
    "refused: <template>:1: setdefault expected one or two arguments",
  )
  // dict-update
  assert_eq(
    r("{% set d = {'a': 1} %}{{ d.update({'b': 2}) }}{{ d }}", context="{}"),
    "None{&#39;a&#39;: 1, &#39;b&#39;: 2}",
  )
  // dict-update-bad
  assert_eq(
    r("{{ {}.update([1]) }}", context="{}"),
    "refused: <template>:1: update wants pairs",
  )
  // dict-keys-values-items
  assert_eq(
    r(
      "{{ {'a': 1}.keys() }}|{{ {'a': 1}.values() }}|{{ {'a': 1}.items() }}",
      context="{}",
    ),
    "[&#39;a&#39;]|[1]|[(&#39;a&#39;, 1)]",
  )
}

///|
test "list methods" {
  // list-pop
  assert_eq(r("{% set l = [1, 2] %}{{ l.pop() }}{{ l }}", context="{}"), "2[1]")
  // list-pop-index
  assert_eq(r("{% set l = [1, 2] %}{{ l.pop(0) }}", context="{}"), "1")
  // list-pop-bad
  assert_eq(
    r("{{ [1].pop(5) }}", context="{}"),
    "refused: <template>:1: pop index out of range",
  )
  // list-pop-args
  assert_eq(
    r("{{ [1].pop(1, 2) }}", context="{}"),
    "refused: <template>:1: pop expected at most one integer",
  )
  // list-sort
  assert_eq(
    r("{% set l = [3, 1] %}{{ l.sort() }}{{ l }}", context="{}"),
    "None[1, 3]",
  )
  // list-sort-args
  assert_eq(
    r("{{ [1].sort(1) }}", context="{}"),
    "refused: <template>:1: sort takes no positional arguments",
  )
  // list-sort-key
  assert_eq(
    r(
      "{% set l = ['bb', 'a'] %}{{ l.sort(key='length') }}{{ l }}",
      context="{}",
    ),
    "refused: <template>:1: sort got an unexpected argument key",
  )
  // list-append-extend
  assert_eq(
    r(
      "{% set l = [] %}{{ l.append(1) }}{{ l.extend([2, 3]) }}{{ l }}",
      context="{}",
    ),
    "NoneNone[1, 2, 3]",
  )
  // list-index
  assert_eq(r("{{ [1, 2].index(2) }}", context="{}"), "1")
  // list-insert
  assert_eq(
    r("{% set l = [1] %}{{ l.insert(0, 0) }}{{ l }}", context="{}"),
    "None[0, 1]",
  )
  // list-remove
  assert_eq(
    r("{% set l = [1, 2] %}{{ l.remove(1) }}{{ l }}", context="{}"),
    "None[2]",
  )
  // list-clear
  assert_eq(
    r("{% set l = [1] %}{{ l.clear() }}{{ l }}", context="{}"),
    "None[]",
  )
  // list-count
  assert_eq(r("{{ [1, 1].count(1) }}", context="{}"), "2")
  // list-reverse
  assert_eq(
    r("{% set l = [1, 2] %}{{ l.reverse() }}{{ l }}", context="{}"),
    "None[2, 1]",
  )
}

///|
test "values compared, searched and printed" {
  // val-kind
  assert_eq(
    r(
      "{{ 1|string }}|{{ true|string }}|{{ 1.5|string }}|{{ none|string }}",
      context="{}",
    ),
    "1|True|1.5|None",
  )
  // val-pprint
  assert_eq(
    r("{{ {'a': [1, 'x']}|pprint }}", context="{}"),
    "{&#39;a&#39;: [1, &#39;x&#39;]}",
  )
  // val-truthy
  assert_eq(
    r(
      "{{ 0|string }}|{{ ''|string }}|{{ []|string }}|{{ {}|string }}",
      context="{}",
    ),
    "0||[]|{}",
  )
  // val-eq
  assert_eq(
    r("{{ 1 == 1.0 }}|{{ [1] == (1,) }}|{{ none == false }}", context="{}"),
    "True|False|False",
  )
  // val-lt
  assert_eq(
    r("{{ 'a' < 'b' }}|{{ [1] < [1, 2] }}|{{ 1 < 2.5 }}", context="{}"),
    "True|True|True",
  )
  // val-in
  assert_eq(
    r("{{ 'a' in 'abc' }}|{{ 1 in [1] }}|{{ 'a' in {'a': 1} }}", context="{}"),
    "True|True|True",
  )
  // val-in-bad
  assert_eq(
    r("{{ 1 in 2 }}", context="{}"),
    "refused: <template>:1: an integer cannot be searched with in",
  )
  // val-item-obj
  assert_eq(r("{{ ns['a'] }}", context="{\"ns\": {\"a\": 1}}"), "1")
  // val-path
  assert_eq(r("{{ x.a.b }}", context="{\"x\": {\"a\": {\"b\": 2}}}"), "2")
}

///|
test "macros and calls" {
  // macro-default
  assert_eq(
    r(
      "{% macro m(a, b=2) %}{{ a }}{{ b }}{% endmacro %}{{ m(1) }}",
      context="{}",
    ),
    "12",
  )
  // macro-varargs
  assert_eq(
    r(
      "{% macro m(a) %}{{ a }}{{ varargs }}{% endmacro %}{{ m(1, 2, 3) }}",
      context="{}",
    ),
    "1(2, 3)",
  )
  // macro-rest
  assert_eq(
    r(
      "{% macro m(a, ...rest) %}{{ a }}{{ rest }}{% endmacro %}{{ m(1, 2, 3) }}",
      context="{}",
    ),
    "1[2, 3]",
  )
  // macro-kwargs
  assert_eq(
    r("{% macro m() %}{{ kwargs }}{% endmacro %}{{ m(a=1) }}", context="{}"),
    "{&#39;a&#39;: 1}",
  )
  // macro-dup-param
  assert_eq(
    r("{% macro m(a, a) %}{% endmacro %}", context="{}"),
    "refused: <template>:1:16: duplicate parameter a",
  )
  // macro-default-then-plain
  assert_eq(
    r("{% macro m(a=1, b) %}{% endmacro %}", context="{}"),
    "refused: <template>:1:18: a parameter without a default follows one with a default",
  )
  // macro-two-values
  assert_eq(
    r("{% macro m(a) %}{{ a }}{% endmacro %}{{ m(1, a=2) }}", context="{}"),
    "refused: <template>:1: macro 'm' got multiple values for argument 'a'",
  )
  // macro-caller
  assert_eq(
    r(
      "{% macro m() %}[{{ caller() }}]{% endmacro %}{% call m() %}in{% endcall %}",
      context="{}",
    ),
    "[in]",
  )
  // macro-caller-args
  assert_eq(
    r(
      "{% macro m() %}{{ caller(1) }}{% endmacro %}{% call(x) m() %}{{ x }}{% endcall %}",
      context="{}",
    ),
    "1",
  )
  // macro-missing-arg
  assert_eq(
    r("{% macro m(a) %}{{ a }}{% endmacro %}{{ m() }}", context="{}"),
    "refused: <template>:1: a is undefined",
  )
  // macro-extra-arg
  assert_eq(
    r("{% macro m(a) %}{{ a }}{% endmacro %}{{ m(1, 2) }}", context="{}"),
    "refused: <template>:1: macro 'm' takes not more than 1 argument(s)",
  )
  // macro-unknown-name
  assert_eq(
    r("{{ nope() }}", context="{}"),
    "refused: <template>:1: nope is undefined",
  )
  // macro-duplicate
  assert_eq(
    r(
      "{% macro m() %}a{% endmacro %}{% macro m() %}b{% endmacro %}{{ m() }}",
      context="{}",
    ),
    "b",
  )
  // macro-nested-def
  assert_eq(
    r(
      "{% macro m() %}{% macro inner() %}i{% endmacro %}{{ inner() }}{% endmacro %}{{ m() }}",
      context="{}",
    ),
    "i",
  )
}

///|
test "the template seams" {
  // extends-missing
  assert_eq(
    r("{% extends 'nope' %}", context="{}"),
    "refused: <template>:1: no template named nope",
  )
  // extends-twice
  assert_eq(
    r("{% extends 'a' %}{% extends 'b' %}", context="{}"),
    "refused: <template>:1: no template named a",
  )
  // extends-not-first
  assert_eq(
    r("x{% extends 'a' %}", context="{}"),
    "refused: <template>:1: no template named a",
  )
}

///|
test "the template seams #2" {
  // include-missing
  assert_eq(
    r("{% include 'nope' %}", context="{}"),
    "refused: <template>:1: no template named nope",
  )
}

///|
test "the template seams #3" {
  // import-missing
  assert_eq(
    r("{% import 'nope' as m %}", context="{}"),
    "refused: <template>:1: no template named nope",
  )
}

///|
test "the template seams #4" {
  // from-import-missing
  assert_eq(
    r("{% from 'nope' import m %}", context="{}"),
    "refused: <template>:1: no template named nope",
  )
}

///|
test "blocks and super" {
  // super-outside
  assert_eq(
    r("{{ super() }}", context="{}"),
    "refused: <template>:1: super is undefined",
  )
}

///|
test "blocks and super #2" {
  // block-required
  assert_eq(
    r("{% block a required %}{% endblock %}", context="{}"),
    "refused: <template>:1: required block 'a' not found",
  )
}

///|
test "undefined names under the strict policy" {
  // undefined-strict
  assert_eq(
    r("{{ nope }}", context="{}"),
    "refused: <template>:1: nope is undefined",
  )
  // undefined-attr
  assert_eq(
    r("{{ nope.a }}", context="{}"),
    "refused: <template>:1: nope is undefined",
  )
  // undefined-loop
  assert_eq(
    r("{{ noexpect|first }}", context="{}"),
    "refused: <template>:1: noexpect is undefined",
  )
}

///|
test "filter and test lookups that fail" {
  // filter-unknown
  assert_eq(
    r("{{ 1|nope }}", context="{}"),
    "refused: <template>:1: no filter named nope",
  )
  // filter-missing-arg
  assert_eq(
    r("{{ 'a'|center }}", context="{}"),
    "                                       a                                        ",
  )
  // filter-extra-arg
  assert_eq(
    r("{{ 'a'|upper(1) }}", context="{}"),
    "refused: <template>:1: upper takes at most 0 positional arguments, 1 given",
  )
  // filter-named-unknown
  assert_eq(
    r("{{ 'a'|truncate(nope=1) }}", context="{}"),
    "refused: <template>:1: truncate got an unexpected argument nope",
  )
}

///|
test "filter and test lookups that fail #2" {
  // test-unknown
  assert_eq(
    r("{{ 1 is nope }}", context="{}"),
    "refused: <template>:1: no test named nope",
  )
}

///|
test "the indentation syntax, its constructs and its refusals" {
  // p-extends-nopath
  assert_eq(
    r("extends", context="{}", format=@moonpug.pug),
    "refused: <template>:1:1: missing path for extends",
  )
  // p-extends-path
  assert_eq(
    r("extends a.pug", context="{}", format=@moonpug.pug),
    "refused: <template>:1: no template named a.pug",
  )
  // p-include-nopath
  assert_eq(
    r("include", context="{}", format=@moonpug.pug),
    "refused: <template>:1:8: missing path for include",
  )
  // p-include-path
  assert_eq(
    r("include a.pug", context="{}", format=@moonpug.pug),
    "refused: <template>:1: no template named a.pug",
  )
  // p-block
  assert_eq(r("block a\np x", context="{}", format=@moonpug.pug), "<p>x</p>")
  // p-block-append
  assert_eq(
    r("block append a\np x", context="{}", format=@moonpug.pug),
    "<p>x</p>",
  )
  // p-block-noname
  assert_eq(
    r("block\np x", context="{}", format=@moonpug.pug),
    "refused: <template>:1:1: an anonymous block belongs inside a mixin",
  )
  // p-if-nocond
  assert_eq(
    r("if\np x", context="{}", format=@moonpug.pug),
    "refused: <template>:1:3: if needs a condition",
  )
  // p-unless
  assert_eq(
    r("unless false\np x", context="{}", format=@moonpug.pug),
    "<p>x</p>",
  )
  // p-each
  assert_eq(
    r("each x in [1]\n  p= x", context="{}", format=@moonpug.pug),
    "<p>1</p>",
  )
  // p-each-noin
  assert_eq(
    r("each x [1]\np x", context="{}", format=@moonpug.pug),
    "refused: <template>:1:1: each statements take the form each VALUE in ITEMS",
  )
  // p-each-noname
  assert_eq(
    r("each in [1]\np x", context="{}", format=@moonpug.pug),
    "refused: <template>:1:1: each statements take the form each VALUE in ITEMS",
  )
  // p-each-pair
  assert_eq(
    r("each x, i in ['a']\n  p #{x}#{i}", context="{}", format=@moonpug.pug),
    "<p>a0</p>",
  )
  // p-each-pair-no
  assert_eq(
    r("each x, in ['a']\np x", context="{}", format=@moonpug.pug),
    "refused: <template>:1:1: each statements take the form each VALUE in ITEMS",
  )
  // p-case
  assert_eq(
    r(
      "case 1\n  when 1\n    p one\n  default\n    p other",
      context="{}",
      format=@moonpug.pug,
    ),
    "<p>one</p>",
  )
  // p-case-nocond
  assert_eq(
    r("case\n  when 1\n    p x", context="{}", format=@moonpug.pug),
    "refused: <template>:2:3: when and default belong inside a case",
  )
  // p-mixin
  assert_eq(
    r("mixin m(a)\n  p= a\n+m(1)", context="{}", format=@moonpug.pug),
    "<p>1</p>",
  )
  // p-mixin-noname
  assert_eq(
    r("mixin\n  p x", context="{}", format=@moonpug.pug),
    "<mixin><p>x</p></mixin>",
  )
  // p-call-noname
  assert_eq(
    r("+", context="{}", format=@moonpug.pug),
    "refused: <template>:1:1: unexpected text +",
  )
  // p-attrs-noparen
  assert_eq(
    r("p&attributes", context="{}", format=@moonpug.pug),
    "refused: <template>:1:13: &attributes takes its value in parentheses",
  )
  // p-mixed-tabs
  assert_eq(
    r("div\n\tp x\n  p y", context="{}", format=@moonpug.pug),
    "refused: <template>:3:1: invalid indentation: tabs and spaces cannot be mixed",
  )
  // p-doctype
  assert_eq(
    r("doctype html\np x", context="{}", format=@moonpug.pug),
    "<!DOCTYPE html><p>x</p>",
  )
  // p-yield
  assert_eq(r("yield", context="{}", format=@moonpug.pug), "")
  // p-code-line
  assert_eq(
    r("- var x = 1\np= x", context="{}", format=@moonpug.pug),
    "refused: <template>:1:1: - lines run host code; write the statement as {% … %} and the output as {{ … }}",
  )
  // p-unbuffered
  assert_eq(r("p= 1 + 1", context="{}", format=@moonpug.pug), "<p>2</p>")
  // p-buffered
  assert_eq(r("p!= '<b>'", context="{}", format=@moonpug.pug), "<p><b></p>")
  // p-comment
  assert_eq(
    r("// note\np x", context="{}", format=@moonpug.pug),
    "<!-- note--><p>x</p>",
  )
  // p-comment-block
  assert_eq(
    r("//\n  note\np x", context="{}", format=@moonpug.pug),
    "<!--note--><p>x</p>",
  )
  // p-interp-unclosed
  assert_eq(
    r("p #{x", context="{}", format=@moonpug.pug),
    "refused: <template>:1:6: no closing } for the interpolation",
  )
  // p-tag-interp
  assert_eq(r("p #[b x]", context="{}", format=@moonpug.pug), "<p><b>x</b></p>")
  // p-pipeless
  assert_eq(
    r("p.\n  one\n  two", context="{}", format=@moonpug.pug),
    "<p>one\ntwo</p>",
  )
  // p-filter
  assert_eq(
    r(":esc\n  <b>", context="{}", format=@moonpug.pug),
    "refused: <template>:1: no filter named esc",
  )
  // p-slash
  assert_eq(r("br/\np x", context="{}", format=@moonpug.pug), "<br/><p>x</p>")
  // p-self-close
  assert_eq(
    r("img(src='a')/", context="{}", format=@moonpug.pug),
    "<img src=\"a\"/>",
  )
  // p-attr-block
  assert_eq(
    r("p&attributes({'a': 1})", context="{}", format=@moonpug.pug),
    "<p a=\"1\"></p>",
  )
  // p-attr-quoted
  assert_eq(
    r("p(a='x', b=\\\"y\\\")", context="{}", format=@moonpug.pug),
    "refused: <template>:1:2: no closing bracket for (",
  )
  // p-attr-noquote
  assert_eq(
    r("p(a=x)", context="{\"x\": 1}", format=@moonpug.pug),
    "<p a=\"1\"></p>",
  )
  // p-attr-colon
  assert_eq(
    r("p(:key='k')", context="{}", format=@moonpug.pug),
    "<p data-key=\"k\"></p>",
  )
  // p-attr-escaped
  assert_eq(
    r("p(title='a<b')", context="{}", format=@moonpug.pug),
    "<p title=\"a&lt;b\"></p>",
  )
  // p-attr-unescaped
  assert_eq(
    r("p(title!='a<b')", context="{}", format=@moonpug.pug),
    "<p title=\"a<b\"></p>",
  )
  // p-text-hash
  assert_eq(r("p #a#b", context="{}", format=@moonpug.pug), "<p>#a#b</p>")
  // p-class-literal
  assert_eq(
    r("p.a.b", context="{}", format=@moonpug.pug),
    "<p class=\"a b\"></p>",
  )
  // p-id-dup
  assert_eq(
    r("p#a#b", context="{}", format=@moonpug.pug),
    "refused: <template>:1:4: a duplicate id attribute is not allowed",
  )
  // p-else
  assert_eq(
    r("if false\n  p a\nelse\n  p b", context="{}", format=@moonpug.pug),
    "<p>b</p>",
  )
  // p-elseif
  assert_eq(
    r("if false\n  p a\nelse if true\n  p b", context="{}", format=@moonpug.pug),
    "<p>b</p>",
  )
  // p-nested-indent
  assert_eq(
    r("div\n  p a\n    span b", context="{}", format=@moonpug.pug),
    "<div><p>a<span>b</span></p></div>",
  )
  // p-stray-indent
  assert_eq(r("  p a", context="{}", format=@moonpug.pug), " p a")
  // p-bad-char
  assert_eq(r("p @", context="{}", format=@moonpug.pug), "<p>@</p>")
  // p-mixin-block
  assert_eq(
    r(
      "mixin m()\n  block\n    p d\n+m()\n    p x",
      context="{}",
      format=@moonpug.pug,
    ),
    "refused: <template>:3:5: unexpected indentation",
  )
}
