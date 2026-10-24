// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// One filter applied: the value on the left, the arguments in Jinja's
/// spelling — positional first, named after. Unknown names are refused, not
/// guessed at, the way a vocabulary must be.
fn apply_filter(
  ctx : Context,
  name : String,
  input : Value,
  pos : Array[Value],
  kw : Map[String, Value],
) -> Value raise Fault {
  match name {
    "abs" =>
      match input {
        Int(n) => Int(if n < 0L { 0L - n } else { n })
        Double(d) => Double(d.abs())
        _ => raise Wrong(because="abs wants a number")
      }
    "attr" => {
      let field = arg_text(pos, kw, 0, None, "attr")
      match input {
        Dict(fields) =>
          match fields.get(field) {
            Some(value) => value
            None => Absent(field)
          }
        _ => Absent(field)
      }
    }
    "batch" => {
      let size = arg_int(pos, kw, 0, None, "batch")
      let fill = match kw.get("fill_with") {
        Some(filler) => Some(filler)
        None => if 1 < pos.length() { Some(pos[1]) } else { None }
      }
      let items = as_list(input, "batch")
      let out = []
      let mut i = 0
      while i < items.length() {
        let part = []
        let mut j = i
        while j < i + size && j < items.length() {
          part.push(items[j])
          j = j + 1
        }
        match fill {
          Some(filler) =>
            while part.length() < size {
              part.push(filler)
            }
          None => ()
        }
        out.push(Seq(part))
        i = i + size
      }
      Seq(out)
    }
    "capitalize" => {
      let s = as_text(input, "capitalize")
      if s.is_empty() {
        Text(s)
      } else {
        Text(head_upper(s))
      }
    }
    "center" => {
      let width = arg_int(pos, kw, 0, Some(80), "center")
      let s = as_text(input, "center")
      if s.length() >= width {
        return Text(s)
      }
      let pad = width - s.length()
      let left = pad / 2
      let right = pad - left
      Text(" ".repeat(left) + s + " ".repeat(right))
    }
    "default" => {
      let fallback = arg_at(pos, 0, Text(""))
      let when_falsy = kw.get_or_default("boolean", Bool(false)) is Bool(true)
      let absent = match input {
        Absent(_) => true
        _ => when_falsy && !truthy(input)
      }
      if absent {
        fallback
      } else {
        input
      }
    }
    "dictsort" => {
      let by_value = kw.get_or_default("by", Text("key")) is Text("value")
      let case_sensitive = kw.get_or_default("case_sensitive", Bool(false))
        is Bool(true)
      let reverse = kw.get_or_default("reverse", Bool(false)) is Bool(true)
      let fields = as_map(input, "dictsort")
      let pairs = []
      for key in sorted_keys(fields) {
        pairs.push((Value::Text(key), fields.get_or_default(key, Null)))
      }
      let key_of = fn(pair : (Value, Value)) -> Value {
        if by_value {
          pair.1
        } else {
          pair.0
        }
      }
      let sort_key = fn(pair : (Value, Value)) -> Value {
        let k = key_of(pair)
        if !case_sensitive {
          match k {
            Text(s) | Markup(s) => Text(s.to_lower())
            other => other
          }
        } else {
          k
        }
      }
      pairs.sort_by(fn(a, b) {
        compare_value(sort_key(a), sort_key(b)) catch {
          _ => 0
        }
      })
      if reverse {
        rev_in_place(pairs)
      }
      let out = []
      for pair in pairs {
        out.push(Seq([pair.0, pair.1]))
      }
      Seq(out)
    }
    "escape" | "e" =>
      match input {
        Markup(s) => Markup(s)
        _ => Markup(escape_text(show_value(input)))
      }
    "filesizeformat" => {
      let bytes = as_double(input, "filesizeformat")
      filesize(bytes)
    }
    "first" =>
      match input {
        Seq(items) =>
          if items.is_empty() {
            Absent("empty list")
          } else {
            items[0]
          }
        Text(s) | Markup(s) =>
          if s.is_empty() {
            Absent("empty string")
          } else {
            Text(s[0:1].to_owned())
          }
        _ => raise Wrong(because="first wants a list or text")
      }
    "float" => {
      let fallback = match arg_at(pos, 0, Double(0.0)) {
        Double(d) => d
        Int(n) => n.to_double()
        Text(s) => @string.parse_double(s) catch { _ => 0.0 }
        _ => 0.0
      }
      match input {
        Double(d) => Double(d)
        Int(n) => Double(n.to_double())
        Text(s) | Markup(s) =>
          Double(@string.parse_double(s)) catch {
            _ => Double(fallback)
          }
        _ => Double(fallback)
      }
    }
    "forceescape" => Markup(escape_text(show_value(input)))
    "format" => format_printf(as_text(input, "format"), pos, kw)
    "groupby" => {
      let field = arg_text(pos, kw, 0, None, "groupby")
      let items = as_list(input, "groupby")
      let groups : Array[(String, Array[Value])] = []
      for item in items {
        let key = show_value(pluck(item, field))
        let mut placed = false
        for group in groups {
          if group.0 == key {
            group.1.push(item)
            placed = true
            break
          }
        }
        if !placed {
          groups.push((key, [item]))
        }
      }
      // Jinja's groupby hands the groups back sorted by their key.
      groups.sort_by(fn(a, b) { a.0.compare(b.0) })
      let out = []
      for group in groups {
        let dict : Map[String, Value] = Map([])
        dict.set("grouper", Value::Text(group.0))
        dict.set("list", Seq(group.1))
        out.push(Dict(dict))
      }
      Seq(out)
    }
    "indent" => {
      let width = arg_int(pos, kw, 0, Some(4), "indent")
      let first_line = kw.get_or_default("first", Bool(false)) is Bool(true)
      let blank = kw.get_or_default("blank", Bool(false)) is Bool(true)
      let s = as_text(input, "indent")
      let pad = " ".repeat(width)
      let newline = if blank { "\n\{pad}" } else { "\n\{pad}" }
      let parts = s.split("\n").to_array()
      let out = []
      for i = 0; i < parts.length(); i = i + 1 {
        if (i == 0 && !first_line) || parts[i].is_empty() {
          out.push(parts[i].to_owned())
        } else {
          out.push(pad + parts[i].to_owned())
        }
      }
      ignore(newline)
      Text(join_texts(out, "\n"))
    }
    "int" => {
      let fallback = match arg_at(pos, 0, Int(0L)) {
        Int(n) => n
        _ => 0L
      }
      let base = arg_int(pos, kw, 1, Some(10), "int")
      match input {
        Int(n) => Int(n)
        Double(d) => Int(@double.trunc(d).to_int64())
        Bool(b) => Int(if b { 1L } else { 0L })
        Text(s) | Markup(s) =>
          Int(@string.parse_int64(s, base~)) catch {
            _ => Int(fallback)
          }
        _ => Int(fallback)
      }
    }
    "items" => {
      let fields = as_map(input, "items")
      let out = []
      for key in sorted_keys(fields) {
        out.push(Seq([Text(key), fields.get_or_default(key, Null)]))
      }
      Seq(out)
    }
    "join" => {
      let sep = arg_text(pos, kw, 0, Some(""), "join")
      let field = kw.get("attribute")
      let parts = []
      for item in as_list(input, "join") {
        let piece = match field {
          Some(f) => pluck(item, as_string_view(f))
          None => item
        }
        parts.push(show_value(piece))
      }
      Text(join_texts(parts, sep))
    }
    "last" =>
      match input {
        Seq(items) =>
          if items.is_empty() {
            Absent("empty list")
          } else {
            items[items.length() - 1]
          }
        Text(s) | Markup(s) =>
          if s.is_empty() {
            Absent("empty string")
          } else {
            Text(s[s.length() - 1:s.length()].to_owned())
          }
        _ => raise Wrong(because="last wants a list or text")
      }
    "length" | "count" => Int(length_of(input, name).to_int64())
    "list" => Seq(materialise(input))
    "lower" => Text(as_text(input, "lower").to_lower())
    "map" => {
      let items = as_list(input, "map")
      let field = kw.get("attribute")
      let fallback = kw.get("default")
      match arg_at(pos, 0, Absent("none")) {
        Absent(_) => {
          let out = []
          for item in items {
            match field {
              Some(f) => {
                let picked = pluck(item, as_string_view(f))
                out.push(picked)
              }
              None => out.push(item)
            }
          }
          Seq(out)
        }
        Text(filter_name) => {
          let out = []
          for item in items {
            let picked = match field {
              Some(f) => {
                let value = pluck(item, as_string_view(f))
                match fallback {
                  Some(_) => value
                  None => value
                }
              }
              None => item
            }
            out.push(
              match ctx.filters.get(filter_name) {
                Some(found) => found.filter(ctx, picked, [], {})
                None => raise Unknown(name=filter_name, kind="filter")
              },
            )
          }
          Seq(out)
        }
        _ => raise Wrong(because="map wants a filter name or attribute")
      }
    }
    "max" | "min" => {
      let items = as_list(input, name)
      if items.is_empty() {
        return Absent(name)
      }
      let field = kw.get("attribute")
      let mut best = items[0]
      let mut best_key = sort_key_of(items[0], field)
      for i = 1; i < items.length(); i = i + 1 {
        let key = sort_key_of(items[i], field)
        let step = compare_value(key, best_key)
        if (name == "max" && step > 0) || (name == "min" && step < 0) {
          best = items[i]
          best_key = key
        }
      }
      best
    }
    "pprint" => Text(repr_value(input))
    "random" => {
      let items = as_list(input, "random")
      if items.is_empty() {
        return Absent("empty list")
      }
      // Deterministic per render and per call, reproducible across renders:
      // a template that renders twice gives the same page twice.
      ctx.tally.n = ctx.tally.n + 1
      let seed : Int64 = ctx.tally.n.to_int64() * 2654435761L +
        items.length().to_int64()
      let index = (seed % items.length().to_int64()).to_int()
      items[index]
    }
    "reject" | "select" => {
      let keep = name == "select"
      let test_name = arg_text(pos, kw, 0, None, name)
      let rest = pos.copy()
      ignore(rest.remove(0))
      let fallback : BuiltinTest = { name: "true", }
      let probe = ctx.tests.get_or_default(test_name, fallback)
      let out = []
      for item in as_list(input, name) {
        let passes = probe.probe(item, rest)
        if passes == keep {
          out.push(item)
        }
      }
      Seq(out)
    }
    "rejectattr" | "selectattr" => {
      let keep = name == "selectattr"
      let field = arg_text(pos, kw, 0, None, name)
      let test_name = arg_text(pos, kw, 1, Some("true"), name)
      // The tail after the attribute and (maybe) the test name goes to the
      // test as its own arguments.
      let rest = pos.copy()
      let heads = if 1 < rest.length() { 2 } else { 1 }
      for _k = 0; _k < heads; _k = _k + 1 {
        ignore(rest.remove(0))
      }
      match ctx.tests.get(test_name) {
        None => raise Unknown(name=test_name, kind="test")
        Some(probe) => {
          let out = []
          for item in as_list(input, name) {
            let passes = probe.probe(pluck(item, field), rest)
            if passes == keep {
              out.push(item)
            }
          }
          Seq(out)
        }
      }
    }
    "replace" => {
      let old = arg_text(pos, kw, 0, None, "replace")
      let new = arg_text(pos, kw, 1, Some(""), "replace")
      let s = as_text(input, "replace")
      let count = arg_int(pos, kw, 2, Some(-1), "replace")
      if count < 0 {
        Text(s.replace_all(old~, new~))
      } else {
        Text(replace_first_n(s, old, new, count))
      }
    }
    "reverse" =>
      match input {
        Seq(items) => {
          let out = items.copy()
          rev_in_place(out)
          Seq(out)
        }
        Text(s) | Markup(s) => Text(s.rev())
        _ => raise Wrong(because="reverse wants a list or text")
      }
    "round" => {
      let precision = arg_int(pos, kw, 0, Some(0), "round")
      let mode = arg_text(pos, kw, 1, Some("common"), "round")
      let d = as_double(input, "round")
      let scaled = d * @math.pow(10.0, precision.to_double())
      let rounded = match mode {
        "ceil" => @double.ceil(scaled)
        "floor" => @double.floor(scaled)
        _ => {
          let half = @double.floor(scaled + 0.5)
          // Python's round: half to even; the common method rounds half away.
          half
        }
      }
      let back = rounded / @math.pow(10.0, precision.to_double())
      if precision <= 0 {
        Int(back.to_int64())
      } else {
        Double(back)
      }
    }
    "safe" => Markup(as_text(input, "safe"))
    "slice" => {
      let parts = arg_int(pos, kw, 0, None, "slice")
      let fill = match kw.get("fill_with") {
        Some(filler) => Some(filler)
        None => if 1 < pos.length() { Some(pos[1]) } else { None }
      }
      let items = as_list(input, "slice")
      let n = items.length()
      let base = n / parts
      let extra = n % parts
      let out = []
      let mut at = 0
      for i = 0; i < parts; i = i + 1 {
        let take = base + (if i < extra { 1 } else { 0 })
        let column = []
        for j = at; j < at + take && j < n; j = j + 1 {
          column.push(items[j])
        }
        match fill {
          Some(filler) =>
            if i >= extra && column.is_empty() {
              column.push(filler)
            }
          None => ()
        }
        out.push(Seq(column))
        at = at + take
      }
      Seq(out)
    }
    "sort" => {
      let reverse = kw.get_or_default("reverse", Bool(false)) is Bool(true)
      let case_sensitive = kw.get_or_default("case_sensitive", Bool(false))
        is Bool(true)
      let field = kw.get("attribute")
      let items = as_list(input, "sort").copy()
      items.sort_by(fn(a, b) {
        cmp_or_equal((a, field, case_sensitive), (b, field, case_sensitive), (
          l,
          r,
        ) => {
          compare_value(
            sort_key_for(sort_key_of(l.0, l.1), l.2),
            sort_key_for(sort_key_of(r.0, r.1), r.2),
          )
        })
      })
      if reverse {
        let items = reverse_in_place(items)
        ignore(items)
      }
      Seq(items)
    }
    "string" => Text(show_value(input))
    "striptags" => {
      let stripped = strip_tags(as_text(input, "striptags"))
      Text(collapse_space(stripped.trim()))
    }
    "sum" => {
      let field = kw.get("attribute")
      let start = kw.get_or_default("start", Int(0L))
      let mut total : Value = start
      for item in as_list(input, "sum") {
        let value = match field {
          Some(f) => pluck(item, as_string_view(f))
          None => item
        }
        total = arith(Add, total, value)
      }
      total
    }
    "title" => {
      let s = as_text(input, "title")
      Text(title_case(s))
    }
    "tojson" => {
      let indent = kw.get("indent")
      let text = match indent {
        Some(Int(n)) => to_json(input).stringify(indent=n.to_int())
        _ => to_json(input).stringify()
      }
      Markup(
        text
        .replace_all(old="<", new="\\u003c")
        .replace_all(old=">", new="\\u003e")
        .replace_all(old="&", new="\\u0026"),
      )
    }
    "trim" => {
      let chars = kw.get("chars")
      let s = as_text(input, "trim")
      Text(
        match chars {
          Some(set) => s.trim(chars=as_string_view(set)).to_owned()
          None => s.trim().to_owned()
        },
      )
    }
    "truncate" => {
      // Jinja's order: length, killwords, end, leeway.
      let limit = arg_int(pos, kw, 0, Some(255), "truncate")
      let killwords = match pos.get(1) {
        Some(Bool(b)) => b
        Some(_) => false
        None => kw.get_or_default("killwords", Bool(false)) is Bool(true)
      }
      let end = match pos.get(2) {
        Some(Text(e)) | Some(Markup(e)) => e
        Some(_) => "..."
        None =>
          match kw.get("end") {
            Some(Text(e)) | Some(Markup(e)) => e
            _ => "..."
          }
      }
      let leeway = arg_int(pos, kw, 3, Some(5), "truncate")
      let s = as_text(input, "truncate")
      if limit < 0 {
        return Text(s)
      }
      if s.length() <= limit + leeway {
        return Text(s)
      }
      let hard = limit - end.length()
      if hard < 0 {
        return Text(end)
      }
      if killwords {
        Text(s[0:hard].to_owned() + end)
      } else {
        let cut = s[0:hard]
        let spot = match cut.rev_find(" ") {
          Some(at) => at
          None => hard
        }
        // The boundary keeps its space, so the end does not glue to the word.
        Text(cut[0:spot + 1].to_owned() + end)
      }
    }
    "unique" => {
      let case_sensitive = kw.get_or_default("case_sensitive", Bool(false))
        is Bool(true)
      let field = kw.get("attribute")
      let seen : Array[Value] = []
      let out = []
      for item in as_list(input, "unique") {
        let key = sort_key_for(sort_key_of(item, field), case_sensitive)
        let mut known = false
        for before in seen {
          if same_value(before, key) {
            known = true
            break
          }
        }
        if !known {
          seen.push(key)
          out.push(item)
        }
      }
      Seq(out)
    }
    "upper" => Text(as_text(input, "upper").to_upper())
    "urlencode" =>
      match input {
        Dict(fields) => {
          let parts = []
          for key in sorted_keys(fields) {
            let value = fields.get_or_default(key, Null)
            parts.push(
              percent_encode(key) + "=" + percent_encode(show_value(value)),
            )
          }
          Text(join_texts(parts, "&"))
        }
        _ => Text(percent_encode(as_text(input, "urlencode")))
      }
    "urlize" =>
      urlize(
        as_text(input, "urlize"),
        kw.get_or_default("trim_url_limit", Absent("none")),
        kw.get_or_default("nofollow", Bool(false)) is Bool(true),
      )
    "wordcount" => Int(count_words(as_text(input, "wordcount")).to_int64())
    "wordwrap" => {
      let width = arg_int(pos, kw, 0, Some(79), "wordwrap")
      let wrap_string = kw.get_or_default("wrapstring", Text("\n"))
      Text(
        word_wrap(
          as_text(input, "wordwrap"),
          width,
          as_string_view(wrap_string),
        ),
      )
    }
    "xmlattr" => {
      let autospace = kw.get_or_default("autospace", Bool(true)) is Bool(true)
      let fields = as_map(input, "xmlattr")
      let parts = []
      for key in sorted_keys(fields) {
        let value = fields.get_or_default(key, Null)
        match value {
          Null | Absent(_) | Bool(false) => ()
          _ => parts.push("\{key}=\"\{escape_text(show_value(value))}\"")
        }
      }
      if autospace && !parts.is_empty() {
        Markup(" " + join_texts(parts, " "))
      } else {
        Markup(join_texts(parts, " "))
      }
    }
    other => django_filter(ctx, other, input, pos, kw)
  }
}

///|
/// Pull one positional argument, or the named one it answers to.
fn arg_at(pos : Array[Value], i : Int32, fallback : Value) -> Value {
  if i < pos.length() {
    pos[i]
  } else {
    fallback
  }
}

///|
fn arg_text(
  pos : Array[Value],
  _kw : Map[String, Value],
  i : Int32,
  fallback : String?,
  filter_name : String,
) -> String raise Fault {
  if i < pos.length() {
    return as_text(pos[i], filter_name)
  }
  match fallback {
    Some(s) => s
    None => raise Wrong(because="\{filter_name} is missing an argument")
  }
}

///|
fn arg_int(
  pos : Array[Value],
  _kw : Map[String, Value],
  i : Int32,
  fallback : Int32?,
  filter_name : String,
) -> Int32 raise Fault {
  let raw = if i < pos.length() { Some(pos[i]) } else { None }
  match raw {
    Some(Int(n)) => n.to_int()
    Some(Double(d)) => d.to_int()
    Some(Text(s)) =>
      @string.parse_int(s) catch {
        _ => raise Wrong(because="\{filter_name} wanted a number")
      }
    _ =>
      match fallback {
        Some(v) => v
        None => raise Wrong(because="\{filter_name} is missing an argument")
      }
  }
}

///|
fn as_text(value : Value, filter_name : String) -> String raise Fault {
  match value {
    Text(s) | Markup(s) => s
    _ => raise Wrong(because="\{filter_name} wants text, not \{kind_of(value)}")
  }
}

///|
fn as_string_view(value : Value) -> StringView {
  match value {
    Text(s) | Markup(s) => s[:]
    _ => ""
  }
}

///|
fn as_list(value : Value, filter_name : String) -> Array[Value] raise Fault {
  match value {
    Seq(items) => items
    _ =>
      raise Wrong(because="\{filter_name} wants a list, not \{kind_of(value)}")
  }
}

///|
fn as_map(
  value : Value,
  filter_name : String,
) -> Map[String, Value] raise Fault {
  match value {
    Dict(fields) => fields
    _ =>
      raise Wrong(
        because="\{filter_name} wants a mapping, not \{kind_of(value)}",
      )
  }
}

///|
fn as_double(value : Value, filter_name : String) -> Double raise Fault {
  match value {
    Int(n) => n.to_double()
    Double(d) => d
    _ => raise Wrong(because="\{filter_name} wants a number")
  }
}

///|
fn length_of(value : Value, filter_name : String) -> Int32 raise Fault {
  match value {
    Seq(items) => items.length()
    Dict(fields) => fields.length()
    Text(s) | Markup(s) => s.length()
    _ =>
      raise Wrong(
        because="\{filter_name} wants something with a length, not \{kind_of(value)}",
      )
  }
}

///|
/// An attribute or key off an item: `attribute='name'`, dotted as in `a.b`.
fn pluck(item : Value, field : StringView) -> Value {
  let mut current = item
  let part = StringBuilder()
  for i = 0; i < field.length(); i = i + 1 {
    let unit = field.at(i)
    if unit == 0x2E {
      current = pluck_once(current, part.to_string())
      part.reset()
    } else {
      part.write_char(u16_char(unit))
    }
  }
  pluck_once(current, part.to_string())
}

///|
fn pluck_once(item : Value, field : StringView) -> Value {
  if field.is_empty() {
    return item
  }
  let name = field.to_owned()
  match item {
    Dict(fields) =>
      match fields.get(name) {
        Some(value) => value
        None => Absent(field.to_owned())
      }
    Namespaced(fields) =>
      match fields.get(name) {
        Some(value) => value
        None => Absent(field.to_owned())
      }
    Seq(items) => {
      let index : Int32? = Some(@string.parse_int(field)) catch { _ => None }
      match index {
        Some(at) => {
          let n = items.length()
          let fixed = if at < 0 { at + n } else { at }
          if fixed >= 0 && fixed < n {
            items[fixed]
          } else {
            Absent(field.to_owned())
          }
        }
        None => Absent(field.to_owned())
      }
    }
    _ => Absent(name)
  }
}

///|
fn sort_key_of(item : Value, field : Value?) -> Value {
  match field {
    Some(f) => pluck(item, as_string_view(f))
    None => item
  }
}

///|
fn sort_key_for(key : Value, case_sensitive : Bool) -> Value {
  if case_sensitive {
    return key
  }
  match key {
    Text(s) | Markup(s) => Text(s.to_lower())
    other => other
  }
}

///|
fn head_upper(s : String) -> String {
  let head = s[0:1]
  let rest = s[1:s.length()]
  head.to_owned().to_upper() + rest.to_owned().to_lower()
}

///|
fn title_case(s : String) -> String {
  let out = StringBuilder()
  let mut boundary = true
  for ch in s {
    if boundary && is_word_char(ch) {
      out.write_char(char_upper(ch))
      boundary = false
    } else if is_word_char(ch) {
      out.write_char(char_lower(ch))
    } else {
      out.write_char(ch)
      boundary = true
    }
  }
  out.to_string()
}

///|
fn count_words(s : String) -> Int32 {
  let mut count = 0
  let mut in_word = false
  for ch in s {
    if is_word_char(ch) {
      if !in_word {
        count = count + 1
        in_word = true
      }
    } else {
      in_word = false
    }
  }
  count
}

///|
fn replace_first_n(
  s : String,
  old : String,
  new : String,
  count : Int32,
) -> String {
  if old.is_empty() || count == 0 {
    return s
  }
  let out = StringBuilder()
  let mut i = 0
  let mut done = 0
  while i < s.length() {
    if done < count && s[i:i + old.length()] == old {
      out.write_string(new)
      i = i + old.length()
      done = done + 1
    } else {
      out.write_string(s[i:i + 1].to_owned())
      i = i + 1
    }
  }
  out.to_string()
}

///|
fn strip_tags(s : String) -> String {
  let out = StringBuilder()
  let mut inside = false
  let mut quote : UInt16 = 0
  for i = 0; i < s.length(); i = i + 1 {
    let unit = s.at(i)
    if !inside && unit == 0x3C {
      inside = true
    } else if inside {
      if quote != 0 {
        if unit == quote {
          quote = 0
        }
      } else if unit == 0x22 || unit == 0x27 {
        quote = unit
      } else if unit == 0x3E {
        inside = false
        out.write_char(' ')
      }
    } else {
      out.write_char(u16_char(unit))
    }
  }
  out.to_string()
}

///|
fn word_wrap(s : String, width : Int32, wrap_string : StringView) -> String {
  let out = StringBuilder()
  let mut line = 0
  for word in s.split(" ") {
    let w = word.length()
    if line > 0 && line + 1 + w > width {
      out.write_string(wrap_string.to_owned())
      line = 0
    } else if line > 0 {
      out.write_char(' ')
      line = line + 1
    }
    out.write_string(word.to_owned())
    line = line + w
  }
  out.to_string()
}

///|
fn filesize(bytes : Double) -> Value {
  let base = 1000.0
  let units = ["kB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"]
  if bytes < base {
    if bytes == 1.0 {
      return Text("1 Byte")
    }
    return Text("\{@double.trunc(bytes)} Bytes")
  }
  let mut size = bytes
  let mut unit = ""
  let mut i = 0
  while i < units.length() {
    size = size / base
    unit = units[i]
    if size < base {
      break
    }
    i = i + 1
  }
  Text("\{show_double(@double.round(size * 10.0) / 10.0)} \{unit}")
}

///|
fn percent_encode(s : String) -> String {
  let unreserved = fn(unit : UInt16) -> Bool {
    (unit >= 0x41 && unit <= 0x5A) ||
    (unit >= 0x61 && unit <= 0x7A) ||
    (unit >= 0x30 && unit <= 0x39) ||
    unit == 0x2D ||
    unit == 0x2E ||
    unit == 0x5F ||
    unit == 0x7E
  }
  fn hex_byte(b : Int32) -> String {
    let hex = "0123456789ABCDEF"
    u16_char(hex.at(b / 16 % 16)).to_string() +
    u16_char(hex.at(b % 16)).to_string()
  }
  // A code point goes out as one %XX per UTF-8 byte.
  fn escape_codepoint(cp : Int32) -> String {
    if cp < 0x80 {
      return "%" + hex_byte(cp)
    }
    let out = StringBuilder()
    let bytes : Array[Int32] = if cp < 0x800 {
      [0xC0 + cp / 64, 0x80 + cp % 64]
    } else if cp < 0x10000 {
      [0xE0 + cp / 4096, 0x80 + cp / 64 % 64, 0x80 + cp % 64]
    } else {
      [
        0xF0 + cp / 262144,
        0x80 + cp / 4096 % 64,
        0x80 + cp / 64 % 64,
        0x80 + cp % 64,
      ]
    }
    for b in bytes {
      out.write_string("%" + hex_byte(b))
    }
    out.to_string()
  }
  let out = StringBuilder()
  for ch in s {
    let cp = ch.to_int()
    if cp < 0x80 && unreserved(cp.to_uint16()) {
      out.write_char(ch)
    } else {
      out.write_string(escape_codepoint(cp))
    }
  }
  out.to_string()
}

///|
/// Python's %-style formatting, `"%s - %s"|format(a, b)` and the named
/// `%(key)s` spelling.
fn format_printf(
  pattern : String,
  pos : Array[Value],
  kw : Map[String, Value],
) -> Value raise Fault {
  let out = StringBuilder()
  let n = pattern.length()
  let mut i = 0
  let mut next = 0
  while i < n {
    let unit = pattern.at(i)
    if unit != 0x25 {
      out.write_char(u16_char(unit))
      i = i + 1
      continue
    }
    i = i + 1
    if i >= n {
      out.write_char('%')
      break
    }
    if pattern.at(i) == 0x25 {
      out.write_char('%')
      i = i + 1
      continue
    }
    // An optional mapping key.
    let value : Value = if pattern.at(i) == 0x28 {
      let close = find_from(pattern, ")", 0)
      match close {
        Some(at) => {
          let key = pattern[i + 1:at]
          i = at + 1
          match kw.get(key.to_owned()) {
            Some(v) => v
            None => raise Wrong(because="format has no \{key}")
          }
        }
        None => raise Wrong(because="format key is unterminated")
      }
    } else {
      let v = if next < pos.length() {
        pos[next]
      } else {
        raise Wrong(because="format has more placeholders than values")
      }
      next = next + 1
      v
    }
    // Flags and a width: the zero flag pads the number to the width.
    let mut pad_zero = false
    let mut width = 0
    let mut seen_width = false
    while i < n &&
          (
            pattern.at(i) == 0x2D ||
            pattern.at(i) == 0x2B ||
            pattern.at(i) == 0x30 ||
            pattern.at(i) == 0x20
          ) {
      if pattern.at(i) == 0x30 {
        pad_zero = true
      }
      i = i + 1
    }
    while i < n && is_digit(pattern.at(i)) {
      width = width * 10 + pattern.at(i).to_int() - 0x30
      seen_width = true
      i = i + 1
    }
    fn pad(plain : String) -> String {
      if seen_width && pad_zero && plain.length() < width {
        let missing = width - plain.length()
        let sign = if plain.has_prefix("-") { "-" } else { "" }
        let digits = if plain.has_prefix("-") {
          plain[1:plain.length()].to_owned()
        } else {
          plain
        }
        sign + "0".repeat(missing) + digits
      } else {
        plain
      }
    }
    if i < n && pattern.at(i) == 0x2E {
      i = i + 1
      while i < n && is_digit(pattern.at(i)) {
        i = i + 1
      }
    }
    if i >= n {
      break
    }
    let verb = pattern.at(i)
    i = i + 1
    match verb {
      0x73 => out.write_string(show_value(value)) // s
      0x72 => out.write_string(repr_value(value)) // r
      0x64 | 0x69 => out.write_string(pad(int_text(value))) // d, i
      0x66 => out.write_string(pad(show_double(as_double(value, "format")))) // f
      0x78 => out.write_string(int_radix(value, 16, false)) // x
      0x58 => out.write_string(int_radix(value, 16, true)) // X
      0x6F => out.write_string(int_radix(value, 8, false)) // o
      0x65 | 0x45 | 0x67 | 0x47 =>
        out.write_string(as_double(value, "format").to_string())
      0x63 => out.write_string(show_value(value)[0:1].to_owned()) // c
      _ => raise Wrong(because="format does not know this verb")
    }
  }
  Text(out.to_string())
}

///|
fn int_text(value : Value) -> String {
  match value {
    Int(n) => n.to_string()
    Double(d) => @double.trunc(d).to_int64().to_string()
    other => show_value(other)
  }
}

///|
fn int_radix(value : Value, radix : Int32, upper : Bool) -> String {
  let n = match value {
    Int(v) => v
    Double(d) => @double.trunc(d).to_int64()
    other => @string.parse_int64(show_value(other)) catch { _ => 0L }
  }
  let text = n.to_string(radix~)
  if upper {
    text.to_upper()
  } else {
    text
  }
}

///|
/// Linkify plain text: bare http(s) and www addresses become anchors. A
/// modest, honest subset of Jinja's `urlize`.
fn urlize(value : String, limit : Value, nofollow : Bool) -> Value {
  let max = match limit {
    Int(n) => n.to_int()
    _ => -1
  }
  // Split between whitespace runs - one blank or many, space or tab - so
  // the prose around a link survives verbatim.
  let words : Array[String] = []
  let run = StringBuilder()
  fn flush() -> Unit {
    if !run.is_empty() {
      let piece = run.to_string()
      run.reset()
      if piece.has_prefix("http://") ||
        piece.has_prefix("https://") ||
        piece.has_prefix("www.") {
        let shown = if max > 0 && piece.length() > max {
          piece[0:max] + "…"
        } else {
          piece
        }
        let href = if piece.has_prefix("www.") {
          "http://\{piece}"
        } else {
          piece
        }
        let rel = if nofollow { " rel=\"nofollow\"" } else { "" }
        words.push(
          "<a href=\"" +
          href +
          "\"" +
          rel +
          ">" +
          escape_text(shown.to_owned()) +
          "</a>",
        )
      } else {
        words.push(piece)
      }
    }
  }
  for ch in value {
    if ch.is_ascii_whitespace() {
      flush()
      words.push(ch.to_string())
    } else {
      run.write_char(ch)
    }
  }
  flush()
  Markup(join_texts(words, ""))
}

///|
/// A builtin filter: dispatch by name into the engine's own table.
priv struct BuiltinFilter {
  name : String
}

///|
impl Filter for BuiltinFilter with fn filter(
  self : BuiltinFilter,
  ctx : Context,
  input : Value,
  pos : Array[Value],
  kw : Map[String, Value],
) -> Value raise Fault {
  apply_filter(ctx, self.name, input, pos, kw)
}

///|
/// The 51 Jinja filters and the Django supplements, registered through the
/// same trait a caller uses.
fn builtin_filters() -> Map[String, &Filter] {
  let table : Map[String, &Filter] = Map([])
  for
    name in [
      "abs", "attr", "batch", "capitalize", "center", "default", "dictsort", "escape",
      "e", "filesizeformat", "first", "float", "forceescape", "format", "groupby",
      "indent", "int", "items", "join", "last", "length", "count", "list", "lower",
      "map", "max", "min", "pprint", "random", "reject", "select", "rejectattr",
      "selectattr", "replace", "reverse", "round", "safe", "slice", "sort", "string",
      "striptags", "sum", "title", "tojson", "trim", "truncate", "unique", "upper",
      "urlencode", "urlize", "wordcount", "wordwrap", "xmlattr",
      // The Django supplements, spelled the way Jinja spells filters.
       "date", "time", "timesince", "timeuntil", "slugify", "pluralize", "linebreaks",
      "linebreaksbr", "truncatechars", "truncatewords", "truncatechars_html", "truncatewords_html",
      "stringformat", "yesno", "json_script", "iriencode", "urlizetrunc", "unordered_list",
      "divisibleby", "get_digit", "add", "cut", "make_list", "ljust", "rjust", "floatformat",
      "escapejs", "spaceless",
    ] {
    let entry : BuiltinFilter = { name, }
    table.set(name, entry)
  }
  table
}

///|
/// Runs of white space become one space: striptags reads as prose, not as
/// layout.
fn collapse_space(s : StringView) -> String {
  let out = StringBuilder()
  let mut in_space = false
  for ch in s {
    if ch.is_ascii_whitespace() || ch == ' ' {
      if !in_space {
        out.write_char(' ')
        in_space = true
      }
    } else {
      out.write_char(ch)
      in_space = false
    }
  }
  out.to_string()
}
