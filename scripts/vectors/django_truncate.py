"""Django 6.1 truncates and slugs a set of values; the results become
src/django_truncate_test.mbt. Usage: django_truncate.py <out>.

The filter functions are Django's own, so what a case expects is what
Django wrote, not what this library would like it to write.
"""
import json
import sys

from django.utils.text import Truncator, slugify

SLUGIFY = "slugify"
CHARS = "truncatechars"
CHARS_HTML = "truncatechars_html"
WORDS_HTML = "truncatewords_html"

HTML = '<p>one <a href="#">two - three <br>four</a> five</p>'
ENTITY = "<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>"

cases = []


def case(name, value, arg):
    cases.append((name, value, arg))


for text in [
    " Jack & Jill like numbers 1,2,3 and 4 and silly characters ?%.$!/",
    "Un \xe9l\xe9phant \xe0 l'or\xe9e du bois",
    "Hello  World---Again",
    "a_b-c d",
    "\xc0\xc9\xce\xd5\xdc \xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e",
    "foo/bar?baz=1&x=2",
    "  spaced  ",
    "cafe\u0301 cole",
    "",
    "___",
    "already-a-slug",
    123,
]:
    case(SLUGIFY, text, None)

for text in [
    "Testing, testing",
    "Testing",
    "abc",
    "",
    "one two three four",
    "\xc5ngstr\xf6m was here",
    "cafe\u0301xyz",
    "\U0001f600\U0001f600\U0001f600",
    "a & b",
]:
    for n in [0, 1, 2, 3, 4, 5, 7, 100]:
        case(CHARS, text, n)

for html in [
    HTML,
    "<b>\xc5ngstr\xf6m</b> was here",
    "a<b>b</b>c",
    "<div><p>text</p></div>",
    "a & b <b>c</b>",
    "x<!-- gone -->y",
    ENTITY,
    "<ul><li>one<li>two</ul>",
    "<p>a<br/>b</p>",
]:
    for n in [0, 1, 2, 3, 4, 5, 6, 9, 10, 12, 20, 100]:
        case(CHARS_HTML, html, n)

for html in [HTML, "<b>\xc5ngstr\xf6m</b> was here", ENTITY, "<p>string</p>"]:
    for n in [0, 1, 2, 3, 4, 5, 6, 100]:
        case(WORDS_HTML, html, n)


def write(name, value, arg):
    if name == SLUGIFY:
        out = slugify(value)
    elif name == CHARS:
        out = Truncator(value).chars(arg)
    elif name == CHARS_HTML:
        out = Truncator(value).chars(arg, html=True)
    else:
        out = Truncator(value).words(arg, html=True, truncate=" \u2026")
    # What this library writes for an escaped quote, so the case shows the
    # truncation and not the escaping.
    return out.replace("&quot;", "&#34;").replace("&#x27;", "&#39;")


lines = []
for i, (name, value, arg) in enumerate(cases):
    source = "{{ v|%s%s }}" % (name, "" if arg is None else "(%d)" % arg)
    body = [
        "source=" + json.dumps(source, ensure_ascii=False),
        json.dumps(json.dumps({"v": value}, ensure_ascii=False), ensure_ascii=False),
        "output=" + json.dumps(write(name, value, arg), ensure_ascii=False),
        "autoescape=false",
    ]
    lines.append(
        '///|\ntest %s {\n  jinja(\n    %s,\n  )\n}\n'
        % (json.dumps("django %s #%d" % (name, i), ensure_ascii=False),
           ",\n    ".join(body))
    )
open(sys.argv[1], "w", encoding="utf-8", newline="\n").write("\n".join(lines))
print(len(lines))
