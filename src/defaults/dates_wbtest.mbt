///|
/// Expected values are Python's: `tzinfo.tzname()`, Django's `O`, and
/// `timedelta.days * 86400 + timedelta.seconds`.
fn zone_row(zone : @moondate.Zone) -> String {
  "\{zone_name(zone)} \{signed_offset(zone)} \{offset_seconds(zone)}"
}

///|
test "zone names and offsets follow Python" {
  inspect(zone_row(Utc), content="UTC +0000 0")
  inspect(zone_row(Offset(330)), content="UTC+05:30 +0530 19800")
  inspect(zone_row(Offset(-300)), content="UTC-05:00 -0500 -18000")
  inspect(
    zone_row(
      Named({ name: "America/New_York", offset: -14400, abbrev: "EDT", }),
    ),
    content="EDT -0400 -14400",
  )
  inspect(
    zone_row(Named({ name: "America/New_York", offset: -17762, abbrev: "", })),
    content="UTC-04:56:02 -0456 -17762",
  )
  inspect(
    zone_row(Precise(1_172_370_000_000L)),
    content="UTC+00:19:32.370000 +0019 1172",
  )
  inspect(
    zone_row(Precise(-1_172_370_000_000L)),
    content="UTC-00:19:32.370000 -0019 -1173",
  )
}
