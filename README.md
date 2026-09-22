# moonpug

A template engine: all of Jinja2, plus what Django and Pug have that Jinja does
not, in Jinja's spelling.

> **Status: planned.** The repository is set up; nothing is implemented yet.

```moonbit
@moonpug.render(source, context)                  // braces, Jinja's vocabulary
@moonpug.render(source, context, syntax=Indent)   // Pug's indentation
```

## One vocabulary, two surfaces

**Jinja2 is the whole of it**: every statement, all 51 filters, all 30 tests,
the globals, the `loop` object, the three undefined strategies, whitespace
control, line statements, and the i18n extension.

**Django and Pug supply what Jinja lacks, in Jinja's form.** Where the two say
the same thing, Jinja's spelling is the one that exists here: `{% else %}` not
`{% empty %}`, `{% raw %}` not `{% verbatim %}`, `loop.index` not
`forloop.counter`, `super()` not `block.super`, `|f(a)` not `|f:a`. Where Django
has something Jinja does not — `date`, `slugify`, `pluralize`, `linebreaks` —
it is added as a filter named the way Jinja names filters.

**Two surfaces, one meaning.** Braces and Pug's indentation are two ways of
writing the same tree: a line beginning with `<` is literal HTML, one beginning
with `{%` is a block, anything else is a Pug line, and `#{expr}` and `{{ expr }}`
both interpolate anywhere. An `extends` chain may cross surfaces, because what
it exchanges is a block, not text.

Nothing reads a file: `extends` and `include` take a `load` function, and the
i18n statements take a `translate` function. The caller supplies both.

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
