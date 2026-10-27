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
  } else if (lang === "md") {
    view.textContent = "";
    const pre = document.createElement("pre");
    pre.textContent = text;
    pre.style.margin = "0";
    pre.style.whiteSpace = "pre-wrap";
    view.append(pre);
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
  .then((m) => { engine = m; render(); reference(); })
  .catch(() => render());
