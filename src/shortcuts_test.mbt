///|
/// The settings with the shorthand prefixes replaced; the rest as they are.
fn prefixed(pairs : Array[(String, String)]) -> @moonpug.Settings {
  { ..@moonpug.settings, shortcuts: Map(pairs), }
}

///|
test "the usual prefixes gather a class and set an id" {
  assert_eq(
    r("div.a.b#main", format=@moonpug.pug),
    "<div class=\"a b\" id=\"main\"></div>",
  )
}

///|
test "a prefix of one's own writes the attribute it names" {
  let settings = prefixed([(".", "class"), ("#", "id"), ("@", "data-role")])
  assert_eq(
    r("div@main", settings~, format=@moonpug.pug),
    "<div data-role=\"main\"></div>",
  )
  assert_eq(
    r("div@main.a#x", settings~, format=@moonpug.pug),
    "<div class=\"a\" data-role=\"main\" id=\"x\"></div>",
  )
}

///|
test "two shorthands under the same attribute stay two values" {
  let settings = prefixed([("@", "data-role")])
  assert_eq(
    r("div@a@b", settings~, format=@moonpug.pug),
    "<div data-role=\"a\" data-role=\"b\"></div>",
  )
}

///|
test "the dot prefix can name another attribute" {
  let settings = prefixed([(".", "data-test")])
  assert_eq(
    r("p.x.y", settings~, format=@moonpug.pug),
    "<p data-test=\"x\" data-test=\"y\"></p>",
  )
  // An id written with a prefix that no longer means id is just another
  // attribute.
  assert_eq(
    r("p#one", settings~, format=@moonpug.pug),
    "refused: <template>:1:2: unexpected text #one",
  )
}

///|
test "a custom prefix follows the rule of the attribute it names" {
  let settings = prefixed([("@", "id")])
  assert_eq(r("p@main", settings~, format=@moonpug.pug), "<p id=\"main\"></p>")
  assert_eq(
    r("p@a@b", settings~, format=@moonpug.pug),
    "refused: <template>:1:4: a duplicate id attribute is not allowed",
  )
}

///|
test "a prefix needs a name, and the attribute rule says which names" {
  let settings = prefixed([("@", "data-x"), ("#", "id")])
  assert_eq(
    r("p@", settings~, format=@moonpug.pug),
    "refused: <template>:1:2: a data-x needs a name after @",
  )
  assert_eq(
    r("p@123", settings~, format=@moonpug.pug),
    "refused: <template>:1:2: data-x names must contain at least one letter or underscore",
  )
  assert_eq(r("p#1", settings~, format=@moonpug.pug), "<p id=\"1\"></p>")
}

///|
test "a shortcut reaches an element written with an attribute section" {
  let settings = prefixed([(".", "class"), ("#", "id"), ("@", "data-role")])
  assert_eq(
    r("div@main(class=\"a\")", settings~, format=@moonpug.pug),
    "<div class=\"a\" data-role=\"main\"></div>",
  )
  assert_eq(
    r("a(href=\"#\").link", settings~, format=@moonpug.pug),
    "<a class=\"link\" href=\"#\"></a>",
  )
}

///|
test "render takes the prefixes as a flat argument" {
  let got = @moonpug.render(
    "div@main",
    @json.parse("{}"),
    format=@moonpug.pug,
    shortcuts=Map([("@", "data-role")]),
  ) catch {
    e => "refused: \{e}"
  }
  assert_eq(got, "<div data-role=\"main\"></div>")
}

///|
test "a brace template ignores the prefixes" {
  let settings = prefixed([("@", "data-role")])
  assert_eq(r("@name", context="{ \"name\": \"x\" }", settings~), "@name")
}
