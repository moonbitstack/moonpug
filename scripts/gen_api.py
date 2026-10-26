"""Write docs/api.html from each package's interface file and the `///`
comments in its sources, so the reference follows the code. Usage:
python scripts/gen_api.py, from the repository root."""
import html, pathlib, re

ROOT = pathlib.Path(__file__).resolve().parent.parent
PACKAGES = [
    ("moonbitstack/moonpug", "src", "The engine: environments, templates, settings, and one-call rendering."),
    ("moonbitstack/moonpug/spec", "src/spec", "Values and the contract extensions build on: objects, filters, tests, refusals. The engine re-exports what a caller needs."),
    ("moonbitstack/moonpug/syntax", "src/syntax", "The tree and the readers, for a language of your own."),
]
DECL = re.compile(r"^pub(?:\((?:all|open)\))?\s+(fn(?:\[[^\]]*\])?|let|struct|enum|suberror|trait|type)\s+([A-Za-z_][\w]*(?:::[A-Za-z_][\w]*)?)")


def docs_of(folder):
    """Doc comments by declared name, and by `Type.field` for fields and variants."""
    out = {}
    for path in sorted((ROOT / folder).glob("*.mbt")):
        if path.name.endswith("_test.mbt"):
            continue
        lines = path.read_text(encoding="utf-8").splitlines()
        pending, owner = [], None
        for line in lines:
            stripped = line.strip()
            if stripped == "///|":
                pending = []
                continue
            if stripped.startswith("///"):
                pending.append(stripped[3:].strip())
                continue
            m = DECL.match(line)
            if m:
                name = m.group(2)
                if pending:
                    out[name] = " ".join(pending)
                owner = name if m.group(1) in ("struct", "enum", "suberror", "trait") and line.rstrip().endswith("{") else None
                pending = []
                continue
            if owner and line.startswith("}"):
                owner = None
            elif owner and pending:
                field = re.match(r"\s+(?:fn\s+)?(?:mut\s+)?([A-Za-z_]\w*)", line)
                if field:
                    out[owner + "." + field.group(1)] = " ".join(pending)
            pending = []
    return out


def items_of(folder):
    """Declarations from the interface file: (kind, name, text, owner)."""
    text = (ROOT / folder / "pkg.generated.mbti").read_text(encoding="utf-8").splitlines()
    items, block = [], None
    for line in text:
        if block is not None:
            block[2].append(line)
            if line.startswith("}"):
                items.append((block[0], block[1], "\n".join(block[2]), None))
                block = None
            continue
        if not line.startswith("pub"):
            continue
        m = re.match(r"pub(?:\((?:all|open)\))?\s+(struct|enum|suberror|trait)\s+(\w+)", line)
        if m and line.rstrip().endswith("{"):
            block = [m.group(1), m.group(2), [line]]
            continue
        if m:
            items.append((m.group(1), m.group(2), line, None))
            continue
        m = re.match(r"pub fn(?:\[[^\]]*\])?\s+(\w+)::(\w+)", line)
        if m:
            items.append(("method", m.group(1) + "::" + m.group(2), line, m.group(1)))
            continue
        m = re.match(r"pub fn(?:\[[^\]]*\])?\s+(\w+)", line)
        if m:
            items.append(("fn", m.group(1), line, None))
            continue
        m = re.match(r"pub let (\w+)", line)
        if m:
            items.append(("let", m.group(1), line, None))
            continue
        m = re.match(r"pub type (\w+)", line)
        if m:
            items.append(("type", m.group(1), line, None))
            continue
        m = re.match(r"pub using @(\w+) \{(.*)\}", line)
        if m:
            items.append(("using", m.group(1), line, None))
    return items


def code(text):
    return "<pre class=\"sig\"><code>%s</code></pre>" % html.escape(text.strip())


def prose(text):
    if not text:
        return ""
    escaped = html.escape(text)
    escaped = re.sub(r"`([^`]+)`", r"<code>\1</code>", escaped)
    return "<p>%s</p>" % escaped


def anchor(pkg, name):
    return (pkg.split("/")[-1] + "-" + name).replace("::", "-").lower()


def render():
    nav, body = [], []
    for pkg, folder, intro in PACKAGES:
        docs = docs_of(folder)
        items = items_of(folder)
        short = pkg.split("/", 1)[1]
        nav.append("<div class=\"group\"><b>%s</b>" % html.escape(short))
        body.append("<section id=\"%s\"><h2>%s</h2>%s" % (anchor(pkg, "top"), html.escape(short), prose(intro)))
        types = [i for i in items if i[0] in ("struct", "enum", "suberror", "trait", "type")]
        methods = {}
        for kind, name, text, owner in items:
            if kind == "method":
                methods.setdefault(owner, []).append((name, text))
        values = [i for i in items if i[0] == "let"]
        fns = [i for i in items if i[0] == "fn"]
        usings = [i for i in items if i[0] == "using"]
        if usings:
            body.append("<h3>Re-exported</h3>")
            body.append(prose("Reachable from this package as well; each is documented in the package it comes from."))
            body.append(code("\n".join(text for _, _, text, _ in usings)))
        for kind, name, text, _ in types:
            nav.append("<a href=\"#%s\">%s</a>" % (anchor(pkg, name), html.escape(name)))
            body.append("<article id=\"%s\"><h3><span class=\"kind\">%s</span> %s</h3>" % (anchor(pkg, name), kind, html.escape(name)))
            body.append(prose(docs.get(name, "")))
            body.append(code(text))
            fields = [(k.split(".", 1)[1], v) for k, v in docs.items() if k.startswith(name + ".")]
            if fields:
                body.append("<dl class=\"fields\">%s</dl>" % "".join(
                    "<dt><code>%s</code></dt><dd>%s</dd>" % (html.escape(f), prose(d)) for f, d in fields))
            for mname, mtext in methods.get(name, []):
                if re.search(r"::(equal|not_equal|output|to_string|to_repr|hash|hash_combine|compare|op_\w+)\(", mtext):
                    continue
                body.append("<div class=\"member\" id=\"%s\">%s%s</div>" % (anchor(pkg, mname), code(mtext), prose(docs.get(mname, ""))))
            body.append("</article>")
        if fns:
            nav.append("<a href=\"#%s\">Functions</a>" % anchor(pkg, "functions"))
            body.append("<h3 id=\"%s\">Functions</h3>" % anchor(pkg, "functions"))
            for _, name, text, _ in fns:
                body.append("<div class=\"member\" id=\"%s\">%s%s</div>" % (anchor(pkg, name), code(text), prose(docs.get(name, ""))))
        if values:
            nav.append("<a href=\"#%s\">Values</a>" % anchor(pkg, "values"))
            body.append("<h3 id=\"%s\">Values</h3>" % anchor(pkg, "values"))
            for _, name, text, _ in values:
                body.append("<div class=\"member\" id=\"%s\">%s%s</div>" % (anchor(pkg, name), code(text), prose(docs.get(name, ""))))
        nav.append("</div>")
        body.append("</section>")
    page = (ROOT / "docs" / "api.template.html").read_text(encoding="utf-8")
    page = page.replace("<!-- nav -->", "\n".join(nav)).replace("<!-- body -->", "\n".join(body))
    (ROOT / "docs" / "api.html").write_text(page, encoding="utf-8", newline="\n")


render()
