<div align="center">

<h1>moonpug</h1>

<p><em>One page, three ways to write it.</em></p>

<p>Templates for MoonBit: text with braces, indented markup, or Markdown, over one expression language.<br>
All three write HTML5. Compiled once, rendered as often as you like; no file, clock or socket unless you hand one in.</p>

<p>
  <a href="https://moonbitstack.github.io/moonpug/">Home</a> ·
  <a href="https://moonbitstack.github.io/moonpug/guide.html">Guide</a> ·
  <a href="https://moonbitstack.github.io/moonpug/api.html">API</a> ·
  <a href="https://moonbitstack.github.io/moonpug/builtins.html">BtIns</a> ·
  <a href="https://mooncakes.io/docs/moonbitstack/moonpug">mooncakes.io</a>
</p>

</div>

<table>
<tr>
<th>html</th><th>pug</th><th>md</th>
</tr>
<tr>
<td>

```html
<ul>
{% for b in books %}
  <li>{{ b.title }}</li>
{% endfor %}
</ul>
```

</td>
<td>

```pug
ul
  each b in books
    li= b.title
```

</td>
<td>

```markdown
{% for b in books %}
- {{ b.title }}
{% endfor %}
```

</td>
</tr>
</table>

```moonbit
let out = @moonpug.render("Hello {{ name|title }}!", { "name": "ada" })
assert_eq(out, "Hello Ada!")
```

## Install

```bash
moon add moonbitstack/moonpug
```

<!-- nocheck -->
```moonbit
import {
  "moonbitstack/moonpug",
}
```

## A first page

Data goes in as anything that converts to `Json`: a `#derive(ToJson)` struct, a map, a parsed document.

<!-- nocheck -->
```moonbit
#derive(ToJson)
struct Book {
  title : String
  year : Int
  tags : Array[String]
}

#derive(ToJson)
struct Shelf {
  shelf : String
  books : Array[Book]
}

let page =
  #|<h1>{{ shelf }}</h1>
  #|<ul>{% for b in books|sort(attribute='year') %}
  #|  <li>{{ b.title }}, {{ b.year }}{% if b.tags %} ({{ b.tags|join(', ') }}){% endif %}</li>
  #|{% endfor %}</ul>
let html = @moonpug.render(page, Shelf::{ shelf: "Reading <list>", books: [...] })
```

Output is escaped by default: `Reading <list>` is written as `Reading &lt;list&gt;`. `|safe` marks text you trust.

## Three languages

| Name | Also | Reads | Preset |
|:--:|:--:|:--|:--:|
| `html` | | text with `{{ }}`, `{% %}` and `{# #}` | `html` (escaped), `text` (not escaped) |
| `pug` | `pg` | elements by indentation, `<` lines passed through, `{% %}` lines as statements | `pug` |
| `md` | `markdown` | the brace syntax, then Markdown | `markdown` |

```moonbit
let data = @json.parse("{\"title\": \"Notes\", \"items\": [\"ink\", \"paper\"]}")
let page = @moonpug.render("h1= title\neach i in items\n  p= i", data, format=@moonpug.pug)
assert_eq(page, "<h1>Notes</h1><p>ink</p><p>paper</p>")
```

A named template picks its format from the extension: `.pug` and `.pg` read as `pug`, `.md` and `.markdown` as Markdown, `.html` `.htm` `.xml` `.svg` as escaped HTML, anything else as text.

### Markdown writes HTML

The output of an `md` template is a page, not Markdown. The template is rendered first, and what it wrote is then read as Markdown:

```text
{# the template #}
## {{ title }}

{% for p in points %}
- {{ p }}
{% endfor %}

{# what it writes #}
<h2>Notes</h2>

- ink
- paper

{# the page #}
<h2>Notes</h2>
<ul>
<li>ink</li>
<li>paper</li>
</ul>
```

Values are escaped before they enter the Markdown, so a tag in the data stays text; the conversion runs afterwards and leaves the entities alone. HTML the template's author wrote is escaped as well, unless the stretch says `safe=false`:

```text
{% block lang=md safe=false %}
<div class="note"><p>body</p></div>
{% endblock %}
```

A language block inside Markdown is not converted a second time: it is rendered on its own, held under a mark, and put back once the Markdown around it is done.

`{% filter markdown %}` and the indentation syntax's `:markdown` run the same conversion, without registering anything:

```text
{% filter markdown %}
## From a string
{% endfilter %}
```

To write a Markdown file — the `README.md` of a generator, a changelog — use the `text` format: the template is still read with braces and nothing is converted. `Lang.finish` is the seam behind all of this: a language carries the conversion its output goes through, and a language of your own can carry its own.

### Language blocks

Any part of a template can switch language, and blocks nest:

```text
<section>
{% block lang=pug %}
ul
  each i in items
    li= i
{% endblock %}
</section>
```

A whole template is one big block in its own language. With `force=true` a stretch reads only its own language: inside `pug` and `md`, blocks in another language stay as text and HTML still reads; inside `html`, `pug` and `md` blocks stay as text. A block's own `force=` wins over the one around it; `Settings.force` sets it for the whole template.

## What a template can say

Statements: `if`/`elif`/`else`, `for`/`else` with `loop`, `break`, `continue`, `set` (with a block and a filter), `with`, `macro` and `call`, `filter`, `include` (`ignore missing`, `with context`), `import` and `from … import`, `extends` and `block` (`super()`, `scoped`, `required`, `append`, `prepend`), `raw`, `autoescape`, `do`, `trans`/`pluralize`, `once`, `show`, `debug`.

Expressions: literals, lists, tuples and maps, attributes and subscripts, slices, arithmetic with `//`, `%` and `**`, comparisons that chain, `in`, `and`/`or`/`not`, `~` to join as text, inline `if`/`else`, filters with `|` and tests with `is`. Strings, lists and maps carry their methods: `'a,b'.split(',')`, `'{:>8.2f}'.format(x)`, `'%s=%d' % (k, v)`, `d.items()`.

Built in: 85 filters (among them `date`, `timesince`, `floatformat`, `pluralize`, `urlize`, `wordwrap`, `tojson`, `json_script`, `groupby`, `dictsort`, `xmlattr`, `slugify`, `truncatechars_html`, `widthratio` and `markdown`, which is the conversion described above), 39 tests, and the globals `range`, `dict`, `lipsum`, `cycler`, `joiner`, `namespace`, `templatetag`, `query_string` and the `gettext` family.

In the indentation syntax: tags with `#id` and `.class`, attributes in `( )`, or `[ ]` and `{ }` when a long list wraps, `&attributes`, `#{}` and `!{}` interpolation, `#[tag]` inline, `|` and `.` text, `if`/`unless`/`each`/`case`, mixins with blocks and attributes, `include` with a block that lands at `yield`, `extends` with `block append` and `prepend`, `doctype`, comments, and `:name` content filters.

## Data, functions and objects

```moonbit
let env = @moonpug.Env::new()
env.add_global("today", @moonpug.Value::func("today", (_, _, _) => Text("2026-10-25")))
env.add_filter("money", (call, value, _, _) => Text("¥" + call.text(value)))
env.add_test("short", (call, value, _) => call.text(value).length() <= 3)
```

A host value joins a template by implementing `Object`. Every method has a default; implement the ones it needs:

<!-- nocheck -->
```moonbit
impl @moonpug.Object for Cart with fn kind(_) { "the cart" }
impl @moonpug.Object for Cart with fn attr(self, name) { ... }     // cart.total
impl @moonpug.Object for Cart with fn items(self) { ... }          // for x in cart
impl @moonpug.Object for Cart with fn assign(self, name, value) { ... }  // {% set cart.coupon = … %}

env.compile(source).render_values({ "cart": Object(cart) })
```

`call`, `callable` and `show` complete the set.

## Templates by name

<!-- nocheck -->
```moonbit
let env = @moonpug.Env::new(load=name => sources.get(name))
let page = env.template("page.html")   // read, compiled and kept
page.render(data)
```

`load` serves `extends`, `include`, `import` and `Env::template`. `translate` answers `{% trans %}` and `gettext`: given a message, its context and the plural count, the translation or `None`. `cache` stores what `{% once key %}` renders. All three are functions you pass in.

## What the program answers

Addresses, static files, form tokens and the clock belong to the program. Register them once and templates can name them; what is not registered is undefined:

<!-- nocheck -->
```moonbit
let host : @moonpug.Host = {
  url: Some((name, args, named) => routes.url(name, args, named)),
  asset: Some(path => "/static/" + path),
  asset_prefix: Some(() => "/static/"),
  media_prefix: Some(() => "/media/"),
  csrf_token: Some(() => forms.token()),
  now: Some(() => clock.now_iso()),
}
@moonpug.Env::new().add_host(host~)
```

| Global | Answers |
|:--|:--|
| `url(name, …)` | the address of a route, the rest of the arguments filling it |
| `static(path)`, `static_prefix()` | where static files are served from |
| `media_prefix()` | where uploaded files are served from |
| `csrf_token()` | the token a form carries, as markup |
| `now(format)` | the moment, in the date-format letters |

`now` takes the time as ISO 8601 text and applies the format letters here, so the program only says what time it is. Anything else a template needs goes through `add_global`, which takes any `Value::func`.

## Your own language

A language is a name, its aliases, how its brace tags treat whitespace, a reader that turns source into the tree, and the conversion its output goes through. The built-in three are registered the same way:

<!-- nocheck -->
```moonbit
fn read_csv(source : String, reading : @moonpug.Reading) -> Array[@syntax.Node] raise @moonpug.Refused {
  ...
  nodes.append(reading.block(cell, "html", None, reading.line))   // cells read as HTML
  ...
}

env.add_lang({
  name: "csv",
  aliases: ["table"],
  options: @syntax.options,
  read: read_csv,
  finish: None,   // the reader writes the page itself
})
```

Then `{% block lang=csv %}` and `Format.lang = "csv"` both work. A language whose output is not HTML yet — AsciiDoc, reStructuredText — gives `finish` the text the stretch rendered and the `Reading` it rendered in, and returns what belongs in the page; Markdown's finish is the conversion described above. `moonbitstack/moonpug/syntax` has the tree and the parsers for expressions and statements, so a reader can reuse them.

## Settings

| Record | Fields | Preset |
|:--|:--|:--|
| `Format` | `lang`, `autoescape`, `safe`, `trim_blocks`, `lstrip_blocks`, `keep_trailing_newline` | `html`, `pug`, `markdown`, `text` |
| `Settings` | `format`, `formats`, `force`, `undefined`, `line_statement`, `line_comment`, `delimiters`, `shortcuts`, `limits` | `settings` |
| `Delimiters` | `variable_start`, `variable_end`, `block_start`, `block_end`, `comment_start`, `comment_end` | `delimiters` |
| `Limits` | `depth` (1000), `range` (100 000), `write` (8 MiB) | `limits` |
| `Host` | `url`, `asset`, `asset_prefix`, `media_prefix`, `csrf_token`, `now` | `host` (all `None`) |

`undefined` is `Strict` by default: a missing name is refused, except where a template asks `is defined` or gives a `default`. `Lenient` prints it as nothing; `Chainable` also lets its attributes be missing. `safe` is about HTML the template's author wrote: on, a converter escapes it, as Markdown readers read a page with `html: false`; `{% block lang=md safe=false %}` turns it off for one stretch.

### Configuration precedence

```
library preset  <  the record you pass  <  the same name passed to this call
```

`render(source, data, settings=s, format=f, force=b, delimiters=d, shortcuts=c, host=h)`: each named argument overrides the field of the same name in `s`, and `s` overrides the preset `settings`.

### Delimiters and shorthands

The strings that make a tag are settings, so a template can stay out of another language's way:

```moonbit
let square = { ..@moonpug.delimiters, variable_start: "[[", variable_end: "]]" }
let hi = @moonpug.render("Hi [[ name ]]! {{ stays }}", { "name": "Ada" }, delimiters=square)
assert_eq(hi, "Hi Ada! {{ stays }}")
```

Statement and comment pairs work the same way, and `-%}`, `+%}`, `raw` and language blocks follow whatever pair is in force. The indentation syntax reads the same settings, both for its `{{ }}` interpolation and for statement lines.

The indentation syntax also takes its shorthand prefixes from the settings: `.` writes a class and `#` an id unless you say otherwise, and a prefix of your own writes the attribute you name.

<!-- nocheck -->
```moonbit
let settings = {
  ..@moonpug.settings,
  shortcuts: Map([(".", "class"), ("#", "id"), ("@", "data-role")]),
}
```

`div@main.a` then writes `<div class="a" data-role="main"></div>`.

### Bounded output

`Limits.write` caps the characters one render may write — code units, so text outside the basic plane counts two each — and it counts what a capture block writes as well, so a macro or a `filter` block cannot grow past the bound either. Crossing it is `Exceeded`, like the depth and `range` bounds.

## Errors

Every refusal is a `Refused` and names the template and line:

| Variant | When |
|:--|:--|
| `Syntax(template, line, column, reason)` | the source is not well formed |
| `Unknown(template, line, kind, name)` | a name, filter, test, template, language or attribute that resolves to nothing |
| `Invalid(template, line, reason)` | values that do not fit: wrong arguments, an operation a type does not take |
| `Exceeded(template, line, limit, got)` | a bound in `Limits` was crossed |

```text
page.html:3: price is undefined
```

## Conformance

The suites below run in CI on every push, on Linux, macOS and Windows. Each one replays the inputs its source published and compares the whole output, not just whether it ran.

| Suite | Cases | Result |
|:--|--:|:--|
| CommonMark 0.31.2 `spec.json`, read as Markdown templates | 652 | 652 render as the Markdown reader renders them; 641 also match the specification's own HTML |
| Jinja 3.1.6 test suite | 500 | all |
| Jinja 3.1.6 filters, methods and formatting | 1748 | all |
| Jinja 3.1.6 i18n extension | 66 | all |
| Django 6.1.2 supplement filters | 253 | all |
| Django 6.1.2 `truncatechars` and `truncatewords` families | 224 | all |
| Pug 3.0.4 cases | 64 + 103 | all |
| One page written in HTML, in Pug and in Markdown | 24 pages | all: the three are one document once a browser's parser has read them |

The eleven CommonMark examples that differ from the specification's HTML are not template questions — the corpus has no template tag in it, and the template frontend reproduces the Markdown reader's output on all 652. They are named here because the reader is what the frontend ends with:

| Examples | Section | Why |
|:--|:--|:--|
| 170, 171, 172, 173, 176, 178 | HTML blocks | `script`, `style` and `textarea` blocks are escaped even where HTML is allowed through, since a browser reads them in a context of their own |
| 602, 606, 608, 611, 612 | Autolinks | the reader's GitHub-flavoured defaults turn a bare address or URL into a link; CommonMark leaves them as text |

## Examples

Each program in `src/examples` runs on its own with `moon run`. They begin with
the smallest render and end with a small application, so they double as a tour:

| Program | Shows |
|:--|:--|
| `01-first-page` | the smallest render: one template, one value |
| `02-three-languages` | the same page in html, pug and md, and a language block inside html |
| `03-template-set` | a layout, a page that extends it, a macro library and an include |
| `04-own-language` | a reader for a language of your own (a small csv renderer) |
| `05-host-objects` | a value the template can read, loop over and change, plus a filter and a global |
| `06-minimal-site` | a minimal but complete generator: compile once, render many pages |
| `07-feature-tour` | a breadth tour of the built-in filters, tests, statements and globals |
| `08-application` | a small application: layout, components, a host object, translation and caching |
| `09-same-page` | twenty-four pages, each written three times; prints them side by side, and as JSON for the check in CI |

```bash
moon run src/examples/01-first-page
moon run src/examples/02-three-languages
moon run src/examples/03-template-set
moon run src/examples/04-own-language
moon run src/examples/05-host-objects
moon run src/examples/06-minimal-site
moon run src/examples/07-feature-tour
moon run src/examples/08-application
moon run src/examples/09-same-page
```

## Licence

Apache-2.0. See [LICENSE](LICENSE).
