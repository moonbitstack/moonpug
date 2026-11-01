///|
test "nesting past the depth limit is refused, not a stack overflow" {
  let shallow = {
    ..@moonpug.settings,
    limits: { ..@moonpug.limits, depth: 20, },
  }
  assert_eq(
    r(
      "{% macro f(n) %}{{ f(n + 1) }}{% endmacro %}{{ f(0) }}",
      settings=shallow,
    ),
    "refused: <template>:1: 21 exceeds the limit of 20",
  )
  assert_eq(
    r(
      "{% include 'a' %}",
      settings=shallow,
      load=files([("a", "x{% include 'a' %}")]),
    ),
    "refused: a:1: 21 exceeds the limit of 20",
  )
  let deep = "{\"t\": {\"c\": [{\"c\": [{\"c\": [{\"c\": []}]}]}]}}"
  let tight = { ..@moonpug.settings, limits: { ..@moonpug.limits, depth: 3, }, }
  assert_eq(
    r(
      "{% for n in [t] recursive %}[{{ loop(n.c) }}]{% endfor %}",
      context=deep,
      settings=tight,
    ),
    "refused: <template>:1: 4 exceeds the limit of 3",
  )
  assert_eq(
    r("{% for n in [t] recursive %}[{{ loop(n.c) }}]{% endfor %}", context=deep),
    "[[[[]]]]",
  )
}

///|
test "range is bounded" {
  let small = {
    ..@moonpug.settings,
    limits: { ..@moonpug.limits, range: 10, },
  }
  assert_eq(r("{{ range(10)|length }}", settings=small), "10")
  assert_eq(
    r("{{ range(11)|length }}", settings=small),
    "refused: <template>:1: 11 exceeds the limit of 10",
  )
  assert_eq(r("{{ range(0, 100, 10)|list|length }}", settings=small), "10")
}

///|
test "the refusal says what crossed which bound" {
  let small = { ..@moonpug.settings, limits: { ..@moonpug.limits, range: 5, }, }
  let got = @moonpug.render(
    "{{ range(9)|list }}",
    Json::object(Map([])),
    settings=small,
  ) catch {
    e => {
      guard e is Exceeded(limit~, got~, line~, ..) else {
        fail("wrong refusal \{e}")
      }
      "\{limit} \{got} \{line}"
    }
  }
  assert_eq(got, "5 9 1")
}

///|
test "what one render writes is bounded" {
  let tight = { ..@moonpug.settings, limits: { ..@moonpug.limits, write: 5, }, }
  assert_eq(r("abcde", settings=tight), "abcde")
  assert_eq(
    r("abcdef", settings=tight),
    "refused: <template>:1: 6 exceeds the limit of 5",
  )
  assert_eq(
    r("a{{ 1 }}b{{ 2 }}c{{ 3 }}", settings=tight),
    "refused: <template>:1: 6 exceeds the limit of 5",
  )
  assert_eq(
    r("{% for n in range(4) %}xx{% endfor %}", settings=tight),
    "refused: <template>:1: 6 exceeds the limit of 5",
  )
  // A block captured for a filter is written all the same.
  assert_eq(
    r("{% filter upper %}abcdef{% endfilter %}", settings=tight),
    "refused: <template>:1: 6 exceeds the limit of 5",
  )
  assert_eq(
    r("{% set x %}abcdef{% endset %}{{ x }}", settings=tight),
    "refused: <template>:1: 6 exceeds the limit of 5",
  )
}

///|
test "a page that fits its bound is written whole" {
  let roomy = {
    ..@moonpug.settings,
    limits: { ..@moonpug.limits, write: 12, },
  }
  assert_eq(
    r("{% for n in range(4) %}xxx{% endfor %}", settings=roomy),
    "xxxxxxxxxxxx",
  )
}

///|
test "a block written inside another counts once" {
  let tight = { ..@moonpug.settings, limits: { ..@moonpug.limits, write: 6, }, }
  assert_eq(
    r(
      "{% macro m() %}ab{% endmacro %}{{ m() }}{{ m() }}{{ m() }}",
      settings=tight,
    ),
    "ababab",
  )
  assert_eq(
    r(
      "{% macro m() %}ab{% endmacro %}{{ m() }}{{ m() }}{{ m() }}{{ m() }}",
      settings=tight,
    ),
    "refused: <template>:1: 8 exceeds the limit of 6",
  )
}
