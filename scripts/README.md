# scripts

`fetch_suites.py` pulls the reference test suites the fixtures come from —
Jinja2's own tests, Pug's `test/cases`, and the Django template tests — and
writes them under `tests/fixtures/` for the matrix to consume. Run it when
bumping the tracked versions; the fixtures in the tree are the ones CI uses.
