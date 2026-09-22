# moonpug

A template engine: `Jinja2` to use, `Pug` to write, one expression language for
both.

> **Status: planned.** The repository is set up; nothing is implemented yet.

```moonbit
@pug.render(template, { "user": "Leo" })     // indentation syntax
@html.render(template, { "user": "Leo" })    // HTML with the same braces
```

## Two syntaxes, one engine

| Package | Syntax | For |
|:--|:--|:--|
| `pug` | Indentation, `a(href=url)= text` | Writing a page by hand |
| `html` | HTML5 with `{{ }}` and `{% %}` | A designer's file, marked up in place |

The expression language, the filters, the inheritance (`extends` / `block`) and
the escaping are the engine's and are shared; only the surface differs.

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
