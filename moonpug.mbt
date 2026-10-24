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

///|
/// One template, one context, one piece of text.
///
/// The seams carry everything this engine refuses to know: `load` hands over
/// another template by name, `translate` carries the gettext question to the
/// caller, `globals` registers host functions such as `url` and `now`, and
/// `cache` stores what `{% once %}` renders. Escaping is on by default and
/// undefined names are strict by default — the family's rule that safety is
/// what you get before you ask.
pub fn render(
  source : StringView,
  context : Json,
  syntax~ : Syntax = Html,
  force~ : Bool = false,
  load? : (String) -> String?,
  translate? : (String, String?, Int32?) -> String?,
  globals? : Map[String, (Array[Json]) -> Json],
  cache? : (String, () -> String raise Fault) -> String raise Fault,
  autoescape~ : Bool = true,
  undefined_policy~ : UndefinedPolicy = Strict,
  trim_blocks~ : Bool = false,
  lstrip_blocks~ : Bool = false,
  keep_trailing_newline~ : Bool = false,
  line? : String,
  shortcuts? : Map[String, String],
) -> String raise Fault {
  let md_preset = syntax is Markdown
  let opts : ReadOpts = {
    syntax,
    force,
    trim_blocks: trim_blocks || md_preset,
    lstrip_blocks: lstrip_blocks || md_preset,
    keep_trailing_newline: keep_trailing_newline || md_preset,
    line,
    shortcuts: match shortcuts {
      Some(table) => table
      None => {}
    },
  }
  let natives = builtin_natives(translate)
  for name, call in kw_natives() {
    natives.set(name, WithKw(call))
  }
  match globals {
    Some(table) =>
      for name, call in table {
        natives.set(
          name,
          Simple(args => {
            let json_args = []
            for arg in args {
              json_args.push(to_json(arg))
            }
            to_value(call(json_args))
          }),
        )
      }
    None => ()
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
    blocks: {},
    natives,
    once: {},
    load,
    translate,
    cache_fn: cache,
    opts,
    policy: undefined_policy,
    autoescape,
    once_tally: 0,
    braking: false,
    skipping: false,
  }
  let nodes = parse_template(source.to_owned(), opts)
  let outer = enter_chain(env, nodes)
  run_nodes(env, outer)
  if env.braking || env.skipping {
    raise Wrong(because="break and continue belong inside a loop")
  }
  env.out.to_string()
}
