///|
/// A host object with every method of the protocol.
struct Counter {
  mut count : Int32
  label : String
}

///|
impl @moonpug.Object for Counter with fn kind(_) {
  "a counter"
}

///|
impl @moonpug.Object for Counter with fn attr(self, name) {
  match name {
    "count" => Some(Int(self.count.to_int64()))
    "label" => Some(Text(self.label))
    _ => None
  }
}

///|
impl @moonpug.Object for Counter with fn call(self, _, args, named) {
  let step = match (args, named.get("by")) {
    ([Int(n)], _) | ([], Some(Int(n))) => n.to_int()
    _ => 1
  }
  self.count += step
  Int(self.count.to_int64())
}

///|
impl @moonpug.Object for Counter with fn callable(_) {
  true
}

///|
impl @moonpug.Object for Counter with fn assign(self, name, value) {
  match (name, value) {
    ("count", Int(n)) => self.count = n.to_int()
    _ => raise @moonpug.invalid("a counter has no field \{name}")
  }
}

///|
impl @moonpug.Object for Counter with fn show(self) {
  "<\{self.label}: \{self.count}>"
}

///|
impl @moonpug.Object for Counter with fn items(self) {
  Some(Array::makei(self.count, i => @moonpug.Value::Int(i.to_int64())))
}

///|
/// An object with only a kind: every other method keeps its default.
struct Opaque {}

///|
impl @moonpug.Object for Opaque with fn kind(_) {
  "an opaque thing"
}

///|
fn render_with(source : String, values : Map[String, @moonpug.Value]) -> String {
  @moonpug.Env::new().compile(source).render_values(values) catch {
    e => "refused: \{e}"
  }
}

///|
test "a host object answers attributes, calls, assignments, printing and loops" {
  let values : Map[String, @moonpug.Value] = Map([
    ("c", Object(Counter::{ count: 2, label: "hits", })),
  ])
  assert_eq(
    render_with(
      "{{ c.label }} {{ c.count }} {{ c() }} {{ c(3) }} {{ c(by=2) }} {{ c }}", values,
    ),
    "hits 2 3 6 8 &lt;hits: 8&gt;",
  )
  assert_eq(
    render_with(
      "{% set c.count = 2 %}{% for i in c %}{{ i }}{% endfor %}|{{ c|list }}", values,
    ),
    "01|[0, 1]",
  )
  assert_eq(
    render_with(
      "{{ c is callable }} {{ c.missing is defined }} {{ c|length }}", values,
    ),
    "True False 2",
  )
  assert_eq(
    render_with("{% set c.label = 'x' %}", values),
    "refused: <template>:1: a counter has no field label",
  )
}

///|
test "an object keeps the defaults it does not implement" {
  let values : Map[String, @moonpug.Value] = Map([("o", Object(Opaque::{ }))])
  assert_eq(
    render_with("{{ o }}|{{ o is callable }}|{{ o.x is defined }}", values),
    "&lt;an opaque thing&gt;|False|False",
  )
  assert_eq(
    render_with("{{ o() }}", values),
    "refused: <template>:1: an opaque thing cannot be called",
  )
  assert_eq(
    render_with("{% set o.x = 1 %}", values),
    "refused: <template>:1: an opaque thing does not take assignments to x",
  )
  assert_eq(
    render_with("{% for x in o %}{% endfor %}", values),
    "refused: <template>:1: an opaque thing cannot be iterated",
  )
}

///|
test "functions, filters and tests registered on the environment" {
  let env = @moonpug.Env::new()
  env.add_global(
    "greet",
    @moonpug.Value::func("greet", (_, args, named) => {
      let who = match args {
        [Text(s)] => s
        _ => "you"
      }
      let mark = match named.get("mark") {
        Some(Text(m)) => m
        _ => "!"
      }
      Text("hi " + who + mark)
    }),
  )
  env.add_global("site", Text("moon"))
  env.add_filter("twice", (call, value, _, _) => {
    Text(call.text(value) + call.text(value))
  })
  env.add_test("short", (call, value, args) => {
    let limit = match args {
      [Int(n)] => n.to_int()
      _ => 3
    }
    call.text(value).length() <= limit
  })
  env.add_filter("upper", (_, _, _, _) => Text("replaced"))
  let t = env.compile(
    "{{ greet() }} {{ greet('Ann', mark='?') }} {{ site|twice }} {{ 'ab' is short }} {{ 'abcd' is short(5) }} {{ 'x'|upper }} {{ greet }}",
  )
  assert_eq(
    t.render(Json::object(Map([]))),
    "hi you! hi Ann? moonmoon True True replaced &lt;function greet&gt;",
  )
  assert_eq(t.name(), "<template>")
}

///|
test "a function's refusal is placed where it was called" {
  let env = @moonpug.Env::new()
  env.add_global(
    "boom",
    @moonpug.Value::func("boom", (_, _, _) => raise @moonpug.invalid("went off")),
  )
  let t = env.compile("ok\n{{ boom() }}", name="page.html")
  let got = t.render(Json::object(Map([]))) catch { e => "refused: \{e}" }
  assert_eq(got, "refused: page.html:2: went off")
}

///|
struct Item {
  name : String
  price : Double
  tags : Array[String]
} derive(ToJson)

///|
test "data carries through Json and through values" {
  let page = @moonpug.render(
    "{% for i in items %}{{ i.name }}={{ i.price }}{{ i.tags|join('/') }};{% endfor %}",
    { "items": Json([Item::{ name: "a", price: 1.5, tags: ["x", "y"], }]) },
  )
  assert_eq(page, "a=1.5x/y;")
  let v = @moonpug.Value::of_json(
    @json.parse("{\"n\": [1, 2.5, \"s\", null, true]}"),
  )
  inspect(v.repr(), content="{'n': [1, 2.5, 's', None, True]}")
  inspect(Json(v).stringify(), content="{\"n\":[1,2.5,\"s\",null,true]}")
}
