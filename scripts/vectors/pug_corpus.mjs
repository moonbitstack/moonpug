// Pug templates whose expressions read the same in JavaScript and in Jinja,
// rendered by Pug 3.0.4 and written as MoonBit test vectors.
// Usage: node pug_corpus.mjs <out>.
import fs from "node:fs";
import { createRequire } from "node:module";

const require = createRequire(import.meta.url);
const pug = require("pug");
const out = process.argv[2];

const ctx = {
  name: "World", n: 21, items: ["a", "b", "c"], obj: { x: 1, y: 2 }, url: "/home", html: "<b>bold</b>",
  attrs: { "data-a": "1", class: "z" }, flag: true, off: false, empty: [], kind: "b", title: "T <&>", id: "main",
};

const T = [
  "p Hello", "p Hello #{name}!", "p #{n * 2} and #{n + 1}", "p !{html}", "p #{html}", "p \\#{name}", "p Esc \\!{html}",
  "p text #[em inline] more", "p #[a(href=url) link] after", "p\n  | piped\n  | lines", "p.\n  dot block\n  #{name}",
  "div\n  span one\n  span two", "ul\n  li a\n  li b\n  li: a(href='/') c", "a: img(src='x.png')", "img(src='a.png' alt='x')",
  "br", "hr/", "foo/", "input(type='checkbox' checked)", "input(checked=false)", "input(checked=off)", "input(value=n)",
  "a(href=url) go", "a(href='/u/' + name) u", "div(class=['a', 'b'])", "div.x.y(class='z')", "div#app.main", "#only", ".only",
  "div(data-n=n data-s='s' data-t=true)", "div(title=title)", "div(title!=title)", "p&attributes(attrs) x",
  "p.c&attributes(attrs)(class='d') x", "div(class=kind)", "div(class=empty)", "a(href='x', target='_blank') t",
  "a(\n  href='/multi'\n  title='line'\n) m", "div(style='color: red')", "div(a='1' b=\"2\" c=3)",
  "// comment\np x", "//- hidden\np x", "//\n  block comment\n  more\np y", "<div>raw html</div>", "div\n  <span>mixed</span>\n  em pug",
  "doctype html\nhtml\n  body\n    input(checked)\n    br", "doctype xml\nroot\n  leaf/", "doctype transitional\nhtml", "doctype strict\nhtml",
  "doctype frameset\nhtml", "doctype 1.1\nhtml", "doctype basic\nhtml", "doctype mobile\nhtml", "doctype plist\nplist", "doctype custom thing\nhtml",
  "if flag\n  p yes\nelse\n  p no", "if off\n  p yes\nelse if n > 20\n  p big\nelse\n  p small", "unless off\n  p shown",
  "unless flag\n  p hidden", "if n == 21\n  p eq", "if kind == 'b'\n  p b", "each item in items\n  li= item",
  "each item, i in items\n  li #{i}:#{item}", "each v, k in obj\n  li #{k}=#{v}", "each item in empty\n  li= item\nelse\n  li none",
  "for item in items\n  li= item", "ul\n  each item in items\n    li\n      span= item",
  "case kind\n  when 'a'\n    p A\n  when 'b'\n    p B\n  default\n    p other",
  "case n\n  when 1\n    p one\n  when 21\n    p twenty-one\n  default\n    p many", "case kind\n  when 'a': p A\n  when 'b': p B",
  "case kind\n  when 'x'\n  when 'b'\n    p fall\n  default\n    p d",
  "mixin item(label)\n  li= label\nul\n  +item('one')\n  +item('two')", "mixin box\n  div.box\n    block\n+box\n  p inside",
  "mixin box\n  div.box\n    if block\n      block\n    else\n      p empty\n+box\n+box\n  p full",
  "mixin link(href, text)\n  a(href=href)&attributes(attributes)= text\n+link('/a', 'A')(class='btn')",
  "mixin tag\n  span(class=attributes.class) t\n+tag.big", "mixin pair(a, b)\n  p #{a}-#{b}\n+pair(1, 2)\n+pair('x')",
  "p= name", "p!= html", "p= n * 2", "p= 'lit'", "p #{'quoted'}", "p= items[0]", "p= obj.x", "p= obj['y']",
  "p\n  = name", "div\n  | text\n  strong bold\n  | tail", "pre.\n  keep   spaces\n    indented",
  "script.\n  var x = 1 < 2;", "style.\n  a { color: red; }", "p: span: em deep", "div(class=['a'])&attributes({'class': 'b'})",
  "a(class='x' class='y')", "p(class='') x", "p(style='') y", "p(id=id) z", "textarea\n  | content", "p\n  | before #[b bold] after",
  "- x", "p Tab\tseparated", "p trailing  ", "div\n\n  p after blank", "div\n  // inner comment\n  p x",
  "block content\n  p default", "p a\np b\np c",
];

const lit = (s) => JSON.stringify(s);
const tests = [];
let kept = 0;
for (const [i, src] of T.entries()) {
  // `-` and `=` lines are JavaScript in Pug and refused here.
  if (/^\s*[-=]/m.test(src)) continue;
  let output;
  try {
    output = pug.render(src, { ...ctx, pretty: false });
  } catch (e) {
    continue;
  }
  kept++;
  tests.push(`///|\ntest ${lit("pug extra #" + i)} {\n  pug_source(${lit(src)}, ${lit(JSON.stringify(ctx))}, ${lit(output)})\n}\n`);
}
fs.writeFileSync(out, tests.join("\n"));
console.log(kept, "of", T.length);
