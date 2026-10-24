// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Everything the engine does, in one pass: `moon run examples/tour`.
#coverage.skip
fn main raise {
  let ctx = @json.parse(
    "{ \"name\": \"moonbit\", \"items\": [\"apple\", \"pear\"], \"n\": 3 }",
  )
  // The brace surface with filters, tests, and the loop object.
  println(
    @moonpug.render(
      "{{ 'hello'|capitalize }}, {{ name }}! {{ items|length }} items: {{ items|join(', ') }}",
      ctx,
    ) catch {
      fault => "F:\{fault}"
    },
  )
  println(
    @moonpug.render(
      "{% for it in items %}{{ loop.index }}. {{ it|title }}{% if not loop.last %}; {% endif %}{% endfor %}",
      ctx,
    ) catch {
      fault => "F:\{fault}"
    },
  )
  // The indentation surface.
  println(
    @moonpug.render("ul#list\n  each it in items\n    li= it|upper", ctx, syntax=Pug) catch {
      fault => "F:\{fault}"
    },
  )
  // A macro and a language block.
  println(
    @moonpug.render(
      "{% macro row(t) %}<tr><td>{{ t }}</td></tr>{% endmacro %}<table>{{ row('x') }}{{ row('y') }}</table>",
      ctx,
    ) catch {
      fault => "F:\{fault}"
    },
  )
  println(
    @moonpug.render(
      "{{ n }}\n{% block lang=pug %}p doubled #{n * 2}{% endblock %}",
      ctx,
    ) catch {
      fault => "F:\{fault}"
    },
  )
  // Extends over the loader seam.
  println(
    @moonpug.render(
      "{% extends 'base' %}{% block body %}<p>{{ name }}</p>{% endblock %}",
      ctx,
      load=fn(name) {
        if name == "base" {
          Some("<html>{% block body %}{% endblock %}</html>")
        } else {
          None
        }
      },
    ) catch {
      fault => "F:\{fault}"
    },
  )
}
