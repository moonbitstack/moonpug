// Compare the three renderings of every page in
// `src/examples/09-same-page`: the HTML, the indentation syntax and Markdown
// have to come out as the same document.
//
//   moon run src/examples/09-same-page -- --json | node scripts/check_same_page.mjs
//
// The three are compared as documents, not as text: each is read with parse5,
// the HTML parser the specification's own test suite uses, and the trees are
// compared node by node. Text is compared with runs of whitespace folded into
// one space and trimmed, which is how a browser paints it, so a newline
// between two blocks — or inside a list item — is not a difference. Inside
// `pre` and `code` whitespace is part of the text and is compared as written.
//
// parse5 is installed by the workflow that runs this: `npm install parse5`.
// It is not a dependency of the library.

import { parse } from "parse5";
import { readFileSync } from "node:fs";

const KEEP = new Set(["pre", "code"]);

const name = (node) => node.tagName ?? node.nodeName;

// The tree with the text folded: elements by tag and attributes, text by the
// words it contributes, comments dropped.
function signature(node, verbatim = false) {
  if (node.nodeName === "#text") {
    const text = verbatim ? node.value : node.value.replace(/\s+/g, " ").trim();
    return text === "" ? null : JSON.stringify(text);
  }
  if (node.nodeName === "#comment") {
    return null;
  }
  const attrs = (node.attrs ?? [])
    .map((a) => `${a.name}=${a.value}`)
    .sort()
    .join(" ");
  const head = node.tagName ? `<${node.tagName} ${attrs}>` : "<document>";
  const keep = verbatim || KEEP.has(node.tagName);
  const inner = (node.childNodes ?? [])
    .map((child) => signature(child, keep))
    .filter((part) => part !== null)
    .join("");
  return `${head}${inner}</>`;
}

const document = (html) => signature(parse(html));

const input = process.argv[2] ? readFileSync(process.argv[2], "utf8") : readFileSync(0, "utf8");
const pages = JSON.parse(input);
if (pages.length < 20) {
  console.error(`only ${pages.length} pages: the check needs at least twenty`);
  process.exit(1);
}

let failed = 0;
for (const page of pages) {
  const want = document(page.html);
  const lines = [];
  for (const other of ["pug", "md"]) {
    const got = document(page[other]);
    if (got !== want) {
      lines.push(`${other}: ${page[other].trim()}`);
    }
  }
  const verdict = lines.length === 0 ? "same" : "DIFFERS";
  console.log(`${verdict.padEnd(8)} ${page.name}`);
  if (lines.length) {
    failed += 1;
    console.log(`  html: ${page.html.trim()}`);
    for (const line of lines) console.log(`  ${line}`);
  }
}
console.log(`\n${pages.length - failed}/${pages.length} pages are the same document in all three`);
process.exit(failed === 0 ? 0 : 1);
