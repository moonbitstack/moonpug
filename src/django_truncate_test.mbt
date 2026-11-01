///|
test "django slugify #0" {
  jinja(
    source="{{ v|slugify }}",
    "{\"v\": \" Jack & Jill like numbers 1,2,3 and 4 and silly characters ?%.$!/\"}",
    output="jack-jill-like-numbers-123-and-4-and-silly-characters",
    autoescape=false,
  )
}

///|
test "django slugify #1" {
  jinja(
    source="{{ v|slugify }}",
    "{\"v\": \"Un éléphant à l'orée du bois\"}",
    output="un-elephant-a-loree-du-bois",
    autoescape=false,
  )
}

///|
test "django slugify #2" {
  jinja(
    source="{{ v|slugify }}",
    "{\"v\": \"Hello  World---Again\"}",
    output="hello-world-again",
    autoescape=false,
  )
}

///|
test "django slugify #3" {
  jinja(
    source="{{ v|slugify }}",
    "{\"v\": \"a_b-c d\"}",
    output="a_b-c-d",
    autoescape=false,
  )
}

///|
test "django slugify #4" {
  jinja(
    source="{{ v|slugify }}",
    "{\"v\": \"ÀÉÎÕÜ æ¥æ¬èª\"}",
    output="aeiou-ea",
    autoescape=false,
  )
}

///|
test "django slugify #5" {
  jinja(
    source="{{ v|slugify }}",
    "{\"v\": \"foo/bar?baz=1&x=2\"}",
    output="foobarbaz1x2",
    autoescape=false,
  )
}

///|
test "django slugify #6" {
  jinja(
    source="{{ v|slugify }}",
    "{\"v\": \"  spaced  \"}",
    output="spaced",
    autoescape=false,
  )
}

///|
test "django slugify #7" {
  jinja(
    source="{{ v|slugify }}",
    "{\"v\": \"café cole\"}",
    output="cafe-cole",
    autoescape=false,
  )
}

///|
test "django slugify #8" {
  jinja(source="{{ v|slugify }}", "{\"v\": \"\"}", output="", autoescape=false)
}

///|
test "django slugify #9" {
  jinja(
    source="{{ v|slugify }}",
    "{\"v\": \"___\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django slugify #10" {
  jinja(
    source="{{ v|slugify }}",
    "{\"v\": \"already-a-slug\"}",
    output="already-a-slug",
    autoescape=false,
  )
}

///|
test "django slugify #11" {
  jinja(
    source="{{ v|slugify }}",
    "{\"v\": 123}",
    output="123",
    autoescape=false,
  )
}

///|
test "django truncatechars #12" {
  jinja(
    source="{{ v|truncatechars(0) }}",
    "{\"v\": \"Testing, testing\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #13" {
  jinja(
    source="{{ v|truncatechars(1) }}",
    "{\"v\": \"Testing, testing\"}",
    output="…",
    autoescape=false,
  )
}

///|
test "django truncatechars #14" {
  jinja(
    source="{{ v|truncatechars(2) }}",
    "{\"v\": \"Testing, testing\"}",
    output="T…",
    autoescape=false,
  )
}

///|
test "django truncatechars #15" {
  jinja(
    source="{{ v|truncatechars(3) }}",
    "{\"v\": \"Testing, testing\"}",
    output="Te…",
    autoescape=false,
  )
}

///|
test "django truncatechars #16" {
  jinja(
    source="{{ v|truncatechars(4) }}",
    "{\"v\": \"Testing, testing\"}",
    output="Tes…",
    autoescape=false,
  )
}

///|
test "django truncatechars #17" {
  jinja(
    source="{{ v|truncatechars(5) }}",
    "{\"v\": \"Testing, testing\"}",
    output="Test…",
    autoescape=false,
  )
}

///|
test "django truncatechars #18" {
  jinja(
    source="{{ v|truncatechars(7) }}",
    "{\"v\": \"Testing, testing\"}",
    output="Testin…",
    autoescape=false,
  )
}

///|
test "django truncatechars #19" {
  jinja(
    source="{{ v|truncatechars(100) }}",
    "{\"v\": \"Testing, testing\"}",
    output="Testing, testing",
    autoescape=false,
  )
}

///|
test "django truncatechars #20" {
  jinja(
    source="{{ v|truncatechars(0) }}",
    "{\"v\": \"Testing\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #21" {
  jinja(
    source="{{ v|truncatechars(1) }}",
    "{\"v\": \"Testing\"}",
    output="…",
    autoescape=false,
  )
}

///|
test "django truncatechars #22" {
  jinja(
    source="{{ v|truncatechars(2) }}",
    "{\"v\": \"Testing\"}",
    output="T…",
    autoescape=false,
  )
}

///|
test "django truncatechars #23" {
  jinja(
    source="{{ v|truncatechars(3) }}",
    "{\"v\": \"Testing\"}",
    output="Te…",
    autoescape=false,
  )
}

///|
test "django truncatechars #24" {
  jinja(
    source="{{ v|truncatechars(4) }}",
    "{\"v\": \"Testing\"}",
    output="Tes…",
    autoescape=false,
  )
}

///|
test "django truncatechars #25" {
  jinja(
    source="{{ v|truncatechars(5) }}",
    "{\"v\": \"Testing\"}",
    output="Test…",
    autoescape=false,
  )
}

///|
test "django truncatechars #26" {
  jinja(
    source="{{ v|truncatechars(7) }}",
    "{\"v\": \"Testing\"}",
    output="Testing",
    autoescape=false,
  )
}

///|
test "django truncatechars #27" {
  jinja(
    source="{{ v|truncatechars(100) }}",
    "{\"v\": \"Testing\"}",
    output="Testing",
    autoescape=false,
  )
}

///|
test "django truncatechars #28" {
  jinja(
    source="{{ v|truncatechars(0) }}",
    "{\"v\": \"abc\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #29" {
  jinja(
    source="{{ v|truncatechars(1) }}",
    "{\"v\": \"abc\"}",
    output="…",
    autoescape=false,
  )
}

///|
test "django truncatechars #30" {
  jinja(
    source="{{ v|truncatechars(2) }}",
    "{\"v\": \"abc\"}",
    output="a…",
    autoescape=false,
  )
}

///|
test "django truncatechars #31" {
  jinja(
    source="{{ v|truncatechars(3) }}",
    "{\"v\": \"abc\"}",
    output="abc",
    autoescape=false,
  )
}

///|
test "django truncatechars #32" {
  jinja(
    source="{{ v|truncatechars(4) }}",
    "{\"v\": \"abc\"}",
    output="abc",
    autoescape=false,
  )
}

///|
test "django truncatechars #33" {
  jinja(
    source="{{ v|truncatechars(5) }}",
    "{\"v\": \"abc\"}",
    output="abc",
    autoescape=false,
  )
}

///|
test "django truncatechars #34" {
  jinja(
    source="{{ v|truncatechars(7) }}",
    "{\"v\": \"abc\"}",
    output="abc",
    autoescape=false,
  )
}

///|
test "django truncatechars #35" {
  jinja(
    source="{{ v|truncatechars(100) }}",
    "{\"v\": \"abc\"}",
    output="abc",
    autoescape=false,
  )
}

///|
test "django truncatechars #36" {
  jinja(
    source="{{ v|truncatechars(0) }}",
    "{\"v\": \"\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #37" {
  jinja(
    source="{{ v|truncatechars(1) }}",
    "{\"v\": \"\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #38" {
  jinja(
    source="{{ v|truncatechars(2) }}",
    "{\"v\": \"\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #39" {
  jinja(
    source="{{ v|truncatechars(3) }}",
    "{\"v\": \"\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #40" {
  jinja(
    source="{{ v|truncatechars(4) }}",
    "{\"v\": \"\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #41" {
  jinja(
    source="{{ v|truncatechars(5) }}",
    "{\"v\": \"\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #42" {
  jinja(
    source="{{ v|truncatechars(7) }}",
    "{\"v\": \"\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #43" {
  jinja(
    source="{{ v|truncatechars(100) }}",
    "{\"v\": \"\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #44" {
  jinja(
    source="{{ v|truncatechars(0) }}",
    "{\"v\": \"one two three four\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #45" {
  jinja(
    source="{{ v|truncatechars(1) }}",
    "{\"v\": \"one two three four\"}",
    output="…",
    autoescape=false,
  )
}

///|
test "django truncatechars #46" {
  jinja(
    source="{{ v|truncatechars(2) }}",
    "{\"v\": \"one two three four\"}",
    output="o…",
    autoescape=false,
  )
}

///|
test "django truncatechars #47" {
  jinja(
    source="{{ v|truncatechars(3) }}",
    "{\"v\": \"one two three four\"}",
    output="on…",
    autoescape=false,
  )
}

///|
test "django truncatechars #48" {
  jinja(
    source="{{ v|truncatechars(4) }}",
    "{\"v\": \"one two three four\"}",
    output="one…",
    autoescape=false,
  )
}

///|
test "django truncatechars #49" {
  jinja(
    source="{{ v|truncatechars(5) }}",
    "{\"v\": \"one two three four\"}",
    output="one …",
    autoescape=false,
  )
}

///|
test "django truncatechars #50" {
  jinja(
    source="{{ v|truncatechars(7) }}",
    "{\"v\": \"one two three four\"}",
    output="one tw…",
    autoescape=false,
  )
}

///|
test "django truncatechars #51" {
  jinja(
    source="{{ v|truncatechars(100) }}",
    "{\"v\": \"one two three four\"}",
    output="one two three four",
    autoescape=false,
  )
}

///|
test "django truncatechars #52" {
  jinja(
    source="{{ v|truncatechars(0) }}",
    "{\"v\": \"Ångström was here\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #53" {
  jinja(
    source="{{ v|truncatechars(1) }}",
    "{\"v\": \"Ångström was here\"}",
    output="…",
    autoescape=false,
  )
}

///|
test "django truncatechars #54" {
  jinja(
    source="{{ v|truncatechars(2) }}",
    "{\"v\": \"Ångström was here\"}",
    output="Å…",
    autoescape=false,
  )
}

///|
test "django truncatechars #55" {
  jinja(
    source="{{ v|truncatechars(3) }}",
    "{\"v\": \"Ångström was here\"}",
    output="Ån…",
    autoescape=false,
  )
}

///|
test "django truncatechars #56" {
  jinja(
    source="{{ v|truncatechars(4) }}",
    "{\"v\": \"Ångström was here\"}",
    output="Ång…",
    autoescape=false,
  )
}

///|
test "django truncatechars #57" {
  jinja(
    source="{{ v|truncatechars(5) }}",
    "{\"v\": \"Ångström was here\"}",
    output="Ångs…",
    autoescape=false,
  )
}

///|
test "django truncatechars #58" {
  jinja(
    source="{{ v|truncatechars(7) }}",
    "{\"v\": \"Ångström was here\"}",
    output="Ångstr…",
    autoescape=false,
  )
}

///|
test "django truncatechars #59" {
  jinja(
    source="{{ v|truncatechars(100) }}",
    "{\"v\": \"Ångström was here\"}",
    output="Ångström was here",
    autoescape=false,
  )
}

///|
test "django truncatechars #60" {
  jinja(
    source="{{ v|truncatechars(0) }}",
    "{\"v\": \"caféxyz\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #61" {
  jinja(
    source="{{ v|truncatechars(1) }}",
    "{\"v\": \"caféxyz\"}",
    output="…",
    autoescape=false,
  )
}

///|
test "django truncatechars #62" {
  jinja(
    source="{{ v|truncatechars(2) }}",
    "{\"v\": \"caféxyz\"}",
    output="c…",
    autoescape=false,
  )
}

///|
test "django truncatechars #63" {
  jinja(
    source="{{ v|truncatechars(3) }}",
    "{\"v\": \"caféxyz\"}",
    output="ca…",
    autoescape=false,
  )
}

///|
test "django truncatechars #64" {
  jinja(
    source="{{ v|truncatechars(4) }}",
    "{\"v\": \"caféxyz\"}",
    output="caf…",
    autoescape=false,
  )
}

///|
test "django truncatechars #65" {
  jinja(
    source="{{ v|truncatechars(5) }}",
    "{\"v\": \"caféxyz\"}",
    output="café…",
    autoescape=false,
  )
}

///|
test "django truncatechars #66" {
  jinja(
    source="{{ v|truncatechars(7) }}",
    "{\"v\": \"caféxyz\"}",
    output="caféxyz",
    autoescape=false,
  )
}

///|
test "django truncatechars #67" {
  jinja(
    source="{{ v|truncatechars(100) }}",
    "{\"v\": \"caféxyz\"}",
    output="caféxyz",
    autoescape=false,
  )
}

///|
test "django truncatechars #68" {
  jinja(
    source="{{ v|truncatechars(0) }}",
    "{\"v\": \"😀😀😀\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #69" {
  jinja(
    source="{{ v|truncatechars(1) }}",
    "{\"v\": \"😀😀😀\"}",
    output="…",
    autoescape=false,
  )
}

///|
test "django truncatechars #70" {
  jinja(
    source="{{ v|truncatechars(2) }}",
    "{\"v\": \"😀😀😀\"}",
    output="😀…",
    autoescape=false,
  )
}

///|
test "django truncatechars #71" {
  jinja(
    source="{{ v|truncatechars(3) }}",
    "{\"v\": \"😀😀😀\"}",
    output="😀😀😀",
    autoescape=false,
  )
}

///|
test "django truncatechars #72" {
  jinja(
    source="{{ v|truncatechars(4) }}",
    "{\"v\": \"😀😀😀\"}",
    output="😀😀😀",
    autoescape=false,
  )
}

///|
test "django truncatechars #73" {
  jinja(
    source="{{ v|truncatechars(5) }}",
    "{\"v\": \"😀😀😀\"}",
    output="😀😀😀",
    autoescape=false,
  )
}

///|
test "django truncatechars #74" {
  jinja(
    source="{{ v|truncatechars(7) }}",
    "{\"v\": \"😀😀😀\"}",
    output="😀😀😀",
    autoescape=false,
  )
}

///|
test "django truncatechars #75" {
  jinja(
    source="{{ v|truncatechars(100) }}",
    "{\"v\": \"😀😀😀\"}",
    output="😀😀😀",
    autoescape=false,
  )
}

///|
test "django truncatechars #76" {
  jinja(
    source="{{ v|truncatechars(0) }}",
    "{\"v\": \"a & b\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars #77" {
  jinja(
    source="{{ v|truncatechars(1) }}",
    "{\"v\": \"a & b\"}",
    output="…",
    autoescape=false,
  )
}

///|
test "django truncatechars #78" {
  jinja(
    source="{{ v|truncatechars(2) }}",
    "{\"v\": \"a & b\"}",
    output="a…",
    autoescape=false,
  )
}

///|
test "django truncatechars #79" {
  jinja(
    source="{{ v|truncatechars(3) }}",
    "{\"v\": \"a & b\"}",
    output="a …",
    autoescape=false,
  )
}

///|
test "django truncatechars #80" {
  jinja(
    source="{{ v|truncatechars(4) }}",
    "{\"v\": \"a & b\"}",
    output="a &…",
    autoescape=false,
  )
}

///|
test "django truncatechars #81" {
  jinja(
    source="{{ v|truncatechars(5) }}",
    "{\"v\": \"a & b\"}",
    output="a & b",
    autoescape=false,
  )
}

///|
test "django truncatechars #82" {
  jinja(
    source="{{ v|truncatechars(7) }}",
    "{\"v\": \"a & b\"}",
    output="a & b",
    autoescape=false,
  )
}

///|
test "django truncatechars #83" {
  jinja(
    source="{{ v|truncatechars(100) }}",
    "{\"v\": \"a & b\"}",
    output="a & b",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #84" {
  jinja(
    source="{{ v|truncatechars_html(0) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #85" {
  jinja(
    source="{{ v|truncatechars_html(1) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>…</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #86" {
  jinja(
    source="{{ v|truncatechars_html(2) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>o…</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #87" {
  jinja(
    source="{{ v|truncatechars_html(3) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>on…</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #88" {
  jinja(
    source="{{ v|truncatechars_html(4) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one…</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #89" {
  jinja(
    source="{{ v|truncatechars_html(5) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">…</a></p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #90" {
  jinja(
    source="{{ v|truncatechars_html(6) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">t…</a></p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #91" {
  jinja(
    source="{{ v|truncatechars_html(9) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">two …</a></p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #92" {
  jinja(
    source="{{ v|truncatechars_html(10) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">two -…</a></p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #93" {
  jinja(
    source="{{ v|truncatechars_html(12) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">two - t…</a></p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #94" {
  jinja(
    source="{{ v|truncatechars_html(20) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">two - three <br>fou…</a></p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #95" {
  jinja(
    source="{{ v|truncatechars_html(100) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">two - three <br>four</a> five</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #96" {
  jinja(
    source="{{ v|truncatechars_html(0) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #97" {
  jinja(
    source="{{ v|truncatechars_html(1) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>…</b>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #98" {
  jinja(
    source="{{ v|truncatechars_html(2) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Å…</b>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #99" {
  jinja(
    source="{{ v|truncatechars_html(3) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ån…</b>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #100" {
  jinja(
    source="{{ v|truncatechars_html(4) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ång…</b>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #101" {
  jinja(
    source="{{ v|truncatechars_html(5) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångs…</b>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #102" {
  jinja(
    source="{{ v|truncatechars_html(6) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångst…</b>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #103" {
  jinja(
    source="{{ v|truncatechars_html(9) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångström</b>…",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #104" {
  jinja(
    source="{{ v|truncatechars_html(10) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångström</b> …",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #105" {
  jinja(
    source="{{ v|truncatechars_html(12) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångström</b> wa…",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #106" {
  jinja(
    source="{{ v|truncatechars_html(20) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångström</b> was here",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #107" {
  jinja(
    source="{{ v|truncatechars_html(100) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångström</b> was here",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #108" {
  jinja(
    source="{{ v|truncatechars_html(0) }}",
    "{\"v\": \"a<b>b</b>c\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #109" {
  jinja(
    source="{{ v|truncatechars_html(1) }}",
    "{\"v\": \"a<b>b</b>c\"}",
    output="…",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #110" {
  jinja(
    source="{{ v|truncatechars_html(2) }}",
    "{\"v\": \"a<b>b</b>c\"}",
    output="a<b>…</b>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #111" {
  jinja(
    source="{{ v|truncatechars_html(3) }}",
    "{\"v\": \"a<b>b</b>c\"}",
    output="a<b>b</b>c",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #112" {
  jinja(
    source="{{ v|truncatechars_html(4) }}",
    "{\"v\": \"a<b>b</b>c\"}",
    output="a<b>b</b>c",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #113" {
  jinja(
    source="{{ v|truncatechars_html(5) }}",
    "{\"v\": \"a<b>b</b>c\"}",
    output="a<b>b</b>c",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #114" {
  jinja(
    source="{{ v|truncatechars_html(6) }}",
    "{\"v\": \"a<b>b</b>c\"}",
    output="a<b>b</b>c",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #115" {
  jinja(
    source="{{ v|truncatechars_html(9) }}",
    "{\"v\": \"a<b>b</b>c\"}",
    output="a<b>b</b>c",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #116" {
  jinja(
    source="{{ v|truncatechars_html(10) }}",
    "{\"v\": \"a<b>b</b>c\"}",
    output="a<b>b</b>c",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #117" {
  jinja(
    source="{{ v|truncatechars_html(12) }}",
    "{\"v\": \"a<b>b</b>c\"}",
    output="a<b>b</b>c",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #118" {
  jinja(
    source="{{ v|truncatechars_html(20) }}",
    "{\"v\": \"a<b>b</b>c\"}",
    output="a<b>b</b>c",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #119" {
  jinja(
    source="{{ v|truncatechars_html(100) }}",
    "{\"v\": \"a<b>b</b>c\"}",
    output="a<b>b</b>c",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #120" {
  jinja(
    source="{{ v|truncatechars_html(0) }}",
    "{\"v\": \"<div><p>text</p></div>\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #121" {
  jinja(
    source="{{ v|truncatechars_html(1) }}",
    "{\"v\": \"<div><p>text</p></div>\"}",
    output="<div><p>…</p></div>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #122" {
  jinja(
    source="{{ v|truncatechars_html(2) }}",
    "{\"v\": \"<div><p>text</p></div>\"}",
    output="<div><p>t…</p></div>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #123" {
  jinja(
    source="{{ v|truncatechars_html(3) }}",
    "{\"v\": \"<div><p>text</p></div>\"}",
    output="<div><p>te…</p></div>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #124" {
  jinja(
    source="{{ v|truncatechars_html(4) }}",
    "{\"v\": \"<div><p>text</p></div>\"}",
    output="<div><p>tex…</p></div>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #125" {
  jinja(
    source="{{ v|truncatechars_html(5) }}",
    "{\"v\": \"<div><p>text</p></div>\"}",
    output="<div><p>text</p></div>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #126" {
  jinja(
    source="{{ v|truncatechars_html(6) }}",
    "{\"v\": \"<div><p>text</p></div>\"}",
    output="<div><p>text</p></div>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #127" {
  jinja(
    source="{{ v|truncatechars_html(9) }}",
    "{\"v\": \"<div><p>text</p></div>\"}",
    output="<div><p>text</p></div>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #128" {
  jinja(
    source="{{ v|truncatechars_html(10) }}",
    "{\"v\": \"<div><p>text</p></div>\"}",
    output="<div><p>text</p></div>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #129" {
  jinja(
    source="{{ v|truncatechars_html(12) }}",
    "{\"v\": \"<div><p>text</p></div>\"}",
    output="<div><p>text</p></div>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #130" {
  jinja(
    source="{{ v|truncatechars_html(20) }}",
    "{\"v\": \"<div><p>text</p></div>\"}",
    output="<div><p>text</p></div>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #131" {
  jinja(
    source="{{ v|truncatechars_html(100) }}",
    "{\"v\": \"<div><p>text</p></div>\"}",
    output="<div><p>text</p></div>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #132" {
  jinja(
    source="{{ v|truncatechars_html(0) }}",
    "{\"v\": \"a & b <b>c</b>\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #133" {
  jinja(
    source="{{ v|truncatechars_html(1) }}",
    "{\"v\": \"a & b <b>c</b>\"}",
    output="…",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #134" {
  jinja(
    source="{{ v|truncatechars_html(2) }}",
    "{\"v\": \"a & b <b>c</b>\"}",
    output="a…",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #135" {
  jinja(
    source="{{ v|truncatechars_html(3) }}",
    "{\"v\": \"a & b <b>c</b>\"}",
    output="a …",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #136" {
  jinja(
    source="{{ v|truncatechars_html(4) }}",
    "{\"v\": \"a & b <b>c</b>\"}",
    output="a &amp;…",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #137" {
  jinja(
    source="{{ v|truncatechars_html(5) }}",
    "{\"v\": \"a & b <b>c</b>\"}",
    output="a &amp; …",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #138" {
  jinja(
    source="{{ v|truncatechars_html(6) }}",
    "{\"v\": \"a & b <b>c</b>\"}",
    output="a &amp; b…",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #139" {
  jinja(
    source="{{ v|truncatechars_html(9) }}",
    "{\"v\": \"a & b <b>c</b>\"}",
    output="a &amp; b <b>c</b>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #140" {
  jinja(
    source="{{ v|truncatechars_html(10) }}",
    "{\"v\": \"a & b <b>c</b>\"}",
    output="a &amp; b <b>c</b>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #141" {
  jinja(
    source="{{ v|truncatechars_html(12) }}",
    "{\"v\": \"a & b <b>c</b>\"}",
    output="a &amp; b <b>c</b>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #142" {
  jinja(
    source="{{ v|truncatechars_html(20) }}",
    "{\"v\": \"a & b <b>c</b>\"}",
    output="a &amp; b <b>c</b>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #143" {
  jinja(
    source="{{ v|truncatechars_html(100) }}",
    "{\"v\": \"a & b <b>c</b>\"}",
    output="a &amp; b <b>c</b>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #144" {
  jinja(
    source="{{ v|truncatechars_html(0) }}",
    "{\"v\": \"x<!-- gone -->y\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #145" {
  jinja(
    source="{{ v|truncatechars_html(1) }}",
    "{\"v\": \"x<!-- gone -->y\"}",
    output="…",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #146" {
  jinja(
    source="{{ v|truncatechars_html(2) }}",
    "{\"v\": \"x<!-- gone -->y\"}",
    output="x…",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #147" {
  jinja(
    source="{{ v|truncatechars_html(3) }}",
    "{\"v\": \"x<!-- gone -->y\"}",
    output="xy",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #148" {
  jinja(
    source="{{ v|truncatechars_html(4) }}",
    "{\"v\": \"x<!-- gone -->y\"}",
    output="xy",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #149" {
  jinja(
    source="{{ v|truncatechars_html(5) }}",
    "{\"v\": \"x<!-- gone -->y\"}",
    output="xy",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #150" {
  jinja(
    source="{{ v|truncatechars_html(6) }}",
    "{\"v\": \"x<!-- gone -->y\"}",
    output="xy",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #151" {
  jinja(
    source="{{ v|truncatechars_html(9) }}",
    "{\"v\": \"x<!-- gone -->y\"}",
    output="xy",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #152" {
  jinja(
    source="{{ v|truncatechars_html(10) }}",
    "{\"v\": \"x<!-- gone -->y\"}",
    output="xy",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #153" {
  jinja(
    source="{{ v|truncatechars_html(12) }}",
    "{\"v\": \"x<!-- gone -->y\"}",
    output="xy",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #154" {
  jinja(
    source="{{ v|truncatechars_html(20) }}",
    "{\"v\": \"x<!-- gone -->y\"}",
    output="xy",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #155" {
  jinja(
    source="{{ v|truncatechars_html(100) }}",
    "{\"v\": \"x<!-- gone -->y\"}",
    output="xy",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #156" {
  jinja(
    source="{{ v|truncatechars_html(0) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #157" {
  jinja(
    source="{{ v|truncatechars_html(1) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>…</i>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #158" {
  jinja(
    source="{{ v|truncatechars_html(2) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>B…</i>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #159" {
  jinja(
    source="{{ v|truncatechars_html(3) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Bu…</i>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #160" {
  jinja(
    source="{{ v|truncatechars_html(4) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Bue…</i>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #161" {
  jinja(
    source="{{ v|truncatechars_html(5) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buen…</i>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #162" {
  jinja(
    source="{{ v|truncatechars_html(6) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Bueno…</i>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #163" {
  jinja(
    source="{{ v|truncatechars_html(9) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buenos d…</i>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #164" {
  jinja(
    source="{{ v|truncatechars_html(10) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buenos dí…</i>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #165" {
  jinja(
    source="{{ v|truncatechars_html(12) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buenos días…</i>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #166" {
  jinja(
    source="{{ v|truncatechars_html(20) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buenos días! ¿Cómo …</i>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #167" {
  jinja(
    source="{{ v|truncatechars_html(100) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buenos días! ¿Cómo está?</i>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #168" {
  jinja(
    source="{{ v|truncatechars_html(0) }}",
    "{\"v\": \"<ul><li>one<li>two</ul>\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #169" {
  jinja(
    source="{{ v|truncatechars_html(1) }}",
    "{\"v\": \"<ul><li>one<li>two</ul>\"}",
    output="<ul><li>…</li></ul>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #170" {
  jinja(
    source="{{ v|truncatechars_html(2) }}",
    "{\"v\": \"<ul><li>one<li>two</ul>\"}",
    output="<ul><li>o…</li></ul>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #171" {
  jinja(
    source="{{ v|truncatechars_html(3) }}",
    "{\"v\": \"<ul><li>one<li>two</ul>\"}",
    output="<ul><li>on…</li></ul>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #172" {
  jinja(
    source="{{ v|truncatechars_html(4) }}",
    "{\"v\": \"<ul><li>one<li>two</ul>\"}",
    output="<ul><li>one<li>…</li></li></ul>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #173" {
  jinja(
    source="{{ v|truncatechars_html(5) }}",
    "{\"v\": \"<ul><li>one<li>two</ul>\"}",
    output="<ul><li>one<li>t…</li></li></ul>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #174" {
  jinja(
    source="{{ v|truncatechars_html(6) }}",
    "{\"v\": \"<ul><li>one<li>two</ul>\"}",
    output="<ul><li>one<li>tw…</li></li></ul>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #175" {
  jinja(
    source="{{ v|truncatechars_html(9) }}",
    "{\"v\": \"<ul><li>one<li>two</ul>\"}",
    output="<ul><li>one<li>two</ul>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #176" {
  jinja(
    source="{{ v|truncatechars_html(10) }}",
    "{\"v\": \"<ul><li>one<li>two</ul>\"}",
    output="<ul><li>one<li>two</ul>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #177" {
  jinja(
    source="{{ v|truncatechars_html(12) }}",
    "{\"v\": \"<ul><li>one<li>two</ul>\"}",
    output="<ul><li>one<li>two</ul>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #178" {
  jinja(
    source="{{ v|truncatechars_html(20) }}",
    "{\"v\": \"<ul><li>one<li>two</ul>\"}",
    output="<ul><li>one<li>two</ul>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #179" {
  jinja(
    source="{{ v|truncatechars_html(100) }}",
    "{\"v\": \"<ul><li>one<li>two</ul>\"}",
    output="<ul><li>one<li>two</ul>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #180" {
  jinja(
    source="{{ v|truncatechars_html(0) }}",
    "{\"v\": \"<p>a<br/>b</p>\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #181" {
  jinja(
    source="{{ v|truncatechars_html(1) }}",
    "{\"v\": \"<p>a<br/>b</p>\"}",
    output="<p>…</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #182" {
  jinja(
    source="{{ v|truncatechars_html(2) }}",
    "{\"v\": \"<p>a<br/>b</p>\"}",
    output="<p>a<br/>…</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #183" {
  jinja(
    source="{{ v|truncatechars_html(3) }}",
    "{\"v\": \"<p>a<br/>b</p>\"}",
    output="<p>a<br/>b</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #184" {
  jinja(
    source="{{ v|truncatechars_html(4) }}",
    "{\"v\": \"<p>a<br/>b</p>\"}",
    output="<p>a<br/>b</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #185" {
  jinja(
    source="{{ v|truncatechars_html(5) }}",
    "{\"v\": \"<p>a<br/>b</p>\"}",
    output="<p>a<br/>b</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #186" {
  jinja(
    source="{{ v|truncatechars_html(6) }}",
    "{\"v\": \"<p>a<br/>b</p>\"}",
    output="<p>a<br/>b</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #187" {
  jinja(
    source="{{ v|truncatechars_html(9) }}",
    "{\"v\": \"<p>a<br/>b</p>\"}",
    output="<p>a<br/>b</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #188" {
  jinja(
    source="{{ v|truncatechars_html(10) }}",
    "{\"v\": \"<p>a<br/>b</p>\"}",
    output="<p>a<br/>b</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #189" {
  jinja(
    source="{{ v|truncatechars_html(12) }}",
    "{\"v\": \"<p>a<br/>b</p>\"}",
    output="<p>a<br/>b</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #190" {
  jinja(
    source="{{ v|truncatechars_html(20) }}",
    "{\"v\": \"<p>a<br/>b</p>\"}",
    output="<p>a<br/>b</p>",
    autoescape=false,
  )
}

///|
test "django truncatechars_html #191" {
  jinja(
    source="{{ v|truncatechars_html(100) }}",
    "{\"v\": \"<p>a<br/>b</p>\"}",
    output="<p>a<br/>b</p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #192" {
  jinja(
    source="{{ v|truncatewords_html(0) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #193" {
  jinja(
    source="{{ v|truncatewords_html(1) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\"> …</a></p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #194" {
  jinja(
    source="{{ v|truncatewords_html(2) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">two …</a></p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #195" {
  jinja(
    source="{{ v|truncatewords_html(3) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">two - …</a></p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #196" {
  jinja(
    source="{{ v|truncatewords_html(4) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">two - three <br> …</a></p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #197" {
  jinja(
    source="{{ v|truncatewords_html(5) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">two - three <br>four</a> …</p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #198" {
  jinja(
    source="{{ v|truncatewords_html(6) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">two - three <br>four</a> five</p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #199" {
  jinja(
    source="{{ v|truncatewords_html(100) }}",
    "{\"v\": \"<p>one <a href=\\\"#\\\">two - three <br>four</a> five</p>\"}",
    output="<p>one <a href=\"#\">two - three <br>four</a> five</p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #200" {
  jinja(
    source="{{ v|truncatewords_html(0) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #201" {
  jinja(
    source="{{ v|truncatewords_html(1) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångström</b> …",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #202" {
  jinja(
    source="{{ v|truncatewords_html(2) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångström</b> was …",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #203" {
  jinja(
    source="{{ v|truncatewords_html(3) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångström</b> was here",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #204" {
  jinja(
    source="{{ v|truncatewords_html(4) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångström</b> was here",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #205" {
  jinja(
    source="{{ v|truncatewords_html(5) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångström</b> was here",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #206" {
  jinja(
    source="{{ v|truncatewords_html(6) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångström</b> was here",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #207" {
  jinja(
    source="{{ v|truncatewords_html(100) }}",
    "{\"v\": \"<b>Ångström</b> was here\"}",
    output="<b>Ångström</b> was here",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #208" {
  jinja(
    source="{{ v|truncatewords_html(0) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #209" {
  jinja(
    source="{{ v|truncatewords_html(1) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buenos …</i>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #210" {
  jinja(
    source="{{ v|truncatewords_html(2) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buenos días! …</i>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #211" {
  jinja(
    source="{{ v|truncatewords_html(3) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buenos días! ¿Cómo …</i>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #212" {
  jinja(
    source="{{ v|truncatewords_html(4) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buenos días! ¿Cómo está?</i>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #213" {
  jinja(
    source="{{ v|truncatewords_html(5) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buenos días! ¿Cómo está?</i>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #214" {
  jinja(
    source="{{ v|truncatewords_html(6) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buenos días! ¿Cómo está?</i>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #215" {
  jinja(
    source="{{ v|truncatewords_html(100) }}",
    "{\"v\": \"<i>Buenos d&iacute;as! &#x00bf;C&oacute;mo est&aacute;?</i>\"}",
    output="<i>Buenos días! ¿Cómo está?</i>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #216" {
  jinja(
    source="{{ v|truncatewords_html(0) }}",
    "{\"v\": \"<p>string</p>\"}",
    output="",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #217" {
  jinja(
    source="{{ v|truncatewords_html(1) }}",
    "{\"v\": \"<p>string</p>\"}",
    output="<p>string</p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #218" {
  jinja(
    source="{{ v|truncatewords_html(2) }}",
    "{\"v\": \"<p>string</p>\"}",
    output="<p>string</p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #219" {
  jinja(
    source="{{ v|truncatewords_html(3) }}",
    "{\"v\": \"<p>string</p>\"}",
    output="<p>string</p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #220" {
  jinja(
    source="{{ v|truncatewords_html(4) }}",
    "{\"v\": \"<p>string</p>\"}",
    output="<p>string</p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #221" {
  jinja(
    source="{{ v|truncatewords_html(5) }}",
    "{\"v\": \"<p>string</p>\"}",
    output="<p>string</p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #222" {
  jinja(
    source="{{ v|truncatewords_html(6) }}",
    "{\"v\": \"<p>string</p>\"}",
    output="<p>string</p>",
    autoescape=false,
  )
}

///|
test "django truncatewords_html #223" {
  jinja(
    source="{{ v|truncatewords_html(100) }}",
    "{\"v\": \"<p>string</p>\"}",
    output="<p>string</p>",
    autoescape=false,
  )
}
