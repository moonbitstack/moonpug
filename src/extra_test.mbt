///|
test "extra #0" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #2" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #3" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #4" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #5" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #6" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #7" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #8" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #9" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #10" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #11" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #12" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #13" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #14" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #15" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #16" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #17" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #18" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #19" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #20" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #21" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"\"}",
    output="[]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #22" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"\"}",
    output="[]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #23" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"\"}",
    output="[]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #24" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"\"}",
    output="***************",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #25" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"\"}",
    output="............",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #26" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"\"}",
    output="            ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #27" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"\"}",
    output="00000000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #28" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"\"}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #29" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #30" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #31" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #32" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #33" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"\"}",
    output="(&#39;&#39;, &#39;&#39;, &#39;&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #34" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"\"}",
    output="(&#39;&#39;, &#39;&#39;, &#39;&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #35" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #36" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"\"}",
    output="[&#39;&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #37" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"\"}",
    output="[&#39;&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #38" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"\"}",
    output="[]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #39" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #40" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #41" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #42" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #43" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"\"}",
    output="12",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #44" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"abc\"}",
    output="Abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #45" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"abc\"}",
    output="abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #46" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"abc\"}",
    output="abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #47" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"abc\"}",
    output="ABC",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #48" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"abc\"}",
    output="ABC",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #49" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"abc\"}",
    output="Abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #50" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"abc\"}",
    output="abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #51" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"abc\"}",
    output="abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #52" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"abc\"}",
    output="abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #53" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"abc\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #54" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"abc\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #55" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"abc\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #56" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"abc\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #57" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"abc\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #58" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"abc\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #59" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"abc\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #60" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"abc\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #61" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"abc\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #62" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"abc\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #63" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"abc\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #64" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"abc\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #65" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"abc\"}",
    output="[&#39;abc&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #66" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"abc\"}",
    output="[&#39;abc&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #67" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"abc\"}",
    output="[&#39;abc&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #68" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"abc\"}",
    output="******abc******",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #69" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"abc\"}",
    output="abc.........",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #70" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"abc\"}",
    output="         abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #71" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"abc\"}",
    output="00000abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #72" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"abc\"}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #73" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"abc\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #74" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"abc\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #75" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"abc\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #76" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"abc\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #77" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"abc\"}",
    output="(&#39;abc&#39;, &#39;&#39;, &#39;&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #78" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"abc\"}",
    output="(&#39;&#39;, &#39;&#39;, &#39;abc&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #79" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"abc\"}",
    output="abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #80" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"abc\"}",
    output="[&#39;abc&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #81" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"abc\"}",
    output="[&#39;abc&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #82" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"abc\"}",
    output="[&#39;abc&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #83" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"abc\"}",
    output="abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #84" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"abc\"}",
    output="abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #85" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"abc\"}",
    output="abc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #86" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"abc\"}",
    output="bc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #87" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"abc\"}",
    output="1abc2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #88" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"Hello World\"}",
    output="Hello world",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #89" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"Hello World\"}",
    output="hello world",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #90" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"Hello World\"}",
    output="hello world",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #91" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"Hello World\"}",
    output="HELLO WORLD",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #92" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"Hello World\"}",
    output="hELLO wORLD",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #93" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"Hello World\"}",
    output="Hello World",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #94" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"Hello World\"}",
    output="Hello World",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #95" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"Hello World\"}",
    output="Hello World",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #96" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"Hello World\"}",
    output="Hello World",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #97" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"Hello World\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #98" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"Hello World\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #99" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"Hello World\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #100" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"Hello World\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #101" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"Hello World\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #102" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"Hello World\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #103" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"Hello World\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #104" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"Hello World\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #105" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"Hello World\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #106" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"Hello World\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #107" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"Hello World\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #108" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"Hello World\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #109" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"Hello World\"}",
    output="[&#39;Hello&#39;, &#39;World&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #110" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"Hello World\"}",
    output="[&#39;Hello World&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #111" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"Hello World\"}",
    output="[&#39;Hello World&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #112" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"Hello World\"}",
    output="**Hello World**",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #113" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"Hello World\"}",
    output="Hello World.",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #114" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"Hello World\"}",
    output=" Hello World",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #115" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"Hello World\"}",
    output="Hello World",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #116" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"Hello World\"}",
    output="3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #117" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"Hello World\"}",
    output="4",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #118" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"Hello World\"}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #119" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"Hello World\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #120" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"Hello World\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #121" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"Hello World\"}",
    output="(&#39;Hello&#39;, &#39; &#39;, &#39;World&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #122" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"Hello World\"}",
    output="(&#39;Hello&#39;, &#39; &#39;, &#39;World&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #123" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"Hello World\"}",
    output="HeLlo World",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #124" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"Hello World\"}",
    output="[&#39;He&#39;, &#39;&#39;, &#39;o Wor&#39;, &#39;d&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #125" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"Hello World\"}",
    output="[&#39;Hello&#39;, &#39;World&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #126" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"Hello World\"}",
    output="[&#39;Hello&#39;, &#39;World&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #127" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"Hello World\"}",
    output="Hello World",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #128" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"Hello World\"}",
    output="llo World",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #129" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"Hello World\"}",
    output="Hello Wor",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #130" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"Hello World\"}",
    output="Hello World",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #131" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"Hello World\"}",
    output="1Hello World2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #132" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"  pad  \"}",
    output="  pad  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #133" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"  pad  \"}",
    output="  pad  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #134" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"  pad  \"}",
    output="  pad  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #135" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"  pad  \"}",
    output="  PAD  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #136" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"  pad  \"}",
    output="  PAD  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #137" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"  pad  \"}",
    output="  Pad  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #138" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"  pad  \"}",
    output="pad",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #139" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"  pad  \"}",
    output="pad  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #140" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"  pad  \"}",
    output="  pad",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #141" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"  pad  \"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #142" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"  pad  \"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #143" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"  pad  \"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #144" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"  pad  \"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #145" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"  pad  \"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #146" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"  pad  \"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #147" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"  pad  \"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #148" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"  pad  \"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #149" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"  pad  \"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #150" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"  pad  \"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #151" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"  pad  \"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #152" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"  pad  \"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #153" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"  pad  \"}",
    output="[&#39;pad&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #154" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"  pad  \"}",
    output="[&#39;  pad  &#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #155" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"  pad  \"}",
    output="[&#39;  pad  &#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #156" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"  pad  \"}",
    output="****  pad  ****",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #157" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"  pad  \"}",
    output="  pad  .....",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #158" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"  pad  \"}",
    output="       pad  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #159" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"  pad  \"}",
    output="0  pad  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #160" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"  pad  \"}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #161" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"  pad  \"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #162" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"  pad  \"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #163" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"  pad  \"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #164" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"  pad  \"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #165" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"  pad  \"}",
    output="(&#39;&#39;, &#39; &#39;, &#39; pad  &#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #166" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"  pad  \"}",
    output="(&#39;  pad &#39;, &#39; &#39;, &#39;&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #167" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"  pad  \"}",
    output="  pad  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #168" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"  pad  \"}",
    output="[&#39;  pad  &#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #169" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"  pad  \"}",
    output="[&#39;  pad &#39;, &#39;&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #170" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"  pad  \"}",
    output="[&#39;pad&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #171" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"  pad  \"}",
    output="  pad  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #172" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"  pad  \"}",
    output="  pad  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #173" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"  pad  \"}",
    output="  pad  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #174" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"  pad  \"}",
    output="d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #175" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"  pad  \"}",
    output="1  pad  2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #176" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="Àéîõü ß",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #177" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="àéîõü ss",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #178" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="àéîõü ß",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #179" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="ÀÉÎÕÜ SS",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #180" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="àéîÕÜ SS",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #181" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="Àéîõü Ss",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #182" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="ÀÉÎõü ß",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #183" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="ÀÉÎõü ß",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #184" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="ÀÉÎõü ß",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #185" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #186" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #187" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #188" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #189" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #190" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #191" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #192" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #193" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #194" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #195" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #196" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #197" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="[&#39;ÀÉÎõü&#39;, &#39;ß&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #198" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="[&#39;ÀÉÎõü ß&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #199" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="[&#39;ÀÉÎõü ß&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #200" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="****ÀÉÎõü ß****",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #201" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="ÀÉÎõü ß.....",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #202" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="     ÀÉÎõü ß",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #203" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="0ÀÉÎõü ß",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #204" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #205" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #206" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #207" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #208" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #209" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="(&#39;ÀÉÎõü&#39;, &#39; &#39;, &#39;ß&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #210" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="(&#39;ÀÉÎõü&#39;, &#39; &#39;, &#39;ß&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #211" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="ÀÉÎõü ß",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #212" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="[&#39;ÀÉÎõü ß&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #213" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="[&#39;ÀÉÎõü&#39;, &#39;ß&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #214" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="[&#39;ÀÉÎõü&#39;, &#39;ß&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #215" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="ÀÉÎõü ß",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #216" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="ÀÉÎõü ß",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #217" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="ÀÉÎõü ß",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #218" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="ÀÉÎõü ß",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #219" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"ÀÉÎõü ß\"}",
    output="1ÀÉÎõü ß2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #220" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"a-b_c d\"}",
    output="A-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #221" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"a-b_c d\"}",
    output="a-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #222" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"a-b_c d\"}",
    output="a-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #223" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"a-b_c d\"}",
    output="A-B_C D",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #224" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"a-b_c d\"}",
    output="A-B_C D",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #225" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"a-b_c d\"}",
    output="A-B_C D",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #226" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"a-b_c d\"}",
    output="a-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #227" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"a-b_c d\"}",
    output="a-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #228" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"a-b_c d\"}",
    output="a-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #229" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"a-b_c d\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #230" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"a-b_c d\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #231" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"a-b_c d\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #232" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"a-b_c d\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #233" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"a-b_c d\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #234" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"a-b_c d\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #235" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"a-b_c d\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #236" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"a-b_c d\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #237" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"a-b_c d\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #238" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"a-b_c d\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #239" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"a-b_c d\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #240" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"a-b_c d\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #241" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"a-b_c d\"}",
    output="[&#39;a-b_c&#39;, &#39;d&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #242" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"a-b_c d\"}",
    output="[&#39;a-b_c d&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #243" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"a-b_c d\"}",
    output="[&#39;a-b_c d&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #244" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"a-b_c d\"}",
    output="****a-b_c d****",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #245" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"a-b_c d\"}",
    output="a-b_c d.....",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #246" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"a-b_c d\"}",
    output="     a-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #247" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"a-b_c d\"}",
    output="0a-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #248" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"a-b_c d\"}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #249" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"a-b_c d\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #250" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"a-b_c d\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #251" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"a-b_c d\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #252" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"a-b_c d\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #253" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"a-b_c d\"}",
    output="(&#39;a-b_c&#39;, &#39; &#39;, &#39;d&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #254" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"a-b_c d\"}",
    output="(&#39;a-b_c&#39;, &#39; &#39;, &#39;d&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #255" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"a-b_c d\"}",
    output="a-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #256" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"a-b_c d\"}",
    output="[&#39;a-b_c d&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #257" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"a-b_c d\"}",
    output="[&#39;a-b_c&#39;, &#39;d&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #258" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"a-b_c d\"}",
    output="[&#39;a-b_c&#39;, &#39;d&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #259" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"a-b_c d\"}",
    output="a-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #260" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"a-b_c d\"}",
    output="a-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #261" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"a-b_c d\"}",
    output="a-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #262" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"a-b_c d\"}",
    output="-b_c d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #263" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"a-b_c d\"}",
    output="1a-b_c d2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #264" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"ǅungla\"}",
    output="ǅungla",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #265" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"ǅungla\"}",
    output="ǆungla",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #266" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"ǅungla\"}",
    output="ǆungla",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #267" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"ǅungla\"}",
    output="ǄUNGLA",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #268" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"ǅungla\"}",
    output="ǅUNGLA",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #269" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"ǅungla\"}",
    output="ǅungla",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #270" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"ǅungla\"}",
    output="ǅungla",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #271" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"ǅungla\"}",
    output="ǅungla",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #272" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"ǅungla\"}",
    output="ǅungla",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #273" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"ǅungla\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #274" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"ǅungla\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #275" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"ǅungla\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #276" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"ǅungla\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #277" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"ǅungla\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #278" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"ǅungla\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #279" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"ǅungla\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #280" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"ǅungla\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #281" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"ǅungla\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #282" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"ǅungla\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #283" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"ǅungla\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #284" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"ǅungla\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #285" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"ǅungla\"}",
    output="[&#39;ǅungla&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #286" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"ǅungla\"}",
    output="[&#39;ǅungla&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #287" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"ǅungla\"}",
    output="[&#39;ǅungla&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #288" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"ǅungla\"}",
    output="*****ǅungla****",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #289" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"ǅungla\"}",
    output="ǅungla......",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #290" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"ǅungla\"}",
    output="      ǅungla",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #291" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"ǅungla\"}",
    output="00ǅungla",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #292" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"ǅungla\"}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #293" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"ǅungla\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #294" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"ǅungla\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #295" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"ǅungla\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #296" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"ǅungla\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #297" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"ǅungla\"}",
    output="(&#39;ǅungla&#39;, &#39;&#39;, &#39;&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #298" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"ǅungla\"}",
    output="(&#39;&#39;, &#39;&#39;, &#39;ǅungla&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #299" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"ǅungla\"}",
    output="ǅungLa",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #300" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"ǅungla\"}",
    output="[&#39;ǅung&#39;, &#39;a&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #301" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"ǅungla\"}",
    output="[&#39;ǅungla&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #302" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"ǅungla\"}",
    output="[&#39;ǅungla&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #303" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"ǅungla\"}",
    output="ǅungla",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #304" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"ǅungla\"}",
    output="ǅungla",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #305" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"ǅungla\"}",
    output="ǅungla",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #306" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"ǅungla\"}",
    output="ǅungl",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #307" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"ǅungla\"}",
    output="1ǅungla2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #308" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #309" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #310" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #311" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #312" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #313" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #314" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #315" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #316" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #317" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"123\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #318" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"123\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #319" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"123\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #320" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"123\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #321" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"123\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #322" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"123\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #323" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"123\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #324" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"123\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #325" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"123\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #326" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"123\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #327" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"123\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #328" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"123\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #329" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"123\"}",
    output="[&#39;123&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #330" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"123\"}",
    output="[&#39;123&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #331" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"123\"}",
    output="[&#39;123&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #332" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"123\"}",
    output="******123******",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #333" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"123\"}",
    output="123.........",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #334" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"123\"}",
    output="         123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #335" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"123\"}",
    output="00000123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #336" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"123\"}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #337" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"123\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #338" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"123\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #339" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"123\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #340" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"123\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #341" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"123\"}",
    output="(&#39;123&#39;, &#39;&#39;, &#39;&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #342" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"123\"}",
    output="(&#39;&#39;, &#39;&#39;, &#39;123&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #343" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #344" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"123\"}",
    output="[&#39;123&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #345" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"123\"}",
    output="[&#39;123&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #346" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"123\"}",
    output="[&#39;123&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #347" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #348" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #349" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #350" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"123\"}",
    output="123",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #351" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"123\"}",
    output="11232",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #352" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #353" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #354" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #355" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #356" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #357" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #358" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #359" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #360" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #361" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"١٢٣\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #362" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"١٢٣\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #363" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"١٢٣\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #364" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"١٢٣\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #365" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"١٢٣\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #366" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"١٢٣\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #367" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"١٢٣\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #368" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"١٢٣\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #369" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"١٢٣\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #370" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"١٢٣\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #371" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"١٢٣\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #372" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"١٢٣\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #373" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"١٢٣\"}",
    output="[&#39;١٢٣&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #374" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"١٢٣\"}",
    output="[&#39;١٢٣&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #375" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"١٢٣\"}",
    output="[&#39;١٢٣&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #376" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"١٢٣\"}",
    output="******١٢٣******",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #377" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣.........",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #378" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"١٢٣\"}",
    output="         ١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #379" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"١٢٣\"}",
    output="00000١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #380" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"١٢٣\"}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #381" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"١٢٣\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #382" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"١٢٣\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #383" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"١٢٣\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #384" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"١٢٣\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #385" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"١٢٣\"}",
    output="(&#39;١٢٣&#39;, &#39;&#39;, &#39;&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #386" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"١٢٣\"}",
    output="(&#39;&#39;, &#39;&#39;, &#39;١٢٣&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #387" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #388" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"١٢٣\"}",
    output="[&#39;١٢٣&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #389" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"١٢٣\"}",
    output="[&#39;١٢٣&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #390" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"١٢٣\"}",
    output="[&#39;١٢٣&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #391" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #392" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #393" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #394" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"١٢٣\"}",
    output="١٢٣",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #395" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"١٢٣\"}",
    output="1١٢٣2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #396" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="X\ty\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #397" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="x\ty\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #398" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="x\ty\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #399" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="X\tY\nZ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #400" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="X\tY\nZ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #401" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="X\tY\nZ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #402" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="x\ty\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #403" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="x\ty\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #404" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="x\ty\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #405" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #406" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #407" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #408" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #409" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #410" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #411" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #412" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #413" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #414" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #415" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #416" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #417" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="[&#39;x&#39;, &#39;y&#39;, &#39;z&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #418" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="[&#39;x\\ty&#39;, &#39;z&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #419" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="[&#39;x\\ty\\n&#39;, &#39;z&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #420" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="*****x\ty\nz*****",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #421" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="x\ty\nz.......",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #422" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="       x\ty\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #423" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="000x\ty\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #424" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #425" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #426" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #427" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #428" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #429" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="(&#39;x\\ty\\nz&#39;, &#39;&#39;, &#39;&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #430" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="(&#39;&#39;, &#39;&#39;, &#39;x\\ty\\nz&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #431" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="x\ty\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #432" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="[&#39;x\\ty\\nz&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #433" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="[&#39;x\\ty\\nz&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #434" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="[&#39;x&#39;, &#39;y\\nz&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #435" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="x   y\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #436" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="x\ty\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #437" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="x\ty\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #438" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="x\ty\nz",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #439" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"x\\ty\\nz\"}",
    output="1x\ty\nz2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #440" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed case text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #441" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="mixed case text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #442" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="mixed case text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #443" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="MIXED CASE TEXT",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #444" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="mIXED case TEXT",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #445" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed Case Text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #446" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed CASE text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #447" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed CASE text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #448" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed CASE text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #449" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #450" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #451" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #452" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #453" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #454" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #455" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #456" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #457" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #458" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #459" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #460" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #461" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="[&#39;Mixed&#39;, &#39;CASE&#39;, &#39;text&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #462" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="[&#39;Mixed CASE text&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #463" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="[&#39;Mixed CASE text&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #464" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed CASE text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #465" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed CASE text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #466" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed CASE text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #467" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed CASE text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #468" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #469" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #470" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #471" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #472" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #473" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="(&#39;Mixed&#39;, &#39; &#39;, &#39;CASE text&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #474" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="(&#39;Mixed CASE&#39;, &#39; &#39;, &#39;text&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #475" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed CASE text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #476" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="[&#39;Mixed CASE text&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #477" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="[&#39;Mixed CASE&#39;, &#39;text&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #478" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="[&#39;Mixed&#39;, &#39;CASE text&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #479" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed CASE text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #480" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed CASE text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #481" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed CASE text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #482" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="Mixed CASE text",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #483" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"Mixed CASE text\"}",
    output="1Mixed CASE text2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #484" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"ﬁne\"}",
    output="Fine",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #485" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"ﬁne\"}",
    output="fine",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #486" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"ﬁne\"}",
    output="ﬁne",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #487" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"ﬁne\"}",
    output="FINE",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #488" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"ﬁne\"}",
    output="FINE",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #489" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"ﬁne\"}",
    output="Fine",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #490" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"ﬁne\"}",
    output="ﬁne",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #491" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"ﬁne\"}",
    output="ﬁne",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #492" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"ﬁne\"}",
    output="ﬁne",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #493" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"ﬁne\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #494" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"ﬁne\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #495" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"ﬁne\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #496" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"ﬁne\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #497" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"ﬁne\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #498" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"ﬁne\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #499" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"ﬁne\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #500" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"ﬁne\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #501" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"ﬁne\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #502" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"ﬁne\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #503" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"ﬁne\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #504" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"ﬁne\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #505" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"ﬁne\"}",
    output="[&#39;ﬁne&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #506" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"ﬁne\"}",
    output="[&#39;ﬁne&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #507" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"ﬁne\"}",
    output="[&#39;ﬁne&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #508" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"ﬁne\"}",
    output="******ﬁne******",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #509" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"ﬁne\"}",
    output="ﬁne.........",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #510" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"ﬁne\"}",
    output="         ﬁne",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #511" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"ﬁne\"}",
    output="00000ﬁne",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #512" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"ﬁne\"}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #513" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"ﬁne\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #514" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"ﬁne\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #515" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"ﬁne\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #516" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"ﬁne\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #517" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"ﬁne\"}",
    output="(&#39;ﬁne&#39;, &#39;&#39;, &#39;&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #518" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"ﬁne\"}",
    output="(&#39;&#39;, &#39;&#39;, &#39;ﬁne&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #519" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"ﬁne\"}",
    output="ﬁne",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #520" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"ﬁne\"}",
    output="[&#39;ﬁne&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #521" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"ﬁne\"}",
    output="[&#39;ﬁne&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #522" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"ﬁne\"}",
    output="[&#39;ﬁne&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #523" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"ﬁne\"}",
    output="ﬁne",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #524" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"ﬁne\"}",
    output="ﬁne",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #525" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"ﬁne\"}",
    output="ﬁne",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #526" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"ﬁne\"}",
    output="ﬁne",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #527" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"ﬁne\"}",
    output="1ﬁne2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #528" {
  jinja(
    source="{{ s.capitalize() }}",
    "{\"s\": \"σΣς\"}",
    output="Σσς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #529" {
  jinja(
    source="{{ s.casefold() }}",
    "{\"s\": \"σΣς\"}",
    output="σσσ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #530" {
  jinja(
    source="{{ s.lower() }}",
    "{\"s\": \"σΣς\"}",
    output="σσς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #531" {
  jinja(
    source="{{ s.upper() }}",
    "{\"s\": \"σΣς\"}",
    output="ΣΣΣ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #532" {
  jinja(
    source="{{ s.swapcase() }}",
    "{\"s\": \"σΣς\"}",
    output="ΣσΣ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #533" {
  jinja(
    source="{{ s.title() }}",
    "{\"s\": \"σΣς\"}",
    output="Σσς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #534" {
  jinja(
    source="{{ s.strip() }}",
    "{\"s\": \"σΣς\"}",
    output="σΣς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #535" {
  jinja(
    source="{{ s.lstrip() }}",
    "{\"s\": \"σΣς\"}",
    output="σΣς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #536" {
  jinja(
    source="{{ s.rstrip() }}",
    "{\"s\": \"σΣς\"}",
    output="σΣς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #537" {
  jinja(
    source="{{ s.isalnum() }}",
    "{\"s\": \"σΣς\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #538" {
  jinja(
    source="{{ s.isalpha() }}",
    "{\"s\": \"σΣς\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #539" {
  jinja(
    source="{{ s.isascii() }}",
    "{\"s\": \"σΣς\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #540" {
  jinja(
    source="{{ s.isdecimal() }}",
    "{\"s\": \"σΣς\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #541" {
  jinja(
    source="{{ s.isdigit() }}",
    "{\"s\": \"σΣς\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #542" {
  jinja(
    source="{{ s.isidentifier() }}",
    "{\"s\": \"σΣς\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #543" {
  jinja(
    source="{{ s.islower() }}",
    "{\"s\": \"σΣς\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #544" {
  jinja(
    source="{{ s.isnumeric() }}",
    "{\"s\": \"σΣς\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #545" {
  jinja(
    source="{{ s.isprintable() }}",
    "{\"s\": \"σΣς\"}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #546" {
  jinja(
    source="{{ s.isspace() }}",
    "{\"s\": \"σΣς\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #547" {
  jinja(
    source="{{ s.istitle() }}",
    "{\"s\": \"σΣς\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #548" {
  jinja(
    source="{{ s.isupper() }}",
    "{\"s\": \"σΣς\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #549" {
  jinja(
    source="{{ s.split() }}",
    "{\"s\": \"σΣς\"}",
    output="[&#39;σΣς&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #550" {
  jinja(
    source="{{ s.splitlines() }}",
    "{\"s\": \"σΣς\"}",
    output="[&#39;σΣς&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #551" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{\"s\": \"σΣς\"}",
    output="[&#39;σΣς&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #552" {
  jinja(
    source="{{ s.center(15, '*') }}",
    "{\"s\": \"σΣς\"}",
    output="******σΣς******",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #553" {
  jinja(
    source="{{ s.ljust(12, '.') }}",
    "{\"s\": \"σΣς\"}",
    output="σΣς.........",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #554" {
  jinja(
    source="{{ s.rjust(12) }}",
    "{\"s\": \"σΣς\"}",
    output="         σΣς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #555" {
  jinja(
    source="{{ s.zfill(8) }}",
    "{\"s\": \"σΣς\"}",
    output="00000σΣς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #556" {
  jinja(
    source="{{ s.count('l') }}",
    "{\"s\": \"σΣς\"}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #557" {
  jinja(
    source="{{ s.find('o') }}",
    "{\"s\": \"σΣς\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #558" {
  jinja(
    source="{{ s.rfind('o') }}",
    "{\"s\": \"σΣς\"}",
    output="-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #559" {
  jinja(
    source="{{ s.startswith('He') }}",
    "{\"s\": \"σΣς\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #560" {
  jinja(
    source="{{ s.endswith(('d', 'c')) }}",
    "{\"s\": \"σΣς\"}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #561" {
  jinja(
    source="{{ s.partition(' ') }}",
    "{\"s\": \"σΣς\"}",
    output="(&#39;σΣς&#39;, &#39;&#39;, &#39;&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #562" {
  jinja(
    source="{{ s.rpartition(' ') }}",
    "{\"s\": \"σΣς\"}",
    output="(&#39;&#39;, &#39;&#39;, &#39;σΣς&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #563" {
  jinja(
    source="{{ s.replace('l', 'L', 1) }}",
    "{\"s\": \"σΣς\"}",
    output="σΣς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #564" {
  jinja(
    source="{{ s.split('l') }}",
    "{\"s\": \"σΣς\"}",
    output="[&#39;σΣς&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #565" {
  jinja(
    source="{{ s.rsplit(' ', 1) }}",
    "{\"s\": \"σΣς\"}",
    output="[&#39;σΣς&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #566" {
  jinja(
    source="{{ s.split(none, 1) }}",
    "{\"s\": \"σΣς\"}",
    output="[&#39;σΣς&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #567" {
  jinja(
    source="{{ s.expandtabs(4) }}",
    "{\"s\": \"σΣς\"}",
    output="σΣς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #568" {
  jinja(
    source="{{ s.removeprefix('He') }}",
    "{\"s\": \"σΣς\"}",
    output="σΣς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #569" {
  jinja(
    source="{{ s.removesuffix('ld') }}",
    "{\"s\": \"σΣς\"}",
    output="σΣς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #570" {
  jinja(
    source="{{ s.strip('ap ') }}",
    "{\"s\": \"σΣς\"}",
    output="σΣς",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #571" {
  jinja(
    source="{{ s.join(['1', '2']) }}",
    "{\"s\": \"σΣς\"}",
    output="1σΣς2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #572" {
  jinja(
    source="{{ 'abc'.index('c') }}|{{ 'abc'.rindex('a') }}",
    "{}",
    output="2|0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #573" {
  jinja(
    source="{{ 'abc'.index('z') }}",
    "{}",
    error="ValueError: substring not found",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #574" {
  jinja(
    source="{{ 'a,b,,c'.split(',') }}|{{ 'a b'.split(' ', -1) }}|{{ ''.split() }}|{{ ''.split(',') }}",
    "{}",
    output="[&#39;a&#39;, &#39;b&#39;, &#39;&#39;, &#39;c&#39;]|[&#39;a&#39;, &#39;b&#39;]|[]|[&#39;&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #575" {
  jinja(
    source="{{ '{0}-{1}-{0}'.format('a', 'b') }}|{{ '{x}{y!r}'.format(x=1, y='q') }}|{{ '{:>{w}}'.format('z', w=5) }}",
    "{}",
    output="a-b-a|1&#39;q&#39;|    z",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #576" {
  jinja(
    source="{{ '{0[1]}{0[0]}'.format('ab') }}|{{ '{d[k]}'.format(d={'k': 3}) }}|{{ '{{}}{}'.format(1) }}",
    "{}",
    output="ba|3|{}1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #577" {
  jinja(
    source="{{ '{a}'.format_map({'a': 5}) }}",
    "{}",
    output="5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #578" {
  jinja(
    source="{{ '{:}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #579" {
  jinja(
    source="{{ '{:d}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #580" {
  jinja(
    source="{{ '{:5d}'.format(0) }}",
    "{}",
    output="    0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #581" {
  jinja(
    source="{{ '{:<6}'.format(0) }}",
    "{}",
    output="0     ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #582" {
  jinja(
    source="{{ '{:>6}'.format(0) }}",
    "{}",
    output="     0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #583" {
  jinja(
    source="{{ '{:^7}'.format(0) }}",
    "{}",
    output="   0   ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #584" {
  jinja(
    source="{{ '{:*^9}'.format(0) }}",
    "{}",
    output="****0****",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #585" {
  jinja(
    source="{{ '{:+}'.format(0) }}",
    "{}",
    output="+0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #586" {
  jinja(
    source="{{ '{: }'.format(0) }}",
    "{}",
    output=" 0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #587" {
  jinja(
    source="{{ '{:-}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #588" {
  jinja(
    source="{{ '{:,}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #589" {
  jinja(
    source="{{ '{:_}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #590" {
  jinja(
    source="{{ '{:08.3f}'.format(0) }}",
    "{}",
    output="0000.000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #591" {
  jinja(
    source="{{ '{:.2f}'.format(0) }}",
    "{}",
    output="0.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #592" {
  jinja(
    source="{{ '{:.0f}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #593" {
  jinja(
    source="{{ '{:e}'.format(0) }}",
    "{}",
    output="0.000000e+00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #594" {
  jinja(
    source="{{ '{:.3E}'.format(0) }}",
    "{}",
    output="0.000E+00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #595" {
  jinja(
    source="{{ '{:g}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #596" {
  jinja(
    source="{{ '{:.3g}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #597" {
  jinja(
    source="{{ '{:G}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #598" {
  jinja(
    source="{{ '{:%}'.format(0) }}",
    "{}",
    output="0.000000%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #599" {
  jinja(
    source="{{ '{:.1%}'.format(0) }}",
    "{}",
    output="0.0%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #600" {
  jinja(
    source="{{ '{:x}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #601" {
  jinja(
    source="{{ '{:X}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #602" {
  jinja(
    source="{{ '{:#x}'.format(0) }}",
    "{}",
    output="0x0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #603" {
  jinja(
    source="{{ '{:#o}'.format(0) }}",
    "{}",
    output="0o0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #604" {
  jinja(
    source="{{ '{:b}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #605" {
  jinja(
    source="{{ '{:#b}'.format(0) }}",
    "{}",
    output="0b0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #606" {
  jinja(
    source="{{ '{:o}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #607" {
  jinja(
    source="{{ '{:c}'.format(0) }}",
    "{}",
    output="\u0000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #608" {
  jinja(
    source="{{ '{:n}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #609" {
  jinja(
    source="{{ '{:z.1f}'.format(0) }}",
    "{}",
    output="0.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #610" {
  jinja(
    source="{{ '{:=+8}'.format(0) }}",
    "{}",
    output="+      0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #611" {
  jinja(
    source="{{ '{:010,.2f}'.format(0) }}",
    "{}",
    output="000,000.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #612" {
  jinja(
    source="{{ '{:.10g}'.format(0) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #613" {
  jinja(
    source="{{ '{:#g}'.format(0) }}",
    "{}",
    output="0.00000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #614" {
  jinja(
    source="{{ '{:s}'.format(0) }}",
    "{}",
    error="ValueError: Unknown format code 's' for object of type 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #615" {
  jinja(
    source="{{ '{:}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #616" {
  jinja(
    source="{{ '{:d}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #617" {
  jinja(
    source="{{ '{:5d}'.format(7) }}",
    "{}",
    output="    7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #618" {
  jinja(
    source="{{ '{:<6}'.format(7) }}",
    "{}",
    output="7     ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #619" {
  jinja(
    source="{{ '{:>6}'.format(7) }}",
    "{}",
    output="     7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #620" {
  jinja(
    source="{{ '{:^7}'.format(7) }}",
    "{}",
    output="   7   ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #621" {
  jinja(
    source="{{ '{:*^9}'.format(7) }}",
    "{}",
    output="****7****",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #622" {
  jinja(
    source="{{ '{:+}'.format(7) }}",
    "{}",
    output="+7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #623" {
  jinja(
    source="{{ '{: }'.format(7) }}",
    "{}",
    output=" 7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #624" {
  jinja(
    source="{{ '{:-}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #625" {
  jinja(
    source="{{ '{:,}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #626" {
  jinja(
    source="{{ '{:_}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #627" {
  jinja(
    source="{{ '{:08.3f}'.format(7) }}",
    "{}",
    output="0007.000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #628" {
  jinja(
    source="{{ '{:.2f}'.format(7) }}",
    "{}",
    output="7.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #629" {
  jinja(
    source="{{ '{:.0f}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #630" {
  jinja(
    source="{{ '{:e}'.format(7) }}",
    "{}",
    output="7.000000e+00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #631" {
  jinja(
    source="{{ '{:.3E}'.format(7) }}",
    "{}",
    output="7.000E+00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #632" {
  jinja(
    source="{{ '{:g}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #633" {
  jinja(
    source="{{ '{:.3g}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #634" {
  jinja(
    source="{{ '{:G}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #635" {
  jinja(
    source="{{ '{:%}'.format(7) }}",
    "{}",
    output="700.000000%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #636" {
  jinja(
    source="{{ '{:.1%}'.format(7) }}",
    "{}",
    output="700.0%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #637" {
  jinja(
    source="{{ '{:x}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #638" {
  jinja(
    source="{{ '{:X}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #639" {
  jinja(
    source="{{ '{:#x}'.format(7) }}",
    "{}",
    output="0x7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #640" {
  jinja(
    source="{{ '{:#o}'.format(7) }}",
    "{}",
    output="0o7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #641" {
  jinja(
    source="{{ '{:b}'.format(7) }}",
    "{}",
    output="111",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #642" {
  jinja(
    source="{{ '{:#b}'.format(7) }}",
    "{}",
    output="0b111",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #643" {
  jinja(
    source="{{ '{:o}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #644" {
  jinja(
    source="{{ '{:c}'.format(7) }}",
    "{}",
    output="\u0007",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #645" {
  jinja(
    source="{{ '{:n}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #646" {
  jinja(
    source="{{ '{:z.1f}'.format(7) }}",
    "{}",
    output="7.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #647" {
  jinja(
    source="{{ '{:=+8}'.format(7) }}",
    "{}",
    output="+      7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #648" {
  jinja(
    source="{{ '{:010,.2f}'.format(7) }}",
    "{}",
    output="000,007.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #649" {
  jinja(
    source="{{ '{:.10g}'.format(7) }}",
    "{}",
    output="7",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #650" {
  jinja(
    source="{{ '{:#g}'.format(7) }}",
    "{}",
    output="7.00000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #651" {
  jinja(
    source="{{ '{:s}'.format(7) }}",
    "{}",
    error="ValueError: Unknown format code 's' for object of type 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #652" {
  jinja(
    source="{{ '{:}'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #653" {
  jinja(
    source="{{ '{:d}'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #654" {
  jinja(
    source="{{ '{:5d}'.format(-42) }}",
    "{}",
    output="  -42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #655" {
  jinja(
    source="{{ '{:<6}'.format(-42) }}",
    "{}",
    output="-42   ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #656" {
  jinja(
    source="{{ '{:>6}'.format(-42) }}",
    "{}",
    output="   -42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #657" {
  jinja(
    source="{{ '{:^7}'.format(-42) }}",
    "{}",
    output="  -42  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #658" {
  jinja(
    source="{{ '{:*^9}'.format(-42) }}",
    "{}",
    output="***-42***",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #659" {
  jinja(
    source="{{ '{:+}'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #660" {
  jinja(
    source="{{ '{: }'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #661" {
  jinja(
    source="{{ '{:-}'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #662" {
  jinja(
    source="{{ '{:,}'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #663" {
  jinja(
    source="{{ '{:_}'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #664" {
  jinja(
    source="{{ '{:08.3f}'.format(-42) }}",
    "{}",
    output="-042.000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #665" {
  jinja(
    source="{{ '{:.2f}'.format(-42) }}",
    "{}",
    output="-42.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #666" {
  jinja(
    source="{{ '{:.0f}'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #667" {
  jinja(
    source="{{ '{:e}'.format(-42) }}",
    "{}",
    output="-4.200000e+01",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #668" {
  jinja(
    source="{{ '{:.3E}'.format(-42) }}",
    "{}",
    output="-4.200E+01",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #669" {
  jinja(
    source="{{ '{:g}'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #670" {
  jinja(
    source="{{ '{:.3g}'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #671" {
  jinja(
    source="{{ '{:G}'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #672" {
  jinja(
    source="{{ '{:%}'.format(-42) }}",
    "{}",
    output="-4200.000000%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #673" {
  jinja(
    source="{{ '{:.1%}'.format(-42) }}",
    "{}",
    output="-4200.0%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #674" {
  jinja(
    source="{{ '{:x}'.format(-42) }}",
    "{}",
    output="-2a",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #675" {
  jinja(
    source="{{ '{:X}'.format(-42) }}",
    "{}",
    output="-2A",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #676" {
  jinja(
    source="{{ '{:#x}'.format(-42) }}",
    "{}",
    output="-0x2a",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #677" {
  jinja(
    source="{{ '{:#o}'.format(-42) }}",
    "{}",
    output="-0o52",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #678" {
  jinja(
    source="{{ '{:b}'.format(-42) }}",
    "{}",
    output="-101010",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #679" {
  jinja(
    source="{{ '{:#b}'.format(-42) }}",
    "{}",
    output="-0b101010",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #680" {
  jinja(
    source="{{ '{:o}'.format(-42) }}",
    "{}",
    output="-52",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #681" {
  jinja(
    source="{{ '{:c}'.format(-42) }}",
    "{}",
    error="OverflowError: %c arg not in range(0x110000)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #682" {
  jinja(
    source="{{ '{:n}'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #683" {
  jinja(
    source="{{ '{:z.1f}'.format(-42) }}",
    "{}",
    output="-42.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #684" {
  jinja(
    source="{{ '{:=+8}'.format(-42) }}",
    "{}",
    output="-     42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #685" {
  jinja(
    source="{{ '{:010,.2f}'.format(-42) }}",
    "{}",
    output="-00,042.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #686" {
  jinja(
    source="{{ '{:.10g}'.format(-42) }}",
    "{}",
    output="-42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #687" {
  jinja(
    source="{{ '{:#g}'.format(-42) }}",
    "{}",
    output="-42.0000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #688" {
  jinja(
    source="{{ '{:s}'.format(-42) }}",
    "{}",
    error="ValueError: Unknown format code 's' for object of type 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #689" {
  jinja(
    source="{{ '{:}'.format(1234567) }}",
    "{}",
    output="1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #690" {
  jinja(
    source="{{ '{:d}'.format(1234567) }}",
    "{}",
    output="1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #691" {
  jinja(
    source="{{ '{:5d}'.format(1234567) }}",
    "{}",
    output="1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #692" {
  jinja(
    source="{{ '{:<6}'.format(1234567) }}",
    "{}",
    output="1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #693" {
  jinja(
    source="{{ '{:>6}'.format(1234567) }}",
    "{}",
    output="1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #694" {
  jinja(
    source="{{ '{:^7}'.format(1234567) }}",
    "{}",
    output="1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #695" {
  jinja(
    source="{{ '{:*^9}'.format(1234567) }}",
    "{}",
    output="*1234567*",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #696" {
  jinja(
    source="{{ '{:+}'.format(1234567) }}",
    "{}",
    output="+1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #697" {
  jinja(
    source="{{ '{: }'.format(1234567) }}",
    "{}",
    output=" 1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #698" {
  jinja(
    source="{{ '{:-}'.format(1234567) }}",
    "{}",
    output="1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #699" {
  jinja(
    source="{{ '{:,}'.format(1234567) }}",
    "{}",
    output="1,234,567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #700" {
  jinja(
    source="{{ '{:_}'.format(1234567) }}",
    "{}",
    output="1_234_567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #701" {
  jinja(
    source="{{ '{:08.3f}'.format(1234567) }}",
    "{}",
    output="1234567.000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #702" {
  jinja(
    source="{{ '{:.2f}'.format(1234567) }}",
    "{}",
    output="1234567.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #703" {
  jinja(
    source="{{ '{:.0f}'.format(1234567) }}",
    "{}",
    output="1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #704" {
  jinja(
    source="{{ '{:e}'.format(1234567) }}",
    "{}",
    output="1.234567e+06",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #705" {
  jinja(
    source="{{ '{:.3E}'.format(1234567) }}",
    "{}",
    output="1.235E+06",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #706" {
  jinja(
    source="{{ '{:g}'.format(1234567) }}",
    "{}",
    output="1.23457e+06",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #707" {
  jinja(
    source="{{ '{:.3g}'.format(1234567) }}",
    "{}",
    output="1.23e+06",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #708" {
  jinja(
    source="{{ '{:G}'.format(1234567) }}",
    "{}",
    output="1.23457E+06",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #709" {
  jinja(
    source="{{ '{:%}'.format(1234567) }}",
    "{}",
    output="123456700.000000%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #710" {
  jinja(
    source="{{ '{:.1%}'.format(1234567) }}",
    "{}",
    output="123456700.0%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #711" {
  jinja(
    source="{{ '{:x}'.format(1234567) }}",
    "{}",
    output="12d687",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #712" {
  jinja(
    source="{{ '{:X}'.format(1234567) }}",
    "{}",
    output="12D687",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #713" {
  jinja(
    source="{{ '{:#x}'.format(1234567) }}",
    "{}",
    output="0x12d687",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #714" {
  jinja(
    source="{{ '{:#o}'.format(1234567) }}",
    "{}",
    output="0o4553207",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #715" {
  jinja(
    source="{{ '{:b}'.format(1234567) }}",
    "{}",
    output="100101101011010000111",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #716" {
  jinja(
    source="{{ '{:#b}'.format(1234567) }}",
    "{}",
    output="0b100101101011010000111",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #717" {
  jinja(
    source="{{ '{:o}'.format(1234567) }}",
    "{}",
    output="4553207",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #718" {
  jinja(
    source="{{ '{:c}'.format(1234567) }}",
    "{}",
    error="OverflowError: %c arg not in range(0x110000)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #719" {
  jinja(
    source="{{ '{:n}'.format(1234567) }}",
    "{}",
    output="1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #720" {
  jinja(
    source="{{ '{:z.1f}'.format(1234567) }}",
    "{}",
    output="1234567.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #721" {
  jinja(
    source="{{ '{:=+8}'.format(1234567) }}",
    "{}",
    output="+1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #722" {
  jinja(
    source="{{ '{:010,.2f}'.format(1234567) }}",
    "{}",
    output="1,234,567.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #723" {
  jinja(
    source="{{ '{:.10g}'.format(1234567) }}",
    "{}",
    output="1234567",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #724" {
  jinja(
    source="{{ '{:#g}'.format(1234567) }}",
    "{}",
    output="1.23457e+06",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #725" {
  jinja(
    source="{{ '{:s}'.format(1234567) }}",
    "{}",
    error="ValueError: Unknown format code 's' for object of type 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #726" {
  jinja(
    source="{{ '{:}'.format(255) }}",
    "{}",
    output="255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #727" {
  jinja(
    source="{{ '{:d}'.format(255) }}",
    "{}",
    output="255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #728" {
  jinja(
    source="{{ '{:5d}'.format(255) }}",
    "{}",
    output="  255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #729" {
  jinja(
    source="{{ '{:<6}'.format(255) }}",
    "{}",
    output="255   ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #730" {
  jinja(
    source="{{ '{:>6}'.format(255) }}",
    "{}",
    output="   255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #731" {
  jinja(
    source="{{ '{:^7}'.format(255) }}",
    "{}",
    output="  255  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #732" {
  jinja(
    source="{{ '{:*^9}'.format(255) }}",
    "{}",
    output="***255***",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #733" {
  jinja(
    source="{{ '{:+}'.format(255) }}",
    "{}",
    output="+255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #734" {
  jinja(
    source="{{ '{: }'.format(255) }}",
    "{}",
    output=" 255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #735" {
  jinja(
    source="{{ '{:-}'.format(255) }}",
    "{}",
    output="255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #736" {
  jinja(
    source="{{ '{:,}'.format(255) }}",
    "{}",
    output="255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #737" {
  jinja(
    source="{{ '{:_}'.format(255) }}",
    "{}",
    output="255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #738" {
  jinja(
    source="{{ '{:08.3f}'.format(255) }}",
    "{}",
    output="0255.000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #739" {
  jinja(
    source="{{ '{:.2f}'.format(255) }}",
    "{}",
    output="255.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #740" {
  jinja(
    source="{{ '{:.0f}'.format(255) }}",
    "{}",
    output="255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #741" {
  jinja(
    source="{{ '{:e}'.format(255) }}",
    "{}",
    output="2.550000e+02",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #742" {
  jinja(
    source="{{ '{:.3E}'.format(255) }}",
    "{}",
    output="2.550E+02",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #743" {
  jinja(
    source="{{ '{:g}'.format(255) }}",
    "{}",
    output="255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #744" {
  jinja(
    source="{{ '{:.3g}'.format(255) }}",
    "{}",
    output="255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #745" {
  jinja(
    source="{{ '{:G}'.format(255) }}",
    "{}",
    output="255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #746" {
  jinja(
    source="{{ '{:%}'.format(255) }}",
    "{}",
    output="25500.000000%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #747" {
  jinja(
    source="{{ '{:.1%}'.format(255) }}",
    "{}",
    output="25500.0%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #748" {
  jinja(
    source="{{ '{:x}'.format(255) }}",
    "{}",
    output="ff",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #749" {
  jinja(
    source="{{ '{:X}'.format(255) }}",
    "{}",
    output="FF",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #750" {
  jinja(
    source="{{ '{:#x}'.format(255) }}",
    "{}",
    output="0xff",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #751" {
  jinja(
    source="{{ '{:#o}'.format(255) }}",
    "{}",
    output="0o377",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #752" {
  jinja(
    source="{{ '{:b}'.format(255) }}",
    "{}",
    output="11111111",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #753" {
  jinja(
    source="{{ '{:#b}'.format(255) }}",
    "{}",
    output="0b11111111",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #754" {
  jinja(
    source="{{ '{:o}'.format(255) }}",
    "{}",
    output="377",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #755" {
  jinja(
    source="{{ '{:c}'.format(255) }}",
    "{}",
    output="ÿ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #756" {
  jinja(
    source="{{ '{:n}'.format(255) }}",
    "{}",
    output="255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #757" {
  jinja(
    source="{{ '{:z.1f}'.format(255) }}",
    "{}",
    output="255.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #758" {
  jinja(
    source="{{ '{:=+8}'.format(255) }}",
    "{}",
    output="+    255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #759" {
  jinja(
    source="{{ '{:010,.2f}'.format(255) }}",
    "{}",
    output="000,255.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #760" {
  jinja(
    source="{{ '{:.10g}'.format(255) }}",
    "{}",
    output="255",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #761" {
  jinja(
    source="{{ '{:#g}'.format(255) }}",
    "{}",
    output="255.000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #762" {
  jinja(
    source="{{ '{:s}'.format(255) }}",
    "{}",
    error="ValueError: Unknown format code 's' for object of type 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #763" {
  jinja(
    source="{{ '{:}'.format(3.14159) }}",
    "{}",
    output="3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #764" {
  jinja(
    source="{{ '{:d}'.format(3.14159) }}",
    "{}",
    error="ValueError: Unknown format code 'd' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #765" {
  jinja(
    source="{{ '{:5d}'.format(3.14159) }}",
    "{}",
    error="ValueError: Unknown format code 'd' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #766" {
  jinja(
    source="{{ '{:<6}'.format(3.14159) }}",
    "{}",
    output="3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #767" {
  jinja(
    source="{{ '{:>6}'.format(3.14159) }}",
    "{}",
    output="3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #768" {
  jinja(
    source="{{ '{:^7}'.format(3.14159) }}",
    "{}",
    output="3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #769" {
  jinja(
    source="{{ '{:*^9}'.format(3.14159) }}",
    "{}",
    output="*3.14159*",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #770" {
  jinja(
    source="{{ '{:+}'.format(3.14159) }}",
    "{}",
    output="+3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #771" {
  jinja(
    source="{{ '{: }'.format(3.14159) }}",
    "{}",
    output=" 3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #772" {
  jinja(
    source="{{ '{:-}'.format(3.14159) }}",
    "{}",
    output="3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #773" {
  jinja(
    source="{{ '{:,}'.format(3.14159) }}",
    "{}",
    output="3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #774" {
  jinja(
    source="{{ '{:_}'.format(3.14159) }}",
    "{}",
    output="3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #775" {
  jinja(
    source="{{ '{:08.3f}'.format(3.14159) }}",
    "{}",
    output="0003.142",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #776" {
  jinja(
    source="{{ '{:.2f}'.format(3.14159) }}",
    "{}",
    output="3.14",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #777" {
  jinja(
    source="{{ '{:.0f}'.format(3.14159) }}",
    "{}",
    output="3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #778" {
  jinja(
    source="{{ '{:e}'.format(3.14159) }}",
    "{}",
    output="3.141590e+00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #779" {
  jinja(
    source="{{ '{:.3E}'.format(3.14159) }}",
    "{}",
    output="3.142E+00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #780" {
  jinja(
    source="{{ '{:g}'.format(3.14159) }}",
    "{}",
    output="3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #781" {
  jinja(
    source="{{ '{:.3g}'.format(3.14159) }}",
    "{}",
    output="3.14",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #782" {
  jinja(
    source="{{ '{:G}'.format(3.14159) }}",
    "{}",
    output="3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #783" {
  jinja(
    source="{{ '{:%}'.format(3.14159) }}",
    "{}",
    output="314.159000%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #784" {
  jinja(
    source="{{ '{:.1%}'.format(3.14159) }}",
    "{}",
    output="314.2%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #785" {
  jinja(
    source="{{ '{:x}'.format(3.14159) }}",
    "{}",
    error="ValueError: Unknown format code 'x' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #786" {
  jinja(
    source="{{ '{:X}'.format(3.14159) }}",
    "{}",
    error="ValueError: Unknown format code 'X' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #787" {
  jinja(
    source="{{ '{:#x}'.format(3.14159) }}",
    "{}",
    error="ValueError: Unknown format code 'x' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #788" {
  jinja(
    source="{{ '{:#o}'.format(3.14159) }}",
    "{}",
    error="ValueError: Unknown format code 'o' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #789" {
  jinja(
    source="{{ '{:b}'.format(3.14159) }}",
    "{}",
    error="ValueError: Unknown format code 'b' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #790" {
  jinja(
    source="{{ '{:#b}'.format(3.14159) }}",
    "{}",
    error="ValueError: Unknown format code 'b' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #791" {
  jinja(
    source="{{ '{:o}'.format(3.14159) }}",
    "{}",
    error="ValueError: Unknown format code 'o' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #792" {
  jinja(
    source="{{ '{:c}'.format(3.14159) }}",
    "{}",
    error="ValueError: Unknown format code 'c' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #793" {
  jinja(
    source="{{ '{:n}'.format(3.14159) }}",
    "{}",
    output="3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #794" {
  jinja(
    source="{{ '{:z.1f}'.format(3.14159) }}",
    "{}",
    output="3.1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #795" {
  jinja(
    source="{{ '{:=+8}'.format(3.14159) }}",
    "{}",
    output="+3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #796" {
  jinja(
    source="{{ '{:010,.2f}'.format(3.14159) }}",
    "{}",
    output="000,003.14",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #797" {
  jinja(
    source="{{ '{:.10g}'.format(3.14159) }}",
    "{}",
    output="3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #798" {
  jinja(
    source="{{ '{:#g}'.format(3.14159) }}",
    "{}",
    output="3.14159",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #799" {
  jinja(
    source="{{ '{:s}'.format(3.14159) }}",
    "{}",
    error="ValueError: Unknown format code 's' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #800" {
  jinja(
    source="{{ '{:}'.format(-0.5) }}",
    "{}",
    output="-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #801" {
  jinja(
    source="{{ '{:d}'.format(-0.5) }}",
    "{}",
    error="ValueError: Unknown format code 'd' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #802" {
  jinja(
    source="{{ '{:5d}'.format(-0.5) }}",
    "{}",
    error="ValueError: Unknown format code 'd' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #803" {
  jinja(
    source="{{ '{:<6}'.format(-0.5) }}",
    "{}",
    output="-0.5  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #804" {
  jinja(
    source="{{ '{:>6}'.format(-0.5) }}",
    "{}",
    output="  -0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #805" {
  jinja(
    source="{{ '{:^7}'.format(-0.5) }}",
    "{}",
    output=" -0.5  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #806" {
  jinja(
    source="{{ '{:*^9}'.format(-0.5) }}",
    "{}",
    output="**-0.5***",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #807" {
  jinja(
    source="{{ '{:+}'.format(-0.5) }}",
    "{}",
    output="-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #808" {
  jinja(
    source="{{ '{: }'.format(-0.5) }}",
    "{}",
    output="-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #809" {
  jinja(
    source="{{ '{:-}'.format(-0.5) }}",
    "{}",
    output="-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #810" {
  jinja(
    source="{{ '{:,}'.format(-0.5) }}",
    "{}",
    output="-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #811" {
  jinja(
    source="{{ '{:_}'.format(-0.5) }}",
    "{}",
    output="-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #812" {
  jinja(
    source="{{ '{:08.3f}'.format(-0.5) }}",
    "{}",
    output="-000.500",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #813" {
  jinja(
    source="{{ '{:.2f}'.format(-0.5) }}",
    "{}",
    output="-0.50",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #814" {
  jinja(
    source="{{ '{:.0f}'.format(-0.5) }}",
    "{}",
    output="-0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #815" {
  jinja(
    source="{{ '{:e}'.format(-0.5) }}",
    "{}",
    output="-5.000000e-01",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #816" {
  jinja(
    source="{{ '{:.3E}'.format(-0.5) }}",
    "{}",
    output="-5.000E-01",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #817" {
  jinja(
    source="{{ '{:g}'.format(-0.5) }}",
    "{}",
    output="-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #818" {
  jinja(
    source="{{ '{:.3g}'.format(-0.5) }}",
    "{}",
    output="-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #819" {
  jinja(
    source="{{ '{:G}'.format(-0.5) }}",
    "{}",
    output="-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #820" {
  jinja(
    source="{{ '{:%}'.format(-0.5) }}",
    "{}",
    output="-50.000000%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #821" {
  jinja(
    source="{{ '{:.1%}'.format(-0.5) }}",
    "{}",
    output="-50.0%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #822" {
  jinja(
    source="{{ '{:x}'.format(-0.5) }}",
    "{}",
    error="ValueError: Unknown format code 'x' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #823" {
  jinja(
    source="{{ '{:X}'.format(-0.5) }}",
    "{}",
    error="ValueError: Unknown format code 'X' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #824" {
  jinja(
    source="{{ '{:#x}'.format(-0.5) }}",
    "{}",
    error="ValueError: Unknown format code 'x' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #825" {
  jinja(
    source="{{ '{:#o}'.format(-0.5) }}",
    "{}",
    error="ValueError: Unknown format code 'o' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #826" {
  jinja(
    source="{{ '{:b}'.format(-0.5) }}",
    "{}",
    error="ValueError: Unknown format code 'b' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #827" {
  jinja(
    source="{{ '{:#b}'.format(-0.5) }}",
    "{}",
    error="ValueError: Unknown format code 'b' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #828" {
  jinja(
    source="{{ '{:o}'.format(-0.5) }}",
    "{}",
    error="ValueError: Unknown format code 'o' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #829" {
  jinja(
    source="{{ '{:c}'.format(-0.5) }}",
    "{}",
    error="ValueError: Unknown format code 'c' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #830" {
  jinja(
    source="{{ '{:n}'.format(-0.5) }}",
    "{}",
    output="-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #831" {
  jinja(
    source="{{ '{:z.1f}'.format(-0.5) }}",
    "{}",
    output="-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #832" {
  jinja(
    source="{{ '{:=+8}'.format(-0.5) }}",
    "{}",
    output="-    0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #833" {
  jinja(
    source="{{ '{:010,.2f}'.format(-0.5) }}",
    "{}",
    output="-00,000.50",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #834" {
  jinja(
    source="{{ '{:.10g}'.format(-0.5) }}",
    "{}",
    output="-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #835" {
  jinja(
    source="{{ '{:#g}'.format(-0.5) }}",
    "{}",
    output="-0.500000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #836" {
  jinja(
    source="{{ '{:s}'.format(-0.5) }}",
    "{}",
    error="ValueError: Unknown format code 's' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #837" {
  jinja(
    source="{{ '{:}'.format(1e+21) }}",
    "{}",
    output="1e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #838" {
  jinja(
    source="{{ '{:d}'.format(1e+21) }}",
    "{}",
    error="ValueError: Unknown format code 'd' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #839" {
  jinja(
    source="{{ '{:5d}'.format(1e+21) }}",
    "{}",
    error="ValueError: Unknown format code 'd' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #840" {
  jinja(
    source="{{ '{:<6}'.format(1e+21) }}",
    "{}",
    output="1e+21 ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #841" {
  jinja(
    source="{{ '{:>6}'.format(1e+21) }}",
    "{}",
    output=" 1e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #842" {
  jinja(
    source="{{ '{:^7}'.format(1e+21) }}",
    "{}",
    output=" 1e+21 ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #843" {
  jinja(
    source="{{ '{:*^9}'.format(1e+21) }}",
    "{}",
    output="**1e+21**",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #844" {
  jinja(
    source="{{ '{:+}'.format(1e+21) }}",
    "{}",
    output="+1e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #845" {
  jinja(
    source="{{ '{: }'.format(1e+21) }}",
    "{}",
    output=" 1e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #846" {
  jinja(
    source="{{ '{:-}'.format(1e+21) }}",
    "{}",
    output="1e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #847" {
  jinja(
    source="{{ '{:,}'.format(1e+21) }}",
    "{}",
    output="1e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #848" {
  jinja(
    source="{{ '{:_}'.format(1e+21) }}",
    "{}",
    output="1e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #849" {
  jinja(
    source="{{ '{:08.3f}'.format(1e+21) }}",
    "{}",
    output="1000000000000000000000.000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #850" {
  jinja(
    source="{{ '{:.2f}'.format(1e+21) }}",
    "{}",
    output="1000000000000000000000.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #851" {
  jinja(
    source="{{ '{:.0f}'.format(1e+21) }}",
    "{}",
    output="1000000000000000000000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #852" {
  jinja(
    source="{{ '{:e}'.format(1e+21) }}",
    "{}",
    output="1.000000e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #853" {
  jinja(
    source="{{ '{:.3E}'.format(1e+21) }}",
    "{}",
    output="1.000E+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #854" {
  jinja(
    source="{{ '{:g}'.format(1e+21) }}",
    "{}",
    output="1e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #855" {
  jinja(
    source="{{ '{:.3g}'.format(1e+21) }}",
    "{}",
    output="1e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #856" {
  jinja(
    source="{{ '{:G}'.format(1e+21) }}",
    "{}",
    output="1E+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #857" {
  jinja(
    source="{{ '{:%}'.format(1e+21) }}",
    "{}",
    output="99999999999999991611392.000000%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #858" {
  jinja(
    source="{{ '{:.1%}'.format(1e+21) }}",
    "{}",
    output="99999999999999991611392.0%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #859" {
  jinja(
    source="{{ '{:x}'.format(1e+21) }}",
    "{}",
    error="ValueError: Unknown format code 'x' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #860" {
  jinja(
    source="{{ '{:X}'.format(1e+21) }}",
    "{}",
    error="ValueError: Unknown format code 'X' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #861" {
  jinja(
    source="{{ '{:#x}'.format(1e+21) }}",
    "{}",
    error="ValueError: Unknown format code 'x' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #862" {
  jinja(
    source="{{ '{:#o}'.format(1e+21) }}",
    "{}",
    error="ValueError: Unknown format code 'o' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #863" {
  jinja(
    source="{{ '{:b}'.format(1e+21) }}",
    "{}",
    error="ValueError: Unknown format code 'b' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #864" {
  jinja(
    source="{{ '{:#b}'.format(1e+21) }}",
    "{}",
    error="ValueError: Unknown format code 'b' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #865" {
  jinja(
    source="{{ '{:o}'.format(1e+21) }}",
    "{}",
    error="ValueError: Unknown format code 'o' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #866" {
  jinja(
    source="{{ '{:c}'.format(1e+21) }}",
    "{}",
    error="ValueError: Unknown format code 'c' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #867" {
  jinja(
    source="{{ '{:n}'.format(1e+21) }}",
    "{}",
    output="1e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #868" {
  jinja(
    source="{{ '{:z.1f}'.format(1e+21) }}",
    "{}",
    output="1000000000000000000000.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #869" {
  jinja(
    source="{{ '{:=+8}'.format(1e+21) }}",
    "{}",
    output="+  1e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #870" {
  jinja(
    source="{{ '{:010,.2f}'.format(1e+21) }}",
    "{}",
    output="1,000,000,000,000,000,000,000.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #871" {
  jinja(
    source="{{ '{:.10g}'.format(1e+21) }}",
    "{}",
    output="1e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #872" {
  jinja(
    source="{{ '{:#g}'.format(1e+21) }}",
    "{}",
    output="1.00000e+21",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #873" {
  jinja(
    source="{{ '{:s}'.format(1e+21) }}",
    "{}",
    error="ValueError: Unknown format code 's' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #874" {
  jinja(
    source="{{ '{:}'.format(1.5e-07) }}",
    "{}",
    output="1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #875" {
  jinja(
    source="{{ '{:d}'.format(1.5e-07) }}",
    "{}",
    error="ValueError: Unknown format code 'd' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #876" {
  jinja(
    source="{{ '{:5d}'.format(1.5e-07) }}",
    "{}",
    error="ValueError: Unknown format code 'd' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #877" {
  jinja(
    source="{{ '{:<6}'.format(1.5e-07) }}",
    "{}",
    output="1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #878" {
  jinja(
    source="{{ '{:>6}'.format(1.5e-07) }}",
    "{}",
    output="1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #879" {
  jinja(
    source="{{ '{:^7}'.format(1.5e-07) }}",
    "{}",
    output="1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #880" {
  jinja(
    source="{{ '{:*^9}'.format(1.5e-07) }}",
    "{}",
    output="*1.5e-07*",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #881" {
  jinja(
    source="{{ '{:+}'.format(1.5e-07) }}",
    "{}",
    output="+1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #882" {
  jinja(
    source="{{ '{: }'.format(1.5e-07) }}",
    "{}",
    output=" 1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #883" {
  jinja(
    source="{{ '{:-}'.format(1.5e-07) }}",
    "{}",
    output="1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #884" {
  jinja(
    source="{{ '{:,}'.format(1.5e-07) }}",
    "{}",
    output="1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #885" {
  jinja(
    source="{{ '{:_}'.format(1.5e-07) }}",
    "{}",
    output="1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #886" {
  jinja(
    source="{{ '{:08.3f}'.format(1.5e-07) }}",
    "{}",
    output="0000.000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #887" {
  jinja(
    source="{{ '{:.2f}'.format(1.5e-07) }}",
    "{}",
    output="0.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #888" {
  jinja(
    source="{{ '{:.0f}'.format(1.5e-07) }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #889" {
  jinja(
    source="{{ '{:e}'.format(1.5e-07) }}",
    "{}",
    output="1.500000e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #890" {
  jinja(
    source="{{ '{:.3E}'.format(1.5e-07) }}",
    "{}",
    output="1.500E-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #891" {
  jinja(
    source="{{ '{:g}'.format(1.5e-07) }}",
    "{}",
    output="1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #892" {
  jinja(
    source="{{ '{:.3g}'.format(1.5e-07) }}",
    "{}",
    output="1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #893" {
  jinja(
    source="{{ '{:G}'.format(1.5e-07) }}",
    "{}",
    output="1.5E-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #894" {
  jinja(
    source="{{ '{:%}'.format(1.5e-07) }}",
    "{}",
    output="0.000015%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #895" {
  jinja(
    source="{{ '{:.1%}'.format(1.5e-07) }}",
    "{}",
    output="0.0%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #896" {
  jinja(
    source="{{ '{:x}'.format(1.5e-07) }}",
    "{}",
    error="ValueError: Unknown format code 'x' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #897" {
  jinja(
    source="{{ '{:X}'.format(1.5e-07) }}",
    "{}",
    error="ValueError: Unknown format code 'X' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #898" {
  jinja(
    source="{{ '{:#x}'.format(1.5e-07) }}",
    "{}",
    error="ValueError: Unknown format code 'x' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #899" {
  jinja(
    source="{{ '{:#o}'.format(1.5e-07) }}",
    "{}",
    error="ValueError: Unknown format code 'o' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #900" {
  jinja(
    source="{{ '{:b}'.format(1.5e-07) }}",
    "{}",
    error="ValueError: Unknown format code 'b' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #901" {
  jinja(
    source="{{ '{:#b}'.format(1.5e-07) }}",
    "{}",
    error="ValueError: Unknown format code 'b' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #902" {
  jinja(
    source="{{ '{:o}'.format(1.5e-07) }}",
    "{}",
    error="ValueError: Unknown format code 'o' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #903" {
  jinja(
    source="{{ '{:c}'.format(1.5e-07) }}",
    "{}",
    error="ValueError: Unknown format code 'c' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #904" {
  jinja(
    source="{{ '{:n}'.format(1.5e-07) }}",
    "{}",
    output="1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #905" {
  jinja(
    source="{{ '{:z.1f}'.format(1.5e-07) }}",
    "{}",
    output="0.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #906" {
  jinja(
    source="{{ '{:=+8}'.format(1.5e-07) }}",
    "{}",
    output="+1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #907" {
  jinja(
    source="{{ '{:010,.2f}'.format(1.5e-07) }}",
    "{}",
    output="000,000.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #908" {
  jinja(
    source="{{ '{:.10g}'.format(1.5e-07) }}",
    "{}",
    output="1.5e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #909" {
  jinja(
    source="{{ '{:#g}'.format(1.5e-07) }}",
    "{}",
    output="1.50000e-07",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #910" {
  jinja(
    source="{{ '{:s}'.format(1.5e-07) }}",
    "{}",
    error="ValueError: Unknown format code 's' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #911" {
  jinja(
    source="{{ '{:}'.format(2.5) }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #912" {
  jinja(
    source="{{ '{:d}'.format(2.5) }}",
    "{}",
    error="ValueError: Unknown format code 'd' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #913" {
  jinja(
    source="{{ '{:5d}'.format(2.5) }}",
    "{}",
    error="ValueError: Unknown format code 'd' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #914" {
  jinja(
    source="{{ '{:<6}'.format(2.5) }}",
    "{}",
    output="2.5   ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #915" {
  jinja(
    source="{{ '{:>6}'.format(2.5) }}",
    "{}",
    output="   2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #916" {
  jinja(
    source="{{ '{:^7}'.format(2.5) }}",
    "{}",
    output="  2.5  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #917" {
  jinja(
    source="{{ '{:*^9}'.format(2.5) }}",
    "{}",
    output="***2.5***",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #918" {
  jinja(
    source="{{ '{:+}'.format(2.5) }}",
    "{}",
    output="+2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #919" {
  jinja(
    source="{{ '{: }'.format(2.5) }}",
    "{}",
    output=" 2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #920" {
  jinja(
    source="{{ '{:-}'.format(2.5) }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #921" {
  jinja(
    source="{{ '{:,}'.format(2.5) }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #922" {
  jinja(
    source="{{ '{:_}'.format(2.5) }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #923" {
  jinja(
    source="{{ '{:08.3f}'.format(2.5) }}",
    "{}",
    output="0002.500",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #924" {
  jinja(
    source="{{ '{:.2f}'.format(2.5) }}",
    "{}",
    output="2.50",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #925" {
  jinja(
    source="{{ '{:.0f}'.format(2.5) }}",
    "{}",
    output="2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #926" {
  jinja(
    source="{{ '{:e}'.format(2.5) }}",
    "{}",
    output="2.500000e+00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #927" {
  jinja(
    source="{{ '{:.3E}'.format(2.5) }}",
    "{}",
    output="2.500E+00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #928" {
  jinja(
    source="{{ '{:g}'.format(2.5) }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #929" {
  jinja(
    source="{{ '{:.3g}'.format(2.5) }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #930" {
  jinja(
    source="{{ '{:G}'.format(2.5) }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #931" {
  jinja(
    source="{{ '{:%}'.format(2.5) }}",
    "{}",
    output="250.000000%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #932" {
  jinja(
    source="{{ '{:.1%}'.format(2.5) }}",
    "{}",
    output="250.0%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #933" {
  jinja(
    source="{{ '{:x}'.format(2.5) }}",
    "{}",
    error="ValueError: Unknown format code 'x' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #934" {
  jinja(
    source="{{ '{:X}'.format(2.5) }}",
    "{}",
    error="ValueError: Unknown format code 'X' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #935" {
  jinja(
    source="{{ '{:#x}'.format(2.5) }}",
    "{}",
    error="ValueError: Unknown format code 'x' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #936" {
  jinja(
    source="{{ '{:#o}'.format(2.5) }}",
    "{}",
    error="ValueError: Unknown format code 'o' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #937" {
  jinja(
    source="{{ '{:b}'.format(2.5) }}",
    "{}",
    error="ValueError: Unknown format code 'b' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #938" {
  jinja(
    source="{{ '{:#b}'.format(2.5) }}",
    "{}",
    error="ValueError: Unknown format code 'b' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #939" {
  jinja(
    source="{{ '{:o}'.format(2.5) }}",
    "{}",
    error="ValueError: Unknown format code 'o' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #940" {
  jinja(
    source="{{ '{:c}'.format(2.5) }}",
    "{}",
    error="ValueError: Unknown format code 'c' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #941" {
  jinja(
    source="{{ '{:n}'.format(2.5) }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #942" {
  jinja(
    source="{{ '{:z.1f}'.format(2.5) }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #943" {
  jinja(
    source="{{ '{:=+8}'.format(2.5) }}",
    "{}",
    output="+    2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #944" {
  jinja(
    source="{{ '{:010,.2f}'.format(2.5) }}",
    "{}",
    output="000,002.50",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #945" {
  jinja(
    source="{{ '{:.10g}'.format(2.5) }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #946" {
  jinja(
    source="{{ '{:#g}'.format(2.5) }}",
    "{}",
    output="2.50000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #947" {
  jinja(
    source="{{ '{:s}'.format(2.5) }}",
    "{}",
    error="ValueError: Unknown format code 's' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #948" {
  jinja(
    source="{{ '{:}'.format(100.0) }}",
    "{}",
    output="100.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #949" {
  jinja(
    source="{{ '{:d}'.format(100.0) }}",
    "{}",
    error="ValueError: Unknown format code 'd' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #950" {
  jinja(
    source="{{ '{:5d}'.format(100.0) }}",
    "{}",
    error="ValueError: Unknown format code 'd' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #951" {
  jinja(
    source="{{ '{:<6}'.format(100.0) }}",
    "{}",
    output="100.0 ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #952" {
  jinja(
    source="{{ '{:>6}'.format(100.0) }}",
    "{}",
    output=" 100.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #953" {
  jinja(
    source="{{ '{:^7}'.format(100.0) }}",
    "{}",
    output=" 100.0 ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #954" {
  jinja(
    source="{{ '{:*^9}'.format(100.0) }}",
    "{}",
    output="**100.0**",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #955" {
  jinja(
    source="{{ '{:+}'.format(100.0) }}",
    "{}",
    output="+100.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #956" {
  jinja(
    source="{{ '{: }'.format(100.0) }}",
    "{}",
    output=" 100.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #957" {
  jinja(
    source="{{ '{:-}'.format(100.0) }}",
    "{}",
    output="100.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #958" {
  jinja(
    source="{{ '{:,}'.format(100.0) }}",
    "{}",
    output="100.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #959" {
  jinja(
    source="{{ '{:_}'.format(100.0) }}",
    "{}",
    output="100.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #960" {
  jinja(
    source="{{ '{:08.3f}'.format(100.0) }}",
    "{}",
    output="0100.000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #961" {
  jinja(
    source="{{ '{:.2f}'.format(100.0) }}",
    "{}",
    output="100.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #962" {
  jinja(
    source="{{ '{:.0f}'.format(100.0) }}",
    "{}",
    output="100",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #963" {
  jinja(
    source="{{ '{:e}'.format(100.0) }}",
    "{}",
    output="1.000000e+02",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #964" {
  jinja(
    source="{{ '{:.3E}'.format(100.0) }}",
    "{}",
    output="1.000E+02",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #965" {
  jinja(
    source="{{ '{:g}'.format(100.0) }}",
    "{}",
    output="100",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #966" {
  jinja(
    source="{{ '{:.3g}'.format(100.0) }}",
    "{}",
    output="100",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #967" {
  jinja(
    source="{{ '{:G}'.format(100.0) }}",
    "{}",
    output="100",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #968" {
  jinja(
    source="{{ '{:%}'.format(100.0) }}",
    "{}",
    output="10000.000000%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #969" {
  jinja(
    source="{{ '{:.1%}'.format(100.0) }}",
    "{}",
    output="10000.0%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #970" {
  jinja(
    source="{{ '{:x}'.format(100.0) }}",
    "{}",
    error="ValueError: Unknown format code 'x' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #971" {
  jinja(
    source="{{ '{:X}'.format(100.0) }}",
    "{}",
    error="ValueError: Unknown format code 'X' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #972" {
  jinja(
    source="{{ '{:#x}'.format(100.0) }}",
    "{}",
    error="ValueError: Unknown format code 'x' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #973" {
  jinja(
    source="{{ '{:#o}'.format(100.0) }}",
    "{}",
    error="ValueError: Unknown format code 'o' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #974" {
  jinja(
    source="{{ '{:b}'.format(100.0) }}",
    "{}",
    error="ValueError: Unknown format code 'b' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #975" {
  jinja(
    source="{{ '{:#b}'.format(100.0) }}",
    "{}",
    error="ValueError: Unknown format code 'b' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #976" {
  jinja(
    source="{{ '{:o}'.format(100.0) }}",
    "{}",
    error="ValueError: Unknown format code 'o' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #977" {
  jinja(
    source="{{ '{:c}'.format(100.0) }}",
    "{}",
    error="ValueError: Unknown format code 'c' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #978" {
  jinja(
    source="{{ '{:n}'.format(100.0) }}",
    "{}",
    output="100",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #979" {
  jinja(
    source="{{ '{:z.1f}'.format(100.0) }}",
    "{}",
    output="100.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #980" {
  jinja(
    source="{{ '{:=+8}'.format(100.0) }}",
    "{}",
    output="+  100.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #981" {
  jinja(
    source="{{ '{:010,.2f}'.format(100.0) }}",
    "{}",
    output="000,100.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #982" {
  jinja(
    source="{{ '{:.10g}'.format(100.0) }}",
    "{}",
    output="100",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #983" {
  jinja(
    source="{{ '{:#g}'.format(100.0) }}",
    "{}",
    output="100.000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #984" {
  jinja(
    source="{{ '{:s}'.format(100.0) }}",
    "{}",
    error="ValueError: Unknown format code 's' for object of type 'float'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #985" {
  jinja(
    source="{{ '{:}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #986" {
  jinja(
    source="{{ '{:d}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #987" {
  jinja(
    source="{{ '{:5d}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #988" {
  jinja(
    source="{{ '{:<6}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #989" {
  jinja(
    source="{{ '{:>6}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #990" {
  jinja(
    source="{{ '{:^7}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #991" {
  jinja(
    source="{{ '{:*^9}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #992" {
  jinja(
    source="{{ '{:+}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #993" {
  jinja(
    source="{{ '{: }'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #994" {
  jinja(
    source="{{ '{:-}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #995" {
  jinja(
    source="{{ '{:,}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #996" {
  jinja(
    source="{{ '{:_}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #997" {
  jinja(
    source="{{ '{:08.3f}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #998" {
  jinja(
    source="{{ '{:.2f}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #999" {
  jinja(
    source="{{ '{:.0f}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1000" {
  jinja(
    source="{{ '{:e}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1001" {
  jinja(
    source="{{ '{:.3E}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1002" {
  jinja(
    source="{{ '{:g}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1003" {
  jinja(
    source="{{ '{:.3g}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1004" {
  jinja(
    source="{{ '{:G}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1005" {
  jinja(
    source="{{ '{:%}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1006" {
  jinja(
    source="{{ '{:.1%}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1007" {
  jinja(
    source="{{ '{:x}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1008" {
  jinja(
    source="{{ '{:X}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1009" {
  jinja(
    source="{{ '{:#x}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1010" {
  jinja(
    source="{{ '{:#o}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1011" {
  jinja(
    source="{{ '{:b}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1012" {
  jinja(
    source="{{ '{:#b}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1013" {
  jinja(
    source="{{ '{:o}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1014" {
  jinja(
    source="{{ '{:c}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1015" {
  jinja(
    source="{{ '{:n}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1016" {
  jinja(
    source="{{ '{:z.1f}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1017" {
  jinja(
    source="{{ '{:=+8}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1018" {
  jinja(
    source="{{ '{:010,.2f}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1019" {
  jinja(
    source="{{ '{:.10g}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1020" {
  jinja(
    source="{{ '{:#g}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1021" {
  jinja(
    source="{{ '{:s}'.format(float('nan')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1022" {
  jinja(
    source="{{ '{:}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1023" {
  jinja(
    source="{{ '{:d}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1024" {
  jinja(
    source="{{ '{:5d}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1025" {
  jinja(
    source="{{ '{:<6}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1026" {
  jinja(
    source="{{ '{:>6}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1027" {
  jinja(
    source="{{ '{:^7}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1028" {
  jinja(
    source="{{ '{:*^9}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1029" {
  jinja(
    source="{{ '{:+}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1030" {
  jinja(
    source="{{ '{: }'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1031" {
  jinja(
    source="{{ '{:-}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1032" {
  jinja(
    source="{{ '{:,}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1033" {
  jinja(
    source="{{ '{:_}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1034" {
  jinja(
    source="{{ '{:08.3f}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1035" {
  jinja(
    source="{{ '{:.2f}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1036" {
  jinja(
    source="{{ '{:.0f}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1037" {
  jinja(
    source="{{ '{:e}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1038" {
  jinja(
    source="{{ '{:.3E}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1039" {
  jinja(
    source="{{ '{:g}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1040" {
  jinja(
    source="{{ '{:.3g}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1041" {
  jinja(
    source="{{ '{:G}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1042" {
  jinja(
    source="{{ '{:%}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1043" {
  jinja(
    source="{{ '{:.1%}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1044" {
  jinja(
    source="{{ '{:x}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1045" {
  jinja(
    source="{{ '{:X}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1046" {
  jinja(
    source="{{ '{:#x}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1047" {
  jinja(
    source="{{ '{:#o}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1048" {
  jinja(
    source="{{ '{:b}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1049" {
  jinja(
    source="{{ '{:#b}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1050" {
  jinja(
    source="{{ '{:o}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1051" {
  jinja(
    source="{{ '{:c}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1052" {
  jinja(
    source="{{ '{:n}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1053" {
  jinja(
    source="{{ '{:z.1f}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1054" {
  jinja(
    source="{{ '{:=+8}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1055" {
  jinja(
    source="{{ '{:010,.2f}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1056" {
  jinja(
    source="{{ '{:.10g}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1057" {
  jinja(
    source="{{ '{:#g}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1058" {
  jinja(
    source="{{ '{:s}'.format(float('inf')) }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1059" {
  jinja(
    source="{{ '{:}'.format(true) }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1060" {
  jinja(
    source="{{ '{:d}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1061" {
  jinja(
    source="{{ '{:5d}'.format(true) }}",
    "{}",
    output="    1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1062" {
  jinja(
    source="{{ '{:<6}'.format(true) }}",
    "{}",
    output="1     ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1063" {
  jinja(
    source="{{ '{:>6}'.format(true) }}",
    "{}",
    output="     1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1064" {
  jinja(
    source="{{ '{:^7}'.format(true) }}",
    "{}",
    output="   1   ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1065" {
  jinja(
    source="{{ '{:*^9}'.format(true) }}",
    "{}",
    output="****1****",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1066" {
  jinja(
    source="{{ '{:+}'.format(true) }}",
    "{}",
    output="+1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1067" {
  jinja(
    source="{{ '{: }'.format(true) }}",
    "{}",
    output=" 1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1068" {
  jinja(
    source="{{ '{:-}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1069" {
  jinja(
    source="{{ '{:,}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1070" {
  jinja(
    source="{{ '{:_}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1071" {
  jinja(
    source="{{ '{:08.3f}'.format(true) }}",
    "{}",
    output="0001.000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1072" {
  jinja(
    source="{{ '{:.2f}'.format(true) }}",
    "{}",
    output="1.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1073" {
  jinja(
    source="{{ '{:.0f}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1074" {
  jinja(
    source="{{ '{:e}'.format(true) }}",
    "{}",
    output="1.000000e+00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1075" {
  jinja(
    source="{{ '{:.3E}'.format(true) }}",
    "{}",
    output="1.000E+00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1076" {
  jinja(
    source="{{ '{:g}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1077" {
  jinja(
    source="{{ '{:.3g}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1078" {
  jinja(
    source="{{ '{:G}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1079" {
  jinja(
    source="{{ '{:%}'.format(true) }}",
    "{}",
    output="100.000000%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1080" {
  jinja(
    source="{{ '{:.1%}'.format(true) }}",
    "{}",
    output="100.0%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1081" {
  jinja(
    source="{{ '{:x}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1082" {
  jinja(
    source="{{ '{:X}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1083" {
  jinja(
    source="{{ '{:#x}'.format(true) }}",
    "{}",
    output="0x1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1084" {
  jinja(
    source="{{ '{:#o}'.format(true) }}",
    "{}",
    output="0o1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1085" {
  jinja(
    source="{{ '{:b}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1086" {
  jinja(
    source="{{ '{:#b}'.format(true) }}",
    "{}",
    output="0b1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1087" {
  jinja(
    source="{{ '{:o}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1088" {
  jinja(
    source="{{ '{:c}'.format(true) }}",
    "{}",
    output="\u0001",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1089" {
  jinja(
    source="{{ '{:n}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1090" {
  jinja(
    source="{{ '{:z.1f}'.format(true) }}",
    "{}",
    output="1.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1091" {
  jinja(
    source="{{ '{:=+8}'.format(true) }}",
    "{}",
    output="+      1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1092" {
  jinja(
    source="{{ '{:010,.2f}'.format(true) }}",
    "{}",
    output="000,001.00",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1093" {
  jinja(
    source="{{ '{:.10g}'.format(true) }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1094" {
  jinja(
    source="{{ '{:#g}'.format(true) }}",
    "{}",
    output="1.00000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1095" {
  jinja(
    source="{{ '{:s}'.format(true) }}",
    "{}",
    error="ValueError: Unknown format code 's' for object of type 'bool'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1096" {
  jinja(
    source="{{ '{:}'.format(v) }}",
    "{\"v\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1097" {
  jinja(
    source="{{ '{:5}'.format(v) }}",
    "{\"v\": \"\"}",
    output="     ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1098" {
  jinja(
    source="{{ '{:<5}'.format(v) }}",
    "{\"v\": \"\"}",
    output="     ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1099" {
  jinja(
    source="{{ '{:>5}'.format(v) }}",
    "{\"v\": \"\"}",
    output="     ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1100" {
  jinja(
    source="{{ '{:^6}'.format(v) }}",
    "{\"v\": \"\"}",
    output="      ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1101" {
  jinja(
    source="{{ '{:*>4}'.format(v) }}",
    "{\"v\": \"\"}",
    output="****",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1102" {
  jinja(
    source="{{ '{:.1}'.format(v) }}",
    "{\"v\": \"\"}",
    output="",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1103" {
  jinja(
    source="{{ '{:8.2}'.format(v) }}",
    "{\"v\": \"\"}",
    output="        ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1104" {
  jinja(
    source="{{ '{:}'.format(v) }}",
    "{\"v\": \"ab\"}",
    output="ab",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1105" {
  jinja(
    source="{{ '{:5}'.format(v) }}",
    "{\"v\": \"ab\"}",
    output="ab   ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1106" {
  jinja(
    source="{{ '{:<5}'.format(v) }}",
    "{\"v\": \"ab\"}",
    output="ab   ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1107" {
  jinja(
    source="{{ '{:>5}'.format(v) }}",
    "{\"v\": \"ab\"}",
    output="   ab",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1108" {
  jinja(
    source="{{ '{:^6}'.format(v) }}",
    "{\"v\": \"ab\"}",
    output="  ab  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1109" {
  jinja(
    source="{{ '{:*>4}'.format(v) }}",
    "{\"v\": \"ab\"}",
    output="**ab",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1110" {
  jinja(
    source="{{ '{:.1}'.format(v) }}",
    "{\"v\": \"ab\"}",
    output="a",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1111" {
  jinja(
    source="{{ '{:8.2}'.format(v) }}",
    "{\"v\": \"ab\"}",
    output="ab      ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1112" {
  jinja(
    source="{{ '{:}'.format(v) }}",
    "{\"v\": \"ünï\"}",
    output="ünï",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1113" {
  jinja(
    source="{{ '{:5}'.format(v) }}",
    "{\"v\": \"ünï\"}",
    output="ünï  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1114" {
  jinja(
    source="{{ '{:<5}'.format(v) }}",
    "{\"v\": \"ünï\"}",
    output="ünï  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1115" {
  jinja(
    source="{{ '{:>5}'.format(v) }}",
    "{\"v\": \"ünï\"}",
    output="  ünï",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1116" {
  jinja(
    source="{{ '{:^6}'.format(v) }}",
    "{\"v\": \"ünï\"}",
    output=" ünï  ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1117" {
  jinja(
    source="{{ '{:*>4}'.format(v) }}",
    "{\"v\": \"ünï\"}",
    output="*ünï",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1118" {
  jinja(
    source="{{ '{:.1}'.format(v) }}",
    "{\"v\": \"ünï\"}",
    output="ü",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1119" {
  jinja(
    source="{{ '{:8.2}'.format(v) }}",
    "{\"v\": \"ünï\"}",
    output="ün      ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1120" {
  jinja(
    source="{{ '%s' % 'x' }}",
    "{}",
    output="x",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1121" {
  jinja(
    source="{{ '%r' % 'x' }}",
    "{}",
    output="&#39;x&#39;",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1122" {
  jinja(
    source="{{ '%d' % 3.9 }}",
    "{}",
    output="3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1123" {
  jinja(
    source="{{ '%i' % -4 }}",
    "{}",
    output="-4",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1124" {
  jinja(
    source="{{ '%5d' % 42 }}",
    "{}",
    output="   42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1125" {
  jinja(
    source="{{ '%-5d|' % 42 }}",
    "{}",
    output="42   |",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1126" {
  jinja(
    source="{{ '%05d' % -42 }}",
    "{}",
    output="-0042",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1127" {
  jinja(
    source="{{ '%+d' % 5 }}",
    "{}",
    output="+5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1128" {
  jinja(
    source="{{ '% d' % 5 }}",
    "{}",
    output=" 5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1129" {
  jinja(
    source="{{ '%x' % 255 }}",
    "{}",
    output="ff",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1130" {
  jinja(
    source="{{ '%#X' % 255 }}",
    "{}",
    output="0XFF",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1131" {
  jinja(
    source="{{ '%o' % 8 }}",
    "{}",
    output="10",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1132" {
  jinja(
    source="{{ '%#o' % 8 }}",
    "{}",
    output="0o10",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1133" {
  jinja(
    source="{{ '%e' % 1234.5 }}",
    "{}",
    output="1.234500e+03",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1134" {
  jinja(
    source="{{ '%.2E' % 0.000123 }}",
    "{}",
    output="1.23E-04",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1135" {
  jinja(
    source="{{ '%f' % 2.5 }}",
    "{}",
    output="2.500000",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1136" {
  jinja(
    source="{{ '%.0f' % 2.5 }}",
    "{}",
    output="2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1137" {
  jinja(
    source="{{ '%.0f' % 3.5 }}",
    "{}",
    output="4",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1138" {
  jinja(
    source="{{ '%10.3f|' % 3.14159 }}",
    "{}",
    output="     3.142|",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1139" {
  jinja(
    source="{{ '%g' % 0.0001 }}",
    "{}",
    output="0.0001",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1140" {
  jinja(
    source="{{ '%g' % 123456789 }}",
    "{}",
    output="1.23457e+08",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1141" {
  jinja(
    source="{{ '%G' % 1e-10 }}",
    "{}",
    output="1E-10",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1142" {
  jinja(
    source="{{ '%c' % 65 }}",
    "{}",
    output="A",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1143" {
  jinja(
    source="{{ '%c' % 'z' }}",
    "{}",
    output="z",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1144" {
  jinja(
    source="{{ '%%' % () }}",
    "{}",
    output="%",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1145" {
  jinja(
    source="{{ '%s and %s' % ('a', 'b') }}",
    "{}",
    output="a and b",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1146" {
  jinja(
    source="{{ '%(a)s-%(b)d' % {'a': 'x', 'b': 2} }}",
    "{}",
    output="x-2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1147" {
  jinja(
    source="{{ '%*d' % (5, 3) }}",
    "{}",
    output="    3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1148" {
  jinja(
    source="{{ '%.*f' % (2, 3.14159) }}",
    "{}",
    output="3.14",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1149" {
  jinja(
    source="{{ '%s' % (1, 2) }}",
    "{}",
    error="TypeError: not all arguments converted during string formatting (required 1, got 2)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1150" {
  jinja(
    source="{{ '%s' % [1, 2] }}",
    "{}",
    output="[1, 2]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1151" {
  jinja(
    source="{{ '%s' % none }}",
    "{}",
    output="None",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1152" {
  jinja(
    source="{{ '%r' % '<b>' }}",
    "{}",
    output="&#39;&lt;b&gt;&#39;",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1153" {
  jinja(
    source="{{ '%a' % 'é' }}",
    "{}",
    output="&#39;\\xe9&#39;",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1154" {
  jinja(
    source="{{ '%d' % 'x' }}",
    "{}",
    error="TypeError: format argument: %d requires a real number, not str",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1155" {
  jinja(
    source="{{ '%s %s' % ('a',) }}",
    "{}",
    error="TypeError: not enough arguments for format string (got 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1156" {
  jinja(
    source="{{ ('<b>%s</b>'|safe) % '<i>' }}",
    "{}",
    output="<b>&lt;i&gt;</b>",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1157" {
  jinja(
    source="{{ 0.1 + 0.2 }}",
    "{}",
    output="0.30000000000000004",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1158" {
  jinja(
    source="{{ 1e16 }}",
    "{}",
    output="1e+16",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1159" {
  jinja(
    source="{{ 1e15 }}",
    "{}",
    output="1000000000000000.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1160" {
  jinja(
    source="{{ 123456789.0 }}",
    "{}",
    output="123456789.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1161" {
  jinja(
    source="{{ 1/3 }}",
    "{}",
    output="0.3333333333333333",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1162" {
  jinja(
    source="{{ 2**0.5 }}",
    "{}",
    output="1.4142135623730951",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1163" {
  jinja(
    source="{{ -0.0 }}",
    "{}",
    output="-0.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1164" {
  jinja(
    source="{{ 1e-5 }}",
    "{}",
    output="1e-05",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1165" {
  jinja(
    source="{{ 0.0001 }}",
    "{}",
    output="0.0001",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1166" {
  jinja(
    source="{{ 10 // 3 }}",
    "{}",
    output="3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1167" {
  jinja(
    source="{{ -7 // 2 }}",
    "{}",
    output="-4",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1168" {
  jinja(
    source="{{ 7 % -3 }}",
    "{}",
    output="-2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1169" {
  jinja(
    source="{{ -7.5 % 2 }}",
    "{}",
    output="0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1170" {
  jinja(
    source="{{ 2 ** -1 }}",
    "{}",
    output="0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1171" {
  jinja(
    source="{{ 2 ** 62 }}",
    "{}",
    output="4611686018427387904",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1172" {
  jinja(
    source="{{ 1e308 * 10 }}",
    "{}",
    output="inf",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1173" {
  jinja(
    source="{{ 5 / 2 }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1174" {
  jinja(
    source="{{ 4 / 2 }}",
    "{}",
    output="2.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1175" {
  jinja(
    source="{{ 3 * 1.0 }}",
    "{}",
    output="3.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1176" {
  jinja(
    source="{{ 17 // 2.5 }}",
    "{}",
    output="6.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1177" {
  jinja(
    source="{{ (1.5).is_integer() }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1178" {
  jinja(
    source="{{ (2.0).is_integer() }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1179" {
  jinja(
    source="{{ 1.5|round }}",
    "{}",
    output="2.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1180" {
  jinja(
    source="{{ 2.5|round }}",
    "{}",
    output="2.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1181" {
  jinja(
    source="{{ 0.125|round(2) }}",
    "{}",
    output="0.12",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1182" {
  jinja(
    source="{{ 0.375|round(2) }}",
    "{}",
    output="0.38",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1183" {
  jinja(
    source="{{ -1.5|round }}",
    "{}",
    output="-2.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1184" {
  jinja(
    source="{{ 2.675|round(2) }}",
    "{}",
    output="2.67",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1185" {
  jinja(
    source="{{ 1234.5678|round(-2) }}",
    "{}",
    output="1200.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1186" {
  jinja(
    source="{{ 1.5|round(0, 'floor') }}",
    "{}",
    output="1.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1187" {
  jinja(
    source="{{ -1.5|round(0, 'ceil') }}",
    "{}",
    output="-1.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1188" {
  jinja(
    source="{{ 42|round(1) }}",
    "{}",
    output="42",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1189" {
  jinja(
    source="{{ 1e300 * 1e300 }}",
    "{}",
    output="inf",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1190" {
  jinja(
    source="{{ (0.1).hex() is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1191" {
  jinja(
    source="{{ [1,2,3,4,5]|batch(2)|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[[1, 2], [3, 4], [5]]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1192" {
  jinja(
    source="{{ [1,2,3,4,5]|batch(2, 'x')|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[[1, 2], [3, 4], [5, &#39;x&#39;]]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1193" {
  jinja(
    source="{{ [1,2,3,4,5,6,7]|slice(3)|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[[1, 2, 3], [4, 5], [6, 7]]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1194" {
  jinja(
    source="{{ [1,2,3,4,5,6,7]|slice(3, 0)|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[[1, 2, 3], [4, 5, 0], [6, 7, 0]]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1195" {
  jinja(
    source="{{ [3,1,2]|sum }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="6",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1196" {
  jinja(
    source="{{ items|sum(attribute='n') }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="6",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1197" {
  jinja(
    source="{{ [1,2]|sum(start=10) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="13",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1198" {
  jinja(
    source="{{ ['b','A','c']|sort }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[&#39;A&#39;, &#39;b&#39;, &#39;c&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1199" {
  jinja(
    source="{{ ['b','A','c']|sort(case_sensitive=true) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[&#39;A&#39;, &#39;b&#39;, &#39;c&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1200" {
  jinja(
    source="{{ ['b','A','c']|sort(reverse=true) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[&#39;c&#39;, &#39;b&#39;, &#39;A&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1201" {
  jinja(
    source="{{ items|sort(attribute='n')|map(attribute='k')|join }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="bca",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1202" {
  jinja(
    source="{{ items|sort(attribute='g,n')|map(attribute='k')|join }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="cab",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1203" {
  jinja(
    source="{{ ['a','A','b']|unique|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[&#39;a&#39;, &#39;b&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1204" {
  jinja(
    source="{{ ['a','A','b']|unique(case_sensitive=true)|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[&#39;a&#39;, &#39;A&#39;, &#39;b&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1205" {
  jinja(
    source="{{ items|unique(attribute='g')|map(attribute='k')|join }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="ab",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1206" {
  jinja(
    source="{{ {'b': 1, 'A': 2, 'c': 0}|dictsort }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[(&#39;A&#39;, 2), (&#39;b&#39;, 1), (&#39;c&#39;, 0)]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1207" {
  jinja(
    source="{{ {'b': 1, 'A': 2, 'c': 0}|dictsort(by='value') }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[(&#39;c&#39;, 0), (&#39;b&#39;, 1), (&#39;A&#39;, 2)]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1208" {
  jinja(
    source="{{ {'b': 1, 'A': 2}|dictsort(true) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[(&#39;A&#39;, 2), (&#39;b&#39;, 1)]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1209" {
  jinja(
    source="{{ {'b': 1, 'A': 2, 'c': 0}|dictsort(reverse=true) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[(&#39;c&#39;, 0), (&#39;b&#39;, 1), (&#39;A&#39;, 2)]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1210" {
  jinja(
    source="{% for g, l in items|groupby('g') %}{{ g }}:{{ l|length }};{% endfor %}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="x:2;y:1;",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1211" {
  jinja(
    source="{% for g in items|groupby('missing', default='none') %}{{ g.grouper }}{% endfor %}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="none",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1212" {
  jinja(
    source="{{ items|map(attribute='k')|join(',') }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="a,b,c",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1213" {
  jinja(
    source="{{ ['a','b']|map('upper')|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[&#39;A&#39;, &#39;B&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1214" {
  jinja(
    source="{{ [1.25, 2.5]|map('round', 1)|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[1.2, 2.5]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1215" {
  jinja(
    source="{{ items|selectattr('n', 'gt', 1)|map(attribute='k')|join }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="ac",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1216" {
  jinja(
    source="{{ items|rejectattr('g', 'equalto', 'x')|map(attribute='k')|join }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="b",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1217" {
  jinja(
    source="{{ [0, 1, '', 'a', none]|select|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[1, &#39;a&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1218" {
  jinja(
    source="{{ [1,2,3]|reject('odd')|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[2]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1219" {
  jinja(
    source="<p{{ {'class': 'a b', 'data-x': '<y>', 'n': none, 'z': false}|xmlattr }}>",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="<p class=\"a b\" data-x=\"&lt;y&gt;\" z=\"False\">",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1220" {
  jinja(
    source="<p{{ {'a': 1}|xmlattr(false) }}>",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="<pa=\"1\">",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1221" {
  jinja(
    source="{{ 'see www.example.org and http://x.y/z?q=1, mail a@b.co.'|urlize }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="see <a href=\"https://www.example.org\" rel=\"noopener\">www.example.org</a> and http://x.y/z?q=1, mail <a href=\"mailto:a@b.co\">a@b.co</a>.",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1222" {
  jinja(
    source="{{ 'http://example.com/very/long/path'|urlize(15) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="<a href=\"http://example.com/very/long/path\" rel=\"noopener\">http://example....</a>",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1223" {
  jinja(
    source="{{ 'http://x.y'|urlize(target='_blank') }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="http://x.y",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1224" {
  jinja(
    source="{{ 'http://x.y'|urlize(rel='me') }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="http://x.y",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1225" {
  jinja(
    source="{{ 'ftp://x.y git://z'|urlize(extra_schemes=['git://']) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="ftp://x.y <a href=\"git://z\" rel=\"noopener\">git://z</a>",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1226" {
  jinja(
    source="{{ '(http://x.y)'|urlize }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="(http://x.y)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1227" {
  jinja(
    source="{{ '<http://x.y>'|urlize }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="&lt;http://x.y&gt;",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1228" {
  jinja(
    source="{{ 'foo bar baz qux quux'|truncate(10) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="foo...",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1229" {
  jinja(
    source="{{ 'foo bar baz qux quux'|truncate(10, true, '>>') }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="foo bar &gt;&gt;",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1230" {
  jinja(
    source="{{ 'foo bar baz qux quux'|truncate(13, leeway=0) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="foo bar...",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1231" {
  jinja(
    source="{{ 'short'|truncate(10) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="short",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1232" {
  jinja(
    source="{{ 'a\nb\n\nc'|indent }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="a\n    b\n\n    c",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1233" {
  jinja(
    source="{{ 'a\nb\n\nc'|indent(2, true) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="  a\n  b\n\n  c",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1234" {
  jinja(
    source="{{ 'a\nb\n\nc'|indent('> ', blank=true) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="a\n&gt; b\n&gt; \n&gt; c",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1235" {
  jinja(
    source="{{ 'a\nb'|indent(first=true) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="    a\n    b",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1236" {
  jinja(
    source="{{ 'hi'|center(1) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="hi",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1237" {
  jinja(
    source="{{ 1023|filesizeformat }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="1.0 kB",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1238" {
  jinja(
    source="{{ 1024|filesizeformat(true) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="1.0 KiB",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1239" {
  jinja(
    source="{{ 1.5e9|filesizeformat }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="1.5 GB",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1240" {
  jinja(
    source="{{ 3e15|filesizeformat(true) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="2.7 PiB",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1241" {
  jinja(
    source="{{ '0x1F'|int(0, 16) }}|{{ '0b11'|int(base=0) }}|{{ '12'|int(base=8) }}|{{ 'zz'|int(-1, 36) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="31|3|10|1295",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1242" {
  jinja(
    source="{{ '1e3'|float }}|{{ 'inf'|float }}|{{ ' 2.5 '|float }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="1000.0|inf|2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1243" {
  jinja(
    source="{{ 'nAN'|float }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="nan",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1244" {
  jinja(
    source="{{ 12|string }}|{{ none|string }}|{{ [1]|string }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="12|None|[1]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1245" {
  jinja(
    source="{{ \"hello o'neil-smith\"|title }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="Hello O&#39;neil-Smith",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1246" {
  jinja(
    source="{{ 'aBC dEF'|capitalize }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="Abc def",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1247" {
  jinja(
    source="{{ '  x  '|trim }}|{{ 'xxaxx'|trim('x') }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="x|a",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1248" {
  jinja(
    source="{{ 'aaa'|replace('a', 'b', 2) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="bba",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1249" {
  jinja(
    source="{{ 'abc'|reverse }}|{{ [1,2]|reverse|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="cba|[2, 1]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1250" {
  jinja(
    source="{{ {'a': 1}|length }}|{{ 'ab'|count }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="1|2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1251" {
  jinja(
    source="{{ ['b','A']|max }}|{{ ['b','A']|max(case_sensitive=true) }}|{{ items|min(attribute='n') }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="b|b|{&#39;k&#39;: &#39;b&#39;, &#39;n&#39;: 1, &#39;g&#39;: &#39;y&#39;}",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1252" {
  jinja(
    source="{{ []|max }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    error="UndefinedError: No aggregated item, sequence was empty.",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1253" {
  jinja(
    source="{{ {'a': 1}|attr('items') is defined }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1254" {
  jinja(
    source="{{ {'a': 1, 'b': [1, 2]}|tojson(2) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="{\n  \"a\": 1,\n  \"b\": [\n    1,\n    2\n  ]\n}",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1255" {
  jinja(
    source="{{ 'a<b>'|striptags }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="a",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1256" {
  jinja(
    source="{{ 'x &amp; y &lt;z&gt; &#39;q&#39; &copy; &euro; &#x41; &unknown;'|striptags }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="x &amp; y &lt;z&gt; &#39;q&#39; © € A &amp;unknown;",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1257" {
  jinja(
    source="{{ '<p>a\n  b</p>  <br/>c'|striptags }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="a b c",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1258" {
  jinja(
    source="{{ 'one two three'|wordcount }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1259" {
  jinja(
    source="{{ 'aaa bbb ccc ddd eee fff'|wordwrap(7) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="aaa bbb\nccc ddd\neee fff",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1260" {
  jinja(
    source="{{ 'aaaaaaaaaaaaaa bb'|wordwrap(5) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="aaaaa\naaaaa\naaaa\nbb",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1261" {
  jinja(
    source="{{ 'aaaaaaaaaaaaaa bb'|wordwrap(5, false) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="aaaaaaaaaaaaaa\nbb",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1262" {
  jinja(
    source="{{ 'a-b-c-d-e-f-g'|wordwrap(4) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="a-b-\nc-d-\ne-\nf-g",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1263" {
  jinja(
    source="{{ 'a-b-c-d-e-f-g'|wordwrap(4, break_on_hyphens=false) }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="a-b-\nc-d-\ne-f-\ng",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1264" {
  jinja(
    source="{{ 'aaa bbb\n\nccc ddd'|wordwrap(5, wrapstring='|') }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="aaa|bbb||ccc|ddd",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1265" {
  jinja(
    source="{{ [1, [2, 'x', {'k': (1, 2)}], none, true, 1.5]|pprint }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[1, [2, &#39;x&#39;, {&#39;k&#39;: (1, 2)}], None, True, 1.5]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1266" {
  jinja(
    source="{{ range(40)|list|pprint }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[0,\n 1,\n 2,\n 3,\n 4,\n 5,\n 6,\n 7,\n 8,\n 9,\n 10,\n 11,\n 12,\n 13,\n 14,\n 15,\n 16,\n 17,\n 18,\n 19,\n 20,\n 21,\n 22,\n 23,\n 24,\n 25,\n 26,\n 27,\n 28,\n 29,\n 30,\n 31,\n 32,\n 33,\n 34,\n 35,\n 36,\n 37,\n 38,\n 39]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1267" {
  jinja(
    source="{{ {'k' ~ i: 'v' * i for i in []}|default('d') }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    error="TemplateSyntaxError: expected token ',', got 'for'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1268" {
  jinja(
    source="{{ ('x' * 100)|pprint }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="&#39;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&#39;",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1269" {
  jinja(
    source="{{ {'long key number one': 'long value number one', 'long key number two': ['long', 'list', 'of', 'values', 'here']}|pprint }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="{&#39;long key number one&#39;: &#39;long value number one&#39;,\n &#39;long key number two&#39;: [&#39;long&#39;, &#39;list&#39;, &#39;of&#39;, &#39;values&#39;, &#39;here&#39;]}",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1270" {
  jinja(
    source="{{ [1, 2]|first }}|{{ []|first is undefined }}|{{ 'abc'|last }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="1|True|c",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1271" {
  jinja(
    source="{{ [1, 2, 3]|random in [1, 2, 3] }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1272" {
  jinja(
    source="{{ 'a b'|urlencode }}|{{ {'a': 'b c', 'd': 1}|urlencode }}|{{ [('x', '/'), ('y', 'é')]|urlencode }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="a%20b|a=b+c&amp;d=1|x=%2F&amp;y=%C3%A9",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1273" {
  jinja(
    source="{{ '<a>'|e }}|{{ '<a>'|safe }}|{{ ('<a>'|safe)|e }}|{{ '<a>'|forceescape }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="&lt;a&gt;|<a>|<a>|&lt;a&gt;",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1274" {
  jinja(
    source="{{ items[0]|items|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[(&#39;k&#39;, &#39;a&#39;), (&#39;n&#39;, 3), (&#39;g&#39;, &#39;x&#39;)]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1275" {
  jinja(
    source="{{ none|default('d') }}|{{ ''|default('d', true) }}|{{ missing|d('m') }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="None|d|m",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1276" {
  jinja(
    source="{{ 'abc'|list }}|{{ {'a': 1}|list }}",
    "{\"items\": [{\"k\": \"a\", \"n\": 3, \"g\": \"x\"}, {\"k\": \"b\", \"n\": 1, \"g\": \"y\"}, {\"k\": \"c\", \"n\": 2, \"g\": \"x\"}]}",
    output="[&#39;a&#39;, &#39;b&#39;, &#39;c&#39;]|[&#39;a&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1277" {
  jinja(
    source="{{ none is boolean }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1278" {
  jinja(
    source="{{ true is boolean }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1279" {
  jinja(
    source="{{ 0 is boolean }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1280" {
  jinja(
    source="{{ 1.5 is boolean }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1281" {
  jinja(
    source="{{ 'Ab' is boolean }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1282" {
  jinja(
    source="{{ 'ab' is boolean }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1283" {
  jinja(
    source="{{ 'AB' is boolean }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1284" {
  jinja(
    source="{{ [1] is boolean }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1285" {
  jinja(
    source="{{ {'a': 1} is boolean }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1286" {
  jinja(
    source="{{ range(2) is boolean }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1287" {
  jinja(
    source="{{ 'x'|safe is boolean }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1288" {
  jinja(
    source="{{ 3 is boolean }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1289" {
  jinja(
    source="{{ missing is boolean }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1290" {
  jinja(
    source="{{ none is callable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1291" {
  jinja(
    source="{{ true is callable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1292" {
  jinja(
    source="{{ 0 is callable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1293" {
  jinja(
    source="{{ 1.5 is callable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1294" {
  jinja(
    source="{{ 'Ab' is callable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1295" {
  jinja(
    source="{{ 'ab' is callable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1296" {
  jinja(
    source="{{ 'AB' is callable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1297" {
  jinja(
    source="{{ [1] is callable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1298" {
  jinja(
    source="{{ {'a': 1} is callable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1299" {
  jinja(
    source="{{ range(2) is callable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1300" {
  jinja(
    source="{{ 'x'|safe is callable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1301" {
  jinja(
    source="{{ 3 is callable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1302" {
  jinja(
    source="{{ none is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1303" {
  jinja(
    source="{{ true is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1304" {
  jinja(
    source="{{ 0 is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1305" {
  jinja(
    source="{{ 1.5 is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1306" {
  jinja(
    source="{{ 'Ab' is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1307" {
  jinja(
    source="{{ 'ab' is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1308" {
  jinja(
    source="{{ 'AB' is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1309" {
  jinja(
    source="{{ [1] is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1310" {
  jinja(
    source="{{ {'a': 1} is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1311" {
  jinja(
    source="{{ range(2) is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1312" {
  jinja(
    source="{{ 'x'|safe is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1313" {
  jinja(
    source="{{ 3 is defined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1314" {
  jinja(
    source="{{ missing is defined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1315" {
  jinja(
    source="{{ none is undefined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1316" {
  jinja(
    source="{{ true is undefined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1317" {
  jinja(
    source="{{ 0 is undefined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1318" {
  jinja(
    source="{{ 1.5 is undefined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1319" {
  jinja(
    source="{{ 'Ab' is undefined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1320" {
  jinja(
    source="{{ 'ab' is undefined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1321" {
  jinja(
    source="{{ 'AB' is undefined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1322" {
  jinja(
    source="{{ [1] is undefined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1323" {
  jinja(
    source="{{ {'a': 1} is undefined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1324" {
  jinja(
    source="{{ range(2) is undefined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1325" {
  jinja(
    source="{{ 'x'|safe is undefined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1326" {
  jinja(
    source="{{ 3 is undefined }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1327" {
  jinja(
    source="{{ missing is undefined }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1328" {
  jinja(
    source="{{ none is none }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1329" {
  jinja(
    source="{{ true is none }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1330" {
  jinja(
    source="{{ 0 is none }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1331" {
  jinja(
    source="{{ 1.5 is none }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1332" {
  jinja(
    source="{{ 'Ab' is none }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1333" {
  jinja(
    source="{{ 'ab' is none }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1334" {
  jinja(
    source="{{ 'AB' is none }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1335" {
  jinja(
    source="{{ [1] is none }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1336" {
  jinja(
    source="{{ {'a': 1} is none }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1337" {
  jinja(
    source="{{ range(2) is none }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1338" {
  jinja(
    source="{{ 'x'|safe is none }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1339" {
  jinja(
    source="{{ 3 is none }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1340" {
  jinja(
    source="{{ missing is none }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1341" {
  jinja(
    source="{{ none is number }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1342" {
  jinja(
    source="{{ true is number }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1343" {
  jinja(
    source="{{ 0 is number }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1344" {
  jinja(
    source="{{ 1.5 is number }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1345" {
  jinja(
    source="{{ 'Ab' is number }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1346" {
  jinja(
    source="{{ 'ab' is number }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1347" {
  jinja(
    source="{{ 'AB' is number }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1348" {
  jinja(
    source="{{ [1] is number }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1349" {
  jinja(
    source="{{ {'a': 1} is number }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1350" {
  jinja(
    source="{{ range(2) is number }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1351" {
  jinja(
    source="{{ 'x'|safe is number }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1352" {
  jinja(
    source="{{ 3 is number }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1353" {
  jinja(
    source="{{ missing is number }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1354" {
  jinja(
    source="{{ none is integer }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1355" {
  jinja(
    source="{{ true is integer }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1356" {
  jinja(
    source="{{ 0 is integer }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1357" {
  jinja(
    source="{{ 1.5 is integer }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1358" {
  jinja(
    source="{{ 'Ab' is integer }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1359" {
  jinja(
    source="{{ 'ab' is integer }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1360" {
  jinja(
    source="{{ 'AB' is integer }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1361" {
  jinja(
    source="{{ [1] is integer }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1362" {
  jinja(
    source="{{ {'a': 1} is integer }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1363" {
  jinja(
    source="{{ range(2) is integer }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1364" {
  jinja(
    source="{{ 'x'|safe is integer }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1365" {
  jinja(
    source="{{ 3 is integer }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1366" {
  jinja(
    source="{{ missing is integer }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1367" {
  jinja(
    source="{{ none is float }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1368" {
  jinja(
    source="{{ true is float }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1369" {
  jinja(
    source="{{ 0 is float }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1370" {
  jinja(
    source="{{ 1.5 is float }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1371" {
  jinja(
    source="{{ 'Ab' is float }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1372" {
  jinja(
    source="{{ 'ab' is float }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1373" {
  jinja(
    source="{{ 'AB' is float }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1374" {
  jinja(
    source="{{ [1] is float }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1375" {
  jinja(
    source="{{ {'a': 1} is float }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1376" {
  jinja(
    source="{{ range(2) is float }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1377" {
  jinja(
    source="{{ 'x'|safe is float }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1378" {
  jinja(
    source="{{ 3 is float }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1379" {
  jinja(
    source="{{ missing is float }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1380" {
  jinja(
    source="{{ none is string }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1381" {
  jinja(
    source="{{ true is string }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1382" {
  jinja(
    source="{{ 0 is string }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1383" {
  jinja(
    source="{{ 1.5 is string }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1384" {
  jinja(
    source="{{ 'Ab' is string }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1385" {
  jinja(
    source="{{ 'ab' is string }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1386" {
  jinja(
    source="{{ 'AB' is string }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1387" {
  jinja(
    source="{{ [1] is string }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1388" {
  jinja(
    source="{{ {'a': 1} is string }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1389" {
  jinja(
    source="{{ range(2) is string }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1390" {
  jinja(
    source="{{ 'x'|safe is string }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1391" {
  jinja(
    source="{{ 3 is string }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1392" {
  jinja(
    source="{{ missing is string }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1393" {
  jinja(
    source="{{ none is mapping }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1394" {
  jinja(
    source="{{ true is mapping }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1395" {
  jinja(
    source="{{ 0 is mapping }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1396" {
  jinja(
    source="{{ 1.5 is mapping }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1397" {
  jinja(
    source="{{ 'Ab' is mapping }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1398" {
  jinja(
    source="{{ 'ab' is mapping }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1399" {
  jinja(
    source="{{ 'AB' is mapping }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1400" {
  jinja(
    source="{{ [1] is mapping }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1401" {
  jinja(
    source="{{ {'a': 1} is mapping }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1402" {
  jinja(
    source="{{ range(2) is mapping }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1403" {
  jinja(
    source="{{ 'x'|safe is mapping }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1404" {
  jinja(
    source="{{ 3 is mapping }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1405" {
  jinja(
    source="{{ missing is mapping }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1406" {
  jinja(
    source="{{ none is sequence }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1407" {
  jinja(
    source="{{ true is sequence }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1408" {
  jinja(
    source="{{ 0 is sequence }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1409" {
  jinja(
    source="{{ 1.5 is sequence }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1410" {
  jinja(
    source="{{ 'Ab' is sequence }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1411" {
  jinja(
    source="{{ 'ab' is sequence }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1412" {
  jinja(
    source="{{ 'AB' is sequence }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1413" {
  jinja(
    source="{{ [1] is sequence }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1414" {
  jinja(
    source="{{ {'a': 1} is sequence }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1415" {
  jinja(
    source="{{ range(2) is sequence }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1416" {
  jinja(
    source="{{ 'x'|safe is sequence }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1417" {
  jinja(
    source="{{ 3 is sequence }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1418" {
  jinja(
    source="{{ missing is sequence }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1419" {
  jinja(
    source="{{ none is iterable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1420" {
  jinja(
    source="{{ true is iterable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1421" {
  jinja(
    source="{{ 0 is iterable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1422" {
  jinja(
    source="{{ 1.5 is iterable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1423" {
  jinja(
    source="{{ 'Ab' is iterable }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1424" {
  jinja(
    source="{{ 'ab' is iterable }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1425" {
  jinja(
    source="{{ 'AB' is iterable }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1426" {
  jinja(
    source="{{ [1] is iterable }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1427" {
  jinja(
    source="{{ {'a': 1} is iterable }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1428" {
  jinja(
    source="{{ range(2) is iterable }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1429" {
  jinja(
    source="{{ 'x'|safe is iterable }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1430" {
  jinja(
    source="{{ 3 is iterable }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1431" {
  jinja(
    source="{{ missing is iterable }}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1432" {
  jinja(
    source="{{ none is lower }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1433" {
  jinja(
    source="{{ true is lower }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1434" {
  jinja(
    source="{{ 0 is lower }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1435" {
  jinja(
    source="{{ 1.5 is lower }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1436" {
  jinja(
    source="{{ 'Ab' is lower }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1437" {
  jinja(
    source="{{ 'ab' is lower }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1438" {
  jinja(
    source="{{ 'AB' is lower }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1439" {
  jinja(
    source="{{ [1] is lower }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1440" {
  jinja(
    source="{{ {'a': 1} is lower }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1441" {
  jinja(
    source="{{ 'x'|safe is lower }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1442" {
  jinja(
    source="{{ 3 is lower }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1443" {
  jinja(
    source="{{ missing is lower }}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1444" {
  jinja(
    source="{{ none is upper }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1445" {
  jinja(
    source="{{ true is upper }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1446" {
  jinja(
    source="{{ 0 is upper }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1447" {
  jinja(
    source="{{ 1.5 is upper }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1448" {
  jinja(
    source="{{ 'Ab' is upper }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1449" {
  jinja(
    source="{{ 'ab' is upper }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1450" {
  jinja(
    source="{{ 'AB' is upper }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1451" {
  jinja(
    source="{{ [1] is upper }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1452" {
  jinja(
    source="{{ {'a': 1} is upper }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1453" {
  jinja(
    source="{{ 'x'|safe is upper }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1454" {
  jinja(
    source="{{ 3 is upper }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1455" {
  jinja(
    source="{{ missing is upper }}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1456" {
  jinja(
    source="{{ none is odd }}",
    "{}",
    error="TypeError: unsupported operand type(s) for %: 'NoneType' and 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1457" {
  jinja(
    source="{{ true is odd }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1458" {
  jinja(
    source="{{ 0 is odd }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1459" {
  jinja(
    source="{{ 1.5 is odd }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1460" {
  jinja(
    source="{{ 'Ab' is odd }}",
    "{}",
    error="TypeError: not all arguments converted during string formatting (required 0, got 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1461" {
  jinja(
    source="{{ 'ab' is odd }}",
    "{}",
    error="TypeError: not all arguments converted during string formatting (required 0, got 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1462" {
  jinja(
    source="{{ 'AB' is odd }}",
    "{}",
    error="TypeError: not all arguments converted during string formatting (required 0, got 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1463" {
  jinja(
    source="{{ [1] is odd }}",
    "{}",
    error="TypeError: unsupported operand type(s) for %: 'list' and 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1464" {
  jinja(
    source="{{ {'a': 1} is odd }}",
    "{}",
    error="TypeError: unsupported operand type(s) for %: 'dict' and 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1465" {
  jinja(
    source="{{ range(2) is odd }}",
    "{}",
    error="TypeError: unsupported operand type(s) for %: 'range' and 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1466" {
  jinja(
    source="{{ 'x'|safe is odd }}",
    "{}",
    error="TypeError: not all arguments converted during string formatting (required 0, got 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1467" {
  jinja(
    source="{{ 3 is odd }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1468" {
  jinja(
    source="{{ missing is odd }}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1469" {
  jinja(
    source="{{ none is even }}",
    "{}",
    error="TypeError: unsupported operand type(s) for %: 'NoneType' and 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1470" {
  jinja(
    source="{{ true is even }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1471" {
  jinja(
    source="{{ 0 is even }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1472" {
  jinja(
    source="{{ 1.5 is even }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1473" {
  jinja(
    source="{{ 'Ab' is even }}",
    "{}",
    error="TypeError: not all arguments converted during string formatting (required 0, got 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1474" {
  jinja(
    source="{{ 'ab' is even }}",
    "{}",
    error="TypeError: not all arguments converted during string formatting (required 0, got 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1475" {
  jinja(
    source="{{ 'AB' is even }}",
    "{}",
    error="TypeError: not all arguments converted during string formatting (required 0, got 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1476" {
  jinja(
    source="{{ [1] is even }}",
    "{}",
    error="TypeError: unsupported operand type(s) for %: 'list' and 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1477" {
  jinja(
    source="{{ {'a': 1} is even }}",
    "{}",
    error="TypeError: unsupported operand type(s) for %: 'dict' and 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1478" {
  jinja(
    source="{{ range(2) is even }}",
    "{}",
    error="TypeError: unsupported operand type(s) for %: 'range' and 'int'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1479" {
  jinja(
    source="{{ 'x'|safe is even }}",
    "{}",
    error="TypeError: not all arguments converted during string formatting (required 0, got 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1480" {
  jinja(
    source="{{ 3 is even }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1481" {
  jinja(
    source="{{ missing is even }}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1482" {
  jinja(
    source="{{ none is escaped }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1483" {
  jinja(
    source="{{ true is escaped }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1484" {
  jinja(
    source="{{ 0 is escaped }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1485" {
  jinja(
    source="{{ 1.5 is escaped }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1486" {
  jinja(
    source="{{ 'Ab' is escaped }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1487" {
  jinja(
    source="{{ 'ab' is escaped }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1488" {
  jinja(
    source="{{ 'AB' is escaped }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1489" {
  jinja(
    source="{{ [1] is escaped }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1490" {
  jinja(
    source="{{ {'a': 1} is escaped }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1491" {
  jinja(
    source="{{ range(2) is escaped }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1492" {
  jinja(
    source="{{ 'x'|safe is escaped }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1493" {
  jinja(
    source="{{ 3 is escaped }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1494" {
  jinja(
    source="{{ missing is escaped }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1495" {
  jinja(
    source="{{ none is true }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1496" {
  jinja(
    source="{{ true is true }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1497" {
  jinja(
    source="{{ 0 is true }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1498" {
  jinja(
    source="{{ 1.5 is true }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1499" {
  jinja(
    source="{{ 'Ab' is true }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1500" {
  jinja(
    source="{{ 'ab' is true }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1501" {
  jinja(
    source="{{ 'AB' is true }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1502" {
  jinja(
    source="{{ [1] is true }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1503" {
  jinja(
    source="{{ {'a': 1} is true }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1504" {
  jinja(
    source="{{ range(2) is true }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1505" {
  jinja(
    source="{{ 'x'|safe is true }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1506" {
  jinja(
    source="{{ 3 is true }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1507" {
  jinja(
    source="{{ missing is true }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1508" {
  jinja(
    source="{{ none is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1509" {
  jinja(
    source="{{ true is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1510" {
  jinja(
    source="{{ 0 is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1511" {
  jinja(
    source="{{ 1.5 is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1512" {
  jinja(
    source="{{ 'Ab' is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1513" {
  jinja(
    source="{{ 'ab' is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1514" {
  jinja(
    source="{{ 'AB' is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1515" {
  jinja(
    source="{{ [1] is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1516" {
  jinja(
    source="{{ {'a': 1} is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1517" {
  jinja(
    source="{{ range(2) is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1518" {
  jinja(
    source="{{ 'x'|safe is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1519" {
  jinja(
    source="{{ 3 is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1520" {
  jinja(
    source="{{ missing is false }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1521" {
  jinja(
    source="{{ 3 is divisibleby(3) }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1522" {
  jinja(
    source="{{ 3 is eq(3) }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1523" {
  jinja(
    source="{{ 3 is ne(3) }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1524" {
  jinja(
    source="{{ 3 is lt(3) }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1525" {
  jinja(
    source="{{ 3 is le(3) }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1526" {
  jinja(
    source="{{ 3 is gt(3) }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1527" {
  jinja(
    source="{{ 3 is ge(3) }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1528" {
  jinja(
    source="{{ 3 is in([1, 3]) }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1529" {
  jinja(
    source="{{ 3 is sameas(3) }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1530" {
  jinja(
    source="{{ 3 is equalto 3 }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1531" {
  jinja(
    source="{{ 3 is greaterthan 2 }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1532" {
  jinja(
    source="{{ 3 is lessthan 2 }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1533" {
  jinja(
    source="{{ 3 is ==(3) }}",
    "{}",
    error="TemplateSyntaxError: expected token 'name', got '=='",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1534" {
  jinja(
    source="{{ 3 is !=(3) }}",
    "{}",
    error="TemplateSyntaxError: expected token 'name', got '!='",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1535" {
  jinja(
    source="{{ 3 is <(4) }}",
    "{}",
    error="TemplateSyntaxError: expected token 'name', got '<'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1536" {
  jinja(
    source="{{ 3 is >(4) }}",
    "{}",
    error="TemplateSyntaxError: expected token 'name', got '>'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1537" {
  jinja(
    source="{{ 3 is <=(3) }}",
    "{}",
    error="TemplateSyntaxError: expected token 'name', got '<='",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1538" {
  jinja(
    source="{{ 3 is >=(3) }}",
    "{}",
    error="TemplateSyntaxError: expected token 'name', got '>='",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1539" {
  jinja(
    source="{{ 3 is filter }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1540" {
  jinja(
    source="{{ 3 is test }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1541" {
  jinja(
    source="{{ 'upper' is filter }}|{{ 'nope' is filter }}|{{ 'odd' is test }}|{{ 'nope' is test }}",
    "{}",
    output="True|False|True|False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1542" {
  jinja(
    source="{{ none is sameas none }}|{{ [] is sameas [] }}",
    "{}",
    output="True|False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1543" {
  jinja(
    source="{{ range(5)|list }}",
    "{}",
    output="[0, 1, 2, 3, 4]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1544" {
  jinja(
    source="{{ range(2, 10, 3)|list }}",
    "{}",
    output="[2, 5, 8]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1545" {
  jinja(
    source="{{ range(10, 0, -3)|list }}",
    "{}",
    output="[10, 7, 4, 1]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1546" {
  jinja(
    source="{{ range(0)|list }}",
    "{}",
    output="[]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1547" {
  jinja(
    source="{{ range(3, 1)|list }}",
    "{}",
    output="[]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1548" {
  jinja(
    source="{{ range(1, 2, 0)|list }}",
    "{}",
    error="ValueError: range() arg 3 must not be zero",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1549" {
  jinja(
    source="{{ dict(a=1, b=2) }}",
    "{}",
    output="{&#39;a&#39;: 1, &#39;b&#39;: 2}",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1550" {
  jinja(
    source="{{ dict() }}",
    "{}",
    output="{}",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1551" {
  jinja(
    source="{% set c = cycler('a', 'b') %}{{ c.next() }}{{ c.next() }}{{ c.current }}{{ c.next() }}{% do c.reset() %}{{ c.next() }}",
    "{}",
    output="abaaa",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1552" {
  jinja(
    source="{% set j = joiner('|') %}{% for i in range(3) %}{{ j() }}{{ i }}{% endfor %}",
    "{}",
    output="0|1|2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1553" {
  jinja(
    source="{% set j = joiner() %}{{ j() }}{{ j() }}",
    "{}",
    output=", ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1554" {
  jinja(
    source="{% set ns = namespace(a=1, b='x') %}{% set ns.a = ns.a + 1 %}{{ ns.a }}{{ ns.b }}",
    "{}",
    output="2x",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1555" {
  jinja(
    source="{% set ns = namespace({'a': 1}, b=2) %}{{ ns.a }}{{ ns.b }}",
    "{}",
    output="12",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1556" {
  jinja(
    source="{{ cycler() is defined }}",
    "{}",
    error="RuntimeError: at least one item has to be provided",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1557" {
  jinja(
    source="{% set l = [3, 1, 2] %}{% do l.append(4) %}{% do l.extend([5]) %}{% do l.insert(0, 9) %}{{ l }}|{{ l.pop() }}|{{ l.pop(0) }}|{{ l }}",
    "{}",
    output="[9, 3, 1, 2, 4, 5]|5|9|[3, 1, 2, 4]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1558" {
  jinja(
    source="{% set l = [3, 1, 2] %}{% do l.sort() %}{{ l }}{% do l.reverse() %}{{ l }}{% do l.remove(1) %}{{ l }}|{{ l.index(3) }}|{{ l.count(2) }}",
    "{}",
    output="[1, 2, 3][3, 2, 1][3, 2]|0|1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1559" {
  jinja(
    source="{% set l = [1] %}{{ l.copy() }}{% do l.clear() %}{{ l }}",
    "{}",
    output="[1][]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1560" {
  jinja(
    source="{{ [1, 2, 3][1:] }}|{{ [1, 2, 3][::-1] }}|{{ 'abcdef'[1:5:2] }}|{{ [1, 2, 3][-1] }}",
    "{}",
    output="[2, 3]|[3, 2, 1]|bd|3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1561" {
  jinja(
    source="{% set d = {'a': 1} %}{{ d.get('a') }}{{ d.get('z') }}{{ d.get('z', 0) }}|{{ d.keys()|list }}|{{ d.values()|list }}|{{ d.items()|list }}",
    "{}",
    output="1None0|[&#39;a&#39;]|[1]|[(&#39;a&#39;, 1)]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1562" {
  jinja(
    source="{% set d = {'a': 1} %}{% do d.update(b=2) %}{% do d.update({'c': 3}) %}{{ d }}|{{ d.pop('a') }}|{{ d.setdefault('e', 5) }}|{{ d }}",
    "{}",
    output="{&#39;a&#39;: 1, &#39;b&#39;: 2, &#39;c&#39;: 3}|1|5|{&#39;b&#39;: 2, &#39;c&#39;: 3, &#39;e&#39;: 5}",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1563" {
  jinja(
    source="{% set d = {'a': 1} %}{{ d.copy() }}{% do d.clear() %}{{ d }}",
    "{}",
    output="{&#39;a&#39;: 1}{}",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1564" {
  jinja(
    source="{{ (1, 2) + (3,) }}|{{ [1] * 3 }}|{{ 'ab' * 2 }}|{{ 2 * 'c' }}",
    "{}",
    output="(1, 2, 3)|[1, 1, 1]|abab|cc",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1565" {
  jinja(
    source="{{ 1 in [1, 2] }}|{{ 'a' in 'cat' }}|{{ 'k' in {'k': 1} }}|{{ 3 not in (1, 2) }}",
    "{}",
    output="True|True|True|True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1566" {
  jinja(
    source="{{ [1, 2] == [1, 2] }}|{{ (1, 2) == [1, 2] }}|{{ 1 == 1.0 }}|{{ 'a' < 'b' }}",
    "{}",
    output="True|False|True|True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1567" {
  jinja(
    source="{{ [1, 2] < [1, 3] }}|{{ (1, 'a') < (1, 'b') }}",
    "{}",
    output="True|True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1568" {
  jinja(
    source="{{ {'a': 1} == {'a': 1} }}|{{ none == none }}|{{ true == 1 }}",
    "{}",
    output="True|True|True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1569" {
  jinja(
    source="{{ (3).is_integer() }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1570" {
  jinja(
    source="{{ (3).conjugate() }}",
    "{}",
    output="3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1571" {
  jinja(
    source="{{ (3).bit_length() }}",
    "{}",
    output="2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1572" {
  jinja(
    source="{{ (3).as_integer_ratio() }}",
    "{}",
    output="(3, 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1573" {
  jinja(
    source="{{ (3).hex() }}",
    "{}",
    error="UndefinedError: 'int object' has no attribute 'hex'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1574" {
  jinja(
    source="{{ (3).real }}",
    "{}",
    output="3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1575" {
  jinja(
    source="{{ (3).imag }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1576" {
  jinja(
    source="{{ (3).numerator }}",
    "{}",
    output="3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1577" {
  jinja(
    source="{{ (3).denominator }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1578" {
  jinja(
    source="{{ (-3).is_integer() }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1579" {
  jinja(
    source="{{ (-3).conjugate() }}",
    "{}",
    output="-3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1580" {
  jinja(
    source="{{ (-3).bit_length() }}",
    "{}",
    output="2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1581" {
  jinja(
    source="{{ (-3).as_integer_ratio() }}",
    "{}",
    output="(-3, 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1582" {
  jinja(
    source="{{ (-3).hex() }}",
    "{}",
    error="UndefinedError: 'int object' has no attribute 'hex'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1583" {
  jinja(
    source="{{ (-3).real }}",
    "{}",
    output="-3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1584" {
  jinja(
    source="{{ (-3).imag }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1585" {
  jinja(
    source="{{ (-3).numerator }}",
    "{}",
    output="-3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1586" {
  jinja(
    source="{{ (-3).denominator }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1587" {
  jinja(
    source="{{ (True).is_integer() }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1588" {
  jinja(
    source="{{ (True).conjugate() }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1589" {
  jinja(
    source="{{ (True).bit_length() }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1590" {
  jinja(
    source="{{ (True).as_integer_ratio() }}",
    "{}",
    output="(1, 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1591" {
  jinja(
    source="{{ (True).hex() }}",
    "{}",
    error="UndefinedError: 'bool object' has no attribute 'hex'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1592" {
  jinja(
    source="{{ (True).real }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1593" {
  jinja(
    source="{{ (True).imag }}",
    "{}",
    output="0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1594" {
  jinja(
    source="{{ (True).numerator }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1595" {
  jinja(
    source="{{ (True).denominator }}",
    "{}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1596" {
  jinja(
    source="{{ (2.5).is_integer() }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1597" {
  jinja(
    source="{{ (2.5).conjugate() }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1598" {
  jinja(
    source="{{ (2.5).bit_length() }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'bit_length'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1599" {
  jinja(
    source="{{ (2.5).as_integer_ratio() }}",
    "{}",
    output="(5, 2)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1600" {
  jinja(
    source="{{ (2.5).hex() }}",
    "{}",
    output="0x1.4000000000000p+1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1601" {
  jinja(
    source="{{ (2.5).real }}",
    "{}",
    output="2.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1602" {
  jinja(
    source="{{ (2.5).imag }}",
    "{}",
    output="0.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1603" {
  jinja(
    source="{{ (2.5).numerator }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'numerator'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1604" {
  jinja(
    source="{{ (2.5).denominator }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'denominator'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1605" {
  jinja(
    source="{{ (-0.75).is_integer() }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1606" {
  jinja(
    source="{{ (-0.75).conjugate() }}",
    "{}",
    output="-0.75",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1607" {
  jinja(
    source="{{ (-0.75).bit_length() }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'bit_length'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1608" {
  jinja(
    source="{{ (-0.75).as_integer_ratio() }}",
    "{}",
    output="(-3, 4)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1609" {
  jinja(
    source="{{ (-0.75).hex() }}",
    "{}",
    output="-0x1.8000000000000p-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1610" {
  jinja(
    source="{{ (-0.75).real }}",
    "{}",
    output="-0.75",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1611" {
  jinja(
    source="{{ (-0.75).imag }}",
    "{}",
    output="0.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1612" {
  jinja(
    source="{{ (-0.75).numerator }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'numerator'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1613" {
  jinja(
    source="{{ (-0.75).denominator }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'denominator'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1614" {
  jinja(
    source="{{ (1e300).is_integer() }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1615" {
  jinja(
    source="{{ (1e300).conjugate() }}",
    "{}",
    output="1e+300",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1616" {
  jinja(
    source="{{ (1e300).bit_length() }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'bit_length'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1617" {
  jinja(
    source="{{ (1e300).hex() }}",
    "{}",
    output="0x1.7e43c8800759cp+996",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1618" {
  jinja(
    source="{{ (1e300).real }}",
    "{}",
    output="1e+300",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1619" {
  jinja(
    source="{{ (1e300).imag }}",
    "{}",
    output="0.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1620" {
  jinja(
    source="{{ (1e300).numerator }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'numerator'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1621" {
  jinja(
    source="{{ (1e300).denominator }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'denominator'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1622" {
  jinja(
    source="{{ (0.0).is_integer() }}",
    "{}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1623" {
  jinja(
    source="{{ (0.0).conjugate() }}",
    "{}",
    output="0.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1624" {
  jinja(
    source="{{ (0.0).bit_length() }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'bit_length'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1625" {
  jinja(
    source="{{ (0.0).as_integer_ratio() }}",
    "{}",
    output="(0, 1)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1626" {
  jinja(
    source="{{ (0.0).hex() }}",
    "{}",
    output="0x0.0p+0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1627" {
  jinja(
    source="{{ (0.0).real }}",
    "{}",
    output="0.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1628" {
  jinja(
    source="{{ (0.0).imag }}",
    "{}",
    output="0.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1629" {
  jinja(
    source="{{ (0.0).numerator }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'numerator'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1630" {
  jinja(
    source="{{ (0.0).denominator }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'denominator'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1631" {
  jinja(
    source="{{ (1e-310).is_integer() }}",
    "{}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1632" {
  jinja(
    source="{{ (1e-310).conjugate() }}",
    "{}",
    output="1e-310",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1633" {
  jinja(
    source="{{ (1e-310).bit_length() }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'bit_length'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1634" {
  jinja(
    source="{{ (1e-310).hex() }}",
    "{}",
    output="0x0.012688b70e62bp-1022",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1635" {
  jinja(
    source="{{ (1e-310).real }}",
    "{}",
    output="1e-310",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1636" {
  jinja(
    source="{{ (1e-310).imag }}",
    "{}",
    output="0.0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1637" {
  jinja(
    source="{{ (1e-310).numerator }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'numerator'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1638" {
  jinja(
    source="{{ (1e-310).denominator }}",
    "{}",
    error="UndefinedError: 'float object' has no attribute 'denominator'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1639" {
  jinja(
    source="{{ (float('nan')).is_integer() }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1640" {
  jinja(
    source="{{ (float('nan')).conjugate() }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1641" {
  jinja(
    source="{{ (float('nan')).bit_length() }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1642" {
  jinja(
    source="{{ (float('nan')).as_integer_ratio() }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1643" {
  jinja(
    source="{{ (float('nan')).hex() }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1644" {
  jinja(
    source="{{ (float('nan')).real }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1645" {
  jinja(
    source="{{ (float('nan')).imag }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1646" {
  jinja(
    source="{{ (float('nan')).numerator }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1647" {
  jinja(
    source="{{ (float('nan')).denominator }}",
    "{}",
    error="UndefinedError: 'float' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1648" {
  jinja(
    source="{{ 'abcabc'.startswith('bc', 1) }}|{{ 'abcabc'.startswith('bc', 1, 2) }}|{{ 'abc'.endswith('b', -3, -1) }}|{{ 'abc'.startswith(('x', 'a')) }}",
    "{}",
    output="True|False|True|True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1649" {
  jinja(
    source="{{ 'abc'.startswith(1) }}",
    "{}",
    error="TypeError: startswith first arg must be str or a tuple of str, not int",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1650" {
  jinja(
    source="{{ 'abc'.startswith() }}",
    "{}",
    error="TypeError: startswith expected at least 1 argument, got 0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1651" {
  jinja(
    source="{{ 'abc'.find('c', 1, 5) }}|{{ 'abc'.find('a', -2) }}|{{ 'abcab'.rfind('ab', 0, 4) }}",
    "{}",
    output="2|-1|0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1652" {
  jinja(
    source="{{ 'a b  c'.rsplit(none, 1) }}|{{ '  a b  '.rsplit() }}|{{ 'a,b,c'.rsplit(',', 1) }}|{{ 'a,b,c'.split(',', 1) }}|{{ 'a,b'.split(',', 0) }}",
    "{}",
    output="[&#39;a b&#39;, &#39;c&#39;]|[&#39;a&#39;, &#39;b&#39;]|[&#39;a,b&#39;, &#39;c&#39;]|[&#39;a&#39;, &#39;b,c&#39;]|[&#39;a,b&#39;]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1653" {
  jinja(
    source="{{ 'a'.split('') }}",
    "{}",
    error="ValueError: empty separator",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1654" {
  jinja(
    source="{{ ','.join([1, 2]) }}",
    "{}",
    error="TypeError: sequence item 0: expected str instance, int found",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1655" {
  jinja(
    source="{{ 'ab'.center(5, 'xy') }}",
    "{}",
    error="TypeError: The fill character must be exactly one character long",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1656" {
  jinja(
    source="{{ 'ab'.center('x') }}",
    "{}",
    error="TypeError: 'str' object cannot be interpreted as an integer",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1657" {
  jinja(
    source="{{ 'ab'.zfill('x') }}",
    "{}",
    error="TypeError: 'str' object cannot be interpreted as an integer",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1658" {
  jinja(
    source="{{ '-42'.zfill(6) }}|{{ '+7'.zfill(4) }}|{{ 'ab'.zfill(1) }}",
    "{}",
    output="-00042|+007|ab",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1659" {
  jinja(
    source="{{ 'abc'.count('') }}|{{ 'aaa'.count('a', 1) }}",
    "{}",
    output="4|2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1660" {
  jinja(
    source="{{ 'abc'.index('z') }}",
    "{}",
    error="ValueError: substring not found",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1661" {
  jinja(
    source="{{ [1, 2].index(3) }}",
    "{}",
    error="ValueError: list.index(x): x not in list",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1662" {
  jinja(
    source="{{ (1, 2).index(2) }}|{{ (1, 1).count(1) }}",
    "{}",
    output="1|2",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1663" {
  jinja(
    source="{{ 'a'.upper(1) }}",
    "{}",
    error="TypeError: str.upper() takes no arguments (1 given)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1664" {
  jinja(
    source="{{ [].pop() }}",
    "{}",
    error="IndexError: pop from empty list",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1665" {
  jinja(
    source="{{ {}.pop('x') }}",
    "{}",
    error="KeyError: 'x'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1666" {
  jinja(
    source="{{ {}.pop('x', 'd') }}",
    "{}",
    output="d",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1667" {
  jinja(
    source="{% set l = [1] %}{% do l.remove(5) %}",
    "{}",
    error="ValueError: list.remove(x): x not in list",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1668" {
  jinja(
    source="{% set l = [3, 1] %}{% do l.sort(reverse=true) %}{{ l }}",
    "{}",
    output="[3, 1]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1669" {
  jinja(
    source="{{ 'x'.removeprefix('') }}|{{ 'abc'.partition('z') }}|{{ 'abc'.rpartition('z') }}",
    "{}",
    output="x|(&#39;abc&#39;, &#39;&#39;, &#39;&#39;)|(&#39;&#39;, &#39;&#39;, &#39;abc&#39;)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1670" {
  jinja(
    source="{{ s.splitlines(true) }}",
    "{}",
    error="UndefinedError: 's' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1671" {
  jinja(
    source="{{ 'Hello'.swapcase() }}|{{ 'ǆ'.swapcase() }}",
    "{}",
    output="hELLO|Ǆ",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1672" {
  jinja(
    source="{{ 'ab'.ljust(5, 'xy') }}",
    "{}",
    error="TypeError: The fill character must be exactly one character long",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1673" {
  jinja(
    source="{{ 'é'.isascii() }}|{{ '_x1'.isidentifier() }}|{{ '1x'.isidentifier() }}",
    "{}",
    output="False|True|False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1674" {
  jinja(
    source="{{ {'a': 1}.update(1) }}",
    "{}",
    error="TypeError: 'int' object is not iterable",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1675" {
  jinja(
    source="{{ {'a': 1}.get() }}",
    "{}",
    error="TypeError: get expected at least 1 argument, got 0",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1676" {
  jinja(
    source="{{ [1].insert(0) }}",
    "{}",
    error="TypeError: insert expected 2 arguments, got 1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1677" {
  jinja(
    source="{{ [1].extend(1) }}",
    "{}",
    error="TypeError: 'int' object is not iterable",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1678" {
  jinja(
    source="{{ f(*[1], **{'a': 1}) }}",
    "{\"f\": null}",
    error="TypeError: 'NoneType' object is not callable",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1679" {
  jinja(
    source="{{ range(*[3])|list }}",
    "{\"f\": null}",
    output="[0, 1, 2]",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1680" {
  jinja(
    source="{{ dict(**{'a': 1}) }}",
    "{\"f\": null}",
    output="{&#39;a&#39;: 1}",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1681" {
  jinja(
    source="{{ range(1, stop=3) }}",
    "{\"f\": null}",
    error="TypeError: range() takes no keyword arguments",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1682" {
  jinja(
    source="{{ 1 is odd is odd }}",
    "{\"f\": null}",
    error="TemplateSyntaxError: You cannot chain multiple tests with is",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1683" {
  jinja(
    source="{% set true = 1 %}",
    "{\"f\": null}",
    error="TemplateSyntaxError: can't assign to 'const'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1684" {
  jinja(
    source="{% set (a, b) = (1, 2) %}{{ a }}{{ b }}",
    "{\"f\": null}",
    output="12",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1685" {
  jinja(
    source="{% set a, b = 'xy' %}{{ b }}{{ a }}",
    "{\"f\": null}",
    output="yx",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1686" {
  jinja(
    source="{% set ns.x = 1 %}",
    "{\"f\": null}",
    error="TemplateRuntimeError: cannot assign attribute on non-namespace object",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1687" {
  jinja(
    source="{% for a, b in [(1, 2), (3, 4)] %}{{ a }}{{ b }}{% endfor %}",
    "{\"f\": null}",
    output="1234",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1688" {
  jinja(
    source="{% for (a, b) in [(1, 2)] %}{{ a + b }}{% endfor %}",
    "{\"f\": null}",
    output="3",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1689" {
  jinja(
    source="{% from 'x' import _private %}",
    "{\"f\": null}",
    error="TemplateAssertionError: names starting with an underline can not be imported",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1690" {
  jinja(
    source="{% macro m(a=1, b) %}{% endmacro %}",
    "{\"f\": null}",
    error="TemplateSyntaxError: non-default argument follows default argument",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1691" {
  jinja(
    source="{% macro m(a, a) %}{% endmacro %}",
    "{\"f\": null}",
    error="SyntaxError: duplicate parameter 'l_1_a' in function definition (<template>, line 12)",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1692" {
  jinja(
    source="{% trans a=1, a=2 %}{% endtrans %}",
    "{\"f\": null}",
    error="TemplateSyntaxError: Encountered unknown tag 'trans'.",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1693" {
  jinja(
    source="{% trans %}{{ x.y }}{% endtrans %}",
    "{\"f\": null}",
    error="TemplateSyntaxError: Encountered unknown tag 'trans'.",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1694" {
  jinja(
    source="{% trans num=1 %}{% pluralize nope %}{% endtrans %}",
    "{\"f\": null}",
    error="TemplateSyntaxError: Encountered unknown tag 'trans'.",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1695" {
  jinja(
    source="{% trans %}a{% pluralize %}b{% pluralize %}c{% endtrans %}",
    "{\"f\": null}",
    error="TemplateSyntaxError: Encountered unknown tag 'trans'.",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1696" {
  jinja(
    source="{% trans %}unclosed",
    "{\"f\": null}",
    error="TemplateSyntaxError: Encountered unknown tag 'trans'.",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1697" {
  jinja(
    source="{% call %}{% endcall %}",
    "{\"f\": null}",
    error="TemplateSyntaxError: unexpected 'end of statement block'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1698" {
  jinja(
    source="{% call x %}{% endcall %}",
    "{\"f\": null}",
    error="TemplateSyntaxError: expected call",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1699" {
  jinja(
    source="{% for x in [1, 2, 3] %}{% if x == 2 %}{% break %}{% endif %}{{ x }}{% endfor %}",
    "{\"f\": null}",
    output="1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1700" {
  jinja(
    source="{% for x in [1, 2] %}{% continue %}{{ x }}{% endfor %}y",
    "{\"f\": null}",
    output="y",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1701" {
  jinja(
    source="{{ 1. }}",
    "{\"f\": null}",
    error="TemplateSyntaxError: expected name or number",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1702" {
  jinja(
    source="{{ x. }}",
    "{\"f\": null}",
    error="TemplateSyntaxError: expected name or number",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1703" {
  jinja(
    source="{{ [1, 2 }}",
    "{\"f\": null}",
    error="TemplateSyntaxError: unexpected '}', expected ']'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1704" {
  jinja(
    source="{{ (1 }}",
    "{\"f\": null}",
    error="TemplateSyntaxError: unexpected '}', expected ')'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1705" {
  jinja(
    source="{{ {'a' 1} }}",
    "{\"f\": null}",
    error="TemplateSyntaxError: expected token ':', got 'integer'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1706" {
  jinja(
    source="{{ 'a' 'b' }}",
    "{\"f\": null}",
    output="ab",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1707" {
  jinja(
    source="{{ 1 if }}",
    "{\"f\": null}",
    error="TemplateSyntaxError: unexpected 'end of print statement'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1708" {
  jinja(
    source="{{ not }}",
    "{\"f\": null}",
    error="TemplateSyntaxError: unexpected 'end of print statement'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1709" {
  jinja(
    source="{{ -'a' }}",
    "{\"f\": null}",
    error="TypeError: bad operand type for unary -: 'str'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1710" {
  jinja(
    source="{{ +true }}|{{ -true }}",
    "{\"f\": null}",
    output="1|-1",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1711" {
  jinja(
    source="{{ 'a' ~ none ~ 1.5 }}",
    "{\"f\": null}",
    output="aNone1.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1712" {
  jinja(
    source="{{ [1][5] }}",
    "{\"f\": null}",
    error="UndefinedError: list object has no element 5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1713" {
  jinja(
    source="{{ 'ab'[9] is undefined }}",
    "{\"f\": null}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1714" {
  jinja(
    source="{{ {'a': 1}['b'] is undefined }}",
    "{\"f\": null}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1715" {
  jinja(
    source="{{ none.x }}",
    "{\"f\": null}",
    error="UndefinedError: 'None' has no attribute 'x'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1716" {
  jinja(
    source="{{ (1).real is defined }}",
    "{\"f\": null}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1717" {
  jinja(
    source="{{ 1 < 'a' }}",
    "{\"f\": null}",
    error="TypeError: '<' not supported between instances of 'int' and 'str'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1718" {
  jinja(
    source="{{ [1] < [2, 3] }}",
    "{\"f\": null}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1719" {
  jinja(
    source="{{ 'b' in 'abc' }}",
    "{\"f\": null}",
    output="True",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1720" {
  jinja(
    source="{{ 1 in 'abc' }}",
    "{\"f\": null}",
    error="TypeError: 'in <string>' requires string as left operand, not int",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1721" {
  jinja(
    source="{{ 10 // 0 }}",
    "{\"f\": null}",
    error="ZeroDivisionError: division by zero",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1722" {
  jinja(
    source="{{ 1 % 0 }}",
    "{\"f\": null}",
    error="ZeroDivisionError: division by zero",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1723" {
  jinja(
    source="{{ 2.5 // 0.0 }}",
    "{\"f\": null}",
    error="ZeroDivisionError: division by zero",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1724" {
  jinja(
    source="{{ 'a' * 'b' }}",
    "{\"f\": null}",
    error="TypeError: can't multiply sequence by non-int of type 'str'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1725" {
  jinja(
    source="{{ [1] + (2,) }}",
    "{\"f\": null}",
    error="TypeError: can only concatenate list (not \"tuple\") to list",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1726" {
  jinja(
    source="{{ 9007199254740993 * 2 }}",
    "{\"f\": null}",
    output="18014398509481986",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1727" {
  jinja(
    source="{{ 2 ** 0.5 ** 2 }}",
    "{\"f\": null}",
    output="2.0000000000000004",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1728" {
  jinja(
    source="{{ -2 ** 2 }}",
    "{\"f\": null}",
    output="4",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1729" {
  jinja(
    source="{{ 7 // -2 }}|{{ -7 % 3 }}|{{ 7.5 % -2 }}",
    "{\"f\": null}",
    output="-4|2|-0.5",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1730" {
  jinja(
    source="{% raw %}{{ x }}{% endraw %}",
    "{\"f\": null}",
    output="{{ x }}",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1731" {
  jinja(
    source="{%- raw -%}  a  {%- endraw -%}",
    "{\"f\": null}",
    output="a",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1732" {
  jinja(
    source="a {#- c -#} b",
    "{\"f\": null}",
    output="ab",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1733" {
  jinja(
    source="a {#+ c +#} b",
    "{\"f\": null}",
    output="a  b",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1734" {
  jinja(
    source="{% if true -%}  x{%- endif %}",
    "{\"f\": null}",
    output="x",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1735" {
  jinja(
    source="{% filter upper %}a{% endfilter %}|{% filter replace('a', 'b')|upper %}aa{% endfilter %}",
    "{\"f\": null}",
    output="A|BB",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1736" {
  jinja(
    source="{% with a = 1, b = a + 1 %}{{ b }}{% endwith %}",
    "{\"f\": null}",
    error="UndefinedError: 'a' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1737" {
  jinja(
    source="{% autoescape false %}{{ '<a>' }}{% endautoescape %}{{ '<a>' }}",
    "{\"f\": null}",
    output="<a>&lt;a&gt;",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1738" {
  jinja(
    source="{% set x %}<b>{% endset %}{{ x }}",
    "{\"f\": null}",
    output="<b>",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1739" {
  jinja(
    source="{{ self.missing is defined }}",
    "{\"f\": null}",
    output="False",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1740" {
  jinja(
    source="{% block a %}A{% endblock %}{{ self.a() }}",
    "{\"f\": null}",
    output="AA",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1741" {
  jinja(
    source="{% for x in [1] %}{{ loop.depth }}{{ loop.revindex }}{{ loop.length }}{% endfor %}",
    "{\"f\": null}",
    output="111",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1742" {
  jinja(
    source="{% for x in [1, 2, 1] %}{{ loop.changed(x) }}{{ loop.cycle('a', 'b', 'c') }}{% endfor %}",
    "{\"f\": null}",
    output="TrueaTruebTruec",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1743" {
  jinja(
    source="{% for x in [1] %}{{ loop.cycle() }}{% endfor %}",
    "{\"f\": null}",
    error="TypeError: no items for cycling given",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1744" {
  jinja(
    source="{% for x in [1, 2] %}{{ loop.previtem|default('-') }}{{ loop.nextitem|default('-') }}{% endfor %}",
    "{\"f\": null}",
    output="-21-",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1745" {
  jinja(
    source="{{ loop }}",
    "{\"f\": null}",
    error="UndefinedError: 'loop' is undefined",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1746" {
  jinja(
    source="{% for x in [1] %}{{ loop() }}{% endfor %}",
    "{\"f\": null}",
    error="TypeError: LoopContext.__call__() missing 1 required positional argument: 'iterable'",
    policy=Strict,
    autoescape=true,
  )
}

///|
test "extra #1747" {
  jinja(
    source="{% for x in [[1]] recursive %}{{ loop(1, 2) }}{% endfor %}",
    "{\"f\": null}",
    error="TypeError: LoopContext.__call__() takes 2 positional arguments but 3 were given",
    policy=Strict,
    autoescape=true,
  )
}
