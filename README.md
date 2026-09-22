# moonpug

A template engine: Jinja2 and Fumi written the same way, Pug when indentation
suits better, one expression language under all of them.

> **Status: planned.** The repository is set up; nothing is implemented yet.

```moonbit
@html.render(template, { "user": "Leo" })    // HTML with `{% %}` blocks
@pug.render(template, { "user": "Leo" })     // indentation
```

## Two packages, three ways of writing

| Package | Block structure | Understands |
|:--|:--|:--|
| `html` | `{% ... %}` | Jinja's `{{ x }}`, `{% if %}`, `{% elif %}`, `{% for %}`, `{% block %}` — **and** Fumi's `{% else-if %}`, `{% for x in xs :key="x.id" %}`, `{% show %}`, `{% once %}`, `{% html raw %}` |
| `pug` | Indentation | `a(href=url)= text`, `#{expr}`, `{{ expr }}` |

**Jinja and Fumi mix freely**, because they are the same grammar with two
vocabularies: the tags they share mean the same thing and the rest is addition.
One tokenizer, one table.

**Pug and the brace blocks do not mix**, because their block structure is
different — indentation against explicit ends — and in one file the two would
fight over scope. That is the grammar talking, not a rule. Inline interpolation
is not block structure, so `#{expr}` and `{{ expr }}` both work inside Pug.

The expression language, the filters, the inheritance (`extends` / `block`), the
escaping and the source mapping are the engine's; only the block structure
differs.

## What it does not do

**Parse documents.** It writes text. Reading HTML back into a tree is
[`moonxml`](https://github.com/moonbitstack/moonxml), and this does not depend on
it: an engine that parsed its own output would be doing the work twice.

**Autoescape by accident.** Escaping is on, and what is already safe says so —
the one decision that stops a template from writing an injection.

## Install

```bash
moon add moonbitstack/moonpug
```

## Licence

Apache-2.0. See [LICENSE](LICENSE).
