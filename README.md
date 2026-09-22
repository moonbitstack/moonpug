# moonpug

A template engine: Jinja2, Django and Fumi written as one, Pug when indentation
suits better, one expression language under all of them.

> **Status: planned.** The repository is set up; nothing is implemented yet.

```moonbit
@moonpug.render(source, context)                  // braces: Jinja / Django / Fumi
@moonpug.render(source, context, syntax=Indent)   // Pug
```

## Four ways of writing, two front ends

| Written as | Block structure | Its own |
|:--|:--|:--|
| Jinja2 | `{% %}` | `raw`, `loop.index`, `super()`, `\|f(a)` |
| Django | `{% %}` | `empty`, `verbatim`, `with`, `cycle`, `forloop.*`, `block.super`, `\|f:a` |
| Fumi | `{% %}` | `else-if`, `show`, `once`, `html`, `:key` |
| Pug | Indentation | `a(href=x)= text`, mixins, `#{expr}` |

**The first three mix freely.** They are one grammar with three vocabularies:
the tags they share mean the same thing, the rest is addition, and the two
filter-argument spellings are told apart by the character after the name.

**Pug is the other front end**, because indentation and explicit ends fight over
scope in one file. Inline interpolation is not block structure, so `#{expr}` and
`{{ expr }}` both work inside Pug. An `extends` chain is all of one kind.

Everything after the front end — the expression language, the filters, the
inheritance, the escaping, the source mapping — is shared.

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
