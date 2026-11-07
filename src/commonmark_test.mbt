///|
/// Render a document as a template in the `md` frontend, with no tag in it
/// to interfere. `safe=false` because the specification's examples carry raw
/// HTML and expect it to stay.
fn as_template(markdown : String) -> String {
  let format = { ..@moonpug.markdown, safe: false, }
  @moonpug.render(markdown, Json::object(Map([])), format~) catch {
    e => "refused: \{e}"
  }
}

///|
/// Every example the CommonMark specification gives, read as a template and
/// compared with what the Markdown reader writes for the same document: a
/// template with no tag in it has to come out unchanged by the frontend. The
/// count that also matches the specification's own HTML is reported, since
/// that is the Markdown reader's business, not the frontend's.
test "every CommonMark example renders as the same document" {
  let cases = commonmark_cases()
  assert_eq(cases.length(), 652)
  let failures = []
  let mut agrees = 0
  for case in cases {
    let (number, section, doc, wanted) = case
    let direct = @moonmd.parse(doc).html(safe=false)
    if direct == wanted {
      agrees += 1
    }
    let got = as_template(doc)
    if got != direct {
      failures.push(
        "example \{number} (\{section}): \{repr(got)} where the reader writes \{repr(direct)}",
      )
    }
  }
  println(
    "commonmark: \{agrees}/\{cases.length()} examples agree with the specification",
  )
  if !failures.is_empty() {
    let shown = if failures.length() > 10 { 10 } else { failures.length() }
    fail(
      "\{failures.length()} examples differ from the reader:\n\{failures[:shown].join("\n")}",
    )
  }
}
