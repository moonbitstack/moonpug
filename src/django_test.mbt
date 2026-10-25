///|
test "django date #0" {
  jinja(
    source="{{ v|date('a A b c d D e E f F g G h H i I j l L m M n N o O P r s S t T u w W y Y z Z \\\\Y\\\\e\\\\s') }}",
    "{\"v\": \"2026-03-05T14:07:09\"}",
    output="p.m. PM mar 2026-03-05T14:07:09 05 Thu  March 2:07 March 2 14 02 14 07 0 5 Thursday False 03 Mar 3 March 2026 +0000 2:07 p.m. Thu, 05 Mar 2026 14:07:09 +0000 09 th 31 UTC 000000 4 10 26 2026 64 0 Yes",
    autoescape=true,
  )
}

///|
test "django date #1" {
  jinja(
    source="{{ v|date }}",
    "{\"v\": \"2026-03-05T14:07:09\"}",
    output="March 5, 2026",
    autoescape=true,
  )
}

///|
test "django time #2" {
  jinja(
    source="{{ v|time('a A e f g G h H i O P s T u Z') }}",
    "{\"v\": \"2026-03-05T14:07:09\"}",
    output="p.m. PM  2:07 2 14 02 14 07 +0000 2:07 p.m. 09 UTC 000000 0",
    autoescape=true,
  )
}

///|
test "django time #3" {
  jinja(
    source="{{ v|time }}",
    "{\"v\": \"2026-03-05T14:07:09\"}",
    output="2:07 p.m.",
    autoescape=true,
  )
}

///|
test "django date #4" {
  jinja(
    source="{{ v|date('a A b c d D e E f F g G h H i I j l L m M n N o O P r s S t T u U w W y Y z Z \\\\Y\\\\e\\\\s') }}",
    "{\"v\": \"2003-10-07T23:39:05.123456+02:00\"}",
    output="p.m. PM oct 2003-10-07T21:39:05.123456+00:00 07 Tue UTC October 9:39 October 9 21 09 21 39 0 7 Tuesday False 10 Oct 10 Oct. 2003 +0000 9:39 p.m. Tue, 07 Oct 2003 21:39:05 +0000 05 th 31 UTC 123456 1065562745 2 41 03 2003 280 0 Yes",
    autoescape=true,
  )
}

///|
test "django date #5" {
  jinja(
    source="{{ v|date }}",
    "{\"v\": \"2003-10-07T23:39:05.123456+02:00\"}",
    output="Oct. 7, 2003",
    autoescape=true,
  )
}

///|
test "django time #6" {
  jinja(
    source="{{ v|time('a A e f g G h H i O P s T u Z') }}",
    "{\"v\": \"2003-10-07T23:39:05.123456+02:00\"}",
    output="p.m. PM UTC 9:39 9 21 09 21 39 +0000 9:39 p.m. 05 UTC 123456 0",
    autoescape=true,
  )
}

///|
test "django time #7" {
  jinja(
    source="{{ v|time }}",
    "{\"v\": \"2003-10-07T23:39:05.123456+02:00\"}",
    output="9:39 p.m.",
    autoescape=true,
  )
}

///|
test "django date #8" {
  jinja(
    source="{{ v|date('a A b c d D e E f F g G h H i I j l L m M n N o O P r s S t T u w W y Y z Z \\\\Y\\\\e\\\\s') }}",
    "{\"v\": \"2026-01-01T00:00:00\"}",
    output="a.m. AM jan 2026-01-01T00:00:00 01 Thu  January 12 January 12 0 12 00 00 0 1 Thursday False 01 Jan 1 Jan. 2026 +0000 midnight Thu, 01 Jan 2026 00:00:00 +0000 00 st 31 UTC 000000 4 1 26 2026 1 0 Yes",
    autoescape=true,
  )
}

///|
test "django date #9" {
  jinja(
    source="{{ v|date }}",
    "{\"v\": \"2026-01-01T00:00:00\"}",
    output="Jan. 1, 2026",
    autoescape=true,
  )
}

///|
test "django time #10" {
  jinja(
    source="{{ v|time('a A e f g G h H i O P s T u Z') }}",
    "{\"v\": \"2026-01-01T00:00:00\"}",
    output="a.m. AM  12 12 0 12 00 00 +0000 midnight 00 UTC 000000 0",
    autoescape=true,
  )
}

///|
test "django time #11" {
  jinja(
    source="{{ v|time }}",
    "{\"v\": \"2026-01-01T00:00:00\"}",
    output="midnight",
    autoescape=true,
  )
}

///|
test "django date #12" {
  jinja(
    source="{{ v|date('a A b c d D e E f F g G h H i I j l L m M n N o O P r s S t T u U w W y Y z Z \\\\Y\\\\e\\\\s') }}",
    "{\"v\": \"2026-12-21T12:00:30-05:30\"}",
    output="p.m. PM dec 2026-12-21T17:30:30+00:00 21 Mon UTC December 5:30 December 5 17 05 17 30 0 21 Monday False 12 Dec 12 Dec. 2026 +0000 5:30 p.m. Mon, 21 Dec 2026 17:30:30 +0000 30 st 31 UTC 000000 1797874230 1 52 26 2026 355 0 Yes",
    autoescape=true,
  )
}

///|
test "django date #13" {
  jinja(
    source="{{ v|date }}",
    "{\"v\": \"2026-12-21T12:00:30-05:30\"}",
    output="Dec. 21, 2026",
    autoescape=true,
  )
}

///|
test "django time #14" {
  jinja(
    source="{{ v|time('a A e f g G h H i O P s T u Z') }}",
    "{\"v\": \"2026-12-21T12:00:30-05:30\"}",
    output="p.m. PM UTC 5:30 5 17 05 17 30 +0000 5:30 p.m. 30 UTC 000000 0",
    autoescape=true,
  )
}

///|
test "django time #15" {
  jinja(
    source="{{ v|time }}",
    "{\"v\": \"2026-12-21T12:00:30-05:30\"}",
    output="5:30 p.m.",
    autoescape=true,
  )
}

///|
test "django date #16" {
  jinja(
    source="{{ v|date('D d M Y jS F z t L W o w N') }}",
    "{\"v\": \"2026-02-28\"}",
    output="Sat 28 Feb 2026 28th February 59 28 False 9 2026 6 Feb.",
    autoescape=true,
  )
}

///|
test "django date #17" {
  jinja(
    source="{{ v|date }}",
    "{\"v\": \"2026-02-28\"}",
    output="Feb. 28, 2026",
    autoescape=true,
  )
}

///|
test "django date #18" {
  jinja(
    source="{{ v|date('SHORT_DATE_FORMAT') }}",
    "{\"v\": \"2026-02-28\"}",
    output="02/28/2026",
    autoescape=true,
  )
}

///|
test "django date #19" {
  jinja(
    source="{{ v|date('DATE_FORMAT') }}",
    "{\"v\": \"2026-03-05T14:07:09\"}",
    output="March 5, 2026",
    autoescape=true,
  )
}

///|
test "django date #20" {
  jinja(
    source="{{ v|date('DATETIME_FORMAT') }}",
    "{\"v\": \"2026-03-05T14:07:09\"}",
    output="March 5, 2026, 2:07 p.m.",
    autoescape=true,
  )
}

///|
test "django date #21" {
  jinja(
    source="{{ v|date('TIME_FORMAT') }}",
    "{\"v\": \"2026-03-05T14:07:09\"}",
    output="2:07 p.m.",
    autoescape=true,
  )
}

///|
test "django date #22" {
  jinja(
    source="{{ v|date('YEAR_MONTH_FORMAT') }}",
    "{\"v\": \"2026-03-05T14:07:09\"}",
    output="March 2026",
    autoescape=true,
  )
}

///|
test "django date #23" {
  jinja(
    source="{{ v|date('MONTH_DAY_FORMAT') }}",
    "{\"v\": \"2026-03-05T14:07:09\"}",
    output="March 5",
    autoescape=true,
  )
}

///|
test "django date #24" {
  jinja(
    source="{{ v|date('SHORT_DATE_FORMAT') }}",
    "{\"v\": \"2026-03-05T14:07:09\"}",
    output="03/05/2026",
    autoescape=true,
  )
}

///|
test "django date #25" {
  jinja(
    source="{{ v|date('SHORT_DATETIME_FORMAT') }}",
    "{\"v\": \"2026-03-05T14:07:09\"}",
    output="03/05/2026 2:07 p.m.",
    autoescape=true,
  )
}

///|
test "django date #26" {
  jinja(
    source="{{ v|date('jS N b P') }}",
    "{\"v\": \"2026-03-01T00:00:00\"}",
    output="1st March mar midnight",
    autoescape=true,
  )
}

///|
test "django date #27" {
  jinja(
    source="{{ v|date('jS N b P') }}",
    "{\"v\": \"2026-03-02T00:00:00\"}",
    output="2nd March mar midnight",
    autoescape=true,
  )
}

///|
test "django date #28" {
  jinja(
    source="{{ v|date('jS N b P') }}",
    "{\"v\": \"2026-03-03T00:00:00\"}",
    output="3rd March mar midnight",
    autoescape=true,
  )
}

///|
test "django date #29" {
  jinja(
    source="{{ v|date('jS N b P') }}",
    "{\"v\": \"2026-03-11T00:00:00\"}",
    output="11th March mar midnight",
    autoescape=true,
  )
}

///|
test "django date #30" {
  jinja(
    source="{{ v|date('jS N b P') }}",
    "{\"v\": \"2026-03-22T00:00:00\"}",
    output="22nd March mar midnight",
    autoescape=true,
  )
}

///|
test "django date #31" {
  jinja(
    source="{{ v|date('jS N b P') }}",
    "{\"v\": \"2026-03-23T00:00:00\"}",
    output="23rd March mar midnight",
    autoescape=true,
  )
}

///|
test "django date #32" {
  jinja(
    source="{{ v|date('jS N b P') }}",
    "{\"v\": \"2026-03-31T00:00:00\"}",
    output="31st March mar midnight",
    autoescape=true,
  )
}

///|
test "django date #33" {
  jinja(
    source="{{ v|date('jS N b P') }}",
    "{\"v\": \"2024-02-29T00:00:00\"}",
    output="29th Feb. feb midnight",
    autoescape=true,
  )
}

///|
test "django date #34" {
  jinja(
    source="{{ v|date('jS N b P') }}",
    "{\"v\": \"2026-09-07T00:00:00\"}",
    output="7th Sept. sep midnight",
    autoescape=true,
  )
}

///|
test "django date #35" {
  jinja(
    source="{{ v|date('jS N b P') }}",
    "{\"v\": \"2026-11-30T00:00:00\"}",
    output="30th Nov. nov midnight",
    autoescape=true,
  )
}

///|
test "django time #36" {
  jinja(
    source="{{ v|time('P f g A') }}",
    "{\"v\": \"2026-03-05T00:00:00\"}",
    output="midnight 12 12 AM",
    autoescape=true,
  )
}

///|
test "django time #37" {
  jinja(
    source="{{ v|time('P f g A') }}",
    "{\"v\": \"2026-03-05T12:00:00\"}",
    output="noon 12 12 PM",
    autoescape=true,
  )
}

///|
test "django time #38" {
  jinja(
    source="{{ v|time('P f g A') }}",
    "{\"v\": \"2026-03-05T00:30:00\"}",
    output="12:30 a.m. 12:30 12 AM",
    autoescape=true,
  )
}

///|
test "django time #39" {
  jinja(
    source="{{ v|time('P f g A') }}",
    "{\"v\": \"2026-03-05T12:05:00\"}",
    output="12:05 p.m. 12:05 12 PM",
    autoescape=true,
  )
}

///|
test "django time #40" {
  jinja(
    source="{{ v|time('P f g A') }}",
    "{\"v\": \"2026-03-05T13:45:00\"}",
    output="1:45 p.m. 1:45 1 PM",
    autoescape=true,
  )
}

///|
test "django time #41" {
  jinja(
    source="{{ v|time('P f g A') }}",
    "{\"v\": \"2026-03-05T23:59:00\"}",
    output="11:59 p.m. 11:59 11 PM",
    autoescape=true,
  )
}

///|
test "django time #42" {
  jinja(
    source="{{ v|time('P f g A') }}",
    "{\"v\": \"2026-03-05T11:00:00\"}",
    output="11 a.m. 11 11 AM",
    autoescape=true,
  )
}

///|
test "django date #43" {
  jinja(source="{{ v|date }}", "{\"v\": \"\"}", output="", autoescape=true)
}

///|
test "django date #44" {
  jinja(source="{{ v|date }}", "{\"v\": null}", output="", autoescape=true)
}

///|
test "django time #45" {
  jinja(source="{{ v|time }}", "{\"v\": \"\"}", output="", autoescape=true)
}

///|
test "django timesince #46" {
  jinja(
    source="{{ v|timesince(w) }}",
    "{\"v\": \"2026-01-01T00:00:00\", \"w\": \"2026-05-17T09:30:00\"}",
    output="4 months, 2 weeks",
    autoescape=true,
  )
}

///|
test "django timeuntil #47" {
  jinja(
    source="{{ v|timeuntil(w) }}",
    "{\"v\": \"2026-05-17T09:30:00\", \"w\": \"2026-01-01T00:00:00\"}",
    output="4 months, 2 weeks",
    autoescape=true,
  )
}

///|
test "django timesince #48" {
  jinja(
    source="{{ v|timesince(w) }}",
    "{\"v\": \"2025-05-17T09:30:00\", \"w\": \"2026-05-17T09:30:00\"}",
    output="1 year",
    autoescape=true,
  )
}

///|
test "django timeuntil #49" {
  jinja(
    source="{{ v|timeuntil(w) }}",
    "{\"v\": \"2026-05-17T09:30:00\", \"w\": \"2025-05-17T09:30:00\"}",
    output="1 year",
    autoescape=true,
  )
}

///|
test "django timesince #50" {
  jinja(
    source="{{ v|timesince(w) }}",
    "{\"v\": \"2026-05-10T09:30:00\", \"w\": \"2026-05-17T09:30:00\"}",
    output="1 week",
    autoescape=true,
  )
}

///|
test "django timeuntil #51" {
  jinja(
    source="{{ v|timeuntil(w) }}",
    "{\"v\": \"2026-05-17T09:30:00\", \"w\": \"2026-05-10T09:30:00\"}",
    output="1 week",
    autoescape=true,
  )
}

///|
test "django timesince #52" {
  jinja(
    source="{{ v|timesince(w) }}",
    "{\"v\": \"2026-05-17T09:29:00\", \"w\": \"2026-05-17T09:30:00\"}",
    output="1 minute",
    autoescape=true,
  )
}

///|
test "django timeuntil #53" {
  jinja(
    source="{{ v|timeuntil(w) }}",
    "{\"v\": \"2026-05-17T09:30:00\", \"w\": \"2026-05-17T09:29:00\"}",
    output="1 minute",
    autoescape=true,
  )
}

///|
test "django timesince #54" {
  jinja(
    source="{{ v|timesince(w) }}",
    "{\"v\": \"2026-05-17T08:00:00\", \"w\": \"2026-05-17T09:30:00\"}",
    output="1 hour, 30 minutes",
    autoescape=true,
  )
}

///|
test "django timeuntil #55" {
  jinja(
    source="{{ v|timeuntil(w) }}",
    "{\"v\": \"2026-05-17T09:30:00\", \"w\": \"2026-05-17T08:00:00\"}",
    output="1 hour, 30 minutes",
    autoescape=true,
  )
}

///|
test "django timesince #56" {
  jinja(
    source="{{ v|timesince(w) }}",
    "{\"v\": \"2026-05-17T09:30:00\", \"w\": \"2026-01-01T00:00:00\"}",
    output="0 minutes",
    autoescape=true,
  )
}

///|
test "django timeuntil #57" {
  jinja(
    source="{{ v|timeuntil(w) }}",
    "{\"v\": \"2026-01-01T00:00:00\", \"w\": \"2026-05-17T09:30:00\"}",
    output="0 minutes",
    autoescape=true,
  )
}

///|
test "django timesince #58" {
  jinja(
    source="{{ v|timesince(w) }}",
    "{\"v\": \"2013-02-10T00:00:00\", \"w\": \"2014-03-10T00:00:00\"}",
    output="1 year, 1 month",
    autoescape=true,
  )
}

///|
test "django timeuntil #59" {
  jinja(
    source="{{ v|timeuntil(w) }}",
    "{\"v\": \"2014-03-10T00:00:00\", \"w\": \"2013-02-10T00:00:00\"}",
    output="1 year, 1 month",
    autoescape=true,
  )
}

///|
test "django timesince #60" {
  jinja(
    source="{{ v|timesince(w) }}",
    "{\"v\": \"2007-08-10T00:00:00\", \"w\": \"2008-09-10T00:00:00\"}",
    output="1 year, 1 month",
    autoescape=true,
  )
}

///|
test "django timeuntil #61" {
  jinja(
    source="{{ v|timeuntil(w) }}",
    "{\"v\": \"2008-09-10T00:00:00\", \"w\": \"2007-08-10T00:00:00\"}",
    output="1 year, 1 month",
    autoescape=true,
  )
}

///|
test "django timesince #62" {
  jinja(
    source="{{ v|timesince(w) }}",
    "{\"v\": \"2026-01-31T10:00:00\", \"w\": \"2026-03-01T09:00:00\"}",
    output="1 month",
    autoescape=true,
  )
}

///|
test "django timeuntil #63" {
  jinja(
    source="{{ v|timeuntil(w) }}",
    "{\"v\": \"2026-03-01T09:00:00\", \"w\": \"2026-01-31T10:00:00\"}",
    output="1 month",
    autoescape=true,
  )
}

///|
test "django timesince #64" {
  jinja(
    source="{{ v|timesince(w) }}",
    "{\"v\": \"2003-10-07T23:39:05.123456+02:00\", \"w\": \"2028-03-10T15:00:00+02:00\"}",
    output="24 years, 5 months",
    autoescape=true,
  )
}

///|
test "django timeuntil #65" {
  jinja(
    source="{{ v|timeuntil(w) }}",
    "{\"v\": \"2028-03-10T15:00:00+02:00\", \"w\": \"2003-10-07T23:39:05.123456+02:00\"}",
    output="24 years, 5 months",
    autoescape=true,
  )
}

///|
test "django timesince #66" {
  jinja(
    source="{{ v|timesince(w) }}",
    "{\"v\": \"2026-02-28\", \"w\": \"2026-05-01\"}",
    output="2 months",
    autoescape=true,
  )
}

///|
test "django timeuntil #67" {
  jinja(
    source="{{ v|timeuntil(w) }}",
    "{\"v\": \"2026-05-01\", \"w\": \"2026-02-28\"}",
    output="2 months",
    autoescape=true,
  )
}

///|
test "django add #68" {
  jinja(source="{{ v|add(3) }}", "{\"v\": 2}", output="5", autoescape=true)
}

///|
test "django add #69" {
  jinja(
    source="{{ v|add('3') }}",
    "{\"v\": \"2\"}",
    output="5",
    autoescape=true,
  )
}

///|
test "django add #70" {
  jinja(
    source="{{ v|add('b') }}",
    "{\"v\": \"a\"}",
    output="ab",
    autoescape=true,
  )
}

///|
test "django add #71" {
  jinja(source="{{ v|add(1) }}", "{\"v\": 2.7}", output="3", autoescape=true)
}

///|
test "django add #72" {
  jinja(source="{{ v|add(1) }}", "{\"v\": \"2.5\"}", output="", autoescape=true)
}

///|
test "django add #73" {
  jinja(source="{{ v|add(1) }}", "{\"v\": \"x\"}", output="", autoescape=true)
}

///|
test "django add #74" {
  jinja(source="{{ v|add(1) }}", "{\"v\": true}", output="2", autoescape=true)
}

///|
test "django addslashes #75" {
  jinja(
    source="{{ v|addslashes }}",
    "{\"v\": \"I'm \\\"here\\\" \\\\ ok\"}",
    output="I\\&#39;m \\&#34;here\\&#34; \\\\ ok",
    autoescape=true,
  )
}

///|
test "django capfirst #76" {
  jinja(
    source="{{ v|capfirst }}",
    "{\"v\": \"hello world\"}",
    output="Hello world",
    autoescape=true,
  )
}

///|
test "django capfirst #77" {
  jinja(
    source="{{ v|capfirst }}",
    "{\"v\": \"ßtraße\"}",
    output="SStraße",
    autoescape=true,
  )
}

///|
test "django capfirst #78" {
  jinja(source="{{ v|capfirst }}", "{\"v\": \"\"}", output="", autoescape=true)
}

///|
test "django cut #79" {
  jinja(
    source="{{ v|cut(' ') }}",
    "{\"v\": \"a b c\"}",
    output="abc",
    autoescape=true,
  )
}

///|
test "django cut #80" {
  jinja(
    source="{{ v|cut(';') }}",
    "{\"v\": \"a;b\"}",
    output="ab",
    autoescape=true,
  )
}

///|
test "django default_if_none #81" {
  jinja(
    source="{{ v|default_if_none('x') }}",
    "{\"v\": null}",
    output="x",
    autoescape=true,
  )
}

///|
test "django default_if_none #82" {
  jinja(
    source="{{ v|default_if_none('x') }}",
    "{\"v\": \"\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django default_if_none #83" {
  jinja(
    source="{{ v|default_if_none('x') }}",
    "{\"v\": 0}",
    output="0",
    autoescape=true,
  )
}

///|
test "django escapejs #84" {
  jinja(
    source="{{ v|escapejs }}",
    "{\"v\": \"a'b\\\"c<d>&=-;`  \\u0001\\\\é\"}",
    output="a\\u0027b\\u0022c\\u003Cd\\u003E\\u0026\\u003D\\u002D\\u003B\\u0060\\u2028\\u2029\\u0001\\u007F\\u009F\\u005Cé",
    autoescape=true,
  )
}

///|
test "django get_digit #85" {
  jinja(
    source="{{ v|get_digit(2) }}",
    "{\"v\": 12345}",
    output="4",
    autoescape=true,
  )
}

///|
test "django get_digit #86" {
  jinja(
    source="{{ v|get_digit(1) }}",
    "{\"v\": 12345}",
    output="5",
    autoescape=true,
  )
}

///|
test "django get_digit #87" {
  jinja(
    source="{{ v|get_digit(9) }}",
    "{\"v\": 12345}",
    output="0",
    autoescape=true,
  )
}

///|
test "django get_digit #88" {
  jinja(
    source="{{ v|get_digit(0) }}",
    "{\"v\": 12345}",
    output="12345",
    autoescape=true,
  )
}

///|
test "django get_digit #89" {
  jinja(
    source="{{ v|get_digit(1) }}",
    "{\"v\": \"x\"}",
    output="x",
    autoescape=true,
  )
}

///|
test "django get_digit #90" {
  jinja(
    source="{{ v|get_digit('a') }}",
    "{\"v\": 123}",
    output="123",
    autoescape=true,
  )
}

///|
test "django iriencode #91" {
  jinja(
    source="{{ v|iriencode }}",
    "{\"v\": \"/a b&c?d=é#f%20\"}",
    output="/a%20b&amp;c?d=%C3%A9#f%20",
    autoescape=true,
  )
}

///|
test "django json_script #92" {
  jinja(
    source="{{ v|json_script('d') }}",
    "{\"v\": {\"a\": 1, \"b\": \"<x>&\", \"c\": [1, 2.5, null, true]}}",
    output="<script id=\"d\" type=\"application/json\">{\"a\": 1, \"b\": \"\\u003Cx\\u003E\\u0026\", \"c\": [1, 2.5, null, true]}</script>",
    autoescape=true,
  )
}

///|
test "django json_script #93" {
  jinja(
    source="{{ v|json_script }}",
    "{\"v\": {\"z\": 1, \"a\": 2}}",
    output="<script type=\"application/json\">{\"z\": 1, \"a\": 2}</script>",
    autoescape=true,
  )
}

///|
test "django json_script #94" {
  jinja(
    source="{{ v|json_script('data') }}",
    "{\"v\": [1, \"x\"]}",
    output="<script id=\"data\" type=\"application/json\">[1, \"x\"]</script>",
    autoescape=true,
  )
}

///|
test "django linebreaks #95" {
  jinja(
    source="{{ v|linebreaks }}",
    "{\"v\": \"a\\n\\nb\\nc\\r\\n\\r\\n\\r\\nd<e>\"}",
    output="<p>a</p>\n\n<p>b<br>c</p>\n\n<p>d&lt;e&gt;</p>",
    autoescape=true,
  )
}

///|
test "django linebreaksbr #96" {
  jinja(
    source="{{ v|linebreaksbr }}",
    "{\"v\": \"a\\nb<c>\\r\\nd\"}",
    output="a<br>b&lt;c&gt;<br>d",
    autoescape=true,
  )
}

///|
test "django linenumbers #97" {
  jinja(
    source="{{ v|linenumbers }}",
    "{\"v\": \"line<0>\\nline<1>\\nline<2>\\nline<3>\\nline<4>\\nline<5>\\nline<6>\\nline<7>\\nline<8>\\nline<9>\\nline<10>\\nline<11>\"}",
    output="01. line&lt;0&gt;\n02. line&lt;1&gt;\n03. line&lt;2&gt;\n04. line&lt;3&gt;\n05. line&lt;4&gt;\n06. line&lt;5&gt;\n07. line&lt;6&gt;\n08. line&lt;7&gt;\n09. line&lt;8&gt;\n10. line&lt;9&gt;\n11. line&lt;10&gt;\n12. line&lt;11&gt;",
    autoescape=true,
  )
}

///|
test "django ljust #98" {
  jinja(
    source="{{ v|ljust(5) }}",
    "{\"v\": \"ab\"}",
    output="ab   ",
    autoescape=true,
  )
}

///|
test "django rjust #99" {
  jinja(
    source="{{ v|rjust(5) }}",
    "{\"v\": \"ab\"}",
    output="   ab",
    autoescape=true,
  )
}

///|
test "django ljust #100" {
  jinja(
    source="{{ v|ljust(3) }}",
    "{\"v\": \"abcdef\"}",
    output="abcdef",
    autoescape=true,
  )
}

///|
test "django phone2numeric #101" {
  jinja(
    source="{{ v|phone2numeric }}",
    "{\"v\": \"1-800-COLLECT\"}",
    output="1-800-2655328",
    autoescape=true,
  )
}

///|
test "django pluralize #102" {
  jinja(source="{{ v|pluralize }}", "{\"v\": 0}", output="s", autoescape=true)
}

///|
test "django pluralize #103" {
  jinja(source="{{ v|pluralize }}", "{\"v\": 1}", output="", autoescape=true)
}

///|
test "django pluralize #104" {
  jinja(source="{{ v|pluralize }}", "{\"v\": 2}", output="s", autoescape=true)
}

///|
test "django pluralize #105" {
  jinja(source="{{ v|pluralize }}", "{\"v\": 1.0}", output="", autoescape=true)
}

///|
test "django pluralize #106" {
  jinja(source="{{ v|pluralize }}", "{\"v\": 1.5}", output="s", autoescape=true)
}

///|
test "django pluralize #107" {
  jinja(
    source="{{ v|pluralize }}",
    "{\"v\": \"1\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django pluralize #108" {
  jinja(
    source="{{ v|pluralize }}",
    "{\"v\": \"2\"}",
    output="s",
    autoescape=true,
  )
}

///|
test "django pluralize #109" {
  jinja(
    source="{{ v|pluralize }}",
    "{\"v\": \"x\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django pluralize #110" {
  jinja(source="{{ v|pluralize }}", "{\"v\": [1]}", output="", autoescape=true)
}

///|
test "django pluralize #111" {
  jinja(
    source="{{ v|pluralize }}",
    "{\"v\": [1, 2]}",
    output="s",
    autoescape=true,
  )
}

///|
test "django pluralize #112" {
  jinja(source="{{ v|pluralize }}", "{\"v\": []}", output="s", autoescape=true)
}

///|
test "django pluralize #113" {
  jinja(
    source="{{ v|pluralize('es') }}",
    "{\"v\": 1}",
    output="",
    autoescape=true,
  )
}

///|
test "django pluralize #114" {
  jinja(
    source="{{ v|pluralize('es') }}",
    "{\"v\": 2}",
    output="es",
    autoescape=true,
  )
}

///|
test "django pluralize #115" {
  jinja(
    source="{{ v|pluralize('y,ies') }}",
    "{\"v\": 1}",
    output="y",
    autoescape=true,
  )
}

///|
test "django pluralize #116" {
  jinja(
    source="{{ v|pluralize('y,ies') }}",
    "{\"v\": 2}",
    output="ies",
    autoescape=true,
  )
}

///|
test "django pluralize #117" {
  jinja(
    source="{{ v|pluralize('a,b,c') }}",
    "{\"v\": 2}",
    output="",
    autoescape=true,
  )
}

///|
test "django truncatewords #118" {
  jinja(
    source="{{ v|truncatewords(2) }}",
    "{\"v\": \"one two three four\"}",
    output="one two …",
    autoescape=true,
  )
}

///|
test "django truncatewords #119" {
  jinja(
    source="{{ v|truncatewords(5) }}",
    "{\"v\": \"one  two\\nthree\"}",
    output="one two three",
    autoescape=true,
  )
}

///|
test "django truncatewords #120" {
  jinja(
    source="{{ v|truncatewords(0) }}",
    "{\"v\": \"one two\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django truncatewords #121" {
  jinja(
    source="{{ v|truncatewords('x') }}",
    "{\"v\": \"one two\"}",
    output="one two",
    autoescape=true,
  )
}

///|
test "django unordered_list #122" {
  jinja(
    source="{{ v|unordered_list }}",
    "{\"v\": [\"a\", [\"b\", \"c\", [\"d\"]], \"e<f>\"]}",
    output="\t<li>a\n\t<ul>\n\t\t<li>b</li>\n\t\t<li>c\n\t\t<ul>\n\t\t\t<li>d</li>\n\t\t</ul>\n\t\t</li>\n\t</ul>\n\t</li>\n\t<li>e&lt;f&gt;</li>",
    autoescape=true,
  )
}

///|
test "django unordered_list #123" {
  jinja(
    source="{{ v|unordered_list }}",
    "{\"v\": [\"x\"]}",
    output="\t<li>x</li>",
    autoescape=true,
  )
}

///|
test "django yesno #124" {
  jinja(source="{{ v|yesno }}", "{\"v\": true}", output="yes", autoescape=true)
}

///|
test "django yesno #125" {
  jinja(source="{{ v|yesno }}", "{\"v\": false}", output="no", autoescape=true)
}

///|
test "django yesno #126" {
  jinja(
    source="{{ v|yesno }}",
    "{\"v\": null}",
    output="maybe",
    autoescape=true,
  )
}

///|
test "django yesno #127" {
  jinja(source="{{ v|yesno }}", "{\"v\": 0}", output="no", autoescape=true)
}

///|
test "django yesno #128" {
  jinja(source="{{ v|yesno }}", "{\"v\": \"x\"}", output="yes", autoescape=true)
}

///|
test "django yesno #129" {
  jinja(
    source="{{ v|yesno('yep,nope,shrug') }}",
    "{\"v\": false}",
    output="nope",
    autoescape=true,
  )
}

///|
test "django yesno #130" {
  jinja(
    source="{{ v|yesno('yep,nope') }}",
    "{\"v\": null}",
    output="nope",
    autoescape=true,
  )
}

///|
test "django yesno #131" {
  jinja(
    source="{{ v|yesno('only') }}",
    "{\"v\": true}",
    output="True",
    autoescape=true,
  )
}

///|
test "django floatformat #132" {
  jinja(
    source="{{ v|floatformat }}",
    "{\"v\": 34.23234}",
    output="34.2",
    autoescape=true,
  )
}

///|
test "django floatformat #133" {
  jinja(
    source="{{ v|floatformat(3) }}",
    "{\"v\": 34.23234}",
    output="34.232",
    autoescape=true,
  )
}

///|
test "django floatformat #134" {
  jinja(
    source="{{ v|floatformat('3') }}",
    "{\"v\": 34.23234}",
    output="34.232",
    autoescape=true,
  )
}

///|
test "django floatformat #135" {
  jinja(
    source="{{ v|floatformat(0) }}",
    "{\"v\": 34.23234}",
    output="34",
    autoescape=true,
  )
}

///|
test "django floatformat #136" {
  jinja(
    source="{{ v|floatformat('0') }}",
    "{\"v\": 34.23234}",
    output="34",
    autoescape=true,
  )
}

///|
test "django floatformat #137" {
  jinja(
    source="{{ v|floatformat(-3) }}",
    "{\"v\": 34.23234}",
    output="34.232",
    autoescape=true,
  )
}

///|
test "django floatformat #138" {
  jinja(
    source="{{ v|floatformat('-3') }}",
    "{\"v\": 34.23234}",
    output="34.232",
    autoescape=true,
  )
}

///|
test "django floatformat #139" {
  jinja(
    source="{{ v|floatformat('2g') }}",
    "{\"v\": 34.23234}",
    output="34.23",
    autoescape=true,
  )
}

///|
test "django floatformat #140" {
  jinja(
    source="{{ v|floatformat('-2g') }}",
    "{\"v\": 34.23234}",
    output="34.23",
    autoescape=true,
  )
}

///|
test "django floatformat #141" {
  jinja(
    source="{{ v|floatformat('2u') }}",
    "{\"v\": 34.23234}",
    output="34.23",
    autoescape=true,
  )
}

///|
test "django floatformat #142" {
  jinja(
    source="{{ v|floatformat('2gu') }}",
    "{\"v\": 34.23234}",
    output="34.23",
    autoescape=true,
  )
}

///|
test "django floatformat #143" {
  jinja(
    source="{{ v|floatformat }}",
    "{\"v\": 34.0}",
    output="34",
    autoescape=true,
  )
}

///|
test "django floatformat #144" {
  jinja(
    source="{{ v|floatformat(3) }}",
    "{\"v\": 34.0}",
    output="34.000",
    autoescape=true,
  )
}

///|
test "django floatformat #145" {
  jinja(
    source="{{ v|floatformat('3') }}",
    "{\"v\": 34.0}",
    output="34.000",
    autoescape=true,
  )
}

///|
test "django floatformat #146" {
  jinja(
    source="{{ v|floatformat(0) }}",
    "{\"v\": 34.0}",
    output="34",
    autoescape=true,
  )
}

///|
test "django floatformat #147" {
  jinja(
    source="{{ v|floatformat('0') }}",
    "{\"v\": 34.0}",
    output="34",
    autoescape=true,
  )
}

///|
test "django floatformat #148" {
  jinja(
    source="{{ v|floatformat(-3) }}",
    "{\"v\": 34.0}",
    output="34",
    autoescape=true,
  )
}

///|
test "django floatformat #149" {
  jinja(
    source="{{ v|floatformat('-3') }}",
    "{\"v\": 34.0}",
    output="34",
    autoescape=true,
  )
}

///|
test "django floatformat #150" {
  jinja(
    source="{{ v|floatformat('2g') }}",
    "{\"v\": 34.0}",
    output="34.00",
    autoescape=true,
  )
}

///|
test "django floatformat #151" {
  jinja(
    source="{{ v|floatformat('-2g') }}",
    "{\"v\": 34.0}",
    output="34",
    autoescape=true,
  )
}

///|
test "django floatformat #152" {
  jinja(
    source="{{ v|floatformat('2u') }}",
    "{\"v\": 34.0}",
    output="34.00",
    autoescape=true,
  )
}

///|
test "django floatformat #153" {
  jinja(
    source="{{ v|floatformat('2gu') }}",
    "{\"v\": 34.0}",
    output="34.00",
    autoescape=true,
  )
}

///|
test "django floatformat #154" {
  jinja(
    source="{{ v|floatformat }}",
    "{\"v\": 34.26}",
    output="34.3",
    autoescape=true,
  )
}

///|
test "django floatformat #155" {
  jinja(
    source="{{ v|floatformat(3) }}",
    "{\"v\": 34.26}",
    output="34.260",
    autoescape=true,
  )
}

///|
test "django floatformat #156" {
  jinja(
    source="{{ v|floatformat('3') }}",
    "{\"v\": 34.26}",
    output="34.260",
    autoescape=true,
  )
}

///|
test "django floatformat #157" {
  jinja(
    source="{{ v|floatformat(0) }}",
    "{\"v\": 34.26}",
    output="34",
    autoescape=true,
  )
}

///|
test "django floatformat #158" {
  jinja(
    source="{{ v|floatformat('0') }}",
    "{\"v\": 34.26}",
    output="34",
    autoescape=true,
  )
}

///|
test "django floatformat #159" {
  jinja(
    source="{{ v|floatformat(-3) }}",
    "{\"v\": 34.26}",
    output="34.260",
    autoescape=true,
  )
}

///|
test "django floatformat #160" {
  jinja(
    source="{{ v|floatformat('-3') }}",
    "{\"v\": 34.26}",
    output="34.260",
    autoescape=true,
  )
}

///|
test "django floatformat #161" {
  jinja(
    source="{{ v|floatformat('2g') }}",
    "{\"v\": 34.26}",
    output="34.26",
    autoescape=true,
  )
}

///|
test "django floatformat #162" {
  jinja(
    source="{{ v|floatformat('-2g') }}",
    "{\"v\": 34.26}",
    output="34.26",
    autoescape=true,
  )
}

///|
test "django floatformat #163" {
  jinja(
    source="{{ v|floatformat('2u') }}",
    "{\"v\": 34.26}",
    output="34.26",
    autoescape=true,
  )
}

///|
test "django floatformat #164" {
  jinja(
    source="{{ v|floatformat('2gu') }}",
    "{\"v\": 34.26}",
    output="34.26",
    autoescape=true,
  )
}

///|
test "django floatformat #165" {
  jinja(
    source="{{ v|floatformat }}",
    "{\"v\": 0.5}",
    output="0.5",
    autoescape=true,
  )
}

///|
test "django floatformat #166" {
  jinja(
    source="{{ v|floatformat(3) }}",
    "{\"v\": 0.5}",
    output="0.500",
    autoescape=true,
  )
}

///|
test "django floatformat #167" {
  jinja(
    source="{{ v|floatformat('3') }}",
    "{\"v\": 0.5}",
    output="0.500",
    autoescape=true,
  )
}

///|
test "django floatformat #168" {
  jinja(
    source="{{ v|floatformat(0) }}",
    "{\"v\": 0.5}",
    output="1",
    autoescape=true,
  )
}

///|
test "django floatformat #169" {
  jinja(
    source="{{ v|floatformat('0') }}",
    "{\"v\": 0.5}",
    output="1",
    autoescape=true,
  )
}

///|
test "django floatformat #170" {
  jinja(
    source="{{ v|floatformat(-3) }}",
    "{\"v\": 0.5}",
    output="0.500",
    autoescape=true,
  )
}

///|
test "django floatformat #171" {
  jinja(
    source="{{ v|floatformat('-3') }}",
    "{\"v\": 0.5}",
    output="0.500",
    autoescape=true,
  )
}

///|
test "django floatformat #172" {
  jinja(
    source="{{ v|floatformat('2g') }}",
    "{\"v\": 0.5}",
    output="0.50",
    autoescape=true,
  )
}

///|
test "django floatformat #173" {
  jinja(
    source="{{ v|floatformat('-2g') }}",
    "{\"v\": 0.5}",
    output="0.50",
    autoescape=true,
  )
}

///|
test "django floatformat #174" {
  jinja(
    source="{{ v|floatformat('2u') }}",
    "{\"v\": 0.5}",
    output="0.50",
    autoescape=true,
  )
}

///|
test "django floatformat #175" {
  jinja(
    source="{{ v|floatformat('2gu') }}",
    "{\"v\": 0.5}",
    output="0.50",
    autoescape=true,
  )
}

///|
test "django floatformat #176" {
  jinja(
    source="{{ v|floatformat }}",
    "{\"v\": -0.4}",
    output="-0.4",
    autoescape=true,
  )
}

///|
test "django floatformat #177" {
  jinja(
    source="{{ v|floatformat(3) }}",
    "{\"v\": -0.4}",
    output="-0.400",
    autoescape=true,
  )
}

///|
test "django floatformat #178" {
  jinja(
    source="{{ v|floatformat('3') }}",
    "{\"v\": -0.4}",
    output="-0.400",
    autoescape=true,
  )
}

///|
test "django floatformat #179" {
  jinja(
    source="{{ v|floatformat(0) }}",
    "{\"v\": -0.4}",
    output="0",
    autoescape=true,
  )
}

///|
test "django floatformat #180" {
  jinja(
    source="{{ v|floatformat('0') }}",
    "{\"v\": -0.4}",
    output="0",
    autoescape=true,
  )
}

///|
test "django floatformat #181" {
  jinja(
    source="{{ v|floatformat(-3) }}",
    "{\"v\": -0.4}",
    output="-0.400",
    autoescape=true,
  )
}

///|
test "django floatformat #182" {
  jinja(
    source="{{ v|floatformat('-3') }}",
    "{\"v\": -0.4}",
    output="-0.400",
    autoescape=true,
  )
}

///|
test "django floatformat #183" {
  jinja(
    source="{{ v|floatformat('2g') }}",
    "{\"v\": -0.4}",
    output="-0.40",
    autoescape=true,
  )
}

///|
test "django floatformat #184" {
  jinja(
    source="{{ v|floatformat('-2g') }}",
    "{\"v\": -0.4}",
    output="-0.40",
    autoescape=true,
  )
}

///|
test "django floatformat #185" {
  jinja(
    source="{{ v|floatformat('2u') }}",
    "{\"v\": -0.4}",
    output="-0.40",
    autoescape=true,
  )
}

///|
test "django floatformat #186" {
  jinja(
    source="{{ v|floatformat('2gu') }}",
    "{\"v\": -0.4}",
    output="-0.40",
    autoescape=true,
  )
}

///|
test "django floatformat #187" {
  jinja(
    source="{{ v|floatformat }}",
    "{\"v\": 1234567.891}",
    output="1234567.9",
    autoescape=true,
  )
}

///|
test "django floatformat #188" {
  jinja(
    source="{{ v|floatformat(3) }}",
    "{\"v\": 1234567.891}",
    output="1234567.891",
    autoescape=true,
  )
}

///|
test "django floatformat #189" {
  jinja(
    source="{{ v|floatformat('3') }}",
    "{\"v\": 1234567.891}",
    output="1234567.891",
    autoescape=true,
  )
}

///|
test "django floatformat #190" {
  jinja(
    source="{{ v|floatformat(0) }}",
    "{\"v\": 1234567.891}",
    output="1234568",
    autoescape=true,
  )
}

///|
test "django floatformat #191" {
  jinja(
    source="{{ v|floatformat('0') }}",
    "{\"v\": 1234567.891}",
    output="1234568",
    autoescape=true,
  )
}

///|
test "django floatformat #192" {
  jinja(
    source="{{ v|floatformat(-3) }}",
    "{\"v\": 1234567.891}",
    output="1234567.891",
    autoescape=true,
  )
}

///|
test "django floatformat #193" {
  jinja(
    source="{{ v|floatformat('-3') }}",
    "{\"v\": 1234567.891}",
    output="1234567.891",
    autoescape=true,
  )
}

///|
test "django floatformat #194" {
  jinja(
    source="{{ v|floatformat('2g') }}",
    "{\"v\": 1234567.891}",
    output="1,234,567.89",
    autoescape=true,
  )
}

///|
test "django floatformat #195" {
  jinja(
    source="{{ v|floatformat('-2g') }}",
    "{\"v\": 1234567.891}",
    output="1,234,567.89",
    autoescape=true,
  )
}

///|
test "django floatformat #196" {
  jinja(
    source="{{ v|floatformat('2u') }}",
    "{\"v\": 1234567.891}",
    output="1234567.89",
    autoescape=true,
  )
}

///|
test "django floatformat #197" {
  jinja(
    source="{{ v|floatformat('2gu') }}",
    "{\"v\": 1234567.891}",
    output="1234567.89",
    autoescape=true,
  )
}

///|
test "django floatformat #198" {
  jinja(
    source="{{ v|floatformat }}",
    "{\"v\": \"34.5\"}",
    output="34.5",
    autoescape=true,
  )
}

///|
test "django floatformat #199" {
  jinja(
    source="{{ v|floatformat(3) }}",
    "{\"v\": \"34.5\"}",
    output="34.500",
    autoescape=true,
  )
}

///|
test "django floatformat #200" {
  jinja(
    source="{{ v|floatformat('3') }}",
    "{\"v\": \"34.5\"}",
    output="34.500",
    autoescape=true,
  )
}

///|
test "django floatformat #201" {
  jinja(
    source="{{ v|floatformat(0) }}",
    "{\"v\": \"34.5\"}",
    output="35",
    autoescape=true,
  )
}

///|
test "django floatformat #202" {
  jinja(
    source="{{ v|floatformat('0') }}",
    "{\"v\": \"34.5\"}",
    output="35",
    autoescape=true,
  )
}

///|
test "django floatformat #203" {
  jinja(
    source="{{ v|floatformat(-3) }}",
    "{\"v\": \"34.5\"}",
    output="34.500",
    autoescape=true,
  )
}

///|
test "django floatformat #204" {
  jinja(
    source="{{ v|floatformat('-3') }}",
    "{\"v\": \"34.5\"}",
    output="34.500",
    autoescape=true,
  )
}

///|
test "django floatformat #205" {
  jinja(
    source="{{ v|floatformat('2g') }}",
    "{\"v\": \"34.5\"}",
    output="34.50",
    autoescape=true,
  )
}

///|
test "django floatformat #206" {
  jinja(
    source="{{ v|floatformat('-2g') }}",
    "{\"v\": \"34.5\"}",
    output="34.50",
    autoescape=true,
  )
}

///|
test "django floatformat #207" {
  jinja(
    source="{{ v|floatformat('2u') }}",
    "{\"v\": \"34.5\"}",
    output="34.50",
    autoescape=true,
  )
}

///|
test "django floatformat #208" {
  jinja(
    source="{{ v|floatformat('2gu') }}",
    "{\"v\": \"34.5\"}",
    output="34.50",
    autoescape=true,
  )
}

///|
test "django floatformat #209" {
  jinja(
    source="{{ v|floatformat }}",
    "{\"v\": \"x\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django floatformat #210" {
  jinja(
    source="{{ v|floatformat(3) }}",
    "{\"v\": \"x\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django floatformat #211" {
  jinja(
    source="{{ v|floatformat('3') }}",
    "{\"v\": \"x\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django floatformat #212" {
  jinja(
    source="{{ v|floatformat(0) }}",
    "{\"v\": \"x\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django floatformat #213" {
  jinja(
    source="{{ v|floatformat('0') }}",
    "{\"v\": \"x\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django floatformat #214" {
  jinja(
    source="{{ v|floatformat(-3) }}",
    "{\"v\": \"x\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django floatformat #215" {
  jinja(
    source="{{ v|floatformat('-3') }}",
    "{\"v\": \"x\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django floatformat #216" {
  jinja(
    source="{{ v|floatformat('2g') }}",
    "{\"v\": \"x\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django floatformat #217" {
  jinja(
    source="{{ v|floatformat('-2g') }}",
    "{\"v\": \"x\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django floatformat #218" {
  jinja(
    source="{{ v|floatformat('2u') }}",
    "{\"v\": \"x\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django floatformat #219" {
  jinja(
    source="{{ v|floatformat('2gu') }}",
    "{\"v\": \"x\"}",
    output="",
    autoescape=true,
  )
}

///|
test "django floatformat #220" {
  jinja(
    source="{{ v|floatformat }}",
    "{\"v\": 66666.6666}",
    output="66666.7",
    autoescape=true,
  )
}

///|
test "django floatformat #221" {
  jinja(
    source="{{ v|floatformat(3) }}",
    "{\"v\": 66666.6666}",
    output="66666.667",
    autoescape=true,
  )
}

///|
test "django floatformat #222" {
  jinja(
    source="{{ v|floatformat('3') }}",
    "{\"v\": 66666.6666}",
    output="66666.667",
    autoescape=true,
  )
}

///|
test "django floatformat #223" {
  jinja(
    source="{{ v|floatformat(0) }}",
    "{\"v\": 66666.6666}",
    output="66667",
    autoescape=true,
  )
}

///|
test "django floatformat #224" {
  jinja(
    source="{{ v|floatformat('0') }}",
    "{\"v\": 66666.6666}",
    output="66667",
    autoescape=true,
  )
}

///|
test "django floatformat #225" {
  jinja(
    source="{{ v|floatformat(-3) }}",
    "{\"v\": 66666.6666}",
    output="66666.667",
    autoescape=true,
  )
}

///|
test "django floatformat #226" {
  jinja(
    source="{{ v|floatformat('-3') }}",
    "{\"v\": 66666.6666}",
    output="66666.667",
    autoescape=true,
  )
}

///|
test "django floatformat #227" {
  jinja(
    source="{{ v|floatformat('2g') }}",
    "{\"v\": 66666.6666}",
    output="66,666.67",
    autoescape=true,
  )
}

///|
test "django floatformat #228" {
  jinja(
    source="{{ v|floatformat('-2g') }}",
    "{\"v\": 66666.6666}",
    output="66,666.67",
    autoescape=true,
  )
}

///|
test "django floatformat #229" {
  jinja(
    source="{{ v|floatformat('2u') }}",
    "{\"v\": 66666.6666}",
    output="66666.67",
    autoescape=true,
  )
}

///|
test "django floatformat #230" {
  jinja(
    source="{{ v|floatformat('2gu') }}",
    "{\"v\": 66666.6666}",
    output="66666.67",
    autoescape=true,
  )
}

///|
test "django floatformat #231" {
  jinja(
    source="{{ v|floatformat }}",
    "{\"v\": 1e+100}",
    output="10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    autoescape=true,
  )
}

///|
test "django floatformat #232" {
  jinja(
    source="{{ v|floatformat(3) }}",
    "{\"v\": 1e+100}",
    output="10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.000",
    autoescape=true,
  )
}

///|
test "django floatformat #233" {
  jinja(
    source="{{ v|floatformat('3') }}",
    "{\"v\": 1e+100}",
    output="10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.000",
    autoescape=true,
  )
}

///|
test "django floatformat #234" {
  jinja(
    source="{{ v|floatformat(0) }}",
    "{\"v\": 1e+100}",
    output="10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    autoescape=true,
  )
}

///|
test "django floatformat #235" {
  jinja(
    source="{{ v|floatformat('0') }}",
    "{\"v\": 1e+100}",
    output="10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    autoescape=true,
  )
}

///|
test "django floatformat #236" {
  jinja(
    source="{{ v|floatformat(-3) }}",
    "{\"v\": 1e+100}",
    output="10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    autoescape=true,
  )
}

///|
test "django floatformat #237" {
  jinja(
    source="{{ v|floatformat('-3') }}",
    "{\"v\": 1e+100}",
    output="10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000",
    autoescape=true,
  )
}

///|
test "django floatformat #238" {
  jinja(
    source="{{ v|floatformat('2g') }}",
    "{\"v\": 1e+100}",
    output="10,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000.00",
    autoescape=true,
  )
}

///|
test "django floatformat #239" {
  jinja(
    source="{{ v|floatformat('-2g') }}",
    "{\"v\": 1e+100}",
    output="10,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000,000",
    autoescape=true,
  )
}

///|
test "django floatformat #240" {
  jinja(
    source="{{ v|floatformat('2u') }}",
    "{\"v\": 1e+100}",
    output="10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.00",
    autoescape=true,
  )
}

///|
test "django floatformat #241" {
  jinja(
    source="{{ v|floatformat('2gu') }}",
    "{\"v\": 1e+100}",
    output="10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000.00",
    autoescape=true,
  )
}

///|
test "django floatformat #242" {
  jinja(
    source="{{ v|floatformat }}",
    "{\"v\": 1.2345678901234567e+19}",
    output="12345678901234567000",
    autoescape=true,
  )
}

///|
test "django floatformat #243" {
  jinja(
    source="{{ v|floatformat(3) }}",
    "{\"v\": 1.2345678901234567e+19}",
    output="12345678901234567000.000",
    autoescape=true,
  )
}

///|
test "django floatformat #244" {
  jinja(
    source="{{ v|floatformat('3') }}",
    "{\"v\": 1.2345678901234567e+19}",
    output="12345678901234567000.000",
    autoescape=true,
  )
}

///|
test "django floatformat #245" {
  jinja(
    source="{{ v|floatformat(0) }}",
    "{\"v\": 1.2345678901234567e+19}",
    output="12345678901234567000",
    autoescape=true,
  )
}

///|
test "django floatformat #246" {
  jinja(
    source="{{ v|floatformat('0') }}",
    "{\"v\": 1.2345678901234567e+19}",
    output="12345678901234567000",
    autoescape=true,
  )
}

///|
test "django floatformat #247" {
  jinja(
    source="{{ v|floatformat(-3) }}",
    "{\"v\": 1.2345678901234567e+19}",
    output="12345678901234567000",
    autoescape=true,
  )
}

///|
test "django floatformat #248" {
  jinja(
    source="{{ v|floatformat('-3') }}",
    "{\"v\": 1.2345678901234567e+19}",
    output="12345678901234567000",
    autoescape=true,
  )
}

///|
test "django floatformat #249" {
  jinja(
    source="{{ v|floatformat('2g') }}",
    "{\"v\": 1.2345678901234567e+19}",
    output="12,345,678,901,234,567,000.00",
    autoescape=true,
  )
}

///|
test "django floatformat #250" {
  jinja(
    source="{{ v|floatformat('-2g') }}",
    "{\"v\": 1.2345678901234567e+19}",
    output="12,345,678,901,234,567,000",
    autoescape=true,
  )
}

///|
test "django floatformat #251" {
  jinja(
    source="{{ v|floatformat('2u') }}",
    "{\"v\": 1.2345678901234567e+19}",
    output="12345678901234567000.00",
    autoescape=true,
  )
}

///|
test "django floatformat #252" {
  jinja(
    source="{{ v|floatformat('2gu') }}",
    "{\"v\": 1.2345678901234567e+19}",
    output="12345678901234567000.00",
    autoescape=true,
  )
}
