///|
/// What a template asks of the program around it: an address by name, the
/// prefix its static and media files sit under, a token to sign a form with,
/// and the clock. Each is a global function a template calls, and each is
/// optional: what is not given is not defined in templates.
pub(all) struct Host {
  /// `url(name, …)`: the address the program gives a route, the rest of
  /// the arguments filling it.
  url : ((String, Array[Value], Map[String, Value]) -> String raise Refused)?
  /// `static(path)`: where a static file is served from.
  asset : ((String) -> String)?
  /// `static_prefix()`: the prefix on its own.
  asset_prefix : (() -> String)?
  /// `media_prefix()`: the prefix uploaded files sit under.
  media_prefix : (() -> String)?
  /// `csrf_token()`: the token a form carries, as markup.
  csrf_token : (() -> String)?
  /// `now()`: the moment to render, as ISO 8601 text. The format letters
  /// are applied to it here, so the program only says what time it is.
  now : (() -> String)?
}

///|
/// No seam at all: templates see none of these names.
pub let host : Host = {
  url: None,
  asset: None,
  asset_prefix: None,
  media_prefix: None,
  csrf_token: None,
  now: None,
}
