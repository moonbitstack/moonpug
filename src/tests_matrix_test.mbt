// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The 30 Jinja tests, one verdict each. `defined` and `undefined` are
/// covered in the statement matrix; here are the value-level ones.
fn ask(template : String, context : String) -> String {
  @moonpug.render(template, @json.parse(context)) catch {
    fault => "F:\{fault}"
  }
}

///|
test "the value-level Jinja tests, one case each" {
  let cases : Array[(String, String, String)] = [
    ("{{ 1 is boolean }}|{{ 'x' is boolean }}", "{}", "False|False"),
    ("{{ loop_var is callable }}|{{ 1 is callable }}", "{}", "False|False"),
    ("{{ 6 is divisibleby(3) }}|{{ 6 is divisibleby(4) }}", "{}", "True|False"),
    ("{{ 1 is eq 1 }}|{{ 1 is eq 2 }}", "{}", "True|False"),
    ("{{ 1 is equalto 1 }}", "{}", "True"),
    ("{{ 1 is ne 2 }}|{{ 1 is ne 1 }}", "{}", "True|False"),
    ("{{ 2 is gt 1 }}|{{ 1 is gt 2 }}", "{}", "True|False"),
    ("{{ 2 is greaterthan 1 }}", "{}", "True"),
    ("{{ 2 is ge 2 }}|{{ 1 is ge 2 }}", "{}", "True|False"),
    ("{{ 1 is lt 2 }}|{{ 2 is lt 1 }}", "{}", "True|False"),
    ("{{ 1 is lessthan 2 }}", "{}", "True"),
    ("{{ 2 is le 2 }}|{{ 3 is le 2 }}", "{}", "True|False"),
    ("{{ '<b>'|safe is escaped }}|{{ 'x' is escaped }}", "{}", "True|False"),
    ("{{ 2 is even }}|{{ 3 is even }}", "{}", "True|False"),
    ("{{ 3 is odd }}|{{ 2 is odd }}", "{}", "True|False"),
    ("{{ false is false }}|{{ true is false }}", "{}", "True|False"),
    ("{{ true is true }}|{{ false is true }}", "{}", "True|False"),
    // Neither filters nor tests are values here, so nothing satisfies them.
    ("{{ range is filter }}|{{ 1 is filter }}", "{}", "False|False"),
    // Test objects are not template values, so nothing in a template is one.
    ("{{ range is test }}|{{ 1 is test }}", "{}", "False|False"),
    ("{{ 1.5 is float }}|{{ 1 is float }}", "{}", "True|False"),
    ("{{ 1 is integer }}|{{ 1.5 is integer }}", "{}", "True|False"),
    ("{{ 1 is number }}|{{ 1.5 is number }}|{{ 'x' is number }}|{{ true is number }}", "{}", "True|True|False|True"),
    ("{{ 'a' in 'abc' is in('abc') }}|{{ 1 is in([2]) }}", "{}", "False|False"),
    ("{{ 1 is in([1, 2]) }}|{{ 3 is in([1, 2]) }}", "{}", "True|False"),
    ("{{ [1] is iterable }}|{{ 'a' is iterable }}|{{ 1 is iterable }}", "{}", "True|True|False"),
    ("{{ {} is mapping }}|{{ [] is mapping }}", "{}", "True|False"),
    ("{{ [1] is sequence }}|{{ 'a' is sequence }}|{{ 1 is sequence }}", "{}", "True|True|False"),
    ("{{ 'a' is string }}|{{ 1 is string }}", "{}", "True|False"),
    ("{{ 'abc' is lower }}|{{ 'Abc' is lower }}", "{}", "True|False"),
    ("{{ 'ABC' is upper }}|{{ 'Abc' is upper }}", "{}", "True|False"),
    ("{{ none is none }}|{{ 0 is none }}", "{}", "True|False"),
    ("{{ true is sameas true }}|{{ 1 is sameas 1.0 }}", "{}", "True|False"),
  ]
  for case in cases {
    let (template, context, want) = case
    let got = ask(template, context)
    if got != want {
      abort("test case failed: \{template} -> \{got}, wanted \{want}")
    }
  }
}

///|
test "the sameas caveat: numbers across int and double are not the same object" {
  assert_eq(ask("{{ 1 is sameas 1 }}", "{}"), "True")
}

///|
test "defined and undefined read the expression, not the value" {
  assert_eq(ask("{{ ghost is defined }}|{{ ghost is not defined }}|{{ 1 is defined }}", "{}"), "False|True|True")
  assert_eq(ask("{{ ghost is undefined }}|{{ 1 is undefined }}", "{}"), "True|False")
  // Strict still refuses the value itself; only the test is safe.
  assert_eq(ask("{{ ghost is defined and (ghost is defined) }}", "{}"), "False")
}
