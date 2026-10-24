// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// Text made safe for element bodies and attribute values: the five
/// characters HTML marks (`&`, `<`, `>`, and both quotes), the whole of the
/// escaping story — a template engine that wrote markup by parsing it would be
/// doing the work twice.
fn escape_text(text : String) -> String {
  let mut needs = false
  for i = 0; i < text.length(); i = i + 1 {
    match text.at(i) {
      0x26 | 0x3C | 0x3E | 0x22 | 0x27 => {
        needs = true
        break
      }
      _ => ()
    }
  }
  if !needs {
    return text
  }
  let out = StringBuilder()
  for i = 0; i < text.length(); i = i + 1 {
    match text.at(i) {
      0x26 => out.write_string("&amp;")
      0x3C => out.write_string("&lt;")
      0x3E => out.write_string("&gt;")
      0x22 => out.write_string("&quot;")
      0x27 => out.write_string("&#39;")
      _ => out.write_char(u16_char(text.at(i)))
    }
  }
  out.to_string()
}

///|
/// The elements HTML leaves open on purpose (HTML Standard §4; SVG's handful
/// rides along). They take no closing tag, whatever the indentation surface
/// would otherwise emit.
fn is_void_element(tag : String) -> Bool {
  match tag {
    "area"
    | "base"
    | "br"
    | "col"
    | "command"
    | "embed"
    | "hr"
    | "img"
    | "input"
    | "keygen"
    | "link"
    | "meta"
    | "param"
    | "source"
    | "track"
    | "wbr"
    | "circle"
    | "ellipse"
    | "line"
    | "path"
    | "polygon"
    | "polyline"
    | "rect"
    | "stop"
    | "use" => true
    _ => false
  }
}

///|
/// The doctype shorthands Pug spells and the documents they name.
fn doctype_of(name : String) -> String {
  match name {
    "5" | "html" => "<!DOCTYPE html>"
    "xml" => "<?xml version=\"1.0\" encoding=\"utf-8\" ?>"
    "transitional" =>
      "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
    "strict" =>
      "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"
    "frameset" =>
      "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Frameset//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd\">"
    "basic" =>
      "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML Basic 1.1//EN\" \"http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd\">"
    "1.1" =>
      "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">"
    "mobile" =>
      "<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.2//EN\" \"http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd\">"
    other => "<!\{other}>"
  }
}
