"""pytest plugin: record every template render Jinja's own tests perform."""
import json, atexit
import jinja2
from jinja2 import environment, loaders

RECORDS = []
CURRENT = [None]

def pytest_runtest_setup(item):
    CURRENT[0] = item.nodeid

_orig_from_string = environment.Environment.from_string
_orig_get_template = environment.Environment.get_template
_orig_render = environment.Template.render

def from_string(self, source, *a, **kw):
    t = _orig_from_string(self, source, *a, **kw)
    t._rec_source = source if isinstance(source, str) else None
    return t

def get_template(self, name, *a, **kw):
    t = _orig_get_template(self, name, *a, **kw)
    t._rec_name = name if isinstance(name, str) else None
    return t

def env_config(env):
    loader = env.loader
    templates = None
    if isinstance(loader, loaders.DictLoader):
        templates = dict(loader.mapping)
    elif loader is not None:
        templates = "unsupported"
    ext = sorted(type(e).__module__ + "." + type(e).__name__ for e in env.extensions.values())
    default = jinja2.Environment()
    custom = (set(env.filters) - set(default.filters)) or (set(env.tests) - set(default.tests)) \
        or any(env.filters[k] is not default.filters[k] for k in default.filters) \
        or any(env.tests[k] is not default.tests[k] for k in default.tests)
    import jinja2.defaults as d
    return {
        "class": type(env).__module__ + "." + type(env).__name__,
        "policies": sorted(k for k in set(env.policies) | set(d.DEFAULT_POLICIES) if env.policies.get(k) != d.DEFAULT_POLICIES.get(k)),
        "autoescape": env.autoescape if isinstance(env.autoescape, bool) else "callable",
        "undefined": env.undefined.__name__,
        "trim_blocks": env.trim_blocks,
        "lstrip_blocks": env.lstrip_blocks,
        "keep_trailing_newline": env.keep_trailing_newline,
        "line_statement_prefix": env.line_statement_prefix,
        "line_comment_prefix": env.line_comment_prefix,
        "delimiters": [env.block_start_string, env.block_end_string, env.variable_start_string,
                       env.variable_end_string, env.comment_start_string, env.comment_end_string],
        "extensions": ext,
        "finalize": env.finalize is not None,
        "newline_sequence": env.newline_sequence,
        "custom": bool(custom),
        "globals": {k: env.globals[k] for k in env.globals if k not in default.globals and k not in ("gettext","ngettext","pgettext","npgettext","_")} if jsonable({k: env.globals[k] for k in env.globals if k not in default.globals and k not in ("gettext","ngettext","pgettext","npgettext","_")}) else "unsupported",
        "globals_extra": sorted(k for k in env.globals if k not in default.globals and k not in ("gettext","ngettext","pgettext","npgettext","_")),
        "is_async": env.is_async,
        "templates": templates,
        "newstyle": getattr(env, "newstyle_gettext", False),
        "gettext": repr(env.globals.get("gettext")),
    }

def jsonable(v):
    if v is None or type(v) in (bool, str):
        return True
    if type(v) is int:
        return abs(v) < 2**63
    if type(v) is float:
        return v == v and abs(v) != float("inf")
    if type(v) is list:
        return all(jsonable(x) for x in v)
    if type(v) is dict:
        return all(type(k) is str and jsonable(x) for k, x in v.items())
    return False

def render(self, *args, **kwargs):
    ctx = dict(*args, **kwargs)
    entry = {"test": CURRENT[0], "source": getattr(self, "_rec_source", None), "name": getattr(self, "_rec_name", None),
             "context": ctx if jsonable(ctx) else "unsupported", "env": env_config(self.environment),
             "template_globals": sorted(k for k in self.globals if k not in self.environment.globals or self.globals[k] is not self.environment.globals[k])}
    try:
        out = _orig_render(self, *args, **kwargs)
        entry["output"] = out
    except Exception as e:
        entry["error"] = type(e).__name__ + ": " + str(e)
        RECORDS.append(entry)
        raise
    RECORDS.append(entry)
    return out

environment.Environment.from_string = from_string
environment.Environment.get_template = get_template
environment.Template.render = render

@atexit.register
def dump():
    with open("records.json", "w", encoding="utf-8") as f:
        json.dump(RECORDS, f, ensure_ascii=False, indent=0)
