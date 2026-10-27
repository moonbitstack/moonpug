// Re-renders every live example on the Built-ins page through the engine the
// site ships, so the output shown is the one the engine produces now.
const root = document.documentElement;
try {
  const saved = localStorage.getItem("moonpug-theme");
  if (saved) root.dataset.theme = saved;
} catch {}

let engine = null;

function renderDemos() {
  if (!engine) return;
  for (const demo of document.querySelectorAll('.demo[data-live="1"]')) {
    const src = demo.querySelector(".demo-src").textContent;
    const dataEl = demo.querySelector(".demo-data");
    const data = dataEl ? dataEl.textContent.trim() : "{}";
    const lang = demo.getAttribute("data-lang") || "html";
    const out = demo.querySelector(".demo-out");
    const text = engine.render_page(src, data, lang, false);
    out.textContent = text;
    out.classList.toggle("refused", text.startsWith("refused: "));
  }
}

import("../engine/moonpug.js")
  .then((m) => {
    engine = m;
    renderDemos();
  })
  .catch(() => renderDemos());
