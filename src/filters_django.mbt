// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The filters Django has that Jinja does not, spelled the way Jinja spells
/// filters: positional first, snake_case, parentheses for arguments. Names
/// Jinja already owns — `center`, `escape`, `filesizeformat` — live in the
/// other file and are not repeated here.
fn django_filter(
  _ctx : Context,
  name : String,
  input : Value,
  pos : Array[Value],
  kw : Map[String, Value],
) -> Value raise Fault {
  match name {
    "date" => {
      let pattern = arg_text(pos, kw, 0, Some("N j, Y"), "date")
      Value::Text(format_moment(as_moment(input), pattern))
    }
    "time" => {
      let pattern = arg_text(pos, kw, 0, Some("G:i"), "time")
      Value::Text(format_moment(as_moment(input), pattern))
    }
    "timesince" | "timeuntil" => {
      let other = match arg_at(pos, 0, Absent("none")) {
        Absent(_) =>
          raise Wrong(
            because="\{name} wants the other moment; this engine reads no clock",
          )
        v => as_moment(v)
      }
      let moment = as_moment(input)
      // timesince measures from `other` to the value; timeuntil the reverse.
      let diff = if name == "timesince" {
        other.diff(moment)
      } else {
        moment.diff(other)
      }
      let since = match diff {
        Some(span) => span
        None => raise Wrong(because="the two moments are not comparable")
      }
      Value::Text(since_text(since))
    }
    "slugify" => {
      let separator = match kw.get("separator") {
        Some(Text(s)) | Some(Markup(s)) => s
        _ => "-"
      }
      Value::Text(slug(as_text(input, "slugify"), separator))
    }
    "pluralize" => {
      let suffixes = arg_text(pos, kw, 0, Some("s"), "pluralize")
      let count = match input {
        Int(n) => n
        Double(d) => @double.trunc(d).to_int64()
        Seq(items) => items.length().to_int64()
        _ => 0L
      }
      let (single, plural) = match split_once_view(suffixes, ",") {
        Some(pair) => (pair.0.to_owned(), pair.1.to_owned())
        None => ("", suffixes)
      }
      Value::Text(if count == 1L { single } else { plural })
    }
    "linebreaks" => {
      let s = as_text(input, "linebreaks")
      let paragraphs = []
      for para in s.split("\n\n") {
        let broken = para.to_owned().replace_all(old="\n", new="<br />")
        paragraphs.push("<p>\{broken}</p>")
      }
      Markup(join_texts(paragraphs, " "))
    }
    "linebreaksbr" => {
      let s = as_text(input, "linebreaksbr")
      Markup(s.replace_all(old="\n", new="<br />"))
    }
    "truncatechars" => {
      let n = arg_int(pos, kw, 0, None, "truncatechars")
      let s = as_text(input, "truncatechars")
      if s.length() <= n {
        Value::Text(s)
      } else {
        Value::Text(s[0:n - 1].to_owned() + "…")
      }
    }
    "truncatewords" => {
      let n = arg_int(pos, kw, 0, None, "truncatewords")
      let s = as_text(input, "truncatewords")
      Value::Text(first_words(s, n, " ..."))
    }
    "truncatechars_html" => {
      let n = arg_int(pos, kw, 0, None, "truncatechars_html")
      Markup(truncate_html(as_text(input, "truncatechars_html"), n, true))
    }
    "truncatewords_html" => {
      let n = arg_int(pos, kw, 0, None, "truncatewords_html")
      Markup(truncate_html_words(as_text(input, "truncatewords_html"), n))
    }
    "stringformat" => {
      // Django applies the pattern to the value: "03d" means printf's %03d.
      let pattern = arg_text(pos, kw, 0, None, "stringformat")
      format_printf("%" + pattern, [input], {})
    }
    "yesno" => {
      let spec = arg_text(pos, kw, 0, Some("yes,no,maybe"), "yesno")
      let parts = spec.split(",").to_array()
      let yes = part_or(parts, 0, "yes")
      let no = part_or(parts, 1, "no")
      let maybe = part_or(parts, 2, "maybe")
      match input {
        Absent(_) => Value::Text(maybe)
        Null => Value::Text(maybe)
        _ => if truthy(input) { Value::Text(yes) } else { Value::Text(no) }
      }
    }
    "json_script" => {
      let id = kw.get("id")
      let element = kw.get("element")
      let tag = match element {
        Some(Text(s)) | Some(Markup(s)) => s
        _ => "script"
      }
      let json = to_json(input)
        .stringify()
        .replace_all(old="<", new="\\u003c")
        .replace_all(old=">", new="\\u003e")
        .replace_all(old="&", new="\\u0026")
        .replace_all(old="'", new="\\u0027")
      let attrs = match id {
        Some(Text(s)) | Some(Markup(s)) => " id=\"\{escape_text(s)}\""
        _ => ""
      }
      Markup("<\{tag}\{attrs} type=\"application/json\">\{json}</\{tag}>")
    }
    "iriencode" => {
      let s = as_text(input, "iriencode")
      Value::Text(iri_encode(s))
    }
    "urlizetrunc" => {
      let limit = arg_at(pos, 0, Int(-1L))
      urlize(as_text(input, "urlizetrunc"), limit, false)
    }
    "unordered_list" =>
      Markup(unordered_list(as_list(input, "unordered_list"), 0))
    "divisibleby" => {
      let by = match arg_at(pos, 0, Null) {
        Int(n) => n
        Double(d) => @double.trunc(d).to_int64()
        _ => raise Wrong(because="divisibleby wants a number")
      }
      if by == 0L {
        raise Wrong(because="divisibleby cannot divide by zero")
      }
      match input {
        Int(n) => Bool(n % by == 0L)
        Double(d) => Bool(@double.trunc(d).to_int64() % by == 0L)
        _ => Bool(false)
      }
    }
    "get_digit" => {
      // Django reads the digits off the value as text, whatever its kind.
      let which = arg_int(pos, kw, 0, None, "get_digit")
      if which < 1 {
        return input
      }
      let digits = show_value(input)
      if which > digits.length() {
        return input
      }
      Value::Text(
        digits[digits.length() - which:digits.length() - which + 1].to_owned(),
      )
    }
    "add" => {
      let other = arg_at(pos, 0, Null)
      match (input, other) {
        (Int(a), Int(b)) => Int(a + b)
        (Int(a), Double(b)) => Double(a.to_double() + b)
        (Double(a), Int(b)) => Double(a + b.to_double())
        (Double(a), Double(b)) => Double(a + b)
        (Seq(a), Seq(b)) => {
          let out = a.copy()
          for item in b {
            out.push(item)
          }
          Seq(out)
        }
        _ => Value::Text(show_value(input) + show_value(other))
      }
    }
    "cut" => {
      let gone = arg_text(pos, kw, 0, None, "cut")
      Value::Text(as_text(input, "cut").replace_all(old=gone, new=""))
    }
    "make_list" =>
      match input {
        Seq(items) => Seq(items)
        _ => {
          let out = []
          for ch in show_value(input) {
            out.push(Value::Text(ch.to_string()))
          }
          Seq(out)
        }
      }
    "ljust" => {
      let width = arg_int(pos, kw, 0, None, "ljust")
      Value::Text(as_text(input, "ljust").pad_end(width, ' '))
    }
    "rjust" => {
      let width = arg_int(pos, kw, 0, None, "rjust")
      Value::Text(as_text(input, "rjust").pad_start(width, ' '))
    }
    "floatformat" => {
      let places = arg_int(pos, kw, 0, Some(-1), "floatformat")
      let d = as_double(input, "floatformat")
      floatformat(d, places)
    }
    "escapejs" => {
      let s = as_text(input, "escapejs")
      Value::Text(escape_js(s))
    }
    "spaceless" => {
      let s = as_text(input, "spaceless")
      Markup(space_between_tags(s))
    }
    _ => raise Unknown(name~, kind="filter")
  }
}

///|
fn part_or(parts : Array[StringView], i : Int32, fallback : String) -> String {
  if i < parts.length() && !parts[i].is_empty() {
    parts[i].to_owned()
  } else {
    fallback
  }
}

///|
fn split_once_view(s : String, sep : String) -> (StringView, StringView)? {
  s.split_once(sep)
}

///|
/// A moment from the value at hand: an RFC 3339 or HTTP date as text, or an
/// epoch count as a number. This engine reads no clock of its own.
fn as_moment(value : Value) -> @moondate.Moment raise Fault {
  match value {
    Text(s) | Markup(s) =>
      @moondate.parse(s) catch {
        _ =>
          @moondate.of_isoformat(s) catch {
            _ => raise Wrong(because="not a date this reads: \{s}")
          }
      }
    Int(n) => @moondate.Moment::of_epoch(n)
    Double(d) => @moondate.Moment::of_epoch(@double.trunc(d).to_int64())
    _ =>
      raise Wrong(because="date wants text or a number, not \{kind_of(value)}")
  }
}

///|

///|
let month_short : Array[String] = [
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec",
]

///|
let weekday_names : Array[String] = [
  "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday",
]

///|
let weekday_short : Array[String] = [
  "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun",
]

///|
/// Django's date format letters, one pass over the pattern.
fn format_moment(moment : @moondate.Moment, pattern : String) -> String {
  let (year, month, day, hour, minute, second, weekday, yearday, _) = moment.timetuple()
  let isocalendar = moment.isocalendar()
  let iso_year = match isocalendar {
    Some(parts) => parts.0
    None => year
  }
  let iso_week = match isocalendar {
    Some(parts) => parts.1
    None => 0
  }
  let out = StringBuilder()
  let mut i = 0
  while i < pattern.length() {
    let unit = pattern.at(i)
    if unit == 0x25 && i + 1 < pattern.length() && pattern.at(i + 1) == 0x25 {
      out.write_char('%')
      i = i + 2
      continue
    }
    // Django's date format is bare letters: Y m d, not %Y %m %d. A `%`
    // escapes itself, and an unknown letter passes through.
    if unit == 0x25 {
      i = i + 1
      if i < pattern.length() && pattern.at(i) == 0x25 {
        out.write_char('%')
        i = i + 1
        continue
      }
      out.write_char('%')
      continue
    }
    if !((unit >= 0x41 && unit <= 0x5A) || (unit >= 0x61 && unit <= 0x7A)) {
      out.write_char(u16_char(unit))
      i = i + 1
      continue
    }
    if i >= pattern.length() {
      break
    }
    let letter = pattern.at(i)
    i = i + 1
    let hour12 = match hour % 12 {
      0 => 12
      h => h
    }
    match letter.to_char() {
      None => ()
      Some(digit) =>
        match digit {
          'a' => out.write_string(if hour < 12 { "a.m." } else { "p.m." })
          'A' => out.write_string(if hour < 12 { "AM" } else { "PM" })
          'b' => out.write_string(month_short[month - 1].to_lower())
          'c' => out.write_string(moment.isoformat())
          'd' => out.write_string(two(day))
          'D' => out.write_string(weekday_short[weekday])
          'e' => out.write_string("")
          'f' =>
            if minute == 0 {
              out.write_string(hour12.to_string())
            } else {
              out.write_string("\{hour12}:\{two(minute)}")
            }
          'g' => out.write_string(hour12.to_string())
          'G' => out.write_string(hour.to_string())
          'h' => out.write_string(two(hour12))
          'H' => out.write_string(two(hour))
          'i' => out.write_string(two(minute))
          'I' => out.write_string("0")
          'j' => out.write_string(day.to_string())
          'l' => out.write_string(weekday_names[weekday])
          'L' => out.write_string(if @moondate.leap(year) { "1" } else { "0" })
          'm' => out.write_string(two(month))
          'M' => out.write_string(month_short[month - 1])
          'n' => out.write_string(month.to_string())
          'N' => out.write_string(ap_month(month))
          'o' => out.write_string(iso_year.to_string())
          'O' => out.write_string(offset_text(moment))
          'P' =>
            if hour == 0 && minute == 0 {
              out.write_string("midnight")
            } else if hour == 12 && minute == 0 {
              out.write_string("noon")
            } else {
              let clock = if minute == 0 {
                "\{hour12}"
              } else {
                "\{hour12}:\{two(minute)}"
              }
              let half = if hour < 12 { "a.m." } else { "p.m." }
              out.write_string("\{clock} \{half}")
            }
          'r' =>
            out.write_string(
              "\{weekday_short[weekday]}, \{two(day)} \{month_short[month - 1]} \{year} \{two(hour)}:\{two(minute)}:\{two(second)} \{offset_text(moment)}",
            )
          's' => out.write_string(two(second))
          'S' => out.write_string(ordinal(day))
          't' => out.write_string(@moondate.length(year, month).to_string())
          'T' => out.write_string("")
          'u' => out.write_string("000000")
          'w' => out.write_string(((weekday + 1) % 7).to_string())
          'W' => out.write_string(two(iso_week))
          'y' => out.write_string(two(year % 100))
          'Y' => out.write_string(year.to_string())
          'z' => out.write_string((yearday - 1).to_string())
          'Z' => {
            let offset = moment.utcoffset()
            let seconds = match offset {
              Some(span) => span.seconds().to_int()
              None => 0
            }
            out.write_string(seconds.to_string())
          }
          other => out.write_char(other)
        }
    }
  }
  out.to_string()
}

///|
fn two(n : Int32) -> String {
  if n < 10 {
    "0\{n}"
  } else {
    n.to_string()
  }
}

///|
fn ap_month(month : Int32) -> String {
  let names = [
    "Jan.", "Feb.", "March", "April", "May", "June", "July", "Aug.", "Sept.", "Oct.",
    "Nov.", "Dec.",
  ]
  names[month - 1]
}

///|
fn ordinal(day : Int32) -> String {
  if day % 100 == 11 || day % 100 == 12 || day % 100 == 13 {
    return "th"
  }
  match day % 10 {
    1 => "st"
    2 => "nd"
    3 => "rd"
    _ => "th"
  }
}

///|
fn offset_text(moment : @moondate.Moment) -> String {
  let offset = moment.utcoffset()
  let seconds = match offset {
    Some(span) => span.seconds().to_int()
    None => 0
  }
  if seconds == 0 {
    return "+0000"
  }
  let sign = if seconds < 0 { "-" } else { "+" }
  let abs = if seconds < 0 { -seconds } else { seconds }
  "\{sign}\{two(abs / 3600)}\{two(abs % 3600 / 60)}"
}

///|
/// "3 weeks, 2 days" — the first non-zero chunk and the one after it.
fn since_text(span : @moondate.Span) -> String {
  let total = span.total_seconds()
  if total < 0.0 {
    return "0 minutes"
  }
  let minutes_total = @double.floor(total / 60.0).to_int()
  let chunks = []
  let years = minutes_total / 525960
  if years > 0 {
    chunks.push("\{years} year\{plural_s(years)}")
  }
  let months = minutes_total % 525960 / 43830
  if months > 0 && chunks.length() < 2 {
    chunks.push("\{months} month\{plural_s(months)}")
  }
  let weeks = minutes_total % 43830 / 10080
  if weeks > 0 && chunks.length() < 2 {
    chunks.push("\{weeks} week\{plural_s(weeks)}")
  }
  let days = minutes_total % 10080 / 1440
  if days > 0 && chunks.length() < 2 {
    chunks.push("\{days} day\{plural_s(days)}")
  }
  let hours = minutes_total % 1440 / 60
  if hours > 0 && chunks.length() < 2 {
    chunks.push("\{hours} hour\{plural_s(hours)}")
  }
  let minutes = minutes_total % 60
  if chunks.is_empty() && minutes == 0 {
    return "0 minutes"
  }
  if minutes > 0 && chunks.length() < 2 {
    chunks.push("\{minutes} minute\{plural_s(minutes)}")
  }
  if chunks.is_empty() {
    "0 minutes"
  } else {
    join_texts(chunks, ", ")
  }
}

///|
fn plural_s(n : Int32) -> String {
  if n == 1 {
    ""
  } else {
    "s"
  }
}

///|
fn slug(s : String, separator : String) -> String {
  let out = StringBuilder()
  let mut boundary = false
  for ch in s {
    if is_word_char(ch) || ch.is_ascii_digit() {
      out.write_char(char_lower(ch))
      boundary = false
    } else if !boundary && !out.is_empty() {
      out.write_string(separator)
      boundary = true
    }
  }
  let text = out.to_string()
  let trimmed = match text.strip_suffix(separator) {
    Some(without) => without.to_owned()
    None => text
  }
  trimmed
}

///|
fn first_words(s : String, n : Int32, end : String) -> String {
  let out = StringBuilder()
  let mut seen = 0
  let mut i = 0
  while i < s.length() && seen < n {
    if s.at(i) == 0x20 {
      seen = seen + 1
      if seen >= n {
        break
      }
      out.write_char(' ')
    } else {
      out.write_char(u16_char(s.at(i)))
    }
    i = i + 1
  }
  out.to_string() + end
}

///|
/// Truncate marked-up text without cutting through a tag: characters count
/// only outside tags, and any tag left open is closed on the way out.
fn truncate_html(s : String, n : Int32, by_chars : Bool) -> String {
  let out = StringBuilder()
  let open_tags : Array[String] = []
  let mut count = 0
  let mut i = 0
  let mut words_seen = 0
  let mut cut = false
  while i < s.length() {
    if s.at(i) == 0x3C {
      match find_from(s, ">", i) {
        Some(at) => {
          let tag = s[i + 1:at]
          out.write_string("<\{tag}>")
          if tag.at(0) == 0x2F {
            // </tag>
            let name = tag[1:tag.length()]
            let mut k = open_tags.length() - 1
            while k >= 0 {
              if open_tags[k] == name.to_owned() {
                ignore(open_tags.remove(k))
                break
              }
              k = k - 1
            }
          } else if !tag.has_suffix("/") &&
            !is_void_element(tag_first_word(tag).to_string()) {
            open_tags.push(tag_first_word(tag).to_string())
          }
          i = at + 1
        }
        None => {
          out.write_string(s[i:s.length()].to_owned())
          break
        }
      }
      continue
    }
    if cut {
      i = i + 1
      continue
    }
    let piece = s[i:i + 1]
    out.write_string(piece.to_owned())
    if by_chars {
      count = count + 1
      if count >= n - 1 {
        cut = true
        out.write_string("…")
      }
    } else if piece == " " {
      words_seen = words_seen + 1
      if words_seen >= n {
        cut = true
        out.write_string(" ...")
      }
    }
    i = i + 1
  }
  while open_tags.length() > 0 {
    let name = open_tags.pop()
    match name {
      Some(tag) => out.write_string("</\{tag}>")
      None => ()
    }
  }
  out.to_string()
}

///|
fn truncate_html_words(s : String, n : Int32) -> String {
  truncate_html(s, n, false)
}

///|
fn tag_first_word(tag : StringView) -> String {
  for i = 0; i < tag.length(); i = i + 1 {
    let unit = tag.at(i)
    if unit == 0x20 || unit == 0x09 || unit == 0x2F {
      return tag[0:i].to_owned()
    }
  }
  tag.to_owned()
}

///|
/// A nested list of items and sublists as `<ul>` nesting, Django's shape.
fn unordered_list(items : Array[Value], depth : Int32) -> String {
  // An item followed by a list nests that list inside the item's <li>,
  // which is how Django reads a nested array.
  let out = StringBuilder()
  out.write_string("<ul>")
  let mut i = 0
  while i < items.length() {
    match items[i] {
      Seq(inner) => out.write_string(unordered_list(inner, depth + 1))
      item => {
        out.write_string("<li>")
        out.write_string(escape_text(show_value(item)))
        if i + 1 < items.length() && items[i + 1] is Seq(_) {
          match items[i + 1] {
            Seq(inner) => out.write_string(unordered_list(inner, depth + 1))
            _ => ()
          }
          i = i + 1
        }
        out.write_string("</li>")
      }
    }
    i = i + 1
  }
  out.write_string("</ul>")
  out.to_string()
}

///|
fn iri_encode(s : String) -> String {
  let out = StringBuilder()
  for i = 0; i < s.length(); i = i + 1 {
    let unit = s.at(i)
    let keep = (unit >= 0x20 && unit <= 0x7E) &&
      unit != 0x22 &&
      unit != 0x25 &&
      unit != 0x3C &&
      unit != 0x3E &&
      unit != 0x20
    if keep {
      out.write_char(u16_char(unit))
    } else if unit == 0x20 {
      out.write_string("%20")
    } else {
      out.write_string(percent_encode(s[i:i + 1].to_owned()))
    }
  }
  out.to_string()
}

///|
fn escape_js(s : String) -> String {
  let out = StringBuilder()
  for i = 0; i < s.length(); i = i + 1 {
    let unit = s.at(i)
    match unit {
      0x5C => out.write_string("\\u005C")
      0x27 => out.write_string("\\u0027")
      0x22 => out.write_string("\\u0022")
      0x3E => out.write_string("\\u003E")
      0x3C => out.write_string("\\u003C")
      0x26 => out.write_string("\\u0026")
      0x0A => out.write_string("\n")
      0x0D => out.write_string("\r")
      0x09 => out.write_string("\t")
      _ =>
        if unit < 0x20 || unit > 0x7E {
          out.write_string("\\u" + hex4(unit))
        } else {
          out.write_char(u16_char(unit))
        }
    }
  }
  out.to_string()
}

///|
fn space_between_tags(s : String) -> String {
  // Only the white space between a closing `>` and an opening `<` goes.
  let out = StringBuilder()
  let mut i = 0
  while i < s.length() {
    if s.at(i) == 0x3E {
      out.write_string(">")
      i = i + 1
      let mut j = i
      while j < s.length() && u16_char(s.at(j)).is_ascii_whitespace() {
        j = j + 1
      }
      if j < s.length() && s.at(j) == 0x3C {
        i = j
      }
    } else {
      out.write_string(s[i:i + 1].to_owned())
      i = i + 1
    }
  }
  out.to_string()
}

///|
fn floatformat(d : Double, places : Int32) -> Value {
  let rounded = if places == 0 {
    Value::Text(@double.round(d).to_int64().to_string())
  } else {
    let digits = if places < 0 { -places } else { places }
    let scale = @math.pow(10.0, digits.to_double())
    let value = @double.round(d * scale) / scale
    let text = value.to_string()
    let trimmed = if places < 0 && text.contains(".") {
      match text.strip_suffix("0") {
        Some(without) =>
          match without.strip_suffix(".") {
            Some(shorter) => shorter.to_owned()
            None => without.to_owned()
          }
        None => text
      }
    } else {
      text
    }
    Text(trimmed)
  }
  rounded
}

///|
fn hex4(unit : UInt16) -> String {
  let hex = "0123456789ABCDEF"
  u16_char(hex.at((unit / 4096 % 16).to_int())).to_string() +
  u16_char(hex.at((unit / 256 % 16).to_int())).to_string() +
  u16_char(hex.at((unit / 16 % 16).to_int())).to_string() +
  u16_char(hex.at((unit % 16).to_int())).to_string()
}
