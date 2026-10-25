///|
fn object_of(text : String) -> Map[String, Json] raise {
  guard @json.parse(text) is Object(fields) else {
    fail("not an object: \{text}")
  }
  fields
}

///|
fn repr(s : String) -> String {
  Json::string(s).stringify()
}

///|
/// Compare a render with what the reference wrote, or, where the reference
/// raised, check that the render is refused too.
fn compare(
  result : Result[String, Error],
  output : String?,
  error : String?,
) -> Unit raise {
  match (result, output) {
    (Ok(got), Some(want)) =>
      if got != want {
        fail("wrote  \{repr(got)}\nwanted \{repr(want)}")
      }
    (Err(e), Some(want)) => fail("refused: \{e}\nwanted \{repr(want)}")
    (Ok(got), None) =>
      fail("wrote \{repr(got)}\nwanted an error: \{error.unwrap_or("")}")
    (Err(_), None) => ()
  }
}

///|
/// Render as the recorded environment did.
fn jinja(
  context : String,
  source? : String,
  name? : String,
  output? : String,
  error? : String,
  policy? : @moonpug.Undefined,
  autoescape? : Bool,
  trim_blocks? : Bool,
  lstrip_blocks? : Bool,
  keep_trailing_newline? : Bool,
  line_statement? : String,
  line_comment? : String,
  templates? : String,
  globals? : String,
) -> Unit raise {
  let format : @moonpug.Format = {
    lang: "html",
    autoescape: autoescape.unwrap_or(false),
    trim_blocks: trim_blocks.unwrap_or(false),
    lstrip_blocks: lstrip_blocks.unwrap_or(false),
    keep_trailing_newline: keep_trailing_newline.unwrap_or(false),
  }
  let settings = {
    ..@moonpug.settings,
    format,
    formats: _ => format,
    undefined: policy.unwrap_or(Lenient),
    line_statement,
    line_comment,
  }
  let sources : Map[String, String] = Map([])
  if templates is Some(t) {
    for k, v in object_of(t) {
      guard v is String(s) else { fail("template \{k} is not text") }
      sources[k] = s
    }
  }
  let env = @moonpug.Env::new(settings~, load=n => sources.get(n))
  if globals is Some(g) {
    for k, v in object_of(g) {
      env.add_global(k, @moonpug.Value::of_json(v))
    }
  }
  let data = @json.parse(context)
  let result : Result[String, Error] = try {
    let template = match (source, name) {
      (Some(s), _) => env.compile(s)
      (None, Some(n)) => env.template(n)
      (None, None) => fail("neither a source nor a name")
    }
    template.render(data)
  } catch {
    e => Err(e)
  } noraise {
    got => Ok(got)
  }
  compare(result, output, error)
}

///|
/// Quotes as Pug escapes them: `"` as `&quot;`, `'` left alone.
fn pug_quotes(s : String) -> String {
  s.replace_all(old="&#34;", new="&quot;").replace_all(old="&#39;", new="'")
}

///|
/// Render a Pug test case by name, the other cases loadable beside it.
fn pug(name : String, output : String) -> Unit raise {
  let settings = { ..@moonpug.settings, undefined: Lenient, }
  let env = @moonpug.Env::new(settings~, load=n => pug_cases.get(n))
  let got = env.template(name).render(Json::object(Map([])))
  if pug_quotes(got) != pug_quotes(output) {
    fail("wrote  \{repr(got)}\nwanted \{repr(output)}")
  }
}

///|
/// Render Pug source with a JSON context and compare with what Pug wrote.
fn pug_source(source : String, context : String, output : String) -> Unit raise {
  let settings = { ..@moonpug.settings, undefined: Lenient, }
  let got = @moonpug.render(
    source,
    @json.parse(context),
    settings~,
    format=@moonpug.pug,
  )
  if pug_quotes(got) != pug_quotes(output) {
    fail("wrote  \{repr(got)}\nwanted \{repr(output)}")
  }
}

///|
/// A render as text, or the refusal as `refused: <message>`.
fn r(
  source : String,
  context~ : String = "{}",
  format~ : @moonpug.Format = @moonpug.html,
  settings~ : @moonpug.Settings = @moonpug.settings,
  load? : (String) -> String?,
) -> String {
  @moonpug.render(source, @json.parse(context), settings~, format~, load?) catch {
    e => "refused: \{e}"
  }
}

///|
fn files(pairs : Array[(String, String)]) -> (String) -> String? {
  let m = Map::from_array(pairs)
  n => m.get(n)
}

///|
/// The catalog the i18n vectors were rendered with.
fn catalog(message : String, context : String?, count : Int32?) -> String? {
  let forms : Map[String, (String, String)] = Map([
    ("%(num)d apple", ("%(num)d Apfel", "%(num)d Äpfel")),
    ("%(count)s item", ("%(count)s Ding", "%(count)s Dinge")),
  ])
  match (context, count) {
    (None, None) =>
      match message {
        "Hello" => Some("Hallo")
        "Hello %(user)s!" => Some("Hallo %(user)s!")
        "Bye" => Some("Tschüss <b>")
        _ => None
      }
    (None, Some(n)) =>
      forms.get(message).map(f => if n == 1 { f.0 } else { f.1 })
    (Some("menu"), None) =>
      if message == "Open" {
        Some("Öffnen")
      } else {
        None
      }
    (Some("shop"), Some(n)) =>
      if message == "%(num)d box" {
        Some(if n == 1 { "%(num)d Kiste" } else { "%(num)d Kisten" })
      } else {
        None
      }
    _ => None
  }
}

///|
fn i18n(
  source : String,
  context : String,
  output? : String,
  error? : String,
  autoescape? : Bool,
) -> Unit raise {
  let format = { ..@moonpug.html, autoescape: autoescape.unwrap_or(false), }
  let env = @moonpug.Env::new(
    settings={ ..@moonpug.settings, format, },
    translate=catalog,
  )
  let result : Result[String, Error] = try
    env.compile(source).render(@json.parse(context))
  catch {
    e => Err(e)
  } noraise {
    got => Ok(got)
  }
  compare(result, output, error)
}
