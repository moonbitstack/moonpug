"""Django 6.1 renders each supplement filter over a set of values; the
results become src/django_test.mbt. Usage: django_filters.py <out>."""
import json, sys, datetime
import django
from django.conf import settings

settings.configure(
    TIME_ZONE="UTC",
    USE_TZ=True,
    TEMPLATES=[{"BACKEND": "django.template.backends.django.DjangoTemplates"}],
)
django.setup()
from django.template import Template, Context, engines

engine = engines["django"].engine


class D:
    """A datetime: ISO text for the engine under test, a datetime for Django."""

    def __init__(self, iso):
        self.iso = iso
        self.py = datetime.datetime.fromisoformat(iso) if "T" in iso or " " in iso else datetime.date.fromisoformat(iso)


def py(v):
    if isinstance(v, D):
        return v.py
    if isinstance(v, list):
        return [py(x) for x in v]
    if isinstance(v, dict):
        return {k: py(x) for k, x in v.items()}
    return v


def js(v):
    if isinstance(v, D):
        return v.iso
    if isinstance(v, list):
        return [js(x) for x in v]
    if isinstance(v, dict):
        return {k: js(x) for k, x in v.items()}
    return v


def lit(s):
    return json.dumps(s, ensure_ascii=False)


def mb(v):
    if isinstance(v, bool):
        return "true" if v else "false"
    if v is None:
        return "none"
    if isinstance(v, str):
        return "'" + v.replace("\\", "\\\\").replace("'", "\\'") + "'"
    return repr(v)


def dj(v):
    if isinstance(v, str):
        return '"' + v.replace('"', '\\"') + '"'
    if v is None:
        return "None"
    return repr(v)


t1 = D("2026-03-05T14:07:09")
t2 = D("2003-10-07T23:39:05.123456+02:00")
t3 = D("2026-01-01T00:00:00")
t4 = D("2026-12-21T12:00:30-05:30")
d1 = D("2026-02-28")
now1 = D("2026-05-17T09:30:00")
now2 = D("2028-03-10T15:00:00+02:00")
fmt = "a A b c d D e E f F g G h H i I j l L m M n N o O P r s S t T u U w W y Y z Z \\Y\\e\\s"

cases = []
for v in [t1, t2, t3, t4]:
    # A naive time's epoch depends on the machine's zone in Django; this
    # library reads a naive time as UTC.
    cases.append(("date", v, fmt if v.py.tzinfo else fmt.replace(" U ", " ")))
    cases.append(("date", v, None))
    cases.append(("time", v, "a A e f g G h H i O P s T u Z"))
    cases.append(("time", v, None))
for v in [d1]:
    cases += [("date", v, "D d M Y jS F z t L W o w N"), ("date", v, None), ("date", v, "SHORT_DATE_FORMAT")]
for name in ["DATE_FORMAT", "DATETIME_FORMAT", "TIME_FORMAT", "YEAR_MONTH_FORMAT", "MONTH_DAY_FORMAT", "SHORT_DATE_FORMAT", "SHORT_DATETIME_FORMAT"]:
    cases.append(("date", t1, name))
for day in ["2026-03-01", "2026-03-02", "2026-03-03", "2026-03-11", "2026-03-22", "2026-03-23", "2026-03-31", "2024-02-29", "2026-09-07", "2026-11-30"]:
    cases.append(("date", D(day + "T00:00:00"), "jS N b P"))
for hm in ["00:00", "12:00", "00:30", "12:05", "13:45", "23:59", "11:00"]:
    cases.append(("time", D("2026-03-05T" + hm + ":00"), "P f g A"))
cases += [("date", "", None), ("date", None, None), ("time", "", None)]
for d, n in [(t3, now1), (D("2025-05-17T09:30:00"), now1), (D("2026-05-10T09:30:00"), now1), (D("2026-05-17T09:29:00"), now1), (D("2026-05-17T08:00:00"), now1), (now1, t3), (D("2013-02-10T00:00:00"), D("2014-03-10T00:00:00")), (D("2007-08-10T00:00:00"), D("2008-09-10T00:00:00")), (D("2026-01-31T10:00:00"), D("2026-03-01T09:00:00")), (t2, now2), (D("2026-02-28"), D("2026-05-01"))]:
    cases.append(("timesince", d, n))
    cases.append(("timeuntil", n, d))
for v, a in [(2, 3), ("2", "3"), ("a", "b"), (2.7, 1), ("2.5", 1), ("x", 1), (True, 1)]:
    cases.append(("add", v, a))
cases += [("addslashes", "I'm \"here\" \\ ok", None), ("capfirst", "hello world", None), ("capfirst", "ßtraße", None), ("capfirst", "", None)]
cases += [("cut", "a b c", " "), ("cut", "a;b", ";")]
cases += [("default_if_none", None, "x"), ("default_if_none", "", "x"), ("default_if_none", 0, "x")]
cases += [("escapejs", "a'b\"c<d>&=-;`  \x01\x7f\x9f\\é", None)]
cases += [("get_digit", 12345, 2), ("get_digit", 12345, 1), ("get_digit", 12345, 9), ("get_digit", 12345, 0), ("get_digit", "x", 1), ("get_digit", 123, "a")]
cases += [("iriencode", "/a b&c?d=é#f%20", None)]
cases += [("json_script", {"a": 1, "b": "<x>&", "c": [1, 2.5, None, True]}, "d"), ("json_script", {"z": 1, "a": 2}, None), ("json_script", [1, "x"], "data")]
cases += [("linebreaks", "a\n\nb\nc\r\n\r\n\r\nd<e>", None), ("linebreaksbr", "a\nb<c>\r\nd", None), ("linenumbers", "\n".join("line<%d>" % i for i in range(12)), None)]
cases += [("ljust", "ab", 5), ("rjust", "ab", 5), ("ljust", "abcdef", 3)]
cases += [("phone2numeric", "1-800-COLLECT", None)]
for v in [0, 1, 2, 1.0, 1.5, "1", "2", "x", [1], [1, 2], []]:
    cases.append(("pluralize", v, None))
for v, a in [(1, "es"), (2, "es"), (1, "y,ies"), (2, "y,ies"), (2, "a,b,c")]:
    cases.append(("pluralize", v, a))
cases += [("truncatewords", "one two three four", 2), ("truncatewords", "one  two\nthree", 5), ("truncatewords", "one two", 0), ("truncatewords", "one two", "x")]
cases += [("unordered_list", ["a", ["b", "c", ["d"]], "e<f>"], None), ("unordered_list", ["x"], None)]
for v in [True, False, None, 0, "x"]:
    cases.append(("yesno", v, None))
cases += [("yesno", False, "yep,nope,shrug"), ("yesno", None, "yep,nope"), ("yesno", True, "only")]
for v in [34.23234, 34.00000, 34.26000, 0.5, -0.4, 1234567.891, "34.5", "x", 66666.6666, 1e100, 12345678901234567890.0]:
    for a in [None, 3, "3", 0, "0", -3, "-3", "2g", "-2g", "2u", "2gu"]:
        cases.append(("floatformat", v, a))

lines = []
for i, (name, value, arg) in enumerate(cases):
    src_ours = "{{ v|%s%s }}" % (name, "" if arg is None else "(%s)" % ("w" if isinstance(arg, D) else mb(arg)))
    src_dj = "{{ v|%s%s }}" % (name, "" if arg is None else ":%s" % ("w" if isinstance(arg, D) else dj(arg)))
    ctx_py = {"v": py(value)}
    ctx_js = {"v": js(value)}
    if isinstance(arg, D):
        ctx_py["w"] = arg.py
        ctx_js["w"] = arg.iso
    try:
        out = engine.from_string(src_dj).render(Context(ctx_py))
    except Exception as e:
        out = None
        err = type(e).__name__ + ": " + str(e)
    body = ["source=" + lit(src_ours), lit(json.dumps(ctx_js, ensure_ascii=False))]
    if out is not None:
        out = out.replace("&#x27;", "&#39;").replace("&quot;", "&#34;")
    body.append("output=" + lit(out) if out is not None else "error=" + lit(err))
    body.append("autoescape=true")
    lines.append("///|\ntest %s {\n  jinja(\n    %s,\n  )\n}\n" % (lit("django %s #%d" % (name, i)), ",\n    ".join(body)))
open(sys.argv[1], "w", encoding="utf-8", newline="\n").write("\n".join(lines))
print(len(lines))
