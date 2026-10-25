///|
/// Python's `json.dumps`: `", "` and `": "` between items without an
/// indent, `","` and a newline with one; non-ASCII written as `\uXXXX`.
/// Jinja's `tojson` sorts the keys, Django's `json_script` keeps their order.
fn json_dumps(
  value : @spec.Value,
  indent : Int32?,
  sort~ : Bool = true,
) -> String raise @spec.Refused {
  let out = StringBuilder()
  json_write(out, value, indent, 0, sort)
  out.to_string()
}

///|
fn json_write(
  out : StringBuilder,
  value : @spec.Value,
  indent : Int32?,
  level : Int32,
  sort : Bool,
) -> Unit raise @spec.Refused {
  match value {
    Null => out.write_string("null")
    Bool(b) => out.write_string(if b { "true" } else { "false" })
    Int(n) => out.write_string(n.to_string())
    Double(d) =>
      out.write_string(
        if d.is_nan() {
          "NaN"
        } else if d.is_pos_inf() {
          "Infinity"
        } else if d.is_neg_inf() {
          "-Infinity"
        } else {
          @spec.python_float(d)
        },
      )
    Text(s) | Markup(s) => json_string(out, s)
    Seq(items) | Tuple(items) => {
      if items.is_empty() {
        out.write_string("[]")
        return
      }
      out.write_char('[')
      for i, item in items {
        if i > 0 {
          out.write_string(if indent is None { ", " } else { "," })
        }
        json_newline(out, indent, level + 1)
        json_write(out, item, indent, level + 1, sort)
      }
      json_newline(out, indent, level)
      out.write_char(']')
    }
    Dict(fields) => {
      if fields.is_empty() {
        out.write_string("{}")
        return
      }
      let keys = fields.keys().collect()
      if sort {
        keys.sort_by((a, b) => @spec.code_point_compare(a, b))
      }
      out.write_char('{')
      for i, key in keys {
        if i > 0 {
          out.write_string(if indent is None { ", " } else { "," })
        }
        json_newline(out, indent, level + 1)
        json_string(out, key)
        out.write_string(": ")
        json_write(out, fields.get(key).unwrap(), indent, level + 1, sort)
      }
      json_newline(out, indent, level)
      out.write_char('}')
    }
    Undefined(_) | Object(_) =>
      raise @spec.invalid(
        "object of type \{value.kind()} is not JSON serializable",
      )
  }
}

///|
fn json_newline(out : StringBuilder, indent : Int32?, level : Int32) -> Unit {
  match indent {
    Some(width) => {
      out.write_char('\n')
      out.write_string(" ".repeat(width * level))
    }
    None => ()
  }
}

///|
fn json_string(out : StringBuilder, s : String) -> Unit {
  out.write_char('"')
  for i in 0..<s.length() {
    let unit = s.code_unit_at(i).to_int()
    match unit {
      '"' => out.write_string("\\\"")
      '\\' => out.write_string("\\\\")
      '\n' => out.write_string("\\n")
      '\r' => out.write_string("\\r")
      '\t' => out.write_string("\\t")
      0x08 => out.write_string("\\b")
      0x0C => out.write_string("\\f")
      u if u < 0x20 || u > 0x7E => {
        let hex = u.to_string(radix=16)
        out.write_string("\\u" + "0".repeat(4 - hex.length()) + hex)
      }
      u => out.write_char(u.unsafe_to_char())
    }
  }
  out.write_char('"')
}

///|
/// Python's `pprint.pformat` with its defaults: width 80, one space per
/// level, mapping keys sorted, long strings split into adjacent literals.
fn pformat(value : @spec.Value) -> String {
  let out = StringBuilder()
  pp(out, value, 0, 0, 1)
  out.to_string()
}

///|
/// `repr` with mapping keys sorted, the way `pprint` prints anything that
/// fits on the line.
fn safe_repr(value : @spec.Value) -> String {
  match value {
    Dict(fields) => {
      let keys = fields.keys().collect()
      keys.sort_by((a, b) => @spec.code_point_compare(a, b))
      "{" +
      keys
      .map(k => @spec.repr_text(k) + ": " + safe_repr(fields.get(k).unwrap()))
      .join(", ") +
      "}"
    }
    Seq(items) => "[" + items.map(safe_repr).join(", ") + "]"
    Tuple([one]) => "(" + safe_repr(one) + ",)"
    Tuple(items) => "(" + items.map(safe_repr).join(", ") + ")"
    other => other.repr()
  }
}

///|
fn pp(
  out : StringBuilder,
  value : @spec.Value,
  indent : Int32,
  allowance : Int32,
  level : Int32,
) -> Unit {
  let rep = safe_repr(value)
  if char_count(rep) <= 80 - indent - allowance {
    out.write_string(rep)
    return
  }
  match value {
    Dict(fields) if !fields.is_empty() => {
      out.write_char('{')
      let keys = fields.keys().collect()
      keys.sort_by((a, b) => @spec.code_point_compare(a, b))
      let inner = indent + 1
      for i, key in keys {
        let last = i == keys.length() - 1
        let krep = @spec.repr_text(key)
        out.write_string(krep)
        out.write_string(": ")
        pp(
          out,
          fields.get(key).unwrap(),
          inner + char_count(krep) + 2,
          if last {
            allowance + 1
          } else {
            1
          },
          level + 1,
        )
        if !last {
          out.write_string(",\n" + " ".repeat(inner))
        }
      }
      out.write_char('}')
    }
    Seq(items) if !items.is_empty() => {
      out.write_char('[')
      pp_items(out, items, indent, allowance + 1, level)
      out.write_char(']')
    }
    Tuple(items) if !items.is_empty() => {
      let end = if items.length() == 1 { ",)" } else { ")" }
      out.write_char('(')
      pp_items(out, items, indent, allowance + end.length(), level)
      out.write_string(end)
    }
    Text(s) if !s.is_empty() => pp_string(out, s, indent, allowance, level)
    _ => out.write_string(rep)
  }
}

///|
fn pp_items(
  out : StringBuilder,
  items : Array[@spec.Value],
  indent : Int32,
  allowance : Int32,
  level : Int32,
) -> Unit {
  let inner = indent + 1
  for i, item in items {
    let last = i == items.length() - 1
    if i > 0 {
      out.write_string(",\n" + " ".repeat(inner))
    }
    pp(out, item, inner, if last { allowance } else { 1 }, level + 1)
  }
}

///|
fn pp_string(
  out : StringBuilder,
  s : String,
  indent : Int32,
  allowance : Int32,
  level : Int32,
) -> Unit {
  let lines = py_splitlines(s, true)
  let (indent, allowance) = if level == 1 {
    (indent + 1, allowance + 1)
  } else {
    (indent, allowance)
  }
  let max_width = 80 - indent
  let chunks = []
  for i, line in lines {
    let rep = @spec.repr_text(line)
    let width1 = if i == lines.length() - 1 {
      max_width - allowance
    } else {
      max_width
    }
    if char_count(rep) <= width1 {
      chunks.push(rep)
      continue
    }
    let parts = space_parts(line)
    let mut current = ""
    for j, part in parts {
      let candidate = current + part
      let width2 = if j == parts.length() - 1 && i == lines.length() - 1 {
        max_width - allowance
      } else {
        max_width
      }
      if char_count(@spec.repr_text(candidate)) > width2 {
        if !current.is_empty() {
          chunks.push(@spec.repr_text(current))
        }
        current = part
      } else {
        current = candidate
      }
    }
    if !current.is_empty() {
      chunks.push(@spec.repr_text(current))
    }
  }
  if chunks.length() == 1 {
    out.write_string(chunks[0])
    return
  }
  if level == 1 {
    out.write_char('(')
  }
  for i, chunk in chunks {
    if i > 0 {
      out.write_string("\n" + " ".repeat(indent))
    }
    out.write_string(chunk)
  }
  if level == 1 {
    out.write_char(')')
  }
}

///|
/// `re.findall(r'\S*\s*', line)` without its empty last match.
fn space_parts(line : String) -> Array[String] {
  let parts = []
  let current = StringBuilder()
  let mut in_space = false
  for ch in line {
    let space = is_space(ch)
    if !space && in_space {
      parts.push(current.to_string())
      current.reset()
    }
    in_space = space
    current.write_char(ch)
  }
  if !current.is_empty() {
    parts.push(current.to_string())
  }
  parts
}
