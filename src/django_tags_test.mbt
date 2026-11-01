///|
test "templatetag writes a delimiter as text" {
  let names = {
    "openblock": "{%",
    "closeblock": "%}",
    "openvariable": "{{",
    "closevariable": "}}",
    "openbrace": "{",
    "closebrace": "}",
    "opencomment": "{#",
    "closecomment": "#}",
  }
  for name, want in names {
    assert_eq(r("{{ templatetag('" + name + "') }}"), want)
  }
  assert_eq(
    r("{{ templatetag('nothing') }}"),
    "refused: <template>:1: templatetag has no nothing; it knows openblock, closeblock, openvariable, closevariable, openbrace, closebrace, opencomment, closecomment",
  )
}

///|
test "templatetag writes what a template cannot" {
  assert_eq(
    r("{{ templatetag('openblock') }} if x {{ templatetag('closeblock') }}"),
    "{% if x %}",
  )
}

///|
test "query_string builds one from named values" {
  jinja(source="{{ query_string(page=2) }}", "{}", output="?page=2")
  jinja(source="{{ query_string(a=1, b='x y') }}", "{}", output="?a=1&b=x+y")
  jinja(
    source="{{ query_string(q='a b&c=d/é') }}",
    "{}",
    output="?q=a+b%26c%3Dd%2F%C3%A9",
  )
  jinja(source="{{ query_string(keep='~-_') }}", "{}", output="?keep=~-_")
  jinja(source="{{ query_string() }}", "{}", output="?")
  // Written into a page, the join is markup like any other text.
  assert_eq(r("{{ query_string(a=1, b=2) }}"), "?a=1&amp;b=2")
}

///|
test "query_string drops the keys set to none and repeats the lists" {
  jinja(source="{{ query_string(a=none) }}", "{}", output="?")
  jinja(
    source="{{ query_string(tags=['a', 'b b']) }}",
    "{}",
    output="?tags=a&tags=b+b",
  )
  jinja(source="{{ query_string(tags=[]) }}", "{}", output="?")
  jinja(source="{{ query_string({'a': 1}, a=none, b=2) }}", "{}", output="?b=2")
  jinja(source="{{ query_string({'a': 1}, a=2) }}", "{}", output="?a=2")
}

///|
test "query_string takes mappings only" {
  assert_eq(
    r("{{ query_string(1) }}"),
    "refused: <template>:1: query_string takes mappings, not an integer",
  )
}

///|
test "widthratio scales a value to a width, rounded half to even" {
  for
    pair in [
      ("175", "200", "100", "88"),
      ("10", "40", "100", "25"),
      ("1", "3", "100", "33"),
      ("2", "3", "100", "67"),
      ("100", "10", "100", "1000"),
      ("-5", "10", "100", "-50"),
      ("0.5", "1", "100", "50"),
      ("5", "0", "100", "0"),
      ("1", "2", "1", "0"),
      ("3", "2", "1", "2"),
    ] {
    let (value, top, width, want) = pair
    assert_eq(
      r("{{ " + value + "|widthratio(" + top + ", " + width + ") }}"),
      want,
    )
  }
  assert_eq(r("{{ 'x'|widthratio(2, 100) }}"), "")
  assert_eq(
    r("{{ 5|widthratio(10, 'x') }}"),
    "refused: <template>:1: widthratio wants a number for its width",
  )
}

///|
test "widthratio takes a hundred for its width when none is given" {
  assert_eq(r("{{ 175|widthratio(200) }}"), "88")
}

///|
/// A host that answers every seam, so the globals can be read.
fn test_host() -> @moonpug.Host {
  {
    url: Some((name, args, named) => {
      let parts = []
      for arg in args {
        parts.push(arg.to_string())
      }
      for key, value in named {
        parts.push(key + "=" + value.to_string())
      }
      "/" + name + (if parts.is_empty() { "" } else { "/" + parts.join("/") })
    }),
    asset: Some(path => "/static/" + path),
    asset_prefix: Some(() => "/static/"),
    media_prefix: Some(() => "/media/"),
    csrf_token: Some(() => {
      "<input type=\"hidden\" name=\"csrfmiddlewaretoken\" value=\"t\">"
    }),
    now: Some(() => "2026-03-05T14:07:09"),
  }
}

///|
test "the host answers url, static and the prefixes" {
  let host = test_host()
  assert_eq(
    @moonpug.render("{{ url('post', 42) }}", Json::object(Map([])), host~) catch {
      e => "refused: \{e}"
    },
    "/post/42",
  )
  assert_eq(
    @moonpug.render("{{ url('post', slug='x') }}", Json::object(Map([])), host~) catch {
      e => "refused: \{e}"
    },
    "/post/slug=x",
  )
  assert_eq(
    @moonpug.render(
      "{{ static('css/site.css') }} {{ static_prefix() }}{{ media_prefix() }}",
      Json::object(Map([])),
      host~,
    ) catch {
      e => "refused: \{e}"
    },
    "/static/css/site.css /static//media/",
  )
}

///|
test "the host token is markup and its clock is formatted" {
  let host = test_host()
  assert_eq(
    @moonpug.render("{{ csrf_token() }}", Json::object(Map([])), host~) catch {
      e => "refused: \{e}"
    },
    "<input type=\"hidden\" name=\"csrfmiddlewaretoken\" value=\"t\">",
  )
  assert_eq(
    @moonpug.render("{{ now('Y-m-d H:i') }}", Json::object(Map([])), host~) catch {
      e => "refused: \{e}"
    },
    "2026-03-05 14:07",
  )
  assert_eq(
    @moonpug.render("{{ now('DATE_FORMAT') }}", Json::object(Map([])), host~) catch {
      e => "refused: \{e}"
    },
    "March 5, 2026",
  )
}

///|
test "a seam the host does not answer stays undefined" {
  assert_eq(
    @moonpug.render("{{ url('post') }}", Json::object(Map([])), host={
      ..@moonpug.host,
      asset: Some(path => "/s/" + path),
    }) catch {
      e => "refused: \{e}"
    },
    "refused: <template>:1: url is undefined",
  )
  assert_eq(
    @moonpug.render("{{ static('a.css') }}", Json::object(Map([])), host={
      ..@moonpug.host,
    }) catch {
      e => "refused: \{e}"
    },
    "refused: <template>:1: static is undefined",
  )
}

///|
test "the clock is asked only when it is used" {
  let asked = Ref(0)
  let host : @moonpug.Host = {
    ..@moonpug.host,
    now: Some(() => {
      asked.val += 1
      "2026-03-05T14:07:09"
    }),
  }
  ignore(
    @moonpug.render("nothing to see", Json::object(Map([])), host~) catch {
      e => "refused: \{e}"
    },
  )
  assert_eq(asked.val, 0)
}

///|
test "firstof is the first truthy of a list" {
  assert_eq(
    r(
      "{{ ([a, b, c]|reject('none')|first) }}",
      context="{ \"a\": null, \"b\": \"second\", \"c\": \"third\" }",
    ),
    "second",
  )
  assert_eq(
    r(
      "{% set a = '' %}{{ (a or b or c) }}",
      context="{ \"b\": \"\", \"c\": \"third\" }",
    ),
    "third",
  )
}

///|
test "regroup is groupby" {
  assert_eq(
    r(
      "{% for group, rows in people|groupby('city') %}{{ group }}:{{ rows|length }} {% endfor %}",
      context="{\"people\": [{\"city\": \"Oslo\"}, {\"city\": \"Rome\"}, {\"city\": \"Oslo\"}]}",
    ),
    "Oslo:2 Rome:1 ",
  )
}

///|
test "ifchanged is loop.changed" {
  assert_eq(
    r(
      "{% for x in [1, 1, 2, 2, 3] %}{% if loop.changed(x) %}{{ x }}{% endif %}{% endfor %}",
    ),
    "123",
  )
}

///|
test "lorem is lipsum, and cycle is cycler" {
  assert_eq(r("{{ lipsum(1, false, 3, 4)|wordcount }}", context="{}"), "3")
  assert_eq(
    r(
      "{% set c = cycler('a', 'b') %}{{ c.next() }}{{ c.next() }}{{ c.next() }}",
    ),
    "aba",
  )
}

///|
test "now reads the host clock, and the date filter reads a value" {
  let host = test_host()
  assert_eq(
    @moonpug.render(
      "{{ now('H:i') }} {{ '2026-03-05T14:07:09'|date('H:i') }}",
      Json::object(Map([])),
      host~,
    ) catch {
      e => "refused: \{e}"
    },
    "14:07 14:07",
  )
}
