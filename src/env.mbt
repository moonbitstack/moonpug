///|
/// Where templates come from and what they all see: the settings, the
/// filters, tests and global values, the loader and the seams for
/// translation and caching. Compiled templates are kept per environment.
pub struct Env {
  priv settings : Settings
  priv filters : Map[String, @spec.Filter]
  priv tests : Map[String, @spec.Test]
  priv globals : Map[String, @spec.Value]
  priv load : ((String) -> String?)?
  priv langs : Map[String, Lang]
  priv translate : ((String, String?, Int32?) -> String?)?
  priv cache : ((String, () -> String raise @spec.Refused) -> String raise @spec.Refused)?
  priv compiled : Map[String, Template]
}

///|
/// An environment with the built-in languages, filters, tests and globals.
///
/// `load` turns a template name into its source for `extends`, `include`,
/// `import` and `Env::template`; without it those are refused. `translate`
/// answers gettext and `{% trans %}`: given a message, its context and the
/// plural count, the translation or `None`. `cache` stores what
/// `{% once key %}` renders: given the key and a way to render, the text.
pub fn Env::new(
  settings~ : Settings = settings,
  load? : (String) -> String?,
  translate? : (String, String?, Int32?) -> String?,
  cache? : (String, () -> String raise @spec.Refused) -> String raise @spec.Refused,
) -> Env {
  let env = {
    settings,
    filters: @defaults.filters(),
    tests: @defaults.tests(),
    globals: @defaults.globals(),
    langs: Map([]),
    load,
    translate,
    cache,
    compiled: Map([]),
  }
  for lang in [@syntax.html, @syntax.markdown, @syntax.pug] {
    env.add_lang(lang)
  }
  env
}

///|
/// Register a language under its name and aliases, replacing any that
/// answer to the same; `Format.lang` and `{% block lang=… %}` find it.
pub fn Env::add_lang(self : Env, lang : Lang) -> Unit {
  self.langs[lang.name] = lang
  for other in lang.aliases {
    self.langs[other] = lang
  }
}

///|
/// Register a filter, replacing any of the same name.
pub fn Env::add_filter(
  self : Env,
  name : String,
  filter : @spec.Filter,
) -> Unit {
  self.filters[name] = filter
}

///|
/// Register a test, replacing any of the same name.
pub fn Env::add_test(self : Env, name : String, test_ : @spec.Test) -> Unit {
  self.tests[name] = test_
}

///|
/// Make a value visible to every template, replacing any of the same name;
/// a function is `Value::func(name, …)`.
pub fn Env::add_global(self : Env, name : String, value : @spec.Value) -> Unit {
  self.globals[name] = value
}

///|
/// Read a source into a template. A `name` picks the format by its
/// extension and appears in errors; `format` overrides either.
pub fn Env::compile(
  self : Env,
  source : StringView,
  name? : String,
  format? : Format,
) -> Template raise @spec.Refused {
  let chosen = match (format, name) {
    (Some(f), _) => f
    (None, Some(n)) => (self.settings.formats)(n)
    (None, None) => self.settings.format
  }
  let template = name.unwrap_or("<template>")
  let settings = self.settings
  let lang = match self.langs.get(chosen.lang) {
    Some(l) => l
    None => raise Unknown(template~, line=0, kind="language", name=chosen.lang)
  }
  let reading : Reading = {
    lang,
    force: settings.force,
    template,
    line: 1,
    options: {
      trim_blocks: chosen.trim_blocks,
      lstrip_blocks: chosen.lstrip_blocks,
      keep_trailing_newline: chosen.keep_trailing_newline,
      line_statement: settings.line_statement,
      line_comment: settings.line_comment,
    },
    langs: n => self.langs.get(n),
  }
  let nodes = @syntax.read(source.to_owned(), reading)
  { env: self, name: template, format: chosen, nodes, }
}

///|
/// The template the loader finds under `name`, compiled once and kept.
pub fn Env::template(self : Env, name : String) -> Template raise @spec.Refused {
  match self.find(name) {
    Some(t) => t
    None => raise Unknown(template="", line=0, kind="template", name~)
  }
}

///|
fn Env::find(self : Env, name : String) -> Template? raise @spec.Refused {
  match self.compiled.get(name) {
    Some(t) => Some(t)
    None =>
      match self.source(name) {
        Some(source) => {
          let t = self.compile(source, name~)
          self.compiled[name] = t
          Some(t)
        }
        None => None
      }
  }
}

///|
fn Env::source(self : Env, name : String) -> String? {
  match self.load {
    Some(load) => load(name)
    None => None
  }
}

///|
fn Env::call(self : Env, autoescape : Bool) -> @spec.Call {
  @spec.Call::new(
    autoescape~,
    undefined=self.settings.undefined,
    range=self.settings.limits.range,
    filters=self.filters,
    tests=self.tests,
    translate?=self.translate,
  )
}
