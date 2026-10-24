# moonpug

[![check and test](https://github.com/moonbitstack/moonpug/actions/workflows/ci.yml/badge.svg)](https://github.com/moonbitstack/moonpug/actions/workflows/ci.yml)

A template engine for MoonBit: **Jinja2 is the vocabulary**, Pug's
indentation and Slim's attribute wrapping are surfaces over it, and
Django's capability set fills the gaps — one expression language, one
evaluator, one set of names.

It writes text; it does not parse documents. Reading HTML back into a
tree is [`moonxml`](https://github.com/moonbitstack/moonxml)'s job, and
this does not depend on it: an engine that parsed its own output would be
doing the work twice.

## The three surfaces

A source is read in one of three surfaces, and a block can switch language
anywhere in the middle:

| Surface | Spelling | Default for |
|:--|:--|:--|
| `Html` | text with `{{ }}`, `{% %}`, `{# #}` | `render(...)` |
| `Pug` | indentation, `#{ }` interpolation, `<` lines pass HTML through | `syntax = Pug` |
| `Markdown` | the brace surface with blank-line-friendly whitespace presets | `syntax = Markdown` |

```moonbit
@moonpug.render("Hello, {{ name }}!", @json.parse("{ \"name\": \"moonbit\" }"))
@moonpug.render("p Hello #{name}", ctx, syntax = Pug)
@moonpug.render("{{ n }}\n{% block lang=pug %}p= n * 2{% endblock %}", ctx)
```

A block recurses: `{% block lang=pug %} … {% endblock %}` nests, keeps the
variables around it, and under `force = true` a language the outer surface
does not speak stays literal text.

## The interface

Every function, its type, its errors, and where each default comes from.

### `render`

```moonbit
pub fn render(
  source : StringView,
  context : Json,                     // a JSON object; the template's top scope
  settings? : Settings,               // the record; `settings` is the preset
  name? : String,                     // for fault messages; "<template>" otherwise
  syntax? : Syntax,                   // flat mirror of settings.syntax
  force? : Bool,                      // flat mirror of settings.force
  load? : (String) -> String?,        // extends/include/import; None refuses them
  translate? : (String, String?, Int?) -> String?,   // gettext seam; None = identity
  cache? : (String, () -> String raise Fault) -> String raise Fault,  // {% once %}
  undefined_policy? : UndefinedPolicy,               // flat mirror; Strict by default
  wins? : Wins,                       // Base | Extra; Extra (the caller) by default
  clash? : OnClash[Entry],            // Ignore | Panic | Handle; Ignore by default
) -> String raise Fault
```

Defaults and their provenance:

| Default | Value | Taken from |
|:--|:--|:--|
| `autoescape` | on | Jinja2's default; the one decision that stops a template writing an injection |
| `undefined_policy` | `Strict` | Jinja2's `StrictUndefined`; the family's rule that safety is default and relaxation explicit |
| `trim_blocks` / `lstrip_blocks` | off | Jinja2's defaults (both on automatically for the Markdown surface, as markdown expects) |
| `wins` | `Extra` | the house priority: the more specific, the caller's, wins |
| `clash` | `Ignore` | silent precedence, the Axios/Terraform shape |

### The registries

Filters, tests, globals and the loader are traits. Everything the library
ships is registered through the same traits a caller uses — there is no
second, privileged path.

```moonbit
pub trait Filter { filter(Self, Context, Value, Array[Value], Map[String, Value]) -> Value raise Fault }
pub trait Test   { probe(Self, Value, Array[Value]) -> Bool raise Fault }
pub trait Global { call(Self, Context, Array[Value], Map[String, Value]) -> Value raise Fault }
pub trait Loader { load(Self, String) -> String? }
```

Register by putting implementations into `Settings.filters`, `.tests`,
`.globals`, `.loader` — or write the record update:

```moonbit
let mine : MyFilter = MyFilter
@moonpug.render(src, ctx, settings = { ..settings, filters: add_filter(mine) })
```

Host knowledge — `url()`, `static()`, `csrf_token()`, `now()` — is not
built in. It enters as registered globals, the way Flask registers
`url_for`; the engine defines the calling convention and the caller
(moonapi) owns the implementation.

### Configuration priority

```
library preset  <  the record passed  <  this call's flat mirrors
```

`wins = Base` reverses the last two; `clash = Panic` refuses a name that
meets a builtin; `clash = Handle(f)` receives both entries and returns the
one that stays. This paragraph appears here, on every registry-taking
function's doc comment, and on the docs site, in the same words.

### `Value`

Templates see a dynamic value: `Null`, `Bool`, `Int`, `Double`, `Text`,
`Markup` (already trusted), `Seq`, `Dict`, `Namespaced`, `Macro`, and the
cycler/joiner handles. `Macro` is constructible by the engine and readable
by callers (`name`, `params`, `rest`); its body stays the engine's.

## What is in the box

- **Jinja2 whole**: every statement, all 51 filters, all 30 tests, the six
  globals, the complete `loop` object (including `cycle`, `changed`,
  `previtem`/`nextitem` and recursion), the three undefined policies,
  whitespace control, line statements, and the i18n extension with the
  gettext family over the `translate` seam.
- **Django's capability set**, spelled Jinja's way: `empty` → `else`,
  `verbatim` → `raw`, `forloop.counter` → `loop.index`, `block.super` →
  `super()`, `|f:a` refused, and the supplement filters (`date`, `slugify`,
  `pluralize`, `linebreaks`, `yesno`, `json_script`, `truncatechars`,
  `unordered_list`, `escapejs`, …) with Django's own semantics.
- **Pug's surface**: elements and shorthand, three kinds of attribute
  brackets (Slim's wrapping), `&attributes` splats, the `:key` diff key as
  `data-key`, `each`/`if`/`unless`/`case`, mixins with caller bodies,
  `block append`/`prepend`, doctype shorthands, content filters as
  `{% filter %}` — minified output, like Pug's own.
- **Vue-shaped extras**: `{% show cond %}` renders and hides with an inline
  style when false; `{% once key %}` caches a fragment through the `cache`
  seam; `:key` becomes `data-key`.
- **A sandbox**: `sandbox = true` turns attribute access away (subscripts
  still work) and pins escaping on.

## Errors

A lexical fault names the template, the one-based line and column, and the
reason: `page.html:2:7: an expression cannot start here`. Every other
fault — an unknown filter, a missing name under the strict policy, a
wrong arity — says which of the three it is and what it saw.

## Not here, on purpose

No custom-tag plugin system, no async templates, no bytecode cache, no
host-code compilation, no I/O of any kind: the engine opens no files,
reads no clock, and touches no socket.

## Install

```bash
moon add moonbitstack/moonpug
```

Then run the examples:

```bash
moon run examples/tour    # every feature in one pass
moon run examples/page    # one page, both surfaces, byte-identical
```

## Documentation

The full handbook — guides for each surface, the filter and test
reference, the extension traits, and a live playground — ships in
[`docs/`](docs/index.html) and renders at the project's GitHub Pages.

## Licence

Apache-2.0. See [LICENSE](LICENSE).
