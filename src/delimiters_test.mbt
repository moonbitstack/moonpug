///|
/// The settings with one pair of delimiters replaced, the rest as they are.
fn marked(
  variable~ : (String, String) = ("{{", "}}"),
  block~ : (String, String) = ("{%", "%}"),
  comment~ : (String, String) = ("{#", "#}"),
) -> @moonpug.Settings {
  let markers : @moonpug.Delimiters = {
    variable_start: variable.0,
    variable_end: variable.1,
    block_start: block.0,
    block_end: block.1,
    comment_start: comment.0,
    comment_end: comment.1,
  }
  { ..@moonpug.settings, delimiters: markers, }
}

///|
test "delimiters of a template's own for outputs" {
  let settings = marked(variable=("[[", "]]"))
  assert_eq(
    r("Hi [[ name ]]!", context="{ \"name\": \"Ada\" }", settings~),
    "Hi Ada!",
  )
  // What the usual pair writes is text now.
  assert_eq(
    r("{{ name }} [[ name ]]", context="{ \"name\": \"Ada\" }", settings~),
    "{{ name }} Ada",
  )
}

///|
test "delimiters of a template's own for statements" {
  let settings = marked(block=("<%", "%>"))
  assert_eq(
    r(
      "<% for n in [1, 2] %><% if n == 1 %>one<% else %>two<% endif %><% endfor %>",
      settings~,
    ),
    "onetwo",
  )
}

///|
test "delimiters of a template's own for comments" {
  let settings = marked(comment=("<%#", "%>"))
  assert_eq(r("a<%# gone %>b{# kept #}", settings~), "ab{# kept #}")
  assert_eq(r("a<%# gone\n still gone %>b", settings~), "ab")
}

///|
test "all three pairs replaced at once" {
  let settings = marked(
    variable=("[=", "=]"),
    block=("[%", "%]"),
    comment=("[#", "#]"),
  )
  assert_eq(
    r("[# note #][% for n in [1, 2] %][= n =][% endfor %]", settings~),
    "12",
  )
}

///|
test "whitespace signs still work with delimiters of one's own" {
  let settings = marked(variable=("[[", "]]"), block=("<%", "%>"))
  assert_eq(r("a  [[- v -]]  b", context="{ \"v\": \"x\" }", settings~), "axb")
  assert_eq(
    r("a\n<% if v -%>\ny\n<% endif %>z", context="{ \"v\": 1 }", settings~),
    "a\ny\nz",
  )
  // The same template with either pair writes the same text, lstrip_blocks
  // included.
  let stripped : @moonpug.Format = { ..@moonpug.html, lstrip_blocks: true, }
  assert_eq(
    r(
      "a\n  <% if v %>\ny<% endif %>",
      context="{ \"v\": 1 }",
      settings~,
      format=stripped,
    ),
    r("a\n  {% if v %}\ny{% endif %}", context="{ \"v\": 1 }", format=stripped),
  )
}

///|
test "raw takes the body as it stands with delimiters of one's own" {
  let settings = marked(variable=("[[", "]]"), block=("<%", "%>"))
  assert_eq(
    r("<% raw %>[[ x ]] <% if y %><% endraw %>", settings~),
    "[[ x ]] <% if y %>",
  )
  assert_eq(r("<% comment %>[[ x ]]<% endcomment %>z", settings~), "z")
}

///|
test "a language block is found by the delimiters in force" {
  let settings = marked(block=("<%", "%>"))
  assert_eq(r("<% block lang=pug %>p hi<% endblock %>", settings~), "<p>hi</p>")
  // Inside the block the delimiters are the ones the brace syntax has.
  assert_eq(
    r(
      "<% block lang=html %>[[ x ]]<% endblock %>",
      context="{ \"x\": 1 }",
      settings~,
    ),
    "[[ x ]]",
  )
}

///|
test "the indentation syntax reads the delimiters too" {
  let settings = marked(variable=("[[", "]]"), block=("<%", "%>"))
  assert_eq(
    r(
      "p Hi [[ name ]]",
      context="{ \"name\": \"Ada\" }",
      settings~,
      format=@moonpug.pug,
    ),
    "<p>Hi Ada</p>",
  )
  assert_eq(
    r(
      "div\n  <% if show %>\n    p seen\n  <% endif %>",
      context="{ \"show\": true }",
      settings~,
      format=@moonpug.pug,
    ),
    "<div><p>seen</p></div>",
  )
  // An output of the brace syntax is text in Pug unless it is the pair in
  // force.
  assert_eq(
    r(
      "p {{ name }}",
      context="{ \"name\": \"Ada\" }",
      settings~,
      format=@moonpug.pug,
    ),
    "<p>{{ name }}</p>",
  )
}

///|
test "a tag left open with delimiters of one's own names its line" {
  let settings = marked(block=("<%", "%>"))
  assert_eq(
    r("a\nb <% if x %>\nc", context="{ \"x\": 1 }", settings~),
    "refused: <template>:3:2: unexpected end of template; expected elif or else or endif",
  )
}

///|
test "a comment left open with delimiters of one's own is refused" {
  let settings = marked(comment=("<!--", "-->"))
  assert_eq(
    r("a<!-- never closed", settings~),
    "refused: <template>:1:6: missing end of comment tag",
  )
}

///|
test "render takes the delimiters as a flat argument" {
  let got = @moonpug.render("[[ a ]]", @json.parse("{\"a\": 1}"), delimiters={
    variable_start: "[[",
    variable_end: "]]",
    block_start: "{%",
    block_end: "%}",
    comment_start: "{#",
    comment_end: "#}",
  }) catch {
    e => "refused: \{e}"
  }
  assert_eq(got, "1")
}
