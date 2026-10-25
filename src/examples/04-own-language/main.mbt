///|
/// A language of one's own: `csv` turns each line into a table row and
/// reads every cell as the brace syntax, so `{{ }}` works inside cells.
fn read_csv(
  source : String,
  reading : @moonpug.Reading,
) -> Array[@syntax.Node] raise @moonpug.Refused {
  let nodes : Array[@syntax.Node] = [Text("<table>")]
  for line in source.split("\n") {
    let cells = line.trim().to_owned()
    if cells.is_empty() {
      continue
    }
    nodes.push(Text("<tr>"))
    for cell in cells.split(",") {
      nodes.push(Text("<td>"))
      nodes.append(
        reading.block(cell.trim().to_owned(), "html", None, reading.line),
      )
      nodes.push(Text("</td>"))
    }
    nodes.push(Text("</tr>"))
  }
  nodes.push(Text("</table>"))
  nodes
}

///|
fn main {
  let env = @moonpug.Env::new()
  env.add_lang({
    name: "csv",
    aliases: ["table"],
    options: @syntax.options,
    read: read_csv,
  })
  let source =
    #|<h2>Stock</h2>
    #|{% block lang=csv %}
    #|item, count
    #|ink, {{ ink }}
    #|paper, {{ paper * 2 }}
    #|{% endblock %}
  println(env.compile(source).render({ "ink": 3, "paper": 50 })) catch {
    e => println("refused: \{e}")
  }
}
