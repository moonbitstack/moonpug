///|
let pug_cases : Map[String, String] = Map([
  (
    "attrs-data.pug", "- var user = { name: 'tobi' }\nfoo(data-user=user)\nfoo(data-items=[1,2,3])\nfoo(data-username='tobi')\nfoo(data-escaped={message: \"Let's rock!\"})\nfoo(data-ampersand={message: \"a quote: &quot; this & that\"})\nfoo(data-epoc=new Date(0))\n",
  ),
  (
    "attrs.colon.pug", "//- Tests for using a colon-prefexed attribute (typical when using short-cut for Vue.js `v-bind`)\ndiv(:my-var=\"model\")\nspan(v-for=\"item in items\" :key=\"item.id\" :value=\"item.name\")\nspan(\n  v-for=\"item in items\"\n  :key=\"item.id\"\n  :value=\"item.name\"\n)\na(:link=\"goHere\" value=\"static\" :my-value=\"dynamic\" @click=\"onClick()\" :another=\"more\") Click Me!\n",
  ),
  (
    "attrs.js.pug", "- var id = 5\n- function answer() { return 42; }\na(href='/user/' + id, class='button')\na(href  =  '/user/' + id, class  =  'button')\nmeta(key='answer', value=answer())\na(class = ['class1', 'class2'])\na.tag-class(class = ['class1', 'class2'])\n\na(href='/user/' + id class='button')\na(href  =  '/user/' + id class  =  'button')\nmeta(key='answer' value=answer())\na(class = ['class1', 'class2'])\na.tag-class(class = ['class1', 'class2'])\n\ndiv(id=id)&attributes({foo: 'bar'})\n- var bar = null\ndiv(foo=null bar=bar)&attributes({baz: 'baz'})\n",
  ),
  (
    "attrs.pug", "a(href='/contact') contact\na(href='/save').button save\na(foo, bar, baz)\na(foo='foo, bar, baz', bar=1)\na(foo='((foo))', bar= (1) ? 1 : 0 )\nselect\n  option(value='foo', selected) Foo\n  option(selected, value='bar') Bar\na(foo=\"class:\")\ninput(pattern='\\\\S+')\n\na(href='/contact') contact\na(href='/save').button save\na(foo bar baz)\na(foo='foo, bar, baz' bar=1)\na(foo='((foo))' bar= (1) ? 1 : 0 )\nselect\n  option(value='foo' selected) Foo\n  option(selected value='bar') Bar\na(foo=\"class:\")\ninput(pattern='\\\\S+')\nfoo(terse=\"true\")\nfoo(date=new Date(0))\n\nfoo(abc\n   ,def)\nfoo(abc,\n    def)\nfoo(abc,\n\t\tdef)\nfoo(abc\n\t\t,def)\nfoo(abc\n\t\tdef)\nfoo(abc\n    def)\n\n- var attrs = {foo: 'bar', bar: '<baz>'}\n\ndiv&attributes(attrs)\n\na(foo='foo' \"bar\"=\"bar\")\na(foo='foo' 'bar'='bar')\n",
  ),
  (
    "attrs.unescaped.pug", "script(type='text/x-template')\n  div(id!='user-<%= user.id %>')\n    h1 <%= user.title %>",
  ),
  ("auxiliary/1794-extends.pug", "block content"),
  (
    "auxiliary/1794-include.pug", "mixin test()\n  .test&attributes(attributes)\n \n+test()",
  ),
  (
    "auxiliary/blocks-in-blocks-layout.pug", "doctype html\nhtml\n  head\n    title Default title\n  body\n    block body\n      .container\n        block content\n",
  ),
  (
    "auxiliary/dialog.pug", "\nextends window.pug\n\nblock window-content\n  .dialog\n    block content\n",
  ),
  ("auxiliary/empty-block.pug", "block test\n\n"),
  (
    "auxiliary/extends-empty-block-1.pug", "extends empty-block.pug\n\nblock test\n    div test1\n\n",
  ),
  (
    "auxiliary/extends-empty-block-2.pug", "extends empty-block.pug\n\nblock test\n    div test2\n\n",
  ),
  (
    "auxiliary/extends-from-root.pug", "extends /auxiliary/layout.pug\n\nblock content\n    include /auxiliary/include-from-root.pug\n",
  ),
  (
    "auxiliary/extends-relative.pug", "extends ../../cases/auxiliary/layout\n\nblock content\n    include ../../cases/auxiliary/include-from-root\n",
  ),
  (
    "auxiliary/filter-in-include.pug", "html\n  head\n    style(type=\"text/css\")\n      :less\n        @pad: 15px;\n        body {\n          padding: @pad;\n        }\n",
  ),
  ("auxiliary/include-from-root.pug", "h1 hello"),
  (
    "auxiliary/inheritance.extend.mixin.block.pug", "mixin article()\n  article\n    block\n\nhtml\n  head\n    title My Application\n    block head\n  body\n    +article\n      block content\n",
  ),
  (
    "auxiliary/inheritance.extend.recursive-grand-grandparent.pug", "h1 grand-grandparent\nblock grand-grandparent",
  ),
  (
    "auxiliary/inheritance.extend.recursive-grandparent.pug", "extends inheritance.extend.recursive-grand-grandparent.pug\n\nblock grand-grandparent\n    h2 grandparent\n    block grandparent\n\n",
  ),
  (
    "auxiliary/inheritance.extend.recursive-parent.pug", "extends inheritance.extend.recursive-grandparent.pug\n\nblock grandparent\n    h3 parent\n    block parent",
  ),
  (
    "auxiliary/layout.include.pug", "html\n  head\n    title My Application\n    block head\n  body\n    block content\n    include window.pug\n",
  ),
  (
    "auxiliary/layout.pug", "html\n  head\n    title My Application\n    block head\n  body\n    block content",
  ),
  (
    "auxiliary/mixin-at-end-of-file.pug", "mixin slide\n  section.slide\n    block",
  ),
  ("auxiliary/mixins.pug", "\nmixin foo()\n  p bar"),
  (
    "auxiliary/pet.pug", ".pet\n  h1 {{name}}\n  p {{name}} is a {{species}} that is {{age}} old",
  ),
  (
    "auxiliary/window.pug", "\n.window\n  a(href='#').close Close\n  block window-content",
  ),
  (
    "auxiliary/yield-nested.pug", "html\n  head\n    title\n  body\n    h1 Page\n    #content\n      #content-wrapper\n        yield\n    #footer\n      stuff",
  ),
  ("basic.pug", "html\n  body\n    h1 Title"),
  ("blanks.pug", "\n\nul\n  li foo\n\n  li bar\n      \n  li baz\n"),
  (
    "block-code.pug", "-\n  list = [\"uno\", \"dos\", \"tres\",\n          \"cuatro\", \"cinco\", \"seis\"];\n//- Without a block, the element is accepted and no code is generated\n-\neach item in list\n  -\n    string = item.charAt(0)\n    \n      .toUpperCase() +\n    item.slice(1);\n  li= string\n",
  ),
  (
    "block-expansion.pug", "ul\n  li: a(href='#') foo\n  li: a(href='#') bar\n\np baz",
  ),
  ("block-expansion.shorthands.pug", "ul\n  li.list-item: .foo: #bar baz"),
  (
    "blockquote.pug", "figure\n  blockquote\n    | Try to define yourself by what you do, and you&#8217;ll burnout every time. You are. That is enough. I rest in that.\n  figcaption from @thefray at 1:43pm on May 10",
  ),
  (
    "blocks-in-blocks.pug", "extends ./auxiliary/blocks-in-blocks-layout.pug\n\nblock body\n  h1 Page 2\n",
  ),
  (
    "blocks-in-if.pug", "//- see https://github.com/pugjs/pug/issues/1589\n\n-var ajax = true\n\n-if( ajax )\n    //- return only contents if ajax requests\n    block contents\n        p ajax contents\n\n-else\n    //- return all html\n    doctype html\n    html\n        head\n            meta( charset='utf8' )\n            title sample\n            body\n                block contents\n                    p all contetns\n",
  ),
  (
    "case-blocks.pug", "html\n  body\n    - var friends = 1\n    case friends\n      when 0\n        p you have no friends\n      when 1\n        p you have a friend\n      default\n        p you have #{friends} friends",
  ),
  (
    "case.pug", "html\n  body\n    - var friends = 1\n    case friends\n      when 0: p you have no friends\n      when 1: p you have a friend\n      default: p you have #{friends} friends\n    - var friends = 0\n    case friends\n      when 0\n      when 1\n        p you have very few friends\n      default\n        p you have #{friends} friends\n\n    - var friend = 'Tim:G'\n    case friend\n      when 'Tim:G':    p Friend is a string\n      when {tim: 'g'}: p Friend is an object\n",
  ),
  ("classes-empty.pug", "a(class='')\na(class=null)\na(class=undefined)"),
  (
    "classes.pug", "a(class=['foo', 'bar', 'baz'])\n\n\n\na.foo(class='bar').baz\n\n\n\na.foo-bar_baz\n\na(class={foo: true, bar: false, baz: true})\n",
  ),
  (
    "code.conditionals.pug", "\n- if (true)\n  p foo\n- else\n  p bar\n\n- if (true) {\n  p foo\n- } else {\n  p bar\n- }\n\nif true\n  p foo\n  p bar\n  p baz\nelse\n  p bar\n\nunless true\n  p foo\nelse\n  p bar\n\nif 'nested'\n  if 'works'\n    p yay\n\n//- allow empty blocks\nif false\nelse\n  .bar\nif true\n  .bar\nelse\n.bing\n\nif false\n  .bing\nelse if false\n  .bar\nelse\n  .foo",
  ),
  ("code.escape.pug", "p= '<script>'\np!= '<script>'"),
  (
    "code.iteration.pug", "\n- var items = [1,2,3]\n\nul\n  - items.forEach(function(item){\n    li= item\n  - })\n\n- var items = [1,2,3]\n\nul\n  for item, i in items\n    li(class='item-' + i)= item\n\nul\n  each item, i in items\n    li= item\n\nul\n  each $item in items\n    li= $item\n\n- var nums = [1, 2, 3]\n- var letters = ['a', 'b', 'c']\n\nul\n  for l in letters\n    for n in nums\n      li #{n}: #{l}\n\n- var count = 1\n- var counter = function() { return [count++, count++, count++] }\nul\n  for n in counter()\n    li #{n}\n",
  ),
  (
    "code.pug", "p= null\np= undefined\np= ''\np= 0\np= false\np(foo=null)\np(foo=undefined)\np(foo='')\np(foo=0)\np(foo=false)",
  ),
  (
    "comments-in-case.pug", "doctype html\nhtml\n  body\n   - var s = 'this'\n   case s\n     //- Comment\n     when 'this'\n       p It's this!\n     when 'that'\n       p It's that!",
  ),
  (
    "comments.pug", "\n// foo\nul\n  // bar\n  li one\n  // baz\n  li two\n\n//\n  ul\n    li foo\n\n// block\n  // inline follow\n  li three\n\n// block\n  // inline followed by tags\n  ul\n    li four\n\n//if IE lt 9\n  // inline\n  script(src='/lame.js')\n  // end-inline\n\np five\n\n.foo // not a comment",
  ),
  (
    "comments.source.pug", "//-\n  s/s.\n\n//- test/cases/comments.source.pug\n\n//-\n  test/cases/comments.source.pug\n  when\n  ()\n",
  ),
  ("doctype.custom.pug", "doctype custom stuff"),
  ("doctype.default.pug", "doctype\nhtml\n  body\n    h1 Title"),
  ("doctype.keyword.pug", "doctype html"),
  (
    "each.else.pug", "\n- var users = []\n\nul\n  for user in users\n    li= user.name\n  else\n    li no users!\n\n\n- var users = [{ name: 'tobi', friends: ['loki'] }, { name: 'loki' }]\n\nif users\n  ul\n    for user in users\n      li= user.name\n    else\n      li no users!\n\n- var user = { name: 'tobi', age: 10 }\n\nul\n  each val, key in user\n    li #{key}: #{val}\n  else\n    li user has no details!\n\n- var user = {}\n\nul\n  each prop, key in user\n    li #{key}: #{val}\n  else\n    li user has no details!\n\n- var user = Object.create(null)\n- user.name = 'tobi'\n\nul\n  each val, key in user\n    li #{key}: #{val}\n  else\n    li user has no details!\n",
  ),
  ("escape-chars.pug", "script.\n  var re = /\\d+/;"),
  (
    "escape-test.pug", "doctype html\nhtml\n    head\n        title escape-test\n    body\n        textarea\n            - var txt = '<param name=\"flashvars\" value=\"a=&quot;value_a&quot;&b=&quot;value_b&quot;&c=3\"/>'\n            | #{txt}\n",
  ),
  (
    "escaping-class-attribute.pug", "foo(attr=\"<%= bar %>\")\nfoo(class=\"<%= bar %>\")\nfoo(attr!=\"<%= bar %>\")\nfoo(class!=\"<%= bar %>\")\nfoo(class!=\"<%= bar %> lol rofl\")\nfoo(class!=\"<%= bar %> lol rofl <%= lmao %>\")\n",
  ),
  ("filter-in-include.pug", "include ./auxiliary/filter-in-include.pug\n"),
  (
    "filters-empty.pug", "- var users = [{ name: 'tobi', age: 2 }]\n\nfb:users\n  for user in users\n    fb:user(age=user.age)\n      :cdata\n",
  ),
  (
    "filters.coffeescript.pug", "script(type='text/javascript')\n  :coffee-script\n    regexp = /\\n/\n  :coffee-script(minify=true)\n    math =\n      square: (value) -> value * value\n",
  ),
  (
    "filters.custom.pug", "html\n  body\n    :custom(opt='val' num=2)\n      Line 1\n      Line 2\n\n      Line 4\n",
  ),
  (
    "filters.include.custom.pug", "html\n  body\n    pre\n      include:custom(opt='val' num=2) filters.include.custom.pug\n",
  ),
  (
    "filters.include.pug", "html\n  body\n    include:markdown-it some.md\n    script\n      include:coffee-script(minify=true) include-filter-coffee.coffee\n    script\n      include:coffee-script(minify=false) include-filter-coffee.coffee\n",
  ),
  ("filters.inline.pug", "p before #[:cdata inside] after"),
  (
    "filters.less.pug", "html\n  head\n    style(type=\"text/css\")\n      :less\n        @pad: 15px;\n        body {\n          padding: @pad;\n        }\n",
  ),
  (
    "filters.markdown.pug", "html\n  body\n    :markdown\n      This is _some_ awesome **markdown**\n      whoop.\n",
  ),
  (
    "filters.nested.pug", "script\n  :cdata:uglify-js\n    (function() {\n      console.log('test')\n    })()\nscript\n  :cdata:uglify-js:coffee-script\n    (->\n      console.log 'test'\n    )()\n",
  ),
  (
    "filters.stylus.pug", "html\n  head\n    style(type=\"text/css\")\n      :stylus\n        body\n          padding: 50px\n  body\n",
  ),
  (
    "html.pug", "- var version = 1449104952939\n\n<ul>\n  <li>foo</li>\n  <li>bar</li>\n  <li>baz</li>\n</ul>\n\n<!--build:js /js/app.min.js?v=#{version}-->\n<!--endbuild-->\n\np You can <em>embed</em> html as well.\np: <strong>Even</strong> as the body of a block expansion.\n",
  ),
  (
    "html5.pug", "doctype html\ninput(type='checkbox', checked)\ninput(type='checkbox', checked=true)\ninput(type='checkbox', checked=false)",
  ),
  (
    "include-extends-from-root.pug", "include /auxiliary/extends-from-root.pug\n",
  ),
  (
    "include-extends-of-common-template.pug", "include auxiliary/extends-empty-block-1.pug\ninclude auxiliary/extends-empty-block-2.pug\n",
  ),
  (
    "include-extends-relative.pug", "include ../cases/auxiliary/extends-relative.pug\n",
  ),
  ("include-only-text-body.pug", "| The message is \"\nyield\n| \"\n"),
  (
    "include-only-text.pug", "html\n  body\n    p\n      include include-only-text-body.pug\n        em hello world\n",
  ),
  (
    "include-with-text-head.pug", "head\n  script(type='text/javascript').\n    alert('hello world');\n",
  ),
  (
    "include-with-text.pug", "html\n  include include-with-text-head.pug\n    script(src='/caustic.js')\n    script(src='/app.js')\n",
  ),
  (
    "include.script.pug", "script#pet-template(type='text/x-template')\n  include auxiliary/pet.pug\n",
  ),
  (
    "include.yield.nested.pug", "\ninclude auxiliary/yield-nested.pug\n  p some content\n  p and some more\n",
  ),
  (
    "includes-with-ext-js.pug", "pre\n  code\n    include javascript-new-lines.js\n",
  ),
  (
    "includes.pug", "\ninclude auxiliary/mixins.pug\n\n+foo\n\nbody\n  include auxiliary/smile.html\n  include auxiliary/escapes.html\n  script(type=\"text/javascript\")\n    include:verbatim auxiliary/includable.js\n",
  ),
  (
    "inheritance.alert-dialog.pug", "\nextends auxiliary/dialog.pug\n\nblock content\n  h1 Alert!\n  p I'm an alert!\n",
  ),
  (
    "inheritance.defaults.pug", "html\n  head\n    block head\n      script(src='jquery.js')\n      script(src='keymaster.js')\n      script(src='caustic.js')",
  ),
  (
    "inheritance.extend.include.pug", "\nextend auxiliary/layout.include.pug\n\nblock head\n  script(src='jquery.js')\n\nblock content\n  h2 Page\n  p Some content\n\nblock window-content\n  h2 Awesome\n  p Now we can extend included blocks!\n",
  ),
  (
    "inheritance.extend.mixins.block.pug", "extend auxiliary/inheritance.extend.mixin.block.pug\n\nblock content\n  p Hello World!\n",
  ),
  (
    "inheritance.extend.mixins.pug", "\nextend auxiliary/layout.pug\n\nmixin article(title)\n  if title\n    h1= title\n  block\n\nblock content\n  +article(\"The meaning of life\")\n    p Foo bar baz!\n",
  ),
  (
    "inheritance.extend.pug", "\nextend auxiliary/layout.pug\n\nblock head\n  script(src='jquery.js')\n\nblock content\n  h2 Page\n  p Some content\n",
  ),
  (
    "inheritance.extend.recursive.pug", "extends /auxiliary/inheritance.extend.recursive-parent.pug\n\nblock parent\n    h4 child",
  ),
  (
    "inheritance.extend.whitespace.pug", "\nextend auxiliary/layout.pug\n\nblock head\n\n  script(src='jquery.js')\n\nblock content\n  \n    \n  \n  h2 Page\n  p Some content\n",
  ),
  (
    "inheritance.pug", "\nextends auxiliary/layout.pug\n\nblock head\n  script(src='jquery.js')\n\nblock content\n  h2 Page\n  p Some content\n",
  ),
  (
    "inline-tag.pug", "p bing #[strong foo] bong\n\np.\n  bing\n  #[strong foo]\n  #[strong= '[foo]']\n  #[- var foo = 'foo]']\n  bong\n\np\n  | bing\n  | #[strong foo]\n  | #[strong= '[foo]']\n  | #[- var foo = 'foo]']\n  | bong\n\np.\n  \\#[strong escaped]\n  \\#[#[strong escaped]\n",
  ),
  (
    "intepolated-elements.pug", "p #[a.rho(href='#', class='rho--modifier') with inline link]\np Some text #[a.rho(href='#', class='rho--modifier')]\np Some text #[a.rho(href='#', class='rho--modifier') with inline link]",
  ),
  (
    "interpolated-mixin.pug", "mixin linkit(url)\n  a(href=url)= url\n\np This also works #[+linkit('http://www.bing.com')] so hurrah for Pug",
  ),
  (
    "interpolation.escape.pug", "\n- var id = 42;\nfoo\n  | some\n  | \\#{text}\n  | here\n  | My ID #{\"is {\" + id + \"}\"}",
  ),
  (
    "layout.append.pug", "\nextends ../fixtures/append/app-layout.pug\n\nblock append head\n  script(src='foo.js')\n  script(src='bar.js')\n",
  ),
  (
    "layout.append.without-block.pug", "\nextends ../fixtures/append-without-block/app-layout.pug\n\nappend head\n  script(src='foo.js')\n  script(src='bar.js')\n",
  ),
  (
    "layout.multi.append.prepend.block.pug", "extends ../fixtures/multi-append-prepend-block/redefine.pug\n\nappend content\n\tp.first.append Something appended to content\n\nprepend content\n\tp.first.prepend Something prepended to content\n\nappend content\n\tp.last.append Last append must be most last\n\nprepend content\n\tp.last.prepend Last prepend must appear at top\n\nappend head\n\tscript(src='jquery.js')\n\nprepend head\n\tscript(src='foo.js')\n",
  ),
  (
    "layout.prepend.pug", "\nextends ../fixtures/prepend/app-layout.pug\n\nblock prepend head\n  script(src='foo.js')\n  script(src='bar.js')\n",
  ),
  (
    "layout.prepend.without-block.pug", "\nextends ../fixtures/prepend-without-block/app-layout.pug\n\nprepend head\n  script(src='foo.js')\n  script(src='bar.js')\n",
  ),
  (
    "mixin-at-end-of-file.pug", "include ./auxiliary/mixin-at-end-of-file.pug\n\n+slide()\n  p some awesome content\n",
  ),
  (
    "mixin-block-with-space.pug", "mixin m(id)\n  div\n    block    \n\n+m()\n  | This text should appear",
  ),
  ("mixin-hoist.pug", "\nmixin foo()\n  h1= title\n\nhtml\n  body\n    +foo\n"),
  (
    "mixin-via-include.pug", "//- regression test for https://github.com/pugjs/pug/issues/1435\n\ninclude ../fixtures/mixin-include.pug\n\n+bang",
  ),
  (
    "mixin.attrs.pug", "mixin centered(title)\n  div.centered(id=attributes.id)\n    - if (title)\n      h1(class=attributes.class)= title\n    block\n    - if (attributes.href)\n      .footer\n        a(href=attributes.href) Back\n\nmixin main(title)\n  div.stretch\n    +centered(title).highlight&attributes(attributes)\n      block\n\nmixin bottom\n  div.bottom&attributes(attributes)\n    block\n\nbody\n  +centered#First Hello World\n  +centered('Section 1')#Second\n    p Some important content.\n  +centered('Section 2')#Third.foo(href='menu.html', class='bar')\n    p Even more important content.\n  +main('Section 3')(href='#')\n    p Last content.\n  +bottom.foo(class='bar', name='end', id='Last', data-attr='baz')\n    p Some final words.\n  +bottom(class=['class1', 'class2'])\n\nmixin foo\n  div.thing(attr1='foo', attr2='bar')&attributes(attributes)\n\n- var val = '<biz>'\n- var classes = ['foo', 'bar']\n+foo(attr3='baz' data-foo=val data-bar!=val class=classes).thunk\n\n//- Regression test for #1424\nmixin work_filmstrip_item(work)\n  div&attributes(attributes)= work\n+work_filmstrip_item('work')(\"data-profile\"='profile', \"data-creator-name\"='name')\n\nmixin my-mixin(arg1, arg2, arg3, arg4)\n  p= arg1\n  p= arg2\n  p= arg3\n  p= arg4\n\n+foo(\n  attr3=\"qux\"\n  class=\"baz\"\n)\n\n+my-mixin(\n'1',\n      '2',\n  '3',\n      '4'\n)\n",
  ),
  (
    "mixin.block-tag-behaviour.pug", "\nmixin article(name)\n  section.article\n    h1= name\n    block\n\nhtml\n  body\n    +article('Foo'): p I'm article foo\n\nmixin article(name)\n  section.article\n    h1= name\n    p\n      block\n\nhtml\n  body\n    +article('Something').\n      I'm a much longer\n      text-only article,\n      but you can still\n      inline html tags\n      in me if you want.",
  ),
  (
    "mixin.blocks.pug", "\n\nmixin form(method, action)\n  form(method=method, action=action)\n    - var csrf_token_from_somewhere = 'hey'\n    input(type='hidden', name='_csrf', value=csrf_token_from_somewhere)\n    block\n\nhtml\n  body\n    +form('GET', '/search')\n      input(type='text', name='query', placeholder='Search')\n      input(type='submit', value='Search')\n\nhtml\n  body\n    +form('POST', '/search')\n      input(type='text', name='query', placeholder='Search')\n      input(type='submit', value='Search')\n\nhtml\n  body\n    +form('POST', '/search')\n\nmixin bar()\n  #bar\n    block\n\nmixin foo()\n  #foo\n    +bar\n      block\n\n+foo\n  p one\n  p two\n  p three\n\n\nmixin baz\n    #baz\n        block\n\n+baz()= '123'",
  ),
  (
    "mixin.merge.pug", "mixin foo\n  p.bar&attributes(attributes) One\n  p.baz.quux&attributes(attributes) Two\n  p&attributes(attributes) Three\n  p.bar&attributes(attributes)(class=\"baz\") Four\n\nbody\n  +foo.hello\n  +foo#world\n  +foo.hello#world\n  +foo.hello.world\n  +foo(class=\"hello\")\n  +foo.hello(class=\"world\")\n  +foo\n  +foo&attributes({class: \"hello\"})",
  ),
  (
    "mixins-unused.pug", "mixin never-called\n  .wtf This isn't something we ever want to output\nbody",
  ),
  (
    "mixins.pug", "mixin comment(title, str)\n  .comment\n    h2= title\n    p.body= str\n\n\nmixin comment (title, str)\n  .comment\n    h2= title\n    p.body= str\n\n#user\n  h1 Tobi\n  .comments\n    +comment('This',\n            (('is regular, javascript')))\n\nmixin list\n  ul\n    li foo\n    li bar\n    li baz\n\nbody\n  +list()\n  + list()\n\nmixin foobar(str)\n  div#interpolation= str + 'interpolated'\n\n- var suffix = \"bar\"\n+#{'foo' + suffix}('This is ')\n",
  ),
  (
    "mixins.rest-args.pug", "mixin list(tag, ...items)\n  #{tag}\n    each item in items\n      li= item\n\n+list('ul', 1, 2, 3, 4)\n",
  ),
  ("namespaces.pug", "fb:user:role Something\nfoo(fb:foo='bar')"),
  (
    "nesting.pug", "ul\n  li a\n  li b\n  li\n    ul\n        li c\n        li d\n  li e",
  ),
  ("pipeless-comments.pug", "//\n       .foo\n  \t.bar\n  .hey\n"),
  ("pipeless-filters.pug", ":markdown-it\n      code sample\n\n  # Heading\n"),
  ("pipeless-tag.pug", "pre.\n    what\n  is #{'going'} #[| #{'on'}]\n"),
  (
    "pre.pug", "pre.\n  foo\n  bar\n  baz\n\npre\n  code.\n    foo\n    bar\n    baz",
  ),
  ("quotes.pug", "p \"foo\"\np 'foo'"),
  (
    "regression.1794.pug", "extends ./auxiliary/1794-extends.pug\n \nblock content\n  include ./auxiliary/1794-include.pug",
  ),
  (
    "regression.784.pug", "- var url = 'http://www.google.com'\n.url #{url.replace('http://', '').replace(/^www\\./, '')}",
  ),
  ("script.whitespace.pug", "script.\n  if (foo) {\n    \n    bar();\n  \n  }"),
  (
    "scripts.non-js.pug", "script#user-template(type='text/template')\n  #user\n    h1 <%= user.name %>\n    p <%= user.description %>\n\nscript#user-template(type='text/template').\n  if (foo) {\n    bar();\n  }",
  ),
  (
    "scripts.pug", "script.\n  if (foo) {\n    bar();\n  }\nscript!= 'foo()'\nscript foo()\nscript\ndiv",
  ),
  ("self-closing-html.pug", "doctype html\nhtml\n  body\n    br/\n"),
  ("single-period.pug", "span ."),
  ("some.md", "Just _some_ markdown **tests**.\n\nWith new line.\n"),
  (
    "source.pug", "html\n  audio(preload='auto', autobuffer, controls)\n    source(src='foo')\n    source(src='bar')",
  ),
  (
    "styles.pug", "html\n  head\n    style.\n      body {\n        padding: 50px;\n      }\n  body\n    div(style='color:red;background:green')\n    div(style={color: 'red', background: 'green'})\n    div&attributes({style: 'color:red;background:green'})\n    div&attributes({style: {color: 'red', background: 'green'}})\n    mixin div()\n      div&attributes(attributes)\n    +div(style='color:red;background:green')\n    +div(style={color: 'red', background: 'green'})\n    - var bg = 'green';\n    div(style={color: 'red', background: bg})\n    div&attributes({style: {color: 'red', background: bg}})\n    +div(style={color: 'red', background: bg})\n",
  ),
  (
    "tag.interpolation.pug", "\n- var tag = 'p'\n- var foo = 'bar'\n\n#{tag} value\n#{tag}(foo='bar') value\n#{foo ? 'a' : 'li'}(something) here\n\nmixin item(icon)\n  li\n    if attributes.href\n      a&attributes(attributes)\n        img.icon(src=icon)\n        block\n    else\n      span&attributes(attributes)\n        img.icon(src=icon)\n        block\n\nul\n  +item('contact') Contact\n  +item(href='/contact') Contact\n",
  ),
  (
    "tags.self-closing.pug", "\nbody\n  foo\n  foo(bar='baz')\n  foo/\n  foo(bar='baz')/\n  foo /\n  foo(bar='baz') /\n  #{'foo'}/\n  #{'foo'}(bar='baz')/\n  #{'foo'} /\n  #{'foo'}(bar='baz') /\n  //- can have a single space after them\n  img \n  //- can have lots of white space after them\n  img    \n  #{\n    'foo'\n  }/\n",
  ),
  (
    "template.pug", "script(type='text/x-template')\n  article\n    h2 {{title}}\n    p {{description}}\n\nscript(type='text/x-template').\n  article\n    h2 {{title}}\n    p {{description}}\n",
  ),
  (
    "text-block.pug", "\nlabel Username:\n  input(type='text', name='user[name]')\n\nlabel Password:\n  input(type='text', name='user[pass]')",
  ),
  (
    "text.pug", "option(value='') -- (selected) --\n\np\n\np.\n\np\n  | foo\n  | bar\n  |\n  |\n  | baz\n\np.\n  foo\n\n\n  bar\n  baz\n\n.\n\n.\n  foo\n\n\n  bar\n  baz\n\npre\n  | foo\n  |   bar\n  |     baz\n  | .\n\npre.\n  foo\n    bar\n      baz\n  .\n\n.\n  foo\n    bar\n      baz\n  .\n",
  ),
  ("utf8bom.pug", "﻿p \"foo\"\n"),
  ("vars.pug", "- var foo = 'bar'\n- var list = [1,2,3]\na(class=list, id=foo)"),
  ("while.pug", "- var x = 1;\nul\n  while x < 10\n    - x++;\n    li= x\n"),
  (
    "xml.pug", "doctype xml\ncategory(term='some term')/\nlink http://google.com",
  ),
  (
    "yield-before-conditional-head.pug", "head\n  script(src='/jquery.js')\n  yield\n  if false\n    script(src='/jquery.ui.js')\n",
  ),
  (
    "yield-before-conditional.pug", "html\n  body\n    include yield-before-conditional-head.pug\n      script(src='/caustic.js')\n      script(src='/app.js')\n",
  ),
  (
    "yield-head.pug", "head\n  script(src='/jquery.js')\n  yield\n  script(src='/jquery.ui.js')\n",
  ),
  (
    "yield-title-head.pug", "head\n  title\n    yield\n  script(src='/jquery.js')\n  script(src='/jquery.ui.js')\n",
  ),
  (
    "yield-title.pug", "html\n  body\n    include yield-title-head.pug\n      | My Title\n",
  ),
  (
    "yield.pug", "html\n  body\n    include yield-head.pug\n      script(src='/caustic.js')\n      script(src='/app.js')\n",
  ),
])

///|
test "pug attrs.unescaped" {
  pug(
    "attrs.unescaped.pug", "<script type=\"text/x-template\"><div id=\"user-<%= user.id %>\"><h1><%= user.title %></h1></div></script>",
  )
}

///|
test "pug basic" {
  pug("basic.pug", "<html><body><h1>Title</h1></body></html>")
}

///|
test "pug blanks" {
  pug("blanks.pug", "<ul><li>foo</li><li>bar</li><li>baz</li></ul>")
}

///|
test "pug block-expansion" {
  pug(
    "block-expansion.pug", "<ul><li><a href=\"#\">foo</a></li><li><a href=\"#\">bar</a></li></ul><p>baz</p>",
  )
}

///|
test "pug block-expansion.shorthands" {
  pug(
    "block-expansion.shorthands.pug", "<ul><li class=\"list-item\"><div class=\"foo\"><div id=\"bar\">baz</div></div></li></ul>",
  )
}

///|
test "pug blockquote" {
  pug(
    "blockquote.pug", "<figure><blockquote>Try to define yourself by what you do, and you&#8217;ll burnout every time. You are. That is enough. I rest in that.</blockquote><figcaption>from @thefray at 1:43pm on May 10</figcaption></figure>",
  )
}

///|
test "pug blocks-in-blocks" {
  pug(
    "blocks-in-blocks.pug", "<!DOCTYPE html><html><head><title>Default title</title></head><body><h1>Page 2</h1></body></html>",
  )
}

///|
test "pug classes-empty" {
  pug("classes-empty.pug", "<a></a><a></a><a></a>")
}

///|
test "pug code.escape" {
  pug("code.escape.pug", "<p>&lt;script&gt;</p><p><script></p>")
}

///|
test "pug comments" {
  pug(
    "comments.pug", "<!-- foo--><ul><!-- bar--><li>one</li><!-- baz--><li>two</li></ul><!--ul\n  li foo\n--><!-- block// inline follow\nli three\n--><!-- block// inline followed by tags\nul\n  li four\n--><!--if IE lt 9// inline\nscript(src='/lame.js')\n// end-inline\n--><p>five</p><div class=\"foo\">// not a comment</div>",
  )
}

///|
test "pug comments.source" {
  pug("comments.source.pug", "")
}

///|
test "pug doctype.custom" {
  pug("doctype.custom.pug", "<!DOCTYPE custom stuff>")
}

///|
test "pug doctype.default" {
  pug(
    "doctype.default.pug", "<!DOCTYPE html><html><body><h1>Title</h1></body></html>",
  )
}

///|
test "pug doctype.keyword" {
  pug("doctype.keyword.pug", "<!DOCTYPE html>")
}

///|
test "pug escaping-class-attribute" {
  pug(
    "escaping-class-attribute.pug", "<foo attr=\"&lt;%= bar %&gt;\"></foo><foo class=\"&lt;%= bar %&gt;\"></foo><foo attr=\"<%= bar %>\"></foo><foo class=\"<%= bar %>\"></foo><foo class=\"<%= bar %> lol rofl\"></foo><foo class=\"<%= bar %> lol rofl <%= lmao %>\"></foo>",
  )
}

///|
test "pug html5" {
  pug(
    "html5.pug", "<!DOCTYPE html><input type=\"checkbox\" checked><input type=\"checkbox\" checked><input type=\"checkbox\">",
  )
}

///|
test "pug include-extends-from-root" {
  pug(
    "include-extends-from-root.pug", "<html><head><title>My Application</title></head><body><h1>hello</h1></body></html>",
  )
}

///|
test "pug include-extends-of-common-template" {
  pug(
    "include-extends-of-common-template.pug", "<div>test1</div><div>test2</div>",
  )
}

///|
test "pug include-only-text-body" {
  pug("include-only-text-body.pug", "The message is \"\"")
}

///|
test "pug include-only-text" {
  pug(
    "include-only-text.pug", "<html><body><p>The message is \"<em>hello world</em>\"</p></body></html>",
  )
}

///|
test "pug include-with-text-head" {
  pug(
    "include-with-text-head.pug", "<head><script type=\"text/javascript\">alert('hello world');</script></head>",
  )
}

///|
test "pug include-with-text" {
  pug(
    "include-with-text.pug", "<html><head><script type=\"text/javascript\">alert('hello world');</script><script src=\"/caustic.js\"></script><script src=\"/app.js\"></script></head></html>",
  )
}

///|
test "pug include.yield.nested" {
  pug(
    "include.yield.nested.pug", "<html><head><title></title></head><body><h1>Page</h1><div id=\"content\"><div id=\"content-wrapper\"><p>some content</p><p>and some more</p></div></div><div id=\"footer\"><stuff></stuff></div></body></html>",
  )
}

///|
test "pug inheritance.alert-dialog" {
  pug(
    "inheritance.alert-dialog.pug", "<div class=\"window\"><a class=\"close\" href=\"#\">Close</a><div class=\"dialog\"><h1>Alert!</h1><p>I'm an alert!</p></div></div>",
  )
}

///|
test "pug inheritance.defaults" {
  pug(
    "inheritance.defaults.pug", "<html><head><script src=\"jquery.js\"></script><script src=\"keymaster.js\"></script><script src=\"caustic.js\"></script></head></html>",
  )
}

///|
test "pug inheritance.extend.include" {
  pug(
    "inheritance.extend.include.pug", "<html><head><title>My Application</title><script src=\"jquery.js\"></script></head><body><h2>Page</h2><p>Some content</p><div class=\"window\"><a class=\"close\" href=\"#\">Close</a><h2>Awesome</h2><p>Now we can extend included blocks!</p></div></body></html>",
  )
}

///|
test "pug inheritance.extend.mixins.block" {
  pug(
    "inheritance.extend.mixins.block.pug", "<html><head><title>My Application</title></head><body><article><p>Hello World!</p></article></body></html>",
  )
}

///|
test "pug inheritance.extend.mixins" {
  pug(
    "inheritance.extend.mixins.pug", "<html><head><title>My Application</title></head><body><h1>The meaning of life</h1><p>Foo bar baz!</p></body></html>",
  )
}

///|
test "pug inheritance.extend" {
  pug(
    "inheritance.extend.pug", "<html><head><title>My Application</title><script src=\"jquery.js\"></script></head><body><h2>Page</h2><p>Some content</p></body></html>",
  )
}

///|
test "pug inheritance.extend.recursive" {
  pug(
    "inheritance.extend.recursive.pug", "<h1>grand-grandparent</h1><h2>grandparent</h2><h3>parent</h3><h4>child</h4>",
  )
}

///|
test "pug inheritance.extend.whitespace" {
  pug(
    "inheritance.extend.whitespace.pug", "<html><head><title>My Application</title><script src=\"jquery.js\"></script></head><body><h2>Page</h2><p>Some content</p></body></html>",
  )
}

///|
test "pug inheritance" {
  pug(
    "inheritance.pug", "<html><head><title>My Application</title><script src=\"jquery.js\"></script></head><body><h2>Page</h2><p>Some content</p></body></html>",
  )
}

///|
test "pug intepolated-elements" {
  pug(
    "intepolated-elements.pug", "<p><a class=\"rho rho--modifier\" href=\"#\">with inline link</a></p><p>Some text <a class=\"rho rho--modifier\" href=\"#\"></a></p><p>Some text <a class=\"rho rho--modifier\" href=\"#\">with inline link</a></p>",
  )
}

///|
test "pug interpolated-mixin" {
  pug(
    "interpolated-mixin.pug", "<p>This also works <a href=\"http://www.bing.com\">http://www.bing.com</a> so hurrah for Pug</p>",
  )
}

///|
test "pug mixin-at-end-of-file" {
  pug(
    "mixin-at-end-of-file.pug", "<section class=\"slide\"><p>some awesome content</p></section>",
  )
}

///|
test "pug mixin-block-with-space" {
  pug("mixin-block-with-space.pug", "<div>This text should appear</div>")
}

///|
test "pug mixin-hoist" {
  pug("mixin-hoist.pug", "<html><body><h1></h1></body></html>")
}

///|
test "pug mixin.block-tag-behaviour" {
  pug(
    "mixin.block-tag-behaviour.pug", "<html><body><section class=\"article\"><h1>Foo</h1><p>I'm article foo</p></section></body></html><html><body><section class=\"article\"><h1>Something</h1><p>I'm a much longer\ntext-only article,\nbut you can still\ninline html tags\nin me if you want.</p></section></body></html>",
  )
}

///|
test "pug mixins-unused" {
  pug("mixins-unused.pug", "<body></body>")
}

///|
test "pug mixins.rest-args" {
  pug(
    "mixins.rest-args.pug", "<ul><li>1</li><li>2</li><li>3</li><li>4</li></ul>",
  )
}

///|
test "pug namespaces" {
  pug(
    "namespaces.pug", "<fb:user:role>Something</fb:user:role><foo fb:foo=\"bar\"></foo>",
  )
}

///|
test "pug nesting" {
  pug(
    "nesting.pug", "<ul><li>a</li><li>b</li><li><ul><li>c</li><li>d</li></ul></li><li>e</li></ul>",
  )
}

///|
test "pug pipeless-comments" {
  pug("pipeless-comments.pug", "<!--     .foo\n\t.bar\n.hey-->")
}

///|
test "pug pipeless-tag" {
  pug("pipeless-tag.pug", "<pre>  what\nis going on</pre>")
}

///|
test "pug pre" {
  pug(
    "pre.pug", "<pre>foo\nbar\nbaz\n</pre><pre><code>foo\nbar\nbaz</code></pre>",
  )
}

///|
test "pug quotes" {
  pug("quotes.pug", "<p>\"foo\"</p><p>'foo'</p>")
}

///|
test "pug regression.1794" {
  pug("regression.1794.pug", "<div class=\"test\"></div>")
}

///|
test "pug script.whitespace" {
  pug("script.whitespace.pug", "<script>if (foo) {\n  \n  bar();\n\n}</script>")
}

///|
test "pug scripts.non-js" {
  pug(
    "scripts.non-js.pug", "<script id=\"user-template\" type=\"text/template\"><div id=\"user\"><h1><%= user.name %></h1><p><%= user.description %></p></div></script><script id=\"user-template\" type=\"text/template\">if (foo) {\n  bar();\n}</script>",
  )
}

///|
test "pug scripts" {
  pug(
    "scripts.pug", "<script>if (foo) {\n  bar();\n}</script><script>foo()</script><script>foo()</script><script></script><div></div>",
  )
}

///|
test "pug self-closing-html" {
  pug("self-closing-html.pug", "<!DOCTYPE html><html><body><br/></body></html>")
}

///|
test "pug single-period" {
  pug("single-period.pug", "<span>.</span>")
}

///|
test "pug source" {
  pug(
    "source.pug", "<html><audio preload=\"auto\" autobuffer=\"autobuffer\" controls=\"controls\"><source src=\"foo\"/><source src=\"bar\"/></audio></html>",
  )
}

///|
test "pug tags.self-closing" {
  pug(
    "tags.self-closing.pug", "<body><foo></foo><foo bar=\"baz\"></foo><foo/><foo bar=\"baz\"/><foo>/</foo><foo bar=\"baz\">/</foo><foo/><foo bar=\"baz\"/><foo>/</foo><foo bar=\"baz\">/</foo><img/><img/><foo/></body>",
  )
}

///|
test "pug text-block" {
  pug(
    "text-block.pug", "<label>Username:<input type=\"text\" name=\"user[name]\"/></label><label>Password:<input type=\"text\" name=\"user[pass]\"/></label>",
  )
}

///|
test "pug text" {
  pug(
    "text.pug", "<option value=\"\">-- (selected) --</option><p></p><p></p><p>foo\nbar\n\n\nbaz</p><p>foo\n\n\nbar\nbaz\n</p>foo\n\n\nbar\nbaz\n<pre>foo\n  bar\n    baz\n.</pre><pre>foo\n  bar\n    baz\n.\n</pre>foo\n  bar\n    baz\n.",
  )
}

///|
test "pug utf8bom" {
  pug("utf8bom.pug", "<p>\"foo\"</p>")
}

///|
test "pug xml" {
  pug(
    "xml.pug", "<?xml version=\"1.0\" encoding=\"utf-8\" ?><category term=\"some term\"/><link>http://google.com</link>",
  )
}

///|
test "pug yield-before-conditional-head" {
  pug(
    "yield-before-conditional-head.pug", "<head><script src=\"/jquery.js\"></script></head>",
  )
}

///|
test "pug yield-before-conditional" {
  pug(
    "yield-before-conditional.pug", "<html><body><head><script src=\"/jquery.js\"></script><script src=\"/caustic.js\"></script><script src=\"/app.js\"></script></head></body></html>",
  )
}

///|
test "pug yield-head" {
  pug(
    "yield-head.pug", "<head><script src=\"/jquery.js\"></script><script src=\"/jquery.ui.js\"></script></head>",
  )
}

///|
test "pug yield-title-head" {
  pug(
    "yield-title-head.pug", "<head><title></title><script src=\"/jquery.js\"></script><script src=\"/jquery.ui.js\"></script></head>",
  )
}

///|
test "pug yield-title" {
  pug(
    "yield-title.pug", "<html><body><head><title>My Title</title><script src=\"/jquery.js\"></script><script src=\"/jquery.ui.js\"></script></head></body></html>",
  )
}

///|
test "pug yield" {
  pug(
    "yield.pug", "<html><body><head><script src=\"/jquery.js\"></script><script src=\"/caustic.js\"></script><script src=\"/app.js\"></script><script src=\"/jquery.ui.js\"></script></head></body></html>",
  )
}
