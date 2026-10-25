"""Templates that exercise the built-in methods, formatting, filters, tests
and globals, rendered by Jinja 3.1.6; written as MoonBit test vectors.
Usage: jinja_corpus.py <out>."""
import json, sys
from jinja2 import Environment, StrictUndefined
from jinja2.ext import loopcontrols, do

env = Environment(autoescape=True, undefined=StrictUndefined, extensions=[loopcontrols, do])
plain = Environment(autoescape=False, undefined=StrictUndefined, extensions=[loopcontrols, do])

S = ["", "abc", "Hello World", "  pad  ", "ÀÉÎõü ß", "a-b_c d", "ǅungla", "123", "١٢٣", "x\ty\nz", "Mixed CASE text", "ﬁne", "σΣς"]
cases = []


def add(src, ctx=None, escape=True):
    cases.append((src, ctx or {}, escape))


# String methods.
for s in S:
    q = json.dumps(s)
    for m in ["capitalize()", "casefold()", "lower()", "upper()", "swapcase()", "title()", "strip()", "lstrip()", "rstrip()",
              "isalnum()", "isalpha()", "isascii()", "isdecimal()", "isdigit()", "isidentifier()", "islower()", "isnumeric()",
              "isprintable()", "isspace()", "istitle()", "isupper()", "split()", "splitlines()", "splitlines(true)",
              "center(15, '*')", "ljust(12, '.')", "rjust(12)", "zfill(8)", "count('l')", "find('o')", "rfind('o')",
              "startswith('He')", "endswith(('d', 'c'))", "partition(' ')", "rpartition(' ')", "replace('l', 'L', 1)",
              "split('l')", "rsplit(' ', 1)", "split(none, 1)", "expandtabs(4)", "removeprefix('He')", "removesuffix('ld')",
              "strip('ap ')", "join(['1', '2'])"]:
        add("{{ s.%s }}" % m, {"s": s})
add("{{ 'abc'.index('c') }}|{{ 'abc'.rindex('a') }}")
add("{{ 'abc'.index('z') }}")
add("{{ 'a,b,,c'.split(',') }}|{{ 'a b'.split(' ', -1) }}|{{ ''.split() }}|{{ ''.split(',') }}")
add("{{ '{0}-{1}-{0}'.format('a', 'b') }}|{{ '{x}{y!r}'.format(x=1, y='q') }}|{{ '{:>{w}}'.format('z', w=5) }}")
add("{{ '{0[1]}{0[0]}'.format('ab') }}|{{ '{d[k]}'.format(d={'k': 3}) }}|{{ '{{}}{}'.format(1) }}")
add("{{ '{a}'.format_map({'a': 5}) }}")

# Format specs.
for v in [0, 7, -42, 1234567, 255, 3.14159, -0.5, 1e21, 1.5e-7, 2.5, 100.0, float("nan"), float("inf"), True]:
    for spec in ["", "d", "5d", "<6", ">6", "^7", "*^9", "+", " ", "-", ",", "_", "08.3f", ".2f", ".0f", "e", ".3E", "g", ".3g", "G",
                 "%", ".1%", "x", "X", "#x", "#o", "b", "#b", "o", "c", "n", "z.1f", "=+8", "010,.2f", ".10g", "#g", "s"]:
        # Literals, not context: a whole float in JSON reads back as an integer.
        lit = "float('nan')" if isinstance(v, float) and v != v else "float('inf')" if v == float("inf") else repr(v).lower() if isinstance(v, bool) else repr(v)
        add("{{ '{:%s}'.format(%s) }}" % (spec, lit))
for v in ["", "ab", "ünï"]:
    for spec in ["", "5", "<5", ">5", "^6", "*>4", ".1", "8.2"]:
        add("{{ '{:%s}'.format(v) }}" % spec, {"v": v})

# Percent formatting.
for fmt, val in [("%s", "'x'"), ("%r", "'x'"), ("%d", "3.9"), ("%i", "-4"), ("%5d", "42"), ("%-5d|", "42"), ("%05d", "-42"),
                 ("%+d", "5"), ("% d", "5"), ("%x", "255"), ("%#X", "255"), ("%o", "8"), ("%#o", "8"), ("%e", "1234.5"),
                 ("%.2E", "0.000123"), ("%f", "2.5"), ("%.0f", "2.5"), ("%.0f", "3.5"), ("%10.3f|", "3.14159"), ("%g", "0.0001"),
                 ("%g", "123456789"), ("%G", "1e-10"), ("%c", "65"), ("%c", "'z'"), ("%%", "()"), ("%s and %s", "('a', 'b')"),
                 ("%(a)s-%(b)d", "{'a': 'x', 'b': 2}"), ("%*d", "(5, 3)"), ("%.*f", "(2, 3.14159)"), ("%s", "(1, 2)"), ("%s", "[1, 2]"),
                 ("%s", "none"), ("%r", "'<b>'"), ("%a", "'é'")]:
    add("{{ '%s' %% %s }}" % (fmt, val))
add("{{ '%d' % 'x' }}")
add("{{ '%s %s' % ('a',) }}")
add("{{ ('<b>%s</b>'|safe) % '<i>' }}")

# Numbers as Python prints them.
for v in ["0.1 + 0.2", "1e16", "1e15", "123456789.0", "1/3", "2**0.5", "-0.0", "1e-5", "0.0001", "10 // 3", "-7 // 2", "7 % -3", "-7.5 % 2",
          "2 ** -1", "2 ** 62", "1e308 * 10", "5 / 2", "4 / 2", "3 * 1.0", "17 // 2.5", "(1.5).is_integer()", "(2.0).is_integer()",
          "1.5|round", "2.5|round", "0.125|round(2)", "0.375|round(2)", "-1.5|round", "2.675|round(2)", "1234.5678|round(-2)",
          "1.5|round(0, 'floor')", "-1.5|round(0, 'ceil')", "42|round(1)", "1e300 * 1e300", "(0.1).hex() is defined"]:
    add("{{ %s }}" % v)

# Filters, edge cases.
F = [
    "{{ [1,2,3,4,5]|batch(2)|list }}", "{{ [1,2,3,4,5]|batch(2, 'x')|list }}", "{{ [1,2,3,4,5,6,7]|slice(3)|list }}",
    "{{ [1,2,3,4,5,6,7]|slice(3, 0)|list }}", "{{ [3,1,2]|sum }}", "{{ items|sum(attribute='n') }}", "{{ [1,2]|sum(start=10) }}",
    "{{ ['b','A','c']|sort }}", "{{ ['b','A','c']|sort(case_sensitive=true) }}", "{{ ['b','A','c']|sort(reverse=true) }}",
    "{{ items|sort(attribute='n')|map(attribute='k')|join }}", "{{ items|sort(attribute='g,n')|map(attribute='k')|join }}",
    "{{ ['a','A','b']|unique|list }}", "{{ ['a','A','b']|unique(case_sensitive=true)|list }}", "{{ items|unique(attribute='g')|map(attribute='k')|join }}",
    "{{ {'b': 1, 'A': 2, 'c': 0}|dictsort }}", "{{ {'b': 1, 'A': 2, 'c': 0}|dictsort(by='value') }}", "{{ {'b': 1, 'A': 2}|dictsort(true) }}",
    "{{ {'b': 1, 'A': 2, 'c': 0}|dictsort(reverse=true) }}", "{% for g, l in items|groupby('g') %}{{ g }}:{{ l|length }};{% endfor %}",
    "{% for g in items|groupby('missing', default='none') %}{{ g.grouper }}{% endfor %}", "{{ items|map(attribute='k')|join(',') }}",
    "{{ ['a','b']|map('upper')|list }}", "{{ [1.25, 2.5]|map('round', 1)|list }}", "{{ items|selectattr('n', 'gt', 1)|map(attribute='k')|join }}",
    "{{ items|rejectattr('g', 'equalto', 'x')|map(attribute='k')|join }}", "{{ [0, 1, '', 'a', none]|select|list }}", "{{ [1,2,3]|reject('odd')|list }}",
    "<p{{ {'class': 'a b', 'data-x': '<y>', 'n': none, 'z': false}|xmlattr }}>", "<p{{ {'a': 1}|xmlattr(false) }}>",
    "{{ 'see www.example.org and http://x.y/z?q=1, mail a@b.co.'|urlize }}", "{{ 'http://example.com/very/long/path'|urlize(15) }}",
    "{{ 'http://x.y'|urlize(target='_blank') }}", "{{ 'http://x.y'|urlize(rel='me') }}", "{{ 'ftp://x.y git://z'|urlize(extra_schemes=['git://']) }}",
    "{{ '(http://x.y)'|urlize }}", "{{ '<http://x.y>'|urlize }}", "{{ 'foo bar baz qux quux'|truncate(10) }}",
    "{{ 'foo bar baz qux quux'|truncate(10, true, '>>') }}", "{{ 'foo bar baz qux quux'|truncate(13, leeway=0) }}", "{{ 'short'|truncate(10) }}",
    "{{ 'a\nb\n\nc'|indent }}", "{{ 'a\nb\n\nc'|indent(2, true) }}", "{{ 'a\nb\n\nc'|indent('> ', blank=true) }}", "{{ 'a\nb'|indent(first=true) }}",
    "{{ 'hi'|center(1) }}", "{{ 1023|filesizeformat }}", "{{ 1024|filesizeformat(true) }}", "{{ 1.5e9|filesizeformat }}", "{{ 3e15|filesizeformat(true) }}",
    "{{ '0x1F'|int(0, 16) }}|{{ '0b11'|int(base=0) }}|{{ '12'|int(base=8) }}|{{ 'zz'|int(-1, 36) }}", "{{ '1e3'|float }}|{{ 'inf'|float }}|{{ ' 2.5 '|float }}",
    "{{ 'nAN'|float }}", "{{ 12|string }}|{{ none|string }}|{{ [1]|string }}", "{{ \"hello o'neil-smith\"|title }}", "{{ 'aBC dEF'|capitalize }}",
    "{{ '  x  '|trim }}|{{ 'xxaxx'|trim('x') }}", "{{ 'aaa'|replace('a', 'b', 2) }}", "{{ 'abc'|reverse }}|{{ [1,2]|reverse|list }}",
    "{{ {'a': 1}|length }}|{{ 'ab'|count }}", "{{ ['b','A']|max }}|{{ ['b','A']|max(case_sensitive=true) }}|{{ items|min(attribute='n') }}",
    "{{ []|max }}", "{{ {'a': 1}|attr('items') is defined }}", "{{ {'a': 1, 'b': [1, 2]}|tojson(2) }}", "{{ 'a<b>'|striptags }}",
    "{{ 'x &amp; y &lt;z&gt; &#39;q&#39; &copy; &euro; &#x41; &unknown;'|striptags }}", "{{ '<p>a\n  b</p>  <br/>c'|striptags }}",
    "{{ 'one two three'|wordcount }}", "{{ 'aaa bbb ccc ddd eee fff'|wordwrap(7) }}", "{{ 'aaaaaaaaaaaaaa bb'|wordwrap(5) }}",
    "{{ 'aaaaaaaaaaaaaa bb'|wordwrap(5, false) }}", "{{ 'a-b-c-d-e-f-g'|wordwrap(4) }}", "{{ 'a-b-c-d-e-f-g'|wordwrap(4, break_on_hyphens=false) }}",
    "{{ 'aaa bbb\n\nccc ddd'|wordwrap(5, wrapstring='|') }}", "{{ [1, [2, 'x', {'k': (1, 2)}], none, true, 1.5]|pprint }}",
    "{{ range(40)|list|pprint }}", "{{ {'k' ~ i: 'v' * i for i in []}|default('d') }}", "{{ ('x' * 100)|pprint }}",
    "{{ {'long key number one': 'long value number one', 'long key number two': ['long', 'list', 'of', 'values', 'here']}|pprint }}",
    "{{ [1, 2]|first }}|{{ []|first is undefined }}|{{ 'abc'|last }}", "{{ [1, 2, 3]|random in [1, 2, 3] }}",
    "{{ 'a b'|urlencode }}|{{ {'a': 'b c', 'd': 1}|urlencode }}|{{ [('x', '/'), ('y', 'é')]|urlencode }}",
    "{{ '<a>'|e }}|{{ '<a>'|safe }}|{{ ('<a>'|safe)|e }}|{{ '<a>'|forceescape }}", "{{ items[0]|items|list }}",
    "{{ none|default('d') }}|{{ ''|default('d', true) }}|{{ missing|d('m') }}", "{{ 'abc'|list }}|{{ {'a': 1}|list }}",
]
ctx = {"items": [{"k": "a", "n": 3, "g": "x"}, {"k": "b", "n": 1, "g": "y"}, {"k": "c", "n": 2, "g": "x"}]}
for f in F:
    add(f, ctx)

# Tests.
for t in ["boolean", "callable", "defined", "undefined", "none", "number", "integer", "float", "string", "mapping", "sequence",
          "iterable", "lower", "upper", "odd", "even", "escaped", "true", "false"]:
    for v in ["none", "true", "0", "1.5", "'Ab'", "'ab'", "'AB'", "[1]", "{'a': 1}", "range(2)", "'x'|safe", "3", "missing"]:
        # Python's repr of a range and a callable StrictUndefined have no counterpart.
        if (v == "range(2)" and t in ("lower", "upper")) or (v == "missing" and t == "callable"):
            continue
        add("{{ %s is %s }}" % (v, t))
for t in ["divisibleby(3)", "eq(3)", "ne(3)", "lt(3)", "le(3)", "gt(3)", "ge(3)", "in([1, 3])", "sameas(3)", "equalto 3",
          "greaterthan 2", "lessthan 2", "==(3)", "!=(3)", "<(4)", ">(4)", "<=(3)", ">=(3)", "filter", "test"]:
    add("{{ 3 is %s }}" % t)
add("{{ 'upper' is filter }}|{{ 'nope' is filter }}|{{ 'odd' is test }}|{{ 'nope' is test }}")
add("{{ none is sameas none }}|{{ [] is sameas [] }}")

# Globals.
G = [
    "{{ range(5)|list }}", "{{ range(2, 10, 3)|list }}", "{{ range(10, 0, -3)|list }}", "{{ range(0)|list }}", "{{ range(3, 1)|list }}",
    "{{ range(1, 2, 0)|list }}", "{{ dict(a=1, b=2) }}", "{{ dict() }}",
    "{% set c = cycler('a', 'b') %}{{ c.next() }}{{ c.next() }}{{ c.current }}{{ c.next() }}{% do c.reset() %}{{ c.next() }}",
    "{% set j = joiner('|') %}{% for i in range(3) %}{{ j() }}{{ i }}{% endfor %}", "{% set j = joiner() %}{{ j() }}{{ j() }}",
    "{% set ns = namespace(a=1, b='x') %}{% set ns.a = ns.a + 1 %}{{ ns.a }}{{ ns.b }}", "{% set ns = namespace({'a': 1}, b=2) %}{{ ns.a }}{{ ns.b }}",
    "{{ cycler() is defined }}",
]
for g in G:
    add(g)

# Lists and dicts.
L = [
    "{% set l = [3, 1, 2] %}{% do l.append(4) %}{% do l.extend([5]) %}{% do l.insert(0, 9) %}{{ l }}|{{ l.pop() }}|{{ l.pop(0) }}|{{ l }}",
    "{% set l = [3, 1, 2] %}{% do l.sort() %}{{ l }}{% do l.reverse() %}{{ l }}{% do l.remove(1) %}{{ l }}|{{ l.index(3) }}|{{ l.count(2) }}",
    "{% set l = [1] %}{{ l.copy() }}{% do l.clear() %}{{ l }}", "{{ [1, 2, 3][1:] }}|{{ [1, 2, 3][::-1] }}|{{ 'abcdef'[1:5:2] }}|{{ [1, 2, 3][-1] }}",
    "{% set d = {'a': 1} %}{{ d.get('a') }}{{ d.get('z') }}{{ d.get('z', 0) }}|{{ d.keys()|list }}|{{ d.values()|list }}|{{ d.items()|list }}",
    "{% set d = {'a': 1} %}{% do d.update(b=2) %}{% do d.update({'c': 3}) %}{{ d }}|{{ d.pop('a') }}|{{ d.setdefault('e', 5) }}|{{ d }}",
    "{% set d = {'a': 1} %}{{ d.copy() }}{% do d.clear() %}{{ d }}", "{{ (1, 2) + (3,) }}|{{ [1] * 3 }}|{{ 'ab' * 2 }}|{{ 2 * 'c' }}",
    "{{ 1 in [1, 2] }}|{{ 'a' in 'cat' }}|{{ 'k' in {'k': 1} }}|{{ 3 not in (1, 2) }}", "{{ [1, 2] == [1, 2] }}|{{ (1, 2) == [1, 2] }}|{{ 1 == 1.0 }}|{{ 'a' < 'b' }}",
    "{{ [1, 2] < [1, 3] }}|{{ (1, 'a') < (1, 'b') }}", "{{ {'a': 1} == {'a': 1} }}|{{ none == none }}|{{ true == 1 }}",
]
for l in L:
    add(l)

# Number methods, method argument shapes, and templates that must be refused.
for v in ["3", "-3", "True", "2.5", "-0.75", "1e300", "0.0", "1e-310", "float('nan')"]:
    for m in ["is_integer()", "conjugate()", "bit_length()", "as_integer_ratio()", "hex()", "real", "imag", "numerator", "denominator"]:
        # Integers are 64 bits wide here, so the exact ratios of these are refused.
        if m == "as_integer_ratio()" and v in ("1e300", "1e-310"):
            continue
        add("{{ (%s).%s }}" % (v, m))
M2 = [
    "{{ 'abcabc'.startswith('bc', 1) }}|{{ 'abcabc'.startswith('bc', 1, 2) }}|{{ 'abc'.endswith('b', -3, -1) }}|{{ 'abc'.startswith(('x', 'a')) }}",
    "{{ 'abc'.startswith(1) }}", "{{ 'abc'.startswith() }}", "{{ 'abc'.find('c', 1, 5) }}|{{ 'abc'.find('a', -2) }}|{{ 'abcab'.rfind('ab', 0, 4) }}",
    "{{ 'a b  c'.rsplit(none, 1) }}|{{ '  a b  '.rsplit() }}|{{ 'a,b,c'.rsplit(',', 1) }}|{{ 'a,b,c'.split(',', 1) }}|{{ 'a,b'.split(',', 0) }}",
    "{{ 'a'.split('') }}", "{{ ','.join([1, 2]) }}", "{{ 'ab'.center(5, 'xy') }}", "{{ 'ab'.center('x') }}", "{{ 'ab'.zfill('x') }}",
    "{{ '-42'.zfill(6) }}|{{ '+7'.zfill(4) }}|{{ 'ab'.zfill(1) }}", "{{ 'abc'.count('') }}|{{ 'aaa'.count('a', 1) }}", "{{ 'abc'.index('z') }}",
    "{{ [1, 2].index(3) }}", "{{ (1, 2).index(2) }}|{{ (1, 1).count(1) }}", "{{ 'a'.upper(1) }}", "{{ [].pop() }}", "{{ {}.pop('x') }}",
    "{{ {}.pop('x', 'd') }}", "{% set l = [1] %}{% do l.remove(5) %}", "{% set l = [3, 1] %}{% do l.sort(reverse=true) %}{{ l }}",
    "{{ 'x'.removeprefix('') }}|{{ 'abc'.partition('z') }}|{{ 'abc'.rpartition('z') }}", "{{ s.splitlines(true) }}",
    "{{ 'Hello'.swapcase() }}|{{ 'ǆ'.swapcase() }}", "{{ 'ab'.ljust(5, 'xy') }}", "{{ 'é'.isascii() }}|{{ '_x1'.isidentifier() }}|{{ '1x'.isidentifier() }}",
    "{{ {'a': 1}.update(1) }}", "{{ {'a': 1}.get() }}", "{{ [1].insert(0) }}", "{{ [1].extend(1) }}",
]
for m in M2:
    add(m)
E = [
    "{{ f(*[1], **{'a': 1}) }}", "{{ range(*[3])|list }}", "{{ dict(**{'a': 1}) }}", "{{ range(1, stop=3) }}", "{{ 1 is odd is odd }}",
    "{% set true = 1 %}", "{% set (a, b) = (1, 2) %}{{ a }}{{ b }}", "{% set a, b = 'xy' %}{{ b }}{{ a }}", "{% set ns.x = 1 %}",
    "{% for a, b in [(1, 2), (3, 4)] %}{{ a }}{{ b }}{% endfor %}", "{% for (a, b) in [(1, 2)] %}{{ a + b }}{% endfor %}",
    "{% from 'x' import _private %}", "{% macro m(a=1, b) %}{% endmacro %}", "{% macro m(a, a) %}{% endmacro %}",
    "{% trans a=1, a=2 %}{% endtrans %}", "{% trans %}{{ x.y }}{% endtrans %}", "{% trans num=1 %}{% pluralize nope %}{% endtrans %}",
    "{% trans %}a{% pluralize %}b{% pluralize %}c{% endtrans %}", "{% trans %}unclosed", "{% call %}{% endcall %}", "{% call x %}{% endcall %}",
    "{% for x in [1, 2, 3] %}{% if x == 2 %}{% break %}{% endif %}{{ x }}{% endfor %}", "{% for x in [1, 2] %}{% continue %}{{ x }}{% endfor %}y",
    "{{ 1. }}", "{{ x. }}", "{{ [1, 2 }}", "{{ (1 }}", "{{ {'a' 1} }}", "{{ 'a' 'b' }}", "{{ 1 if }}", "{{ not }}", "{{ -'a' }}", "{{ +true }}|{{ -true }}",
    "{{ 'a' ~ none ~ 1.5 }}", "{{ [1][5] }}", "{{ 'ab'[9] is undefined }}", "{{ {'a': 1}['b'] is undefined }}", "{{ none.x }}", "{{ (1).real is defined }}",
    "{{ 1 < 'a' }}", "{{ [1] < [2, 3] }}", "{{ 'b' in 'abc' }}", "{{ 1 in 'abc' }}", "{{ 10 // 0 }}", "{{ 1 % 0 }}", "{{ 2.5 // 0.0 }}", "{{ 'a' * 'b' }}",
    "{{ [1] + (2,) }}", "{{ 9007199254740993 * 2 }}", "{{ 2 ** 0.5 ** 2 }}", "{{ -2 ** 2 }}", "{{ 7 // -2 }}|{{ -7 % 3 }}|{{ 7.5 % -2 }}",
    "{% raw %}{{ x }}{% endraw %}", "{%- raw -%}  a  {%- endraw -%}", "a {#- c -#} b", "a {#+ c +#} b", "{% if true -%}  x{%- endif %}",
    "{% filter upper %}a{% endfilter %}|{% filter replace('a', 'b')|upper %}aa{% endfilter %}", "{% with a = 1, b = a + 1 %}{{ b }}{% endwith %}",
    "{% autoescape false %}{{ '<a>' }}{% endautoescape %}{{ '<a>' }}", "{% set x %}<b>{% endset %}{{ x }}", "{{ self.missing is defined }}",
    "{% block a %}A{% endblock %}{{ self.a() }}", "{% for x in [1] %}{{ loop.depth }}{{ loop.revindex }}{{ loop.length }}{% endfor %}",
    "{% for x in [1, 2, 1] %}{{ loop.changed(x) }}{{ loop.cycle('a', 'b', 'c') }}{% endfor %}", "{% for x in [1] %}{{ loop.cycle() }}{% endfor %}",
    "{% for x in [1, 2] %}{{ loop.previtem|default('-') }}{{ loop.nextitem|default('-') }}{% endfor %}", "{{ loop }}",
    "{% for x in [1] %}{{ loop() }}{% endfor %}", "{% for x in [[1]] recursive %}{{ loop(1, 2) }}{% endfor %}",
]
for e in E:
    add(e, {"f": None})

lines = []
for i, (src, ctx, escape) in enumerate(cases):
    e = env if escape else plain
    try:
        out = e.from_string(src).render(**ctx)
        result = "output=" + json.dumps(out, ensure_ascii=False)
    except Exception as ex:
        result = "error=" + json.dumps(type(ex).__name__ + ": " + str(ex), ensure_ascii=False)
    body = ["source=" + json.dumps(src, ensure_ascii=False), json.dumps(json.dumps(ctx, ensure_ascii=False), ensure_ascii=False), result, "policy=Strict"]
    if escape:
        body.append("autoescape=true")
    lines.append("///|\ntest %s {\n  jinja(\n    %s,\n  )\n}\n" % (json.dumps("extra #%d" % i), ",\n    ".join(body)))
open(sys.argv[1], "w", encoding="utf-8", newline="\n").write("\n".join(lines))
print(len(lines))
