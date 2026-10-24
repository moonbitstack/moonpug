// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The command this repository installs: renders a small demonstration page
/// through both surfaces and prints the results.
#coverage.skip
fn main {
  println(page_brace())
  println(page_pug())
}

///|
fn demo_context() -> Json {
  @json.parse("{ \"name\": \"moonpug\", \"n\": 2 }") catch {
    _ => @json.parse("{}") catch { _ => abort("unreachable") }
  }
}

///|
fn page_brace() -> String {
  @moonpug.render("Hello, {{ name }}! {{ n * 2 }}", demo_context()) catch {
    fault => "error: \{fault}"
  }
}

///|
fn page_pug() -> String {
  @moonpug.render("p= name", demo_context(), syntax=Pug) catch {
    fault => "error: \{fault}"
  }
}
