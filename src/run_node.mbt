///|
fn Run::run_nodes(
  self : Run,
  nodes : Array[@syntax.Node],
) -> Unit raise @spec.Refused {
  for node in nodes {
    match node {
      Line(n) => self.line = n
      _ => {
        let template = self.template
        let line = self.line
        self.run_node(node) catch {
          e => raise e.at(template, line)
        }
        if self.braking || self.skipping {
          return
        }
      }
    }
  }
}

///|
fn Run::run_node(self : Run, node : @syntax.Node) -> Unit raise @spec.Refused {
  match node {
    Line(n) => self.line = n
    Text(t) => if !self.extended { self.out.write_string(t) }
    Out(e) => {
      let v = self.eval(e)
      if !self.extended {
        self.emit(v)
      }
    }
    Raw(e) => {
      let v = self.eval(e)
      if !self.extended {
        self.out.write_string(
          match v {
            Markup(s) => s
            other => self.call.text(other)
          },
        )
      }
    }
    For(target~, iter~, cond~, recursive~, each~, body~, otherwise~) =>
      self.run_for(
        target,
        self.eval(iter),
        cond,
        recursive,
        each,
        body,
        otherwise,
        0,
      )
    If(branches, otherwise) => {
      for branch in branches {
        if self.call.truthy(self.eval(branch.0)) {
          self.run_nodes(branch.1)
          return
        }
      }
      self.run_nodes(otherwise)
    }
    Set(target, e) => self.assign(target, self.eval(e))
    SetBlock(target, filter, body) => {
      let captured = self.capture(() => self.run_nodes(body))
      let mut value = self.rendered(captured)
      match filter {
        Some(chain) => value = self.apply_chain(chain, value)
        None => ()
      }
      self.assign(target, value)
    }
    MacroDef(m) => self.bind(m.name, self.make_macro(m))
    CallBlock(params, call, body) =>
      match call {
        Call(target, args) => {
          let callee = self.eval(target)
          let (pos, named) = self.eval_args(args)
          let caller = Macro::{
            run: self,
            name: "caller",
            params,
            body,
            home: self.scopes.copy(),
            template: self.template,
            pug: false,
            caller: None,
            varargs: true,
            kwargs: true,
          }
          named["caller"] = Object(caller)
          let result = self.invoke(callee, pos, named)
          if !self.extended {
            self.emit(result)
          }
        }
        _ => raise @spec.invalid("a call block ends in a call")
      }
    FilterBlock(chain, body) => {
      let captured = self.capture(() => self.run_nodes(body))
      let value = self.apply_chain(chain, self.rendered(captured))
      if !self.extended {
        self.emit(value)
      }
    }
    Extends(e) => self.set_parent(self.eval(e))
    BlockDef(b) =>
      if !self.extended {
        self.render_block(b.name, scoped=b.scoped)
      }
    Include(e, missing~, context~, raw~, inline~, block~) =>
      self.include_template(
        self.eval(e),
        missing~,
        context~,
        raw~,
        inline~,
        block~,
      )
    Yield => ()
    Import(e, name, context~) =>
      self.bind(name, self.import_module(self.eval(e), context))
    FromImport(e, names, context~) => {
      let imported = self.import_module(self.eval(e), context)
      for pair in names {
        let (name, renamed) = pair
        match imported {
          Object(obj) =>
            match obj.attr(name) {
              Some(v) => self.bind(renamed.unwrap_or(name), v)
              None =>
                raise @spec.invalid(
                  "the template does not export the requested name \{name}",
                )
            }
          _ => ()
        }
      }
    }
    With(pairs, body) => {
      let values = pairs.map(p => (p.0, self.eval(p.1)))
      self.scoped(Map([]), () => {
        for pair in values {
          self.assign(pair.0, pair.1)
        }
        self.run_nodes(body)
      })
    }
    Autoescape(e, body) => {
      let before = self.autoescape()
      self.set_autoescape(self.call.truthy(self.eval(e)))
      defer self.set_autoescape(before)
      self.scoped(Map([]), () => self.run_nodes(body))
    }
    Do(e) => ignore(self.eval(e))
    Debug => {
      let context = self.visible()
      let filters = self.env.filters.keys().collect()
      filters.sort_by((a, b) => @spec.code_point_compare(a, b))
      let tests = self.env.tests.keys().collect()
      tests.sort_by((a, b) => @spec.code_point_compare(a, b))
      let report = @spec.Value::Dict(
        Map([
          ("context", Dict(context)),
          ("filters", Seq(filters.map(f => @spec.Value::Text(f)))),
          ("tests", Seq(tests.map(t => @spec.Value::Text(t)))),
        ]),
      )
      self.emit(self.call.filter("pprint", report, [], Map([])))
    }
    Show(e, body) => {
      let captured = self.capture(() => self.run_nodes(body))
      if self.call.truthy(self.eval(e)) {
        self.out.write_string(captured)
      } else {
        self.out.write_string("<div style=\"display: none\">")
        self.out.write_string(captured)
        self.out.write_string("</div>")
      }
    }
    Once(key, body) => {
      let slot = match key {
        Some(e) => self.call.text(self.eval(e))
        None => "\{self.template}:\{self.line}"
      }
      match self.once.get(slot) {
        Some(text) => self.out.write_string(text)
        None => {
          let render = () => {
            let text = self.capture(() => self.run_nodes(body))
            self.once[slot] = text
            text
          }
          let text = match self.env.cache {
            Some(store) => store(slot, render)
            None => render()
          }
          self.once[slot] = text
          self.out.write_string(text)
        }
      }
    }
    TransOut(t) => self.trans(t)
    Break => self.braking = true
    Continue => self.skipping = true
    Element(el) => self.element(el)
    Doctype(name) => {
      let text = doctype(name)
      let lower = text.to_lower()
      self.terse = lower == "<!doctype html>"
      self.xml = lower.has_prefix("<?xml")
      self.out.write_string(text)
    }
    Comment(body) => {
      self.out.write_string("<!--")
      self.run_nodes(body)
      self.out.write_string("-->")
    }
    Case(subject, arms, otherwise) => {
      let value = self.eval(subject)
      for arm in arms {
        for candidate in arm.0 {
          if self.eval(candidate) == value {
            self.run_nodes(arm.1)
            return
          }
        }
      }
      self.run_nodes(otherwise)
    }
  }
}

///|
/// Apply a filter chain whose innermost input is missing to `value`.
fn Run::apply_chain(
  self : Run,
  chain : @syntax.Expr,
  value : @spec.Value,
) -> @spec.Value raise @spec.Refused {
  match chain {
    Filter(None, name, args) => {
      let (pos, named) = self.eval_args(args)
      self.call.filter(name, value, pos, named)
    }
    Filter(Some(inner), name, args) => {
      let v = self.apply_chain(inner, value)
      let (pos, named) = self.eval_args(args)
      self.call.filter(name, v, pos, named)
    }
    _ => raise @spec.invalid("expected a filter")
  }
}

///|
/// Bind a value to a target: a name, a tuple unpacking an iterable, or an
/// attribute of a namespace.
fn Run::assign(
  self : Run,
  target : @syntax.Target,
  value : @spec.Value,
) -> Unit raise @spec.Refused {
  match target {
    Name(n) => self.bind(n, value)
    Tuple(targets) => {
      let items = self.call.items(value)
      if items.length() != targets.length() {
        raise @spec.invalid(
          if items.length() > targets.length() {
            "too many values to unpack (expected \{targets.length()})"
          } else {
            "not enough values to unpack (expected \{targets.length()}, got \{items.length()})"
          },
        )
      }
      for i, t in targets {
        self.assign(t, items[i])
      }
    }
    Field(name, attr) =>
      match self.lookup(name) {
        Object(obj) => obj.assign(attr, value)
        Undefined(n) => raise undefined_use(n)
        _ =>
          raise @spec.invalid(
            "cannot assign attribute on a non-namespace object",
          )
      }
  }
}

///|
/// A Jinja doctype from Pug's shorthand, or the name as written.
fn doctype(name : String) -> String {
  match name.to_lower() {
    "" | "html" | "5" => "<!DOCTYPE html>"
    "xml" => "<?xml version=\"1.0\" encoding=\"utf-8\" ?>"
    "transitional" =>
      "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">"
    "strict" =>
      "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"
    "frameset" =>
      "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Frameset//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd\">"
    "1.1" =>
      "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">"
    "basic" =>
      "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML Basic 1.1//EN\" \"http://www.w3.org/TR/xhtml-basic/xhtml-basic11.dtd\">"
    "mobile" =>
      "<!DOCTYPE html PUBLIC \"-//WAPFORUM//DTD XHTML Mobile 1.2//EN\" \"http://www.openmobilealliance.org/tech/DTD/xhtml-mobile12.dtd\">"
    "plist" =>
      "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">"
    _ => "<!DOCTYPE " + name + ">"
  }
}
