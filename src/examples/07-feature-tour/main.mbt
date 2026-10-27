///|
/// A tour through the built-ins, grouped by what they work on. Each block is
/// rendered on its own so the output reads top to bottom; the point is to show
/// the shape of the language and the breadth of what ships, not to build
/// anything in particular. Redundancy here is on purpose.
let text_src =
  #|<p>{{ "hello WORLD"|capitalize }}</p>
  #|<p>{{ "a-b-c"|replace("-", " ") }}</p>
  #|<p>{{ "  spaced  "|trim }}</p>
  #|<p>{{ "a long sentence about the weather"|truncate(20) }}</p>
  #|<p>{{ "one two three four five"|wordwrap(10) }}</p>
  #|<p>{{ "hi"|center(10) }}</p>
  #|<p>{{ "<b>hi</b>"|striptags }}</p>
  #|<p>{{ "<a href=\"x\">link</a>"|urlize }}</p>
  #|<p>{{ "a<b>"|e }}</p>

let numbers_src =
  #|<p>{{ 3.14159|round(2) }}</p>
  #|<p>{{ "3.14"|float }}</p>
  #|<p>{{ 1234567|filesizeformat }}</p>
  #|<p>{{ [3, 1, 2]|sort|list }}</p>
  #|<p>{{ [1, 2, 3, 4]|sum }}</p>
  #|<p>{{ [1, 2, 3, 4, 5]|batch(2)|list }}</p>
  #|<p>{{ [1, 2, 3, 4, 5]|slice(2)|list }}</p>
  #|<p>{{ [1, 2, 2, 3]|unique|list }}</p>
  #|<p>{{ [1, 2, 3]|random }}</p>
  #|<p>{{ {"b": 2, "a": 1}|dictsort|list }}</p>

let lists_src =
  #|<p>{{ users|map(attribute="name")|join(", ") }}</p>
  #|<p>{{ items|selectattr("shown")|list }}</p>
  #|<p>{{ users|groupby("kind")|map(attribute="grouper")|join(", ") }}</p>
  #|<p>{{ [1, 2, 3, 4]|reject("odd")|list }}</p>
  #|<p>{{ [1, 2, 3, 4]|first }} {{ [1, 2, 3, 4]|last }} {{ [1, 2, 3, 4]|length }}</p>
  #|<p>{{ [1, 2, 3]|reverse|list }}</p>
  #|<p>{{ {"a": 1}|tojson }}</p>
  #|<p>{{ {"q": "a b"}|urlencode }}</p>
  #|<p>{{ {"class": "x", "id": 5}|xmlattr }}</p>

let choose_src =
  #|<p>{{ missing|default("none") }}</p>
  #|<p>{% set ns = namespace(total=0) %}{% for i in [1, 2, 3] %}{% set ns.total = ns.total + i %}{% endfor %}{{ ns.total }}</p>
  #|<p>{% if 9 is divisibleby(3) %}yes{% else %}no{% endif %}</p>
  #|<p>{% set c = cycler("odd", "even") %}{{ c.next() }}{{ c.next() }}{{ c.next() }}</p>
  #|<p>{% set j = joiner(", ") %}{% for x in ["a", "b", "c"] %}{{ j() }}{{ x }}{% endfor %}</p>
  #|<p>{{ ok|yesno }} · {{ count|pluralize }}</p>

let dates_src =
  #|<p>{{ d|date("Y-m-d") }}</p>
  #|<p>{{ d|timesince(now) }}</p>

let tests_src =
  #|<p>{{ 4 is even }} {{ 9 is divisibleby(3) }} {{ "ab" is iterable }}</p>
  #|<p>{{ [1, 2] is sequence }} {{ range is callable }} {{ ("<b>"|safe) is escaped }}</p>
  #|<p>{% set present = 1 %}{{ present is defined }} {{ missing is undefined }}</p>
  #|<p>{{ 7 is number }} {{ "x" is string }} {{ {"a": 1} is mapping }}</p>
  #|<p>{{ 3 is integer }} {{ 3.0 is float }} {{ none is none }} {{ true is boolean }}</p>
  #|<p>{{ "abc" is lower }} {{ "ABC" is upper }} {{ a is sameas a }}</p>

let globals_src =
  #|<p>{{ range(1, 4)|list }} {{ range(0, 10, 2)|list }}</p>
  #|<p>{{ dict(a=1, b=2)|items|list }}</p>
  #|<p>{{ gettext("Hello") }} {{ _("World") }}</p>
  #|<p>{{ lipsum(n=1, min=5, max=8) }}</p>

let statements_src =
  #|<p>{% for b in books|sort(attribute='year') %}{{ loop.index }}. {{ b.title }}{% if not loop.last %}; {% endif %}{% endfor %}</p>
  #|<p>{% macro field(name, value='') %}<input name="{{ name }}" value="{{ value }}">{% endmacro %}{{ field('email') }}</p>
  #|<p>{% filter upper %}shouted{% endfilter %}</p>
  #|<p>{% with total = 3 %}{{ total }}{% endwith %}</p>
  #|<p>{% set total = [1, 2, 3]|sum %}{{ total }}</p>

///|
/// Render one section and print it under a heading.
fn show(title : String, source : String, data : Json) -> Unit {
  println("## " + title)
  try {
    println(@moonpug.render(source, data))
  } catch {
    e => println("refused: \{e}")
  }
  println("")
}

///|
fn main {
  try {
    show("Text", text_src, @json.parse("{}"))
    show("Numbers", numbers_src, @json.parse("{}"))
    show(
      "Lists and maps",
      lists_src,
      @json.parse(
        "{\"users\":[{\"name\":\"Ada\",\"kind\":\"a\"},{\"name\":\"Grace\",\"kind\":\"b\"},{\"name\":\"Alan\",\"kind\":\"a\"}],\"items\":[{\"shown\":true},{\"shown\":false}]}",
      ),
    )
    show("Choosing a value", choose_src, @json.parse("{\"ok\":true,\"count\":3}"))
    show(
      "Dates",
      dates_src,
      @json.parse("{\"d\":\"2026-01-01\",\"now\":\"2026-05-04\"}"),
    )
    show("Tests", tests_src, @json.parse("{}"))
    show("Globals", globals_src, @json.parse("{}"))
    show(
      "Statements",
      statements_src,
      @json.parse(
        "{\"books\":[{\"title\":\"Dune\",\"year\":1965},{\"title\":\"The Hobbit\",\"year\":1937}]}",
      ),
    )
  } catch {
    e => println("refused: \{e}")
  }
}
