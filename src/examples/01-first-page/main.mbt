///|
struct Book {
  title : String
  author : String
  year : Int32
  tags : Array[String]
} derive(ToJson)

///|
struct Shelf {
  shelf : String
  books : Array[Book]
} derive(ToJson)

///|
fn main {
  let books = [
    Book::{
      title: "The Hobbit",
      author: "Tolkien",
      year: 1937,
      tags: ["fantasy"],
    },
    Book::{
      title: "Dune",
      author: "Herbert",
      year: 1965,
      tags: ["science fiction", "classic"],
    },
  ]
  let page =
    #|<h1>{{ shelf }}</h1>
    #|<ul>
    #|{% for b in books|sort(attribute='year') %}
    #|  <li>{{ b.title }} · {{ b.author }}, {{ b.year }}{% if b.tags %} ({{ b.tags|join(', ') }}){% endif %}</li>
    #|{% endfor %}
    #|</ul>
  let out = @moonpug.render(page, Shelf::{ shelf: "Reading <list>", books, }) catch {
    e => "refused: \{e}"
  }
  println(out)
}
