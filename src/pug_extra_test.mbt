///|
test "pug extra #0" {
  pug_source(
    "p Hello", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>Hello</p>",
  )
}

///|
test "pug extra #1" {
  pug_source(
    "p Hello #{name}!", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>Hello World!</p>",
  )
}

///|
test "pug extra #2" {
  pug_source(
    "p #{n * 2} and #{n + 1}", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>42 and 22</p>",
  )
}

///|
test "pug extra #3" {
  pug_source(
    "p !{html}", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p><b>bold</b></p>",
  )
}

///|
test "pug extra #4" {
  pug_source(
    "p #{html}", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>&lt;b&gt;bold&lt;/b&gt;</p>",
  )
}

///|
test "pug extra #5" {
  pug_source(
    "p \\#{name}", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>#{name}</p>",
  )
}

///|
test "pug extra #6" {
  pug_source(
    "p Esc \\!{html}", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>Esc !{html}</p>",
  )
}

///|
test "pug extra #7" {
  pug_source(
    "p text #[em inline] more", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>text <em>inline</em> more</p>",
  )
}

///|
test "pug extra #8" {
  pug_source(
    "p #[a(href=url) link] after", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p><a href=\"/home\">link</a> after</p>",
  )
}

///|
test "pug extra #9" {
  pug_source(
    "p\n  | piped\n  | lines", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>piped\nlines</p>",
  )
}

///|
test "pug extra #10" {
  pug_source(
    "p.\n  dot block\n  #{name}", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>dot block\nWorld</p>",
  )
}

///|
test "pug extra #11" {
  pug_source(
    "div\n  span one\n  span two", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div><span>one</span><span>two</span></div>",
  )
}

///|
test "pug extra #12" {
  pug_source(
    "ul\n  li a\n  li b\n  li: a(href='/') c", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<ul><li>a</li><li>b</li><li><a href=\"/\">c</a></li></ul>",
  )
}

///|
test "pug extra #13" {
  pug_source(
    "a: img(src='x.png')", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<a><img src=\"x.png\"/></a>",
  )
}

///|
test "pug extra #14" {
  pug_source(
    "img(src='a.png' alt='x')", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<img src=\"a.png\" alt=\"x\"/>",
  )
}

///|
test "pug extra #15" {
  pug_source(
    "br", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<br/>",
  )
}

///|
test "pug extra #16" {
  pug_source(
    "hr/", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<hr/>",
  )
}

///|
test "pug extra #17" {
  pug_source(
    "foo/", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<foo/>",
  )
}

///|
test "pug extra #18" {
  pug_source(
    "input(type='checkbox' checked)", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<input type=\"checkbox\" checked=\"checked\"/>",
  )
}

///|
test "pug extra #19" {
  pug_source(
    "input(checked=false)", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<input/>",
  )
}

///|
test "pug extra #20" {
  pug_source(
    "input(checked=off)", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<input/>",
  )
}

///|
test "pug extra #21" {
  pug_source(
    "input(value=n)", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<input value=\"21\"/>",
  )
}

///|
test "pug extra #22" {
  pug_source(
    "a(href=url) go", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<a href=\"/home\">go</a>",
  )
}

///|
test "pug extra #23" {
  pug_source(
    "a(href='/u/' + name) u", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<a href=\"/u/World\">u</a>",
  )
}

///|
test "pug extra #24" {
  pug_source(
    "div(class=['a', 'b'])", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div class=\"a b\"></div>",
  )
}

///|
test "pug extra #25" {
  pug_source(
    "div.x.y(class='z')", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div class=\"x y z\"></div>",
  )
}

///|
test "pug extra #26" {
  pug_source(
    "div#app.main", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div class=\"main\" id=\"app\"></div>",
  )
}

///|
test "pug extra #27" {
  pug_source(
    "#only", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div id=\"only\"></div>",
  )
}

///|
test "pug extra #28" {
  pug_source(
    ".only", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div class=\"only\"></div>",
  )
}

///|
test "pug extra #29" {
  pug_source(
    "div(data-n=n data-s='s' data-t=true)", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div data-n=\"21\" data-s=\"s\" data-t=\"data-t\"></div>",
  )
}

///|
test "pug extra #30" {
  pug_source(
    "div(title=title)", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div title=\"T &lt;&amp;&gt;\"></div>",
  )
}

///|
test "pug extra #31" {
  pug_source(
    "div(title!=title)", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div title=\"T <&>\"></div>",
  )
}

///|
test "pug extra #32" {
  pug_source(
    "p&attributes(attrs) x", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p class=\"z\" data-a=\"1\">x</p>",
  )
}

///|
test "pug extra #33" {
  pug_source(
    "p.c&attributes(attrs)(class='d') x", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p class=\"c d z\" data-a=\"1\">x</p>",
  )
}

///|
test "pug extra #34" {
  pug_source(
    "div(class=kind)", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div class=\"b\"></div>",
  )
}

///|
test "pug extra #35" {
  pug_source(
    "div(class=empty)", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div></div>",
  )
}

///|
test "pug extra #36" {
  pug_source(
    "a(href='x', target='_blank') t", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<a href=\"x\" target=\"_blank\">t</a>",
  )
}

///|
test "pug extra #37" {
  pug_source(
    "a(\n  href='/multi'\n  title='line'\n) m", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<a href=\"/multi\" title=\"line\">m</a>",
  )
}

///|
test "pug extra #38" {
  pug_source(
    "div(style='color: red')", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div style=\"color: red\"></div>",
  )
}

///|
test "pug extra #39" {
  pug_source(
    "div(a='1' b=\"2\" c=3)", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div a=\"1\" b=\"2\" c=\"3\"></div>",
  )
}

///|
test "pug extra #40" {
  pug_source(
    "// comment\np x", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<!-- comment--><p>x</p>",
  )
}

///|
test "pug extra #41" {
  pug_source(
    "//- hidden\np x", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>x</p>",
  )
}

///|
test "pug extra #42" {
  pug_source(
    "//\n  block comment\n  more\np y", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<!--block comment\nmore--><p>y</p>",
  )
}

///|
test "pug extra #43" {
  pug_source(
    "<div>raw html</div>", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div>raw html</div>",
  )
}

///|
test "pug extra #44" {
  pug_source(
    "div\n  <span>mixed</span>\n  em pug", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div><span>mixed</span><em>pug</em></div>",
  )
}

///|
test "pug extra #45" {
  pug_source(
    "doctype html\nhtml\n  body\n    input(checked)\n    br", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<!DOCTYPE html><html><body><input checked><br></body></html>",
  )
}

///|
test "pug extra #46" {
  pug_source(
    "doctype xml\nroot\n  leaf/", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<?xml version=\"1.0\" encoding=\"utf-8\" ?><root><leaf/></root>",
  )
}

///|
test "pug extra #47" {
  pug_source(
    "doctype transitional\nhtml", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\"><html></html>",
  )
}

///|
test "pug extra #48" {
  pug_source(
    "doctype strict\nhtml", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\"><html></html>",
  )
}

///|
test "pug extra #49" {
  pug_source(
    "doctype frameset\nhtml", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Frameset//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd\"><html></html>",
  )
}

///|
test "pug extra #50" {
  pug_source(
    "doctype 1.1\nhtml", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\"><html></html>",
  )
}

///|
test "pug extra #51" {
  pug_source(
    "doctype basic\nhtml", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML Basic 1.1//EN\" \"http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd\"><html></html>",
  )
}

///|
test "pug extra #52" {
  pug_source(
    "doctype mobile\nhtml", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.2//EN\" \"http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd\"><html></html>",
  )
}

///|
test "pug extra #53" {
  pug_source(
    "doctype plist\nplist", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\"><plist></plist>",
  )
}

///|
test "pug extra #54" {
  pug_source(
    "doctype custom thing\nhtml", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<!DOCTYPE custom thing><html></html>",
  )
}

///|
test "pug extra #55" {
  pug_source(
    "if flag\n  p yes\nelse\n  p no", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>yes</p>",
  )
}

///|
test "pug extra #56" {
  pug_source(
    "if off\n  p yes\nelse if n > 20\n  p big\nelse\n  p small", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>big</p>",
  )
}

///|
test "pug extra #57" {
  pug_source(
    "unless off\n  p shown", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>shown</p>",
  )
}

///|
test "pug extra #58" {
  pug_source(
    "unless flag\n  p hidden", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "",
  )
}

///|
test "pug extra #59" {
  pug_source(
    "if n == 21\n  p eq", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>eq</p>",
  )
}

///|
test "pug extra #60" {
  pug_source(
    "if kind == 'b'\n  p b", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>b</p>",
  )
}

///|
test "pug extra #61" {
  pug_source(
    "each item in items\n  li= item", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<li>a</li><li>b</li><li>c</li>",
  )
}

///|
test "pug extra #62" {
  pug_source(
    "each item, i in items\n  li #{i}:#{item}", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<li>0:a</li><li>1:b</li><li>2:c</li>",
  )
}

///|
test "pug extra #63" {
  pug_source(
    "each v, k in obj\n  li #{k}=#{v}", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<li>x=1</li><li>y=2</li>",
  )
}

///|
test "pug extra #64" {
  pug_source(
    "each item in empty\n  li= item\nelse\n  li none", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<li>none</li>",
  )
}

///|
test "pug extra #65" {
  pug_source(
    "for item in items\n  li= item", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<li>a</li><li>b</li><li>c</li>",
  )
}

///|
test "pug extra #66" {
  pug_source(
    "ul\n  each item in items\n    li\n      span= item", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<ul><li><span>a</span></li><li><span>b</span></li><li><span>c</span></li></ul>",
  )
}

///|
test "pug extra #67" {
  pug_source(
    "case kind\n  when 'a'\n    p A\n  when 'b'\n    p B\n  default\n    p other",
    "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>B</p>",
  )
}

///|
test "pug extra #68" {
  pug_source(
    "case n\n  when 1\n    p one\n  when 21\n    p twenty-one\n  default\n    p many",
    "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>twenty-one</p>",
  )
}

///|
test "pug extra #69" {
  pug_source(
    "case kind\n  when 'a': p A\n  when 'b': p B", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>B</p>",
  )
}

///|
test "pug extra #70" {
  pug_source(
    "case kind\n  when 'x'\n  when 'b'\n    p fall\n  default\n    p d", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>fall</p>",
  )
}

///|
test "pug extra #71" {
  pug_source(
    "mixin item(label)\n  li= label\nul\n  +item('one')\n  +item('two')", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<ul><li>one</li><li>two</li></ul>",
  )
}

///|
test "pug extra #72" {
  pug_source(
    "mixin box\n  div.box\n    block\n+box\n  p inside", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div class=\"box\"><p>inside</p></div>",
  )
}

///|
test "pug extra #73" {
  pug_source(
    "mixin box\n  div.box\n    if block\n      block\n    else\n      p empty\n+box\n+box\n  p full",
    "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div class=\"box\"><p>empty</p></div><div class=\"box\"><p>full</p></div>",
  )
}

///|
test "pug extra #74" {
  pug_source(
    "mixin link(href, text)\n  a(href=href)&attributes(attributes)= text\n+link('/a', 'A')(class='btn')",
    "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<a class=\"btn\" href=\"/a\">A</a>",
  )
}

///|
test "pug extra #75" {
  pug_source(
    "mixin tag\n  span(class=attributes.class) t\n+tag.big", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<span class=\"big\">t</span>",
  )
}

///|
test "pug extra #76" {
  pug_source(
    "mixin pair(a, b)\n  p #{a}-#{b}\n+pair(1, 2)\n+pair('x')", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>1-2</p><p>x-</p>",
  )
}

///|
test "pug extra #77" {
  pug_source(
    "p= name", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>World</p>",
  )
}

///|
test "pug extra #78" {
  pug_source(
    "p!= html", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p><b>bold</b></p>",
  )
}

///|
test "pug extra #79" {
  pug_source(
    "p= n * 2", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>42</p>",
  )
}

///|
test "pug extra #80" {
  pug_source(
    "p= 'lit'", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>lit</p>",
  )
}

///|
test "pug extra #81" {
  pug_source(
    "p #{'quoted'}", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>quoted</p>",
  )
}

///|
test "pug extra #82" {
  pug_source(
    "p= items[0]", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>a</p>",
  )
}

///|
test "pug extra #83" {
  pug_source(
    "p= obj.x", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>1</p>",
  )
}

///|
test "pug extra #84" {
  pug_source(
    "p= obj['y']", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>2</p>",
  )
}

///|
test "pug extra #86" {
  pug_source(
    "div\n  | text\n  strong bold\n  | tail", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div>text<strong>bold</strong>tail</div>",
  )
}

///|
test "pug extra #87" {
  pug_source(
    "pre.\n  keep   spaces\n    indented", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<pre>keep   spaces\n  indented</pre>",
  )
}

///|
test "pug extra #88" {
  pug_source(
    "script.\n  var x = 1 < 2;", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<script>var x = 1 < 2;</script>",
  )
}

///|
test "pug extra #89" {
  pug_source(
    "style.\n  a { color: red; }", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<style>a { color: red; }</style>",
  )
}

///|
test "pug extra #90" {
  pug_source(
    "p: span: em deep", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p><span><em>deep</em></span></p>",
  )
}

///|
test "pug extra #91" {
  pug_source(
    "div(class=['a'])&attributes({'class': 'b'})", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div class=\"a b\"></div>",
  )
}

///|
test "pug extra #92" {
  pug_source(
    "a(class='x' class='y')", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<a class=\"x y\"></a>",
  )
}

///|
test "pug extra #93" {
  pug_source(
    "p(class='') x", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>x</p>",
  )
}

///|
test "pug extra #94" {
  pug_source(
    "p(style='') y", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>y</p>",
  )
}

///|
test "pug extra #95" {
  pug_source(
    "p(id=id) z", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p id=\"main\">z</p>",
  )
}

///|
test "pug extra #96" {
  pug_source(
    "textarea\n  | content", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<textarea>content</textarea>",
  )
}

///|
test "pug extra #97" {
  pug_source(
    "p\n  | before #[b bold] after", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>before <b>bold</b> after</p>",
  )
}

///|
test "pug extra #99" {
  pug_source(
    "p Tab\tseparated", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>Tab\tseparated</p>",
  )
}

///|
test "pug extra #100" {
  pug_source(
    "p trailing  ", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>trailing  </p>",
  )
}

///|
test "pug extra #101" {
  pug_source(
    "div\n\n  p after blank", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div><p>after blank</p></div>",
  )
}

///|
test "pug extra #102" {
  pug_source(
    "div\n  // inner comment\n  p x", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<div><!-- inner comment--><p>x</p></div>",
  )
}

///|
test "pug extra #103" {
  pug_source(
    "block content\n  p default", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>default</p>",
  )
}

///|
test "pug extra #104" {
  pug_source(
    "p a\np b\np c", "{\"name\":\"World\",\"n\":21,\"items\":[\"a\",\"b\",\"c\"],\"obj\":{\"x\":1,\"y\":2},\"url\":\"/home\",\"html\":\"<b>bold</b>\",\"attrs\":{\"data-a\":\"1\",\"class\":\"z\"},\"flag\":true,\"off\":false,\"empty\":[],\"kind\":\"b\",\"title\":\"T <&>\",\"id\":\"main\"}",
    "<p>a</p><p>b</p><p>c</p>",
  )
}
