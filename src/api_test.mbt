// Copyright 2026 Leo Cheng
// SPDX-License-Identifier: Apache-2.0

///|
/// The whole extension surface in one file: a caller's own filter, test and
/// global, its own loader, a colliding name, the sandbox, and where a fault
/// sits in the source.
struct Shout {}

///|
impl Filter for Shout with fn filter(
  _self : Shout,
  _ctx : @moonpug.Context,
  input : @moonpug.Value,
  _pos : Array[@moonpug.Value],
  _kw : Map[String, @moonpug.Value],
) -> @moonpug.Value raise @moonpug.Fault {
  @moonpug.Value::Text(@moonpug.show(input).to_upper() + "!")
}

///|
struct Loud {}

///|
impl Test for Loud with fn probe(
  _self : Loud,
  input : @moonpug.Value,
  _pos : Array[@moonpug.Value],
) -> Bool raise @moonpug.Fault {
  @moonpug.show(input).length() > 3
}

///|
struct Ticket {}

///|
impl Global for Ticket with fn call(
  _self : Ticket,
  _ctx : @moonpug.Context,
  pos : Array[@moonpug.Value],
  _kw : Map[String, @moonpug.Value],
) -> @moonpug.Value raise @moonpug.Fault {
  // The host decides what a CSRF token is; the engine only carries it.
  @moonpug.Value::Text(
    "csrf-" +
    @moonpug.show(if pos.is_empty() { @moonpug.Value::Int(0) } else { pos[0] }),
  )
}

///|
struct Bank {}

///|
impl Loader for Bank with fn load(_self : Bank, name : String) -> String? {
  if name == "part" {
    Some("[from the bank]")
  } else {
    None
  }
}

///|
fn extended(
  filters? : Map[String, &@moonpug.Filter],
  tests? : Map[String, &@moonpug.Test],
  globals? : Map[String, &@moonpug.Global],
  loader? : &@moonpug.Loader,
  sandbox~ : Bool = false,
  autoescape~ : Bool = true,
) -> @moonpug.Settings {
  {
    ..@moonpug.preset,
    filters: match filters {
      Some(given) => given
      None => Map([])
    },
    tests: match tests {
      Some(given) => given
      None => Map([])
    },
    globals: match globals {
      Some(given) => given
      None => Map([])
    },
    loader,
    sandbox,
    autoescape,
  }
}

///|
test "a caller's own filter, test and global ride the same traits" {
  let shout : Shout = Shout::{ }
  let loud : Loud = Loud::{ }
  let ticket : Ticket = Ticket::{ }
  let out = @moonpug.render(
    "{{ 'hey'|shout }} {{ 'abcd' is loud }} {{ 'x' is not loud }} {{ ticket(7) }}",
    @json.parse("{}"),
    settings=extended(filters={ "shout": shout }, tests={ "loud": loud }, globals={
      "ticket": ticket,
    }),
  ) catch {
    fault => "F:\{fault}"
  }
  assert_eq(out, "HEY! True True csrf-7")
}

///|
test "a caller's loader feeds extends and include" {
  let bank : Bank = Bank::{ }
  let out = @moonpug.render(
    "{% include 'part' %}|{% include 'nope' ignore missing %}",
    @json.parse("{}"),
    settings=extended(loader=bank),
  ) catch {
    fault => "F:\{fault}"
  }
  assert_eq(out, "[from the bank]|")
}

///|
test "a registered name over a builtin wins by default" {
  let shout : Shout = Shout::{ }
  let out = @moonpug.render(
    "{{ 'calm'|upper }}",
    @json.parse("{}"),
    settings=extended(filters={ "upper": shout }),
  ) catch {
    fault => "F:\{fault}"
  }
  assert_eq(out, "CALM!")
}

///|
test "wins base keeps the builtin, clash panic refuses the collision" {
  let shout : Shout = Shout::{ }
  let out = @moonpug.render(
    "{{ 'calm'|upper }}",
    @json.parse("{}"),
    settings=extended(filters={ "upper": shout }),
    wins=Base,
  ) catch {
    fault => "F:\{fault}"
  }
  assert_eq(out, "CALM")
  let refused = @moonpug.render(
    "{{ 'calm'|upper }}",
    @json.parse("{}"),
    settings=extended(filters={ "upper": shout }),
    clash=Panic,
  ) catch {
    fault => "F:\{fault}"
  }
  assert_eq(refused, "F:a registered filter collides with a builtin: upper")
}

///|
test "the sandbox turns attribute access away and escaping stays on" {
  let out = @moonpug.render(
    "{{ user.name }}",
    @json.parse("{ \"user\": { \"name\": \"me\" } }"),
    settings=extended(sandbox=true),
  ) catch {
    fault => "F:\{fault}"
  }
  assert_eq(
    out, "F:sandbox: attribute access is off; use a subscript or a filter",
  )
  let kept = @moonpug.render(
    "{{ user['name'] }}|{{ evil }}",
    @json.parse("{ \"user\": { \"name\": \"me\" }, \"evil\": \"<b>\" }"),
    settings=extended(sandbox=true),
  ) catch {
    fault => "F:\{fault}"
  }
  assert_eq(kept, "me|&lt;b&gt;")
}

///|
test "a lexical fault names the template, line and column" {
  let out = @moonpug.render(
    "line one\n{% if %}",
    @json.parse("{}"),
    name="page.html",
  ) catch {
    fault => "F:\{fault}"
  }
  assert_eq(out, "F:page.html:2:7: an expression cannot start here")
}
