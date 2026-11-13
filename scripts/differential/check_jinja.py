"""Render the Jinja cases with Jinja 3.1.6 itself and compare them with what
moonpug wrote.

    python scripts/differential/check_jinja.py <rendered.json>

`rendered.json` is what render_cases.mjs wrote, from the engine compiled to
JavaScript. The environment is set up the way moonpug's `html` preset is:
escaping on, an undefined name refused, no trimming of lines or whitespace
around tags. Anything that disagrees is printed with both sides and fails the
run.
"""

import json
import pathlib
import sys

from jinja2 import Environment, StrictUndefined

HERE = pathlib.Path(__file__).resolve().parent
CASES = HERE / "cases.json"


def main() -> int:
    rendered = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
    cases = json.loads(CASES.read_text(encoding="utf-8"))["jinja"]
    environment = Environment(
        autoescape=True,
        undefined=StrictUndefined,
        trim_blocks=False,
        lstrip_blocks=False,
        keep_trailing_newline=False,
    )
    differs = []
    for one in cases:
        want = environment.from_string(one["source"]).render(**one["data"])
        got = rendered["jinja"].get(one["name"])
        if got != want:
            differs.append((one["name"], want, got))
    for name, want, got in differs:
        print(f"{name}: jinja wrote {want!r}, moonpug wrote {got!r}")
    print(f"jinja 3.1.6: {len(cases) - len(differs)}/{len(cases)} cases agree")
    return 1 if differs else 0


if __name__ == "__main__":
    sys.exit(main())
