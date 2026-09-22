# moonpug

A template engine: everything Jinja2, Django, Pug and Fumi can do, spelled the
way Jinja does it.

> **Status: planned.** The repository is set up; nothing is implemented yet.

```moonbit
@moonpug.render(source, context)                  // braces, Jinja's vocabulary
@moonpug.render(source, context, syntax=Indent)   // Pug's indentation
```

## Everything the four of them do, spelled the way Jinja does

**Jinja2 whole**: every statement, all 51 filters, all 30 tests, the globals, the
`loop` object, the three undefined strategies, whitespace control, line
statements, and the i18n extension.

**Django, Pug and Fumi bring the rest.** Nothing is dropped for being someone
else's idea; only spellings are. Where two of them say the same thing, Jinja's
is the one that exists here — `{% else %}` not `{% empty %}`, `{% raw %}` not
`{% verbatim %}`, `loop.index` not `forloop.counter`, `super()` not
`block.super`, `|f(a)` not `|f:a`, `elif` not `else-if`. Where they have
something Jinja does not, it is added in Jinja's shape:

| From | Capability | Here |
|:--|:--|:--|
| Django | `date`, `slugify`, `pluralize`, `linebreaks`, `yesno`, … | Filters, named the way Jinja names filters |
| Django | `url`, `static`, `csrf_token`, `now`, `querystring` | Globals the caller registers — Jinja's own answer to host knowledge, as Flask does with `url_for` |
| Django | `cycle`, `regroup`, `ifchanged`, `spaceless`, `firstof` | `cycler()`, `|groupby`, `loop.changed()`, `|spaceless`, an expression |
| Fumi | `show` | Renders, and hides with an inline style when false — what `v-show` means once the markup has left the server |
| Fumi | `once` | Caches that piece under a key; the store is supplied by the caller |
| Fumi | `:key` | Emitted as `data-key`, and handed to the caller as an annotation |
| Pug | `block append` / `prepend` | Modifiers on `{% block %}`; Jinja can only override |
| Pug | Element shorthand, `&attributes`, content filters, `doctype` | Kept, because they are the indentation surface |

**Two surfaces, one meaning.** A line beginning with `<` is literal HTML, one
beginning with `{%` is a block, anything else is a Pug line; `#{expr}` and
`{{ expr }}` both interpolate anywhere. An `extends` chain may cross surfaces,
because what it exchanges is a block, not text.

Nothing reads a file or a clock: `extends` and `include` take a `load` function,
the i18n statements take a `translate` function, and the host globals are
registered by the caller.

## What it does not do

**Parse documents.** It writes text. Reading HTML back into a tree is
[`moonxml`](https://github.com/moonbitstack/moonxml), and this does not depend on
it: an engine that parsed its own output would be doing the work twice.

**Autoescape by accident.** Escaping is on, and what is already safe says so —
the one decision that stops a template from writing an injection.

**Compile to host code.** Neither JSP's shape (markup outside, code inside) nor
JSX's (code outside, markup inside). This is a template engine; a template is
data, and it stays data.

## Install

```bash
moon add moonbitstack/moonpug
```

## Licence

Apache-2.0. See [LICENSE](LICENSE).
