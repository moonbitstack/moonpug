"""Jinja's i18n extension with new-style gettext over a small catalog; the
same catalog backs the translation seam in the MoonBit helper.
Usage: jinja_i18n.py <out>."""
import json, sys
from jinja2 import Environment, StrictUndefined

CAT = {"Hello": "Hallo", "Hello %(user)s!": "Hallo %(user)s!", "Bye": "Tschüss <b>"}
CTX = {("menu", "Open"): "Öffnen"}
PL = {"%(num)d apple": ("%(num)d Apfel", "%(num)d Äpfel"), "%(count)s item": ("%(count)s Ding", "%(count)s Dinge")}
CTX_PL = {("shop", "%(num)d box"): ("%(num)d Kiste", "%(num)d Kisten")}


def gettext(s):
    return CAT.get(s, s)


def ngettext(s, p, n):
    if s in PL:
        return PL[s][0 if n == 1 else 1]
    return s if n == 1 else p


def pgettext(c, s):
    return CTX.get((c, s), s)


def npgettext(c, s, p, n):
    if (c, s) in CTX_PL:
        return CTX_PL[(c, s)][0 if n == 1 else 1]
    return s if n == 1 else p


def make(autoescape):
    env = Environment(autoescape=autoescape, undefined=StrictUndefined, extensions=["jinja2.ext.i18n"])
    env.install_gettext_callables(gettext, ngettext, newstyle=True, pgettext=pgettext, npgettext=npgettext)
    return env


T = [
    "{% trans %}Hello{% endtrans %}", "{% trans %}Unknown{% endtrans %}", "{% trans user=name %}Hello {{ user }}!{% endtrans %}",
    "{% trans %}Hello {{ name }}!{% endtrans %}", "{% trans count=n %}{{ count }} item{% pluralize %}{{ count }} items{% endtrans %}",
    "{% trans num=n %}{{ num }} apple{% pluralize %}{{ num }} apples{% endtrans %}",
    "{% trans num=n %}{{ num }} apple{% pluralize num %}{{ num }} apples{% endtrans %}",
    "{% trans num=one %}{{ num }} apple{% pluralize %}{{ num }} apples{% endtrans %}",
    "{% trans %}Bye{% endtrans %}", "{% trans %}{{ html }} and more{% endtrans %}", "{% trans x=html %}{{ x }}!{% endtrans %}",
    "{% trans \"menu\" %}Open{% endtrans %}", "{% trans \"shop\" num=n %}{{ num }} box{% pluralize %}{{ num }} boxes{% endtrans %}",
    "{% trans trimmed %}\n  Hello\n    {{ name }}!\n{% endtrans %}", "{% trans notrimmed %}\n  spaced  {% endtrans %}",
    "{% trans %}100%% sure{% endtrans %}", "{% trans a=1, b=2 %}{{ a }} and {{ b }}{% endtrans %}",
    "{{ _('Hello') }}", "{{ gettext('Hello %(user)s!', user=name) }}", "{{ gettext('Hello %(user)s!', user=html) }}",
    "{{ ngettext('%(num)d apple', '%(num)d apples', n) }}", "{{ ngettext('%(num)d apple', '%(num)d apples', one) }}",
    "{{ ngettext('x', 'xs', 2) }}", "{{ pgettext('menu', 'Open') }}", "{{ pgettext('menu', 'Close') }}",
    "{{ npgettext('shop', '%(num)d box', '%(num)d boxes', n) }}", "{{ gettext('Bye') }}", "{{ _('50%% off') }}",
    "{% trans %}a{% pluralize %}b{% endtrans %}", "{% trans count=n %}{% endtrans %}", "{% trans %}{% trans %}{% endtrans %}",
    "{% trans %}{{ name|upper }}{% endtrans %}", "{% trans user=name|upper %}Hello {{ user }}!{% endtrans %}",
]
ctx = {"name": "Ann", "n": 3, "one": 1, "html": "<i>x</i>"}
lines = []
for i, src in enumerate(T):
    for auto in (True, False):
        try:
            out = make(auto).from_string(src).render(**ctx)
            result = "output=" + json.dumps(out, ensure_ascii=False)
        except Exception as e:
            result = "error=" + json.dumps(type(e).__name__ + ": " + str(e), ensure_ascii=False)
        body = [json.dumps(src, ensure_ascii=False), json.dumps(json.dumps(ctx), ensure_ascii=False), result]
        if auto:
            body.append("autoescape=true")
        lines.append("///|\ntest %s {\n  i18n(\n    %s,\n  )\n}\n" % (json.dumps("i18n #%d%s" % (i, " escaped" if auto else "")), ",\n    ".join(body)))
open(sys.argv[1], "w", encoding="utf-8", newline="\n").write("\n".join(lines))
print(len(lines))
