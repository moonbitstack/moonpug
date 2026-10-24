///|
test "probe if variants" {
  let a = render("if ok\n  p yes", @json.parse("{ \"ok\": true }"), syntax=Pug) catch {
    f => "F:" + f.to_string()
  }
  println("A=" + a)
  let b = render(
    "if ok\n  p yes\nelse\n  p no",
    @json.parse("{ \"ok\": false }"),
    syntax=Pug,
  ) catch {
    f => "F:" + f.to_string()
  }
  println("B=" + b)
}
