///|
/// A method of a string, list or mapping, bound to the value, as Python
/// offers it to a template: `d.items()`, `s.split(",")`, `l.append(x)`.
/// `None` when the value has no method of that name.
pub fn attr(value : @spec.Value, name : String) -> @spec.Value? {
  let bound = fn(run : @spec.Func) -> @spec.Value? {
    Some(@spec.Value::func(name, run))
  }
  match value {
    Text(s) | Markup(s) =>
      match string_method(value, s, name) {
        Some(run) => bound(run)
        None => None
      }
    Seq(items) =>
      match list_method(items, name) {
        Some(run) => bound(run)
        None => None
      }
    Tuple(items) =>
      match name {
        "count" => bound((_, args, _) => Int(count_items(items, args)))
        "index" => bound((_, args, _) => Int(index_items(items, args, "tuple")))
        _ => None
      }
    Dict(fields) =>
      match dict_method(fields, name) {
        Some(run) => bound(run)
        None => None
      }
    Int(_) | Double(_) | Bool(_) =>
      match (name, value) {
        ("real" | "numerator", Bool(b)) => Some(Int(if b { 1 } else { 0 }))
        ("real", _) | ("numerator", Int(_)) => Some(value)
        ("imag", Double(_)) => Some(Double(0.0))
        ("imag", _) => Some(Int(0))
        ("denominator", Int(_) | Bool(_)) => Some(Int(1))
        _ =>
          match number_method(value, name) {
            Some(run) => bound(run)
            None => None
          }
      }
    _ => None
  }
}

///|
/// The methods of a number a template reaches for: `is_integer`,
/// `as_integer_ratio`, `bit_length`, `conjugate` and a float's `hex`.
fn number_method(value : @spec.Value, name : String) -> @spec.Func? {
  let value = match value {
    Bool(b) => @spec.Value::Int(if b { 1 } else { 0 })
    v => v
  }
  let run : @spec.Func = match (name, value) {
    ("is_integer", Int(_)) =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(true)
      }
    ("is_integer", Double(d)) =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(!d.is_inf() && d == d.floor())
      }
    ("conjugate", _) =>
      (_, a, n) => {
        none_args(a, n, name)
        value
      }
    ("bit_length", Int(i)) =>
      (_, a, n) => {
        none_args(a, n, name)
        let m = if i < 0L { -i } else { i }
        Int((64 - m.clz()).to_int64())
      }
    ("as_integer_ratio", Int(_)) =>
      (_, a, n) => {
        none_args(a, n, name)
        Tuple([value, Int(1)])
      }
    ("as_integer_ratio", Double(d)) =>
      (_, a, n) => {
        none_args(a, n, name)
        if d.is_nan() || d.is_inf() {
          raise @spec.invalid(
            "cannot convert \{@spec.python_float(d)} to integer ratio",
          )
        }
        let (negative, mantissa, exponent) = exact(d)
        let (num, den) = if exponent >= 0 {
          (mantissa * (1N << exponent), 1N)
        } else {
          let den = 1N << -exponent
          let g = gcd(mantissa, den)
          (mantissa / g, den / g)
        }
        let top = @bigint.BigInt::from_int64(9223372036854775807L)
        if num > top || den > top {
          raise @spec.invalid(
            "\{@spec.python_float(d)} does not fit in a 64-bit integer ratio",
          )
        }
        let num = if negative { -num } else { num }
        Tuple([Int(num.to_int64()), Int(den.to_int64())])
      }
    ("hex", Double(d)) =>
      (_, a, n) => {
        none_args(a, n, name)
        Text(float_hex(d))
      }
    _ => return None
  }
  Some(run)
}

///|
fn gcd(a : @bigint.BigInt, b : @bigint.BigInt) -> @bigint.BigInt {
  if b == 0N {
    a
  } else {
    gcd(b, a % b)
  }
}

///|
/// Python's `float.hex()`: `0x1.8000000000000p+1`, thirteen hex digits of
/// fraction.
fn float_hex(d : Double) -> String {
  if d.is_nan() {
    return "nan"
  }
  if d.is_inf() {
    return if d > 0.0 { "inf" } else { "-inf" }
  }
  let bits = d.reinterpret_as_uint64()
  let sign = if bits >> 63 == 1UL { "-" } else { "" }
  let biased = ((bits >> 52) & 0x7FFUL).to_int()
  let fraction = bits & 0xFFFFFFFFFFFFFUL
  if biased == 0 && fraction == 0UL {
    return sign + "0x0.0p+0"
  }
  let (lead, exponent) = if biased == 0 {
    ("0", -1022)
  } else {
    ("1", biased - 1023)
  }
  let mut digits = fraction.to_string(radix=16)
  digits = "0".repeat(13 - digits.length()) + digits
  let e = if exponent >= 0 {
    "+" + exponent.to_string()
  } else {
    exponent.to_string()
  }
  "\{sign}0x\{lead}.\{digits}p\{e}"
}

///|
fn one(
  args : Array[@spec.Value],
  who : String,
) -> @spec.Value raise @spec.Refused {
  match args {
    [a] => a
    _ =>
      raise @spec.invalid(
        "\{who} takes exactly one argument (\{args.length()} given)",
      )
  }
}

///|
fn none_args(
  args : Array[@spec.Value],
  named : Map[String, @spec.Value],
  who : String,
) -> Unit raise @spec.Refused {
  if !args.is_empty() || !named.is_empty() {
    raise @spec.invalid("\{who} takes no arguments")
  }
}

///|
fn count_items(
  items : Array[@spec.Value],
  args : Array[@spec.Value],
) -> Int64 raise @spec.Refused {
  let x = one(args, "count")
  items.iter().filter(v => v == x).count().to_int64()
}

///|
fn index_items(
  items : Array[@spec.Value],
  args : Array[@spec.Value],
  who : String,
) -> Int64 raise @spec.Refused {
  let x = one(args, "index")
  match items.search(x) {
    Some(i) => i.to_int64()
    None => raise @spec.invalid("\{who}.index(x): x not in \{who}")
  }
}

///|
fn text_arg(
  call : @spec.Call,
  args : Array[@spec.Value],
  i : Int32,
  who : String,
) -> String raise @spec.Refused {
  match args.get(i) {
    Some(Text(s) | Markup(s)) => s
    Some(v) => raise @spec.invalid("\{who} wants a string, not \{v.kind()}")
    None => {
      ignore(call)
      raise @spec.invalid("\{who} is missing an argument")
    }
  }
}

///|
/// A prefix test against a string or a tuple of strings, from `start` to
/// `end`, as `startswith` and `endswith` take them.
fn bounds(
  args : Array[@spec.Value],
  n : Int32,
  who : String,
) -> (Int32, Int32) raise @spec.Refused {
  let norm = (v : Int64) => {
    let v = v.to_int()
    if v < 0 {
      (v + n).max(0)
    } else {
      v.min(n)
    }
  }
  let at = (i : Int32, default : Int32) => {
    match args.get(i) {
      None | Some(Null) => Ok(default)
      Some(Int(v)) => Ok(norm(v))
      Some(Bool(b)) => Ok(norm(if b { 1L } else { 0L }))
      Some(_) => Err(())
    }
  }
  match (at(1, 0), at(2, n)) {
    (Ok(start), Ok(end)) => (start, end)
    _ => raise @spec.invalid("\{who}: slice indices must be integers or None")
  }
}

///|
fn affix(
  call : @spec.Call,
  s : String,
  args : Array[@spec.Value],
  who : String,
  suffix : Bool,
) -> Bool raise @spec.Refused {
  if args.is_empty() || args.length() > 3 {
    raise @spec.invalid("\{who} takes one to three arguments")
  }
  let n = char_count(s)
  let norm = fn(v : Int32) { if v < 0 { (v + n).max(0) } else { v.min(n) } }
  let start = match args.get(1) {
    Some(Int(v)) => norm(v.to_int())
    _ => 0
  }
  let end = match args.get(2) {
    Some(Int(v)) => norm(v.to_int())
    _ => n
  }
  let part = chars_slice(s, start, end)
  let candidates = match args[0] {
    Tuple(items) | Seq(items) => items
    other => [other]
  }
  for c in candidates {
    let t = match c {
      Text(t) | Markup(t) => t
      _ => raise @spec.invalid("\{who} first arg must be str or a tuple of str")
    }
    if start > end && !t.is_empty() {
      continue
    }
    if (if suffix { part.has_suffix(t) } else { part.has_prefix(t) }) {
      return true
    }
  }
  ignore(call)
  false
}

///|
/// Python's `str.split(sep, maxsplit)` and `rsplit`.
fn py_split(
  s : String,
  sep : String?,
  maxsplit : Int32,
  right : Bool,
) -> Array[String] raise @spec.Refused {
  match sep {
    None => {
      let parts = py_split_ws(s)
      if maxsplit < 0 || parts.length() <= maxsplit + 1 {
        return parts
      }
      let cs = s.iter().collect()
      if right {
        let out = []
        let mut end = cs.length()
        while end > 0 && is_space(cs[end - 1]) {
          end -= 1
        }
        let mut splits = 0
        while splits < maxsplit {
          let mut start = end
          while start > 0 && !is_space(cs[start - 1]) {
            start -= 1
          }
          out.push(String::from_array(cs[start:end]))
          splits += 1
          end = start
          while end > 0 && is_space(cs[end - 1]) {
            end -= 1
          }
          if end == 0 {
            break
          }
        }
        if end > 0 {
          out.push(String::from_array(cs[:end]))
        }
        out.rev()
      } else {
        let out = []
        let mut start = 0
        while start < cs.length() && is_space(cs[start]) {
          start += 1
        }
        let mut splits = 0
        while splits < maxsplit && start < cs.length() {
          let mut end = start
          while end < cs.length() && !is_space(cs[end]) {
            end += 1
          }
          out.push(String::from_array(cs[start:end]))
          splits += 1
          start = end
          while start < cs.length() && is_space(cs[start]) {
            start += 1
          }
        }
        if start < cs.length() {
          out.push(String::from_array(cs[start:]))
        }
        out
      }
    }
    Some("") => raise @spec.invalid("empty separator")
    Some(sep) => {
      let all = s.split(sep).map(p => p.to_owned()).collect()
      if maxsplit < 0 || all.length() <= maxsplit + 1 {
        all
      } else if right {
        let keep = all.length() - maxsplit
        [all[:keep].join(sep), ..all[keep:]]
      } else {
        [..all[:maxsplit], all[maxsplit:].join(sep)]
      }
    }
  }
}

///|
/// Python's `str.title`: a letter after a non-cased character goes up,
/// every other cased letter down.
fn py_title(s : String) -> String {
  let out = StringBuilder()
  let mut previous_cased = false
  for ch in s {
    let text = ch.to_string()
    if previous_cased {
      out.write_string(@moonucd.lower(text))
    } else {
      out.write_string(@moonucd.title(text))
    }
    previous_cased = @moonucd.has(ch, Cased) ||
      @moonucd.category(ch) is (Lu | Ll | Lt)
  }
  out.to_string()
}

///|
fn find_index(
  haystack : String,
  needle : String,
  right : Bool,
  start~ : Int32 = 0,
  end? : Int32,
) -> Int32 {
  let h = haystack.iter().collect()
  let n = needle.iter().collect()
  let end = end.unwrap_or(h.length())
  if start > h.length() {
    return -1
  }
  let last = end - n.length()
  if last < start {
    return -1
  }
  let matches = fn(i : Int32) {
    for j, c in n {
      if h[i + j] != c {
        return false
      }
    }
    true
  }
  if right {
    for i = last; i >= start; i = i - 1 {
      if matches(i) {
        return i
      }
    }
  } else {
    for i in start..<=last {
      if matches(i) {
        return i
      }
    }
  }
  -1
}

///|
fn string_method(value : @spec.Value, s : String, name : String) -> @spec.Func? {
  let wrap = fn(t : String) { same_kind(value, t) }
  let run : @spec.Func = match name {
    "upper" =>
      (_, a, n) => {
        none_args(a, n, name)
        wrap(@moonucd.upper(s))
      }
    "lower" =>
      (_, a, n) => {
        none_args(a, n, name)
        wrap(@moonucd.lower(s))
      }
    "casefold" =>
      (_, a, n) => {
        none_args(a, n, name)
        wrap(@moonucd.fold(s))
      }
    "capitalize" =>
      (_, a, n) => {
        none_args(a, n, name)
        wrap(py_capitalize(s))
      }
    "title" =>
      (_, a, n) => {
        none_args(a, n, name)
        wrap(py_title(s))
      }
    "swapcase" =>
      (_, a, n) => {
        none_args(a, n, name)
        let out = StringBuilder()
        for ch in s {
          let t = ch.to_string()
          out.write_string(
            if is_upper_char(ch) {
              @moonucd.lower(t)
            } else if is_lower_char(ch) {
              @moonucd.upper(t)
            } else {
              t
            },
          )
        }
        wrap(out.to_string())
      }
    "strip" | "lstrip" | "rstrip" =>
      (call, a, _) => {
        let chars = match a.get(0) {
          Some(Null) | None => None
          Some(_) => Some(text_arg(call, a, 0, name))
        }
        let cs = s.iter().collect()
        let drop = match chars {
          Some(set) => {
            let members = set.iter().collect()
            (c : Char) => members.contains(c)
          }
          None => is_space
        }
        let mut lo = 0
        let mut hi = cs.length()
        if name != "rstrip" {
          while lo < hi && drop(cs[lo]) {
            lo += 1
          }
        }
        if name != "lstrip" {
          while hi > lo && drop(cs[hi - 1]) {
            hi -= 1
          }
        }
        wrap(String::from_array(cs[lo:hi]))
      }
    "split" | "rsplit" =>
      (call, a, n) => {
        let b = bind(name, ["sep", "maxsplit"], a, n)
        let sep = match b.get("sep") {
          Some(Null) | None => None
          Some(v) => Some(call.text(v))
        }
        Seq(
          py_split(s, sep, b.int("maxsplit", -1), name == "rsplit").map(p => {
            wrap(p)
          }),
        )
      }
    "splitlines" =>
      (_, a, n) => {
        let b = bind(name, ["keepends"], a, n)
        Seq(py_splitlines(s, b.flag("keepends", false)).map(p => wrap(p)))
      }
    "startswith" => (call, a, _) => Bool(affix(call, s, a, name, false))
    "endswith" => (call, a, _) => Bool(affix(call, s, a, name, true))
    "replace" =>
      (call, a, n) => {
        let b = bind(name, ["old", "new", "count"], a, n)
        wrap(
          py_replace(
            s,
            call.text(b.need("old")),
            call.text(b.need("new")),
            b.int("count", -1),
          ),
        )
      }
    "find" | "rfind" | "index" | "rindex" =>
      (call, a, _) => {
        let (start, end) = bounds(a, char_count(s), name)
        let at = find_index(
          s,
          text_arg(call, a, 0, name),
          name.has_prefix("r"),
          start~,
          end~,
        )
        if at < 0 && name.has_suffix("index") {
          raise @spec.invalid("substring not found")
        }
        Int(at.to_int64())
      }
    "count" =>
      (call, a, _) => {
        let needle = text_arg(call, a, 0, name)
        let (start, end) = bounds(a, char_count(s), name)
        Int(
          if start > char_count(s) {
            0L
          } else if needle.is_empty() {
            ((end - start).max(0) + 1).to_int64()
          } else if end <= start {
            0L
          } else {
            count_of(chars_slice(s, start, end), needle).to_int64()
          },
        )
      }
    "join" =>
      (call, a, _) => {
        let parts = []
        for item in call.items(one(a, name)) {
          match item {
            Text(t) | Markup(t) => parts.push(t)
            other =>
              raise @spec.invalid(
                "sequence item: expected str instance, \{other.kind()} found",
              )
          }
        }
        wrap(parts.join(s))
      }
    "center" | "ljust" | "rjust" =>
      (call, a, _) => {
        let width = match a.get(0) {
          Some(Int(w)) => w.to_int()
          _ => raise @spec.invalid("\{name} wants an integer width")
        }
        let fill = match a.get(1) {
          Some(Text(f)) if char_count(f) == 1 => f
          Some(_) =>
            raise @spec.invalid(
              "the fill character must be exactly one character long",
            )
          None => " "
        }
        let len = char_count(s)
        if len >= width {
          return wrap(s)
        }
        let gap = width - len
        ignore(call)
        wrap(
          match name {
            "ljust" => s + fill.repeat(gap)
            "rjust" => fill.repeat(gap) + s
            _ => {
              let left = gap / 2 + (gap & width & 1)
              fill.repeat(left) + s + fill.repeat(gap - left)
            }
          },
        )
      }
    "zfill" =>
      (_, a, _) => {
        let width = match a.get(0) {
          Some(Int(w)) => w.to_int()
          _ => raise @spec.invalid("zfill wants an integer width")
        }
        let len = char_count(s)
        if len >= width {
          return wrap(s)
        }
        if s.has_prefix("+") || s.has_prefix("-") {
          wrap(s[:1].to_owned() + "0".repeat(width - len) + s[1:].to_owned())
        } else {
          wrap("0".repeat(width - len) + s)
        }
      }
    "partition" | "rpartition" =>
      (call, a, _) => {
        let sep = text_arg(call, a, 0, name)
        if sep.is_empty() {
          raise @spec.invalid("empty separator")
        }
        let at = find_index(s, sep, name == "rpartition")
        if at < 0 {
          if name == "partition" {
            Tuple([wrap(s), wrap(""), wrap("")])
          } else {
            Tuple([wrap(""), wrap(""), wrap(s)])
          }
        } else {
          let n = char_count(sep)
          Tuple([
            wrap(chars_slice(s, 0, at)),
            wrap(sep),
            wrap(chars_slice(s, at + n, char_count(s))),
          ])
        }
      }
    "removeprefix" =>
      (call, a, _) => {
        let p = text_arg(call, a, 0, name)
        wrap(if s.has_prefix(p) { s[p.length():].to_owned() } else { s })
      }
    "removesuffix" =>
      (call, a, _) => {
        let p = text_arg(call, a, 0, name)
        wrap(
          if !p.is_empty() && s.has_suffix(p) {
            s[:s.length() - p.length()].to_owned()
          } else {
            s
          },
        )
      }
    "format" =>
      (call, a, n) => wrap(str_format(call, s, a, n, escape=value is Markup(_)))
    "format_map" =>
      (call, a, n) => {
        guard a is [Dict(fields)] && n.is_empty() else {
          raise @spec.invalid("format_map takes one mapping")
        }
        wrap(str_format(call, s, [], fields, escape=value is Markup(_)))
      }
    "expandtabs" =>
      (_, a, n) => {
        let size = match (a, n.get("tabsize")) {
          ([], None) => 8
          ([Int(t)], None) | ([], Some(Int(t))) => t.to_int()
          _ => raise @spec.invalid("expandtabs takes one integer")
        }
        let out = StringBuilder()
        let mut column = 0
        for c in s {
          match c {
            '\t' =>
              if size > 0 {
                let gap = size - column % size
                out.write_string(" ".repeat(gap))
                column += gap
              }
            '\n' | '\r' => {
              out.write_char(c)
              column = 0
            }
            _ => {
              out.write_char(c)
              column += 1
            }
          }
        }
        wrap(out.to_string())
      }
    "isprintable" =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(
          s
          .iter()
          .all(c => {
            c == ' ' ||
            !(@moonucd.category(c) is (Cc | Cf | Cs | Co | Cn | Zl | Zp | Zs))
          }),
        )
      }
    "isalpha" =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(!s.is_empty() && s.iter().all(is_alpha))
      }
    "isalnum" =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(!s.is_empty() && s.iter().all(is_alnum))
      }
    "isdigit" =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(!s.is_empty() && s.iter().all(is_digit))
      }
    "isdecimal" =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(
          !s.is_empty() &&
          s.iter().all(c => @moonucd.numeric(c) is Some(Decimal)),
        )
      }
    "isnumeric" =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(!s.is_empty() && s.iter().all(c => @moonucd.numeric(c) is Some(_)))
      }
    "isspace" =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(!s.is_empty() && s.iter().all(is_space))
      }
    "islower" =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(py_islower(s))
      }
    "isupper" =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(py_isupper(s))
      }
    "isascii" =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(s.iter().all(c => c.is_ascii()))
      }
    "istitle" =>
      (_, a, n) => {
        none_args(a, n, name)
        Bool(
          !s.is_empty() &&
          py_title(s) == s &&
          s.iter().any(c => @moonucd.has(c, Cased)),
        )
      }
    "isidentifier" =>
      (_, a, n) => {
        none_args(a, n, name)
        let cs = s.iter().collect()
        Bool(
          !cs.is_empty() &&
          (cs[0] == '_' || @moonucd.has(cs[0], XidStart)) &&
          cs[1:].iter().all(c => @moonucd.has(c, XidContinue)),
        )
      }
    _ => return None
  }
  Some(run)
}

///|
fn list_method(items : Array[@spec.Value], name : String) -> @spec.Func? {
  let run : @spec.Func = match name {
    "append" =>
      (_, a, _) => {
        items.push(one(a, name))
        Null
      }
    "extend" =>
      (call, a, _) => {
        for item in call.items(one(a, name)) {
          items.push(item)
        }
        Null
      }
    "insert" =>
      (_, a, _) => {
        guard a is [Int(i), x] else {
          raise @spec.invalid("insert expected an index and a value")
        }
        let n = items.length()
        let at = if i < 0 { (i.to_int() + n).max(0) } else { i.to_int().min(n) }
        items.insert(at, x)
        Null
      }
    "pop" =>
      (_, a, _) => {
        if items.is_empty() {
          raise @spec.invalid("pop from empty list")
        }
        let i = match a {
          [] => items.length() - 1
          [Int(i)] =>
            if i < 0 {
              i.to_int() + items.length()
            } else {
              i.to_int()
            }
          _ => raise @spec.invalid("pop expected at most one integer")
        }
        if i < 0 || i >= items.length() {
          raise @spec.invalid("pop index out of range")
        }
        items.remove(i)
      }
    "remove" =>
      (_, a, _) => {
        let x = one(a, name)
        match items.search(x) {
          Some(i) => {
            ignore(items.remove(i))
            Null
          }
          None => raise @spec.invalid("list.remove(x): x not in list")
        }
      }
    "index" => (_, a, _) => Int(index_items(items, a, "list"))
    "count" => (_, a, _) => Int(count_items(items, a))
    "reverse" =>
      (_, a, n) => {
        none_args(a, n, name)
        items.rev_in_place()
        Null
      }
    "copy" =>
      (_, a, n) => {
        none_args(a, n, name)
        Seq(items.copy())
      }
    "clear" =>
      (_, a, n) => {
        none_args(a, n, name)
        items.clear()
        Null
      }
    "sort" =>
      (_, a, n) => {
        if !a.is_empty() {
          raise @spec.invalid("sort takes no positional arguments")
        }
        let b = bind(name, ["reverse"], a, n)
        let ordered = sorted(items, x => x, b.flag("reverse", false))
        for i, v in ordered {
          items[i] = v
        }
        Null
      }
    _ => return None
  }
  Some(run)
}

///|
fn dict_method(fields : Map[String, @spec.Value], name : String) -> @spec.Func? {
  let key_of = fn(v : @spec.Value) { v.to_string() }
  let run : @spec.Func = match name {
    "items" =>
      (_, a, n) => {
        none_args(a, n, name)
        Seq(
          fields.iter().map(p => @spec.Value::Tuple([Text(p.0), p.1])).collect(),
        )
      }
    "keys" =>
      (_, a, n) => {
        none_args(a, n, name)
        Seq(fields.keys().map(k => @spec.Value::Text(k)).collect())
      }
    "values" =>
      (_, a, n) => {
        none_args(a, n, name)
        Seq(fields.values().collect())
      }
    "get" =>
      (_, a, _) => {
        match a {
          [k] => fields.get(key_of(k)).unwrap_or(Null)
          [k, d] => fields.get(key_of(k)).unwrap_or(d)
          _ => raise @spec.invalid("get expected one or two arguments")
        }
      }
    "pop" =>
      (_, a, _) => {
        match a {
          [k] =>
            match fields.get(key_of(k)) {
              Some(v) => {
                fields.remove(key_of(k))
                v
              }
              None => raise @spec.unknown("key", key_of(k))
            }
          [k, d] => {
            let v = fields.get(key_of(k)).unwrap_or(d)
            fields.remove(key_of(k))
            v
          }
          _ => raise @spec.invalid("pop expected one or two arguments")
        }
      }
    "setdefault" =>
      (_, a, _) => {
        let (k, d) = match a {
          [k] => (key_of(k), @spec.Value::Null)
          [k, d] => (key_of(k), d)
          _ => raise @spec.invalid("setdefault expected one or two arguments")
        }
        match fields.get(k) {
          Some(v) => v
          None => {
            fields[k] = d
            d
          }
        }
      }
    "update" =>
      (_, a, n) => {
        match a {
          [] => ()
          [Dict(other)] =>
            for k, v in other {
              fields[k] = v
            }
          [Seq(pairs) | Tuple(pairs)] =>
            for p in pairs {
              match p {
                Seq([k, v]) | Tuple([k, v]) => fields[key_of(k)] = v
                _ => raise @spec.invalid("update wants pairs")
              }
            }
          _ => raise @spec.invalid("update expected at most one mapping")
        }
        for k, v in n {
          fields[k] = v
        }
        Null
      }
    "copy" =>
      (_, a, n) => {
        none_args(a, n, name)
        Dict(fields.copy())
      }
    "clear" =>
      (_, a, n) => {
        none_args(a, n, name)
        fields.clear()
        Null
      }
    _ => return None
  }
  Some(run)
}
