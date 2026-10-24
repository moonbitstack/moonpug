// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The command this repository installs: a template, a JSON context on
/// stdin, the rendered text on stdout.
///
///     moon run bin -- init.pug '{"name": "world"}'
#coverage.skip
fn main raise {
  let args = @args.argv()
  let mut template = ""
  let mut context = "{}"
  for i = 0; i < args.length(); i = i + 1 {
    if args[i] == "--template" && i + 1 < args.length() {
      template = args[i + 1]
    } else if args[i] == "--context" && i + 1 < args.length() {
      context = args[i + 1]
    }
  }
  let page = @moonpug.render(
    template,
    @json.parse(context) catch {
      _ => @json.parse("{}")
    },
    syntax=Pug,
  ) catch {
    fault => "error: \{fault}"
  }
  println(page)
}
