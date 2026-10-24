// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The Django supplements, the six Jinja globals, and the gettext family.
fn dj(template : String, context : String) -> String {
  @moonpug.render(template, @json.parse(context)) catch {
    fault => "F:\{fault}"
  }
}

///|
test "the Django supplement filters" {
  let cases : Array[(String, String, String)] = [
    // date with Django's bare-letter format
    (
      "{{ '2026-03-05T14:07:09'|date('Y-m-d') }}|{{ '2026-03-05T14:07:09'|date('jS M') }}",
      "{}", "2026-03-05|5th Mar",
    ),
    // time
    ("{{ '2026-03-05T14:07:09'|time('H:i') }}", "{}", "14:07"),
    // slugify
    (
      "{{ 'Hello, MoonBit World!'|slugify }}|{{ 'a  b--c'|slugify }}", "{}", "hello-moonbit-world|a-b-c",
    ),
    // pluralize: empty on the singular, the suffix on the plural
    (
      "{{ 1|pluralize }}|{{ 2|pluralize }}|{{ 2|pluralize('es') }}|{{ 1|pluralize('y,ies') }}|{{ 2|pluralize('y,ies') }}",
      "{}", "|s|es|y|ies",
    ),
    // linebreaks / linebreaksbr
    (
      "{{ 'a\n\nb'|linebreaks }}|{{ 'a\nb'|linebreaksbr }}", "{}", "<p>a</p> <p>b</p>|a<br />b",
    ),
    // truncatechars / truncatewords
    (
      "{{ 'abcdefg'|truncatechars(6) }}|{{ 'one two three four'|truncatewords(2) }}",
      "{}", "abcde…|one two ...",
    ),
    // stringformat: Django applies the pattern to the value
    ("{{ 3|stringformat('03d') }}", "{}", "003"),
    // yesno
    (
      "{{ true|yesno }}|{{ false|yesno }}|{{ none|yesno }}|{{ false|yesno('yep,nope,shrug') }}",
      "{}", "yes|no|maybe|nope",
    ),
    // json_script
    (
      "{{ { a: 1 }|json_script(id='d') }}", "{}", "<script id=\"d\" type=\"application/json\">{\"a\":1}</script>",
    ),
    // iriencode keeps Django's IRI-safe set; autoescape then shows the &
    ("{{ 'a b&c'|iriencode }}", "{}", "a%20b&amp;c"),
    // unordered_list
    (
      "{{ ['a', ['b'], 'c']|unordered_list }}", "{}", "<ul><li>a<ul><li>b</li></ul></li><li>c</li></ul>",
    ),
    // divisibleby
    ("{{ 6|divisibleby(3) }}|{{ 7|divisibleby(3) }}", "{}", "True|False"),
    // get_digit reads the digits off any value
    ("{{ 12345|get_digit(2) }}|{{ 12345|get_digit(1) }}", "{}", "4|5"),
    // add
    ("{{ 2|add(3) }}|{{ 'a'|add('b') }}", "{}", "5|ab"),
    // cut
    ("{{ 'a b c'|cut(' ') }}", "{}", "abc"),
    // make_list
    (
      "{{ 'ab'|make_list }}|{{ [1,2]|make_list }}", "{}", "[&#39;a&#39;, &#39;b&#39;]|[1, 2]",
    ),
    // ljust / rjust
    ("{{ 'a'|ljust(3) }}x|{{ 'a'|rjust(3) }}x", "{}", "a  x|  ax"),
    // floatformat
    (
      "{{ 4.50|floatformat }}|{{ 4.0|floatformat }}|{{ 4.567|floatformat(2) }}",
      "{}", "4.5|4|4.57",
    ),
    // escapejs escapes only the JS-delimiter set, as Django does
    ("{{ 'a\\'b<c>'|escapejs }}", "{}", "a\\u0027b\\u003Cc\\u003E"),
    // spaceless
    ("{{ '<div>  <b>x</b>  </div>'|spaceless }}", "{}", "<div><b>x</b></div>"),
    // urlizetrunc
    (
      "{{ 'see http://x.example now'|urlizetrunc(8) }}", "{}", "see <a href=\"http://x.example\">http://x…</a> now",
    ),
  ]
  for case in cases {
    let (template, context, want) = case
    let got = dj(template, context)
    if got != want {
      abort("django case failed: \{template} -> \{got}, wanted \{want}")
    }
  }
}

///|
test "timesince and timeuntil measure between two moments the caller names" {
  assert_eq(
    dj("{{ '2026-01-01T00:00:00'|timesince('2026-01-08T00:00:00') }}", "{}"),
    "1 week",
  )
  assert_eq(
    dj("{{ '2026-01-08T00:00:00'|timeuntil('2026-01-01T00:00:00') }}", "{}"),
    "1 week",
  )
}

///|
test "the Jinja globals" {
  assert_eq(
    dj(
      "{{ range(3)|list }}|{{ range(2, 5)|list }}|{{ range(0, 6, 2)|list }}", "{}",
    ),
    "[0, 1, 2]|[2, 3, 4]|[0, 2, 4]",
  )
  assert_eq(
    dj("{{ dict(a=1, b=2)|items }}", "{}"),
    "[[&#39;a&#39;, 1], [&#39;b&#39;, 2]]",
  )
  assert_eq(dj("{{ namespace(x=1).x }}", "{}"), "1")
  assert_eq(
    dj(
      "{% set c = cycler('a', 'b') %}{{ c.next() }}{{ c.next() }}{{ c.next() }}",
      "{}",
    ),
    "aba",
  )
  assert_eq(dj("{% set j = joiner('|') %}{{ j() }}a{{ j() }}b", "{}"), "a|b")
  // lipsum is deterministic: one paragraph of four twelve-word sentences
  let text = dj("{{ lipsum(1, html=false) }}", "{}")
  assert_eq(dj("{{ lipsum(1, html=false)|wordcount }}", "{}"), "48")
}

///|
test "the gettext family over the translate seam" {
  let out = @moonpug.render(
    "{{ _('hi') }}|{{ ngettext('1 apple', 'many apples', 3) }}|{{ pgettext('greeting', 'hi') }}",
    @json.parse("{}"),
    translate=fn(msgid, _ctx, _count) {
      if msgid == "hi" {
        Some("hej")
      } else {
        None
      }
    },
  ) catch {
    fault => "F:\{fault}"
  }
  assert_eq(out, "hej|many apples|hej")
}

///|
test "trans with a plural and placeholders over the seam" {
  let out = @moonpug.render(
    "{% trans count=n %}{{ count }} apple{% pluralize %}{{ count }} apples{% endtrans %}",
    @json.parse("{ \"n\": 3 }"),
    translate=fn(msgid, _ctx, count) {
      match count {
        Some(1) => Some(msgid)
        _ => Some(msgid + " (plural)")
      }
    },
  ) catch {
    fault => "F:\{fault}"
  }
  assert_eq(out, "3 apples (plural)")
}

///|
test "trans without a seam passes the text through" {
  assert_eq(
    dj(
      "{% trans count=2 %}one apple{% pluralize %}{{ count }} apples{% endtrans %}",
      "{ \"n\": 2 }",
    ),
    "2 apples",
  )
}
