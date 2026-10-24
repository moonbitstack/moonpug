// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One page written twice — the brace surface and the indentation surface —
/// over the same context. The outputs are byte-identical, which is the
/// whole promise: two spellings, one meaning.
#coverage.skip
fn main raise {
  let context = @json.parse(
    "{ \"title\": \"Shop\", \"items\": [\"apple\", \"pear\"] }",
  )
  let html = @moonpug.render(
    "<h1>{{ title }}</h1><ul>{% for it in items %}<li>{{ it }}</li>{% endfor %}</ul>",
    context,
  ) catch {
    fault => "F:\{fault}"
  }
  let pug = @moonpug.render(
    "h1= title\nul\n  each it in items\n    li= it",
    context,
    syntax=Pug,
  ) catch {
    fault => "F:\{fault}"
  }
  println(html)
  println(pug)
  println(if html == pug { "identical" } else { "DIFFERENT" })
}
