// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Which of the three surfaces a source is written in.
///
/// `Html` is the default: text with Jinja's braces, and nothing else. A whole
/// file given to `Pug` is exactly that file wrapped in one big
/// `block lang=pug`, and the same holds for `Markdown`. A block can switch
/// language anywhere: `{% block lang=pug %} … {% endblock %}` nests
/// recursively and keeps the variables around it.
pub fn render(
  source : StringView,
  context : Json,
  settings? : Settings,
  name? : String,
  syntax? : Syntax,
  load? : (String) -> String?,
  translate? : (String, String?, Int32?) -> String?,
  cache? : (String, () -> String raise Fault) -> String raise Fault,
  undefined_policy? : UndefinedPolicy,
  wins? : Wins,
  clash? : OnClash[Entry],
) -> String raise Fault {
  let chosen = match settings {
    Some(given) => given
    None => preset
  }
  let wins = match wins {
    Some(given) => given
    None => Extra
  }
  let clash = match clash {
    Some(given) => given
    None => Ignore
  }
  let filters = merge_registry(
    "filter",
    builtin_filters(),
    chosen.filters,
    fn(found) -> Entry { FilterOf(found) },
    fn(entry) -> &Filter {
      match entry {
        FilterOf(found) => found
        other => ignore_entry_filter(other)
      }
    },
    wins,
    clash,
  )
  let tests = merge_registry(
    "test",
    builtin_tests(),
    chosen.tests,
    found => TestOf(found),
    entry => {
      match entry {
        TestOf(found) => found
        other => ignore_entry_test(other)
      }
    },
    wins,
    clash,
  )
  let globals = merge_registry(
    "global",
    builtin_globals(),
    chosen.globals,
    found => GlobalOf(found),
    entry => {
      match entry {
        GlobalOf(found) => found
        other => ignore_entry_global(other)
      }
    },
    wins,
    clash,
  )
  let surface = match syntax {
    Some(given) => given
    None => chosen.syntax
  }
  let policy = match undefined_policy {
    Some(given) => given
    None => chosen.undefined_policy
  }
  let seam = match translate {
    Some(given) => Some(given)
    None => chosen.translate
  }
  let once_store = match cache {
    Some(given) => Some(given)
    None => chosen.cache
  }
  let loader_fn = match load {
    Some(given) => Some(given)
    None =>
      match chosen.loader {
        Some(found) => {
          fn fetch(n : String) -> String? {
            found.load(n)
          }
          Some(fetch)
        }
        None => None
      }
  }
  let md_preset = surface is Markdown
  let opts : ReadOpts = {
    syntax: surface,
    force: chosen.force,
    trim_blocks: chosen.trim_blocks || md_preset,
    lstrip_blocks: chosen.lstrip_blocks || md_preset,
    keep_trailing_newline: chosen.keep_trailing_newline || md_preset,
    line: chosen.line,
    shortcuts: chosen.shortcuts,
    sandbox: chosen.sandbox,
  }
  let base = match context {
    Object(_) => to_value(context)
    _ => raise Wrong(because="the context wants a JSON object")
  }
  let fields = match base {
    Dict(fields) => fields
    _ => raise Wrong(because="the context wants a JSON object")
  }
  let env : Env = {
    out: StringBuilder(),
    stack: [fields],
    blocks: Map([]),
    filters,
    tests,
    globals,
    once: Map([]),
    tally: { n: 0, },
    load: loader_fn,
    translate: seam,
    cache_fn: once_store,
    opts,
    policy,
    // A sandbox forces the safe side: markup stays escaped whatever the
    // record said.
    autoescape: chosen.autoescape || chosen.sandbox,
    braking: false,
    skipping: false,
  }
  let template_name = match name {
    Some(given) => given
    None => "<template>"
  }
  let source = source.to_owned()
  try {
    let nodes = parse_template(source, opts)
    let outer = enter_chain(env, nodes)
    run_nodes(env, outer)
    if env.braking || env.skipping {
      raise Wrong(because="break and continue belong inside a loop")
    }
  } catch {
    Lexical(at~, because~, ..) =>
      raise locate(source, template_name, at, because)
    fault => raise fault
  }
  env.out.to_string()
}

///|
fn ignore_entry_filter(_entry : Entry) -> &Filter {
  // Only a same-kind entry ever reaches its own merge; the slot cannot be
  // wrong unless the engine itself is.
  abort("a filter entry arrived in the wrong slot")
}

///|
fn ignore_entry_test(_entry : Entry) -> &Test {
  abort("a test entry arrived in the wrong slot")
}

///|
fn ignore_entry_global(_entry : Entry) -> &Global {
  abort("a global entry arrived in the wrong slot")
}

///|
/// Where a byte offset sits, as a one-based line and column, for the fault
/// a caller reads.
fn locate(
  source : String,
  name : String,
  at : Int32,
  because : String,
) -> Fault {
  let mut line = 1
  let mut column = 1
  for i = 0; i < at && i < source.length(); i = i + 1 {
    if source.at(i) == 0x0A {
      line = line + 1
      column = 1
    } else {
      column = column + 1
    }
  }
  Lexical(at~, name~, line~, column~, because~)
}
// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Which of the three surfaces a source is written in.
///
/// `Html` is the default: text with Jinja's braces, and nothing else. A whole
/// file given to `Pug` is exactly that file wrapped in one big
/// `block lang=pug`, and the same holds for `Markdown`. A block can switch
/// language anywhere: `{% block lang=pug %} … {% endblock %}` nests
/// recursively and keeps the variables around it.
pub(all) enum Syntax {
  Html
  Pug
  Markdown
} derive(Eq, Debug)

///|
pub extend Syntax with Eq::{equal, not_equal}

///|
pub extend Syntax with Debug::{to_repr}

///|
pub extend Syntax with Show::{output, to_string}

///|
pub impl Show for Syntax with fn output(self, logger) {
  logger.write_string(
    match self {
      Html => "html"
      Pug => "pug"
      Markdown => "markdown"
    },
  )
}

///|
/// What happens when a name does not resolve, Jinja's three answers. The
/// family's rule is safe by default: strict unless asked otherwise.
pub(all) enum UndefinedPolicy {
  Strict
  Lenient
  Chainable
} derive(Eq, Debug)

///|
pub extend UndefinedPolicy with Eq::{equal, not_equal}

///|
pub extend UndefinedPolicy with Debug::{to_repr}

///|
pub extend UndefinedPolicy with Show::{output, to_string}

///|
pub impl Show for UndefinedPolicy with fn output(self, logger) {
  logger.write_string(
    match self {
      Strict => "strict"
      Lenient => "lenient"
      Chainable => "chainable"
    },
  )
}

///|
/// Parse a source in the surface the options name. The two frontends build
/// the same tree; nothing after this line knows which one read the template.
fn parse_template(source : String, opts : ReadOpts) -> Array[Node] raise Fault {
  match opts.syntax {
    Pug => parse_pug(source, opts)
    Html | Markdown => parse_braces(source, opts)
  }
}

///|
/// A loaded template's surface: the name says — `.pug` and `.md`/`.markdown`
/// endings count, and a name that says nothing is read the way its loader
/// was.
fn opts_for_name(opts : ReadOpts, name : String) -> ReadOpts {
  if name.has_suffix(".pug") {
    return { ..opts, syntax: Pug, }
  }
  if name.has_suffix(".md") || name.has_suffix(".markdown") {
    return {
      ..opts,
      syntax: Markdown,
      trim_blocks: true,
      lstrip_blocks: true,
      keep_trailing_newline: true,
    }
  }
  if name.has_suffix(".html") {
    return { ..opts, syntax: Html, }
  }
  opts
}

///|
fn opts_for_lang(opts : ReadOpts, lang : String) -> ReadOpts {
  match normalise_lang(lang) {
    Pug => { ..opts, syntax: Pug, }
    Markdown =>
      {
        ..opts,
        syntax: Markdown,
        trim_blocks: true,
        lstrip_blocks: true,
        keep_trailing_newline: true,
      }
    Html => { ..opts, syntax: Html, }
  }
}
