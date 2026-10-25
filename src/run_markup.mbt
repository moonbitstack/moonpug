///|
/// `{% trans %}`: ask the seam for the message, fall back to the singular or
/// plural text, fill `%(name)s` from the bound values, and write it as
/// trusted text when escaping is on, escaping the values instead.
fn Run::trans(self : Run, t : @syntax.Trans) -> Unit raise @spec.Refused {
  let values : Map[String, @spec.Value] = Map([])
  for pair in t.vars {
    values[pair.0] = self.eval(pair.1)
  }
  let count = match t.count {
    Some(e) => Some(self.eval(e))
    None => None
  }
  let one = match count {
    Some(c) => c == Int(1)
    None => true
  }
  let fallback = match t.plural {
    Some(p) if !one => p
    _ => t.singular
  }
  let n = match count {
    Some(c) => c.index()
    None => None
  }
  let message = self.call
    .translate(t.singular, context?=t.context, count?=n)
    .unwrap_or(fallback)
  let text = if values.is_empty() {
    message
  } else {
    @defaults.percent(
      self.call,
      message,
      Dict(values),
      escape=self.autoescape(),
    )
  }
  if !self.extended {
    self.out.write_string(text)
  }
}

///|
/// The elements HTML leaves without a closing tag.
let void_elements : Array[String] = [
  "area", "base", "br", "col", "embed", "hr", "img", "input", "link", "meta", "param",
  "source", "track", "wbr",
]

///|
/// A value as JavaScript's `JSON.stringify` writes it, the text Pug gives an
/// attribute holding a number, a list or a mapping.
fn js_json(value : @spec.Value) -> String {
  match value {
    Null | Undefined(_) => "null"
    Bool(b) => if b { "true" } else { "false" }
    Int(n) => n.to_string()
    Double(d) =>
      if d.is_nan() || d.is_inf() {
        "null"
      } else if d == d.floor() && d.abs() < 1.0e21 {
        d.to_int64().to_string()
      } else {
        d.to_string()
      }
    Text(s) | Markup(s) => Json::string(s).stringify()
    Seq(items) | Tuple(items) => "[" + items.map(js_json).join(",") + "]"
    Dict(fields) => {
      let parts = []
      for k, v in fields {
        parts.push(Json::string(k).stringify() + ":" + js_json(v))
      }
      "{" + parts.join(",") + "}"
    }
    Object(_) => Json::string(value.to_string()).stringify()
  }
}

///|
/// Pug's class value: a list's members joined, a mapping's keys whose
/// values are true, text as it stands.
fn class_text(value : @spec.Value) -> String {
  match value {
    Seq(items) | Tuple(items) =>
      items.map(class_text).filter(c => !c.is_empty()).join(" ")
    Dict(fields) =>
      fields
      .iter()
      .filter(p => p.0 != "" && p.1.truthy())
      .map(p => p.0)
      .collect()
      .join(" ")
    Null | Undefined(_) | Bool(false) => ""
    other => other.to_string()
  }
}

///|
/// One attribute as Pug writes it: absent when false or missing, bare (or
/// repeated, outside the HTML doctype) when true, else quoted.
fn Run::write_attr(
  self : Run,
  name : String,
  value : @spec.Value,
  escape : Bool,
) -> Unit {
  match value {
    Bool(false) | Null | Undefined(_) => return
    Text("") | Markup("") if name == "class" || name == "style" => return
    Bool(true) =>
      self.out.write_string(
        if self.terse {
          " " + name
        } else {
          " " + name + "=\"" + name + "\""
        },
      )
    _ => {
      let raw = match value {
        Text(s) | Markup(s) => s
        other => js_json(other)
      }
      let string_like = value is (Text(_) | Markup(_))
      if !escape && !string_like && raw.contains("\"") {
        self.out.write_string(
          " " + name + "='" + raw.replace_all(old="'", new="&#39;") + "'",
        )
        return
      }
      let text = if escape && !(value is Markup(_)) {
        @spec.escape(raw)
      } else {
        raw
      }
      self.out.write_string(" " + name + "=\"" + text + "\"")
    }
  }
}

///|
fn Run::element(self : Run, el : @syntax.Element) -> Unit raise @spec.Refused {
  if self.extended {
    return
  }
  let tag = self.call.text(self.eval(el.tag))
  self.out.write_char('<')
  self.out.write_string(tag)
  if el.splats.is_empty() {
    let classes = []
    let others = []
    for attr in el.attrs {
      let value = match attr.value {
        Some(e) => self.eval(e)
        None => Bool(true)
      }
      if attr.name == "class" {
        classes.push((value, attr.escape))
      } else {
        others.push((attr.name, value, attr.escape))
      }
    }
    if !classes.is_empty() {
      let joined = classes
        .map(pair => {
          let c = class_text(pair.0)
          if pair.1 {
            @spec.escape(c)
          } else {
            c
          }
        })
        .filter(c => !c.is_empty())
        .join(" ")
      self.write_attr("class", Text(joined), false)
    }
    for other in others {
      let value = if other.0 == "style" {
        @spec.Value::Text(style_text(other.1))
      } else {
        other.1
      }
      self.write_attr(other.0, value, other.2)
    }
  } else {
    let merged : Map[String, @spec.Value] = Map([])
    for attr in el.attrs {
      let value = match attr.value {
        Some(e) => {
          let v = self.eval(e)
          if attr.escape && attr.name != "class" && v is Text(_) {
            @spec.Value::Text(@spec.escape(v.to_string()))
          } else {
            v
          }
        }
        None => Bool(true)
      }
      merge_attr(merged, attr.name, value)
    }
    for splat in el.splats {
      match self.eval(splat) {
        Dict(fields) =>
          for k, v in fields {
            merge_attr(merged, k, v)
          }
        Undefined(name) => raise undefined_use(name)
        v => raise @spec.invalid("&attributes takes a mapping, not \{v.kind()}")
      }
    }
    match merged.get("class") {
      Some(c) => self.write_attr("class", Text(class_text(c)), false)
      None => ()
    }
    for k, v in merged {
      if k == "class" {
        continue
      }
      let value = if k == "style" {
        @spec.Value::Text(style_text(v))
      } else {
        v
      }
      self.write_attr(k, value, false)
    }
  }
  let empty = !self.xml && void_elements.contains(tag)
  if el.self_close || empty {
    self.out.write_string(if self.terse && !el.self_close { ">" } else { "/>" })
    if el.body.iter().any(n => !(n is (Line(_) | Text(_)))) {
      raise @spec.invalid(
        "\{tag} is a self closing element: <\{tag}/> but contains nested content",
      )
    }
    return
  }
  self.out.write_char('>')
  self.run_nodes(el.body)
  self.out.write_string("</" + tag + ">")
}
