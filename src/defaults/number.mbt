///|
/// A finite double as `m * 2^e` with `m` a non-negative integer, and its
/// sign.
fn exact(d : Double) -> (Bool, @bigint.BigInt, Int32) {
  let bits = d.reinterpret_as_uint64()
  let negative = bits >> 63 == 1
  let biased = ((bits >> 52) & 0x7FF).to_int()
  let fraction = bits & 0xFFFFFFFFFFFFF
  if biased == 0 {
    (negative, @bigint.BigInt::from_uint64(fraction), -1074)
  } else {
    (
      negative,
      @bigint.BigInt::from_uint64(fraction | (1UL << 52)),
      biased - 1075,
    )
  }
}

///|
fn ten_to(n : Int32) -> @bigint.BigInt {
  @bigint.BigInt::from_int(10).pow(@bigint.BigInt::from_int(n))
}

///|
/// `|d| * 10^n` rounded to an integer, half to even, from the double's
/// exact value: the rounding Python's `round` and `%f` perform.
fn scaled_half_even(d : Double, n : Int32) -> (Bool, @bigint.BigInt) {
  let (negative, m, e) = exact(d)
  let mut num = m
  let mut den = @bigint.BigInt::from_int(1)
  if e >= 0 {
    num = num.shl(e)
  } else {
    den = den.shl(-e)
  }
  if n >= 0 {
    num = num * ten_to(n)
  } else {
    den = den * ten_to(-n)
  }
  let q = num / den
  let r = num - q * den
  let twice = r.shl(1)
  let order = twice.compare(den)
  let q = if order > 0 ||
    (order == 0 && !(q % @bigint.BigInt::from_int(2)).is_zero()) {
    q + @bigint.BigInt::from_int(1)
  } else {
    q
  }
  (negative, q)
}

///|
/// Python's `round(x, n)` for a float.
fn python_round(d : Double, n : Int32) -> Double {
  if d.is_nan() || d.is_inf() || d == 0.0 {
    return d
  }
  if n > 330 {
    return d
  }
  if n < -330 {
    return if d < 0.0 { -0.0 } else { 0.0 }
  }
  let (negative, q) = scaled_half_even(d, n)
  let text = (if negative { "-" } else { "" }) +
    q.to_string() +
    "e" +
    (-n).to_string()
  let back = @string.parse_double(text) catch { _ => d }
  if back == 0.0 && negative {
    -0.0
  } else {
    back
  }
}

///|
/// `d` written with exactly `places` decimals, as Python's `%.Nf` does.
fn fixed(d : Double, places : Int32) -> String {
  if d.is_nan() {
    return "nan"
  }
  if d.is_inf() {
    return if d > 0.0 { "inf" } else { "-inf" }
  }
  let (negative, q) = scaled_half_even(d, places)
  let digits = q.to_string()
  let padded = if digits.length() <= places {
    "0".repeat(places - digits.length() + 1) + digits
  } else {
    digits
  }
  let cut = padded.length() - places
  let body = if places == 0 {
    padded
  } else {
    padded[:cut].to_owned() + "." + padded[cut:].to_owned()
  }
  (if negative { "-" } else { "" }) + body
}

///|
/// `d` in Python's `%e`: one digit, `places` decimals, an exponent of at
/// least two digits.
fn scientific(d : Double, places : Int32, upper : Bool) -> String {
  if d.is_nan() || d.is_inf() {
    let t = fixed(d, 0)
    return if upper { t.to_upper() } else { t }
  }
  let e_char = if upper { "E" } else { "e" }
  if d == 0.0 {
    let sign = if 1.0 / d < 0.0 { "-" } else { "" }
    let mantissa = if places > 0 { "0." + "0".repeat(places) } else { "0" }
    return sign + mantissa + e_char + "+00"
  }
  let (negative, m, e) = exact(d)
  let approx = (m.bit_length() - 1 + e).to_double() * 0.30102999566398120
  let mut exp = approx.floor().to_int()
  let mut q = scaled_half_even(d, places - exp).1
  if q.compare(ten_to(places + 1)) >= 0 {
    exp += 1
    q = scaled_half_even(d, places - exp).1
  } else if q.compare(ten_to(places)) < 0 {
    exp -= 1
    q = scaled_half_even(d, places - exp).1
  }
  let digits = q.to_string()
  let mantissa = if places == 0 {
    digits
  } else {
    digits[:1].to_owned() + "." + digits[1:].to_owned()
  }
  let sign_e = if exp < 0 { "-" } else { "+" }
  let abs_e = exp.abs()
  (if negative { "-" } else { "" }) +
  mantissa +
  e_char +
  sign_e +
  (if abs_e < 10 { "0" } else { "" }) +
  abs_e.to_string()
}

///|
/// Python's `%g`: `%e` or `%f` by the exponent, trailing zeros dropped
/// unless `alternate`.
fn general(
  d : Double,
  places : Int32,
  upper : Bool,
  alternate : Bool,
) -> String {
  if d.is_nan() || d.is_inf() {
    let t = fixed(d, 0)
    return if upper { t.to_upper() } else { t }
  }
  let p = if places == 0 { 1 } else { places }
  let sci = scientific(d, p - 1, upper)
  let at = sci.rev_find(if upper { "E" } else { "e" }).unwrap()
  let exp = @string.parse_int(sci[at + 1:]) catch { _ => 0 }
  let text = if exp < -4 || exp >= p {
    if alternate {
      sci
    } else {
      let mantissa = sci[:at].to_owned()
      trim_zeros(mantissa) + sci[at:].to_owned()
    }
  } else {
    let f = fixed(d, p - 1 - exp)
    if alternate {
      f
    } else {
      trim_zeros(f)
    }
  }
  text
}

///|
fn trim_zeros(s : String) -> String {
  if !s.contains(".") {
    return s
  }
  let mut end = s.length()
  while end > 0 && s[end - 1] == '0' {
    end -= 1
  }
  if end > 0 && s[end - 1] == '.' {
    end -= 1
  }
  s[:end].to_owned()
}
