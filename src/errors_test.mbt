///|
test "syntax errors name the template, line and column" {
  assert_eq(r("a\n{{ 1 + }}"), "refused: <template>:2:8: unexpected }}")
  assert_eq(
    r("{% if x %}"),
    "refused: <template>:1:11: unexpected end of template; expected elif or else or endif",
  )
  assert_eq(
    r("{% endfor %}"),
    "refused: <template>:1:4: unknown statement endfor",
  )
  assert_eq(
    r("{{ x|truncate:3 }}"),
    "refused: <template>:1:14: filter arguments take parentheses, as in |truncate(…)",
  )
  assert_eq(
    r("{% for x in %}{% endfor %}"),
    "refused: <template>:1:13: expected an expression, found the end of the tag",
  )
  assert_eq(
    r("{{ 'a }}"),
    "refused: <template>:1:4: the string is never closed",
  )
  assert_eq(
    r("{{ 0123 }}"),
    "refused: <template>:1:4: leading zeros are not allowed in 0123",
  )
  assert_eq(
    r("{% block a-b %}{% endblock %}"),
    "refused: <template>:1:11: block names have to be valid identifiers and may not contain hyphens",
  )
}

///|
test "errors in the indentation syntax name the line" {
  assert_eq(
    r("p ok\n  - x = 1", format=@moonpug.pug),
    "refused: <template>:2:3: - lines run host code; write the statement as {% … %} and the output as {{ … }}",
  )
  assert_eq(
    r("div\n\tp\n    span", format=@moonpug.pug),
    "refused: <template>:3:1: invalid indentation: tabs and spaces cannot be mixed",
  )
  assert_eq(
    r("p(class='a'", format=@moonpug.pug),
    "refused: <template>:1:2: no closing bracket for (",
  )
  assert_eq(
    r("img/\n  p x", format=@moonpug.pug),
    "refused: <template>:1: img is a self closing element: <img/> but contains nested content",
  )
}

///|
test "runtime errors name the template and line" {
  assert_eq(
    r("a\nb {{ missing }}"),
    "refused: <template>:2: missing is undefined",
  )
  assert_eq(
    r("{{ 1 + 'a' }}"),
    "refused: <template>:1: unsupported operand types for +: an integer and a string",
  )
  assert_eq(
    r("{{ x|nofilter }}"),
    "refused: <template>:1: no filter named nofilter",
  )
  assert_eq(
    r("{{ 1 is notest }}"),
    "refused: <template>:1: no test named notest",
  )
  assert_eq(
    r("{% include 'nope' %}", load=files([])),
    "refused: <template>:1: no template named nope",
  )
  assert_eq(r("{% include 'nope' ignore missing %}x", load=files([])), "x")
  assert_eq(r("{{ 1 / 0 }}"), "refused: <template>:1: division by zero")
  assert_eq(
    r("{{ 2 ** 64 }}"),
    "refused: <template>:1: integer result too large to hold in 64 bits",
  )
  assert_eq(
    r("{% extends 'a' %}{% extends 'b' %}", load=files([("a", ""), ("b", "")])),
    "refused: <template>:1: extended multiple times",
  )
}

///|
test "the three undefined policies" {
  let lenient = { ..@moonpug.settings, undefined: Lenient, }
  let chainable = { ..@moonpug.settings, undefined: Chainable, }
  assert_eq(
    r(
      "[{{ x }}]{% for i in x %}{% endfor %}{{ x is defined }}",
      settings=lenient,
    ),
    "[]False",
  )
  assert_eq(
    r("{{ x.y }}", settings=lenient),
    "refused: <template>:1: x is undefined",
  )
  assert_eq(r("[{{ x.y.z }}][{{ x['k'] }}]", settings=chainable), "[][]")
  assert_eq(r("{{ x }}"), "refused: <template>:1: x is undefined")
  assert_eq(
    r("{{ x is defined }}|{{ x|default('d') }}|{{ 'a' if false }}"),
    "False|d|",
  )
  assert_eq(r("{% if x %}{% endif %}"), "refused: <template>:1: x is undefined")
}

///|
test "a fault from an extension is placed at the call" {
  let e = @moonpug.invalid("bad")
  assert_eq(e.place(), ("", 0))
  let placed = e.at("t.html", 3)
  assert_eq(placed.to_string(), "t.html:3: bad")
  assert_eq(placed.at("other", 9).to_string(), "t.html:3: bad")
  assert_eq(
    @moonpug.unknown("filter", "f").at("x", 1).to_string(),
    "x:1: no filter named f",
  )
}
