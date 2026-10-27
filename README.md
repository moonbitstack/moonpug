<div align="center">

<h1>moonpug</h1>

<p><em>One page, three ways to write it.</em></p>

<p>Templates for MoonBit: text with braces, indented markup, or Markdown, over one expression language.<br>
Compiled once, rendered as often as you like; no file, clock or socket unless you hand one in.</p>

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
// Hello Ada!
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

Data goes in as anything that converts to `Json`: a `derive(ToJson)` struct, a map, a parsed document.

<!-- nocheck -->
```moonbit
struct Book {
  title : String
  year : Int
  tags : Array[String]
} derive(ToJson)

struct Shelf {
  shelf : String
  books : Array[Book]
} derive(ToJson)

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
| `md` | `markdown` | the brace syntax, with a tag on a line of its own leaving no blank line | `markdown` |

```moonbit
let data : Json = { "title": "Notes", "items": ["ink", "paper"] }
@moonpug.render("h1= title\neach i in items\n  p= i", data, format=@moonpug.pug)
// <h1>Notes</h1><p>ink</p><p>paper</p>
```

A named template picks its format from the extension: `.pug` and `.pg` read as `pug`, `.md` as Markdown, `.html` `.htm` `.xml` `.svg` as escaped HTML, anything else as text.

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

Built in: 79 filters (among them `date`, `timesince`, `floatformat`, `pluralize`, `urlize`, `wordwrap`, `tojson`, `json_script`, `groupby`, `dictsort`, `xmlattr`), 39 tests, and the globals `range`, `dict`, `lipsum`, `cycler`, `joiner`, `namespace` and the `gettext` family.

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

## Your own language

A language is a name, its aliases, how its brace tags treat whitespace, and a reader that turns source into the tree. The built-in three are registered the same way:

<!-- nocheck -->
```moonbit
fn read_csv(source : String, reading : @moonpug.Reading) -> Array[@syntax.Node] raise @moonpug.Refused {
  ...
  nodes.append(reading.block(cell, "html", None, reading.line))   // cells read as HTML
  ...
}

env.add_lang({ name: "csv", aliases: ["table"], options: @syntax.options, read: read_csv })
```

Then `{% block lang=csv %}` and `Format.lang = "csv"` both work. `moonbitstack/moonpug/syntax` has the tree and the parsers for expressions and statements, so a reader can reuse them.

## Settings

| Record | Fields | Preset |
|:--|:--|:--|
| `Format` | `lang`, `autoescape`, `trim_blocks`, `lstrip_blocks`, `keep_trailing_newline` | `html`, `pug`, `markdown`, `text` |
| `Settings` | `format`, `formats`, `force`, `undefined`, `line_statement`, `line_comment`, `limits` | `settings` |
| `Limits` | `depth` (1000), `range` (100 000) | `limits` |

`undefined` is `Strict` by default: a missing name is refused, except where a template asks `is defined` or gives a `default`. `Lenient` prints it as nothing; `Chainable` also lets its attributes be missing.

### Configuration precedence

```
library preset  <  the record you pass  <  the same name passed to this call
```

`render(source, data, settings=s, format=f, force=b)`: `format` and `force` override the ones in `s`, and `s` overrides the preset `settings`.

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

```bash
moon run src/examples/01-first-page
moon run src/examples/02-three-languages
moon run src/examples/03-template-set
moon run src/examples/04-own-language
moon run src/examples/05-host-objects
moon run src/examples/06-minimal-site
moon run src/examples/07-feature-tour
moon run src/examples/08-application
```

## Licence

Apache-2.0. See [LICENSE](LICENSE).
