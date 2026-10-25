///|
/// A shopping cart the template can read, loop over and change.
struct Cart {
  items : Array[(String, Int32)]
  mut coupon : String
}

///|
impl @moonpug.Object for Cart with fn kind(_) {
  "the cart"
}

///|
impl @moonpug.Object for Cart with fn attr(self, name) {
  match name {
    "total" => Some(Int(self.items.fold(init=0, (s, p) => s + p.1).to_int64()))
    "coupon" => Some(Text(self.coupon))
    _ => None
  }
}

///|
impl @moonpug.Object for Cart with fn items(self) {
  Some(
    self.items.map(p => @moonpug.Value::Tuple([Text(p.0), Int(p.1.to_int64())])),
  )
}

///|
impl @moonpug.Object for Cart with fn assign(self, name, value) {
  match (name, value) {
    ("coupon", Text(code)) => self.coupon = code
    _ => raise @moonpug.invalid("the cart has no field \{name} to set")
  }
}

///|
fn main {
  let env = @moonpug.Env::new()
  env.add_filter("money", (call, value, _, _) => Text("¥" + call.text(value)))
  env.add_global(
    "today",
    @moonpug.Value::func("today", (_, _, _) => Text("2026-10-25")),
  )
  let cart = Cart::{ items: [("ink", 12), ("paper", 30)], coupon: "", }
  let source =
    #|{% for name, price in cart %}{{ name }} {{ price|money }}; {% endfor %}
    #|total {{ cart.total|money }} on {{ today() }}
    #|{% set cart.coupon = 'AUTUMN' %}coupon {{ cart.coupon }}
  println(env.compile(source).render_values({ "cart": Object(cart) })) catch {
    e => println("refused: \{e}")
  }
}
