// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
fn main {
  let page = @moonpug.render(
    "Hello, {{ name }}!",
    @json.parse("{ \"name\": \"moonpug\" }"),
  ) catch {
    fault => "render failed: \{fault}"
  }
  println(page)
}
