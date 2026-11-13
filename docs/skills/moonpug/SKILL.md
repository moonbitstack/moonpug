---
name: moonpug
description: Templates for MoonBit — HTML, Pug and Markdown pages over one expression language. Use it to render a page, a component or an email from data, and to write a generator whose pages come from templates.
---

# moonpug

```bash
moon add moonbitstack/moonpug
```

```moonbit
import {
  "moonbitstack/moonpug",
}
```

`@moonpug.render(source, data)` compiles and renders in one call. When a template renders more than once, compile it:

```moonbit
let data : Json = { "title": "Notes", "name": "ada" }
let env = @moonpug.Env::new()
let page = env.compile("Hello {{ name|title }}!")
let one = page.render(data)
assert_eq(one, "Hello Ada!")
```

The context is anything that converts to `Json` — a `#derive(ToJson)` struct, a map literal, a parsed document.

## A page in any of the three languages

`.html`, `.pug` and `.md` templates all write HTML5; the name picks the language, or `format` does:

```moonbit
let pug = @moonpug.render("h1= title", data, format=@moonpug.pug)
assert_eq(pug, "<h1>Notes</h1>")
let md = @moonpug.render("# {{ title }}\n", data, format=@moonpug.markdown)
assert_eq(md, "<h1>Notes</h1>\n")
```

A Markdown template is rendered to Markdown and then read as Markdown. Values are escaped before they enter the Markdown, so data cannot put a tag in the page. HTML you wrote yourself is escaped too unless the stretch says `safe=false`:

```moonbit
let note = env.compile(
  "{% block lang=md safe=false %}<div class=\"note\">body</div>{% endblock %}",
)
assert_eq(note.render(data), "<div class=\"note\">body</div>\n")
```

To write a Markdown file rather than a page, use `@moonpug.text`: braces still work and nothing is converted.

```moonbit
let file = @moonpug.render("# {{ title }}\n", data, format={ ..@moonpug.text, keep_trailing_newline: true })
assert_eq(file, "# Notes\n")
```

## Templates by name, and blocks in two languages

```moonbit
let sources : Map[String, String] = Map([
  ("layout.html", "<main>{% block body %}{% endblock %}</main>"),
])
let env = @moonpug.Env::new(load=name => sources.get(name))
let page = env.template("layout.html")
assert_eq(page.render(data), "<main></main>")
```

`load` serves `extends`, `include`, `import` and `Env::template`. One template can switch language anywhere, and a block in another language is converted by its own language:

```moonbit
let mixed = @moonpug.render("<section>{% block lang=pug %}em x{% endblock %}</section>", data)
assert_eq(mixed, "<section><em>x</em></section>")
```

## Rules that catch people out

- `undefined` is strict by default: a missing name is refused. Ask `is defined`, give it a `default`, or set `undefined: Lenient`.
- A filter, test or global registered with `Env::add_filter`, `add_test` or `add_global` replaces the built-in of that name; there is no second layer.
- `Env` keeps compiled templates, so a template read through `load` is parsed once. `render` parses on every call.
- Refusals name the template and the line, and cross the boundary as `@moonpug.Refused`: `Syntax`, `Unknown`, `Invalid`, `Exceeded`.
- Markdown's output is a page: put `safe=false` on a block, or `Format.safe = false` on the format, when a template has to carry its own HTML.
- A language of your own is a name, a reader and a `finish` conversion; Markdown's `finish` is the two-step conversion above.
