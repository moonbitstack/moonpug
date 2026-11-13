///|
/// An attribute that holds a list or a mapping is written as JSON text. The
/// expectations here are what Pug 3.0.4 writes for the same source and data,
/// so the writer has to stay a JSON writer in the sense JavaScript's
/// `JSON.stringify` means — quotes and backslashes escaped, a control
/// character as `\u0007`, and no escaping of non-ASCII.
test "a list or a mapping in an attribute is the JSON text JavaScript writes" {
  let ctx : Json = {
    "list": ["a\"b", "c\\d", "e\nf", "g\u{7}h"],
    "map": { "k\"1": "v\\1" },
    "empty": [],
    "nested": [[1, 2], { "deep": [true, null] }],
  }
  let cases : Array[(String, String)] = [
    (
      "div(data-list=list)", "<div data-list=\"[&#34;a\\&#34;b&#34;,&#34;c\\\\d&#34;,&#34;e\\nf&#34;,&#34;g\\u0007h&#34;]\"></div>",
    ),
    (
      "div(data-map=map)", "<div data-map=\"{&#34;k\\&#34;1&#34;:&#34;v\\\\1&#34;}\"></div>",
    ),
    ("div(data-empty=empty)", "<div data-empty=\"[]\"></div>"),
    (
      "div(data-nested=nested)", "<div data-nested=\"[[1,2],{&#34;deep&#34;:[true,null]}]\"></div>",
    ),
  ]
  for pair in cases {
    assert_eq(@moonpug.render(pair.0, ctx, format=@moonpug.pug), pair.1)
  }
}

///|
/// A quote inside text is HTML-escaped, not JSON-escaped: the attribute is
/// text, and only values that are not text go through the JSON writer.
test "text in an attribute is escaped as HTML, not as JSON" {
  let ctx : Json = { "q": "say \"hi\"", "b": "back\\slash", "n": "line\nbreak" }
  assert_eq(
    @moonpug.render("div(data-q=q)", ctx, format=@moonpug.pug),
    "<div data-q=\"say &#34;hi&#34;\"></div>",
  )
  assert_eq(
    @moonpug.render("div(data-b=b)", ctx, format=@moonpug.pug),
    "<div data-b=\"back\\slash\"></div>",
  )
  assert_eq(
    @moonpug.render("div(data-n=n)", ctx, format=@moonpug.pug),
    "<div data-n=\"line\nbreak\"></div>",
  )
}

///|
/// The same writer serves unescaped attributes: `!=` keeps the JSON text as it
/// stands, and a value that is not text is written with its quotes intact.
test "an unescaped attribute keeps the JSON text as it stands" {
  let ctx : Json = { "list": ["a\"b"] }
  assert_eq(
    @moonpug.render("div(data-list!=list)", ctx, format=@moonpug.pug),
    "<div data-list='[\"a\\\"b\"]'></div>",
  )
}
