const samples = {
  html: {
    source: `<h2>{{ shelf }}</h2>
<ul>
{%- for b in books|sort(attribute='year') %}
  <li>{{ b.title }} <em>{{ b.year }}</em>
    {%- if b.tags %} · {{ b.tags|join(', ') }}{% endif %}</li>
{%- endfor %}
</ul>
<p>{{ books|length }} {{ 'book' if books|length == 1 else 'books' }}, newest from {{ (books|map(attribute='year')|max) }}.</p>`,
  },
  pug: {
    source: `h2= shelf
ul
  each b in books
    li
      | #{b.title}
      em  #{b.year}
p Written in #[strong pug], read by the same engine.`,
  },
  md: {
    source: `## {{ shelf }}
{% for b in books %}
- **{{ b.title }}**, {{ b.year }}
{% endfor %}

{% block lang=pug %}
p A pug block inside Markdown.
{% endblock %}`,
  },
};

const data = `{
  "shelf": "Reading <list>",
  "books": [
    {"title": "Dune", "year": 1965, "tags": ["classic"]},
    {"title": "The Hobbit", "year": 1937, "tags": []}
  ]
}`;

const $ = (s) => document.querySelector(s);
let engine = null;
let lang = "html";

function render() {
  const out = $("#out");
  const view = $("#view");
  if (!engine) {
    out.textContent = "The engine loads from engine/moonpug.js.";
    return;
  }
  const text = engine.render_page($("#source").value, $("#data").value, lang, $("#force").checked);
  const refused = text.startsWith("refused: ");
  out.textContent = text;
  out.classList.toggle("refused", refused);
  if (refused) {
    view.textContent = "";
  } else {
    view.innerHTML = text;
  }
}

function choose(name) {
  lang = name;
  for (const b of document.querySelectorAll(".tabs button")) {
    b.setAttribute("aria-pressed", String(b.dataset.lang === name));
  }
  $("#source").value = samples[name].source;
  render();
}

// The three spellings of one page: the engine writes the source and what it
// renders to, so the panes and the bench below show the same shelf.
function trio() {
  const box = document.getElementById("trio");
  const verdict = document.getElementById("trio-verdict");
  if (!box || !engine) return;
  const rows = JSON.parse(engine.three_ways($("#data").value));
  const panes = box.querySelectorAll("article");
  for (const [i, pane] of [...panes].entries()) {
    const row = rows[i];
    pane.querySelector("pre.src").textContent = row.source;
    pane.querySelector("pre.out").textContent = row.out;
  }
  const same = rows.every((row) => doc(row.out) === doc(rows[0].out));
  verdict.replaceChildren(
    document.createTextNode(same
      ? "The three outputs are one document. Read with the browser's parser, they differ only in where the newlines fall: "
      : "The three outputs differ: "),
    Object.assign(document.createElement("b"), {
      textContent: same ? "same tree, same text" : "not the same",
    }),
  );
}

// A document as a tree of tags, attributes and words: whitespace between
// blocks is not part of what a reader sees, so it is folded away here too.
function doc(html) {
  const walk = (node) => {
    if (node.nodeType === Node.TEXT_NODE) {
      const text = node.parentElement?.closest("pre, code")
        ? node.textContent
        : node.textContent.replace(/\s+/g, " ").trim();
      return text === "" ? "" : JSON.stringify(text);
    }
    if (node.nodeType !== Node.ELEMENT_NODE) return "";
    const attrs = [...node.attributes].map((a) => `${a.name}=${a.value}`).sort().join(" ");
    return `<${node.tagName} ${attrs}>${[...node.childNodes].map(walk).join("")}</>`;
  };
  const body = new DOMParser().parseFromString(html, "text/html").body;
  return [...body.childNodes].map(walk).join("");
}

const anchor = { filters: "filter", tests: "test", globals: "global" };

function reference() {
  if (!engine) return;
  const names = JSON.parse(engine.names());
  for (const [key, list] of Object.entries(names)) {
    const box = document.querySelector(`[data-names="${key}"]`);
    if (!box) continue;
    box.replaceChildren(...list.map((n) => {
      const a = document.createElement("a");
      a.href = `builtins.html#${anchor[key]}-${encodeURIComponent(n)}`;
      const c = document.createElement("code");
      c.textContent = n;
      a.append(c);
      return a;
    }));
    const count = document.querySelector(`[data-count="${key}"]`);
    if (count) count.textContent = String(list.length);
  }
}

function theme() {
  const root = document.documentElement;
  const button = $("#theme");
  let saved = null;
  try { saved = localStorage.getItem("moonpug-theme"); } catch {}
  if (saved) root.dataset.theme = saved;
  button.addEventListener("click", () => {
    const dark = root.dataset.theme
      ? root.dataset.theme === "dark"
      : matchMedia("(prefers-color-scheme: dark)").matches;
    root.dataset.theme = dark ? "light" : "dark";
    try { localStorage.setItem("moonpug-theme", root.dataset.theme); } catch {}
  });
}

theme();
$("#data").value = data;
for (const b of document.querySelectorAll(".tabs button")) b.addEventListener("click", () => choose(b.dataset.lang));
for (const el of ["#source", "#data", "#force"]) $(el).addEventListener("input", render);
choose("html");
import("../engine/moonpug.js")
  .then((m) => { engine = m; render(); reference(); trio(); })
  .catch(() => render());
