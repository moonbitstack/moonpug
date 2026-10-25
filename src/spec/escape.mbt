///|
/// Text made safe for HTML and XML, element bodies and quoted attributes
/// alike: the five characters markupsafe replaces, written the way it does.
pub fn escape(text : String) -> String {
  if !text.iter().any(ch => ch is ('&' | '<' | '>' | '"' | '\'')) {
    return text
  }
  let out = StringBuilder()
  for ch in text {
    match ch {
      '&' => out.write_string("&amp;")
      '<' => out.write_string("&lt;")
      '>' => out.write_string("&gt;")
      '"' => out.write_string("&#34;")
      '\'' => out.write_string("&#39;")
      c => out.write_char(c)
    }
  }
  out.to_string()
}

///|
/// A value as markup: safe text as it stands, anything else printed and
/// escaped.
pub fn Value::markup(self : Value) -> String {
  match self {
    Markup(s) => s
    _ => escape(self.to_string())
  }
}
