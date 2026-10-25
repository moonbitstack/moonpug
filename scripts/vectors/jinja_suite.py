"""Turn records.json, written by running Jinja 3.1.6's own test suite with
jinja_record.py as a pytest plugin, into src/jinja_test.mbt. Usage:
jinja_suite.py <out>."""
import json, sys, collections, math

OUT = sys.argv[1]
records = json.load(open("records.json", encoding="utf-8"))

UNDEF = {"Undefined": "Lenient", "LoggingUndefined": "Lenient", "ChainableUndefined": "Chainable", "StrictUndefined": "Strict"}


# Random output; integers wider than 64 bits; non-text mapping keys.
SKIP = {
    "jinja_tests/test_filters.py::TestFilter::test_random",
    "jinja_tests/test_filters.py::TestFilter::test_int[12345678901234567890-12345678901234567890]",
    "jinja_tests/test_lexnparse.py::TestSyntax::test_trailing_comma",
}
# Python object internals have no counterpart here.
INTERNALS = ("__class__", "_undefined_name")


class Unsupported(Exception):
    pass


def plain(v):
    if v is None or isinstance(v, (bool, str)):
        return v
    if isinstance(v, int):
        if abs(v) >= 2**63:
            raise Unsupported
        return v
    if isinstance(v, float):
        if math.isinf(v) or math.isnan(v):
            raise Unsupported
        return v
    if type(v) is list:
        return [plain(x) for x in v]
    if type(v) is dict:
        if not all(type(k) is str for k in v):
            raise Unsupported
        return {k: plain(x) for k, x in v.items()}
    raise Unsupported


def lit(s):
    out = []
    for ch in s:
        o = ord(ch)
        if ch == "\\":
            out.append("\\\\")
        elif ch == '"':
            out.append('\\"')
        elif ch == "\n":
            out.append("\\n")
        elif ch == "\t":
            out.append("\\t")
        elif ch == "\r":
            out.append("\\r")
        elif o < 0x20 or o == 0x7F or 0xD800 <= o <= 0xDFFF:
            out.append("\\u{%x}" % o)
        else:
            out.append(ch)
    return '"' + "".join(out) + '"'


def usable(e):
    env = e["env"]
    if e["context"] == "unsupported" or env["templates"] == "unsupported":
        return None
    if e["source"] is None and not (e["name"] and isinstance(env["templates"], dict)):
        return None
    if env["extensions"] or env["custom"] or env["is_async"] or env["finalize"]:
        return None
    if env["delimiters"] != ["{%", "%}", "{{", "}}", "{#", "#}"]:
        return None
    if env["newline_sequence"] != "\n" or env["autoescape"] == "callable":
        return None
    if env["class"] != "jinja2.environment.Environment" or env["policies"] or e["template_globals"]:
        return None
    if e["test"] in SKIP or e["test"].split("[")[0] in SKIP:
        return None
    if any(word in (e["source"] or "") for word in INTERNALS):
        return None
    if env["undefined"] not in UNDEF:
        return None
    if env["globals"] == "unsupported":
        return None
    try:
        glob = plain(env["globals"])
        ctx = plain(e["context"])
        templates = plain(env["templates"]) if env["templates"] else {}
    except Unsupported:
        return None
    return ctx, templates, glob


def main():
    seen = collections.Counter()
    lines = []
    count = 0
    for e in records:
        got = usable(e)
        if got is None:
            continue
        ctx, templates, glob = got
        env = e["env"]
        test = e["test"].replace("jinja_tests/", "").replace(".py::", " ")
        seen[test] += 1
        name = test if seen[test] == 1 else f"{test} #{seen[test]}"
        args = []
        if e["source"] is not None:
            args.append("source=" + lit(e["source"]))
        else:
            args.append("name=" + lit(e["name"]))
        args.append(lit(json.dumps(ctx, ensure_ascii=False)))
        if "error" in e:
            args.append("error=" + lit(e["error"]))
        else:
            args.append("output=" + lit(e["output"]))
        u = UNDEF[env["undefined"]]
        if u != "Lenient":
            args.append(f"policy={u}")
        for key in ("autoescape", "trim_blocks", "lstrip_blocks", "keep_trailing_newline"):
            if env[key]:
                args.append(f"{key}=true")
        for key, arg in (("line_statement_prefix", "line_statement"), ("line_comment_prefix", "line_comment")):
            if env[key]:
                args.append(f"{arg}={lit(env[key])}")
        if templates:
            args.append("templates=" + lit(json.dumps(templates, ensure_ascii=False)))
        if glob:
            args.append("globals=" + lit(json.dumps(glob, ensure_ascii=False)))
        body = ",\n    ".join(args)
        lines.append(f"///|\ntest {lit('jinja ' + name)} {{\n  jinja(\n    {body},\n  )\n}}\n")
        count += 1
    with open(OUT, "w", encoding="utf-8", newline="\n") as f:
        f.write("\n".join(lines))
    print(count)


main()
