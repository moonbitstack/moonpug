///|
/// The tags Django writes as `{% … %}` that have no statement here: a
/// delimiter spelled out, a query string built from its arguments, and the
/// calls the program answers through `Host`.
///
/// `templatetag` is a global because it takes a name and no value;
/// `query_string` is a global for the same reason. `widthratio` is a filter,
/// the value being what the ratio is taken of.

///|
/// The delimiters a template writes as text, by Django's name for each.
let template_tags : Map[String, String] = Map([
  ("openblock", "{%"),
  ("closeblock", "%}"),
  ("openvariable", "{{"),
  ("closevariable", "}}"),
  ("openbrace", "{"),
  ("closebrace", "}"),
  ("opencomment", "{#"),
  ("closecomment", "#}"),
])

///|
fn global_templatetag(
  call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("templatetag", ["tag"], args, named)
  let name = call.text(b.need("tag"))
  match template_tags.get(name) {
    Some(text) => Text(text)
    None =>
      raise @spec.invalid(
        "templatetag has no \{name}; it knows \{template_tags.keys().join(", ")}",
      )
  }
}

///|
/// Python's `quote_plus`: everything but letters, digits and `_.-~` becomes
/// `%XX` of its UTF-8 bytes, and a space becomes `+`.
fn quote_plus(text : String) -> String {
  let hex = "0123456789ABCDEF"
  let out = StringBuilder()
  for byte in @utf8.encode(text) {
    let b = byte.to_int()
    let ch = b.unsafe_to_char()
    if b < 0x80 &&
      (
        ch.is_ascii_alphabetic() ||
        ch.is_ascii_digit() ||
        ch is ('_' | '.' | '-' | '~')
      ) {
      out.write_char(ch)
    } else if b == 0x20 {
      out.write_char('+')
    } else {
      out.write_char('%')
      out.write_char(hex[b >> 4].to_int().unsafe_to_char())
      out.write_char(hex[b & 0xF].to_int().unsafe_to_char())
    }
  }
  out.to_string()
}

///|
/// The values one key carries in a query string, in the order given.
fn query_values(value : @spec.Value) -> Array[String]? {
  match value {
    Null => None
    Seq(items) | Tuple(items) => {
      let out = []
      for item in items {
        if item is Null {
          continue
        }
        out.push(item.to_string())
      }
      Some(out)
    }
    _ => Some([value.to_string()])
  }
}

///|
/// A query string from mappings and named values: a `Null` drops its key, a
/// list repeats it. The lead `?` is always there, as Django writes it.
fn global_query_string(
  call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let params : Map[String, Array[String]] = Map([])
  let put = (key : String, value : @spec.Value) => {
    match query_values(value) {
      None => ignore(params.remove(key))
      Some(values) =>
        if values.is_empty() {
          ignore(params.remove(key))
        } else {
          params[key] = values
        }
    }
  }
  for arg in args {
    guard arg is Dict(fields) else {
      raise @spec.invalid("query_string takes mappings, not \{arg.kind()}")
    }
    for key, value in fields {
      put(key, value)
    }
  }
  for key, value in named {
    put(key, value)
  }
  let out = []
  for key, values in params {
    for value in values {
      out.push(quote_plus(key) + "=" + quote_plus(value))
    }
  }
  ignore(call)
  Text("?" + out.join("&"))
}

///|
/// The number Django's `widthratio` writes: the ratio of the value to a
/// maximum, scaled to a width, rounded half to even as Python's `round`.
fn filter_widthratio(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("widthratio", ["max_value", "max_width"], args, named)
  let max_value = b.need("max_value")
  let width = match python_int(b.get("max_width").unwrap_or(Int(100L))) {
    Some(w) => w.to_double()
    None => raise @spec.invalid("widthratio wants a number for its width")
  }
  let top = match to_float(max_value) {
    Some(d) => d
    None => return Text("")
  }
  let of = match to_float(value) {
    Some(d) => d
    None => return Text("")
  }
  ignore(call)
  if top == 0.0 {
    return Text("0")
  }
  let ratio = of / top * width
  if ratio.is_nan() {
    return Text("")
  }
  if ratio.is_inf() {
    return Text("")
  }
  let floor = ratio.floor()
  let part = ratio - floor
  let rounded = if part > 0.5 {
    floor + 1.0
  } else if part < 0.5 {
    floor
  } else if (floor / 2.0).floor() * 2.0 == floor {
    floor
  } else {
    floor + 1.0
  }
  if rounded.abs() >= 9.223372036854775808e18 {
    return Text("")
  }
  Text(rounded.to_int64().to_string())
}

///|
/// The moment a host's `now` gives, written in Django's format letters; the
/// format may also be the name of one of Django's own settings.
fn now_at(
  seam : () -> String,
  call : @spec.Call,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("now", ["format"], args, named)
  let format = format_arg(call, b.get("format"), "DATE_FORMAT")
  match local_of(Text(seam())) {
    Some(m) => Text(django_format(m, format, false).unwrap_or(""))
    None => raise @spec.invalid("the host's clock did not give a date")
  }
}

///|
/// The globals a host fills: an address by name, where its files sit, the
/// token a form carries, and the clock. Only what the host answers to is
/// defined in templates.
pub fn host_globals(host : @spec.Host) -> Map[String, @spec.Value] {
  let out : Map[String, @spec.Value] = Map([])
  match host.url {
    Some(seam) =>
      out["url"] = @spec.Value::func("url", (call, args, named) => {
        guard args is [first, ..] else {
          raise @spec.invalid("url wants the name of a route")
        }
        Text(seam(call.text(first), args[1:].to_owned(), named))
      })
    None => ()
  }
  match host.asset {
    Some(seam) =>
      out["static"] = @spec.Value::func("static", (call, args, named) => {
        let b = bind("static", ["path"], args, named)
        Text(seam(call.text(b.need("path"))))
      })
    None => ()
  }
  match host.asset_prefix {
    Some(seam) =>
      out["static_prefix"] = @spec.Value::func("static_prefix", (_, _, _) => {
        Text(seam())
      })
    None => ()
  }
  match host.media_prefix {
    Some(seam) =>
      out["media_prefix"] = @spec.Value::func("media_prefix", (_, _, _) => {
        Text(seam())
      })
    None => ()
  }
  match host.csrf_token {
    Some(seam) =>
      out["csrf_token"] = @spec.Value::func("csrf_token", (_, _, _) => {
        Markup(seam())
      })
    None => ()
  }
  match host.now {
    Some(seam) =>
      out["now"] = @spec.Value::func("now", (call, args, named) => {
        now_at(seam, call, args, named)
      })
    None => ()
  }
  out
}
