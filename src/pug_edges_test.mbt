///|
/// The templates a case may include or extend, in the indentation syntax.
fn pug_template(name : String) -> String? {
  if name == "part" || name == "part.pug" {
    Some("part {{ x|upper }}")
  } else if name == "base" || name == "base.pug" {
    Some("base:{% block a %}base{% endblock %}")
  } else {
    None
  }
}

///|
test "the indentation syntax at its edges" {
  // q-id-noname
  assert_eq(
    r("p#", context="{}", format=@moonpug.pug, load=pug_template),
    "refused: <template>:1:2: an id needs a name after #",
  )
  // q-id-dash
  assert_eq(
    r("p#a-b", context="{}", format=@moonpug.pug, load=pug_template),
    "<p id=\"a-b\"></p>",
  )
  // q-interp-nested
  assert_eq(
    r("p #[b #[i x]]", context="{}", format=@moonpug.pug, load=pug_template),
    "<p><b><i>x</i></b></p>",
  )
  // q-interp-escape
  assert_eq(
    r("p \\#[b] x", context="{}", format=@moonpug.pug, load=pug_template),
    "<p>#[b] x</p>",
  )
  // q-interp-escape-hash
  assert_eq(
    r(
      "p \\#{x} y",
      context="{\"x\": 1}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "<p>#{x} y</p>",
  )
  // q-tab-indent
  assert_eq(
    r("div\n\tp x", context="{}", format=@moonpug.pug, load=pug_template),
    "<div><p>x</p></div>",
  )
  // q-each-triple
  assert_eq(
    r(
      "each a, b, c in [[1, 2, 3]]\n  p= a",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "refused: <template>:1:1: each statements take the form each VALUE in ITEMS",
  )
  // q-if-else-colon
  assert_eq(
    r(
      "if false: p a\nelse: p b",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "refused: <template>:2:10: else cannot have a condition; perhaps you meant else if",
  )
  // q-case-when-multi
  assert_eq(
    r(
      "case 3\n  when 1, 2\n    p a\n  when 3\n    p b",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "<p>b</p>",
  )
  // q-attrs-after-call
  assert_eq(
    r(
      "mixin m()\n  p&attributes(attributes)\n+m()(a='1')",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "<p a=\"1\"></p>",
  )
  // q-empty-output
  assert_eq(
    r("p=", context="{}", format=@moonpug.pug, load=pug_template),
    "refused: <template>:1:3: unexpected the end of the template",
  )
  // q-double-eq
  assert_eq(
    r("p== '<b>'", context="{}", format=@moonpug.pug, load=pug_template),
    "refused: <template>:1:3: unexpected =",
  )
  // q-block-append-chain
  assert_eq(
    r(
      "extends base\nblock append a\n  p x",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "refused: base.pug:1:5: unexpected text :{% b",
  )
  // q-include-filter-attrs
  assert_eq(
    r(
      "include:upper part",
      context="{\"x\": \"a\"}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "PART {{ X|UPPER }}",
  )
  // q-unbuffered-comment
  assert_eq(
    r("-# note\np x", context="{}", format=@moonpug.pug, load=pug_template),
    "refused: <template>:1:1: - lines run host code; write the statement as {% … %} and the output as {{ … }}",
  )
  // q-attr-then-block
  assert_eq(
    r(
      "p(a='1')&attributes({'b': 2})",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "<p a=\"1\" b=\"2\"></p>",
  )
  // q-host-code
  assert_eq(
    r("- if (x) {\np y", context="{}", format=@moonpug.pug, load=pug_template),
    "refused: <template>:1:1: - lines run host code; write the statement as {% … %} and the output as {{ … }}",
  )
  // q-pipe-multiline
  assert_eq(
    r(
      "p\n  | one\n  | two\n  | three",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "<p>one\ntwo\nthree</p>",
  )
  // q-mixin-block
  assert_eq(
    r(
      "mixin m()\n  block\n+m()\n  p x",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "<p>x</p>",
  )
  // q-doctype-case
  assert_eq(
    r("doctype HTML", context="{}", format=@moonpug.pug, load=pug_template),
    "<!DOCTYPE html>",
  )
  // q-cond-attr
  assert_eq(
    r(
      "p(class=(x))",
      context="{\"x\": false}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "<p></p>",
  )
  // q-slash-comment
  assert_eq(
    r("//\n  a\n  b\np x", context="{}", format=@moonpug.pug, load=pug_template),
    "<!--a\nb--><p>x</p>",
  )
  // q-plaintext-indent
  assert_eq(
    r(
      "script.\n  var x = 1;\n  var y = 2;",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "<script>var x = 1;\nvar y = 2;</script>",
  )
  // q-tag-interp-attrs
  assert_eq(
    r(
      "p #[b(title='x') y]",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "<p><b title=\"x\">y</b></p>",
  )
  // q-newline-in-attr
  assert_eq(
    r(
      "p(a='1',\n  b='2',\n  c='3')",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "<p a=\"1\" b=\"2\" c=\"3\"></p>",
  )
  // q-eos-in-block
  assert_eq(
    r(
      "each x in [1]\n  p= x\n ",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "refused: <template>:3:2: inconsistent indentation: expecting either 0 or 2",
  )
  // q-stray-outdent
  assert_eq(
    r(
      "div\n    p a\n  p b",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "refused: <template>:3:3: inconsistent indentation: expecting either 0 or 4",
  )
  // q-colon-nested
  assert_eq(
    r("div: p: b x", context="{}", format=@moonpug.pug, load=pug_template),
    "<div><p><b>x</b></p></div>",
  )
  // q-when-block-inline
  assert_eq(
    r(
      "case 1\n  when 1: p a",
      context="{}",
      format=@moonpug.pug,
      load=pug_template,
    ),
    "<p>a</p>",
  )
  // q-filter-pipeless
  assert_eq(
    r(":upper\n  a\n  b", context="{}", format=@moonpug.pug, load=pug_template),
    "A\nB",
  )
}
