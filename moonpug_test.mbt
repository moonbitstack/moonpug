// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The first breath: a template, a context, a page.
test "hello, moonpug" {
  let out = @moonpug.render(
    "Hello, {{ name }}!",
    @json.parse("{ \"name\": \"moonbit\" }"),
  )
  assert_eq(out, "Hello, moonbit!")
}

///|
test "a for loop with the loop object" {
  let out = @moonpug.render(
    "{% for item in items %}{{ loop.index }}:{{ item }} {% endfor %}",
    @json.parse("{ \"items\": [\"a\", \"b\"] }"),
  )
  assert_eq(out, "1:a 2:b ")
}

///|
test "filters and tests in one expression" {
  let out = @moonpug.render(
    "{{ [3, 1, 2] | sort | join('-') }} and {{ 5 is divisibleby(5) }}",
    @json.parse("{}"),
  )
  assert_eq(out, "1-2-3 and True")
}

///|
test "escaping is on until told otherwise" {
  let out = @moonpug.render(
    "{{ evil }}|{% autoescape off %}{{ evil }}{% endautoescape %}",
    @json.parse("{ \"evil\": \"<b>\" }"),
  )
  assert_eq(out, "&lt;b&gt;|<b>")
}

///|
test "the indentation surface renders elements" {
  let out = @moonpug.render(
    (
      #|ul#menu.item
      #|  li.first a
      #|  li: a(href="/") /
    ),
    @json.parse("{}"),
    syntax=Pug,
  )
  assert_eq(
    out, "<ul id=\"menu\" class=\"item\"><li class=\"first\">a</li><li><a href=\"/\">/</a></li></ul>",
  )
}
