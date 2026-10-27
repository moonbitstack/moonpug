// Generates docs/builtins.html from a single source of truth: every filter,
// test, global and statement of the template language, with an example run
// through the compiled engine so the output on the page is the real one.
//
//   node scripts/gen_builtins.mjs
//
// The engine (docs/engine/moonpug.js) must be built first; the docs workflow
// does that before running this. A demo flagged live re-renders in the page
// through engine.render_page; a few that need a loader or a host object are
// recorded as written and marked not live.

import * as engine from "../docs/engine/moonpug.js";
import { writeFileSync } from "node:fs";

const esc = (s) =>
  String(s).replaceAll("&", "&amp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;");

const render = (src, data = "{}", lang = "html", force = false) =>
  engine.render_page(src, data, lang, force);

const FILTER_CATS = [
  ["text", "Text and letters"],
  ["numbers", "Numbers"],
  ["lists", "Lists and tables"],
  ["choose", "Choosing a value"],
  ["web", "Markup and URLs"],
  ["dates", "Dates and times"],
];

// [name, cat, summary, usage, params[[name,kind,note]], [src, data?, lang?], aliasNote?]
const FILTERS = [
  // ---- Text and letters ----
  ["capitalize", "text", "Capitalise the first character and lowercase the rest.", "value|capitalize", [], ['{{ "hello WORLD"|capitalize }}']],
  ["capfirst", "text", "Capitalise only the first character, leaving the rest.", "value|capfirst", [], ['{{ "hello"|capfirst }}']],
  ["center", "text", "Centre the text in a field of the given width.", "value|center(width)", [["width", "int", "field width"]], ['{{ "hi"|center(10) }}']],
  ["cut", "text", "Remove every occurrence of a substring.", "value|cut(arg)", [["arg", "string", "text to remove"]], ['{{ "a-b-c"|cut("-") }}']],
  ["escape", "text", "Escape HTML so the text is safe to write. Markup is left as it stands.", "value|escape", [], ['{{ "<b>"|escape }}']],
  ["e", "text", "An alias of escape.", "value|e", [], ['{{ "<b>"|e }}']],
  ["escapejs", "text", "Escape text so it is safe inside a JavaScript string.", "value|escapejs", [], ['{{ "a\'b<c"|escapejs }}']],
  ["forceescape", "text", "Escape even text already marked safe.", "value|forceescape", [], ['{{ ("<b>"|safe)|forceescape }}']],
  ["indent", "text", "Indent each line (after the first unless first) by a width.", "value|indent(width, first, blank)", [["width", "int or string", "spaces or a literal prefix"], ["first", "bool", "indent the first line too"], ["blank", "bool", "indent blank lines too"]], ['{{ "a\\nb"|indent(2) }}']],
  ["linebreaks", "text", "Turn newlines into paragraphs and line breaks, returned as safe HTML.", "value|linebreaks", [], ['{{ "one\\n\\ntwo"|linebreaks }}']],
  ["linebreaksbr", "text", "Turn newlines into line breaks, returned as safe HTML.", "value|linebreaksbr", [], ['{{ "a\\nb"|linebreaksbr }}']],
  ["linenumbers", "text", "Prefix every line with its one-based number.", "value|linenumbers", [], ['{{ "a\\nb\\nc"|linenumbers }}']],
  ["lower", "text", "Lowercase the text.", "value|lower", [], ['{{ "HELLO"|lower }}']],
  ["replace", "text", "Replace occurrences of old with new, at most count times.", "value|replace(old, new, count)", [["old", "string", "text to find"], ["new", "string", "replacement"], ["count", "int", "most replacements, -1 for all"]], ['{{ "a-b-c"|replace("-", " ") }}']],
  ["safe", "text", "Mark the text safe; it passes through without escaping.", "value|safe", [], ['{{ ("<b>"|safe) }}']],
  ["spaceless", "text", "Remove the whitespace between tags.", "value|spaceless", [], ['{{ "<a>  </a>"|spaceless }}']],
  ["string", "text", "Cast the value to text.", "value|string", [], ['{{ 7|string }}']],
  ["striptags", "text", "Strip tags and decode entities, collapsing whitespace.", "value|striptags", [], ['{{ "<b>hi</b>"|striptags }}']],
  ["title", "text", "Title-case the text: capitalise each word.", "value|title", [], ['{{ "hello world"|title }}']],
  ["trim", "text", "Strip surrounding characters (default whitespace).", "value|trim(chars)", [["chars", "string", "characters to strip"]], ['{{ "  hi  "|trim }}']],
  ["truncate", "text", "Cut to a length, ending with an ellipsis, keeping whole words unless killwords.", "value|truncate(length, killwords, end, leeway)", [["length", "int", "maximum length"], ["killwords", "bool", "cut mid-word"], ["end", "string", "the ending, … by default"], ["leeway", "int", "grace before cutting"]], ['{{ "a long sentence about the weather"|truncate(20) }}']],
  ["upper", "text", "Uppercase the text.", "value|upper", [], ['{{ "héllo"|upper }}']],
  ["wordcount", "text", "Count the words.", "value|wordcount", [], ['{{ "the quick brown"|wordcount }}']],
  ["wordwrap", "text", "Wrap the text at a column width.", "value|wordwrap(width, break_long_words, wrapstring, break_on_hyphens)", [["width", "int", "column width"], ["break_long_words", "bool", "split long words"], ["wrapstring", "string", "line separator"], ["break_on_hyphens", "bool", "break on hyphens"]], ['{{ "one two three four five"|wordwrap(10) }}']],
  ["addslashes", "text", "Escape quotes and backslashes for a JavaScript string.", "value|addslashes", [], ['{{ "it\'s"|addslashes }}']],
  ["iriencode", "text", "Percent-encode an IRI for use in a URL.", "value|iriencode", [], ['{{ "a path/c?d"|iriencode }}']],
  ["phone2numeric", "text", "Map letters to the digits of a telephone keypad.", "value|phone2numeric", [], ['{{ "0800cafe"|phone2numeric }}']],
  ["format", "text", "Fill % placeholders with positional or named arguments.", "value|format(*args, **named)", [["args", "values", "positional %s, %d, …"], ["named", "mapping", "named %(name)s"]], ['{{ "%s = %s"|format("x", 1) }}']],

  // ---- Numbers ----
  ["abs", "numbers", "The absolute value of a number.", "value|abs", [], ['{{ -7|abs }}']],
  ["add", "numbers", "Add a number, or concatenate strings and lists.", "value|add(arg)", [["arg", "value", "the value to add or join"]], ['{{ 10|add(5) }}']],
  ["filesizeformat", "numbers", "Format a count of bytes as a human size.", "value|filesizeformat(binary)", [["binary", "bool", "use 1024-based units"]], ['{{ 1234567|filesizeformat }}']],
  ["float", "numbers", "Parse a number or string as a floating point value.", "value|float(default)", [["default", "float", "fallback when not a number"]], ['{{ "3.14"|float }}']],
  ["floatformat", "numbers", "Format a number to fixed places, Django style (g groups thousands, u ungroups).", "value|floatformat(arg)", [["arg", "string or int", "places; -1 drops empty fraction; default -1"]], ['{{ 3.14159|floatformat(2) }}']],
  ["get_digit", "numbers", "Return the nth digit of an integer, counting from the right; 1 is the units digit.", "value|get_digit(arg)", [["arg", "int", "which digit"]], ['{{ 12345|get_digit(2) }}']],
  ["int", "numbers", "Parse a number or string as an integer, in a given base.", "value|int(default, base)", [["default", "int", "fallback when not a number"], ["base", "int", "number base, 10 by default"]], ['{{ "42"|int }}']],
  ["round", "numbers", "Round a number: common, ceil or floor, to a number of places.", "value|round(precision, method)", [["precision", "int", "decimal places"], ["method", "string", "common, ceil or floor"]], ['{{ 3.14159|round(2) }}']],
  ["sum", "numbers", "Add the items, or a named field of each.", "value|sum(attribute, start)", [["attribute", "string", "field to sum"], ["start", "value", "starting value"]], ['{{ items|sum(attribute="n") }}', '{"items":[{"n":1},{"n":2},{"n":3}]}']],

  // ---- Lists and tables ----
  ["batch", "lists", "Group items into rows of a given size, padding the last with fill_with.", "value|batch(linecount, fill_with)", [["linecount", "int", "items per row"], ["fill_with", "value", "padding for the last row"]], ['{{ [1,2,3,4,5]|batch(2)|list }}']],
  ["dictsort", "lists", "Sort a mapping into (key, value) pairs, by key, value or with a case-sensitive order.", "value|dictsort(case_sensitive, by, reverse)", [["case_sensitive", "bool", "compare letters as written"], ["by", "string", "key or value"], ["reverse", "bool", "reverse the order"]], ['{{ {"b":2,"a":1}|dictsort|list }}']],
  ["first", "lists", "The first item of a sequence.", "value|first", [], ['{{ [1,2,3]|first }}']],
  ["groupby", "lists", "Group items that share an attribute, each group read as grouper and list.", "value|groupby(attribute, default, case_sensitive)", [["attribute", "string", "field to group by"], ["default", "value", "value for missing fields"], ["case_sensitive", "bool", "compare letters as written"]], ['{{ users|groupby("kind")|map(attribute="grouper")|join(", ") }}', '{"users":[{"kind":"a","name":"x"},{"kind":"b","name":"y"},{"kind":"a","name":"z"}]}']],
  ["items", "lists", "A mapping's entries as (key, value) pairs.", "value|items", [], ['{{ {"a":1,"b":2}|items|list }}']],
  ["join", "lists", "Join items with a separator, or a named field of each.", "value|join(d, attribute)", [["d", "string", "the separator"], ["attribute", "string", "field to join"]], ['{{ ["a","b","c"]|join(", ") }}']],
  ["last", "lists", "The last item of a sequence.", "value|last", [], ['{{ [1,2,3]|last }}']],
  ["length", "lists", "The length: characters of a string, items of a list, keys of a mapping.", "value|length", [], ['{{ [1,2,3]|length }}']],
  ["count", "lists", "An alias of length.", "value|count", [], ['{{ "hello"|count }}']],
  ["list", "lists", "Turn the value into a list.", "value|list", [], ['{{ "abc"|list }}']],
  ["map", "lists", "Apply a filter to each item, or pull a named field out of each.", "value|map(attribute, default, filter)", [["attribute", "string", "field to read"], ["default", "value", "value for missing fields"], ["filter", "string", "a filter to apply to each item"]], ['{{ users|map(attribute="name")|join(", ") }}', '{"users":[{"name":"Ada"},{"name":"Grace"}]}']],
  ["max", "lists", "The largest item, or the largest by a field.", "value|max(attribute, case_sensitive)", [["attribute", "string", "field to compare"], ["case_sensitive", "bool", "compare letters as written"]], ['{{ [3,1,2]|max }}']],
  ["min", "lists", "The smallest item, or the smallest by a field.", "value|min(attribute, case_sensitive)", [["attribute", "string", "field to compare"], ["case_sensitive", "bool", "compare letters as written"]], ['{{ [3,1,2]|min }}']],
  ["pprint", "lists", "A readable, Python-style print of a value.", "value|pprint", [], ['{{ {"a":[1,2],"b":3}|pprint }}']],
  ["random", "lists", "One item, chosen so the same page renders the same way twice.", "value|random", [], ['{{ [1,2,3]|random }}']],
  ["reject", "lists", "Drop items that pass a test; with no test, drop the untruthy.", "value|reject(test, args)", [["test", "string", "a test name"], ["args", "values", "the test's arguments"]], ['{{ [1,2,3,4]|reject("odd")|list }}']],
  ["rejectattr", "lists", "Drop items whose field fails a test.", "value|rejectattr(attribute, test, args)", [["attribute", "string", "field to test"], ["test", "string", "a test name"], ["args", "values", "the test's arguments"]], ['{{ items|rejectattr("shown")|list }}', '{"items":[{"shown":true},{"shown":false}]}']],
  ["reverse", "lists", "Reverse a list, or the characters of a string.", "value|reverse", [], ['{{ [1,2,3]|reverse|list }}']],
  ["select", "lists", "Keep items that pass a test; with no test, keep the truthy.", "value|select(test, args)", [["test", "string", "a test name"], ["args", "values", "the test's arguments"]], ['{{ [1,2,3,4]|select("odd")|list }}']],
  ["selectattr", "lists", "Keep items whose field passes a test.", "value|selectattr(attribute, test, args)", [["attribute", "string", "field to test"], ["test", "string", "a test name"], ["args", "values", "the test's arguments"]], ['{{ items|selectattr("shown")|list }}', '{"items":[{"shown":true},{"shown":false}]}']],
  ["slice", "lists", "Split into a number of slices, padding the last with fill_with.", "value|slice(slices, fill_with)", [["slices", "int", "how many slices"], ["fill_with", "value", "padding for the last slice"]], ['{{ [1,2,3,4,5]|slice(2)|list }}']],
  ["sort", "lists", "Sort items, by a field, with a case-sensitive or reversed order.", "value|sort(reverse, case_sensitive, attribute)", [["reverse", "bool", "reverse the order"], ["case_sensitive", "bool", "compare letters as written"], ["attribute", "string", "field to sort by"]], ['{{ ["b","a","c"]|sort|list }}']],
  ["unique", "lists", "Drop repeated items, by value or by a field.", "value|unique(case_sensitive, attribute)", [["case_sensitive", "bool", "compare letters as written"], ["attribute", "string", "field to compare"]], ['{{ [1,2,2,3]|unique|list }}']],
  ["attr", "lists", "Read a named attribute of a host object.", "value|attr(name)", [["name", "string", "the attribute"]], ['{% set ns = namespace(city="Rome") %}{{ ns|attr("city") }}']],

  // ---- Choosing a value ----
  ["default", "choose", "A fallback when the value is undefined, or false under boolean.", "value|default(default_value, boolean)", [["default_value", "value", "what to use instead"], ["boolean", "bool", "also replace a false value"]], ['{{ missing|default("none") }}']],
  ["d", "choose", "An alias of default.", "value|d(default_value, boolean)", [["default_value", "value", "what to use instead"], ["boolean", "bool", "also replace a false value"]], ['{{ missing|d("none") }}']],
  ["default_if_none", "choose", "A fallback used only when the value is null.", "value|default_if_none(arg)", [["arg", "value", "what to use instead"]], ['{{ none|default_if_none("none") }}']],

  // ---- Markup and URLs ----
  ["urlencode", "web", "Percent-encode a string, or a mapping or pairs as a query string.", "value|urlencode", [], ['{{ {"q":"a b"}|urlencode }}']],
  ["urlize", "web", "Turn web addresses and emails into anchor tags.", "value|urlize(trim_url_limit, nofollow, target, rel, extra_schemes)", [["trim_url_limit", "int", "shorten shown links"], ["nofollow", "bool", "add rel=nofollow"], ["target", "string", "the anchor target"], ["rel", "string", "extra rel words"], ["extra_schemes", "list", "more URI schemes to link"]], ['{{ "visit http://example.com"|urlize }}']],
  ["xmlattr", "web", "Build a string of attributes from a mapping, as safe markup.", "value|xmlattr(autospace)", [["autospace", "bool", "a leading space, on by default"]], ['{{ {"class":"x","id":5}|xmlattr }}']],
  ["tojson", "web", "Serialise a value to JSON safe inside a script tag.", "value|tojson(indent)", [["indent", "int", "spaces to indent"]], ['{{ {"a":1}|tojson }}']],
  ["json_script", "web", "Wrap JSON in a script tag, optionally with an id.", "value|json_script(element_id)", [["element_id", "string", "the tag's id"]], ['{{ {"a":1}|json_script("data") }}']],
  ["truncatewords", "web", "Cut to a number of words, ending with an ellipsis.", "value|truncatewords(arg)", [["arg", "int", "most words"]], ['{{ "one two three four"|truncatewords(2) }}']],
  ["unordered_list", "web", "Render a list of items and nested lists as HTML ul elements.", "value|unordered_list", [], ['{{ tree|unordered_list }}', '{"tree":["first",["child one","child two"],"last"]}']],
  ["ljust", "web", "Left-justify the text in a field of the given width.", "value|ljust(arg)", [["arg", "int", "field width"]], ['{{ "hi"|ljust(5) }}']],
  ["rjust", "web", "Right-justify the text in a field of the given width.", "value|rjust(arg)", [["arg", "int", "field width"]], ['{{ "hi"|rjust(5) }}']],
  ["yesno", "web", "Map true, false and null to words, comma-separated.", "value|yesno(arg)", [["arg", "string", "yes,no,maybe (maybe optional)"],], ['{{ ok|yesno }}', '{"ok":true}']],
  ["pluralize", "web", "Add a suffix (or two, comma-separated) based on a count.", "value|pluralize(arg)", [["arg", "string", "suffix, or singular,plural"]], ['{{ count|pluralize }}', '{"count":3}']],

  // ---- Dates and times ----
  ["date", "dates", "Format a date with Django's letters; a time letter is refused.", "value|date(arg)", [["arg", "string", "a format or a named format such as DATE_FORMAT"]], ['{{ d|date("Y-m-d") }}', '{"d":"2026-05-04"}']],
  ["time", "dates", "Format a time with Django's letters; a date letter is ignored.", "value|time(arg)", [["arg", "string", "a format or TIME_FORMAT"]], ['{{ t|time("H:i") }}', '{"t":"2026-05-04T13:45:00"}']],
  ["timesince", "dates", "Words for the span from a date to now (a date you supply, templates read no clock).", "value|timesince(now, depth)", [["now", "date", "the moment to measure to"], ["depth", "int", "most adjacent units, 2 by default"]], ['{{ d|timesince(now) }}', '{"d":"2026-01-01","now":"2026-05-04"}']],
  ["timeuntil", "dates", "Words for the span from now to a date.", "value|timeuntil(now, depth)", [["now", "date", "the moment to measure to"], ["depth", "int", "most adjacent units, 2 by default"]], ['{{ d|timeuntil(now) }}', '{"d":"2026-05-04","now":"2026-01-01"}']],
];

const TEST_CATS = [
  ["type", "Type"],
  ["compare", "Numbers and comparison"],
  ["string", "Strings"],
  ["identity", "Identity and membership"],
  ["existence", "Existence"],
];

// [name, cat, summary, usage, params, src, aliasNote?]
const TESTS = [
  // ---- Type ----
  ["none", "type", "True when the value is null.", "value is none", [], ['{{ none is none }}']],
  ["boolean", "type", "True when the value is a boolean.", "value is boolean", [], ['{{ true is boolean }}']],
  ["true", "type", "True when the value is the boolean true.", "value is true", [], ['{{ true is true }}']],
  ["false", "type", "True when the value is the boolean false.", "value is false", [], ['{{ false is false }}']],
  ["integer", "type", "True when the value is an integer.", "value is integer", [], ['{{ 3 is integer }}']],
  ["float", "type", "True when the value is a floating point number.", "value is float", [], ['{{ 3.0 is float }}']],
  ["number", "type", "True when the value is a number (integer, float or boolean).", "value is number", [], ['{{ 3 is number }}']],
  ["string", "type", "True when the value is text or safe markup.", "value is string", [], ['{{ "x" is string }}']],
  ["mapping", "type", "True when the value is a mapping.", "value is mapping", [], ['{{ {} is mapping }}']],
  ["sequence", "type", "True when the value is a string, list, tuple or mapping.", "value is sequence", [], ['{{ [1,2] is sequence }}']],
  ["iterable", "type", "True when the value can be looped over.", "value is iterable", [], ['{{ "ab" is iterable }}']],
  ["callable", "type", "True when the value can be called, like a global function.", "value is callable", [], ['{{ range is callable }}']],
  ["escaped", "type", "True when the value is markup already safe to write.", "value is escaped", [], ['{{ ("<b>"|safe) is escaped }}']],

  // ---- Numbers and comparison ----
  ["odd", "compare", "True when a number is odd.", "value is odd", [], ['{{ 7 is odd }}']],
  ["even", "compare", "True when a number is even.", "value is even", [], ['{{ 4 is even }}']],
  ["divisibleby", "compare", "True when a number divides by the argument.", "value is divisibleby(n)", [["n", "number", "the divisor"]], ['{{ 9 is divisibleby(3) }}']],
  ["==", "compare", "True when the value equals the other. Also eq and equalto.", "value == other", [["other", "value", "what to compare against"]], ['{{ 3 == 3 }}']],
  ["eq", "compare", "An alias of ==.", "value is eq other", [["other", "value", "what to compare against"]], ['{{ 3 is eq 3 }}']],
  ["equalto", "compare", "An alias of ==.", "value is equalto other", [["other", "value", "what to compare against"]], ['{{ 3 is equalto 3 }}']],
  ["!=", "compare", "True when the value differs from the other. Also ne.", "value != other", [["other", "value", "what to compare against"]], ['{{ 3 != 4 }}']],
  ["ne", "compare", "An alias of !=.", "value is ne other", [["other", "value", "what to compare against"]], ['{{ 3 is ne 4 }}']],
  ["<", "compare", "True when the value is less than the other. Also lt and lessthan.", "value < other", [["other", "value", "what to compare against"]], ['{{ 3 < 4 }}']],
  ["lt", "compare", "An alias of <.", "value is lt other", [["other", "value", "what to compare against"]], ['{{ 3 is lt 4 }}']],
  ["lessthan", "compare", "An alias of <.", "value is lessthan other", [["other", "value", "what to compare against"]], ['{{ 3 is lessthan 4 }}']],
  [">", "compare", "True when the value is greater than the other. Also gt and greaterthan.", "value > other", [["other", "value", "what to compare against"]], ['{{ 3 > 2 }}']],
  ["gt", "compare", "An alias of >.", "value is gt other", [["other", "value", "what to compare against"]], ['{{ 3 is gt 2 }}']],
  ["greaterthan", "compare", "An alias of >.", "value is greaterthan other", [["other", "value", "what to compare against"]], ['{{ 3 is greaterthan 2 }}']],
  ["<=", "compare", "True when the value is at most the other. Also le.", "value <= other", [["other", "value", "what to compare against"]], ['{{ 3 <= 3 }}']],
  ["le", "compare", "An alias of <=.", "value is le other", [["other", "value", "what to compare against"]], ['{{ 3 is le 3 }}']],
  [">=", "compare", "True when the value is at least the other. Also ge.", "value >= other", [["other", "value", "what to compare against"]], ['{{ 3 >= 3 }}']],
  ["ge", "compare", "An alias of >=.", "value is ge other", [["other", "value", "what to compare against"]], ['{{ 3 is ge 3 }}']],

  // ---- Strings ----
  ["lower", "string", "True when text is all lowercase.", "value is lower", [], ['{{ "abc" is lower }}']],
  ["upper", "string", "True when text is all uppercase.", "value is upper", [], ['{{ "ABC" is upper }}']],

  // ---- Identity and membership ----
  ["sameas", "identity", "True when the two values are the same object or equal value.", "value is sameas other", [["other", "value", "the other value"]], ['{% set a = [1] %}{{ a is sameas a }}']],
  ["in", "identity", "True when the value is a member of the container.", "value is in container", [["container", "value", "where to look"]], ['{{ "a" in ["a","b"] }}']],

  // ---- Existence ----
  ["defined", "existence", "True when the name resolved to a value.", "value is defined", [], ['{% set present = 1 %}{{ present is defined }}']],
  ["undefined", "existence", "True when the name resolved to nothing.", "value is undefined", [], ['{{ missing is undefined }}']],
  ["filter", "existence", "True when a filter of the given name is registered.", "value is filter", [], ['{{ "upper" is filter }}']],
  ["test", "existence", "True when a test of the given name is registered.", "value is test", [], ['{{ "odd" is test }}']],
];

// [name, summary, usage, params, src, aliasNote?]
const GLOBALS = [
  ["range", "Build a list of integers, Python's range.", "range(stop) · range(start, stop) · range(start, stop, step)", [["start", "int", "first value, 0 by default"], ["stop", "int", "one past the last"], ["step", "int", "the step, 1 by default"]], ['{{ range(1, 4)|list }}{{ range(0, 10, 2)|list }}']],
  ["dict", "Build a mapping from pairs, a mapping or named arguments.", "dict(pairs) · dict(a=1, b=2)", [["pairs", "sequence", "a list of [key, value]"], ["named", "values", "keys and values"]], ['{{ dict(a=1, b=2)|items|list }}']],
  ["lipsum", "Generate pseudo-Latin filler text, the same page twice, as safe HTML or plain text.", "lipsum(n, html, min, max)", [["n", "int", "paragraphs, 5 by default"], ["html", "bool", "wrap in <p>, true by default"], ["min", "int", "shortest word count"], ["max", "int", "longest word count"]], ['{{ lipsum(n=1, min=5, max=8) }}']],
  ["cycler", "Cycle through items: current names the present item, next advances.", "cycler(*items)", [["items", "values", "the values to cycle"]], ['{% set c = cycler("odd","even") %}{{ c.next() }}{{ c.next() }}{{ c.next() }}']],
  ["joiner", "A separator that prints nothing the first time and the separator after.", "joiner(sep)", [["sep", "string", "the separator, \", \" by default"]], ['{% set j = joiner(", ") %}{% for x in ["a","b","c"] %}{{ j() }}{{ x }}{% endfor %}']],
  ["namespace", "A mapping whose fields a template may assign from inside a loop or block.", "namespace(**fields)", [["fields", "values", "initial fields"]], ['{% set ns = namespace(n=0) %}{% for i in [1,2,3] %}{% set ns.n = ns.n + i %}{% endfor %}{{ ns.n }}']],
  ["gettext", "Translate a message through the translation seam; with no seam the text stands.", "gettext(message) · _(message)", [["message", "string", "the message to translate"]], ['{{ gettext("Hello") }} {{ _("World") }}']],
  ["_", "An alias of gettext.", "_(message)", [["message", "string", "the message to translate"]], ['{{ _("Hello") }}']],
  ["ngettext", "Translate a singular or plural message by a count.", "ngettext(singular, plural, count)", [["singular", "string", "one form"], ["plural", "string", "many form"], ["count", "number", "the count"]], ['{{ ngettext("%(num)d apple", "%(num)d apples", n) }}', '{"n":2}']],
  ["pgettext", "Translate a message within a context.", "pgettext(context, message)", [["context", "string", "the message context"], ["message", "string", "the message to translate"]], ['{{ pgettext("menu", "Open") }}']],
  ["npgettext", "Translate a singular or plural message within a context.", "npgettext(context, singular, plural, count)", [["context", "string", "the message context"], ["singular", "string", "one form"], ["plural", "string", "many form"], ["count", "number", "the count"]], ['{{ npgettext("file", "%(num)d file", "%(num)d files", n) }}', '{"n":2}']],
];

const STATEMENT_CATS = [
  ["flow", "Flow control"],
  ["reuse", "Templates and reuse"],
  ["output", "Output and escaping"],
  ["i18n", "Internationalisation"],
  ["misc", "Side effects and caching"],
];

// [name, cat, summary, syntax, params, demo{or src/static/note}, note?]
const STATEMENTS = [
  ["if", "flow", "Branch on a condition; elif adds a clause, else the fallback.", "{% if cond %}…{% elif cond %}…{% else %}…{% endif %}", [], { src: '{% if n > 2 %}big{% elif n == 2 %}two{% else %}small{% endif %}', data: '{"n":2}' }],
  ["for", "flow", "Loop over items. The else runs when there were none; break and continue work inside. The loop variable holds index, index0, revindex, first, last, length, depth, previtem, nextitem, cycle(…) and changed(…); a recursive loop calls loop(children).", "{% for x in items %}…{% else %}…{% endfor %}", [["items", "sequence", "what to iterate"], ["if", "condition", "loop only matching items"], ["recursive", "flag", "descend into nested items"]], { src: '{% for x in items %}{{ loop.index }}:{{ x }}{% if not loop.last %}, {% endif %}{% else %}none{% endfor %}', data: '{"items":["a","b","c"]}' }],
  ["set", "flow", "Bind a name to a value, or to a block of markup with endset.", "{% set name = expr %} · {% set name %}…{% endset %}", [["name", "name", "the variable"], ["expr", "value", "a value or filter chain"], ["block", "flag", "a block form with endset"]], { src: '{% set greeting %}Hello {{ name }}{% endset %}{{ greeting }}', data: '{"name":"Ada"}' }],
  ["with", "flow", "Give names local values for the enclosed block.", "{% with a = 1, b = 2 %}…{% endwith %}", [["names", "assignments", "names and their values"]], { src: '{% with total = 3 %}{{ total }}{% endwith %}' }],
  ["macro", "reuse", "Define a reusable block with parameters; call it by name, or with a caller block via endcall.", "{% macro name(args) %}…{% endmacro %} · {% call name(args) %}…{% endcall %}", [["args", "parameters", "names, defaults, a rest parameter"]], { src: '{% macro field(n, v="") %}<input name="{{ n }}" value="{{ v }}">{% endmacro %}{{ field("q") }}' }, "Macros, and the indentation syntax's mixins, take attributes and a block too."],
  ["filter", "reuse", "Apply a filter to a block of markup.", "{% filter upper %}…{% endfilter %}", [["filter", "filter", "the filter and its arguments"]], { src: '{% filter upper %}hello {{ name }}{% endfilter %}', data: '{"name":"ada"}' }],
  ["block", "reuse", "Define a named block a parent can fill; super() calls the parent's block, scoped sees the loop around it, required must be filled, append and prepend add to it. The indentation syntax has block append and block prepend too. Needs a loader through Env::new(load=…).", "{% extends \"base\" %} · {% block name %}…{% endblock %}", [], { static: true, note: "Inheritance needs a loader, so the example below is shown, not run. The parent is read through load passed to Env::new; the Guide walks a full layout." , src: '{% extends "layout.html" %}\n{% block body %}page{% endblock %}' }],
  ["include", "reuse", "Pull in another template; ignore missing tolerates a missing file, with context shares the names, inline renders in place, raw includes plain text, and a block lands where the included file says yield. Needs a loader.", "{% include \"partial\" %} · {% include \"partial\" ignore missing with context %}", [["missing", "flag", "ignore a missing file"], ["context", "flag", "share local names"], ["inline", "flag", "render in place"], ["raw", "flag", "include as text"]], { static: true, note: "Includes a named template through the loader, so the syntax is shown rather than run here.", src: '{% include "footer.html" ignore missing %}' }],
  ["import", "reuse", "Import names from another template as a module, or bring chosen names in directly; with context shares the names. Needs a loader.", "{% import \"ui\" as ui %} · {% from \"ui\" import card %}", [["context", "flag", "share local names"]], { static: true, note: "Reads the module through the loader, so the syntax is shown rather than run here.", src: '{% from "ui.html" import card %}{{ card("Title", "Note") }}' }],
  ["raw", "output", "Write text exactly as written, with no substitution.", "{% raw %}…{% endraw %}", [], { src: '{% raw %}{{ not_evaluated }}{% endraw %}' }],
  ["autoescape", "output", "Turn escaping on or off for the enclosed block.", "{% autoescape false %}…{% endautoescape %}", [["flag", "bool", "escape or not"]], { src: '{% autoescape false %}{{ html }}{% endautoescape %}', data: '{"html":"<b>"}' }],
  ["show", "output", "Write the block either way; when the condition is false it is hidden with an inline style, not removed.", "{% show cond %}…{% endshow %}", [["cond", "bool", "whether to show"]], { src: '{% show ok %}<b>shown</b>{% endshow %}', data: '{"ok":true}' }],
  ["debug", "output", "Print the current context: every name in scope.", "{% debug %}", [], { static: true, out: "{…all names in scope…}", src: '{% debug %}' }],
  ["trans", "i18n", "Mark text for translation; pluralize switches on a count. With no translation seam the source text stands.", "{% trans %}…{% endtrans %} · {% trans count=n %}…{% pluralize %}…{% endtrans %}", [["count", "number", "the plural count"], ["context", "string", "a message context"]], { src: '{% trans count=n %}{{ count }} item{% pluralize %}{{ count }} items{% endtrans %}', data: '{"n":3}' }],
  ["do", "misc", "Evaluate an expression for its side effect, typically calling a method of a host object.", "{% do object.method() %}", [["expr", "call", "a callable to run"]], { static: true, out: "(no output; runs the callable for its effect)", src: '{% do user.log("visited") %}' }],
  ["once", "misc", "Render a block once and, with a cache passed to Env::new, keep it; without one it renders every time.", "{% once key %}…{% endonce %}", [["key", "value", "the cache key"]], { src: '{% once "sidebar" %}{{ 1 + 1 }}{% endonce %}' }],
];

// ---- HTML assembly -------------------------------------------------------

let warnings = [];

function demoBlock(d, idPrefix) {
  // Filters, tests and globals store a demo as [src, data?, lang?];
  // statements store it as {src, data?, static?, note?, out?}. Normalise.
  if (Array.isArray(d)) d = { src: d[0], data: d[1], lang: d[2] };
  const label = (t) => `<span class="demo-label">${t}</span>`;
  if (d.static && d.note) {
    // A statement that cannot run in the browser engine: show the source and a note.
    return `<div class="demo" data-live="0"><span class="demo-label">template</span>` +
      `<pre class="code demo-src">${esc(d.src)}</pre>` +
      `<p class="note">${esc(d.note)}</p></div>`;
  }
  const src = d.src;
  const data = d.data != null ? d.data : "{}";
  const lang = d.lang || "html";
  let out;
  if (d.static && d.out != null) {
    out = d.out;
  } else {
    out = render(src, data, lang, false);
    if (out.startsWith("refused: ")) {
      warnings.push(`${idPrefix}: ${out}\n   ${src}`);
    }
  }
  const live = d.static ? "0" : "1";
  const dataBox =
    d.data != null && !d.static
      ? `${label("data")}<pre class="code demo-data">${esc(data)}</pre>`
      : "";
  const srcBox = `${label("template")}<pre class="code demo-src">${esc(src)}</pre>`;
  const outBox = `${label("output")}<div class="demo-out">${esc(out)}</div>`;
  return `<div class="demo" data-live="${live}" data-lang="${lang}">${srcBox}${dataBox}${outBox}</div>`;
}

function paramsBlock(params) {
  if (!params || params.length === 0) return "";
  const rows = params
    .map(([n, k, note]) => `<dt><code>${esc(n)}</code> <i>${esc(k)}</i></dt><dd>${esc(note)}</dd>`)
    .join("");
  return `<dl class="fields">${rows}</dl>`;
}

function article(kind, id, name, summary, usage, params, demo, aliasNote) {
  const kindTag = `<span class="kind">${kind}</span>`;
  const alias = aliasNote ? ` <span class="alias">${esc(aliasNote)}</span>` : "";
  return `<article id="${id}"><h3>${kindTag} ${esc(name)}${alias}</h3>
<p>${esc(summary)}</p>
<pre class="sig"><code>${esc(usage)}</code></pre>
${paramsBlock(params)}
${demoBlock(demo, id)}
</article>`;
}

function filtersSection() {
  let out = `<section id="filters"><h2>Filters</h2>
<p class="lede">Seventy-nine filters, written after a value with <code>|</code>. Aliases are noted where they stand in for another.</p>`;
  for (const [cat, label] of FILTER_CATS) {
    const items = FILTERS.filter((f) => f[1] === cat);
    out += `<h3 id="filters-${cat}">${esc(label)}</h3>`;
    for (const [name, , summary, usage, params, demo, aliasNote] of items) {
      out += article("filter", `filter-${name}`, name, summary, usage, params, demo, aliasNote);
    }
  }
  out += `</section>`;
  return out;
}

function testsSection() {
  let out = `<section id="tests"><h2>Tests</h2>
<p class="lede">Thirty-nine tests, written after a value with <code>is</code>. Many comparison names are aliases of the symbol forms.</p>`;
  for (const [cat, label] of TEST_CATS) {
    const items = TESTS.filter((t) => t[1] === cat);
    out += `<h3 id="tests-${cat}">${esc(label)}</h3>`;
    for (const [name, , summary, usage, params, demo, aliasNote] of items) {
      out += article("test", `test-${name}`, name, summary, usage, params, demo, aliasNote);
    }
  }
  out += `</section>`;
  return out;
}

function globalsSection() {
  let out = `<section id="globals"><h2>Globals</h2>
<p class="lede">Eleven names every template sees without being passed in. <code>_</code> is an alias of <code>gettext</code>.</p>`;
  for (const [name, summary, usage, params, demo, aliasNote] of GLOBALS) {
    out += article("global", `global-${name}`, name, summary, usage, params, demo, aliasNote);
  }
  out += `</section>`;
  return out;
}

function statementsSection() {
  let out = `<section id="statements"><h2>Statements</h2>
<p class="lede">The tags that shape a template. Most run live below through the same engine this site ships; a few that need a loader or a host object are shown with their syntax.</p>`;
  for (const [cat, label] of STATEMENT_CATS) {
    const items = STATEMENTS.filter((s) => s[1] === cat);
    out += `<h3 id="statements-${cat}">${esc(label)}</h3>`;
    for (const [name, , summary, usage, params, demo, note] of items) {
      out += article("statement", `stmt-${name}`, name, summary, usage, params, demo);
    }
  }
  out += `</section>`;
  return out;
}

function asideIndex() {
  let groups = "";
  const addGroup = (title, items) => {
    if (!items.length) return;
    groups += `<div class="group"><b>${esc(title)}</b>`;
    for (const [name, id] of items) {
      groups += `<a href="#${id}">${esc(name)}</a>`;
    }
    groups += `</div>`;
  };
  for (const [cat, label] of FILTER_CATS) {
    addGroup(label, FILTERS.filter((f) => f[1] === cat).map((f) => [f[0], `filter-${f[0]}`]));
  }
  addGroup("Tests", TESTS.map((t) => [t[0], `test-${t[0]}`]));
  addGroup("Globals", GLOBALS.map((g) => [g[0], `global-${g[0]}`]));
  for (const [cat, label] of STATEMENT_CATS) {
    addGroup(label, STATEMENTS.filter((s) => s[1] === cat).map((s) => [s[0], `stmt-${s[0]}`]));
  }
  return `<aside class="index">${groups}</aside>`;
}

const githubSvg = `<svg viewBox="0 0 16 16" width="18" height="18" aria-hidden="true"><path fill="currentColor" d="M8 0C3.58 0 0 3.58 0 8a8 8 0 0 0 5.47 7.59c.4.07.55-.17.55-.38v-1.33c-2.23.48-2.7-1.07-2.7-1.07-.36-.92-.89-1.17-.89-1.17-.73-.5.06-.49.06-.49.8.06 1.23.83 1.23.83.72 1.22 1.88.87 2.34.66.07-.52.28-.87.5-1.07-1.78-.2-3.65-.89-3.65-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82a7.6 7.6 0 0 1 4 0c1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48v2.2c0 .21.15.46.55.38A8 8 0 0 0 16 8c0-4.42-3.58-8-8-8Z"/></svg>`;

const html = `<!doctype html>
<html lang="en-GB">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>moonpug built-ins</title>
<meta name="description" content="Every filter, test, global and statement of the moonpug template language, with an example rendered by the engine itself.">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,500;0,9..144,600;1,9..144,500&family=Inter:wght@500;600&family=JetBrains+Mono:wght@400;500&family=Source+Serif+4:opsz,wght@8..60,400;8..60,600&display=swap" rel="stylesheet">
<link rel="stylesheet" href="assets/site.css">
</head>
<body class="page builtins">
<header class="bar">
  <a class="mark" href="index.html">moon<b>pug</b></a>
  <nav>
    <a href="index.html">Home</a>
    <a href="guide.html">Guide</a>
    <a href="api.html">API</a>
    <a href="builtins.html" aria-current="page">Built-ins</a>
  </nav>
  <a class="github" href="https://github.com/moonbitstack/moonpug" aria-label="moonpug on GitHub">${githubSvg}</a>
  <button id="theme" type="button">Light / dark</button>
</header>
<main class="doc">
  ${asideIndex()}
  <div class="reference">
    <div class="kicker">Reference</div>
    <h1>Built-ins</h1>
    <p class="lede">What a template can reach without being handed anything: the filters, tests and globals, and the statements that shape a page. Every live example below is rendered by the same engine this site is built from &mdash; edit nothing, the output is the real one.</p>
    ${filtersSection()}
    ${testsSection()}
    ${globalsSection()}
    ${statementsSection()}
  </div>
</main>
<footer>moonpug · Apache-2.0 · <a href="https://github.com/moonbitstack/moonpug">github.com/moonbitstack/moonpug</a></footer>
<script type="module" src="assets/page.js"></script>
<script type="module" src="assets/builtins.js"></script>
</body>
</html>
`;

writeFileSync(new URL("../docs/builtins.html", import.meta.url), html);

if (warnings.length) {
  console.error("Refusals in live demos (fix the example):");
  for (const w of warnings) console.error(w);
  process.exit(1);
}
console.log("docs/builtins.html written");
