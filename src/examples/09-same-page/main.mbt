///|
/// One page, written three ways: the HTML it is, the same page in the
/// indentation syntax, and the same page in Markdown. Rendered through the
/// same data, the three have to come out as the same document.
priv struct Page {
  name : String
  html : String
  pug : String
  md : String
}

///|
fn page(name : String, html : String, pug : String, md : String) -> Page {
  { name, html, pug, md, }
}

///|
/// The data every page is rendered over.
fn data() -> Json {
  {
    "title": "Notes",
    "intro": "Everything here is written by hand.",
    "items": ["ink", "paper"],
    "flag": true,
    "bad": "<script>alert(1)</script>",
    "text": "let x = 1\n",
    "plain": "a & b < c",
  }
}

///|
/// Twenty-four pages, each one small enough to read, each written three
/// times. Every construct the three frontends share appears at least once.
fn pages() -> Array[Page] {
  [
    page("a heading", "<h1>{{ title }}</h1>", "h1= title", "# {{ title }}"),
    page(
      "a paragraph with emphasis", "<p>plain <em>em</em> and <strong>strong</strong></p>",
      "p plain #[em em] and #[strong strong]", "plain *em* and **strong**",
    ),
    page(
      "an unordered list", "<ul><li>one</li><li>two</li></ul>", "ul\n  li one\n  li two",
      "- one\n- two",
    ),
    page(
      "an ordered list", "<ol><li>one</li><li>two</li></ol>", "ol\n  li one\n  li two",
      "1. one\n2. two",
    ),
    page(
      "a list inside a list", "<ul><li>outer<ul><li>inner</li></ul></li></ul>", "ul\n  li\n    | outer\n    ul\n      li inner",
      "- outer\n  - inner",
    ),
    page(
      "a link", "<p><a href=\"/notes\">notes</a></p>", "p: a(href=\"/notes\") notes",
      "[notes](/notes)",
    ),
    page(
      "a link with a title", "<p><a href=\"/x\" title=\"a title\">x</a></p>", "p: a(href=\"/x\" title=\"a title\") x",
      "[x](/x \"a title\")",
    ),
    page(
      "inline code", "<p>run <code>moon test</code> first</p>", "p run #[code moon test] first",
      "run `moon test` first",
    ),
    page(
      "a code block", "<pre><code class=\"language-mbt\">{{ text }}</code></pre>",
      "pre\n  code.language-mbt= text", "```mbt\nlet x = 1\n```",
    ),
    page(
      "a block quote", "<blockquote><p>quoted</p></blockquote>", "blockquote\n  p quoted",
      "> quoted",
    ),
    page(
      "a block quote of two paragraphs", "<blockquote><p>one</p><p>two</p></blockquote>",
      "blockquote\n  p one\n  p two", "> one\n>\n> two",
    ),
    page(
      "a table", "<table><thead><tr><th>k</th><th>v</th></tr></thead><tbody><tr><td>a</td><td>1</td></tr></tbody></table>",
      "table\n  thead\n    tr\n      th k\n      th v\n  tbody\n    tr\n      td a\n      td 1",
      "| k | v |\n| --- | --- |\n| a | 1 |",
    ),
    page("a rule", "<hr/>", "hr", "---"),
    page(
      "an image", "<p><img src=\"/a.png\" alt=\"a\"/></p>", "p\n  img(src=\"/a.png\" alt=\"a\")",
      "![a](/a.png)",
    ),
    page(
      "a break in a paragraph", "<p>one<br/>two</p>", "p\n  | one\n  br\n  | two",
      "one\\\ntwo",
    ),
    page(
      "a loop over data", "<ul>{% for i in items %}<li>{{ i }}</li>{% endfor %}</ul>",
      "ul\n  each i in items\n    li= i", "{% for i in items %}\n- {{ i }}\n{% endfor %}",
    ),
    page(
      "a choice", "{% if flag %}<p>on</p>{% else %}<p>off</p>{% endif %}", "if flag\n  p on\nelse\n  p off",
      "{% if flag %}\non\n{% else %}\noff\n{% endif %}",
    ),
    page(
      "a value that could break the page", "<h1>{{ bad }}</h1>", "h1= bad", "# {{ bad }}",
    ),
    page("text with entities", "<p>{{ plain }}</p>", "p= plain", "{{ plain }}"),
    page(
      "two headings", "<h2>{{ title }}</h2><h3>{{ intro }}</h3>", "h2= title\nh3= intro",
      "## {{ title }}\n\n### {{ intro }}",
    ),
    page(
      "a list of marks", "<ul><li><em>a</em></li><li><code>b</code></li></ul>", "ul\n  li\n    em a\n  li\n    code b",
      "- *a*\n- `b`",
    ),
    page(
      "an element with a class", "<div class=\"note\"><p>body</p></div>", "div.note\n  p body",
      "{% block lang=html %}<div class=\"note\"><p>body</p></div>{% endblock %}",
    ),
    page(
      "a section of its own", "<section><h2>{{ title }}</h2><p>{{ intro }}</p></section>",
      "section\n  h2= title\n  p= intro", "{% block lang=html %}<section><h2>{{ title }}</h2><p>{{ intro }}</p></section>{% endblock %}",
    ),
    page(
      "a page out of everything",
      (
        #|<h1>{{ title }}</h1><p>{{ intro }}</p><ul>{% for i in items %}<li>{{ i }}</li>{% endfor %}</ul><p><a href="/notes">notes</a></p>
      ),
      "h1= title\np= intro\nul\n  each i in items\n    li= i\np: a(href=\"/notes\") notes",
      (
        #|# {{ title }}
        #|
        #|{{ intro }}
        #|
        #|{% for i in items %}
        #|- {{ i }}
        #|{% endfor %}
        #|
        #|[notes](/notes)
      ),
    ),
  ]
}

///|
/// Render one page in one language, or the refusal that stopped it.
fn draw(source : String, format : @moonpug.Format) -> String {
  @moonpug.render(source, data(), format~) catch {
    e => "refused: \{e}"
  }
}

///|
/// The three renderings of every page, as one JSON document.
fn renderings() -> Json {
  let out : Array[Json] = []
  for page in pages() {
    out.push(
      Json::object(
        Map([
          ("name", Json::string(page.name)),
          ("html", Json::string(draw(page.html, @moonpug.html))),
          ("pug", Json::string(draw(page.pug, @moonpug.pug))),
          ("md", Json::string(draw(page.md, @moonpug.markdown))),
        ]),
      ),
    )
  }
  Json::array(out)
}

///|
/// Print the pages side by side: the HTML and the indentation syntax have to
/// agree byte for byte, and Markdown, once a browser has read it, says the
/// same thing — `scripts/check_same_page.mjs` holds the last of that, since
/// two documents can differ as text and be the same page.
fn main {
  let args = @env.args()
  if args.contains("--json") {
    println(@jsontext.dumps(renderings()))
    return
  }
  let mut agreed = 0
  for page in pages() {
    let html = draw(page.html, @moonpug.html)
    let pug = draw(page.pug, @moonpug.pug)
    let md = draw(page.md, @moonpug.markdown)
    let same = html == pug
    if same {
      agreed += 1
    }
    println("--- \{page.name}")
    println("html  \{one_line(html)}")
    println("pug   \{one_line(pug)}")
    println("md    \{one_line(md)}")
    if !same {
      println("html and pug differ")
    }
  }
  println("")
  println(
    "html and pug agree byte for byte on \{agreed} of \{pages().length()} pages",
  )
  println(
    "the Markdown of each is checked against the other two with a browser's parser:",
  )
  println(
    "  moon run src/examples/09-same-page -- --json | node scripts/check_same_page.mjs",
  )
}

///|
/// One line, so a page of three lines does not push the next out of view.
fn one_line(text : String) -> String {
  text.replace_all(old="\n", new="\\n")
}
