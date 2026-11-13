// Render the differential cases with moonpug compiled to JavaScript, and
// write what it wrote as JSON. The checks beside this file render the same
// cases with the reference implementation and compare the two.
//
//   node scripts/differential/render_cases.mjs <engine.js> <out.json>
//
// The engine is the playground build: `render_page(source, context, lang,
// force)` takes the data as JSON text, which is what the cases hold.
import fs from "node:fs";
import path from "node:path";
import { pathToFileURL } from "node:url";

const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1"));
const [enginePath, outPath] = process.argv.slice(2);
if (!enginePath || !outPath) {
  console.error("usage: render_cases.mjs <engine.js> <out.json>");
  process.exit(2);
}

const engine = await import(pathToFileURL(path.resolve(enginePath)).href);
const cases = JSON.parse(fs.readFileSync(path.join(here, "cases.json"), "utf8"));

const rendered = { jinja: {}, pug: {} };
for (const language of ["jinja", "pug"]) {
  for (const one of cases[language]) {
    const lang = language === "jinja" ? "html" : "pug";
    rendered[language][one.name] = engine.render_page(
      one.source,
      JSON.stringify(one.data),
      lang,
      false,
    );
  }
}

fs.writeFileSync(outPath, JSON.stringify(rendered), "utf8");
console.log(`rendered ${cases.jinja.length} jinja and ${cases.pug.length} pug cases with moonpug`);
