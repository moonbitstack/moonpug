///|
/// A compiled template, ready to render any number of times.
pub struct Template {
  priv env : Env
  priv name : String
  priv format : Format
  priv nodes : Array[@syntax.Node]
}

///|
/// The name the template was compiled under.
pub fn Template::name(self : Template) -> String {
  self.name
}

///|
/// Render with a context of data: a `Json` object, or any value whose
/// `to_json` gives one.
pub fn[C : ToJson] Template::render(
  self : Template,
  context : C,
) -> String raise @spec.Refused {
  match @spec.Value::of_json(Json(context)) {
    Dict(fields) => self.render_values(fields)
    other =>
      raise Invalid(
        template=self.name,
        line=0,
        reason="the context must be a mapping, not \{other.kind()}",
      )
  }
}

///|
/// Render with values that may hold functions and objects as well as data.
pub fn Template::render_values(
  self : Template,
  values : Map[String, @spec.Value],
) -> String raise @spec.Refused {
  let run = Run::new(self.env, self.name, self.format.autoescape, values.copy())
  run.scopes[0]["self"] = Object(Blocks::{ run, })
  run.render_chain(self.nodes)
  run.out.to_string()
}

///|
/// Compile and render `source` in one call. `format` and `force` override
/// the settings' own; `load`, `translate` and `cache` are the seams
/// `Env::new` takes.
pub fn[C : ToJson] render(
  source : StringView,
  context : C,
  settings~ : Settings = settings,
  format? : Format,
  force? : Bool,
  load? : (String) -> String?,
  translate? : (String, String?, Int32?) -> String?,
  cache? : (String, () -> String raise @spec.Refused) -> String raise @spec.Refused,
) -> String raise @spec.Refused {
  let settings = match force {
    Some(f) => { ..settings, force: f, }
    None => settings
  }
  Env::new(settings~, load?, translate?, cache?)
  .compile(source, format?)
  .render(context)
}
