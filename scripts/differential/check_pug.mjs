// Render the Pug cases with Pug 3.0.4 itself and compare them with what
// moonpug wrote.
//
//   node scripts/differential/check_pug.mjs <rendered.json>
//
// `rendered.json` is what render_cases.mjs wrote. Anything that disagrees is
// printed with both sides and fails the run.
import fs from "node:fs";
import path from "node:path";
import { createRequire } from "node:module";

const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\/([A-Za-z]:)/, "$1"));
const require = createRequire(import.meta.url);
const pug = require("pug");

const rendered = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
const cases = JSON.parse(fs.readFileSync(path.join(here, "cases.json"), "utf8")).pug;

const differs = [];
for (const one of cases) {
  const want = pug.render(one.source, { ...one.data, pretty: false });
  const got = rendered.pug[one.name];
  if (got !== want) differs.push([one.name, want, got]);
}

for (const [name, want, got] of differs) {
  console.log(`${name}: pug wrote ${JSON.stringify(want)}, moonpug wrote ${JSON.stringify(got)}`);
}
console.log(`pug 3.0.4: ${cases.length - differs.length}/${cases.length} cases agree`);
process.exit(differs.length === 0 ? 0 : 1);
