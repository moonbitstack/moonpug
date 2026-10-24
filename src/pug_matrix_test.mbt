// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The indentation surface: elements, attributes, control flow, mixins,
/// blocks, the language blocks, the rejections, and the dual-surface promise.
fn pg(template : String, context : String) -> String {
  @moonpug.render(template, @json.parse(context), syntax=Pug) catch {
    fault => "F:\{fault}"
  }
}

///|
test "elements and shorthand" {
  assert_eq(pg("div", "{}"), "<div></div>")
  assert_eq(
    pg("#app.content", "{}"),
    "<div id=\"app\" class=\"content\"></div>",
  )
  assert_eq(pg("br", "{}"), "<br>")
  assert_eq(
    pg("input(type='checkbox' checked)", "{}"),
    "<input type=\"checkbox\" checked>",
  )
  assert_eq(
    pg("a(href='/x' target=_blank) link", "{}"),
    "<a href=\"/x\" target=\"_blank\">link</a>",
  )
}

///|
test "text lines, interpolation, inline html" {
  assert_eq(pg("| hello #{name}", "{ \"name\": \"world\" }"), "hello world")
  assert_eq(pg("p text", "{}"), "<p>text</p>")
  assert_eq(pg("p= name", "{ \"name\": \"<b>\" }"), "<p>&lt;b&gt;</p>")
  assert_eq(pg("p!= name", "{ \"name\": \"<b>\" }"), "<p><b></p>")
  assert_eq(pg("<hr>", "{}"), "<hr>")
}

///|
test "nesting and the colon chain" {
  assert_eq(
    pg("ul\n  li one\n  li two", "{}"),
    "<ul><li>one</li><li>two</li></ul>",
  )
  assert_eq(pg("li: a(href='/') home", "{}"), "<li><a href=\"/\">home</a></li>")
}

///|
test "attributes merge shorthand, conditionals and splats" {
  assert_eq(
    pg(
      "input(type='text' class='wide' disabled=needs)&attributes(attrs)", "{ \"needs\": true, \"attrs\": { \"data-x\": \"1\" } }",
    ),
    "<input type=\"text\" class=\"wide\" disabled data-x=\"1\">",
  )
}

///|
test "control flow: each, if, unless, case" {
  assert_eq(
    pg(
      "each u in users\n  li= u.n", "{ \"users\": [{\"n\":\"a\"},{\"n\":\"b\"}] }",
    ),
    "<li>a</li><li>b</li>",
  )
  assert_eq(
    pg("each v, k in sizes\n  p= k + '=' + v", "{ \"sizes\": { \"s\": 1 } }"),
    "<p>s=1</p>",
  )
  assert_eq(
    pg("if ok\n  p yes\nelse\n  p no", "{ \"ok\": false }"),
    "<p>no</p>",
  )
  assert_eq(pg("unless ok\n  p no\n", "{ \"ok\": false }"), "<p>no</p>")
  assert_eq(
    pg("case n\n  when 1, 2\n    p small\n  default\n    p big", "{ \"n\": 9 }"),
    "<p>big</p>",
  )
  assert_eq(
    pg("case n\n  when 1, 2\n    p small\n  default\n    p big", "{ \"n\": 9 }"),
    "<p>big</p>",
  )
}

///|
test "mixins with and without a caller body" {
  assert_eq(pg("mixin pet(name)\n  p= name\n+pet('cat')", "{}"), "<p>cat</p>")
  assert_eq(
    pg(
      "mixin card()\n  .box\n    if block\n      block\n    | end\n+card()\n  | inner",
      "{}",
    ),
    "<div class=\"box\">innerend</div>",
  )
}

///|
test "blocks replace over the loader, append keeps both" {
  let out = @moonpug.render(
    "extends 'base'\nblock body\n  p child",
    @json.parse("{}"),
    syntax=Pug,
    load=fn(name) {
      if name == "base" {
        Some("block body\n  p parent")
      } else {
        None
      }
    },
  ) catch {
    fault => "F:\{fault}"
  }
  // The child's block replaces the parent's, Pug's default.
  assert_eq(out, "<p>child</p>")
  let both = @moonpug.render(
    "extends 'base'\nappend body\n  p child",
    @json.parse("{}"),
    syntax=Pug,
    load=fn(name) {
      if name == "base" {
        Some("block body\n  p parent")
      } else {
        None
      }
    },
  ) catch {
    fault => "F:\{fault}"
  }
  assert_eq(both, "<p>parent</p><p>child</p>")
}

///|
test "doctype and comments" {
  assert_eq(pg("doctype html\nhtml", "{}"), "<!DOCTYPE html><html></html>")
  assert_eq(pg("// visible\np x", "{}"), "<!-- visible --><p>x</p>")
  assert_eq(pg("//- hidden\np x", "{}"), "<p>x</p>")
}

///|
test "the language blocks switch surfaces in place" {
  assert_eq(
    @moonpug.render(
      "{{ n }}\n{% block lang=pug %}p= n * 2{% endblock %}",
      @json.parse("{ \"n\": 21 }"),
    ) catch {
      fault => "F:\{fault}"
    },
    "21\n<p>42</p>",
  )
  assert_eq(
    @moonpug.render(
      "{% block lang=pug %}ul\n  li ok{% endblock %}",
      @json.parse("{}"),
      syntax=Pug,
    ) catch {
      fault => "F:\{fault}"
    },
    "<ul><li>ok</li></ul>",
  )
}

///|
test "force keeps foreign language blocks as text" {
  assert_eq(
    @moonpug.render(
      "{% block lang=md %}**not parsed**{% endblock %}",
      @json.parse("{}"),
      syntax=Pug,
      force=true,
    ) catch {
      fault => "F:\{fault}"
    },
    // Under force the whole construct is literal text, markers included.
    "{% block lang=md %}**not parsed**{% endblock %}",
  )
}

///|
test "the markdown preset" {
  assert_eq(
    @moonpug.render(
      "# {{ title }}\n\nbody",
      @json.parse("{ \"title\": \"T\" }"),
      syntax=Markdown,
    ) catch {
      fault => "F:\{fault}"
    },
    "# T\n\nbody",
  )
}

///|
test "the rejections: Slim's line prefixes and Django's spellings" {
  assert_true(pg("- code", "{}").has_prefix("F:"))
  assert_true(pg("= expr", "{}").has_prefix("F:"))
  let jinja_refused = @moonpug.render(
    "{% verbatim %}x{% endverbatim %}",
    @json.parse("{}"),
  ) catch {
    fault => "F:\{fault}"
  }
  assert_true(jinja_refused.has_prefix("F:"))
  let colon_refused = @moonpug.render(
    "{{ 'ab'|truncate:3 }}",
    @json.parse("{}"),
  ) catch {
    fault => "F:\{fault}"
  }
  assert_true(colon_refused.has_prefix("F:"))
}

///|
test "the same page through both surfaces is byte-identical" {
  let context = "{ \"title\": \"Shop\", \"items\": [\"apple\", \"pear\"] }"
  let html = @moonpug.render(
    "<h1>{{ title }}</h1><ul>{% for it in items %}<li>{{ it }}</li>{% endfor %}</ul>",
    @json.parse(context),
  ) catch {
    fault => "F:\{fault}"
  }
  let pug = @moonpug.render(
    "h1= title\nul\n  each it in items\n    li= it",
    @json.parse(context),
    syntax=Pug,
  ) catch {
    fault => "F:\{fault}"
  }
  assert_eq(html, "<h1>Shop</h1><ul><li>apple</li><li>pear</li></ul>")
  assert_eq(html, pug)
}
