///|
/// The moment a value names: ISO 8601 text, or seconds since the epoch. An
/// empty value, or text that is not a date, names none, which Django's date
/// filters answer with empty text.
fn moment_of(value : @spec.Value) -> @moondate.Moment? {
  match value {
    Text(s) | Markup(s) =>
      if s.is_empty() {
        None
      } else {
        Some(@moondate.of_isoformat(s)) catch {
          _ => None
        }
      }
    Int(n) => Some(@moondate.Moment::of_epoch(n, zone=Utc))
    Double(d) if !d.is_nan() && !d.is_inf() => {
      let whole = d.floor()
      let nano = ((d - whole) * 1.0e9).round().to_int()
      Some(@moondate.Moment::of_epoch(whole.to_int64(), nano~, zone=Utc))
    }
    _ => None
  }
}

///|
/// A moment as the date filters show it: one with a zone is read in UTC,
/// the time zone this library takes, as Django shows an aware time in its
/// current zone; one without is shown as written.
fn local_of(value : @spec.Value) -> @moondate.Moment? {
  match moment_of(value) {
    Some(Zoned(_) as m) => m.astimezone(Offset(0))
    other => other
  }
}

///|
/// The English names Django's default locale gives months and weekdays.
let month_names : Array[String] = [
  "January", "February", "March", "April", "May", "June", "July", "August", "September",
  "October", "November", "December",
]

///|
let month_ap : Array[String] = [
  "Jan.", "Feb.", "March", "April", "May", "June", "July", "Aug.", "Sept.", "Oct.",
  "Nov.", "Dec.",
]

///|
let weekday_names : Array[String] = [
  "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday",
]

///|
/// The formats Django's English locale names, by setting.
let named_formats : Map[String, String] = Map([
  ("DATE_FORMAT", "N j, Y"),
  ("DATETIME_FORMAT", "N j, Y, P"),
  ("TIME_FORMAT", "P"),
  ("YEAR_MONTH_FORMAT", "F Y"),
  ("MONTH_DAY_FORMAT", "F j"),
  ("SHORT_DATE_FORMAT", "m/d/Y"),
  ("SHORT_DATETIME_FORMAT", "m/d/Y P"),
])

///|
fn pad2(n : Int32) -> String {
  if n < 10 {
    "0" + n.to_string()
  } else {
    n.to_string()
  }
}

///|
/// The zone a moment is read in: its own, or UTC for one written without,
/// the default time zone this library takes.
fn zone_of(m : @moondate.Moment) -> @moondate.Zone {
  match m {
    Zoned(zone~, ..) => zone
    _ => Utc
  }
}

///|
fn offset_minutes(zone : @moondate.Zone) -> Int32 {
  match zone {
    Utc => 0
    Offset(minutes) => minutes
  }
}

///|
/// The zone's name as Python's fixed-offset `timezone` gives it.
fn zone_name(zone : @moondate.Zone) -> String {
  match zone {
    Utc | Offset(0) => "UTC"
    Offset(m) => {
      let sign = if m < 0 { "-" } else { "+" }
      let a = m.abs()
      "UTC" + sign + pad2(a / 60) + ":" + pad2(a % 60)
    }
  }
}

///|
fn signed_offset(zone : @moondate.Zone) -> String {
  let m = offset_minutes(zone)
  let sign = if m < 0 { "-" } else { "+" }
  let a = m.abs()
  sign + pad2(a / 60) + pad2(a % 60)
}

///|
let time_codes : String = "aAefgGhHiOPsTuZ"

///|
/// A moment written in Django's date format, PHP's letters: `\` escapes the
/// next character. `time_only` is the `time` filter, which knows the time
/// letters alone; a date letter there gives `None`. A date without a time
/// refuses the time letters, as Django's does.
fn django_format(
  m : @moondate.Moment,
  format : String,
  time_only : Bool,
) -> String? raise @spec.Refused {
  let has_date = !(m is Clock(_))
  let has_time = !(m is Day(_))
  let date = m.date().unwrap_or({ year: 1900, month: 1, day: 1, })
  let t = m.time()
  let zone = zone_of(m)
  let hour12 = if t.hour % 12 == 0 { 12 } else { t.hour % 12 }
  let f = if t.minute == 0 {
    hour12.to_string()
  } else {
    hour12.to_string() + ":" + pad2(t.minute)
  }
  let meridiem = if t.hour > 11 { "p.m." } else { "a.m." }
  let out = StringBuilder()
  let chars = format.iter().collect()
  let mut i = 0
  while i < chars.length() {
    let ch = chars[i]
    i += 1
    if ch == '\\' && i < chars.length() {
      out.write_char(chars[i])
      i += 1
      continue
    }
    if !"aAbcdDeEfFgGhHiIjlLmMnNoOPrsStTUuwWyYzZ".contains_char(ch) {
      out.write_char(ch)
      continue
    }
    let time_code = time_codes.contains_char(ch)
    if time_only && !time_code {
      return None
    }
    if time_code && !has_time {
      raise @spec.invalid(
        "the format for a date may not contain time letters, found \{ch}",
      )
    }
    if !time_code && !has_date {
      return None
    }
    let piece = match ch {
      'a' => meridiem
      'A' => if t.hour > 11 { "PM" } else { "AM" }
      'e' => if m is Zoned(_) { zone_name(zone) } else { "" }
      'f' => f
      'g' => hour12.to_string()
      'G' => t.hour.to_string()
      'h' => pad2(hour12)
      'H' => pad2(t.hour)
      'i' => pad2(t.minute)
      'O' => signed_offset(zone)
      'P' =>
        if t.minute == 0 && t.hour == 0 {
          "midnight"
        } else if t.minute == 0 && t.hour == 12 {
          "noon"
        } else {
          f + " " + meridiem
        }
      's' => pad2(t.second)
      'T' => zone_name(zone)
      'u' => {
        let micro = (t.nano / 1000).to_string()
        "000000"[:6 - micro.length()].to_owned() + micro
      }
      'Z' => (offset_minutes(zone) * 60).to_string()
      'b' => month_names[date.month - 1][:3].to_owned().to_lower()
      'c' => m.isoformat()
      'd' => pad2(date.day)
      'D' => weekday_names[(date.weekday() + 6) % 7][:3].to_owned()
      'E' | 'F' => month_names[date.month - 1]
      'I' => "0"
      'j' => date.day.to_string()
      'l' => weekday_names[(date.weekday() + 6) % 7]
      'L' => if @moondate.leap(date.year) { "True" } else { "False" }
      'm' => pad2(date.month)
      'M' => month_names[date.month - 1][:3].to_owned()
      'n' => date.month.to_string()
      'N' => month_ap[date.month - 1]
      'o' => date.isocalendar().0.to_string()
      'r' => {
        let day = weekday_names[(date.weekday() + 6) % 7][:3].to_owned()
        let month = month_names[date.month - 1][:3].to_owned()
        let year = date.year.to_string()
        "\{day}, \{pad2(date.day)} \{month} \{year} \{pad2(t.hour)}:\{pad2(t.minute)}:\{pad2(t.second)} \{signed_offset(zone)}"
      }
      'S' =>
        if date.day is (11 | 12 | 13) {
          "th"
        } else {
          match date.day % 10 {
            1 => "st"
            2 => "nd"
            3 => "rd"
            _ => "th"
          }
        }
      't' => @moondate.length(date.year, date.month).to_string()
      'U' => {
        let wall = date.days().to_int64() * 86400L +
          t.hour.to_int64() * 3600L +
          t.minute.to_int64() * 60L +
          t.second.to_int64()
        (wall - offset_minutes(zone).to_int64() * 60L).to_string()
      }
      'w' => date.weekday().to_string()
      'W' => date.isocalendar().1.to_string()
      'y' => pad2(date.year % 100)
      'Y' => {
        let y = date.year.to_string()
        "0000"[:(4 - y.length()).max(0)].to_owned() + y
      }
      'z' => date.yearday().to_string()
      _ => ""
    }
    out.write_string(piece)
  }
  Some(out.to_string())
}

///|
/// A format argument: a Django format setting by name, else the letters
/// themselves.
fn format_arg(
  call : @spec.Call,
  arg : @spec.Value?,
  fallback : String,
) -> String raise @spec.Refused {
  let given = match arg {
    Some(Null) | None => fallback
    Some(v) => call.text(v)
  }
  named_formats.get(given).unwrap_or(given)
}

///|
fn filter_date(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("date", ["arg"], args, named)
  let format = format_arg(call, b.get("arg"), "DATE_FORMAT")
  match local_of(value) {
    Some(m) => Text(django_format(m, format, false).unwrap_or(""))
    None => Text("")
  }
}

///|
fn filter_time(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  let b = bind("time", ["arg"], args, named)
  let format = format_arg(call, b.get("arg"), "TIME_FORMAT")
  match local_of(value) {
    Some(m) =>
      Text(django_format(m, format, true).unwrap_or("")) catch {
        _ => Text("")
      }
    None => Text("")
  }
}

///|
/// The calendar's month lengths as Django's `timesince` counts them,
/// February always 28.
let month_days : Array[Int32] = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

///|
let time_units : Array[(String, String)] = [
  ("year", "years"),
  ("month", "months"),
  ("week", "weeks"),
  ("day", "days"),
  ("hour", "hours"),
  ("minute", "minutes"),
]

///|
fn unit_text(i : Int32, n : Int64) -> String {
  let (one, many) = time_units[i]
  n.to_string() + "\u{A0}" + (if n == 1L { one } else { many })
}

///|
/// A moment as a datetime: a date alone is its midnight.
fn wall_of(m : @moondate.Moment) -> (@moondate.Date, @moondate.Time, Bool)? {
  match m {
    Zoned(date~, time~, ..) => Some((date, time, true))
    Plain(date~, time~) => Some((date, time, false))
    Day(date~) =>
      Some((date, { hour: 0, minute: 0, second: 0, nano: 0, }, false))
    Clock(_) => None
  }
}

///|
/// Seconds since the epoch of a wall time read in `zone`.
fn seconds_of(
  date : @moondate.Date,
  t : @moondate.Time,
  zone : @moondate.Zone,
) -> Int64 {
  date.days().to_int64() * 86400L +
  t.hour.to_int64() * 3600L +
  t.minute.to_int64() * 60L +
  t.second.to_int64() -
  offset_minutes(zone).to_int64() * 60L
}

///|
/// Django's `timesince`: up to `depth` adjacent units from years down to
/// minutes between `d` and `now`, years and months counted on the calendar;
/// `reversed` measures from `now` to `d`, after `now` is read in `d`'s zone.
/// `None` when the two cannot be compared.
fn timesince(
  d : @moondate.Moment,
  now : @moondate.Moment,
  depth : Int32,
  reversed : Bool,
) -> String? {
  guard wall_of(d) is Some((d_date, d_time, d_aware)) else { return None }
  guard wall_of(now) is Some((n_date0, n_time0, n_aware)) else { return None }
  if d_aware != n_aware {
    return None
  }
  let d_zone = zone_of(d)
  let (n_date, n_time) = if n_aware {
    let shifted = seconds_of(n_date0, n_time0, zone_of(now)) +
      offset_minutes(d_zone).to_int64() * 60L
    let days = if shifted >= 0L {
      shifted / 86400L
    } else {
      (shifted - 86399L) / 86400L
    }
    let rest = shifted - days * 86400L
    (
      @moondate.Date::of_days(days.to_int()),
      @moondate.Time::{
        hour: (rest / 3600L).to_int(),
        minute: (rest / 60L % 60L).to_int(),
        second: (rest % 60L).to_int(),
        nano: n_time0.nano,
      },
    )
  } else {
    (n_date0, n_time0)
  }
  let (d_date, d_time, n_date, n_time) = if reversed {
    (n_date, n_time, d_date, d_time)
  } else {
    (d_date, d_time, n_date, n_time)
  }
  let since = seconds_of(n_date, n_time, Utc) - seconds_of(d_date, d_time, Utc)
  let zero = Some(unit_text(5, 0L))
  if since <= 0L {
    return zero
  }
  let mut total_months = (n_date.year - d_date.year) * 12 +
    (n_date.month - d_date.month)
  if d_date.day > n_date.day || (d_date.day == n_date.day && d_time > n_time) {
    total_months -= 1
  }
  let years = if total_months >= 0 {
    total_months / 12
  } else {
    (total_months - 11) / 12
  }
  let months = total_months - years * 12
  let (pivot_date, pivot_time) = if years != 0 || months != 0 {
    let mut year = d_date.year + years
    let mut month = d_date.month + months
    if month > 12 {
      month -= 12
      year += 1
    }
    let day = d_date.day.min(month_days[month - 1])
    (@moondate.Date::{ year, month, day, }, { ..d_time, nano: 0, })
  } else {
    (d_date, d_time)
  }
  let pivot_nanos = seconds_of(pivot_date, pivot_time, Utc).to_double() * 1.0e9 +
    pivot_time.nano.to_double()
  let now_nanos = seconds_of(n_date, n_time, Utc).to_double() * 1.0e9 +
    n_time.nano.to_double()
  let mut remaining = (now_nanos - pivot_nanos) / 1.0e9
  let partials : Array[Int64] = [years.to_int64(), months.to_int64()]
  for chunk in [604800.0, 86400.0, 3600.0, 60.0] {
    let count = (remaining / chunk).floor()
    partials.push(count.to_int64())
    remaining -= chunk * count
  }
  guard partials.search_by(p => p != 0L) is Some(first) else { return zero }
  let out = []
  let mut i = first
  while i < partials.length() && out.length() < depth {
    if partials[i] == 0L {
      break
    }
    out.push(unit_text(i, partials[i]))
    i += 1
  }
  Some(out.join(", "))
}

///|
fn since_or_until(
  who : String,
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
  until : Bool,
) -> @spec.Value raise @spec.Refused {
  let b = bind(who, ["now", "depth"], args, named)
  if !value.truthy() {
    return Text("")
  }
  let now = match b.get("now") {
    Some(Null) | None =>
      raise @spec.invalid(
        "\{who} needs the moment to measure to, as \{who}(now): templates read no clock",
      )
    Some(v) => v
  }
  let depth = b.int("depth", 2)
  if depth <= 0 {
    raise @spec.invalid("depth must be greater than 0")
  }
  ignore(call)
  match (moment_of(value), moment_of(now)) {
    (Some(d), Some(n)) => Text(timesince(d, n, depth, until).unwrap_or(""))
    _ => Text("")
  }
}

///|
fn filter_timesince(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  since_or_until("timesince", call, value, args, named, false)
}

///|
fn filter_timeuntil(
  call : @spec.Call,
  value : @spec.Value,
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
) -> @spec.Value raise @spec.Refused {
  since_or_until("timeuntil", call, value, args, named, true)
}
