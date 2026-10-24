// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
fn page(source : String, context : String) -> String {
  @moonpug.render(source, @json.parse(context)) catch {
    fault => "FAULT:\{fault}"
  }
}

///|
fn pug_page(source : String, context : String) -> String {
  @moonpug.render(source, @json.parse(context), syntax=Pug) catch {
    fault => "FAULT:\{fault}"
  }
}

///|
test "arithmetic keeps Python's typing" {
  assert_eq(
    page(
      "{{ 7 / 2 }}|{{ 7 // 2 }}|{{ 7 % 3 }}|{{ 2 ** 10 }}|{{ -7 // 2 }}|{{ -7 % 3 }}",
      "{}",
    ),
    "3.5|3|1|1024|-4|2",
  )
  assert_eq(page("{{ 1 + 2.5 }}|{{ [1] + [2] }}", "{}"), "3.5|[1, 2]")
}

///|
test "string concatenation tilde and plus" {
  assert_eq(page("{{ 'a' ~ 1 ~ true }}", "{}"), "a1True")
}

///|
test "comparisons chain like Python" {
  assert_eq(
    page(
      "{{ 1 < 2 }}|{{ 'b' > 'a' }}|{{ 1 == 1.0 }}|{{ 2 != 2 }}|{{ 3 in [1, 2, 3] }}|{{ 4 not in [1, 2, 3] }}",
      "{}",
    ),
    "True|True|True|False|True|True",
  )
}

///|
test "inline conditional" {
  assert_eq(
    page("{{ 'yes' if items else 'no' }}", "{}"),
    "FAULT:undefined: items",
  )
}

///|
test "slicing with steps" {
  assert_eq(
    page(
      "{{ [1,2,3,4,5][1:4] }}|{{ 'abcdef'[::-1] }}|{{ [1,2,3,4,5][::2] }}|{{ 'abcdef'[4:1:-1] }}",
      "{}",
    ),
    "[2, 3, 4]|fedcba|[1, 3, 5]|edc",
  )
}

///|
test "inline conditional has both branches" {
  assert_eq(page("{{ 'yes' if ok else 'no' }}", "{ \"ok\": true }"), "yes")
  assert_eq(page("{{ 'yes' if ok else 'no' }}", "{ \"ok\": false }"), "no")
}

///|
test "printf format filter" {
  assert_eq(page("{{ '%s-%s'|format('a', 'b') }}", "{}"), "a-b")
}

///|
test "statements compose: set and with" {
  assert_eq(
    page(
      "{% set greeting = 'hi' %}{{ greeting }} {% with loud=true %}{{ greeting if loud else 'x' }}{% endwith %}",
      "{}",
    ),
    "hi hi",
  )
}

///|
test "if elif else" {
  assert_eq(
    page(
      "{% if n > 10 %}big{% elif n > 5 %}mid{% else %}small{% endif %}", "{ \"n\": 7 }",
    ),
    "mid",
  )
  assert_eq(
    page(
      "{% if n > 10 %}big{% elif n > 5 %}mid{% else %}small{% endif %}", "{ \"n\": 2 }",
    ),
    "small",
  )
  assert_eq(
    page(
      "{% if n > 10 %}big{% elif n > 5 %}mid{% else %}small{% endif %}", "{ \"n\": 20 }",
    ),
    "big",
  )
}

///|
test "for else runs only when empty" {
  assert_eq(
    page("{% for x in xs %}{{ x }}{% else %}none{% endfor %}", "{ \"xs\": [] }"),
    "none",
  )
  assert_eq(
    page(
      "{% for x in xs %}{{ x }}{% else %}none{% endfor %}", "{ \"xs\": [1, 2] }",
    ),
    "12",
  )
}

///|
test "loop object complete" {
  let out = page(
    "{% for x in 'abc' %}{{ loop.index }}{{ loop.index0 }}{{ loop.revindex }}{{ loop.revindex0 }}{{ loop.first }}{{ loop.last }}{{ loop.length }}{{ loop.previtem is defined }}{{ loop.nextitem is defined }};{% endfor %}",
    "{}",
  )
  assert_eq(
    out, "1032TrueFalse3FalseTrue;2121FalseFalse3TrueTrue;3210FalseTrue3TrueFalse;",
  )
}

///|
test "loop cycle and changed" {
  assert_eq(
    page(
      "{% for i in [1,1,2] %}{{ loop.cycle('a','b') }}{{ loop.changed(i) }};{% endfor %}",
      "{}",
    ),
    "aTrue;bFalse;aTrue;",
  )
}

///|
test "break and continue" {
  assert_eq(
    page(
      "{% for i in [1,2,3,4] %}{% if i == 2 %}{% continue %}{% endif %}{% if i == 4 %}{% break %}{% endif %}{{ i }}{% endfor %}",
      "{}",
    ),
    "13",
  )
}

///|
test "filtered for" {
  assert_eq(
    page("{% for n in [1,2,3,4] if n is even %}{{ n }}{% endfor %}", "{}"),
    "24",
  )
}

///|
test "recursive loop" {
  let tree = "{ \"tree\": { \"label\": \"a\", \"children\": [ { \"label\": \"b\", \"children\": [] } ] } }"
  assert_eq(
    @moonpug.render(
      "{% for item in [tree] recursive %}{{ item.label }}({{ loop(item.children) }}){% endfor %}",
      @json.parse(tree),
    ) catch {
      fault => "FAULT:\{fault}"
    },
    "a(b())",
  )
}

///|
test "set with block body" {
  assert_eq(
    page("{% set x %}<b>{{ y }}</b>{% endset %}{{ x }}", "{ \"y\": \"hi\" }"),
    "<b>hi</b>",
  )
}

///|
test "namespaces hold dotted assignment" {
  assert_eq(
    page(
      "{% set ns = namespace(count=0) %}{% for i in [1,2] %}{% set ns.count = ns.count + 1 %}{% endfor %}{{ ns.count }}",
      "{}",
    ),
    "2",
  )
}

///|
test "macros take defaults and varargs" {
  assert_eq(
    page(
      "{% macro f(a, b='!') %}{{ a }}{{ b }}{{ varargs|join(',') }}{% endmacro %}{{ f('x', 'y', 'z', 'w') }}",
      "{}",
    ),
    "xyz,w",
  )
}

///|
test "call blocks pass a caller" {
  assert_eq(
    page(
      "{% macro wrap() %}[{{ caller() }}]{% endmacro %}{% call wrap() %}inner{% endcall %}",
      "{}",
    ),
    "[inner]",
  )
}

///|
test "filter blocks chain" {
  assert_eq(
    page("{% filter upper|replace('X', 'y') %}axb{% endfilter %}", "{}"),
    "AyB",
  )
}

///|
test "raw keeps braces literally" {
  assert_eq(
    page("{% raw %}{{ not_an_expr }}{% endraw %}", "{}"),
    "{{ not_an_expr }}",
  )
}

///|
test "include via the load seam" {
  let out = @moonpug.render("{% include 'part.html' %}", @json.parse("{}"), load=fn(
    name,
  ) {
    if name == "part.html" {
      Some("[part]")
    } else {
      None
    }
  }) catch {
    fault => "FAULT:\{fault}"
  }
  assert_eq(out, "[part]")
}

///|
test "include ignore missing stays silent" {
  let out = @moonpug.render(
    "{% include 'nothing.html' ignore missing %}ok",
    @json.parse("{}"),
  ) catch {
    fault => "FAULT:\{fault}"
  }
  assert_eq(out, "ok")
}

///|
test "extends chains across the load seam with super and scoped" {
  let out = @moonpug.render(
    "{% extends 'base' %}{% block title %}{{ super() }}child{% endblock %}",
    @json.parse("{ \"n\": 3 }"),
    load=fn(name) {
      if name == "base" {
        Some("{% block title %}{{ n }}:{% endblock %}")
      } else {
        None
      }
    },
  ) catch {
    fault => "FAULT:\{fault}"
  }
  assert_eq(out, "3:child")
}

///|
test "append and prepend on blocks" {
  let out = @moonpug.render(
    "{% extends 'base' %}{% block body append %}+{% endblock %}",
    @json.parse("{}"),
    load=fn(name) {
      if name == "base" {
        Some("{% block body %}b{% endblock %}")
      } else {
        None
      }
    },
  ) catch {
    fault => "FAULT:\{fault}"
  }
  assert_eq(out, "b+")
}

///|
test "import and from import" {
  let out = @moonpug.render(
    "{% import 'lib' as m %}{{ m.greet() }}{% from 'lib' import greet as g %}{{ g() }}",
    @json.parse("{}"),
    load=fn(name) {
      if name == "lib" {
        Some("{% macro greet() %}hello{% endmacro %}")
      } else {
        None
      }
    },
  ) catch {
    fault => "FAULT:\{fault}"
  }
  assert_eq(out, "hellohello")
}

///|
test "with context carries the caller's scope" {
  let out = @moonpug.render(
    "{% include 'part' %}",
    @json.parse("{ \"who\": \"me\" }"),
    load=fn(name) { if name == "part" { Some("{{ who }}") } else { None } },
  ) catch {
    fault => "FAULT:\{fault}"
  }
  assert_eq(out, "me")
}

///|
test "undefined policies: strict refuses, lenient prints empty, chainable walks" {
  assert_eq(page("{{ ghost }}", "{}"), "FAULT:undefined: ghost")
  assert_eq(
    @moonpug.render(
      "{{ ghost }}{{ ghost is defined }}",
      @json.parse("{}"),
      undefined_policy=Lenient,
    ) catch {
      fault => "FAULT:\{fault}"
    },
    "False",
  )
  assert_eq(
    @moonpug.render(
      "{{ ghost.me.too is defined }}|{{ ghost is defined }}",
      @json.parse("{}"),
      undefined_policy=Chainable,
    ) catch {
      fault => "FAULT:\{fault}"
    },
    "False|False",
  )
}

///|
test "pug surface greets through its own helper" {
  assert_eq(pug_page("| hello", "{}"), "hello\n")
}
