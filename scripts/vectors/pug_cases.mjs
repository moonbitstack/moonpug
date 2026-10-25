// Pug 3.0.4 renders its own test cases; the ones without JavaScript code
// become src/pug_test.mbt. Usage: node pug_cases.mjs <cases dir> <out>.
import fs from "node:fs";
import path from "node:path";
import { createRequire } from "node:module";

const require = createRequire(import.meta.url);
const pug = require("pug");
const [casesDir, out] = process.argv.slice(2);

const lit = (s) =>
  '"' +
  [...s]
    .map((ch) => {
      const o = ch.codePointAt(0);
      if (ch === "\\") return "\\\\";
      if (ch === '"') return '\\"';
      if (ch === "\n") return "\\n";
      if (ch === "\t") return "\\t";
      if (ch === "\r") return "\\r";
      if (o < 0x20 || o === 0x7f) return "\\u{" + o.toString(16) + "}";
      return ch;
    })
    .join("") +
  '"';

const files = {};
const walk = (dir, prefix) => {
  for (const name of fs.readdirSync(dir)) {
    const full = path.join(dir, name);
    if (fs.statSync(full).isDirectory()) walk(full, prefix + name + "/");
    else if (/\.(pug|html|md|txt)$/.test(name)) files[prefix + name] = fs.readFileSync(full, "utf8");
  }
};
walk(casesDir, "");

const javascript = /^\s*-|\bvar\b|function|=>|require\(|\.map\(|\.forEach\(|\bnew\b|\$\{/m;
// Expressions here are Jinja's, not JavaScript's; `{{ }}` in text is
// output; a path may not climb above the loader's root.
const differs = new Set([
  "classes", "code", "mixin.merge",
  "include.script", "template",
  "include-extends-relative", "layout.append", "layout.append.without-block",
  "layout.multi.append.prepend.block", "layout.prepend", "layout.prepend.without-block",
  "mixin-via-include",
]);
const tests = [];
let skipped = 0;
for (const name of fs.readdirSync(casesDir).filter((n) => n.endsWith(".pug")).sort()) {
  const source = files[name];
  if (javascript.test(source) || differs.has(name.replace(/\.pug$/, ""))) {
    skipped++;
    continue;
  }
  let output;
  try {
    output = pug.renderFile(path.join(casesDir, name), { pretty: false, basedir: casesDir });
  } catch (e) {
    skipped++;
    continue;
  }
  tests.push(`///|\ntest ${lit("pug " + name.replace(/\.pug$/, ""))} {\n  pug(${lit(name)}, ${lit(output)})\n}\n`);
}
const table = Object.entries(files)
  .filter(([n]) => n.endsWith(".pug") || n.endsWith(".md") || n.endsWith(".txt"))
  .map(([n, s]) => `    (${lit(n)}, ${lit(s)}),`)
  .join("\n");
fs.writeFileSync(
  out,
  `///|\nlet pug_cases : Map[String, String] = Map([\n${table}\n  ])\n\n` + tests.join("\n"),
);
console.log(tests.length, "kept", skipped, "skipped");
