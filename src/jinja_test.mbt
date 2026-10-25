///|
test "jinja test_api TestExtendedAPI::test_item_and_attribute" {
  jinja(
    source="{{ foo.items()|list }}",
    "{\"foo\": {\"items\": 42}}",
    output="[('items', 42)]",
  )
}

///|
test "jinja test_api TestExtendedAPI::test_item_and_attribute #2" {
  jinja(
    source="{{ foo|attr(\"items\")()|list }}",
    "{\"foo\": {\"items\": 42}}",
    output="[('items', 42)]",
  )
}

///|
test "jinja test_api TestExtendedAPI::test_item_and_attribute #3" {
  jinja(
    source="{{ foo[\"items\"] }}",
    "{\"foo\": {\"items\": 42}}",
    output="42",
  )
}

///|
test "jinja test_api TestUndefined::test_logging_undefined" {
  jinja(source="{{ missing }}", "{}", output="")
}

///|
test "jinja test_api TestUndefined::test_logging_undefined #2" {
  jinja(
    source="{{ missing.attribute }}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
  )
}

///|
test "jinja test_api TestUndefined::test_logging_undefined #3" {
  jinja(source="{{ missing|list }}", "{}", output="[]")
}

///|
test "jinja test_api TestUndefined::test_logging_undefined #4" {
  jinja(source="{{ missing is not defined }}", "{}", output="True")
}

///|
test "jinja test_api TestUndefined::test_logging_undefined #5" {
  jinja(source="{{ foo.missing }}", "{\"foo\": 42}", output="")
}

///|
test "jinja test_api TestUndefined::test_logging_undefined #6" {
  jinja(source="{{ not missing }}", "{}", output="True")
}

///|
test "jinja test_api TestUndefined::test_default_undefined" {
  jinja(source="{{ missing }}", "{}", output="")
}

///|
test "jinja test_api TestUndefined::test_default_undefined #2" {
  jinja(
    source="{{ missing.attribute }}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
  )
}

///|
test "jinja test_api TestUndefined::test_default_undefined #3" {
  jinja(source="{{ missing|list }}", "{}", output="[]")
}

///|
test "jinja test_api TestUndefined::test_default_undefined #4" {
  jinja(source="{{ missing is not defined }}", "{}", output="True")
}

///|
test "jinja test_api TestUndefined::test_default_undefined #5" {
  jinja(source="{{ foo.missing }}", "{\"foo\": 42}", output="")
}

///|
test "jinja test_api TestUndefined::test_default_undefined #6" {
  jinja(source="{{ not missing }}", "{}", output="True")
}

///|
test "jinja test_api TestUndefined::test_default_undefined #7" {
  jinja(
    source="{{ missing - 1}}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
  )
}

///|
test "jinja test_api TestUndefined::test_default_undefined #8" {
  jinja(source="{{ 'foo' in missing }}", "{}", output="False")
}

///|
test "jinja test_api TestUndefined::test_chainable_undefined" {
  jinja(source="{{ missing }}", "{}", output="", policy=Chainable)
}

///|
test "jinja test_api TestUndefined::test_chainable_undefined #2" {
  jinja(source="{{ missing|list }}", "{}", output="[]", policy=Chainable)
}

///|
test "jinja test_api TestUndefined::test_chainable_undefined #3" {
  jinja(
    source="{{ missing is not defined }}",
    "{}",
    output="True",
    policy=Chainable,
  )
}

///|
test "jinja test_api TestUndefined::test_chainable_undefined #4" {
  jinja(
    source="{{ foo.missing }}",
    "{\"foo\": 42}",
    output="",
    policy=Chainable,
  )
}

///|
test "jinja test_api TestUndefined::test_chainable_undefined #5" {
  jinja(source="{{ not missing }}", "{}", output="True", policy=Chainable)
}

///|
test "jinja test_api TestUndefined::test_chainable_undefined #6" {
  jinja(
    source="{{ missing - 1}}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
    policy=Chainable,
  )
}

///|
test "jinja test_api TestUndefined::test_chainable_undefined #7" {
  jinja(source="{{ missing.bar[\"baz\"] }}", "{}", output="", policy=Chainable)
}

///|
test "jinja test_api TestUndefined::test_strict_undefined" {
  jinja(
    source="{{ missing }}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
    policy=Strict,
  )
}

///|
test "jinja test_api TestUndefined::test_strict_undefined #2" {
  jinja(
    source="{{ missing.attribute }}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
    policy=Strict,
  )
}

///|
test "jinja test_api TestUndefined::test_strict_undefined #3" {
  jinja(
    source="{{ missing|list }}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
    policy=Strict,
  )
}

///|
test "jinja test_api TestUndefined::test_strict_undefined #4" {
  jinja(
    source="{{ 'foo' in missing }}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
    policy=Strict,
  )
}

///|
test "jinja test_api TestUndefined::test_strict_undefined #5" {
  jinja(
    source="{{ missing is not defined }}",
    "{}",
    output="True",
    policy=Strict,
  )
}

///|
test "jinja test_api TestUndefined::test_strict_undefined #6" {
  jinja(
    source="{{ foo.missing }}",
    "{\"foo\": 42}",
    error="UndefinedError: 'int object' has no attribute 'missing'",
    policy=Strict,
  )
}

///|
test "jinja test_api TestUndefined::test_strict_undefined #7" {
  jinja(
    source="{{ not missing }}",
    "{}",
    error="UndefinedError: 'missing' is undefined",
    policy=Strict,
  )
}

///|
test "jinja test_api TestUndefined::test_strict_undefined #8" {
  jinja(
    source="{{ missing|default(\"default\", true) }}",
    "{}",
    output="default",
    policy=Strict,
  )
}

///|
test "jinja test_api TestUndefined::test_strict_undefined #9" {
  jinja(source="{{ \"foo\" if false }}", "{}", output="", policy=Strict)
}

///|
test "jinja test_api TestUndefined::test_indexing_gives_undefined" {
  jinja(
    source="{{ var[42].foo }}",
    "{\"var\": 0}",
    error="UndefinedError: int object has no element 42",
  )
}

///|
test "jinja test_async TestAsyncIncludes::test_context_include_with_overrides" {
  jinja(
    name="main",
    "{}",
    output="123",
    templates="{\"main\": \"{% for item in [1, 2, 3] %}{% include 'item' %}{% endfor %}\", \"item\": \"{{ item }}\"}",
  )
}

///|
test "jinja test_compile test_undefined_import_curly_name" {
  jinja(
    name="{bad}",
    "{}",
    error="UndefinedError: the template 'macro' (imported on line 1 in '{bad}') does not export the requested name 'm'",
    templates="{\"{bad}\": \"{% from 'macro' import m %}{{ m() }}\", \"macro\": \"\"}",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_simple" {
  jinja(
    source="{% for item in seq %}{{ item }}{% endfor %}",
    "{\"seq\": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]}",
    output="0123456789",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_else" {
  jinja(
    source="{% for item in seq %}XXX{% else %}...{% endfor %}",
    "{}",
    output="...",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_else_scoping_item" {
  jinja(
    source="{% for item in [] %}{% else %}{{ item }}{% endfor %}",
    "{\"item\": 42}",
    output="42",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_empty_blocks" {
  jinja(
    source="<{% for item in seq %}{% else %}{% endfor %}>",
    "{}",
    output="<>",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_context_vars" {
  jinja(
    source="{% for item in seq -%}\n            {{ loop.index }}|{{ loop.index0 }}|{{ loop.revindex }}|{{\n                loop.revindex0 }}|{{ loop.first }}|{{ loop.last }}|{{\n               loop.length }}###{% endfor %}",
    "{\"seq\": [42, 24]}",
    output="1|0|2|1|True|False|2###2|1|1|0|False|True|2###",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_lookaround" {
  jinja(
    source="{% for item in seq -%}\n            {{ loop.previtem|default('x') }}-{{ item }}-{{\n            loop.nextitem|default('x') }}|\n        {%- endfor %}",
    "{\"seq\": [0, 1, 2, 3]}",
    output="x-0-1|0-1-2|1-2-3|2-3-x|",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_changed" {
  jinja(
    source="{% for item in seq -%}\n            {{ loop.changed(item) }},\n        {%- endfor %}",
    "{\"seq\": [null, null, 1, 2, 2, 3, 4, 4, 4]}",
    output="True,False,True,True,False,True,True,False,False,",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_scope" {
  jinja(
    source="{% for item in seq %}{% endfor %}{{ item }}",
    "{\"seq\": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]}",
    output="",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_noniter" {
  jinja(
    source="{% for item in none %}...{% endfor %}",
    "{}",
    error="TypeError: 'NoneType' object is not iterable",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_recursive" {
  jinja(
    source="{% for item in seq recursive -%}\n            [{{ item.a }}{% if item.b %}<{{ loop(item.b) }}>{% endif %}]\n        {%- endfor %}",
    "{\"seq\": [{\"a\": 1, \"b\": [{\"a\": 1}, {\"a\": 2}]}, {\"a\": 2, \"b\": [{\"a\": 1}, {\"a\": 2}]}, {\"a\": 3, \"b\": [{\"a\": \"a\"}]}]}",
    output="[1<[1][2]>][2<[1][2]>][3<[a]>]",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_recursive_lookaround" {
  jinja(
    source="{% for item in seq recursive -%}\n            [{{ loop.previtem.a if loop.previtem is defined else 'x' }}.{{\n            item.a }}.{{ loop.nextitem.a if loop.nextitem is defined else 'x'\n            }}{% if item.b %}<{{ loop(item.b) }}>{% endif %}]\n        {%- endfor %}",
    "{\"seq\": [{\"a\": 1, \"b\": [{\"a\": 1}, {\"a\": 2}]}, {\"a\": 2, \"b\": [{\"a\": 1}, {\"a\": 2}]}, {\"a\": 3, \"b\": [{\"a\": \"a\"}]}]}",
    output="[x.1.2<[x.1.2][1.2.x]>][1.2.3<[x.1.2][1.2.x]>][2.3.x<[x.a.x]>]",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_recursive_depth0" {
  jinja(
    source="{% for item in seq recursive -%}\n        [{{ loop.depth0 }}:{{ item.a }}{% if item.b %}<{{ loop(item.b) }}>{% endif %}]\n        {%- endfor %}",
    "{\"seq\": [{\"a\": 1, \"b\": [{\"a\": 1}, {\"a\": 2}]}, {\"a\": 2, \"b\": [{\"a\": 1}, {\"a\": 2}]}, {\"a\": 3, \"b\": [{\"a\": \"a\"}]}]}",
    output="[0:1<[1:1][1:2]>][0:2<[1:1][1:2]>][0:3<[1:a]>]",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_recursive_depth" {
  jinja(
    source="{% for item in seq recursive -%}\n        [{{ loop.depth }}:{{ item.a }}{% if item.b %}<{{ loop(item.b) }}>{% endif %}]\n        {%- endfor %}",
    "{\"seq\": [{\"a\": 1, \"b\": [{\"a\": 1}, {\"a\": 2}]}, {\"a\": 2, \"b\": [{\"a\": 1}, {\"a\": 2}]}, {\"a\": 3, \"b\": [{\"a\": \"a\"}]}]}",
    output="[1:1<[2:1][2:2]>][1:2<[2:1][2:2]>][1:3<[2:a]>]",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_looploop" {
  jinja(
    source="{% for row in table %}\n            {%- set rowloop = loop -%}\n            {% for cell in row -%}\n                [{{ rowloop.index }}|{{ loop.index }}]\n            {%- endfor %}\n        {%- endfor %}",
    "{\"table\": [\"ab\", \"cd\"]}",
    output="[1|1][1|2][2|1][2|2]",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_loop_errors" {
  jinja(
    source="{% for item in [1] if loop.index\n                                      == 0 %}...{% endfor %}",
    "{}",
    error="UndefinedError: 'loop' is undefined",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_loop_errors #2" {
  jinja(
    source="{% for item in [] %}...{% else\n            %}{{ loop }}{% endfor %}",
    "{}",
    output="",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_loop_filter" {
  jinja(
    source="{% for item in range(10) if item is even %}[{{ item }}]{% endfor %}",
    "{}",
    output="[0][2][4][6][8]",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_loop_filter #2" {
  jinja(
    source="\n            {%- for item in range(10) if item is even %}[{{\n                loop.index }}:{{ item }}]{% endfor %}",
    "{}",
    output="[1:0][2:2][3:4][4:6][5:8]",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_scoped_loop_var" {
  jinja(
    source="{% for x in seq %}{{ loop.first }}{% for y in seq %}{% endfor %}{% endfor %}",
    "{\"seq\": \"ab\"}",
    output="TrueFalse",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_scoped_loop_var #2" {
  jinja(
    source="{% for x in seq %}{% for y in seq %}{{ loop.first }}{% endfor %}{% endfor %}",
    "{\"seq\": \"ab\"}",
    output="TrueFalseTrueFalse",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_recursive_empty_loop_iter" {
  jinja(
    source="\n        {%- for item in foo recursive -%}{%- endfor -%}\n        ",
    "{\"foo\": []}",
    output="",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_call_in_loop" {
  jinja(
    source="\n        {%- macro do_something() -%}\n            [{{ caller() }}]\n        {%- endmacro %}\n\n        {%- for i in [1, 2, 3] %}\n            {%- call do_something() -%}\n                {{ i }}\n            {%- endcall %}\n        {%- endfor -%}\n        ",
    "{}",
    output="[1][2][3]",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_unpacking" {
  jinja(
    source="{% for a, b, c in [[1, 2, 3]] %}{{ a }}|{{ b }}|{{ c }}{% endfor %}",
    "{}",
    output="1|2|3",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_intended_scoping_with_set" {
  jinja(
    source="{% for item in seq %}{{ x }}{% set x = item %}{{ x }}{% endfor %}",
    "{\"x\": 0, \"seq\": [1, 2, 3]}",
    output="010203",
  )
}

///|
test "jinja test_core_tags TestForLoop::test_intended_scoping_with_set #2" {
  jinja(
    source="{% set x = 9 %}{% for item in seq %}{{ x }}{% set x = item %}{{ x }}{% endfor %}",
    "{\"x\": 0, \"seq\": [1, 2, 3]}",
    output="919293",
  )
}

///|
test "jinja test_core_tags TestIfCondition::test_simple" {
  jinja(source="{% if true %}...{% endif %}", "{}", output="...")
}

///|
test "jinja test_core_tags TestIfCondition::test_elif" {
  jinja(
    source="{% if false %}XXX{% elif true\n            %}...{% else %}XXX{% endif %}",
    "{}",
    output="...",
  )
}

///|
test "jinja test_core_tags TestIfCondition::test_elif_deep" {
  jinja(
    source="{% if a == 0 %}0{% elif a == 1 %}1\n{% elif a == 2 %}2\n{% elif a == 3 %}3\n{% elif a == 4 %}4\n{% elif a == 5 %}5\n{% elif a == 6 %}6\n{% elif a == 7 %}7\n{% elif a == 8 %}8\n{% elif a == 9 %}9\n{% elif a == 10 %}10\n{% elif a == 11 %}11\n{% elif a == 12 %}12\n{% elif a == 13 %}13\n{% elif a == 14 %}14\n{% elif a == 15 %}15\n{% elif a == 16 %}16\n{% elif a == 17 %}17\n{% elif a == 18 %}18\n{% elif a == 19 %}19\n{% elif a == 20 %}20\n{% elif a == 21 %}21\n{% elif a == 22 %}22\n{% elif a == 23 %}23\n{% elif a == 24 %}24\n{% elif a == 25 %}25\n{% elif a == 26 %}26\n{% elif a == 27 %}27\n{% elif a == 28 %}28\n{% elif a == 29 %}29\n{% elif a == 30 %}30\n{% elif a == 31 %}31\n{% elif a == 32 %}32\n{% elif a == 33 %}33\n{% elif a == 34 %}34\n{% elif a == 35 %}35\n{% elif a == 36 %}36\n{% elif a == 37 %}37\n{% elif a == 38 %}38\n{% elif a == 39 %}39\n{% elif a == 40 %}40\n{% elif a == 41 %}41\n{% elif a == 42 %}42\n{% elif a == 43 %}43\n{% elif a == 44 %}44\n{% elif a == 45 %}45\n{% elif a == 46 %}46\n{% elif a == 47 %}47\n{% elif a == 48 %}48\n{% elif a == 49 %}49\n{% elif a == 50 %}50\n{% elif a == 51 %}51\n{% elif a == 52 %}52\n{% elif a == 53 %}53\n{% elif a == 54 %}54\n{% elif a == 55 %}55\n{% elif a == 56 %}56\n{% elif a == 57 %}57\n{% elif a == 58 %}58\n{% elif a == 59 %}59\n{% elif a == 60 %}60\n{% elif a == 61 %}61\n{% elif a == 62 %}62\n{% elif a == 63 %}63\n{% elif a == 64 %}64\n{% elif a == 65 %}65\n{% elif a == 66 %}66\n{% elif a == 67 %}67\n{% elif a == 68 %}68\n{% elif a == 69 %}69\n{% elif a == 70 %}70\n{% elif a == 71 %}71\n{% elif a == 72 %}72\n{% elif a == 73 %}73\n{% elif a == 74 %}74\n{% elif a == 75 %}75\n{% elif a == 76 %}76\n{% elif a == 77 %}77\n{% elif a == 78 %}78\n{% elif a == 79 %}79\n{% elif a == 80 %}80\n{% elif a == 81 %}81\n{% elif a == 82 %}82\n{% elif a == 83 %}83\n{% elif a == 84 %}84\n{% elif a == 85 %}85\n{% elif a == 86 %}86\n{% elif a == 87 %}87\n{% elif a == 88 %}88\n{% elif a == 89 %}89\n{% elif a == 90 %}90\n{% elif a == 91 %}91\n{% elif a == 92 %}92\n{% elif a == 93 %}93\n{% elif a == 94 %}94\n{% elif a == 95 %}95\n{% elif a == 96 %}96\n{% elif a == 97 %}97\n{% elif a == 98 %}98\n{% elif a == 99 %}99\n{% elif a == 100 %}100\n{% elif a == 101 %}101\n{% elif a == 102 %}102\n{% elif a == 103 %}103\n{% elif a == 104 %}104\n{% elif a == 105 %}105\n{% elif a == 106 %}106\n{% elif a == 107 %}107\n{% elif a == 108 %}108\n{% elif a == 109 %}109\n{% elif a == 110 %}110\n{% elif a == 111 %}111\n{% elif a == 112 %}112\n{% elif a == 113 %}113\n{% elif a == 114 %}114\n{% elif a == 115 %}115\n{% elif a == 116 %}116\n{% elif a == 117 %}117\n{% elif a == 118 %}118\n{% elif a == 119 %}119\n{% elif a == 120 %}120\n{% elif a == 121 %}121\n{% elif a == 122 %}122\n{% elif a == 123 %}123\n{% elif a == 124 %}124\n{% elif a == 125 %}125\n{% elif a == 126 %}126\n{% elif a == 127 %}127\n{% elif a == 128 %}128\n{% elif a == 129 %}129\n{% elif a == 130 %}130\n{% elif a == 131 %}131\n{% elif a == 132 %}132\n{% elif a == 133 %}133\n{% elif a == 134 %}134\n{% elif a == 135 %}135\n{% elif a == 136 %}136\n{% elif a == 137 %}137\n{% elif a == 138 %}138\n{% elif a == 139 %}139\n{% elif a == 140 %}140\n{% elif a == 141 %}141\n{% elif a == 142 %}142\n{% elif a == 143 %}143\n{% elif a == 144 %}144\n{% elif a == 145 %}145\n{% elif a == 146 %}146\n{% elif a == 147 %}147\n{% elif a == 148 %}148\n{% elif a == 149 %}149\n{% elif a == 150 %}150\n{% elif a == 151 %}151\n{% elif a == 152 %}152\n{% elif a == 153 %}153\n{% elif a == 154 %}154\n{% elif a == 155 %}155\n{% elif a == 156 %}156\n{% elif a == 157 %}157\n{% elif a == 158 %}158\n{% elif a == 159 %}159\n{% elif a == 160 %}160\n{% elif a == 161 %}161\n{% elif a == 162 %}162\n{% elif a == 163 %}163\n{% elif a == 164 %}164\n{% elif a == 165 %}165\n{% elif a == 166 %}166\n{% elif a == 167 %}167\n{% elif a == 168 %}168\n{% elif a == 169 %}169\n{% elif a == 170 %}170\n{% elif a == 171 %}171\n{% elif a == 172 %}172\n{% elif a == 173 %}173\n{% elif a == 174 %}174\n{% elif a == 175 %}175\n{% elif a == 176 %}176\n{% elif a == 177 %}177\n{% elif a == 178 %}178\n{% elif a == 179 %}179\n{% elif a == 180 %}180\n{% elif a == 181 %}181\n{% elif a == 182 %}182\n{% elif a == 183 %}183\n{% elif a == 184 %}184\n{% elif a == 185 %}185\n{% elif a == 186 %}186\n{% elif a == 187 %}187\n{% elif a == 188 %}188\n{% elif a == 189 %}189\n{% elif a == 190 %}190\n{% elif a == 191 %}191\n{% elif a == 192 %}192\n{% elif a == 193 %}193\n{% elif a == 194 %}194\n{% elif a == 195 %}195\n{% elif a == 196 %}196\n{% elif a == 197 %}197\n{% elif a == 198 %}198\n{% elif a == 199 %}199\n{% elif a == 200 %}200\n{% elif a == 201 %}201\n{% elif a == 202 %}202\n{% elif a == 203 %}203\n{% elif a == 204 %}204\n{% elif a == 205 %}205\n{% elif a == 206 %}206\n{% elif a == 207 %}207\n{% elif a == 208 %}208\n{% elif a == 209 %}209\n{% elif a == 210 %}210\n{% elif a == 211 %}211\n{% elif a == 212 %}212\n{% elif a == 213 %}213\n{% elif a == 214 %}214\n{% elif a == 215 %}215\n{% elif a == 216 %}216\n{% elif a == 217 %}217\n{% elif a == 218 %}218\n{% elif a == 219 %}219\n{% elif a == 220 %}220\n{% elif a == 221 %}221\n{% elif a == 222 %}222\n{% elif a == 223 %}223\n{% elif a == 224 %}224\n{% elif a == 225 %}225\n{% elif a == 226 %}226\n{% elif a == 227 %}227\n{% elif a == 228 %}228\n{% elif a == 229 %}229\n{% elif a == 230 %}230\n{% elif a == 231 %}231\n{% elif a == 232 %}232\n{% elif a == 233 %}233\n{% elif a == 234 %}234\n{% elif a == 235 %}235\n{% elif a == 236 %}236\n{% elif a == 237 %}237\n{% elif a == 238 %}238\n{% elif a == 239 %}239\n{% elif a == 240 %}240\n{% elif a == 241 %}241\n{% elif a == 242 %}242\n{% elif a == 243 %}243\n{% elif a == 244 %}244\n{% elif a == 245 %}245\n{% elif a == 246 %}246\n{% elif a == 247 %}247\n{% elif a == 248 %}248\n{% elif a == 249 %}249\n{% elif a == 250 %}250\n{% elif a == 251 %}251\n{% elif a == 252 %}252\n{% elif a == 253 %}253\n{% elif a == 254 %}254\n{% elif a == 255 %}255\n{% elif a == 256 %}256\n{% elif a == 257 %}257\n{% elif a == 258 %}258\n{% elif a == 259 %}259\n{% elif a == 260 %}260\n{% elif a == 261 %}261\n{% elif a == 262 %}262\n{% elif a == 263 %}263\n{% elif a == 264 %}264\n{% elif a == 265 %}265\n{% elif a == 266 %}266\n{% elif a == 267 %}267\n{% elif a == 268 %}268\n{% elif a == 269 %}269\n{% elif a == 270 %}270\n{% elif a == 271 %}271\n{% elif a == 272 %}272\n{% elif a == 273 %}273\n{% elif a == 274 %}274\n{% elif a == 275 %}275\n{% elif a == 276 %}276\n{% elif a == 277 %}277\n{% elif a == 278 %}278\n{% elif a == 279 %}279\n{% elif a == 280 %}280\n{% elif a == 281 %}281\n{% elif a == 282 %}282\n{% elif a == 283 %}283\n{% elif a == 284 %}284\n{% elif a == 285 %}285\n{% elif a == 286 %}286\n{% elif a == 287 %}287\n{% elif a == 288 %}288\n{% elif a == 289 %}289\n{% elif a == 290 %}290\n{% elif a == 291 %}291\n{% elif a == 292 %}292\n{% elif a == 293 %}293\n{% elif a == 294 %}294\n{% elif a == 295 %}295\n{% elif a == 296 %}296\n{% elif a == 297 %}297\n{% elif a == 298 %}298\n{% elif a == 299 %}299\n{% elif a == 300 %}300\n{% elif a == 301 %}301\n{% elif a == 302 %}302\n{% elif a == 303 %}303\n{% elif a == 304 %}304\n{% elif a == 305 %}305\n{% elif a == 306 %}306\n{% elif a == 307 %}307\n{% elif a == 308 %}308\n{% elif a == 309 %}309\n{% elif a == 310 %}310\n{% elif a == 311 %}311\n{% elif a == 312 %}312\n{% elif a == 313 %}313\n{% elif a == 314 %}314\n{% elif a == 315 %}315\n{% elif a == 316 %}316\n{% elif a == 317 %}317\n{% elif a == 318 %}318\n{% elif a == 319 %}319\n{% elif a == 320 %}320\n{% elif a == 321 %}321\n{% elif a == 322 %}322\n{% elif a == 323 %}323\n{% elif a == 324 %}324\n{% elif a == 325 %}325\n{% elif a == 326 %}326\n{% elif a == 327 %}327\n{% elif a == 328 %}328\n{% elif a == 329 %}329\n{% elif a == 330 %}330\n{% elif a == 331 %}331\n{% elif a == 332 %}332\n{% elif a == 333 %}333\n{% elif a == 334 %}334\n{% elif a == 335 %}335\n{% elif a == 336 %}336\n{% elif a == 337 %}337\n{% elif a == 338 %}338\n{% elif a == 339 %}339\n{% elif a == 340 %}340\n{% elif a == 341 %}341\n{% elif a == 342 %}342\n{% elif a == 343 %}343\n{% elif a == 344 %}344\n{% elif a == 345 %}345\n{% elif a == 346 %}346\n{% elif a == 347 %}347\n{% elif a == 348 %}348\n{% elif a == 349 %}349\n{% elif a == 350 %}350\n{% elif a == 351 %}351\n{% elif a == 352 %}352\n{% elif a == 353 %}353\n{% elif a == 354 %}354\n{% elif a == 355 %}355\n{% elif a == 356 %}356\n{% elif a == 357 %}357\n{% elif a == 358 %}358\n{% elif a == 359 %}359\n{% elif a == 360 %}360\n{% elif a == 361 %}361\n{% elif a == 362 %}362\n{% elif a == 363 %}363\n{% elif a == 364 %}364\n{% elif a == 365 %}365\n{% elif a == 366 %}366\n{% elif a == 367 %}367\n{% elif a == 368 %}368\n{% elif a == 369 %}369\n{% elif a == 370 %}370\n{% elif a == 371 %}371\n{% elif a == 372 %}372\n{% elif a == 373 %}373\n{% elif a == 374 %}374\n{% elif a == 375 %}375\n{% elif a == 376 %}376\n{% elif a == 377 %}377\n{% elif a == 378 %}378\n{% elif a == 379 %}379\n{% elif a == 380 %}380\n{% elif a == 381 %}381\n{% elif a == 382 %}382\n{% elif a == 383 %}383\n{% elif a == 384 %}384\n{% elif a == 385 %}385\n{% elif a == 386 %}386\n{% elif a == 387 %}387\n{% elif a == 388 %}388\n{% elif a == 389 %}389\n{% elif a == 390 %}390\n{% elif a == 391 %}391\n{% elif a == 392 %}392\n{% elif a == 393 %}393\n{% elif a == 394 %}394\n{% elif a == 395 %}395\n{% elif a == 396 %}396\n{% elif a == 397 %}397\n{% elif a == 398 %}398\n{% elif a == 399 %}399\n{% elif a == 400 %}400\n{% elif a == 401 %}401\n{% elif a == 402 %}402\n{% elif a == 403 %}403\n{% elif a == 404 %}404\n{% elif a == 405 %}405\n{% elif a == 406 %}406\n{% elif a == 407 %}407\n{% elif a == 408 %}408\n{% elif a == 409 %}409\n{% elif a == 410 %}410\n{% elif a == 411 %}411\n{% elif a == 412 %}412\n{% elif a == 413 %}413\n{% elif a == 414 %}414\n{% elif a == 415 %}415\n{% elif a == 416 %}416\n{% elif a == 417 %}417\n{% elif a == 418 %}418\n{% elif a == 419 %}419\n{% elif a == 420 %}420\n{% elif a == 421 %}421\n{% elif a == 422 %}422\n{% elif a == 423 %}423\n{% elif a == 424 %}424\n{% elif a == 425 %}425\n{% elif a == 426 %}426\n{% elif a == 427 %}427\n{% elif a == 428 %}428\n{% elif a == 429 %}429\n{% elif a == 430 %}430\n{% elif a == 431 %}431\n{% elif a == 432 %}432\n{% elif a == 433 %}433\n{% elif a == 434 %}434\n{% elif a == 435 %}435\n{% elif a == 436 %}436\n{% elif a == 437 %}437\n{% elif a == 438 %}438\n{% elif a == 439 %}439\n{% elif a == 440 %}440\n{% elif a == 441 %}441\n{% elif a == 442 %}442\n{% elif a == 443 %}443\n{% elif a == 444 %}444\n{% elif a == 445 %}445\n{% elif a == 446 %}446\n{% elif a == 447 %}447\n{% elif a == 448 %}448\n{% elif a == 449 %}449\n{% elif a == 450 %}450\n{% elif a == 451 %}451\n{% elif a == 452 %}452\n{% elif a == 453 %}453\n{% elif a == 454 %}454\n{% elif a == 455 %}455\n{% elif a == 456 %}456\n{% elif a == 457 %}457\n{% elif a == 458 %}458\n{% elif a == 459 %}459\n{% elif a == 460 %}460\n{% elif a == 461 %}461\n{% elif a == 462 %}462\n{% elif a == 463 %}463\n{% elif a == 464 %}464\n{% elif a == 465 %}465\n{% elif a == 466 %}466\n{% elif a == 467 %}467\n{% elif a == 468 %}468\n{% elif a == 469 %}469\n{% elif a == 470 %}470\n{% elif a == 471 %}471\n{% elif a == 472 %}472\n{% elif a == 473 %}473\n{% elif a == 474 %}474\n{% elif a == 475 %}475\n{% elif a == 476 %}476\n{% elif a == 477 %}477\n{% elif a == 478 %}478\n{% elif a == 479 %}479\n{% elif a == 480 %}480\n{% elif a == 481 %}481\n{% elif a == 482 %}482\n{% elif a == 483 %}483\n{% elif a == 484 %}484\n{% elif a == 485 %}485\n{% elif a == 486 %}486\n{% elif a == 487 %}487\n{% elif a == 488 %}488\n{% elif a == 489 %}489\n{% elif a == 490 %}490\n{% elif a == 491 %}491\n{% elif a == 492 %}492\n{% elif a == 493 %}493\n{% elif a == 494 %}494\n{% elif a == 495 %}495\n{% elif a == 496 %}496\n{% elif a == 497 %}497\n{% elif a == 498 %}498\n{% elif a == 499 %}499\n{% elif a == 500 %}500\n{% elif a == 501 %}501\n{% elif a == 502 %}502\n{% elif a == 503 %}503\n{% elif a == 504 %}504\n{% elif a == 505 %}505\n{% elif a == 506 %}506\n{% elif a == 507 %}507\n{% elif a == 508 %}508\n{% elif a == 509 %}509\n{% elif a == 510 %}510\n{% elif a == 511 %}511\n{% elif a == 512 %}512\n{% elif a == 513 %}513\n{% elif a == 514 %}514\n{% elif a == 515 %}515\n{% elif a == 516 %}516\n{% elif a == 517 %}517\n{% elif a == 518 %}518\n{% elif a == 519 %}519\n{% elif a == 520 %}520\n{% elif a == 521 %}521\n{% elif a == 522 %}522\n{% elif a == 523 %}523\n{% elif a == 524 %}524\n{% elif a == 525 %}525\n{% elif a == 526 %}526\n{% elif a == 527 %}527\n{% elif a == 528 %}528\n{% elif a == 529 %}529\n{% elif a == 530 %}530\n{% elif a == 531 %}531\n{% elif a == 532 %}532\n{% elif a == 533 %}533\n{% elif a == 534 %}534\n{% elif a == 535 %}535\n{% elif a == 536 %}536\n{% elif a == 537 %}537\n{% elif a == 538 %}538\n{% elif a == 539 %}539\n{% elif a == 540 %}540\n{% elif a == 541 %}541\n{% elif a == 542 %}542\n{% elif a == 543 %}543\n{% elif a == 544 %}544\n{% elif a == 545 %}545\n{% elif a == 546 %}546\n{% elif a == 547 %}547\n{% elif a == 548 %}548\n{% elif a == 549 %}549\n{% elif a == 550 %}550\n{% elif a == 551 %}551\n{% elif a == 552 %}552\n{% elif a == 553 %}553\n{% elif a == 554 %}554\n{% elif a == 555 %}555\n{% elif a == 556 %}556\n{% elif a == 557 %}557\n{% elif a == 558 %}558\n{% elif a == 559 %}559\n{% elif a == 560 %}560\n{% elif a == 561 %}561\n{% elif a == 562 %}562\n{% elif a == 563 %}563\n{% elif a == 564 %}564\n{% elif a == 565 %}565\n{% elif a == 566 %}566\n{% elif a == 567 %}567\n{% elif a == 568 %}568\n{% elif a == 569 %}569\n{% elif a == 570 %}570\n{% elif a == 571 %}571\n{% elif a == 572 %}572\n{% elif a == 573 %}573\n{% elif a == 574 %}574\n{% elif a == 575 %}575\n{% elif a == 576 %}576\n{% elif a == 577 %}577\n{% elif a == 578 %}578\n{% elif a == 579 %}579\n{% elif a == 580 %}580\n{% elif a == 581 %}581\n{% elif a == 582 %}582\n{% elif a == 583 %}583\n{% elif a == 584 %}584\n{% elif a == 585 %}585\n{% elif a == 586 %}586\n{% elif a == 587 %}587\n{% elif a == 588 %}588\n{% elif a == 589 %}589\n{% elif a == 590 %}590\n{% elif a == 591 %}591\n{% elif a == 592 %}592\n{% elif a == 593 %}593\n{% elif a == 594 %}594\n{% elif a == 595 %}595\n{% elif a == 596 %}596\n{% elif a == 597 %}597\n{% elif a == 598 %}598\n{% elif a == 599 %}599\n{% elif a == 600 %}600\n{% elif a == 601 %}601\n{% elif a == 602 %}602\n{% elif a == 603 %}603\n{% elif a == 604 %}604\n{% elif a == 605 %}605\n{% elif a == 606 %}606\n{% elif a == 607 %}607\n{% elif a == 608 %}608\n{% elif a == 609 %}609\n{% elif a == 610 %}610\n{% elif a == 611 %}611\n{% elif a == 612 %}612\n{% elif a == 613 %}613\n{% elif a == 614 %}614\n{% elif a == 615 %}615\n{% elif a == 616 %}616\n{% elif a == 617 %}617\n{% elif a == 618 %}618\n{% elif a == 619 %}619\n{% elif a == 620 %}620\n{% elif a == 621 %}621\n{% elif a == 622 %}622\n{% elif a == 623 %}623\n{% elif a == 624 %}624\n{% elif a == 625 %}625\n{% elif a == 626 %}626\n{% elif a == 627 %}627\n{% elif a == 628 %}628\n{% elif a == 629 %}629\n{% elif a == 630 %}630\n{% elif a == 631 %}631\n{% elif a == 632 %}632\n{% elif a == 633 %}633\n{% elif a == 634 %}634\n{% elif a == 635 %}635\n{% elif a == 636 %}636\n{% elif a == 637 %}637\n{% elif a == 638 %}638\n{% elif a == 639 %}639\n{% elif a == 640 %}640\n{% elif a == 641 %}641\n{% elif a == 642 %}642\n{% elif a == 643 %}643\n{% elif a == 644 %}644\n{% elif a == 645 %}645\n{% elif a == 646 %}646\n{% elif a == 647 %}647\n{% elif a == 648 %}648\n{% elif a == 649 %}649\n{% elif a == 650 %}650\n{% elif a == 651 %}651\n{% elif a == 652 %}652\n{% elif a == 653 %}653\n{% elif a == 654 %}654\n{% elif a == 655 %}655\n{% elif a == 656 %}656\n{% elif a == 657 %}657\n{% elif a == 658 %}658\n{% elif a == 659 %}659\n{% elif a == 660 %}660\n{% elif a == 661 %}661\n{% elif a == 662 %}662\n{% elif a == 663 %}663\n{% elif a == 664 %}664\n{% elif a == 665 %}665\n{% elif a == 666 %}666\n{% elif a == 667 %}667\n{% elif a == 668 %}668\n{% elif a == 669 %}669\n{% elif a == 670 %}670\n{% elif a == 671 %}671\n{% elif a == 672 %}672\n{% elif a == 673 %}673\n{% elif a == 674 %}674\n{% elif a == 675 %}675\n{% elif a == 676 %}676\n{% elif a == 677 %}677\n{% elif a == 678 %}678\n{% elif a == 679 %}679\n{% elif a == 680 %}680\n{% elif a == 681 %}681\n{% elif a == 682 %}682\n{% elif a == 683 %}683\n{% elif a == 684 %}684\n{% elif a == 685 %}685\n{% elif a == 686 %}686\n{% elif a == 687 %}687\n{% elif a == 688 %}688\n{% elif a == 689 %}689\n{% elif a == 690 %}690\n{% elif a == 691 %}691\n{% elif a == 692 %}692\n{% elif a == 693 %}693\n{% elif a == 694 %}694\n{% elif a == 695 %}695\n{% elif a == 696 %}696\n{% elif a == 697 %}697\n{% elif a == 698 %}698\n{% elif a == 699 %}699\n{% elif a == 700 %}700\n{% elif a == 701 %}701\n{% elif a == 702 %}702\n{% elif a == 703 %}703\n{% elif a == 704 %}704\n{% elif a == 705 %}705\n{% elif a == 706 %}706\n{% elif a == 707 %}707\n{% elif a == 708 %}708\n{% elif a == 709 %}709\n{% elif a == 710 %}710\n{% elif a == 711 %}711\n{% elif a == 712 %}712\n{% elif a == 713 %}713\n{% elif a == 714 %}714\n{% elif a == 715 %}715\n{% elif a == 716 %}716\n{% elif a == 717 %}717\n{% elif a == 718 %}718\n{% elif a == 719 %}719\n{% elif a == 720 %}720\n{% elif a == 721 %}721\n{% elif a == 722 %}722\n{% elif a == 723 %}723\n{% elif a == 724 %}724\n{% elif a == 725 %}725\n{% elif a == 726 %}726\n{% elif a == 727 %}727\n{% elif a == 728 %}728\n{% elif a == 729 %}729\n{% elif a == 730 %}730\n{% elif a == 731 %}731\n{% elif a == 732 %}732\n{% elif a == 733 %}733\n{% elif a == 734 %}734\n{% elif a == 735 %}735\n{% elif a == 736 %}736\n{% elif a == 737 %}737\n{% elif a == 738 %}738\n{% elif a == 739 %}739\n{% elif a == 740 %}740\n{% elif a == 741 %}741\n{% elif a == 742 %}742\n{% elif a == 743 %}743\n{% elif a == 744 %}744\n{% elif a == 745 %}745\n{% elif a == 746 %}746\n{% elif a == 747 %}747\n{% elif a == 748 %}748\n{% elif a == 749 %}749\n{% elif a == 750 %}750\n{% elif a == 751 %}751\n{% elif a == 752 %}752\n{% elif a == 753 %}753\n{% elif a == 754 %}754\n{% elif a == 755 %}755\n{% elif a == 756 %}756\n{% elif a == 757 %}757\n{% elif a == 758 %}758\n{% elif a == 759 %}759\n{% elif a == 760 %}760\n{% elif a == 761 %}761\n{% elif a == 762 %}762\n{% elif a == 763 %}763\n{% elif a == 764 %}764\n{% elif a == 765 %}765\n{% elif a == 766 %}766\n{% elif a == 767 %}767\n{% elif a == 768 %}768\n{% elif a == 769 %}769\n{% elif a == 770 %}770\n{% elif a == 771 %}771\n{% elif a == 772 %}772\n{% elif a == 773 %}773\n{% elif a == 774 %}774\n{% elif a == 775 %}775\n{% elif a == 776 %}776\n{% elif a == 777 %}777\n{% elif a == 778 %}778\n{% elif a == 779 %}779\n{% elif a == 780 %}780\n{% elif a == 781 %}781\n{% elif a == 782 %}782\n{% elif a == 783 %}783\n{% elif a == 784 %}784\n{% elif a == 785 %}785\n{% elif a == 786 %}786\n{% elif a == 787 %}787\n{% elif a == 788 %}788\n{% elif a == 789 %}789\n{% elif a == 790 %}790\n{% elif a == 791 %}791\n{% elif a == 792 %}792\n{% elif a == 793 %}793\n{% elif a == 794 %}794\n{% elif a == 795 %}795\n{% elif a == 796 %}796\n{% elif a == 797 %}797\n{% elif a == 798 %}798\n{% elif a == 799 %}799\n{% elif a == 800 %}800\n{% elif a == 801 %}801\n{% elif a == 802 %}802\n{% elif a == 803 %}803\n{% elif a == 804 %}804\n{% elif a == 805 %}805\n{% elif a == 806 %}806\n{% elif a == 807 %}807\n{% elif a == 808 %}808\n{% elif a == 809 %}809\n{% elif a == 810 %}810\n{% elif a == 811 %}811\n{% elif a == 812 %}812\n{% elif a == 813 %}813\n{% elif a == 814 %}814\n{% elif a == 815 %}815\n{% elif a == 816 %}816\n{% elif a == 817 %}817\n{% elif a == 818 %}818\n{% elif a == 819 %}819\n{% elif a == 820 %}820\n{% elif a == 821 %}821\n{% elif a == 822 %}822\n{% elif a == 823 %}823\n{% elif a == 824 %}824\n{% elif a == 825 %}825\n{% elif a == 826 %}826\n{% elif a == 827 %}827\n{% elif a == 828 %}828\n{% elif a == 829 %}829\n{% elif a == 830 %}830\n{% elif a == 831 %}831\n{% elif a == 832 %}832\n{% elif a == 833 %}833\n{% elif a == 834 %}834\n{% elif a == 835 %}835\n{% elif a == 836 %}836\n{% elif a == 837 %}837\n{% elif a == 838 %}838\n{% elif a == 839 %}839\n{% elif a == 840 %}840\n{% elif a == 841 %}841\n{% elif a == 842 %}842\n{% elif a == 843 %}843\n{% elif a == 844 %}844\n{% elif a == 845 %}845\n{% elif a == 846 %}846\n{% elif a == 847 %}847\n{% elif a == 848 %}848\n{% elif a == 849 %}849\n{% elif a == 850 %}850\n{% elif a == 851 %}851\n{% elif a == 852 %}852\n{% elif a == 853 %}853\n{% elif a == 854 %}854\n{% elif a == 855 %}855\n{% elif a == 856 %}856\n{% elif a == 857 %}857\n{% elif a == 858 %}858\n{% elif a == 859 %}859\n{% elif a == 860 %}860\n{% elif a == 861 %}861\n{% elif a == 862 %}862\n{% elif a == 863 %}863\n{% elif a == 864 %}864\n{% elif a == 865 %}865\n{% elif a == 866 %}866\n{% elif a == 867 %}867\n{% elif a == 868 %}868\n{% elif a == 869 %}869\n{% elif a == 870 %}870\n{% elif a == 871 %}871\n{% elif a == 872 %}872\n{% elif a == 873 %}873\n{% elif a == 874 %}874\n{% elif a == 875 %}875\n{% elif a == 876 %}876\n{% elif a == 877 %}877\n{% elif a == 878 %}878\n{% elif a == 879 %}879\n{% elif a == 880 %}880\n{% elif a == 881 %}881\n{% elif a == 882 %}882\n{% elif a == 883 %}883\n{% elif a == 884 %}884\n{% elif a == 885 %}885\n{% elif a == 886 %}886\n{% elif a == 887 %}887\n{% elif a == 888 %}888\n{% elif a == 889 %}889\n{% elif a == 890 %}890\n{% elif a == 891 %}891\n{% elif a == 892 %}892\n{% elif a == 893 %}893\n{% elif a == 894 %}894\n{% elif a == 895 %}895\n{% elif a == 896 %}896\n{% elif a == 897 %}897\n{% elif a == 898 %}898\n{% elif a == 899 %}899\n{% elif a == 900 %}900\n{% elif a == 901 %}901\n{% elif a == 902 %}902\n{% elif a == 903 %}903\n{% elif a == 904 %}904\n{% elif a == 905 %}905\n{% elif a == 906 %}906\n{% elif a == 907 %}907\n{% elif a == 908 %}908\n{% elif a == 909 %}909\n{% elif a == 910 %}910\n{% elif a == 911 %}911\n{% elif a == 912 %}912\n{% elif a == 913 %}913\n{% elif a == 914 %}914\n{% elif a == 915 %}915\n{% elif a == 916 %}916\n{% elif a == 917 %}917\n{% elif a == 918 %}918\n{% elif a == 919 %}919\n{% elif a == 920 %}920\n{% elif a == 921 %}921\n{% elif a == 922 %}922\n{% elif a == 923 %}923\n{% elif a == 924 %}924\n{% elif a == 925 %}925\n{% elif a == 926 %}926\n{% elif a == 927 %}927\n{% elif a == 928 %}928\n{% elif a == 929 %}929\n{% elif a == 930 %}930\n{% elif a == 931 %}931\n{% elif a == 932 %}932\n{% elif a == 933 %}933\n{% elif a == 934 %}934\n{% elif a == 935 %}935\n{% elif a == 936 %}936\n{% elif a == 937 %}937\n{% elif a == 938 %}938\n{% elif a == 939 %}939\n{% elif a == 940 %}940\n{% elif a == 941 %}941\n{% elif a == 942 %}942\n{% elif a == 943 %}943\n{% elif a == 944 %}944\n{% elif a == 945 %}945\n{% elif a == 946 %}946\n{% elif a == 947 %}947\n{% elif a == 948 %}948\n{% elif a == 949 %}949\n{% elif a == 950 %}950\n{% elif a == 951 %}951\n{% elif a == 952 %}952\n{% elif a == 953 %}953\n{% elif a == 954 %}954\n{% elif a == 955 %}955\n{% elif a == 956 %}956\n{% elif a == 957 %}957\n{% elif a == 958 %}958\n{% elif a == 959 %}959\n{% elif a == 960 %}960\n{% elif a == 961 %}961\n{% elif a == 962 %}962\n{% elif a == 963 %}963\n{% elif a == 964 %}964\n{% elif a == 965 %}965\n{% elif a == 966 %}966\n{% elif a == 967 %}967\n{% elif a == 968 %}968\n{% elif a == 969 %}969\n{% elif a == 970 %}970\n{% elif a == 971 %}971\n{% elif a == 972 %}972\n{% elif a == 973 %}973\n{% elif a == 974 %}974\n{% elif a == 975 %}975\n{% elif a == 976 %}976\n{% elif a == 977 %}977\n{% elif a == 978 %}978\n{% elif a == 979 %}979\n{% elif a == 980 %}980\n{% elif a == 981 %}981\n{% elif a == 982 %}982\n{% elif a == 983 %}983\n{% elif a == 984 %}984\n{% elif a == 985 %}985\n{% elif a == 986 %}986\n{% elif a == 987 %}987\n{% elif a == 988 %}988\n{% elif a == 989 %}989\n{% elif a == 990 %}990\n{% elif a == 991 %}991\n{% elif a == 992 %}992\n{% elif a == 993 %}993\n{% elif a == 994 %}994\n{% elif a == 995 %}995\n{% elif a == 996 %}996\n{% elif a == 997 %}997\n{% elif a == 998 %}998\n{% elif a == 999 %}999{% else %}x{% endif %}",
    "{\"a\": 0}",
    output="0",
  )
}

///|
test "jinja test_core_tags TestIfCondition::test_elif_deep #2" {
  jinja(
    source="{% if a == 0 %}0{% elif a == 1 %}1\n{% elif a == 2 %}2\n{% elif a == 3 %}3\n{% elif a == 4 %}4\n{% elif a == 5 %}5\n{% elif a == 6 %}6\n{% elif a == 7 %}7\n{% elif a == 8 %}8\n{% elif a == 9 %}9\n{% elif a == 10 %}10\n{% elif a == 11 %}11\n{% elif a == 12 %}12\n{% elif a == 13 %}13\n{% elif a == 14 %}14\n{% elif a == 15 %}15\n{% elif a == 16 %}16\n{% elif a == 17 %}17\n{% elif a == 18 %}18\n{% elif a == 19 %}19\n{% elif a == 20 %}20\n{% elif a == 21 %}21\n{% elif a == 22 %}22\n{% elif a == 23 %}23\n{% elif a == 24 %}24\n{% elif a == 25 %}25\n{% elif a == 26 %}26\n{% elif a == 27 %}27\n{% elif a == 28 %}28\n{% elif a == 29 %}29\n{% elif a == 30 %}30\n{% elif a == 31 %}31\n{% elif a == 32 %}32\n{% elif a == 33 %}33\n{% elif a == 34 %}34\n{% elif a == 35 %}35\n{% elif a == 36 %}36\n{% elif a == 37 %}37\n{% elif a == 38 %}38\n{% elif a == 39 %}39\n{% elif a == 40 %}40\n{% elif a == 41 %}41\n{% elif a == 42 %}42\n{% elif a == 43 %}43\n{% elif a == 44 %}44\n{% elif a == 45 %}45\n{% elif a == 46 %}46\n{% elif a == 47 %}47\n{% elif a == 48 %}48\n{% elif a == 49 %}49\n{% elif a == 50 %}50\n{% elif a == 51 %}51\n{% elif a == 52 %}52\n{% elif a == 53 %}53\n{% elif a == 54 %}54\n{% elif a == 55 %}55\n{% elif a == 56 %}56\n{% elif a == 57 %}57\n{% elif a == 58 %}58\n{% elif a == 59 %}59\n{% elif a == 60 %}60\n{% elif a == 61 %}61\n{% elif a == 62 %}62\n{% elif a == 63 %}63\n{% elif a == 64 %}64\n{% elif a == 65 %}65\n{% elif a == 66 %}66\n{% elif a == 67 %}67\n{% elif a == 68 %}68\n{% elif a == 69 %}69\n{% elif a == 70 %}70\n{% elif a == 71 %}71\n{% elif a == 72 %}72\n{% elif a == 73 %}73\n{% elif a == 74 %}74\n{% elif a == 75 %}75\n{% elif a == 76 %}76\n{% elif a == 77 %}77\n{% elif a == 78 %}78\n{% elif a == 79 %}79\n{% elif a == 80 %}80\n{% elif a == 81 %}81\n{% elif a == 82 %}82\n{% elif a == 83 %}83\n{% elif a == 84 %}84\n{% elif a == 85 %}85\n{% elif a == 86 %}86\n{% elif a == 87 %}87\n{% elif a == 88 %}88\n{% elif a == 89 %}89\n{% elif a == 90 %}90\n{% elif a == 91 %}91\n{% elif a == 92 %}92\n{% elif a == 93 %}93\n{% elif a == 94 %}94\n{% elif a == 95 %}95\n{% elif a == 96 %}96\n{% elif a == 97 %}97\n{% elif a == 98 %}98\n{% elif a == 99 %}99\n{% elif a == 100 %}100\n{% elif a == 101 %}101\n{% elif a == 102 %}102\n{% elif a == 103 %}103\n{% elif a == 104 %}104\n{% elif a == 105 %}105\n{% elif a == 106 %}106\n{% elif a == 107 %}107\n{% elif a == 108 %}108\n{% elif a == 109 %}109\n{% elif a == 110 %}110\n{% elif a == 111 %}111\n{% elif a == 112 %}112\n{% elif a == 113 %}113\n{% elif a == 114 %}114\n{% elif a == 115 %}115\n{% elif a == 116 %}116\n{% elif a == 117 %}117\n{% elif a == 118 %}118\n{% elif a == 119 %}119\n{% elif a == 120 %}120\n{% elif a == 121 %}121\n{% elif a == 122 %}122\n{% elif a == 123 %}123\n{% elif a == 124 %}124\n{% elif a == 125 %}125\n{% elif a == 126 %}126\n{% elif a == 127 %}127\n{% elif a == 128 %}128\n{% elif a == 129 %}129\n{% elif a == 130 %}130\n{% elif a == 131 %}131\n{% elif a == 132 %}132\n{% elif a == 133 %}133\n{% elif a == 134 %}134\n{% elif a == 135 %}135\n{% elif a == 136 %}136\n{% elif a == 137 %}137\n{% elif a == 138 %}138\n{% elif a == 139 %}139\n{% elif a == 140 %}140\n{% elif a == 141 %}141\n{% elif a == 142 %}142\n{% elif a == 143 %}143\n{% elif a == 144 %}144\n{% elif a == 145 %}145\n{% elif a == 146 %}146\n{% elif a == 147 %}147\n{% elif a == 148 %}148\n{% elif a == 149 %}149\n{% elif a == 150 %}150\n{% elif a == 151 %}151\n{% elif a == 152 %}152\n{% elif a == 153 %}153\n{% elif a == 154 %}154\n{% elif a == 155 %}155\n{% elif a == 156 %}156\n{% elif a == 157 %}157\n{% elif a == 158 %}158\n{% elif a == 159 %}159\n{% elif a == 160 %}160\n{% elif a == 161 %}161\n{% elif a == 162 %}162\n{% elif a == 163 %}163\n{% elif a == 164 %}164\n{% elif a == 165 %}165\n{% elif a == 166 %}166\n{% elif a == 167 %}167\n{% elif a == 168 %}168\n{% elif a == 169 %}169\n{% elif a == 170 %}170\n{% elif a == 171 %}171\n{% elif a == 172 %}172\n{% elif a == 173 %}173\n{% elif a == 174 %}174\n{% elif a == 175 %}175\n{% elif a == 176 %}176\n{% elif a == 177 %}177\n{% elif a == 178 %}178\n{% elif a == 179 %}179\n{% elif a == 180 %}180\n{% elif a == 181 %}181\n{% elif a == 182 %}182\n{% elif a == 183 %}183\n{% elif a == 184 %}184\n{% elif a == 185 %}185\n{% elif a == 186 %}186\n{% elif a == 187 %}187\n{% elif a == 188 %}188\n{% elif a == 189 %}189\n{% elif a == 190 %}190\n{% elif a == 191 %}191\n{% elif a == 192 %}192\n{% elif a == 193 %}193\n{% elif a == 194 %}194\n{% elif a == 195 %}195\n{% elif a == 196 %}196\n{% elif a == 197 %}197\n{% elif a == 198 %}198\n{% elif a == 199 %}199\n{% elif a == 200 %}200\n{% elif a == 201 %}201\n{% elif a == 202 %}202\n{% elif a == 203 %}203\n{% elif a == 204 %}204\n{% elif a == 205 %}205\n{% elif a == 206 %}206\n{% elif a == 207 %}207\n{% elif a == 208 %}208\n{% elif a == 209 %}209\n{% elif a == 210 %}210\n{% elif a == 211 %}211\n{% elif a == 212 %}212\n{% elif a == 213 %}213\n{% elif a == 214 %}214\n{% elif a == 215 %}215\n{% elif a == 216 %}216\n{% elif a == 217 %}217\n{% elif a == 218 %}218\n{% elif a == 219 %}219\n{% elif a == 220 %}220\n{% elif a == 221 %}221\n{% elif a == 222 %}222\n{% elif a == 223 %}223\n{% elif a == 224 %}224\n{% elif a == 225 %}225\n{% elif a == 226 %}226\n{% elif a == 227 %}227\n{% elif a == 228 %}228\n{% elif a == 229 %}229\n{% elif a == 230 %}230\n{% elif a == 231 %}231\n{% elif a == 232 %}232\n{% elif a == 233 %}233\n{% elif a == 234 %}234\n{% elif a == 235 %}235\n{% elif a == 236 %}236\n{% elif a == 237 %}237\n{% elif a == 238 %}238\n{% elif a == 239 %}239\n{% elif a == 240 %}240\n{% elif a == 241 %}241\n{% elif a == 242 %}242\n{% elif a == 243 %}243\n{% elif a == 244 %}244\n{% elif a == 245 %}245\n{% elif a == 246 %}246\n{% elif a == 247 %}247\n{% elif a == 248 %}248\n{% elif a == 249 %}249\n{% elif a == 250 %}250\n{% elif a == 251 %}251\n{% elif a == 252 %}252\n{% elif a == 253 %}253\n{% elif a == 254 %}254\n{% elif a == 255 %}255\n{% elif a == 256 %}256\n{% elif a == 257 %}257\n{% elif a == 258 %}258\n{% elif a == 259 %}259\n{% elif a == 260 %}260\n{% elif a == 261 %}261\n{% elif a == 262 %}262\n{% elif a == 263 %}263\n{% elif a == 264 %}264\n{% elif a == 265 %}265\n{% elif a == 266 %}266\n{% elif a == 267 %}267\n{% elif a == 268 %}268\n{% elif a == 269 %}269\n{% elif a == 270 %}270\n{% elif a == 271 %}271\n{% elif a == 272 %}272\n{% elif a == 273 %}273\n{% elif a == 274 %}274\n{% elif a == 275 %}275\n{% elif a == 276 %}276\n{% elif a == 277 %}277\n{% elif a == 278 %}278\n{% elif a == 279 %}279\n{% elif a == 280 %}280\n{% elif a == 281 %}281\n{% elif a == 282 %}282\n{% elif a == 283 %}283\n{% elif a == 284 %}284\n{% elif a == 285 %}285\n{% elif a == 286 %}286\n{% elif a == 287 %}287\n{% elif a == 288 %}288\n{% elif a == 289 %}289\n{% elif a == 290 %}290\n{% elif a == 291 %}291\n{% elif a == 292 %}292\n{% elif a == 293 %}293\n{% elif a == 294 %}294\n{% elif a == 295 %}295\n{% elif a == 296 %}296\n{% elif a == 297 %}297\n{% elif a == 298 %}298\n{% elif a == 299 %}299\n{% elif a == 300 %}300\n{% elif a == 301 %}301\n{% elif a == 302 %}302\n{% elif a == 303 %}303\n{% elif a == 304 %}304\n{% elif a == 305 %}305\n{% elif a == 306 %}306\n{% elif a == 307 %}307\n{% elif a == 308 %}308\n{% elif a == 309 %}309\n{% elif a == 310 %}310\n{% elif a == 311 %}311\n{% elif a == 312 %}312\n{% elif a == 313 %}313\n{% elif a == 314 %}314\n{% elif a == 315 %}315\n{% elif a == 316 %}316\n{% elif a == 317 %}317\n{% elif a == 318 %}318\n{% elif a == 319 %}319\n{% elif a == 320 %}320\n{% elif a == 321 %}321\n{% elif a == 322 %}322\n{% elif a == 323 %}323\n{% elif a == 324 %}324\n{% elif a == 325 %}325\n{% elif a == 326 %}326\n{% elif a == 327 %}327\n{% elif a == 328 %}328\n{% elif a == 329 %}329\n{% elif a == 330 %}330\n{% elif a == 331 %}331\n{% elif a == 332 %}332\n{% elif a == 333 %}333\n{% elif a == 334 %}334\n{% elif a == 335 %}335\n{% elif a == 336 %}336\n{% elif a == 337 %}337\n{% elif a == 338 %}338\n{% elif a == 339 %}339\n{% elif a == 340 %}340\n{% elif a == 341 %}341\n{% elif a == 342 %}342\n{% elif a == 343 %}343\n{% elif a == 344 %}344\n{% elif a == 345 %}345\n{% elif a == 346 %}346\n{% elif a == 347 %}347\n{% elif a == 348 %}348\n{% elif a == 349 %}349\n{% elif a == 350 %}350\n{% elif a == 351 %}351\n{% elif a == 352 %}352\n{% elif a == 353 %}353\n{% elif a == 354 %}354\n{% elif a == 355 %}355\n{% elif a == 356 %}356\n{% elif a == 357 %}357\n{% elif a == 358 %}358\n{% elif a == 359 %}359\n{% elif a == 360 %}360\n{% elif a == 361 %}361\n{% elif a == 362 %}362\n{% elif a == 363 %}363\n{% elif a == 364 %}364\n{% elif a == 365 %}365\n{% elif a == 366 %}366\n{% elif a == 367 %}367\n{% elif a == 368 %}368\n{% elif a == 369 %}369\n{% elif a == 370 %}370\n{% elif a == 371 %}371\n{% elif a == 372 %}372\n{% elif a == 373 %}373\n{% elif a == 374 %}374\n{% elif a == 375 %}375\n{% elif a == 376 %}376\n{% elif a == 377 %}377\n{% elif a == 378 %}378\n{% elif a == 379 %}379\n{% elif a == 380 %}380\n{% elif a == 381 %}381\n{% elif a == 382 %}382\n{% elif a == 383 %}383\n{% elif a == 384 %}384\n{% elif a == 385 %}385\n{% elif a == 386 %}386\n{% elif a == 387 %}387\n{% elif a == 388 %}388\n{% elif a == 389 %}389\n{% elif a == 390 %}390\n{% elif a == 391 %}391\n{% elif a == 392 %}392\n{% elif a == 393 %}393\n{% elif a == 394 %}394\n{% elif a == 395 %}395\n{% elif a == 396 %}396\n{% elif a == 397 %}397\n{% elif a == 398 %}398\n{% elif a == 399 %}399\n{% elif a == 400 %}400\n{% elif a == 401 %}401\n{% elif a == 402 %}402\n{% elif a == 403 %}403\n{% elif a == 404 %}404\n{% elif a == 405 %}405\n{% elif a == 406 %}406\n{% elif a == 407 %}407\n{% elif a == 408 %}408\n{% elif a == 409 %}409\n{% elif a == 410 %}410\n{% elif a == 411 %}411\n{% elif a == 412 %}412\n{% elif a == 413 %}413\n{% elif a == 414 %}414\n{% elif a == 415 %}415\n{% elif a == 416 %}416\n{% elif a == 417 %}417\n{% elif a == 418 %}418\n{% elif a == 419 %}419\n{% elif a == 420 %}420\n{% elif a == 421 %}421\n{% elif a == 422 %}422\n{% elif a == 423 %}423\n{% elif a == 424 %}424\n{% elif a == 425 %}425\n{% elif a == 426 %}426\n{% elif a == 427 %}427\n{% elif a == 428 %}428\n{% elif a == 429 %}429\n{% elif a == 430 %}430\n{% elif a == 431 %}431\n{% elif a == 432 %}432\n{% elif a == 433 %}433\n{% elif a == 434 %}434\n{% elif a == 435 %}435\n{% elif a == 436 %}436\n{% elif a == 437 %}437\n{% elif a == 438 %}438\n{% elif a == 439 %}439\n{% elif a == 440 %}440\n{% elif a == 441 %}441\n{% elif a == 442 %}442\n{% elif a == 443 %}443\n{% elif a == 444 %}444\n{% elif a == 445 %}445\n{% elif a == 446 %}446\n{% elif a == 447 %}447\n{% elif a == 448 %}448\n{% elif a == 449 %}449\n{% elif a == 450 %}450\n{% elif a == 451 %}451\n{% elif a == 452 %}452\n{% elif a == 453 %}453\n{% elif a == 454 %}454\n{% elif a == 455 %}455\n{% elif a == 456 %}456\n{% elif a == 457 %}457\n{% elif a == 458 %}458\n{% elif a == 459 %}459\n{% elif a == 460 %}460\n{% elif a == 461 %}461\n{% elif a == 462 %}462\n{% elif a == 463 %}463\n{% elif a == 464 %}464\n{% elif a == 465 %}465\n{% elif a == 466 %}466\n{% elif a == 467 %}467\n{% elif a == 468 %}468\n{% elif a == 469 %}469\n{% elif a == 470 %}470\n{% elif a == 471 %}471\n{% elif a == 472 %}472\n{% elif a == 473 %}473\n{% elif a == 474 %}474\n{% elif a == 475 %}475\n{% elif a == 476 %}476\n{% elif a == 477 %}477\n{% elif a == 478 %}478\n{% elif a == 479 %}479\n{% elif a == 480 %}480\n{% elif a == 481 %}481\n{% elif a == 482 %}482\n{% elif a == 483 %}483\n{% elif a == 484 %}484\n{% elif a == 485 %}485\n{% elif a == 486 %}486\n{% elif a == 487 %}487\n{% elif a == 488 %}488\n{% elif a == 489 %}489\n{% elif a == 490 %}490\n{% elif a == 491 %}491\n{% elif a == 492 %}492\n{% elif a == 493 %}493\n{% elif a == 494 %}494\n{% elif a == 495 %}495\n{% elif a == 496 %}496\n{% elif a == 497 %}497\n{% elif a == 498 %}498\n{% elif a == 499 %}499\n{% elif a == 500 %}500\n{% elif a == 501 %}501\n{% elif a == 502 %}502\n{% elif a == 503 %}503\n{% elif a == 504 %}504\n{% elif a == 505 %}505\n{% elif a == 506 %}506\n{% elif a == 507 %}507\n{% elif a == 508 %}508\n{% elif a == 509 %}509\n{% elif a == 510 %}510\n{% elif a == 511 %}511\n{% elif a == 512 %}512\n{% elif a == 513 %}513\n{% elif a == 514 %}514\n{% elif a == 515 %}515\n{% elif a == 516 %}516\n{% elif a == 517 %}517\n{% elif a == 518 %}518\n{% elif a == 519 %}519\n{% elif a == 520 %}520\n{% elif a == 521 %}521\n{% elif a == 522 %}522\n{% elif a == 523 %}523\n{% elif a == 524 %}524\n{% elif a == 525 %}525\n{% elif a == 526 %}526\n{% elif a == 527 %}527\n{% elif a == 528 %}528\n{% elif a == 529 %}529\n{% elif a == 530 %}530\n{% elif a == 531 %}531\n{% elif a == 532 %}532\n{% elif a == 533 %}533\n{% elif a == 534 %}534\n{% elif a == 535 %}535\n{% elif a == 536 %}536\n{% elif a == 537 %}537\n{% elif a == 538 %}538\n{% elif a == 539 %}539\n{% elif a == 540 %}540\n{% elif a == 541 %}541\n{% elif a == 542 %}542\n{% elif a == 543 %}543\n{% elif a == 544 %}544\n{% elif a == 545 %}545\n{% elif a == 546 %}546\n{% elif a == 547 %}547\n{% elif a == 548 %}548\n{% elif a == 549 %}549\n{% elif a == 550 %}550\n{% elif a == 551 %}551\n{% elif a == 552 %}552\n{% elif a == 553 %}553\n{% elif a == 554 %}554\n{% elif a == 555 %}555\n{% elif a == 556 %}556\n{% elif a == 557 %}557\n{% elif a == 558 %}558\n{% elif a == 559 %}559\n{% elif a == 560 %}560\n{% elif a == 561 %}561\n{% elif a == 562 %}562\n{% elif a == 563 %}563\n{% elif a == 564 %}564\n{% elif a == 565 %}565\n{% elif a == 566 %}566\n{% elif a == 567 %}567\n{% elif a == 568 %}568\n{% elif a == 569 %}569\n{% elif a == 570 %}570\n{% elif a == 571 %}571\n{% elif a == 572 %}572\n{% elif a == 573 %}573\n{% elif a == 574 %}574\n{% elif a == 575 %}575\n{% elif a == 576 %}576\n{% elif a == 577 %}577\n{% elif a == 578 %}578\n{% elif a == 579 %}579\n{% elif a == 580 %}580\n{% elif a == 581 %}581\n{% elif a == 582 %}582\n{% elif a == 583 %}583\n{% elif a == 584 %}584\n{% elif a == 585 %}585\n{% elif a == 586 %}586\n{% elif a == 587 %}587\n{% elif a == 588 %}588\n{% elif a == 589 %}589\n{% elif a == 590 %}590\n{% elif a == 591 %}591\n{% elif a == 592 %}592\n{% elif a == 593 %}593\n{% elif a == 594 %}594\n{% elif a == 595 %}595\n{% elif a == 596 %}596\n{% elif a == 597 %}597\n{% elif a == 598 %}598\n{% elif a == 599 %}599\n{% elif a == 600 %}600\n{% elif a == 601 %}601\n{% elif a == 602 %}602\n{% elif a == 603 %}603\n{% elif a == 604 %}604\n{% elif a == 605 %}605\n{% elif a == 606 %}606\n{% elif a == 607 %}607\n{% elif a == 608 %}608\n{% elif a == 609 %}609\n{% elif a == 610 %}610\n{% elif a == 611 %}611\n{% elif a == 612 %}612\n{% elif a == 613 %}613\n{% elif a == 614 %}614\n{% elif a == 615 %}615\n{% elif a == 616 %}616\n{% elif a == 617 %}617\n{% elif a == 618 %}618\n{% elif a == 619 %}619\n{% elif a == 620 %}620\n{% elif a == 621 %}621\n{% elif a == 622 %}622\n{% elif a == 623 %}623\n{% elif a == 624 %}624\n{% elif a == 625 %}625\n{% elif a == 626 %}626\n{% elif a == 627 %}627\n{% elif a == 628 %}628\n{% elif a == 629 %}629\n{% elif a == 630 %}630\n{% elif a == 631 %}631\n{% elif a == 632 %}632\n{% elif a == 633 %}633\n{% elif a == 634 %}634\n{% elif a == 635 %}635\n{% elif a == 636 %}636\n{% elif a == 637 %}637\n{% elif a == 638 %}638\n{% elif a == 639 %}639\n{% elif a == 640 %}640\n{% elif a == 641 %}641\n{% elif a == 642 %}642\n{% elif a == 643 %}643\n{% elif a == 644 %}644\n{% elif a == 645 %}645\n{% elif a == 646 %}646\n{% elif a == 647 %}647\n{% elif a == 648 %}648\n{% elif a == 649 %}649\n{% elif a == 650 %}650\n{% elif a == 651 %}651\n{% elif a == 652 %}652\n{% elif a == 653 %}653\n{% elif a == 654 %}654\n{% elif a == 655 %}655\n{% elif a == 656 %}656\n{% elif a == 657 %}657\n{% elif a == 658 %}658\n{% elif a == 659 %}659\n{% elif a == 660 %}660\n{% elif a == 661 %}661\n{% elif a == 662 %}662\n{% elif a == 663 %}663\n{% elif a == 664 %}664\n{% elif a == 665 %}665\n{% elif a == 666 %}666\n{% elif a == 667 %}667\n{% elif a == 668 %}668\n{% elif a == 669 %}669\n{% elif a == 670 %}670\n{% elif a == 671 %}671\n{% elif a == 672 %}672\n{% elif a == 673 %}673\n{% elif a == 674 %}674\n{% elif a == 675 %}675\n{% elif a == 676 %}676\n{% elif a == 677 %}677\n{% elif a == 678 %}678\n{% elif a == 679 %}679\n{% elif a == 680 %}680\n{% elif a == 681 %}681\n{% elif a == 682 %}682\n{% elif a == 683 %}683\n{% elif a == 684 %}684\n{% elif a == 685 %}685\n{% elif a == 686 %}686\n{% elif a == 687 %}687\n{% elif a == 688 %}688\n{% elif a == 689 %}689\n{% elif a == 690 %}690\n{% elif a == 691 %}691\n{% elif a == 692 %}692\n{% elif a == 693 %}693\n{% elif a == 694 %}694\n{% elif a == 695 %}695\n{% elif a == 696 %}696\n{% elif a == 697 %}697\n{% elif a == 698 %}698\n{% elif a == 699 %}699\n{% elif a == 700 %}700\n{% elif a == 701 %}701\n{% elif a == 702 %}702\n{% elif a == 703 %}703\n{% elif a == 704 %}704\n{% elif a == 705 %}705\n{% elif a == 706 %}706\n{% elif a == 707 %}707\n{% elif a == 708 %}708\n{% elif a == 709 %}709\n{% elif a == 710 %}710\n{% elif a == 711 %}711\n{% elif a == 712 %}712\n{% elif a == 713 %}713\n{% elif a == 714 %}714\n{% elif a == 715 %}715\n{% elif a == 716 %}716\n{% elif a == 717 %}717\n{% elif a == 718 %}718\n{% elif a == 719 %}719\n{% elif a == 720 %}720\n{% elif a == 721 %}721\n{% elif a == 722 %}722\n{% elif a == 723 %}723\n{% elif a == 724 %}724\n{% elif a == 725 %}725\n{% elif a == 726 %}726\n{% elif a == 727 %}727\n{% elif a == 728 %}728\n{% elif a == 729 %}729\n{% elif a == 730 %}730\n{% elif a == 731 %}731\n{% elif a == 732 %}732\n{% elif a == 733 %}733\n{% elif a == 734 %}734\n{% elif a == 735 %}735\n{% elif a == 736 %}736\n{% elif a == 737 %}737\n{% elif a == 738 %}738\n{% elif a == 739 %}739\n{% elif a == 740 %}740\n{% elif a == 741 %}741\n{% elif a == 742 %}742\n{% elif a == 743 %}743\n{% elif a == 744 %}744\n{% elif a == 745 %}745\n{% elif a == 746 %}746\n{% elif a == 747 %}747\n{% elif a == 748 %}748\n{% elif a == 749 %}749\n{% elif a == 750 %}750\n{% elif a == 751 %}751\n{% elif a == 752 %}752\n{% elif a == 753 %}753\n{% elif a == 754 %}754\n{% elif a == 755 %}755\n{% elif a == 756 %}756\n{% elif a == 757 %}757\n{% elif a == 758 %}758\n{% elif a == 759 %}759\n{% elif a == 760 %}760\n{% elif a == 761 %}761\n{% elif a == 762 %}762\n{% elif a == 763 %}763\n{% elif a == 764 %}764\n{% elif a == 765 %}765\n{% elif a == 766 %}766\n{% elif a == 767 %}767\n{% elif a == 768 %}768\n{% elif a == 769 %}769\n{% elif a == 770 %}770\n{% elif a == 771 %}771\n{% elif a == 772 %}772\n{% elif a == 773 %}773\n{% elif a == 774 %}774\n{% elif a == 775 %}775\n{% elif a == 776 %}776\n{% elif a == 777 %}777\n{% elif a == 778 %}778\n{% elif a == 779 %}779\n{% elif a == 780 %}780\n{% elif a == 781 %}781\n{% elif a == 782 %}782\n{% elif a == 783 %}783\n{% elif a == 784 %}784\n{% elif a == 785 %}785\n{% elif a == 786 %}786\n{% elif a == 787 %}787\n{% elif a == 788 %}788\n{% elif a == 789 %}789\n{% elif a == 790 %}790\n{% elif a == 791 %}791\n{% elif a == 792 %}792\n{% elif a == 793 %}793\n{% elif a == 794 %}794\n{% elif a == 795 %}795\n{% elif a == 796 %}796\n{% elif a == 797 %}797\n{% elif a == 798 %}798\n{% elif a == 799 %}799\n{% elif a == 800 %}800\n{% elif a == 801 %}801\n{% elif a == 802 %}802\n{% elif a == 803 %}803\n{% elif a == 804 %}804\n{% elif a == 805 %}805\n{% elif a == 806 %}806\n{% elif a == 807 %}807\n{% elif a == 808 %}808\n{% elif a == 809 %}809\n{% elif a == 810 %}810\n{% elif a == 811 %}811\n{% elif a == 812 %}812\n{% elif a == 813 %}813\n{% elif a == 814 %}814\n{% elif a == 815 %}815\n{% elif a == 816 %}816\n{% elif a == 817 %}817\n{% elif a == 818 %}818\n{% elif a == 819 %}819\n{% elif a == 820 %}820\n{% elif a == 821 %}821\n{% elif a == 822 %}822\n{% elif a == 823 %}823\n{% elif a == 824 %}824\n{% elif a == 825 %}825\n{% elif a == 826 %}826\n{% elif a == 827 %}827\n{% elif a == 828 %}828\n{% elif a == 829 %}829\n{% elif a == 830 %}830\n{% elif a == 831 %}831\n{% elif a == 832 %}832\n{% elif a == 833 %}833\n{% elif a == 834 %}834\n{% elif a == 835 %}835\n{% elif a == 836 %}836\n{% elif a == 837 %}837\n{% elif a == 838 %}838\n{% elif a == 839 %}839\n{% elif a == 840 %}840\n{% elif a == 841 %}841\n{% elif a == 842 %}842\n{% elif a == 843 %}843\n{% elif a == 844 %}844\n{% elif a == 845 %}845\n{% elif a == 846 %}846\n{% elif a == 847 %}847\n{% elif a == 848 %}848\n{% elif a == 849 %}849\n{% elif a == 850 %}850\n{% elif a == 851 %}851\n{% elif a == 852 %}852\n{% elif a == 853 %}853\n{% elif a == 854 %}854\n{% elif a == 855 %}855\n{% elif a == 856 %}856\n{% elif a == 857 %}857\n{% elif a == 858 %}858\n{% elif a == 859 %}859\n{% elif a == 860 %}860\n{% elif a == 861 %}861\n{% elif a == 862 %}862\n{% elif a == 863 %}863\n{% elif a == 864 %}864\n{% elif a == 865 %}865\n{% elif a == 866 %}866\n{% elif a == 867 %}867\n{% elif a == 868 %}868\n{% elif a == 869 %}869\n{% elif a == 870 %}870\n{% elif a == 871 %}871\n{% elif a == 872 %}872\n{% elif a == 873 %}873\n{% elif a == 874 %}874\n{% elif a == 875 %}875\n{% elif a == 876 %}876\n{% elif a == 877 %}877\n{% elif a == 878 %}878\n{% elif a == 879 %}879\n{% elif a == 880 %}880\n{% elif a == 881 %}881\n{% elif a == 882 %}882\n{% elif a == 883 %}883\n{% elif a == 884 %}884\n{% elif a == 885 %}885\n{% elif a == 886 %}886\n{% elif a == 887 %}887\n{% elif a == 888 %}888\n{% elif a == 889 %}889\n{% elif a == 890 %}890\n{% elif a == 891 %}891\n{% elif a == 892 %}892\n{% elif a == 893 %}893\n{% elif a == 894 %}894\n{% elif a == 895 %}895\n{% elif a == 896 %}896\n{% elif a == 897 %}897\n{% elif a == 898 %}898\n{% elif a == 899 %}899\n{% elif a == 900 %}900\n{% elif a == 901 %}901\n{% elif a == 902 %}902\n{% elif a == 903 %}903\n{% elif a == 904 %}904\n{% elif a == 905 %}905\n{% elif a == 906 %}906\n{% elif a == 907 %}907\n{% elif a == 908 %}908\n{% elif a == 909 %}909\n{% elif a == 910 %}910\n{% elif a == 911 %}911\n{% elif a == 912 %}912\n{% elif a == 913 %}913\n{% elif a == 914 %}914\n{% elif a == 915 %}915\n{% elif a == 916 %}916\n{% elif a == 917 %}917\n{% elif a == 918 %}918\n{% elif a == 919 %}919\n{% elif a == 920 %}920\n{% elif a == 921 %}921\n{% elif a == 922 %}922\n{% elif a == 923 %}923\n{% elif a == 924 %}924\n{% elif a == 925 %}925\n{% elif a == 926 %}926\n{% elif a == 927 %}927\n{% elif a == 928 %}928\n{% elif a == 929 %}929\n{% elif a == 930 %}930\n{% elif a == 931 %}931\n{% elif a == 932 %}932\n{% elif a == 933 %}933\n{% elif a == 934 %}934\n{% elif a == 935 %}935\n{% elif a == 936 %}936\n{% elif a == 937 %}937\n{% elif a == 938 %}938\n{% elif a == 939 %}939\n{% elif a == 940 %}940\n{% elif a == 941 %}941\n{% elif a == 942 %}942\n{% elif a == 943 %}943\n{% elif a == 944 %}944\n{% elif a == 945 %}945\n{% elif a == 946 %}946\n{% elif a == 947 %}947\n{% elif a == 948 %}948\n{% elif a == 949 %}949\n{% elif a == 950 %}950\n{% elif a == 951 %}951\n{% elif a == 952 %}952\n{% elif a == 953 %}953\n{% elif a == 954 %}954\n{% elif a == 955 %}955\n{% elif a == 956 %}956\n{% elif a == 957 %}957\n{% elif a == 958 %}958\n{% elif a == 959 %}959\n{% elif a == 960 %}960\n{% elif a == 961 %}961\n{% elif a == 962 %}962\n{% elif a == 963 %}963\n{% elif a == 964 %}964\n{% elif a == 965 %}965\n{% elif a == 966 %}966\n{% elif a == 967 %}967\n{% elif a == 968 %}968\n{% elif a == 969 %}969\n{% elif a == 970 %}970\n{% elif a == 971 %}971\n{% elif a == 972 %}972\n{% elif a == 973 %}973\n{% elif a == 974 %}974\n{% elif a == 975 %}975\n{% elif a == 976 %}976\n{% elif a == 977 %}977\n{% elif a == 978 %}978\n{% elif a == 979 %}979\n{% elif a == 980 %}980\n{% elif a == 981 %}981\n{% elif a == 982 %}982\n{% elif a == 983 %}983\n{% elif a == 984 %}984\n{% elif a == 985 %}985\n{% elif a == 986 %}986\n{% elif a == 987 %}987\n{% elif a == 988 %}988\n{% elif a == 989 %}989\n{% elif a == 990 %}990\n{% elif a == 991 %}991\n{% elif a == 992 %}992\n{% elif a == 993 %}993\n{% elif a == 994 %}994\n{% elif a == 995 %}995\n{% elif a == 996 %}996\n{% elif a == 997 %}997\n{% elif a == 998 %}998\n{% elif a == 999 %}999{% else %}x{% endif %}",
    "{\"a\": 10}",
    output="10\n",
  )
}

///|
test "jinja test_core_tags TestIfCondition::test_elif_deep #3" {
  jinja(
    source="{% if a == 0 %}0{% elif a == 1 %}1\n{% elif a == 2 %}2\n{% elif a == 3 %}3\n{% elif a == 4 %}4\n{% elif a == 5 %}5\n{% elif a == 6 %}6\n{% elif a == 7 %}7\n{% elif a == 8 %}8\n{% elif a == 9 %}9\n{% elif a == 10 %}10\n{% elif a == 11 %}11\n{% elif a == 12 %}12\n{% elif a == 13 %}13\n{% elif a == 14 %}14\n{% elif a == 15 %}15\n{% elif a == 16 %}16\n{% elif a == 17 %}17\n{% elif a == 18 %}18\n{% elif a == 19 %}19\n{% elif a == 20 %}20\n{% elif a == 21 %}21\n{% elif a == 22 %}22\n{% elif a == 23 %}23\n{% elif a == 24 %}24\n{% elif a == 25 %}25\n{% elif a == 26 %}26\n{% elif a == 27 %}27\n{% elif a == 28 %}28\n{% elif a == 29 %}29\n{% elif a == 30 %}30\n{% elif a == 31 %}31\n{% elif a == 32 %}32\n{% elif a == 33 %}33\n{% elif a == 34 %}34\n{% elif a == 35 %}35\n{% elif a == 36 %}36\n{% elif a == 37 %}37\n{% elif a == 38 %}38\n{% elif a == 39 %}39\n{% elif a == 40 %}40\n{% elif a == 41 %}41\n{% elif a == 42 %}42\n{% elif a == 43 %}43\n{% elif a == 44 %}44\n{% elif a == 45 %}45\n{% elif a == 46 %}46\n{% elif a == 47 %}47\n{% elif a == 48 %}48\n{% elif a == 49 %}49\n{% elif a == 50 %}50\n{% elif a == 51 %}51\n{% elif a == 52 %}52\n{% elif a == 53 %}53\n{% elif a == 54 %}54\n{% elif a == 55 %}55\n{% elif a == 56 %}56\n{% elif a == 57 %}57\n{% elif a == 58 %}58\n{% elif a == 59 %}59\n{% elif a == 60 %}60\n{% elif a == 61 %}61\n{% elif a == 62 %}62\n{% elif a == 63 %}63\n{% elif a == 64 %}64\n{% elif a == 65 %}65\n{% elif a == 66 %}66\n{% elif a == 67 %}67\n{% elif a == 68 %}68\n{% elif a == 69 %}69\n{% elif a == 70 %}70\n{% elif a == 71 %}71\n{% elif a == 72 %}72\n{% elif a == 73 %}73\n{% elif a == 74 %}74\n{% elif a == 75 %}75\n{% elif a == 76 %}76\n{% elif a == 77 %}77\n{% elif a == 78 %}78\n{% elif a == 79 %}79\n{% elif a == 80 %}80\n{% elif a == 81 %}81\n{% elif a == 82 %}82\n{% elif a == 83 %}83\n{% elif a == 84 %}84\n{% elif a == 85 %}85\n{% elif a == 86 %}86\n{% elif a == 87 %}87\n{% elif a == 88 %}88\n{% elif a == 89 %}89\n{% elif a == 90 %}90\n{% elif a == 91 %}91\n{% elif a == 92 %}92\n{% elif a == 93 %}93\n{% elif a == 94 %}94\n{% elif a == 95 %}95\n{% elif a == 96 %}96\n{% elif a == 97 %}97\n{% elif a == 98 %}98\n{% elif a == 99 %}99\n{% elif a == 100 %}100\n{% elif a == 101 %}101\n{% elif a == 102 %}102\n{% elif a == 103 %}103\n{% elif a == 104 %}104\n{% elif a == 105 %}105\n{% elif a == 106 %}106\n{% elif a == 107 %}107\n{% elif a == 108 %}108\n{% elif a == 109 %}109\n{% elif a == 110 %}110\n{% elif a == 111 %}111\n{% elif a == 112 %}112\n{% elif a == 113 %}113\n{% elif a == 114 %}114\n{% elif a == 115 %}115\n{% elif a == 116 %}116\n{% elif a == 117 %}117\n{% elif a == 118 %}118\n{% elif a == 119 %}119\n{% elif a == 120 %}120\n{% elif a == 121 %}121\n{% elif a == 122 %}122\n{% elif a == 123 %}123\n{% elif a == 124 %}124\n{% elif a == 125 %}125\n{% elif a == 126 %}126\n{% elif a == 127 %}127\n{% elif a == 128 %}128\n{% elif a == 129 %}129\n{% elif a == 130 %}130\n{% elif a == 131 %}131\n{% elif a == 132 %}132\n{% elif a == 133 %}133\n{% elif a == 134 %}134\n{% elif a == 135 %}135\n{% elif a == 136 %}136\n{% elif a == 137 %}137\n{% elif a == 138 %}138\n{% elif a == 139 %}139\n{% elif a == 140 %}140\n{% elif a == 141 %}141\n{% elif a == 142 %}142\n{% elif a == 143 %}143\n{% elif a == 144 %}144\n{% elif a == 145 %}145\n{% elif a == 146 %}146\n{% elif a == 147 %}147\n{% elif a == 148 %}148\n{% elif a == 149 %}149\n{% elif a == 150 %}150\n{% elif a == 151 %}151\n{% elif a == 152 %}152\n{% elif a == 153 %}153\n{% elif a == 154 %}154\n{% elif a == 155 %}155\n{% elif a == 156 %}156\n{% elif a == 157 %}157\n{% elif a == 158 %}158\n{% elif a == 159 %}159\n{% elif a == 160 %}160\n{% elif a == 161 %}161\n{% elif a == 162 %}162\n{% elif a == 163 %}163\n{% elif a == 164 %}164\n{% elif a == 165 %}165\n{% elif a == 166 %}166\n{% elif a == 167 %}167\n{% elif a == 168 %}168\n{% elif a == 169 %}169\n{% elif a == 170 %}170\n{% elif a == 171 %}171\n{% elif a == 172 %}172\n{% elif a == 173 %}173\n{% elif a == 174 %}174\n{% elif a == 175 %}175\n{% elif a == 176 %}176\n{% elif a == 177 %}177\n{% elif a == 178 %}178\n{% elif a == 179 %}179\n{% elif a == 180 %}180\n{% elif a == 181 %}181\n{% elif a == 182 %}182\n{% elif a == 183 %}183\n{% elif a == 184 %}184\n{% elif a == 185 %}185\n{% elif a == 186 %}186\n{% elif a == 187 %}187\n{% elif a == 188 %}188\n{% elif a == 189 %}189\n{% elif a == 190 %}190\n{% elif a == 191 %}191\n{% elif a == 192 %}192\n{% elif a == 193 %}193\n{% elif a == 194 %}194\n{% elif a == 195 %}195\n{% elif a == 196 %}196\n{% elif a == 197 %}197\n{% elif a == 198 %}198\n{% elif a == 199 %}199\n{% elif a == 200 %}200\n{% elif a == 201 %}201\n{% elif a == 202 %}202\n{% elif a == 203 %}203\n{% elif a == 204 %}204\n{% elif a == 205 %}205\n{% elif a == 206 %}206\n{% elif a == 207 %}207\n{% elif a == 208 %}208\n{% elif a == 209 %}209\n{% elif a == 210 %}210\n{% elif a == 211 %}211\n{% elif a == 212 %}212\n{% elif a == 213 %}213\n{% elif a == 214 %}214\n{% elif a == 215 %}215\n{% elif a == 216 %}216\n{% elif a == 217 %}217\n{% elif a == 218 %}218\n{% elif a == 219 %}219\n{% elif a == 220 %}220\n{% elif a == 221 %}221\n{% elif a == 222 %}222\n{% elif a == 223 %}223\n{% elif a == 224 %}224\n{% elif a == 225 %}225\n{% elif a == 226 %}226\n{% elif a == 227 %}227\n{% elif a == 228 %}228\n{% elif a == 229 %}229\n{% elif a == 230 %}230\n{% elif a == 231 %}231\n{% elif a == 232 %}232\n{% elif a == 233 %}233\n{% elif a == 234 %}234\n{% elif a == 235 %}235\n{% elif a == 236 %}236\n{% elif a == 237 %}237\n{% elif a == 238 %}238\n{% elif a == 239 %}239\n{% elif a == 240 %}240\n{% elif a == 241 %}241\n{% elif a == 242 %}242\n{% elif a == 243 %}243\n{% elif a == 244 %}244\n{% elif a == 245 %}245\n{% elif a == 246 %}246\n{% elif a == 247 %}247\n{% elif a == 248 %}248\n{% elif a == 249 %}249\n{% elif a == 250 %}250\n{% elif a == 251 %}251\n{% elif a == 252 %}252\n{% elif a == 253 %}253\n{% elif a == 254 %}254\n{% elif a == 255 %}255\n{% elif a == 256 %}256\n{% elif a == 257 %}257\n{% elif a == 258 %}258\n{% elif a == 259 %}259\n{% elif a == 260 %}260\n{% elif a == 261 %}261\n{% elif a == 262 %}262\n{% elif a == 263 %}263\n{% elif a == 264 %}264\n{% elif a == 265 %}265\n{% elif a == 266 %}266\n{% elif a == 267 %}267\n{% elif a == 268 %}268\n{% elif a == 269 %}269\n{% elif a == 270 %}270\n{% elif a == 271 %}271\n{% elif a == 272 %}272\n{% elif a == 273 %}273\n{% elif a == 274 %}274\n{% elif a == 275 %}275\n{% elif a == 276 %}276\n{% elif a == 277 %}277\n{% elif a == 278 %}278\n{% elif a == 279 %}279\n{% elif a == 280 %}280\n{% elif a == 281 %}281\n{% elif a == 282 %}282\n{% elif a == 283 %}283\n{% elif a == 284 %}284\n{% elif a == 285 %}285\n{% elif a == 286 %}286\n{% elif a == 287 %}287\n{% elif a == 288 %}288\n{% elif a == 289 %}289\n{% elif a == 290 %}290\n{% elif a == 291 %}291\n{% elif a == 292 %}292\n{% elif a == 293 %}293\n{% elif a == 294 %}294\n{% elif a == 295 %}295\n{% elif a == 296 %}296\n{% elif a == 297 %}297\n{% elif a == 298 %}298\n{% elif a == 299 %}299\n{% elif a == 300 %}300\n{% elif a == 301 %}301\n{% elif a == 302 %}302\n{% elif a == 303 %}303\n{% elif a == 304 %}304\n{% elif a == 305 %}305\n{% elif a == 306 %}306\n{% elif a == 307 %}307\n{% elif a == 308 %}308\n{% elif a == 309 %}309\n{% elif a == 310 %}310\n{% elif a == 311 %}311\n{% elif a == 312 %}312\n{% elif a == 313 %}313\n{% elif a == 314 %}314\n{% elif a == 315 %}315\n{% elif a == 316 %}316\n{% elif a == 317 %}317\n{% elif a == 318 %}318\n{% elif a == 319 %}319\n{% elif a == 320 %}320\n{% elif a == 321 %}321\n{% elif a == 322 %}322\n{% elif a == 323 %}323\n{% elif a == 324 %}324\n{% elif a == 325 %}325\n{% elif a == 326 %}326\n{% elif a == 327 %}327\n{% elif a == 328 %}328\n{% elif a == 329 %}329\n{% elif a == 330 %}330\n{% elif a == 331 %}331\n{% elif a == 332 %}332\n{% elif a == 333 %}333\n{% elif a == 334 %}334\n{% elif a == 335 %}335\n{% elif a == 336 %}336\n{% elif a == 337 %}337\n{% elif a == 338 %}338\n{% elif a == 339 %}339\n{% elif a == 340 %}340\n{% elif a == 341 %}341\n{% elif a == 342 %}342\n{% elif a == 343 %}343\n{% elif a == 344 %}344\n{% elif a == 345 %}345\n{% elif a == 346 %}346\n{% elif a == 347 %}347\n{% elif a == 348 %}348\n{% elif a == 349 %}349\n{% elif a == 350 %}350\n{% elif a == 351 %}351\n{% elif a == 352 %}352\n{% elif a == 353 %}353\n{% elif a == 354 %}354\n{% elif a == 355 %}355\n{% elif a == 356 %}356\n{% elif a == 357 %}357\n{% elif a == 358 %}358\n{% elif a == 359 %}359\n{% elif a == 360 %}360\n{% elif a == 361 %}361\n{% elif a == 362 %}362\n{% elif a == 363 %}363\n{% elif a == 364 %}364\n{% elif a == 365 %}365\n{% elif a == 366 %}366\n{% elif a == 367 %}367\n{% elif a == 368 %}368\n{% elif a == 369 %}369\n{% elif a == 370 %}370\n{% elif a == 371 %}371\n{% elif a == 372 %}372\n{% elif a == 373 %}373\n{% elif a == 374 %}374\n{% elif a == 375 %}375\n{% elif a == 376 %}376\n{% elif a == 377 %}377\n{% elif a == 378 %}378\n{% elif a == 379 %}379\n{% elif a == 380 %}380\n{% elif a == 381 %}381\n{% elif a == 382 %}382\n{% elif a == 383 %}383\n{% elif a == 384 %}384\n{% elif a == 385 %}385\n{% elif a == 386 %}386\n{% elif a == 387 %}387\n{% elif a == 388 %}388\n{% elif a == 389 %}389\n{% elif a == 390 %}390\n{% elif a == 391 %}391\n{% elif a == 392 %}392\n{% elif a == 393 %}393\n{% elif a == 394 %}394\n{% elif a == 395 %}395\n{% elif a == 396 %}396\n{% elif a == 397 %}397\n{% elif a == 398 %}398\n{% elif a == 399 %}399\n{% elif a == 400 %}400\n{% elif a == 401 %}401\n{% elif a == 402 %}402\n{% elif a == 403 %}403\n{% elif a == 404 %}404\n{% elif a == 405 %}405\n{% elif a == 406 %}406\n{% elif a == 407 %}407\n{% elif a == 408 %}408\n{% elif a == 409 %}409\n{% elif a == 410 %}410\n{% elif a == 411 %}411\n{% elif a == 412 %}412\n{% elif a == 413 %}413\n{% elif a == 414 %}414\n{% elif a == 415 %}415\n{% elif a == 416 %}416\n{% elif a == 417 %}417\n{% elif a == 418 %}418\n{% elif a == 419 %}419\n{% elif a == 420 %}420\n{% elif a == 421 %}421\n{% elif a == 422 %}422\n{% elif a == 423 %}423\n{% elif a == 424 %}424\n{% elif a == 425 %}425\n{% elif a == 426 %}426\n{% elif a == 427 %}427\n{% elif a == 428 %}428\n{% elif a == 429 %}429\n{% elif a == 430 %}430\n{% elif a == 431 %}431\n{% elif a == 432 %}432\n{% elif a == 433 %}433\n{% elif a == 434 %}434\n{% elif a == 435 %}435\n{% elif a == 436 %}436\n{% elif a == 437 %}437\n{% elif a == 438 %}438\n{% elif a == 439 %}439\n{% elif a == 440 %}440\n{% elif a == 441 %}441\n{% elif a == 442 %}442\n{% elif a == 443 %}443\n{% elif a == 444 %}444\n{% elif a == 445 %}445\n{% elif a == 446 %}446\n{% elif a == 447 %}447\n{% elif a == 448 %}448\n{% elif a == 449 %}449\n{% elif a == 450 %}450\n{% elif a == 451 %}451\n{% elif a == 452 %}452\n{% elif a == 453 %}453\n{% elif a == 454 %}454\n{% elif a == 455 %}455\n{% elif a == 456 %}456\n{% elif a == 457 %}457\n{% elif a == 458 %}458\n{% elif a == 459 %}459\n{% elif a == 460 %}460\n{% elif a == 461 %}461\n{% elif a == 462 %}462\n{% elif a == 463 %}463\n{% elif a == 464 %}464\n{% elif a == 465 %}465\n{% elif a == 466 %}466\n{% elif a == 467 %}467\n{% elif a == 468 %}468\n{% elif a == 469 %}469\n{% elif a == 470 %}470\n{% elif a == 471 %}471\n{% elif a == 472 %}472\n{% elif a == 473 %}473\n{% elif a == 474 %}474\n{% elif a == 475 %}475\n{% elif a == 476 %}476\n{% elif a == 477 %}477\n{% elif a == 478 %}478\n{% elif a == 479 %}479\n{% elif a == 480 %}480\n{% elif a == 481 %}481\n{% elif a == 482 %}482\n{% elif a == 483 %}483\n{% elif a == 484 %}484\n{% elif a == 485 %}485\n{% elif a == 486 %}486\n{% elif a == 487 %}487\n{% elif a == 488 %}488\n{% elif a == 489 %}489\n{% elif a == 490 %}490\n{% elif a == 491 %}491\n{% elif a == 492 %}492\n{% elif a == 493 %}493\n{% elif a == 494 %}494\n{% elif a == 495 %}495\n{% elif a == 496 %}496\n{% elif a == 497 %}497\n{% elif a == 498 %}498\n{% elif a == 499 %}499\n{% elif a == 500 %}500\n{% elif a == 501 %}501\n{% elif a == 502 %}502\n{% elif a == 503 %}503\n{% elif a == 504 %}504\n{% elif a == 505 %}505\n{% elif a == 506 %}506\n{% elif a == 507 %}507\n{% elif a == 508 %}508\n{% elif a == 509 %}509\n{% elif a == 510 %}510\n{% elif a == 511 %}511\n{% elif a == 512 %}512\n{% elif a == 513 %}513\n{% elif a == 514 %}514\n{% elif a == 515 %}515\n{% elif a == 516 %}516\n{% elif a == 517 %}517\n{% elif a == 518 %}518\n{% elif a == 519 %}519\n{% elif a == 520 %}520\n{% elif a == 521 %}521\n{% elif a == 522 %}522\n{% elif a == 523 %}523\n{% elif a == 524 %}524\n{% elif a == 525 %}525\n{% elif a == 526 %}526\n{% elif a == 527 %}527\n{% elif a == 528 %}528\n{% elif a == 529 %}529\n{% elif a == 530 %}530\n{% elif a == 531 %}531\n{% elif a == 532 %}532\n{% elif a == 533 %}533\n{% elif a == 534 %}534\n{% elif a == 535 %}535\n{% elif a == 536 %}536\n{% elif a == 537 %}537\n{% elif a == 538 %}538\n{% elif a == 539 %}539\n{% elif a == 540 %}540\n{% elif a == 541 %}541\n{% elif a == 542 %}542\n{% elif a == 543 %}543\n{% elif a == 544 %}544\n{% elif a == 545 %}545\n{% elif a == 546 %}546\n{% elif a == 547 %}547\n{% elif a == 548 %}548\n{% elif a == 549 %}549\n{% elif a == 550 %}550\n{% elif a == 551 %}551\n{% elif a == 552 %}552\n{% elif a == 553 %}553\n{% elif a == 554 %}554\n{% elif a == 555 %}555\n{% elif a == 556 %}556\n{% elif a == 557 %}557\n{% elif a == 558 %}558\n{% elif a == 559 %}559\n{% elif a == 560 %}560\n{% elif a == 561 %}561\n{% elif a == 562 %}562\n{% elif a == 563 %}563\n{% elif a == 564 %}564\n{% elif a == 565 %}565\n{% elif a == 566 %}566\n{% elif a == 567 %}567\n{% elif a == 568 %}568\n{% elif a == 569 %}569\n{% elif a == 570 %}570\n{% elif a == 571 %}571\n{% elif a == 572 %}572\n{% elif a == 573 %}573\n{% elif a == 574 %}574\n{% elif a == 575 %}575\n{% elif a == 576 %}576\n{% elif a == 577 %}577\n{% elif a == 578 %}578\n{% elif a == 579 %}579\n{% elif a == 580 %}580\n{% elif a == 581 %}581\n{% elif a == 582 %}582\n{% elif a == 583 %}583\n{% elif a == 584 %}584\n{% elif a == 585 %}585\n{% elif a == 586 %}586\n{% elif a == 587 %}587\n{% elif a == 588 %}588\n{% elif a == 589 %}589\n{% elif a == 590 %}590\n{% elif a == 591 %}591\n{% elif a == 592 %}592\n{% elif a == 593 %}593\n{% elif a == 594 %}594\n{% elif a == 595 %}595\n{% elif a == 596 %}596\n{% elif a == 597 %}597\n{% elif a == 598 %}598\n{% elif a == 599 %}599\n{% elif a == 600 %}600\n{% elif a == 601 %}601\n{% elif a == 602 %}602\n{% elif a == 603 %}603\n{% elif a == 604 %}604\n{% elif a == 605 %}605\n{% elif a == 606 %}606\n{% elif a == 607 %}607\n{% elif a == 608 %}608\n{% elif a == 609 %}609\n{% elif a == 610 %}610\n{% elif a == 611 %}611\n{% elif a == 612 %}612\n{% elif a == 613 %}613\n{% elif a == 614 %}614\n{% elif a == 615 %}615\n{% elif a == 616 %}616\n{% elif a == 617 %}617\n{% elif a == 618 %}618\n{% elif a == 619 %}619\n{% elif a == 620 %}620\n{% elif a == 621 %}621\n{% elif a == 622 %}622\n{% elif a == 623 %}623\n{% elif a == 624 %}624\n{% elif a == 625 %}625\n{% elif a == 626 %}626\n{% elif a == 627 %}627\n{% elif a == 628 %}628\n{% elif a == 629 %}629\n{% elif a == 630 %}630\n{% elif a == 631 %}631\n{% elif a == 632 %}632\n{% elif a == 633 %}633\n{% elif a == 634 %}634\n{% elif a == 635 %}635\n{% elif a == 636 %}636\n{% elif a == 637 %}637\n{% elif a == 638 %}638\n{% elif a == 639 %}639\n{% elif a == 640 %}640\n{% elif a == 641 %}641\n{% elif a == 642 %}642\n{% elif a == 643 %}643\n{% elif a == 644 %}644\n{% elif a == 645 %}645\n{% elif a == 646 %}646\n{% elif a == 647 %}647\n{% elif a == 648 %}648\n{% elif a == 649 %}649\n{% elif a == 650 %}650\n{% elif a == 651 %}651\n{% elif a == 652 %}652\n{% elif a == 653 %}653\n{% elif a == 654 %}654\n{% elif a == 655 %}655\n{% elif a == 656 %}656\n{% elif a == 657 %}657\n{% elif a == 658 %}658\n{% elif a == 659 %}659\n{% elif a == 660 %}660\n{% elif a == 661 %}661\n{% elif a == 662 %}662\n{% elif a == 663 %}663\n{% elif a == 664 %}664\n{% elif a == 665 %}665\n{% elif a == 666 %}666\n{% elif a == 667 %}667\n{% elif a == 668 %}668\n{% elif a == 669 %}669\n{% elif a == 670 %}670\n{% elif a == 671 %}671\n{% elif a == 672 %}672\n{% elif a == 673 %}673\n{% elif a == 674 %}674\n{% elif a == 675 %}675\n{% elif a == 676 %}676\n{% elif a == 677 %}677\n{% elif a == 678 %}678\n{% elif a == 679 %}679\n{% elif a == 680 %}680\n{% elif a == 681 %}681\n{% elif a == 682 %}682\n{% elif a == 683 %}683\n{% elif a == 684 %}684\n{% elif a == 685 %}685\n{% elif a == 686 %}686\n{% elif a == 687 %}687\n{% elif a == 688 %}688\n{% elif a == 689 %}689\n{% elif a == 690 %}690\n{% elif a == 691 %}691\n{% elif a == 692 %}692\n{% elif a == 693 %}693\n{% elif a == 694 %}694\n{% elif a == 695 %}695\n{% elif a == 696 %}696\n{% elif a == 697 %}697\n{% elif a == 698 %}698\n{% elif a == 699 %}699\n{% elif a == 700 %}700\n{% elif a == 701 %}701\n{% elif a == 702 %}702\n{% elif a == 703 %}703\n{% elif a == 704 %}704\n{% elif a == 705 %}705\n{% elif a == 706 %}706\n{% elif a == 707 %}707\n{% elif a == 708 %}708\n{% elif a == 709 %}709\n{% elif a == 710 %}710\n{% elif a == 711 %}711\n{% elif a == 712 %}712\n{% elif a == 713 %}713\n{% elif a == 714 %}714\n{% elif a == 715 %}715\n{% elif a == 716 %}716\n{% elif a == 717 %}717\n{% elif a == 718 %}718\n{% elif a == 719 %}719\n{% elif a == 720 %}720\n{% elif a == 721 %}721\n{% elif a == 722 %}722\n{% elif a == 723 %}723\n{% elif a == 724 %}724\n{% elif a == 725 %}725\n{% elif a == 726 %}726\n{% elif a == 727 %}727\n{% elif a == 728 %}728\n{% elif a == 729 %}729\n{% elif a == 730 %}730\n{% elif a == 731 %}731\n{% elif a == 732 %}732\n{% elif a == 733 %}733\n{% elif a == 734 %}734\n{% elif a == 735 %}735\n{% elif a == 736 %}736\n{% elif a == 737 %}737\n{% elif a == 738 %}738\n{% elif a == 739 %}739\n{% elif a == 740 %}740\n{% elif a == 741 %}741\n{% elif a == 742 %}742\n{% elif a == 743 %}743\n{% elif a == 744 %}744\n{% elif a == 745 %}745\n{% elif a == 746 %}746\n{% elif a == 747 %}747\n{% elif a == 748 %}748\n{% elif a == 749 %}749\n{% elif a == 750 %}750\n{% elif a == 751 %}751\n{% elif a == 752 %}752\n{% elif a == 753 %}753\n{% elif a == 754 %}754\n{% elif a == 755 %}755\n{% elif a == 756 %}756\n{% elif a == 757 %}757\n{% elif a == 758 %}758\n{% elif a == 759 %}759\n{% elif a == 760 %}760\n{% elif a == 761 %}761\n{% elif a == 762 %}762\n{% elif a == 763 %}763\n{% elif a == 764 %}764\n{% elif a == 765 %}765\n{% elif a == 766 %}766\n{% elif a == 767 %}767\n{% elif a == 768 %}768\n{% elif a == 769 %}769\n{% elif a == 770 %}770\n{% elif a == 771 %}771\n{% elif a == 772 %}772\n{% elif a == 773 %}773\n{% elif a == 774 %}774\n{% elif a == 775 %}775\n{% elif a == 776 %}776\n{% elif a == 777 %}777\n{% elif a == 778 %}778\n{% elif a == 779 %}779\n{% elif a == 780 %}780\n{% elif a == 781 %}781\n{% elif a == 782 %}782\n{% elif a == 783 %}783\n{% elif a == 784 %}784\n{% elif a == 785 %}785\n{% elif a == 786 %}786\n{% elif a == 787 %}787\n{% elif a == 788 %}788\n{% elif a == 789 %}789\n{% elif a == 790 %}790\n{% elif a == 791 %}791\n{% elif a == 792 %}792\n{% elif a == 793 %}793\n{% elif a == 794 %}794\n{% elif a == 795 %}795\n{% elif a == 796 %}796\n{% elif a == 797 %}797\n{% elif a == 798 %}798\n{% elif a == 799 %}799\n{% elif a == 800 %}800\n{% elif a == 801 %}801\n{% elif a == 802 %}802\n{% elif a == 803 %}803\n{% elif a == 804 %}804\n{% elif a == 805 %}805\n{% elif a == 806 %}806\n{% elif a == 807 %}807\n{% elif a == 808 %}808\n{% elif a == 809 %}809\n{% elif a == 810 %}810\n{% elif a == 811 %}811\n{% elif a == 812 %}812\n{% elif a == 813 %}813\n{% elif a == 814 %}814\n{% elif a == 815 %}815\n{% elif a == 816 %}816\n{% elif a == 817 %}817\n{% elif a == 818 %}818\n{% elif a == 819 %}819\n{% elif a == 820 %}820\n{% elif a == 821 %}821\n{% elif a == 822 %}822\n{% elif a == 823 %}823\n{% elif a == 824 %}824\n{% elif a == 825 %}825\n{% elif a == 826 %}826\n{% elif a == 827 %}827\n{% elif a == 828 %}828\n{% elif a == 829 %}829\n{% elif a == 830 %}830\n{% elif a == 831 %}831\n{% elif a == 832 %}832\n{% elif a == 833 %}833\n{% elif a == 834 %}834\n{% elif a == 835 %}835\n{% elif a == 836 %}836\n{% elif a == 837 %}837\n{% elif a == 838 %}838\n{% elif a == 839 %}839\n{% elif a == 840 %}840\n{% elif a == 841 %}841\n{% elif a == 842 %}842\n{% elif a == 843 %}843\n{% elif a == 844 %}844\n{% elif a == 845 %}845\n{% elif a == 846 %}846\n{% elif a == 847 %}847\n{% elif a == 848 %}848\n{% elif a == 849 %}849\n{% elif a == 850 %}850\n{% elif a == 851 %}851\n{% elif a == 852 %}852\n{% elif a == 853 %}853\n{% elif a == 854 %}854\n{% elif a == 855 %}855\n{% elif a == 856 %}856\n{% elif a == 857 %}857\n{% elif a == 858 %}858\n{% elif a == 859 %}859\n{% elif a == 860 %}860\n{% elif a == 861 %}861\n{% elif a == 862 %}862\n{% elif a == 863 %}863\n{% elif a == 864 %}864\n{% elif a == 865 %}865\n{% elif a == 866 %}866\n{% elif a == 867 %}867\n{% elif a == 868 %}868\n{% elif a == 869 %}869\n{% elif a == 870 %}870\n{% elif a == 871 %}871\n{% elif a == 872 %}872\n{% elif a == 873 %}873\n{% elif a == 874 %}874\n{% elif a == 875 %}875\n{% elif a == 876 %}876\n{% elif a == 877 %}877\n{% elif a == 878 %}878\n{% elif a == 879 %}879\n{% elif a == 880 %}880\n{% elif a == 881 %}881\n{% elif a == 882 %}882\n{% elif a == 883 %}883\n{% elif a == 884 %}884\n{% elif a == 885 %}885\n{% elif a == 886 %}886\n{% elif a == 887 %}887\n{% elif a == 888 %}888\n{% elif a == 889 %}889\n{% elif a == 890 %}890\n{% elif a == 891 %}891\n{% elif a == 892 %}892\n{% elif a == 893 %}893\n{% elif a == 894 %}894\n{% elif a == 895 %}895\n{% elif a == 896 %}896\n{% elif a == 897 %}897\n{% elif a == 898 %}898\n{% elif a == 899 %}899\n{% elif a == 900 %}900\n{% elif a == 901 %}901\n{% elif a == 902 %}902\n{% elif a == 903 %}903\n{% elif a == 904 %}904\n{% elif a == 905 %}905\n{% elif a == 906 %}906\n{% elif a == 907 %}907\n{% elif a == 908 %}908\n{% elif a == 909 %}909\n{% elif a == 910 %}910\n{% elif a == 911 %}911\n{% elif a == 912 %}912\n{% elif a == 913 %}913\n{% elif a == 914 %}914\n{% elif a == 915 %}915\n{% elif a == 916 %}916\n{% elif a == 917 %}917\n{% elif a == 918 %}918\n{% elif a == 919 %}919\n{% elif a == 920 %}920\n{% elif a == 921 %}921\n{% elif a == 922 %}922\n{% elif a == 923 %}923\n{% elif a == 924 %}924\n{% elif a == 925 %}925\n{% elif a == 926 %}926\n{% elif a == 927 %}927\n{% elif a == 928 %}928\n{% elif a == 929 %}929\n{% elif a == 930 %}930\n{% elif a == 931 %}931\n{% elif a == 932 %}932\n{% elif a == 933 %}933\n{% elif a == 934 %}934\n{% elif a == 935 %}935\n{% elif a == 936 %}936\n{% elif a == 937 %}937\n{% elif a == 938 %}938\n{% elif a == 939 %}939\n{% elif a == 940 %}940\n{% elif a == 941 %}941\n{% elif a == 942 %}942\n{% elif a == 943 %}943\n{% elif a == 944 %}944\n{% elif a == 945 %}945\n{% elif a == 946 %}946\n{% elif a == 947 %}947\n{% elif a == 948 %}948\n{% elif a == 949 %}949\n{% elif a == 950 %}950\n{% elif a == 951 %}951\n{% elif a == 952 %}952\n{% elif a == 953 %}953\n{% elif a == 954 %}954\n{% elif a == 955 %}955\n{% elif a == 956 %}956\n{% elif a == 957 %}957\n{% elif a == 958 %}958\n{% elif a == 959 %}959\n{% elif a == 960 %}960\n{% elif a == 961 %}961\n{% elif a == 962 %}962\n{% elif a == 963 %}963\n{% elif a == 964 %}964\n{% elif a == 965 %}965\n{% elif a == 966 %}966\n{% elif a == 967 %}967\n{% elif a == 968 %}968\n{% elif a == 969 %}969\n{% elif a == 970 %}970\n{% elif a == 971 %}971\n{% elif a == 972 %}972\n{% elif a == 973 %}973\n{% elif a == 974 %}974\n{% elif a == 975 %}975\n{% elif a == 976 %}976\n{% elif a == 977 %}977\n{% elif a == 978 %}978\n{% elif a == 979 %}979\n{% elif a == 980 %}980\n{% elif a == 981 %}981\n{% elif a == 982 %}982\n{% elif a == 983 %}983\n{% elif a == 984 %}984\n{% elif a == 985 %}985\n{% elif a == 986 %}986\n{% elif a == 987 %}987\n{% elif a == 988 %}988\n{% elif a == 989 %}989\n{% elif a == 990 %}990\n{% elif a == 991 %}991\n{% elif a == 992 %}992\n{% elif a == 993 %}993\n{% elif a == 994 %}994\n{% elif a == 995 %}995\n{% elif a == 996 %}996\n{% elif a == 997 %}997\n{% elif a == 998 %}998\n{% elif a == 999 %}999{% else %}x{% endif %}",
    "{\"a\": 999}",
    output="999",
  )
}

///|
test "jinja test_core_tags TestIfCondition::test_elif_deep #4" {
  jinja(
    source="{% if a == 0 %}0{% elif a == 1 %}1\n{% elif a == 2 %}2\n{% elif a == 3 %}3\n{% elif a == 4 %}4\n{% elif a == 5 %}5\n{% elif a == 6 %}6\n{% elif a == 7 %}7\n{% elif a == 8 %}8\n{% elif a == 9 %}9\n{% elif a == 10 %}10\n{% elif a == 11 %}11\n{% elif a == 12 %}12\n{% elif a == 13 %}13\n{% elif a == 14 %}14\n{% elif a == 15 %}15\n{% elif a == 16 %}16\n{% elif a == 17 %}17\n{% elif a == 18 %}18\n{% elif a == 19 %}19\n{% elif a == 20 %}20\n{% elif a == 21 %}21\n{% elif a == 22 %}22\n{% elif a == 23 %}23\n{% elif a == 24 %}24\n{% elif a == 25 %}25\n{% elif a == 26 %}26\n{% elif a == 27 %}27\n{% elif a == 28 %}28\n{% elif a == 29 %}29\n{% elif a == 30 %}30\n{% elif a == 31 %}31\n{% elif a == 32 %}32\n{% elif a == 33 %}33\n{% elif a == 34 %}34\n{% elif a == 35 %}35\n{% elif a == 36 %}36\n{% elif a == 37 %}37\n{% elif a == 38 %}38\n{% elif a == 39 %}39\n{% elif a == 40 %}40\n{% elif a == 41 %}41\n{% elif a == 42 %}42\n{% elif a == 43 %}43\n{% elif a == 44 %}44\n{% elif a == 45 %}45\n{% elif a == 46 %}46\n{% elif a == 47 %}47\n{% elif a == 48 %}48\n{% elif a == 49 %}49\n{% elif a == 50 %}50\n{% elif a == 51 %}51\n{% elif a == 52 %}52\n{% elif a == 53 %}53\n{% elif a == 54 %}54\n{% elif a == 55 %}55\n{% elif a == 56 %}56\n{% elif a == 57 %}57\n{% elif a == 58 %}58\n{% elif a == 59 %}59\n{% elif a == 60 %}60\n{% elif a == 61 %}61\n{% elif a == 62 %}62\n{% elif a == 63 %}63\n{% elif a == 64 %}64\n{% elif a == 65 %}65\n{% elif a == 66 %}66\n{% elif a == 67 %}67\n{% elif a == 68 %}68\n{% elif a == 69 %}69\n{% elif a == 70 %}70\n{% elif a == 71 %}71\n{% elif a == 72 %}72\n{% elif a == 73 %}73\n{% elif a == 74 %}74\n{% elif a == 75 %}75\n{% elif a == 76 %}76\n{% elif a == 77 %}77\n{% elif a == 78 %}78\n{% elif a == 79 %}79\n{% elif a == 80 %}80\n{% elif a == 81 %}81\n{% elif a == 82 %}82\n{% elif a == 83 %}83\n{% elif a == 84 %}84\n{% elif a == 85 %}85\n{% elif a == 86 %}86\n{% elif a == 87 %}87\n{% elif a == 88 %}88\n{% elif a == 89 %}89\n{% elif a == 90 %}90\n{% elif a == 91 %}91\n{% elif a == 92 %}92\n{% elif a == 93 %}93\n{% elif a == 94 %}94\n{% elif a == 95 %}95\n{% elif a == 96 %}96\n{% elif a == 97 %}97\n{% elif a == 98 %}98\n{% elif a == 99 %}99\n{% elif a == 100 %}100\n{% elif a == 101 %}101\n{% elif a == 102 %}102\n{% elif a == 103 %}103\n{% elif a == 104 %}104\n{% elif a == 105 %}105\n{% elif a == 106 %}106\n{% elif a == 107 %}107\n{% elif a == 108 %}108\n{% elif a == 109 %}109\n{% elif a == 110 %}110\n{% elif a == 111 %}111\n{% elif a == 112 %}112\n{% elif a == 113 %}113\n{% elif a == 114 %}114\n{% elif a == 115 %}115\n{% elif a == 116 %}116\n{% elif a == 117 %}117\n{% elif a == 118 %}118\n{% elif a == 119 %}119\n{% elif a == 120 %}120\n{% elif a == 121 %}121\n{% elif a == 122 %}122\n{% elif a == 123 %}123\n{% elif a == 124 %}124\n{% elif a == 125 %}125\n{% elif a == 126 %}126\n{% elif a == 127 %}127\n{% elif a == 128 %}128\n{% elif a == 129 %}129\n{% elif a == 130 %}130\n{% elif a == 131 %}131\n{% elif a == 132 %}132\n{% elif a == 133 %}133\n{% elif a == 134 %}134\n{% elif a == 135 %}135\n{% elif a == 136 %}136\n{% elif a == 137 %}137\n{% elif a == 138 %}138\n{% elif a == 139 %}139\n{% elif a == 140 %}140\n{% elif a == 141 %}141\n{% elif a == 142 %}142\n{% elif a == 143 %}143\n{% elif a == 144 %}144\n{% elif a == 145 %}145\n{% elif a == 146 %}146\n{% elif a == 147 %}147\n{% elif a == 148 %}148\n{% elif a == 149 %}149\n{% elif a == 150 %}150\n{% elif a == 151 %}151\n{% elif a == 152 %}152\n{% elif a == 153 %}153\n{% elif a == 154 %}154\n{% elif a == 155 %}155\n{% elif a == 156 %}156\n{% elif a == 157 %}157\n{% elif a == 158 %}158\n{% elif a == 159 %}159\n{% elif a == 160 %}160\n{% elif a == 161 %}161\n{% elif a == 162 %}162\n{% elif a == 163 %}163\n{% elif a == 164 %}164\n{% elif a == 165 %}165\n{% elif a == 166 %}166\n{% elif a == 167 %}167\n{% elif a == 168 %}168\n{% elif a == 169 %}169\n{% elif a == 170 %}170\n{% elif a == 171 %}171\n{% elif a == 172 %}172\n{% elif a == 173 %}173\n{% elif a == 174 %}174\n{% elif a == 175 %}175\n{% elif a == 176 %}176\n{% elif a == 177 %}177\n{% elif a == 178 %}178\n{% elif a == 179 %}179\n{% elif a == 180 %}180\n{% elif a == 181 %}181\n{% elif a == 182 %}182\n{% elif a == 183 %}183\n{% elif a == 184 %}184\n{% elif a == 185 %}185\n{% elif a == 186 %}186\n{% elif a == 187 %}187\n{% elif a == 188 %}188\n{% elif a == 189 %}189\n{% elif a == 190 %}190\n{% elif a == 191 %}191\n{% elif a == 192 %}192\n{% elif a == 193 %}193\n{% elif a == 194 %}194\n{% elif a == 195 %}195\n{% elif a == 196 %}196\n{% elif a == 197 %}197\n{% elif a == 198 %}198\n{% elif a == 199 %}199\n{% elif a == 200 %}200\n{% elif a == 201 %}201\n{% elif a == 202 %}202\n{% elif a == 203 %}203\n{% elif a == 204 %}204\n{% elif a == 205 %}205\n{% elif a == 206 %}206\n{% elif a == 207 %}207\n{% elif a == 208 %}208\n{% elif a == 209 %}209\n{% elif a == 210 %}210\n{% elif a == 211 %}211\n{% elif a == 212 %}212\n{% elif a == 213 %}213\n{% elif a == 214 %}214\n{% elif a == 215 %}215\n{% elif a == 216 %}216\n{% elif a == 217 %}217\n{% elif a == 218 %}218\n{% elif a == 219 %}219\n{% elif a == 220 %}220\n{% elif a == 221 %}221\n{% elif a == 222 %}222\n{% elif a == 223 %}223\n{% elif a == 224 %}224\n{% elif a == 225 %}225\n{% elif a == 226 %}226\n{% elif a == 227 %}227\n{% elif a == 228 %}228\n{% elif a == 229 %}229\n{% elif a == 230 %}230\n{% elif a == 231 %}231\n{% elif a == 232 %}232\n{% elif a == 233 %}233\n{% elif a == 234 %}234\n{% elif a == 235 %}235\n{% elif a == 236 %}236\n{% elif a == 237 %}237\n{% elif a == 238 %}238\n{% elif a == 239 %}239\n{% elif a == 240 %}240\n{% elif a == 241 %}241\n{% elif a == 242 %}242\n{% elif a == 243 %}243\n{% elif a == 244 %}244\n{% elif a == 245 %}245\n{% elif a == 246 %}246\n{% elif a == 247 %}247\n{% elif a == 248 %}248\n{% elif a == 249 %}249\n{% elif a == 250 %}250\n{% elif a == 251 %}251\n{% elif a == 252 %}252\n{% elif a == 253 %}253\n{% elif a == 254 %}254\n{% elif a == 255 %}255\n{% elif a == 256 %}256\n{% elif a == 257 %}257\n{% elif a == 258 %}258\n{% elif a == 259 %}259\n{% elif a == 260 %}260\n{% elif a == 261 %}261\n{% elif a == 262 %}262\n{% elif a == 263 %}263\n{% elif a == 264 %}264\n{% elif a == 265 %}265\n{% elif a == 266 %}266\n{% elif a == 267 %}267\n{% elif a == 268 %}268\n{% elif a == 269 %}269\n{% elif a == 270 %}270\n{% elif a == 271 %}271\n{% elif a == 272 %}272\n{% elif a == 273 %}273\n{% elif a == 274 %}274\n{% elif a == 275 %}275\n{% elif a == 276 %}276\n{% elif a == 277 %}277\n{% elif a == 278 %}278\n{% elif a == 279 %}279\n{% elif a == 280 %}280\n{% elif a == 281 %}281\n{% elif a == 282 %}282\n{% elif a == 283 %}283\n{% elif a == 284 %}284\n{% elif a == 285 %}285\n{% elif a == 286 %}286\n{% elif a == 287 %}287\n{% elif a == 288 %}288\n{% elif a == 289 %}289\n{% elif a == 290 %}290\n{% elif a == 291 %}291\n{% elif a == 292 %}292\n{% elif a == 293 %}293\n{% elif a == 294 %}294\n{% elif a == 295 %}295\n{% elif a == 296 %}296\n{% elif a == 297 %}297\n{% elif a == 298 %}298\n{% elif a == 299 %}299\n{% elif a == 300 %}300\n{% elif a == 301 %}301\n{% elif a == 302 %}302\n{% elif a == 303 %}303\n{% elif a == 304 %}304\n{% elif a == 305 %}305\n{% elif a == 306 %}306\n{% elif a == 307 %}307\n{% elif a == 308 %}308\n{% elif a == 309 %}309\n{% elif a == 310 %}310\n{% elif a == 311 %}311\n{% elif a == 312 %}312\n{% elif a == 313 %}313\n{% elif a == 314 %}314\n{% elif a == 315 %}315\n{% elif a == 316 %}316\n{% elif a == 317 %}317\n{% elif a == 318 %}318\n{% elif a == 319 %}319\n{% elif a == 320 %}320\n{% elif a == 321 %}321\n{% elif a == 322 %}322\n{% elif a == 323 %}323\n{% elif a == 324 %}324\n{% elif a == 325 %}325\n{% elif a == 326 %}326\n{% elif a == 327 %}327\n{% elif a == 328 %}328\n{% elif a == 329 %}329\n{% elif a == 330 %}330\n{% elif a == 331 %}331\n{% elif a == 332 %}332\n{% elif a == 333 %}333\n{% elif a == 334 %}334\n{% elif a == 335 %}335\n{% elif a == 336 %}336\n{% elif a == 337 %}337\n{% elif a == 338 %}338\n{% elif a == 339 %}339\n{% elif a == 340 %}340\n{% elif a == 341 %}341\n{% elif a == 342 %}342\n{% elif a == 343 %}343\n{% elif a == 344 %}344\n{% elif a == 345 %}345\n{% elif a == 346 %}346\n{% elif a == 347 %}347\n{% elif a == 348 %}348\n{% elif a == 349 %}349\n{% elif a == 350 %}350\n{% elif a == 351 %}351\n{% elif a == 352 %}352\n{% elif a == 353 %}353\n{% elif a == 354 %}354\n{% elif a == 355 %}355\n{% elif a == 356 %}356\n{% elif a == 357 %}357\n{% elif a == 358 %}358\n{% elif a == 359 %}359\n{% elif a == 360 %}360\n{% elif a == 361 %}361\n{% elif a == 362 %}362\n{% elif a == 363 %}363\n{% elif a == 364 %}364\n{% elif a == 365 %}365\n{% elif a == 366 %}366\n{% elif a == 367 %}367\n{% elif a == 368 %}368\n{% elif a == 369 %}369\n{% elif a == 370 %}370\n{% elif a == 371 %}371\n{% elif a == 372 %}372\n{% elif a == 373 %}373\n{% elif a == 374 %}374\n{% elif a == 375 %}375\n{% elif a == 376 %}376\n{% elif a == 377 %}377\n{% elif a == 378 %}378\n{% elif a == 379 %}379\n{% elif a == 380 %}380\n{% elif a == 381 %}381\n{% elif a == 382 %}382\n{% elif a == 383 %}383\n{% elif a == 384 %}384\n{% elif a == 385 %}385\n{% elif a == 386 %}386\n{% elif a == 387 %}387\n{% elif a == 388 %}388\n{% elif a == 389 %}389\n{% elif a == 390 %}390\n{% elif a == 391 %}391\n{% elif a == 392 %}392\n{% elif a == 393 %}393\n{% elif a == 394 %}394\n{% elif a == 395 %}395\n{% elif a == 396 %}396\n{% elif a == 397 %}397\n{% elif a == 398 %}398\n{% elif a == 399 %}399\n{% elif a == 400 %}400\n{% elif a == 401 %}401\n{% elif a == 402 %}402\n{% elif a == 403 %}403\n{% elif a == 404 %}404\n{% elif a == 405 %}405\n{% elif a == 406 %}406\n{% elif a == 407 %}407\n{% elif a == 408 %}408\n{% elif a == 409 %}409\n{% elif a == 410 %}410\n{% elif a == 411 %}411\n{% elif a == 412 %}412\n{% elif a == 413 %}413\n{% elif a == 414 %}414\n{% elif a == 415 %}415\n{% elif a == 416 %}416\n{% elif a == 417 %}417\n{% elif a == 418 %}418\n{% elif a == 419 %}419\n{% elif a == 420 %}420\n{% elif a == 421 %}421\n{% elif a == 422 %}422\n{% elif a == 423 %}423\n{% elif a == 424 %}424\n{% elif a == 425 %}425\n{% elif a == 426 %}426\n{% elif a == 427 %}427\n{% elif a == 428 %}428\n{% elif a == 429 %}429\n{% elif a == 430 %}430\n{% elif a == 431 %}431\n{% elif a == 432 %}432\n{% elif a == 433 %}433\n{% elif a == 434 %}434\n{% elif a == 435 %}435\n{% elif a == 436 %}436\n{% elif a == 437 %}437\n{% elif a == 438 %}438\n{% elif a == 439 %}439\n{% elif a == 440 %}440\n{% elif a == 441 %}441\n{% elif a == 442 %}442\n{% elif a == 443 %}443\n{% elif a == 444 %}444\n{% elif a == 445 %}445\n{% elif a == 446 %}446\n{% elif a == 447 %}447\n{% elif a == 448 %}448\n{% elif a == 449 %}449\n{% elif a == 450 %}450\n{% elif a == 451 %}451\n{% elif a == 452 %}452\n{% elif a == 453 %}453\n{% elif a == 454 %}454\n{% elif a == 455 %}455\n{% elif a == 456 %}456\n{% elif a == 457 %}457\n{% elif a == 458 %}458\n{% elif a == 459 %}459\n{% elif a == 460 %}460\n{% elif a == 461 %}461\n{% elif a == 462 %}462\n{% elif a == 463 %}463\n{% elif a == 464 %}464\n{% elif a == 465 %}465\n{% elif a == 466 %}466\n{% elif a == 467 %}467\n{% elif a == 468 %}468\n{% elif a == 469 %}469\n{% elif a == 470 %}470\n{% elif a == 471 %}471\n{% elif a == 472 %}472\n{% elif a == 473 %}473\n{% elif a == 474 %}474\n{% elif a == 475 %}475\n{% elif a == 476 %}476\n{% elif a == 477 %}477\n{% elif a == 478 %}478\n{% elif a == 479 %}479\n{% elif a == 480 %}480\n{% elif a == 481 %}481\n{% elif a == 482 %}482\n{% elif a == 483 %}483\n{% elif a == 484 %}484\n{% elif a == 485 %}485\n{% elif a == 486 %}486\n{% elif a == 487 %}487\n{% elif a == 488 %}488\n{% elif a == 489 %}489\n{% elif a == 490 %}490\n{% elif a == 491 %}491\n{% elif a == 492 %}492\n{% elif a == 493 %}493\n{% elif a == 494 %}494\n{% elif a == 495 %}495\n{% elif a == 496 %}496\n{% elif a == 497 %}497\n{% elif a == 498 %}498\n{% elif a == 499 %}499\n{% elif a == 500 %}500\n{% elif a == 501 %}501\n{% elif a == 502 %}502\n{% elif a == 503 %}503\n{% elif a == 504 %}504\n{% elif a == 505 %}505\n{% elif a == 506 %}506\n{% elif a == 507 %}507\n{% elif a == 508 %}508\n{% elif a == 509 %}509\n{% elif a == 510 %}510\n{% elif a == 511 %}511\n{% elif a == 512 %}512\n{% elif a == 513 %}513\n{% elif a == 514 %}514\n{% elif a == 515 %}515\n{% elif a == 516 %}516\n{% elif a == 517 %}517\n{% elif a == 518 %}518\n{% elif a == 519 %}519\n{% elif a == 520 %}520\n{% elif a == 521 %}521\n{% elif a == 522 %}522\n{% elif a == 523 %}523\n{% elif a == 524 %}524\n{% elif a == 525 %}525\n{% elif a == 526 %}526\n{% elif a == 527 %}527\n{% elif a == 528 %}528\n{% elif a == 529 %}529\n{% elif a == 530 %}530\n{% elif a == 531 %}531\n{% elif a == 532 %}532\n{% elif a == 533 %}533\n{% elif a == 534 %}534\n{% elif a == 535 %}535\n{% elif a == 536 %}536\n{% elif a == 537 %}537\n{% elif a == 538 %}538\n{% elif a == 539 %}539\n{% elif a == 540 %}540\n{% elif a == 541 %}541\n{% elif a == 542 %}542\n{% elif a == 543 %}543\n{% elif a == 544 %}544\n{% elif a == 545 %}545\n{% elif a == 546 %}546\n{% elif a == 547 %}547\n{% elif a == 548 %}548\n{% elif a == 549 %}549\n{% elif a == 550 %}550\n{% elif a == 551 %}551\n{% elif a == 552 %}552\n{% elif a == 553 %}553\n{% elif a == 554 %}554\n{% elif a == 555 %}555\n{% elif a == 556 %}556\n{% elif a == 557 %}557\n{% elif a == 558 %}558\n{% elif a == 559 %}559\n{% elif a == 560 %}560\n{% elif a == 561 %}561\n{% elif a == 562 %}562\n{% elif a == 563 %}563\n{% elif a == 564 %}564\n{% elif a == 565 %}565\n{% elif a == 566 %}566\n{% elif a == 567 %}567\n{% elif a == 568 %}568\n{% elif a == 569 %}569\n{% elif a == 570 %}570\n{% elif a == 571 %}571\n{% elif a == 572 %}572\n{% elif a == 573 %}573\n{% elif a == 574 %}574\n{% elif a == 575 %}575\n{% elif a == 576 %}576\n{% elif a == 577 %}577\n{% elif a == 578 %}578\n{% elif a == 579 %}579\n{% elif a == 580 %}580\n{% elif a == 581 %}581\n{% elif a == 582 %}582\n{% elif a == 583 %}583\n{% elif a == 584 %}584\n{% elif a == 585 %}585\n{% elif a == 586 %}586\n{% elif a == 587 %}587\n{% elif a == 588 %}588\n{% elif a == 589 %}589\n{% elif a == 590 %}590\n{% elif a == 591 %}591\n{% elif a == 592 %}592\n{% elif a == 593 %}593\n{% elif a == 594 %}594\n{% elif a == 595 %}595\n{% elif a == 596 %}596\n{% elif a == 597 %}597\n{% elif a == 598 %}598\n{% elif a == 599 %}599\n{% elif a == 600 %}600\n{% elif a == 601 %}601\n{% elif a == 602 %}602\n{% elif a == 603 %}603\n{% elif a == 604 %}604\n{% elif a == 605 %}605\n{% elif a == 606 %}606\n{% elif a == 607 %}607\n{% elif a == 608 %}608\n{% elif a == 609 %}609\n{% elif a == 610 %}610\n{% elif a == 611 %}611\n{% elif a == 612 %}612\n{% elif a == 613 %}613\n{% elif a == 614 %}614\n{% elif a == 615 %}615\n{% elif a == 616 %}616\n{% elif a == 617 %}617\n{% elif a == 618 %}618\n{% elif a == 619 %}619\n{% elif a == 620 %}620\n{% elif a == 621 %}621\n{% elif a == 622 %}622\n{% elif a == 623 %}623\n{% elif a == 624 %}624\n{% elif a == 625 %}625\n{% elif a == 626 %}626\n{% elif a == 627 %}627\n{% elif a == 628 %}628\n{% elif a == 629 %}629\n{% elif a == 630 %}630\n{% elif a == 631 %}631\n{% elif a == 632 %}632\n{% elif a == 633 %}633\n{% elif a == 634 %}634\n{% elif a == 635 %}635\n{% elif a == 636 %}636\n{% elif a == 637 %}637\n{% elif a == 638 %}638\n{% elif a == 639 %}639\n{% elif a == 640 %}640\n{% elif a == 641 %}641\n{% elif a == 642 %}642\n{% elif a == 643 %}643\n{% elif a == 644 %}644\n{% elif a == 645 %}645\n{% elif a == 646 %}646\n{% elif a == 647 %}647\n{% elif a == 648 %}648\n{% elif a == 649 %}649\n{% elif a == 650 %}650\n{% elif a == 651 %}651\n{% elif a == 652 %}652\n{% elif a == 653 %}653\n{% elif a == 654 %}654\n{% elif a == 655 %}655\n{% elif a == 656 %}656\n{% elif a == 657 %}657\n{% elif a == 658 %}658\n{% elif a == 659 %}659\n{% elif a == 660 %}660\n{% elif a == 661 %}661\n{% elif a == 662 %}662\n{% elif a == 663 %}663\n{% elif a == 664 %}664\n{% elif a == 665 %}665\n{% elif a == 666 %}666\n{% elif a == 667 %}667\n{% elif a == 668 %}668\n{% elif a == 669 %}669\n{% elif a == 670 %}670\n{% elif a == 671 %}671\n{% elif a == 672 %}672\n{% elif a == 673 %}673\n{% elif a == 674 %}674\n{% elif a == 675 %}675\n{% elif a == 676 %}676\n{% elif a == 677 %}677\n{% elif a == 678 %}678\n{% elif a == 679 %}679\n{% elif a == 680 %}680\n{% elif a == 681 %}681\n{% elif a == 682 %}682\n{% elif a == 683 %}683\n{% elif a == 684 %}684\n{% elif a == 685 %}685\n{% elif a == 686 %}686\n{% elif a == 687 %}687\n{% elif a == 688 %}688\n{% elif a == 689 %}689\n{% elif a == 690 %}690\n{% elif a == 691 %}691\n{% elif a == 692 %}692\n{% elif a == 693 %}693\n{% elif a == 694 %}694\n{% elif a == 695 %}695\n{% elif a == 696 %}696\n{% elif a == 697 %}697\n{% elif a == 698 %}698\n{% elif a == 699 %}699\n{% elif a == 700 %}700\n{% elif a == 701 %}701\n{% elif a == 702 %}702\n{% elif a == 703 %}703\n{% elif a == 704 %}704\n{% elif a == 705 %}705\n{% elif a == 706 %}706\n{% elif a == 707 %}707\n{% elif a == 708 %}708\n{% elif a == 709 %}709\n{% elif a == 710 %}710\n{% elif a == 711 %}711\n{% elif a == 712 %}712\n{% elif a == 713 %}713\n{% elif a == 714 %}714\n{% elif a == 715 %}715\n{% elif a == 716 %}716\n{% elif a == 717 %}717\n{% elif a == 718 %}718\n{% elif a == 719 %}719\n{% elif a == 720 %}720\n{% elif a == 721 %}721\n{% elif a == 722 %}722\n{% elif a == 723 %}723\n{% elif a == 724 %}724\n{% elif a == 725 %}725\n{% elif a == 726 %}726\n{% elif a == 727 %}727\n{% elif a == 728 %}728\n{% elif a == 729 %}729\n{% elif a == 730 %}730\n{% elif a == 731 %}731\n{% elif a == 732 %}732\n{% elif a == 733 %}733\n{% elif a == 734 %}734\n{% elif a == 735 %}735\n{% elif a == 736 %}736\n{% elif a == 737 %}737\n{% elif a == 738 %}738\n{% elif a == 739 %}739\n{% elif a == 740 %}740\n{% elif a == 741 %}741\n{% elif a == 742 %}742\n{% elif a == 743 %}743\n{% elif a == 744 %}744\n{% elif a == 745 %}745\n{% elif a == 746 %}746\n{% elif a == 747 %}747\n{% elif a == 748 %}748\n{% elif a == 749 %}749\n{% elif a == 750 %}750\n{% elif a == 751 %}751\n{% elif a == 752 %}752\n{% elif a == 753 %}753\n{% elif a == 754 %}754\n{% elif a == 755 %}755\n{% elif a == 756 %}756\n{% elif a == 757 %}757\n{% elif a == 758 %}758\n{% elif a == 759 %}759\n{% elif a == 760 %}760\n{% elif a == 761 %}761\n{% elif a == 762 %}762\n{% elif a == 763 %}763\n{% elif a == 764 %}764\n{% elif a == 765 %}765\n{% elif a == 766 %}766\n{% elif a == 767 %}767\n{% elif a == 768 %}768\n{% elif a == 769 %}769\n{% elif a == 770 %}770\n{% elif a == 771 %}771\n{% elif a == 772 %}772\n{% elif a == 773 %}773\n{% elif a == 774 %}774\n{% elif a == 775 %}775\n{% elif a == 776 %}776\n{% elif a == 777 %}777\n{% elif a == 778 %}778\n{% elif a == 779 %}779\n{% elif a == 780 %}780\n{% elif a == 781 %}781\n{% elif a == 782 %}782\n{% elif a == 783 %}783\n{% elif a == 784 %}784\n{% elif a == 785 %}785\n{% elif a == 786 %}786\n{% elif a == 787 %}787\n{% elif a == 788 %}788\n{% elif a == 789 %}789\n{% elif a == 790 %}790\n{% elif a == 791 %}791\n{% elif a == 792 %}792\n{% elif a == 793 %}793\n{% elif a == 794 %}794\n{% elif a == 795 %}795\n{% elif a == 796 %}796\n{% elif a == 797 %}797\n{% elif a == 798 %}798\n{% elif a == 799 %}799\n{% elif a == 800 %}800\n{% elif a == 801 %}801\n{% elif a == 802 %}802\n{% elif a == 803 %}803\n{% elif a == 804 %}804\n{% elif a == 805 %}805\n{% elif a == 806 %}806\n{% elif a == 807 %}807\n{% elif a == 808 %}808\n{% elif a == 809 %}809\n{% elif a == 810 %}810\n{% elif a == 811 %}811\n{% elif a == 812 %}812\n{% elif a == 813 %}813\n{% elif a == 814 %}814\n{% elif a == 815 %}815\n{% elif a == 816 %}816\n{% elif a == 817 %}817\n{% elif a == 818 %}818\n{% elif a == 819 %}819\n{% elif a == 820 %}820\n{% elif a == 821 %}821\n{% elif a == 822 %}822\n{% elif a == 823 %}823\n{% elif a == 824 %}824\n{% elif a == 825 %}825\n{% elif a == 826 %}826\n{% elif a == 827 %}827\n{% elif a == 828 %}828\n{% elif a == 829 %}829\n{% elif a == 830 %}830\n{% elif a == 831 %}831\n{% elif a == 832 %}832\n{% elif a == 833 %}833\n{% elif a == 834 %}834\n{% elif a == 835 %}835\n{% elif a == 836 %}836\n{% elif a == 837 %}837\n{% elif a == 838 %}838\n{% elif a == 839 %}839\n{% elif a == 840 %}840\n{% elif a == 841 %}841\n{% elif a == 842 %}842\n{% elif a == 843 %}843\n{% elif a == 844 %}844\n{% elif a == 845 %}845\n{% elif a == 846 %}846\n{% elif a == 847 %}847\n{% elif a == 848 %}848\n{% elif a == 849 %}849\n{% elif a == 850 %}850\n{% elif a == 851 %}851\n{% elif a == 852 %}852\n{% elif a == 853 %}853\n{% elif a == 854 %}854\n{% elif a == 855 %}855\n{% elif a == 856 %}856\n{% elif a == 857 %}857\n{% elif a == 858 %}858\n{% elif a == 859 %}859\n{% elif a == 860 %}860\n{% elif a == 861 %}861\n{% elif a == 862 %}862\n{% elif a == 863 %}863\n{% elif a == 864 %}864\n{% elif a == 865 %}865\n{% elif a == 866 %}866\n{% elif a == 867 %}867\n{% elif a == 868 %}868\n{% elif a == 869 %}869\n{% elif a == 870 %}870\n{% elif a == 871 %}871\n{% elif a == 872 %}872\n{% elif a == 873 %}873\n{% elif a == 874 %}874\n{% elif a == 875 %}875\n{% elif a == 876 %}876\n{% elif a == 877 %}877\n{% elif a == 878 %}878\n{% elif a == 879 %}879\n{% elif a == 880 %}880\n{% elif a == 881 %}881\n{% elif a == 882 %}882\n{% elif a == 883 %}883\n{% elif a == 884 %}884\n{% elif a == 885 %}885\n{% elif a == 886 %}886\n{% elif a == 887 %}887\n{% elif a == 888 %}888\n{% elif a == 889 %}889\n{% elif a == 890 %}890\n{% elif a == 891 %}891\n{% elif a == 892 %}892\n{% elif a == 893 %}893\n{% elif a == 894 %}894\n{% elif a == 895 %}895\n{% elif a == 896 %}896\n{% elif a == 897 %}897\n{% elif a == 898 %}898\n{% elif a == 899 %}899\n{% elif a == 900 %}900\n{% elif a == 901 %}901\n{% elif a == 902 %}902\n{% elif a == 903 %}903\n{% elif a == 904 %}904\n{% elif a == 905 %}905\n{% elif a == 906 %}906\n{% elif a == 907 %}907\n{% elif a == 908 %}908\n{% elif a == 909 %}909\n{% elif a == 910 %}910\n{% elif a == 911 %}911\n{% elif a == 912 %}912\n{% elif a == 913 %}913\n{% elif a == 914 %}914\n{% elif a == 915 %}915\n{% elif a == 916 %}916\n{% elif a == 917 %}917\n{% elif a == 918 %}918\n{% elif a == 919 %}919\n{% elif a == 920 %}920\n{% elif a == 921 %}921\n{% elif a == 922 %}922\n{% elif a == 923 %}923\n{% elif a == 924 %}924\n{% elif a == 925 %}925\n{% elif a == 926 %}926\n{% elif a == 927 %}927\n{% elif a == 928 %}928\n{% elif a == 929 %}929\n{% elif a == 930 %}930\n{% elif a == 931 %}931\n{% elif a == 932 %}932\n{% elif a == 933 %}933\n{% elif a == 934 %}934\n{% elif a == 935 %}935\n{% elif a == 936 %}936\n{% elif a == 937 %}937\n{% elif a == 938 %}938\n{% elif a == 939 %}939\n{% elif a == 940 %}940\n{% elif a == 941 %}941\n{% elif a == 942 %}942\n{% elif a == 943 %}943\n{% elif a == 944 %}944\n{% elif a == 945 %}945\n{% elif a == 946 %}946\n{% elif a == 947 %}947\n{% elif a == 948 %}948\n{% elif a == 949 %}949\n{% elif a == 950 %}950\n{% elif a == 951 %}951\n{% elif a == 952 %}952\n{% elif a == 953 %}953\n{% elif a == 954 %}954\n{% elif a == 955 %}955\n{% elif a == 956 %}956\n{% elif a == 957 %}957\n{% elif a == 958 %}958\n{% elif a == 959 %}959\n{% elif a == 960 %}960\n{% elif a == 961 %}961\n{% elif a == 962 %}962\n{% elif a == 963 %}963\n{% elif a == 964 %}964\n{% elif a == 965 %}965\n{% elif a == 966 %}966\n{% elif a == 967 %}967\n{% elif a == 968 %}968\n{% elif a == 969 %}969\n{% elif a == 970 %}970\n{% elif a == 971 %}971\n{% elif a == 972 %}972\n{% elif a == 973 %}973\n{% elif a == 974 %}974\n{% elif a == 975 %}975\n{% elif a == 976 %}976\n{% elif a == 977 %}977\n{% elif a == 978 %}978\n{% elif a == 979 %}979\n{% elif a == 980 %}980\n{% elif a == 981 %}981\n{% elif a == 982 %}982\n{% elif a == 983 %}983\n{% elif a == 984 %}984\n{% elif a == 985 %}985\n{% elif a == 986 %}986\n{% elif a == 987 %}987\n{% elif a == 988 %}988\n{% elif a == 989 %}989\n{% elif a == 990 %}990\n{% elif a == 991 %}991\n{% elif a == 992 %}992\n{% elif a == 993 %}993\n{% elif a == 994 %}994\n{% elif a == 995 %}995\n{% elif a == 996 %}996\n{% elif a == 997 %}997\n{% elif a == 998 %}998\n{% elif a == 999 %}999{% else %}x{% endif %}",
    "{\"a\": 1000}",
    output="x",
  )
}

///|
test "jinja test_core_tags TestIfCondition::test_else" {
  jinja(source="{% if false %}XXX{% else %}...{% endif %}", "{}", output="...")
}

///|
test "jinja test_core_tags TestIfCondition::test_empty" {
  jinja(source="[{% if true %}{% else %}{% endif %}]", "{}", output="[]")
}

///|
test "jinja test_core_tags TestIfCondition::test_complete" {
  jinja(
    source="{% if a %}A{% elif b %}B{% elif c == d %}C{% else %}D{% endif %}",
    "{\"a\": 0, \"b\": false, \"c\": 42, \"d\": 42.0}",
    output="C",
  )
}

///|
test "jinja test_core_tags TestIfCondition::test_no_scope" {
  jinja(
    source="{% if a %}{% set foo = 1 %}{% endif %}{{ foo }}",
    "{\"a\": true}",
    output="1",
  )
}

///|
test "jinja test_core_tags TestIfCondition::test_no_scope #2" {
  jinja(
    source="{% if true %}{% set foo = 1 %}{% endif %}{{ foo }}",
    "{}",
    output="1",
  )
}

///|
test "jinja test_core_tags TestMacros::test_simple" {
  jinja(
    source="{% macro say_hello(name) %}Hello {{ name }}!{% endmacro %}\n{{ say_hello('Peter') }}",
    "{}",
    output="Hello Peter!",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestMacros::test_scoping" {
  jinja(
    source="{% macro level1(data1) %}\n{% macro level2(data2) %}{{ data1 }}|{{ data2 }}{% endmacro %}\n{{ level2('bar') }}{% endmacro %}\n{{ level1('foo') }}",
    "{}",
    output="foo|bar",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestMacros::test_arguments" {
  jinja(
    source="{% macro m(a, b, c='c', d='d') %}{{ a }}|{{ b }}|{{ c }}|{{ d }}{% endmacro %}\n{{ m() }}|{{ m('a') }}|{{ m('a', 'b') }}|{{ m(1, 2, 3) }}",
    "{}",
    output="||c|d|a||c|d|a|b|c|d|1|2|3|d",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestMacros::test_varargs" {
  jinja(
    source="{% macro test() %}{{ varargs|join('|') }}{% endmacro %}{{ test(1, 2, 3) }}",
    "{}",
    output="1|2|3",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestMacros::test_simple_call" {
  jinja(
    source="{% macro test() %}[[{{ caller() }}]]{% endmacro %}{% call test() %}data{% endcall %}",
    "{}",
    output="[[data]]",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestMacros::test_complex_call" {
  jinja(
    source="{% macro test() %}[[{{ caller('data') }}]]{% endmacro %}{% call(data) test() %}{{ data }}{% endcall %}",
    "{}",
    output="[[data]]",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestMacros::test_caller_undefined" {
  jinja(
    source="{% set caller = 42 %}{% macro test() %}{{ caller is not defined }}{% endmacro %}{{ test() }}",
    "{}",
    output="True",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestMacros::test_include" {
  jinja(
    source="{% from \"include\" import test %}{{ test(\"foo\") }}",
    "{}",
    output="[foo]",
    templates="{\"include\": \"{% macro test(foo) %}[{{ foo }}]{% endmacro %}\"}",
  )
}

///|
test "jinja test_core_tags TestMacros::test_callself" {
  jinja(
    source="{% macro foo(x) %}{{ x }}{% if x > 1 %}|{{ foo(x - 1) }}{% endif %}{% endmacro %}{{ foo(5) }}",
    "{}",
    output="5|4|3|2|1",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestSet::test_normal" {
  jinja(source="{% set foo = 1 %}{{ foo }}", "{}", output="1", trim_blocks=true)
}

///|
test "jinja test_core_tags TestSet::test_block" {
  jinja(
    source="{% set foo %}42{% endset %}{{ foo }}",
    "{}",
    output="42",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestSet::test_block_escaping" {
  jinja(
    source="{% set foo %}<em>{{ test }}</em>{% endset %}foo: {{ foo }}",
    "{\"test\": \"<unsafe>\"}",
    output="foo: <em>&lt;unsafe&gt;</em>",
    autoescape=true,
  )
}

///|
test "jinja test_core_tags TestSet::test_set_invalid" {
  jinja(
    source="{% set foo.bar = 1 %}",
    "{\"foo\": {}}",
    error="TemplateRuntimeError: cannot assign attribute on non-namespace object",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestSet::test_namespace" {
  jinja(
    source="{% set ns = namespace() %}{% set ns.bar = '42' %}{{ ns.bar }}",
    "{}",
    output="42",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestSet::test_namespace_block" {
  jinja(
    source="{% set ns = namespace() %}{% set ns.bar %}42{% endset %}{{ ns.bar }}",
    "{}",
    output="42",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestSet::test_init_namespace" {
  jinja(
    source="{% set ns = namespace(d, self=37) %}{% set ns.b = 42 %}{{ ns.a }}|{{ ns.self }}|{{ ns.b }}",
    "{\"d\": {\"a\": 13}}",
    output="13|37|42",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestSet::test_namespace_loop" {
  jinja(
    source="{% set ns = namespace(found=false) %}{% for x in range(4) %}{% if x == v %}{% set ns.found = true %}{% endif %}{% endfor %}{{ ns.found }}",
    "{\"v\": 3}",
    output="True",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestSet::test_namespace_loop #2" {
  jinja(
    source="{% set ns = namespace(found=false) %}{% for x in range(4) %}{% if x == v %}{% set ns.found = true %}{% endif %}{% endfor %}{{ ns.found }}",
    "{\"v\": 4}",
    output="False",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestSet::test_namespace_macro" {
  jinja(
    source="{% set ns = namespace() %}{% set ns.a = 13 %}{% macro magic(x) %}{% set x.b = 37 %}{% endmacro %}{{ magic(ns) }}{{ ns.a }}|{{ ns.b }}",
    "{}",
    output="13|37",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestSet::test_namespace_set_tuple" {
  jinja(
    source="{% set ns = namespace(a=12, b=36) %}{% set ns.a, ns.b = ns.a + 1, ns.b + 1 %}{{ ns.a }}|{{ ns.b }}",
    "{}",
    output="13|37",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestSet::test_block_escaping_filtered" {
  jinja(
    source="{% set foo | trim %}<em>{{ test }}</em>    {% endset %}foo: {{ foo }}",
    "{\"test\": \"<unsafe>\"}",
    output="foo: <em>&lt;unsafe&gt;</em>",
    autoescape=true,
  )
}

///|
test "jinja test_core_tags TestSet::test_block_filtered" {
  jinja(
    source="{% set foo | trim | length | string %} 42    {% endset %}{{ foo }}",
    "{}",
    output="2",
    trim_blocks=true,
  )
}

///|
test "jinja test_core_tags TestWith::test_with" {
  jinja(
    source="        {% with a=42, b=23 -%}\n            {{ a }} = {{ b }}\n        {% endwith -%}\n            {{ a }} = {{ b }}        ",
    "{\"a\": 1, \"b\": 2}",
    output="        42 = 23\n        1 = 2        ",
  )
}

///|
test "jinja test_core_tags TestWith::test_with_argument_scoping" {
  jinja(
    source="        {%- with a=1, b=2, c=b, d=e, e=5 -%}\n            {{ a }}|{{ b }}|{{ c }}|{{ d }}|{{ e }}\n        {%- endwith -%}\n        ",
    "{\"b\": 3, \"e\": 4}",
    output="1|2|3|4|5",
  )
}

///|
test "jinja test_ext TestExtensions::test_extend_late" {
  jinja(
    source="{% autoescape true %}{{ \"<test>\" }}{% endautoescape %}",
    "{}",
    output="&lt;test&gt;",
  )
}

///|
test "jinja test_ext TestNewstyleInternationalization::test_autoescape_macros" {
  jinja(
    source="{% macro m() %}<html>{% endmacro %}{% autoescape true %}{{ m() }}{% endautoescape %}",
    "{}",
    output="<html>",
  )
}

///|
test "jinja test_ext TestAutoEscape::test_scoped_setting" {
  jinja(
    source="\n            {{ \"<HelloWorld>\" }}\n            {% autoescape false %}\n                {{ \"<HelloWorld>\" }}\n            {% endautoescape %}\n            {{ \"<HelloWorld>\" }}\n        ",
    "{}",
    output="\n            &lt;HelloWorld&gt;\n            \n                <HelloWorld>\n            \n            &lt;HelloWorld&gt;\n        ",
    autoescape=true,
  )
}

///|
test "jinja test_ext TestAutoEscape::test_scoped_setting #2" {
  jinja(
    source="\n            {{ \"<HelloWorld>\" }}\n            {% autoescape true %}\n                {{ \"<HelloWorld>\" }}\n            {% endautoescape %}\n            {{ \"<HelloWorld>\" }}\n        ",
    "{}",
    output="\n            <HelloWorld>\n            \n                &lt;HelloWorld&gt;\n            \n            <HelloWorld>\n        ",
  )
}

///|
test "jinja test_ext TestAutoEscape::test_nonvolatile" {
  jinja(
    source="{{ {\"foo\": \"<test>\"}|xmlattr|escape }}",
    "{}",
    output=" foo=\"&lt;test&gt;\"",
    autoescape=true,
  )
}

///|
test "jinja test_ext TestAutoEscape::test_nonvolatile #2" {
  jinja(
    source="{% autoescape false %}{{ {\"foo\": \"<test>\"}|xmlattr|escape }}{% endautoescape %}",
    "{}",
    output=" foo=&#34;&amp;lt;test&amp;gt;&#34;",
    autoescape=true,
  )
}

///|
test "jinja test_ext TestAutoEscape::test_volatile" {
  jinja(
    source="{% autoescape foo %}{{ {\"foo\": \"<test>\"}|xmlattr|escape }}{% endautoescape %}",
    "{\"foo\": false}",
    output=" foo=&#34;&amp;lt;test&amp;gt;&#34;",
    autoescape=true,
  )
}

///|
test "jinja test_ext TestAutoEscape::test_volatile #2" {
  jinja(
    source="{% autoescape foo %}{{ {\"foo\": \"<test>\"}|xmlattr|escape }}{% endautoescape %}",
    "{\"foo\": true}",
    output=" foo=\"&lt;test&gt;\"",
    autoescape=true,
  )
}

///|
test "jinja test_ext TestAutoEscape::test_scoping" {
  jinja(
    source="{% autoescape true %}{% set x = \"<x>\" %}{{ x }}{% endautoescape %}{{ x }}{{ \"<y>\" }}",
    "{\"x\": 1}",
    output="&lt;x&gt;1<y>",
  )
}

///|
test "jinja test_filters TestFilter::test_capitalize" {
  jinja(source="{{ \"foo bar\"|capitalize }}", "{}", output="Foo bar")
}

///|
test "jinja test_filters TestFilter::test_center" {
  jinja(source="{{ \"foo\"|center(9) }}", "{}", output="   foo   ")
}

///|
test "jinja test_filters TestFilter::test_default" {
  jinja(
    source="{{ missing|default('no') }}|{{ false|default('no') }}|{{ false|default('no', true) }}|{{ given|default('no') }}",
    "{\"given\": \"yes\"}",
    output="no|False|no|yes",
  )
}

///|
test "jinja test_filters TestFilter::test_dictsort[-[('aa', 0), ('AB', 3), ('b', 1), ('c', 2)]]" {
  jinja(
    source="{{ foo|dictsort() }}",
    "{\"foo\": {\"aa\": 0, \"b\": 1, \"c\": 2, \"AB\": 3}}",
    output="[('aa', 0), ('AB', 3), ('b', 1), ('c', 2)]",
  )
}

///|
test "jinja test_filters TestFilter::test_dictsort[true-[('AB', 3), ('aa', 0), ('b', 1), ('c', 2)]]" {
  jinja(
    source="{{ foo|dictsort(true) }}",
    "{\"foo\": {\"aa\": 0, \"b\": 1, \"c\": 2, \"AB\": 3}}",
    output="[('AB', 3), ('aa', 0), ('b', 1), ('c', 2)]",
  )
}

///|
test "jinja test_filters TestFilter::test_dictsort[by=\"value\"-[('aa', 0), ('b', 1), ('c', 2), ('AB', 3)]]" {
  jinja(
    source="{{ foo|dictsort(by=\"value\") }}",
    "{\"foo\": {\"aa\": 0, \"b\": 1, \"c\": 2, \"AB\": 3}}",
    output="[('aa', 0), ('b', 1), ('c', 2), ('AB', 3)]",
  )
}

///|
test "jinja test_filters TestFilter::test_dictsort[reverse=true-[('c', 2), ('b', 1), ('AB', 3), ('aa', 0)]]" {
  jinja(
    source="{{ foo|dictsort(reverse=true) }}",
    "{\"foo\": {\"aa\": 0, \"b\": 1, \"c\": 2, \"AB\": 3}}",
    output="[('c', 2), ('b', 1), ('AB', 3), ('aa', 0)]",
  )
}

///|
test "jinja test_filters TestFilter::test_batch" {
  jinja(
    source="{{ foo|batch(3)|list }}|{{ foo|batch(3, 'X')|list }}",
    "{\"foo\": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]}",
    output="[[0, 1, 2], [3, 4, 5], [6, 7, 8], [9]]|[[0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 'X', 'X']]",
  )
}

///|
test "jinja test_filters TestFilter::test_slice" {
  jinja(
    source="{{ foo|slice(3)|list }}|{{ foo|slice(3, 'X')|list }}",
    "{\"foo\": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]}",
    output="[[0, 1, 2, 3], [4, 5, 6], [7, 8, 9]]|[[0, 1, 2, 3], [4, 5, 6, 'X'], [7, 8, 9, 'X']]",
  )
}

///|
test "jinja test_filters TestFilter::test_escape" {
  jinja(source="{{ '<\">&'|escape }}", "{}", output="&lt;&#34;&gt;&amp;")
}

///|
test "jinja test_filters TestFilter::test_trim[None-..stays..]" {
  jinja(
    source="{{ foo|trim(chars) }}",
    "{\"foo\": \"  ..stays..\", \"chars\": null}",
    output="..stays..",
  )
}

///|
test "jinja test_filters TestFilter::test_trim[.-  ..stays]" {
  jinja(
    source="{{ foo|trim(chars) }}",
    "{\"foo\": \"  ..stays..\", \"chars\": \".\"}",
    output="  ..stays",
  )
}

///|
test "jinja test_filters TestFilter::test_trim[ .-stays]" {
  jinja(
    source="{{ foo|trim(chars) }}",
    "{\"foo\": \"  ..stays..\", \"chars\": \" .\"}",
    output="stays",
  )
}

///|
test "jinja test_filters TestFilter::test_striptags" {
  jinja(
    source="{{ foo|striptags }}",
    "{\"foo\": \"  <p>just a small   \\n <a href=\\\"#\\\">example</a> link</p>\\n<p>to a webpage</p> <!-- <p>and some commented stuff</p> -->\"}",
    output="just a small example link to a webpage",
  )
}

///|
test "jinja test_filters TestFilter::test_filesizeformat" {
  jinja(
    source="{{ 100|filesizeformat }}|{{ 1000|filesizeformat }}|{{ 1000000|filesizeformat }}|{{ 1000000000|filesizeformat }}|{{ 1000000000000|filesizeformat }}|{{ 100|filesizeformat(true) }}|{{ 1000|filesizeformat(true) }}|{{ 1000000|filesizeformat(true) }}|{{ 1000000000|filesizeformat(true) }}|{{ 1000000000000|filesizeformat(true) }}",
    "{}",
    output="100 Bytes|1.0 kB|1.0 MB|1.0 GB|1.0 TB|100 Bytes|1000 Bytes|976.6 KiB|953.7 MiB|931.3 GiB",
  )
}

///|
test "jinja test_filters TestFilter::test_filesizeformat_issue59" {
  jinja(
    source="{{ 300|filesizeformat }}|{{ 3000|filesizeformat }}|{{ 3000000|filesizeformat }}|{{ 3000000000|filesizeformat }}|{{ 3000000000000|filesizeformat }}|{{ 300|filesizeformat(true) }}|{{ 3000|filesizeformat(true) }}|{{ 3000000|filesizeformat(true) }}",
    "{}",
    output="300 Bytes|3.0 kB|3.0 MB|3.0 GB|3.0 TB|300 Bytes|2.9 KiB|2.9 MiB",
  )
}

///|
test "jinja test_filters TestFilter::test_first" {
  jinja(
    source="{{ foo|first }}",
    "{\"foo\": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]}",
    output="0",
  )
}

///|
test "jinja test_filters TestFilter::test_float[42-42.0]" {
  jinja(source="{{ value|float }}", "{\"value\": \"42\"}", output="42.0")
}

///|
test "jinja test_filters TestFilter::test_float[abc-0.0]" {
  jinja(source="{{ value|float }}", "{\"value\": \"abc\"}", output="0.0")
}

///|
test "jinja test_filters TestFilter::test_float[32.32-32.32]" {
  jinja(source="{{ value|float }}", "{\"value\": \"32.32\"}", output="32.32")
}

///|
test "jinja test_filters TestFilter::test_float_default" {
  jinja(
    source="{{ value|float(default=1.0) }}",
    "{\"value\": \"abc\"}",
    output="1.0",
  )
}

///|
test "jinja test_filters TestFilter::test_format" {
  jinja(source="{{ '%s|%s'|format('a', 'b') }}", "{}", output="a|b")
}

///|
test "jinja test_filters TestFilter::test_indent" {
  jinja(
    source="{{ foo|indent(2, false, false) }}",
    "{\"foo\": \"\\nfoo bar\\n\\\"baz\\\"\\n\"}",
    output="\n  foo bar\n  \"baz\"\n",
  )
}

///|
test "jinja test_filters TestFilter::test_indent #2" {
  jinja(
    source="{{ foo|indent(2, false, true) }}",
    "{\"foo\": \"\\nfoo bar\\n\\\"baz\\\"\\n\"}",
    output="\n  foo bar\n  \"baz\"\n  ",
  )
}

///|
test "jinja test_filters TestFilter::test_indent #3" {
  jinja(
    source="{{ foo|indent(2, true, false) }}",
    "{\"foo\": \"\\nfoo bar\\n\\\"baz\\\"\\n\"}",
    output="  \n  foo bar\n  \"baz\"\n",
  )
}

///|
test "jinja test_filters TestFilter::test_indent #4" {
  jinja(
    source="{{ foo|indent(2, true, true) }}",
    "{\"foo\": \"\\nfoo bar\\n\\\"baz\\\"\\n\"}",
    output="  \n  foo bar\n  \"baz\"\n  ",
  )
}

///|
test "jinja test_filters TestFilter::test_indent #5" {
  jinja(source="{{ \"jinja\"|indent }}", "{}", output="jinja")
}

///|
test "jinja test_filters TestFilter::test_indent #6" {
  jinja(source="{{ \"jinja\"|indent(first=true) }}", "{}", output="    jinja")
}

///|
test "jinja test_filters TestFilter::test_indent #7" {
  jinja(source="{{ \"jinja\"|indent(blank=true) }}", "{}", output="jinja")
}

///|
test "jinja test_filters TestFilter::test_indent_width_string" {
  jinja(
    source="{{ 'jinja\nflask'|indent(width='>>> ', first=True) }}",
    "{}",
    output=">>> jinja\n>>> flask",
  )
}

///|
test "jinja test_filters TestFilter::test_int[42-42]" {
  jinja(source="{{ value|int }}", "{\"value\": \"42\"}", output="42")
}

///|
test "jinja test_filters TestFilter::test_int[abc-0]" {
  jinja(source="{{ value|int }}", "{\"value\": \"abc\"}", output="0")
}

///|
test "jinja test_filters TestFilter::test_int[32.32-32]" {
  jinja(source="{{ value|int }}", "{\"value\": \"32.32\"}", output="32")
}

///|
test "jinja test_filters TestFilter::test_int[1e10000-0]" {
  jinja(source="{{ value|int }}", "{\"value\": \"1e10000\"}", output="0")
}

///|
test "jinja test_filters TestFilter::test_int_base[0x4d32-16-19762]" {
  jinja(
    source="{{ value|int(base=base) }}",
    "{\"value\": \"0x4d32\", \"base\": 16}",
    output="19762",
  )
}

///|
test "jinja test_filters TestFilter::test_int_base[011-8-9]" {
  jinja(
    source="{{ value|int(base=base) }}",
    "{\"value\": \"011\", \"base\": 8}",
    output="9",
  )
}

///|
test "jinja test_filters TestFilter::test_int_base[0x33Z-16-0]" {
  jinja(
    source="{{ value|int(base=base) }}",
    "{\"value\": \"0x33Z\", \"base\": 16}",
    output="0",
  )
}

///|
test "jinja test_filters TestFilter::test_int_default" {
  jinja(source="{{ value|int(default=1) }}", "{\"value\": \"abc\"}", output="1")
}

///|
test "jinja test_filters TestFilter::test_join" {
  jinja(source="{{ [1, 2, 3]|join(\"|\") }}", "{}", output="1|2|3")
}

///|
test "jinja test_filters TestFilter::test_join #2" {
  jinja(
    source="{{ [\"<foo>\", \"<span>foo</span>\"|safe]|join }}",
    "{}",
    output="&lt;foo&gt;<span>foo</span>",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_last" {
  jinja(
    source="{{ foo|last }}",
    "{\"foo\": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]}",
    output="9",
  )
}

///|
test "jinja test_filters TestFilter::test_length" {
  jinja(source="{{ \"hello world\"|length }}", "{}", output="11")
}

///|
test "jinja test_filters TestFilter::test_lower" {
  jinja(source="{{ \"FOO\"|lower }}", "{}", output="foo")
}

///|
test "jinja test_filters TestFilter::test_items_undefined" {
  jinja(source="{{ d|items|list }}", "{}", output="[]")
}

///|
test "jinja test_filters TestFilter::test_pprint" {
  jinja(
    source="{{ data|pprint }}",
    "{\"data\": [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 265, 266, 267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 366, 367, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 635, 636, 637, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 663, 664, 665, 666, 667, 668, 669, 670, 671, 672, 673, 674, 675, 676, 677, 678, 679, 680, 681, 682, 683, 684, 685, 686, 687, 688, 689, 690, 691, 692, 693, 694, 695, 696, 697, 698, 699, 700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 724, 725, 726, 727, 728, 729, 730, 731, 732, 733, 734, 735, 736, 737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 748, 749, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 773, 774, 775, 776, 777, 778, 779, 780, 781, 782, 783, 784, 785, 786, 787, 788, 789, 790, 791, 792, 793, 794, 795, 796, 797, 798, 799, 800, 801, 802, 803, 804, 805, 806, 807, 808, 809, 810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822, 823, 824, 825, 826, 827, 828, 829, 830, 831, 832, 833, 834, 835, 836, 837, 838, 839, 840, 841, 842, 843, 844, 845, 846, 847, 848, 849, 850, 851, 852, 853, 854, 855, 856, 857, 858, 859, 860, 861, 862, 863, 864, 865, 866, 867, 868, 869, 870, 871, 872, 873, 874, 875, 876, 877, 878, 879, 880, 881, 882, 883, 884, 885, 886, 887, 888, 889, 890, 891, 892, 893, 894, 895, 896, 897, 898, 899, 900, 901, 902, 903, 904, 905, 906, 907, 908, 909, 910, 911, 912, 913, 914, 915, 916, 917, 918, 919, 920, 921, 922, 923, 924, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938, 939, 940, 941, 942, 943, 944, 945, 946, 947, 948, 949, 950, 951, 952, 953, 954, 955, 956, 957, 958, 959, 960, 961, 962, 963, 964, 965, 966, 967, 968, 969, 970, 971, 972, 973, 974, 975, 976, 977, 978, 979, 980, 981, 982, 983, 984, 985, 986, 987, 988, 989, 990, 991, 992, 993, 994, 995, 996, 997, 998, 999]}",
    output="[0,\n 1,\n 2,\n 3,\n 4,\n 5,\n 6,\n 7,\n 8,\n 9,\n 10,\n 11,\n 12,\n 13,\n 14,\n 15,\n 16,\n 17,\n 18,\n 19,\n 20,\n 21,\n 22,\n 23,\n 24,\n 25,\n 26,\n 27,\n 28,\n 29,\n 30,\n 31,\n 32,\n 33,\n 34,\n 35,\n 36,\n 37,\n 38,\n 39,\n 40,\n 41,\n 42,\n 43,\n 44,\n 45,\n 46,\n 47,\n 48,\n 49,\n 50,\n 51,\n 52,\n 53,\n 54,\n 55,\n 56,\n 57,\n 58,\n 59,\n 60,\n 61,\n 62,\n 63,\n 64,\n 65,\n 66,\n 67,\n 68,\n 69,\n 70,\n 71,\n 72,\n 73,\n 74,\n 75,\n 76,\n 77,\n 78,\n 79,\n 80,\n 81,\n 82,\n 83,\n 84,\n 85,\n 86,\n 87,\n 88,\n 89,\n 90,\n 91,\n 92,\n 93,\n 94,\n 95,\n 96,\n 97,\n 98,\n 99,\n 100,\n 101,\n 102,\n 103,\n 104,\n 105,\n 106,\n 107,\n 108,\n 109,\n 110,\n 111,\n 112,\n 113,\n 114,\n 115,\n 116,\n 117,\n 118,\n 119,\n 120,\n 121,\n 122,\n 123,\n 124,\n 125,\n 126,\n 127,\n 128,\n 129,\n 130,\n 131,\n 132,\n 133,\n 134,\n 135,\n 136,\n 137,\n 138,\n 139,\n 140,\n 141,\n 142,\n 143,\n 144,\n 145,\n 146,\n 147,\n 148,\n 149,\n 150,\n 151,\n 152,\n 153,\n 154,\n 155,\n 156,\n 157,\n 158,\n 159,\n 160,\n 161,\n 162,\n 163,\n 164,\n 165,\n 166,\n 167,\n 168,\n 169,\n 170,\n 171,\n 172,\n 173,\n 174,\n 175,\n 176,\n 177,\n 178,\n 179,\n 180,\n 181,\n 182,\n 183,\n 184,\n 185,\n 186,\n 187,\n 188,\n 189,\n 190,\n 191,\n 192,\n 193,\n 194,\n 195,\n 196,\n 197,\n 198,\n 199,\n 200,\n 201,\n 202,\n 203,\n 204,\n 205,\n 206,\n 207,\n 208,\n 209,\n 210,\n 211,\n 212,\n 213,\n 214,\n 215,\n 216,\n 217,\n 218,\n 219,\n 220,\n 221,\n 222,\n 223,\n 224,\n 225,\n 226,\n 227,\n 228,\n 229,\n 230,\n 231,\n 232,\n 233,\n 234,\n 235,\n 236,\n 237,\n 238,\n 239,\n 240,\n 241,\n 242,\n 243,\n 244,\n 245,\n 246,\n 247,\n 248,\n 249,\n 250,\n 251,\n 252,\n 253,\n 254,\n 255,\n 256,\n 257,\n 258,\n 259,\n 260,\n 261,\n 262,\n 263,\n 264,\n 265,\n 266,\n 267,\n 268,\n 269,\n 270,\n 271,\n 272,\n 273,\n 274,\n 275,\n 276,\n 277,\n 278,\n 279,\n 280,\n 281,\n 282,\n 283,\n 284,\n 285,\n 286,\n 287,\n 288,\n 289,\n 290,\n 291,\n 292,\n 293,\n 294,\n 295,\n 296,\n 297,\n 298,\n 299,\n 300,\n 301,\n 302,\n 303,\n 304,\n 305,\n 306,\n 307,\n 308,\n 309,\n 310,\n 311,\n 312,\n 313,\n 314,\n 315,\n 316,\n 317,\n 318,\n 319,\n 320,\n 321,\n 322,\n 323,\n 324,\n 325,\n 326,\n 327,\n 328,\n 329,\n 330,\n 331,\n 332,\n 333,\n 334,\n 335,\n 336,\n 337,\n 338,\n 339,\n 340,\n 341,\n 342,\n 343,\n 344,\n 345,\n 346,\n 347,\n 348,\n 349,\n 350,\n 351,\n 352,\n 353,\n 354,\n 355,\n 356,\n 357,\n 358,\n 359,\n 360,\n 361,\n 362,\n 363,\n 364,\n 365,\n 366,\n 367,\n 368,\n 369,\n 370,\n 371,\n 372,\n 373,\n 374,\n 375,\n 376,\n 377,\n 378,\n 379,\n 380,\n 381,\n 382,\n 383,\n 384,\n 385,\n 386,\n 387,\n 388,\n 389,\n 390,\n 391,\n 392,\n 393,\n 394,\n 395,\n 396,\n 397,\n 398,\n 399,\n 400,\n 401,\n 402,\n 403,\n 404,\n 405,\n 406,\n 407,\n 408,\n 409,\n 410,\n 411,\n 412,\n 413,\n 414,\n 415,\n 416,\n 417,\n 418,\n 419,\n 420,\n 421,\n 422,\n 423,\n 424,\n 425,\n 426,\n 427,\n 428,\n 429,\n 430,\n 431,\n 432,\n 433,\n 434,\n 435,\n 436,\n 437,\n 438,\n 439,\n 440,\n 441,\n 442,\n 443,\n 444,\n 445,\n 446,\n 447,\n 448,\n 449,\n 450,\n 451,\n 452,\n 453,\n 454,\n 455,\n 456,\n 457,\n 458,\n 459,\n 460,\n 461,\n 462,\n 463,\n 464,\n 465,\n 466,\n 467,\n 468,\n 469,\n 470,\n 471,\n 472,\n 473,\n 474,\n 475,\n 476,\n 477,\n 478,\n 479,\n 480,\n 481,\n 482,\n 483,\n 484,\n 485,\n 486,\n 487,\n 488,\n 489,\n 490,\n 491,\n 492,\n 493,\n 494,\n 495,\n 496,\n 497,\n 498,\n 499,\n 500,\n 501,\n 502,\n 503,\n 504,\n 505,\n 506,\n 507,\n 508,\n 509,\n 510,\n 511,\n 512,\n 513,\n 514,\n 515,\n 516,\n 517,\n 518,\n 519,\n 520,\n 521,\n 522,\n 523,\n 524,\n 525,\n 526,\n 527,\n 528,\n 529,\n 530,\n 531,\n 532,\n 533,\n 534,\n 535,\n 536,\n 537,\n 538,\n 539,\n 540,\n 541,\n 542,\n 543,\n 544,\n 545,\n 546,\n 547,\n 548,\n 549,\n 550,\n 551,\n 552,\n 553,\n 554,\n 555,\n 556,\n 557,\n 558,\n 559,\n 560,\n 561,\n 562,\n 563,\n 564,\n 565,\n 566,\n 567,\n 568,\n 569,\n 570,\n 571,\n 572,\n 573,\n 574,\n 575,\n 576,\n 577,\n 578,\n 579,\n 580,\n 581,\n 582,\n 583,\n 584,\n 585,\n 586,\n 587,\n 588,\n 589,\n 590,\n 591,\n 592,\n 593,\n 594,\n 595,\n 596,\n 597,\n 598,\n 599,\n 600,\n 601,\n 602,\n 603,\n 604,\n 605,\n 606,\n 607,\n 608,\n 609,\n 610,\n 611,\n 612,\n 613,\n 614,\n 615,\n 616,\n 617,\n 618,\n 619,\n 620,\n 621,\n 622,\n 623,\n 624,\n 625,\n 626,\n 627,\n 628,\n 629,\n 630,\n 631,\n 632,\n 633,\n 634,\n 635,\n 636,\n 637,\n 638,\n 639,\n 640,\n 641,\n 642,\n 643,\n 644,\n 645,\n 646,\n 647,\n 648,\n 649,\n 650,\n 651,\n 652,\n 653,\n 654,\n 655,\n 656,\n 657,\n 658,\n 659,\n 660,\n 661,\n 662,\n 663,\n 664,\n 665,\n 666,\n 667,\n 668,\n 669,\n 670,\n 671,\n 672,\n 673,\n 674,\n 675,\n 676,\n 677,\n 678,\n 679,\n 680,\n 681,\n 682,\n 683,\n 684,\n 685,\n 686,\n 687,\n 688,\n 689,\n 690,\n 691,\n 692,\n 693,\n 694,\n 695,\n 696,\n 697,\n 698,\n 699,\n 700,\n 701,\n 702,\n 703,\n 704,\n 705,\n 706,\n 707,\n 708,\n 709,\n 710,\n 711,\n 712,\n 713,\n 714,\n 715,\n 716,\n 717,\n 718,\n 719,\n 720,\n 721,\n 722,\n 723,\n 724,\n 725,\n 726,\n 727,\n 728,\n 729,\n 730,\n 731,\n 732,\n 733,\n 734,\n 735,\n 736,\n 737,\n 738,\n 739,\n 740,\n 741,\n 742,\n 743,\n 744,\n 745,\n 746,\n 747,\n 748,\n 749,\n 750,\n 751,\n 752,\n 753,\n 754,\n 755,\n 756,\n 757,\n 758,\n 759,\n 760,\n 761,\n 762,\n 763,\n 764,\n 765,\n 766,\n 767,\n 768,\n 769,\n 770,\n 771,\n 772,\n 773,\n 774,\n 775,\n 776,\n 777,\n 778,\n 779,\n 780,\n 781,\n 782,\n 783,\n 784,\n 785,\n 786,\n 787,\n 788,\n 789,\n 790,\n 791,\n 792,\n 793,\n 794,\n 795,\n 796,\n 797,\n 798,\n 799,\n 800,\n 801,\n 802,\n 803,\n 804,\n 805,\n 806,\n 807,\n 808,\n 809,\n 810,\n 811,\n 812,\n 813,\n 814,\n 815,\n 816,\n 817,\n 818,\n 819,\n 820,\n 821,\n 822,\n 823,\n 824,\n 825,\n 826,\n 827,\n 828,\n 829,\n 830,\n 831,\n 832,\n 833,\n 834,\n 835,\n 836,\n 837,\n 838,\n 839,\n 840,\n 841,\n 842,\n 843,\n 844,\n 845,\n 846,\n 847,\n 848,\n 849,\n 850,\n 851,\n 852,\n 853,\n 854,\n 855,\n 856,\n 857,\n 858,\n 859,\n 860,\n 861,\n 862,\n 863,\n 864,\n 865,\n 866,\n 867,\n 868,\n 869,\n 870,\n 871,\n 872,\n 873,\n 874,\n 875,\n 876,\n 877,\n 878,\n 879,\n 880,\n 881,\n 882,\n 883,\n 884,\n 885,\n 886,\n 887,\n 888,\n 889,\n 890,\n 891,\n 892,\n 893,\n 894,\n 895,\n 896,\n 897,\n 898,\n 899,\n 900,\n 901,\n 902,\n 903,\n 904,\n 905,\n 906,\n 907,\n 908,\n 909,\n 910,\n 911,\n 912,\n 913,\n 914,\n 915,\n 916,\n 917,\n 918,\n 919,\n 920,\n 921,\n 922,\n 923,\n 924,\n 925,\n 926,\n 927,\n 928,\n 929,\n 930,\n 931,\n 932,\n 933,\n 934,\n 935,\n 936,\n 937,\n 938,\n 939,\n 940,\n 941,\n 942,\n 943,\n 944,\n 945,\n 946,\n 947,\n 948,\n 949,\n 950,\n 951,\n 952,\n 953,\n 954,\n 955,\n 956,\n 957,\n 958,\n 959,\n 960,\n 961,\n 962,\n 963,\n 964,\n 965,\n 966,\n 967,\n 968,\n 969,\n 970,\n 971,\n 972,\n 973,\n 974,\n 975,\n 976,\n 977,\n 978,\n 979,\n 980,\n 981,\n 982,\n 983,\n 984,\n 985,\n 986,\n 987,\n 988,\n 989,\n 990,\n 991,\n 992,\n 993,\n 994,\n 995,\n 996,\n 997,\n 998,\n 999]",
  )
}

///|
test "jinja test_filters TestFilter::test_reverse" {
  jinja(
    source="{{ 'foobar'|reverse|join }}|{{ [1, 2, 3]|reverse|list }}",
    "{}",
    output="raboof|[3, 2, 1]",
  )
}

///|
test "jinja test_filters TestFilter::test_string" {
  jinja(
    source="{{ obj|string }}",
    "{\"obj\": [1, 2, 3, 4, 5]}",
    output="[1, 2, 3, 4, 5]",
  )
}

///|
test "jinja test_filters TestFilter::test_title" {
  jinja(source="{{ \"foo bar\"|title }}", "{}", output="Foo Bar")
}

///|
test "jinja test_filters TestFilter::test_title #2" {
  jinja(source="{{ \"foo's bar\"|title }}", "{}", output="Foo's Bar")
}

///|
test "jinja test_filters TestFilter::test_title #3" {
  jinja(source="{{ \"foo   bar\"|title }}", "{}", output="Foo   Bar")
}

///|
test "jinja test_filters TestFilter::test_title #4" {
  jinja(source="{{ \"f bar f\"|title }}", "{}", output="F Bar F")
}

///|
test "jinja test_filters TestFilter::test_title #5" {
  jinja(source="{{ \"foo-bar\"|title }}", "{}", output="Foo-Bar")
}

///|
test "jinja test_filters TestFilter::test_title #6" {
  jinja(source="{{ \"foo\tbar\"|title }}", "{}", output="Foo\tBar")
}

///|
test "jinja test_filters TestFilter::test_title #7" {
  jinja(source="{{ \"FOO\tBAR\"|title }}", "{}", output="Foo\tBar")
}

///|
test "jinja test_filters TestFilter::test_title #8" {
  jinja(source="{{ \"foo (bar)\"|title }}", "{}", output="Foo (Bar)")
}

///|
test "jinja test_filters TestFilter::test_title #9" {
  jinja(source="{{ \"foo {bar}\"|title }}", "{}", output="Foo {Bar}")
}

///|
test "jinja test_filters TestFilter::test_title #10" {
  jinja(source="{{ \"foo [bar]\"|title }}", "{}", output="Foo [Bar]")
}

///|
test "jinja test_filters TestFilter::test_title #11" {
  jinja(source="{{ \"foo <bar>\"|title }}", "{}", output="Foo <Bar>")
}

///|
test "jinja test_filters TestFilter::test_truncate" {
  jinja(
    source="{{ data|truncate(15, true, \">>>\") }}|{{ data|truncate(15, false, \">>>\") }}|{{ smalldata|truncate(15) }}",
    "{\"data\": \"foobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz barfoobar baz bar\", \"smalldata\": \"foobar baz bar\"}",
    output="foobar baz b>>>|foobar baz>>>|foobar baz bar",
  )
}

///|
test "jinja test_filters TestFilter::test_truncate_very_short" {
  jinja(
    source="{{ \"foo bar baz\"|truncate(9) }}|{{ \"foo bar baz\"|truncate(9, true) }}",
    "{}",
    output="foo bar baz|foo bar baz",
  )
}

///|
test "jinja test_filters TestFilter::test_truncate_end_length" {
  jinja(
    source="{{ \"Joel is a slug\"|truncate(7, true) }}",
    "{}",
    output="Joel...",
  )
}

///|
test "jinja test_filters TestFilter::test_upper" {
  jinja(source="{{ \"foo\"|upper }}", "{}", output="FOO")
}

///|
test "jinja test_filters TestFilter::test_urlize" {
  jinja(
    source="{{ \"foo example.org bar\"|urlize }}",
    "{}",
    output="foo <a href=\"https://example.org\" rel=\"noopener\">example.org</a> bar",
  )
}

///|
test "jinja test_filters TestFilter::test_urlize #2" {
  jinja(
    source="{{ \"foo http://www.example.com/ bar\"|urlize }}",
    "{}",
    output="foo <a href=\"http://www.example.com/\" rel=\"noopener\">http://www.example.com/</a> bar",
  )
}

///|
test "jinja test_filters TestFilter::test_urlize #3" {
  jinja(
    source="{{ \"foo mailto:email@example.com bar\"|urlize }}",
    "{}",
    output="foo <a href=\"mailto:email@example.com\">email@example.com</a> bar",
  )
}

///|
test "jinja test_filters TestFilter::test_urlize #4" {
  jinja(
    source="{{ \"foo email@example.com bar\"|urlize }}",
    "{}",
    output="foo <a href=\"mailto:email@example.com\">email@example.com</a> bar",
  )
}

///|
test "jinja test_filters TestFilter::test_urlize_target_parameter" {
  jinja(
    source="{{ \"foo http://www.example.com/ bar\"|urlize(target=\"_blank\") }}",
    "{}",
    output="foo <a href=\"http://www.example.com/\" rel=\"noopener\" target=\"_blank\">http://www.example.com/</a> bar",
  )
}

///|
test "jinja test_filters TestFilter::test_urlize_extra_schemes_parameter" {
  jinja(
    source="{{ \"foo tel:+1-514-555-1234 ftp://localhost bar\"|urlize(extra_schemes=[\"tel:\", \"ftp:\"]) }}",
    "{}",
    output="foo <a href=\"tel:+1-514-555-1234\" rel=\"noopener\">tel:+1-514-555-1234</a> <a href=\"ftp://localhost\" rel=\"noopener\">ftp://localhost</a> bar",
  )
}

///|
test "jinja test_filters TestFilter::test_wordcount" {
  jinja(source="{{ \"foo bar baz\"|wordcount }}", "{}", output="3")
}

///|
test "jinja test_filters TestFilter::test_wordcount #2" {
  jinja(
    source="{{ s|wordcount }}",
    "{}",
    error="UndefinedError: 's' is undefined",
    policy=Strict,
  )
}

///|
test "jinja test_filters TestFilter::test_block" {
  jinja(
    source="{% filter lower|escape %}<HEHE>{% endfilter %}",
    "{}",
    output="&lt;hehe&gt;",
  )
}

///|
test "jinja test_filters TestFilter::test_chaining" {
  jinja(
    source="{{ ['<foo>', '<bar>']|first|upper|escape }}",
    "{}",
    output="&lt;FOO&gt;",
  )
}

///|
test "jinja test_filters TestFilter::test_sum" {
  jinja(source="{{ [1, 2, 3, 4, 5, 6]|sum }}", "{}", output="21")
}

///|
test "jinja test_filters TestFilter::test_sum_attributes" {
  jinja(
    source="{{ values|sum('value') }}",
    "{\"values\": [{\"value\": 23}, {\"value\": 1}, {\"value\": 18}]}",
    output="42",
  )
}

///|
test "jinja test_filters TestFilter::test_sum_attributes_nested" {
  jinja(
    source="{{ values|sum('real.value') }}",
    "{\"values\": [{\"real\": {\"value\": 23}}, {\"real\": {\"value\": 1}}, {\"real\": {\"value\": 18}}]}",
    output="42",
  )
}

///|
test "jinja test_filters TestFilter::test_sum_attributes_tuple" {
  jinja(
    source="{{ values.items()|sum('1') }}",
    "{\"values\": {\"foo\": 23, \"bar\": 1, \"baz\": 18}}",
    output="42",
  )
}

///|
test "jinja test_filters TestFilter::test_abs" {
  jinja(source="{{ -1|abs }}|{{ 1|abs }}", "{}", output="1|1")
}

///|
test "jinja test_filters TestFilter::test_round_positive" {
  jinja(
    source="{{ 2.7|round }}|{{ 2.1|round }}|{{ 2.1234|round(3, 'floor') }}|{{ 2.1|round(0, 'ceil') }}",
    "{}",
    output="3.0|2.0|2.123|3.0",
  )
}

///|
test "jinja test_filters TestFilter::test_round_negative" {
  jinja(
    source="{{ 21.3|round(-1)}}|{{ 21.3|round(-1, 'ceil')}}|{{ 21.3|round(-1, 'floor')}}",
    "{}",
    output="20.0|30.0|20.0",
  )
}

///|
test "jinja test_filters TestFilter::test_xmlattr" {
  jinja(
    source="{{ {'foo': 42, 'bar': 23, 'fish': none, 'spam': missing, 'blub:blub': '<?>'}|xmlattr }}",
    "{}",
    output=" foo=\"42\" bar=\"23\" blub:blub=\"&lt;?&gt;\"",
  )
}

///|
test "jinja test_filters TestFilter::test_xmlattr_key_invalid[\\t]" {
  jinja(
    source="{{ {key: 'my_class'}|xmlattr }}",
    "{\"key\": \"class\\tonclick=alert(1)\"}",
    error="ValueError: Invalid character in attribute name: 'class\\tonclick=alert(1)'",
  )
}

///|
test "jinja test_filters TestFilter::test_xmlattr_key_invalid[\\n]" {
  jinja(
    source="{{ {key: 'my_class'}|xmlattr }}",
    "{\"key\": \"class\\nonclick=alert(1)\"}",
    error="ValueError: Invalid character in attribute name: 'class\\nonclick=alert(1)'",
  )
}

///|
test "jinja test_filters TestFilter::test_xmlattr_key_invalid[\\x0c]" {
  jinja(
    source="{{ {key: 'my_class'}|xmlattr }}",
    "{\"key\": \"class\\fonclick=alert(1)\"}",
    error="ValueError: Invalid character in attribute name: 'class\\x0conclick=alert(1)'",
  )
}

///|
test "jinja test_filters TestFilter::test_xmlattr_key_invalid[ ]" {
  jinja(
    source="{{ {key: 'my_class'}|xmlattr }}",
    "{\"key\": \"class onclick=alert(1)\"}",
    error="ValueError: Invalid character in attribute name: 'class onclick=alert(1)'",
  )
}

///|
test "jinja test_filters TestFilter::test_xmlattr_key_invalid[/]" {
  jinja(
    source="{{ {key: 'my_class'}|xmlattr }}",
    "{\"key\": \"class/onclick=alert(1)\"}",
    error="ValueError: Invalid character in attribute name: 'class/onclick=alert(1)'",
  )
}

///|
test "jinja test_filters TestFilter::test_xmlattr_key_invalid[>]" {
  jinja(
    source="{{ {key: 'my_class'}|xmlattr }}",
    "{\"key\": \"class>onclick=alert(1)\"}",
    error="ValueError: Invalid character in attribute name: 'class>onclick=alert(1)'",
  )
}

///|
test "jinja test_filters TestFilter::test_xmlattr_key_invalid[=]" {
  jinja(
    source="{{ {key: 'my_class'}|xmlattr }}",
    "{\"key\": \"class=onclick=alert(1)\"}",
    error="ValueError: Invalid character in attribute name: 'class=onclick=alert(1)'",
  )
}

///|
test "jinja test_filters TestFilter::test_sort1" {
  jinja(
    source="{{ [2, 3, 1]|sort }}|{{ [2, 3, 1]|sort(true) }}",
    "{}",
    output="[1, 2, 3]|[3, 2, 1]",
  )
}

///|
test "jinja test_filters TestFilter::test_sort2" {
  jinja(
    source="{{ \"\".join([\"c\", \"A\", \"b\", \"D\"]|sort) }}",
    "{}",
    output="AbcD",
  )
}

///|
test "jinja test_filters TestFilter::test_sort3" {
  jinja(
    source="{{ ['foo', 'Bar', 'blah']|sort }}",
    "{}",
    output="['Bar', 'blah', 'foo']",
  )
}

///|
test "jinja test_filters TestFilter::test_unique" {
  jinja(
    source="{{ \"\".join([\"b\", \"A\", \"a\", \"b\"]|unique) }}",
    "{}",
    output="bA",
  )
}

///|
test "jinja test_filters TestFilter::test_unique_case_sensitive" {
  jinja(
    source="{{ \"\".join([\"b\", \"A\", \"a\", \"b\"]|unique(true)) }}",
    "{}",
    output="bAa",
  )
}

///|
test "jinja test_filters TestFilter::test_min_max[{{ [\"a\", \"B\"]|min }}-a]" {
  jinja(source="{{ [\"a\", \"B\"]|min }}", "{}", output="a")
}

///|
test "jinja test_filters TestFilter::test_min_max[{{ [\"a\", \"B\"]|min(case_sensitive=true) }}-B]" {
  jinja(
    source="{{ [\"a\", \"B\"]|min(case_sensitive=true) }}",
    "{}",
    output="B",
  )
}

///|
test "jinja test_filters TestFilter::test_min_max[{{ []|min }}-]" {
  jinja(source="{{ []|min }}", "{}", output="")
}

///|
test "jinja test_filters TestFilter::test_min_max[{{ [\"a\", \"B\"]|max }}-B]" {
  jinja(source="{{ [\"a\", \"B\"]|max }}", "{}", output="B")
}

///|
test "jinja test_filters TestFilter::test_min_max[{{ [\"a\", \"B\"]|max(case_sensitive=true) }}-a]" {
  jinja(
    source="{{ [\"a\", \"B\"]|max(case_sensitive=true) }}",
    "{}",
    output="a",
  )
}

///|
test "jinja test_filters TestFilter::test_min_max[{{ []|max }}-]" {
  jinja(source="{{ []|max }}", "{}", output="")
}

///|
test "jinja test_filters TestFilter::test_groupby" {
  jinja(
    source="\n        {%- for grouper, list in [{'foo': 1, 'bar': 2},\n                                  {'foo': 2, 'bar': 3},\n                                  {'foo': 1, 'bar': 1},\n                                  {'foo': 3, 'bar': 4}]|groupby('foo') -%}\n            {{ grouper }}{% for x in list %}: {{ x.foo }}, {{ x.bar }}{% endfor %}|\n        {%- endfor %}",
    "{}",
    output="1: 1, 2: 1, 1|2: 2, 3|3: 3, 4|",
  )
}

///|
test "jinja test_filters TestFilter::test_groupby_tuple_index" {
  jinja(
    source="\n        {%- for grouper, list in [('a', 1), ('a', 2), ('b', 1)]|groupby(0) -%}\n            {{ grouper }}{% for x in list %}:{{ x.1 }}{% endfor %}|\n        {%- endfor %}",
    "{}",
    output="a:1:2|b:1|",
  )
}

///|
test "jinja test_filters TestFilter::test_groupby_default" {
  jinja(
    source="{% for city, items in users|groupby('city', default='NY') %}{{ city }}: {{ items|map(attribute='name')|join(', ') }}\n{% endfor %}",
    "{\"users\": [{\"name\": \"emma\", \"city\": \"NY\"}, {\"name\": \"smith\", \"city\": \"WA\"}, {\"name\": \"john\"}]}",
    output="NY: emma, john\nWA: smith\n",
  )
}

///|
test "jinja test_filters TestFilter::test_groupby_case[False-a: 1, 3\\nb: 2\\n]" {
  jinja(
    source="{% for k, vs in data|groupby('k', case_sensitive=cs) %}{{ k }}: {{ vs|join(', ', attribute='v') }}\n{% endfor %}",
    "{\"data\": [{\"k\": \"a\", \"v\": 1}, {\"k\": \"b\", \"v\": 2}, {\"k\": \"A\", \"v\": 3}], \"cs\": false}",
    output="a: 1, 3\nb: 2\n",
  )
}

///|
test "jinja test_filters TestFilter::test_groupby_case[True-A: 3\\na: 1\\nb: 2\\n]" {
  jinja(
    source="{% for k, vs in data|groupby('k', case_sensitive=cs) %}{{ k }}: {{ vs|join(', ', attribute='v') }}\n{% endfor %}",
    "{\"data\": [{\"k\": \"a\", \"v\": 1}, {\"k\": \"b\", \"v\": 2}, {\"k\": \"A\", \"v\": 3}], \"cs\": true}",
    output="A: 3\na: 1\nb: 2\n",
  )
}

///|
test "jinja test_filters TestFilter::test_filtertag" {
  jinja(
    source="{% filter upper|replace('FOO', 'foo') %}foobar{% endfilter %}",
    "{}",
    output="fooBAR",
  )
}

///|
test "jinja test_filters TestFilter::test_replace" {
  jinja(
    source="{{ string|replace(\"o\", 42) }}",
    "{\"string\": \"<foo>\"}",
    output="<f4242>",
  )
}

///|
test "jinja test_filters TestFilter::test_replace #2" {
  jinja(
    source="{{ string|replace(\"o\", 42) }}",
    "{\"string\": \"<foo>\"}",
    output="&lt;f4242&gt;",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_replace #3" {
  jinja(
    source="{{ string|replace(\"<\", 42) }}",
    "{\"string\": \"<foo>\"}",
    output="42foo&gt;",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_safe" {
  jinja(
    source="{{ \"<div>foo</div>\"|safe }}",
    "{}",
    output="<div>foo</div>",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_safe #2" {
  jinja(
    source="{{ \"<div>foo</div>\" }}",
    "{}",
    output="&lt;div&gt;foo&lt;/div&gt;",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_urlencode[Hello, world!-Hello%2C%20world%21]" {
  jinja(
    source="{{ value|urlencode }}",
    "{\"value\": \"Hello, world!\"}",
    output="Hello%2C%20world%21",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_urlencode[Hello, world\\u203d-Hello%2C%20world%E2%80%BD]" {
  jinja(
    source="{{ value|urlencode }}",
    "{\"value\": \"Hello, world‽\"}",
    output="Hello%2C%20world%E2%80%BD",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_urlencode[value2-f=1]" {
  jinja(
    source="{{ value|urlencode }}",
    "{\"value\": {\"f\": 1}}",
    output="f=1",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_urlencode[value4-%E2%80%BD=1]" {
  jinja(
    source="{{ value|urlencode }}",
    "{\"value\": {\"‽\": 1}}",
    output="%E2%80%BD=1",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_urlencode[a b/c-a%20b/c]" {
  jinja(
    source="{{ value|urlencode }}",
    "{\"value\": \"a b/c\"}",
    output="a%20b/c",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_simple_map" {
  jinja(source="{{ [\"1\", \"2\", \"3\"]|map(\"int\")|sum }}", "{}", output="6")
}

///|
test "jinja test_filters TestFilter::test_map_sum" {
  jinja(
    source="{{ [[1,2], [3], [4,5,6]]|map(\"sum\")|list }}",
    "{}",
    output="[3, 3, 15]",
  )
}

///|
test "jinja test_filters TestFilter::test_empty_map" {
  jinja(source="{{ none|map(\"upper\")|list }}", "{}", output="[]")
}

///|
test "jinja test_filters TestFilter::test_simple_select" {
  jinja(
    source="{{ [1, 2, 3, 4, 5]|select(\"odd\")|join(\"|\") }}",
    "{}",
    output="1|3|5",
  )
}

///|
test "jinja test_filters TestFilter::test_bool_select" {
  jinja(
    source="{{ [none, false, 0, 1, 2, 3, 4, 5]|select|join(\"|\") }}",
    "{}",
    output="1|2|3|4|5",
  )
}

///|
test "jinja test_filters TestFilter::test_simple_reject" {
  jinja(
    source="{{ [1, 2, 3, 4, 5]|reject(\"odd\")|join(\"|\") }}",
    "{}",
    output="2|4",
  )
}

///|
test "jinja test_filters TestFilter::test_bool_reject" {
  jinja(
    source="{{ [none, false, 0, 1, 2, 3, 4, 5]|reject|join(\"|\") }}",
    "{}",
    output="None|False|0",
  )
}

///|
test "jinja test_filters TestFilter::test_json_dump" {
  jinja(
    source="{{ x|tojson }}",
    "{\"x\": {\"foo\": \"bar\"}}",
    output="{\"foo\": \"bar\"}",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_json_dump #2" {
  jinja(
    source="{{ x|tojson }}",
    "{\"x\": \"\\\"ba&r'\"}",
    output="\"\\\"ba\\u0026r\\u0027\"",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_json_dump #3" {
  jinja(
    source="{{ x|tojson }}",
    "{\"x\": \"<bar>\"}",
    output="\"\\u003cbar\\u003e\"",
    autoescape=true,
  )
}

///|
test "jinja test_filters TestFilter::test_wordwrap" {
  jinja(
    source="{{ s|wordwrap(20) }}",
    "{\"s\": \"Hello!\\nThis is Jinja saying something.\"}",
    output="Hello!\nThis is Jinja saying\nsomething.",
  )
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_if" {
  jinja(
    source="{%- if x is defined -%}{{ x|f }}{%- else -%}x{% endif %}",
    "{}",
    output="x",
  )
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_if #2" {
  jinja(
    source="{%- if x is defined -%}{{ x|f }}{%- else -%}x{% endif %}",
    "{\"x\": 42}",
    error="TemplateRuntimeError: No filter named 'f' found.",
  )
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_elif" {
  jinja(
    source="{%- if x is defined -%}{{ x }}{%- elif y is defined -%}{{ y|f }}{%- else -%}foo{%- endif -%}",
    "{}",
    output="foo",
  )
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_elif #2" {
  jinja(
    source="{%- if x is defined -%}{{ x }}{%- elif y is defined -%}{{ y|f }}{%- else -%}foo{%- endif -%}",
    "{\"y\": 42}",
    error="TemplateRuntimeError: No filter named 'f' found.",
  )
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_else" {
  jinja(
    source="{%- if x is not defined -%}foo{%- else -%}{{ x|f }}{%- endif -%}",
    "{}",
    output="foo",
  )
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_else #2" {
  jinja(
    source="{%- if x is not defined -%}foo{%- else -%}{{ x|f }}{%- endif -%}",
    "{\"x\": 42}",
    error="TemplateRuntimeError: No filter named 'f' found.",
  )
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_nested_if" {
  jinja(
    source="{%- if x is not defined -%}foo{%- else -%}{%- if y is defined -%}{{ y|f }}{%- endif -%}{{ x }}{%- endif -%}",
    "{}",
    output="foo",
  )
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_nested_if #2" {
  jinja(
    source="{%- if x is not defined -%}foo{%- else -%}{%- if y is defined -%}{{ y|f }}{%- endif -%}{{ x }}{%- endif -%}",
    "{\"x\": 42}",
    output="42",
  )
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_nested_if #3" {
  jinja(
    source="{%- if x is not defined -%}foo{%- else -%}{%- if y is defined -%}{{ y|f }}{%- endif -%}{{ x }}{%- endif -%}",
    "{\"x\": 24, \"y\": 42}",
    error="TemplateRuntimeError: No filter named 'f' found.",
  )
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_condexpr" {
  jinja(source="{{ x|f if x is defined else 'foo' }}", "{}", output="foo")
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_condexpr #2" {
  jinja(source="{{ 'foo' if x is not defined else x|f }}", "{}", output="foo")
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_condexpr #3" {
  jinja(
    source="{{ x|f if x is defined else 'foo' }}",
    "{\"x\": 42}",
    error="TemplateRuntimeError: No filter named 'f' found.",
  )
}

///|
test "jinja test_filters TestFilter::test_filter_undefined_in_condexpr #4" {
  jinja(
    source="{{ 'foo' if x is not defined else x|f }}",
    "{\"x\": 42}",
    error="TemplateRuntimeError: No filter named 'f' found.",
  )
}

///|
test "jinja test_imports TestImports::test_context_imports" {
  jinja(
    source="{% import \"module\" as m %}{{ m.test() }}",
    "{\"foo\": 42}",
    output="[|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestImports::test_context_imports #2" {
  jinja(
    source="{% import \"module\" as m without context %}{{ m.test() }}",
    "{\"foo\": 42}",
    output="[|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestImports::test_context_imports #3" {
  jinja(
    source="{% import \"module\" as m with context %}{{ m.test() }}",
    "{\"foo\": 42}",
    output="[42|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestImports::test_context_imports #4" {
  jinja(
    source="{% from \"module\" import test %}{{ test() }}",
    "{\"foo\": 42}",
    output="[|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestImports::test_context_imports #5" {
  jinja(
    source="{% from \"module\" import test without context %}{{ test() }}",
    "{\"foo\": 42}",
    output="[|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestImports::test_context_imports #6" {
  jinja(
    source="{% from \"module\" import test with context %}{{ test() }}",
    "{\"foo\": 42}",
    output="[42|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestImports::test_not_exported" {
  jinja(
    source="{% from 'module' import nothing %}{{ nothing() }}",
    "{}",
    error="UndefinedError: the template 'module' (imported on line 1) does not export the requested name 'nothing'",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestImports::test_import_with_globals" {
  jinja(
    source="{% import \"module\" as m %}{{ m.test() }}",
    "{}",
    output="[|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_context_include" {
  jinja(
    source="{% include \"header\" %}",
    "{\"foo\": 42}",
    output="[42|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_context_include #2" {
  jinja(
    source="{% include \"header\" with context %}",
    "{\"foo\": 42}",
    output="[42|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_context_include #3" {
  jinja(
    source="{% include \"header\" without context %}",
    "{\"foo\": 42}",
    output="[|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_choice_includes" {
  jinja(
    source="{% include [\"missing\", \"header\"] %}",
    "{\"foo\": 42}",
    output="[42|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_choice_includes #2" {
  jinja(
    source="{% include [\"missing\", \"missing2\"] ignore missing %}",
    "{\"foo\": 42}",
    output="",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_choice_includes #3" {
  jinja(
    source="{% include [\"missing\", \"missing2\"] %}",
    "{}",
    error="TemplatesNotFound: none of the templates given were found: missing, missing2",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_choice_includes #4" {
  jinja(
    source="{% include [\"missing\", \"missing2\"] %}",
    "{}",
    error="TemplatesNotFound: none of the templates given were found: missing, missing2",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_choice_includes #5" {
  jinja(
    source="{% include [\"missing\", \"header\"] %}",
    "{\"foo\": 42}",
    output="[42|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_choice_includes #6" {
  jinja(
    source="{% include x %}",
    "{\"x\": [\"missing\", \"header\"], \"foo\": 42}",
    output="[42|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_choice_includes #7" {
  jinja(
    source="{% include [x, \"header\"] %}",
    "{\"x\": \"missing\", \"foo\": 42}",
    output="[42|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_choice_includes #8" {
  jinja(
    source="{% include x %}",
    "{\"x\": \"header\", \"foo\": 42}",
    output="[42|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_choice_includes #9" {
  jinja(
    source="{% include [x] %}",
    "{\"x\": \"header\", \"foo\": 42}",
    output="[42|23]",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_include_ignoring_missing" {
  jinja(
    source="{% include \"missing\" %}",
    "{}",
    error="TemplateNotFound: missing",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_include_ignoring_missing #2" {
  jinja(
    source="{% include \"missing\" ignore missing  %}",
    "{}",
    output="",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_include_ignoring_missing #3" {
  jinja(
    source="{% include \"missing\" ignore missing with context %}",
    "{}",
    output="",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_include_ignoring_missing #4" {
  jinja(
    source="{% include \"missing\" ignore missing without context %}",
    "{}",
    output="",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_context_include_with_overrides" {
  jinja(
    name="main",
    "{}",
    output="123",
    templates="{\"main\": \"{% for item in [1, 2, 3] %}{% include 'item' %}{% endfor %}\", \"item\": \"{{ item }}\"}",
  )
}

///|
test "jinja test_imports TestIncludes::test_unoptimized_scopes" {
  jinja(
    source="\n            {% macro outer(o) %}\n            {% macro inner() %}\n            {% include \"o_printer\" %}\n            {% endmacro %}\n            {{ inner() }}\n            {% endmacro %}\n            {{ outer(\"FOO\") }}\n        ",
    "{}",
    output="\n            \n            \n            \n            \n            (FOO)\n            \n            \n        ",
    templates="{\"module\": \"{% macro test() %}[{{ foo }}|{{ bar }}]{% endmacro %}\", \"header\": \"[{{ foo }}|{{ 23 }}]\", \"o_printer\": \"({{ o }})\"}",
    globals="{\"bar\": 23}",
  )
}

///|
test "jinja test_imports TestIncludes::test_import_from_with_context" {
  jinja(
    source="{% set foobar = 42 %}{% from 'a' import x with context %}{{ x() }}",
    "{}",
    output="42",
    templates="{\"a\": \"{% macro x() %}{{ foobar }}{% endmacro %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_layout" {
  jinja(
    name="layout",
    "{}",
    output="|block 1 from layout|block 2 from layout|nested block 4 from layout|",
    trim_blocks=true,
    templates="{\"layout\": \"|{% block block1 %}block 1 from layout{% endblock %}\\n|{% block block2 %}block 2 from layout{% endblock %}\\n|{% block block3 %}\\n{% block block4 %}nested block 4 from layout{% endblock %}\\n{% endblock %}|\", \"level1\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}block 1 from level1{% endblock %}\", \"level2\": \"{% extends \\\"level1\\\" %}\\n{% block block2 %}{% block block5 %}nested block 5 from level2{%\\nendblock %}{% endblock %}\", \"level3\": \"{% extends \\\"level2\\\" %}\\n{% block block5 %}block 5 from level3{% endblock %}\\n{% block block4 %}block 4 from level3{% endblock %}\\n\", \"level4\": \"{% extends \\\"level3\\\" %}\\n{% block block3 %}block 3 from level4{% endblock %}\\n\", \"working\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\", \"doublee\": \"{% extends \\\"layout\\\" %}\\n{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_level1" {
  jinja(
    name="level1",
    "{}",
    output="|block 1 from level1|block 2 from layout|nested block 4 from layout|",
    trim_blocks=true,
    templates="{\"layout\": \"|{% block block1 %}block 1 from layout{% endblock %}\\n|{% block block2 %}block 2 from layout{% endblock %}\\n|{% block block3 %}\\n{% block block4 %}nested block 4 from layout{% endblock %}\\n{% endblock %}|\", \"level1\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}block 1 from level1{% endblock %}\", \"level2\": \"{% extends \\\"level1\\\" %}\\n{% block block2 %}{% block block5 %}nested block 5 from level2{%\\nendblock %}{% endblock %}\", \"level3\": \"{% extends \\\"level2\\\" %}\\n{% block block5 %}block 5 from level3{% endblock %}\\n{% block block4 %}block 4 from level3{% endblock %}\\n\", \"level4\": \"{% extends \\\"level3\\\" %}\\n{% block block3 %}block 3 from level4{% endblock %}\\n\", \"working\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\", \"doublee\": \"{% extends \\\"layout\\\" %}\\n{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_level2" {
  jinja(
    name="level2",
    "{}",
    output="|block 1 from level1|nested block 5 from level2|nested block 4 from layout|",
    trim_blocks=true,
    templates="{\"layout\": \"|{% block block1 %}block 1 from layout{% endblock %}\\n|{% block block2 %}block 2 from layout{% endblock %}\\n|{% block block3 %}\\n{% block block4 %}nested block 4 from layout{% endblock %}\\n{% endblock %}|\", \"level1\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}block 1 from level1{% endblock %}\", \"level2\": \"{% extends \\\"level1\\\" %}\\n{% block block2 %}{% block block5 %}nested block 5 from level2{%\\nendblock %}{% endblock %}\", \"level3\": \"{% extends \\\"level2\\\" %}\\n{% block block5 %}block 5 from level3{% endblock %}\\n{% block block4 %}block 4 from level3{% endblock %}\\n\", \"level4\": \"{% extends \\\"level3\\\" %}\\n{% block block3 %}block 3 from level4{% endblock %}\\n\", \"working\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\", \"doublee\": \"{% extends \\\"layout\\\" %}\\n{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_level3" {
  jinja(
    name="level3",
    "{}",
    output="|block 1 from level1|block 5 from level3|block 4 from level3|",
    trim_blocks=true,
    templates="{\"layout\": \"|{% block block1 %}block 1 from layout{% endblock %}\\n|{% block block2 %}block 2 from layout{% endblock %}\\n|{% block block3 %}\\n{% block block4 %}nested block 4 from layout{% endblock %}\\n{% endblock %}|\", \"level1\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}block 1 from level1{% endblock %}\", \"level2\": \"{% extends \\\"level1\\\" %}\\n{% block block2 %}{% block block5 %}nested block 5 from level2{%\\nendblock %}{% endblock %}\", \"level3\": \"{% extends \\\"level2\\\" %}\\n{% block block5 %}block 5 from level3{% endblock %}\\n{% block block4 %}block 4 from level3{% endblock %}\\n\", \"level4\": \"{% extends \\\"level3\\\" %}\\n{% block block3 %}block 3 from level4{% endblock %}\\n\", \"working\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\", \"doublee\": \"{% extends \\\"layout\\\" %}\\n{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_level4" {
  jinja(
    name="level4",
    "{}",
    output="|block 1 from level1|block 5 from level3|block 3 from level4|",
    trim_blocks=true,
    templates="{\"layout\": \"|{% block block1 %}block 1 from layout{% endblock %}\\n|{% block block2 %}block 2 from layout{% endblock %}\\n|{% block block3 %}\\n{% block block4 %}nested block 4 from layout{% endblock %}\\n{% endblock %}|\", \"level1\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}block 1 from level1{% endblock %}\", \"level2\": \"{% extends \\\"level1\\\" %}\\n{% block block2 %}{% block block5 %}nested block 5 from level2{%\\nendblock %}{% endblock %}\", \"level3\": \"{% extends \\\"level2\\\" %}\\n{% block block5 %}block 5 from level3{% endblock %}\\n{% block block4 %}block 4 from level3{% endblock %}\\n\", \"level4\": \"{% extends \\\"level3\\\" %}\\n{% block block3 %}block 3 from level4{% endblock %}\\n\", \"working\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\", \"doublee\": \"{% extends \\\"layout\\\" %}\\n{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_super" {
  jinja(
    name="c",
    "{}",
    output="--INTRO--|BEFORE|[(INNER)]|AFTER",
    templates="{\"a\": \"{% block intro %}INTRO{% endblock %}|BEFORE|{% block data %}INNER{% endblock %}|AFTER\", \"b\": \"{% extends \\\"a\\\" %}{% block data %}({{ super() }}){% endblock %}\", \"c\": \"{% extends \\\"b\\\" %}{% block intro %}--{{ super() }}--{% endblock %}\\n{% block data %}[{{ super() }}]{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_reuse_blocks" {
  jinja(
    source="{{ self.foo() }}|{% block foo %}42{% endblock %}|{{ self.foo() }}",
    "{}",
    output="42|42|42",
    trim_blocks=true,
    templates="{\"layout\": \"|{% block block1 %}block 1 from layout{% endblock %}\\n|{% block block2 %}block 2 from layout{% endblock %}\\n|{% block block3 %}\\n{% block block4 %}nested block 4 from layout{% endblock %}\\n{% endblock %}|\", \"level1\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}block 1 from level1{% endblock %}\", \"level2\": \"{% extends \\\"level1\\\" %}\\n{% block block2 %}{% block block5 %}nested block 5 from level2{%\\nendblock %}{% endblock %}\", \"level3\": \"{% extends \\\"level2\\\" %}\\n{% block block5 %}block 5 from level3{% endblock %}\\n{% block block4 %}block 4 from level3{% endblock %}\\n\", \"level4\": \"{% extends \\\"level3\\\" %}\\n{% block block3 %}block 3 from level4{% endblock %}\\n\", \"working\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\", \"doublee\": \"{% extends \\\"layout\\\" %}\\n{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_preserve_blocks" {
  jinja(
    name="b",
    "{}",
    output="BA",
    templates="{\"a\": \"{% if false %}{% block x %}A{% endblock %}{% endif %}{{ self.x() }}\", \"b\": \"{% extends \\\"a\\\" %}{% block x %}B{{ super() }}{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_dynamic_inheritance" {
  jinja(
    name="child",
    "{\"default\": \"default1\"}",
    output="DEFAULT1CHILD",
    templates="{\"default1\": \"DEFAULT1{% block x %}{% endblock %}\", \"default2\": \"DEFAULT2{% block x %}{% endblock %}\", \"child\": \"{% extends default %}{% block x %}CHILD{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_dynamic_inheritance #2" {
  jinja(
    name="child",
    "{\"default\": \"default2\"}",
    output="DEFAULT2CHILD",
    templates="{\"default1\": \"DEFAULT1{% block x %}{% endblock %}\", \"default2\": \"DEFAULT2{% block x %}{% endblock %}\", \"child\": \"{% extends default %}{% block x %}CHILD{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_multi_inheritance" {
  jinja(
    name="child",
    "{\"default\": \"default2\"}",
    output="DEFAULT2CHILD",
    templates="{\"default1\": \"DEFAULT1{% block x %}{% endblock %}\", \"default2\": \"DEFAULT2{% block x %}{% endblock %}\", \"child\": \"{% if default %}{% extends default %}{% else %}{% extends 'default1' %}{% endif %}{% block x %}CHILD{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_multi_inheritance #2" {
  jinja(
    name="child",
    "{\"default\": \"default1\"}",
    output="DEFAULT1CHILD",
    templates="{\"default1\": \"DEFAULT1{% block x %}{% endblock %}\", \"default2\": \"DEFAULT2{% block x %}{% endblock %}\", \"child\": \"{% if default %}{% extends default %}{% else %}{% extends 'default1' %}{% endif %}{% block x %}CHILD{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_multi_inheritance #3" {
  jinja(
    name="child",
    "{}",
    output="DEFAULT1CHILD",
    templates="{\"default1\": \"DEFAULT1{% block x %}{% endblock %}\", \"default2\": \"DEFAULT2{% block x %}{% endblock %}\", \"child\": \"{% if default %}{% extends default %}{% else %}{% extends 'default1' %}{% endif %}{% block x %}CHILD{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_scoped_block" {
  jinja(
    source="{% extends 'default.html' %}{% block item %}{{ item }}{% endblock %}",
    "{\"seq\": [0, 1, 2, 3, 4]}",
    output="[0][1][2][3][4]",
    templates="{\"default.html\": \"{% for item in seq %}[{% block item scoped %}{% endblock %}]{% endfor %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_super_in_scoped_block" {
  jinja(
    source="{% extends \"default.html\" %}{% block item %}{{ super() }}|{{ item * 2 }}{% endblock %}",
    "{\"seq\": [0, 1, 2, 3, 4]}",
    output="[0|0][1|2][2|4][3|6][4|8]",
    templates="{\"default.html\": \"{% for item in seq %}[{% block item scoped %}{{ item }}{% endblock %}]{% endfor %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_scoped_block_after_inheritance" {
  jinja(
    name="index.html",
    "{\"the_foo\": 42}",
    output="\n            \n                \n                    \n                        43\n                    \n                \n                    \n                        44\n                    \n                \n                    \n                        45\n                    \n                \n            \n            ",
    templates="{\"layout.html\": \"\\n            {% block useless %}{% endblock %}\\n            \", \"index.html\": \"\\n            {%- extends 'layout.html' %}\\n            {% from 'helpers.html' import foo with context %}\\n            {% block useless %}\\n                {% for x in [1, 2, 3] %}\\n                    {% block testing scoped %}\\n                        {{ foo(x) }}\\n                    {% endblock %}\\n                {% endfor %}\\n            {% endblock %}\\n            \", \"helpers.html\": \"\\n            {% macro foo(x) %}{{ the_foo + x }}{% endmacro %}\\n            \"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_level1_required" {
  jinja(
    name="level1",
    "{}",
    output="[1]",
    templates="{\"default\": \"{% block x required %}{# comment #}\\n {% endblock %}\", \"level1\": \"{% extends 'default' %}{% block x %}[1]{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_level2_required" {
  jinja(
    name="level1",
    "{}",
    output="[1]",
    templates="{\"default\": \"{% block x required %}{% endblock %}\", \"level1\": \"{% extends 'default' %}{% block x %}[1]{% endblock %}\", \"level2\": \"{% extends 'default' %}{% block x %}[2]{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_level2_required #2" {
  jinja(
    name="level2",
    "{}",
    output="[2]",
    templates="{\"default\": \"{% block x required %}{% endblock %}\", \"level1\": \"{% extends 'default' %}{% block x %}[1]{% endblock %}\", \"level2\": \"{% extends 'default' %}{% block x %}[2]{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_level3_required" {
  jinja(
    name="level1",
    "{}",
    error="TemplateRuntimeError: Required block 'x' not found",
    templates="{\"default\": \"{% block x required %}{% endblock %}\", \"level1\": \"{% extends 'default' %}\", \"level2\": \"{% extends 'level1' %}{% block x %}[2]{% endblock %}\", \"level3\": \"{% extends 'level2' %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_level3_required #2" {
  jinja(
    name="level2",
    "{}",
    output="[2]",
    templates="{\"default\": \"{% block x required %}{% endblock %}\", \"level1\": \"{% extends 'default' %}\", \"level2\": \"{% extends 'level1' %}{% block x %}[2]{% endblock %}\", \"level3\": \"{% extends 'level2' %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_level3_required #3" {
  jinja(
    name="level3",
    "{}",
    output="[2]",
    templates="{\"default\": \"{% block x required %}{% endblock %}\", \"level1\": \"{% extends 'default' %}\", \"level2\": \"{% extends 'level1' %}{% block x %}[2]{% endblock %}\", \"level3\": \"{% extends 'level2' %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_invalid_required" {
  jinja(
    name="top",
    "{\"t\": \"empty\"}",
    output="CHILD",
    templates="{\"empty\": \"{% block x required %}{% endblock %}\", \"blank\": \"{% block x required %} {# c #}{% endblock %}\", \"text\": \"{% block x required %}data {# c #}{% endblock %}\", \"block\": \"{% block x required %}{% block y %}{% endblock %}{% endblock %}\", \"if\": \"{% block x required %}{% if true %}{% endif %}{% endblock %}\", \"top\": \"{% extends t %}{% block x %}CHILD{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_invalid_required #2" {
  jinja(
    name="top",
    "{\"t\": \"blank\"}",
    output="CHILD",
    templates="{\"empty\": \"{% block x required %}{% endblock %}\", \"blank\": \"{% block x required %} {# c #}{% endblock %}\", \"text\": \"{% block x required %}data {# c #}{% endblock %}\", \"block\": \"{% block x required %}{% block y %}{% endblock %}{% endblock %}\", \"if\": \"{% block x required %}{% if true %}{% endif %}{% endblock %}\", \"top\": \"{% extends t %}{% block x %}CHILD{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_invalid_required #3" {
  jinja(
    name="top",
    "{\"t\": \"text\"}",
    error="TemplateSyntaxError: Required blocks can only contain comments or whitespace",
    templates="{\"empty\": \"{% block x required %}{% endblock %}\", \"blank\": \"{% block x required %} {# c #}{% endblock %}\", \"text\": \"{% block x required %}data {# c #}{% endblock %}\", \"block\": \"{% block x required %}{% block y %}{% endblock %}{% endblock %}\", \"if\": \"{% block x required %}{% if true %}{% endif %}{% endblock %}\", \"top\": \"{% extends t %}{% block x %}CHILD{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_invalid_required #4" {
  jinja(
    name="top",
    "{\"t\": \"block\"}",
    error="TemplateSyntaxError: Required blocks can only contain comments or whitespace",
    templates="{\"empty\": \"{% block x required %}{% endblock %}\", \"blank\": \"{% block x required %} {# c #}{% endblock %}\", \"text\": \"{% block x required %}data {# c #}{% endblock %}\", \"block\": \"{% block x required %}{% block y %}{% endblock %}{% endblock %}\", \"if\": \"{% block x required %}{% if true %}{% endif %}{% endblock %}\", \"top\": \"{% extends t %}{% block x %}CHILD{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_invalid_required #5" {
  jinja(
    name="top",
    "{\"t\": \"if\"}",
    error="TemplateSyntaxError: Required blocks can only contain comments or whitespace",
    templates="{\"empty\": \"{% block x required %}{% endblock %}\", \"blank\": \"{% block x required %} {# c #}{% endblock %}\", \"text\": \"{% block x required %}data {# c #}{% endblock %}\", \"block\": \"{% block x required %}{% block y %}{% endblock %}{% endblock %}\", \"if\": \"{% block x required %}{% if true %}{% endif %}{% endblock %}\", \"top\": \"{% extends t %}{% block x %}CHILD{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_required_with_scope" {
  jinja(
    name="child1",
    "{\"seq\": [0, 1, 2]}",
    output="[0][1][2]",
    templates="{\"default1\": \"{% for item in seq %}[{% block item scoped required %}{% endblock %}]{% endfor %}\", \"child1\": \"{% extends 'default1' %}{% block item %}{{ item }}{% endblock %}\", \"default2\": \"{% for item in seq %}[{% block item required scoped %}{% endblock %}]{% endfor %}\", \"child2\": \"{% extends 'default2' %}{% block item %}{{ item }}{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_required_with_scope #2" {
  jinja(
    name="child2",
    "{\"seq\": [0, 1, 2]}",
    error="TemplateSyntaxError: expected token 'end of statement block', got 'scoped'",
    templates="{\"default1\": \"{% for item in seq %}[{% block item scoped required %}{% endblock %}]{% endfor %}\", \"child1\": \"{% extends 'default1' %}{% block item %}{{ item }}{% endblock %}\", \"default2\": \"{% for item in seq %}[{% block item required scoped %}{% endblock %}]{% endfor %}\", \"child2\": \"{% extends 'default2' %}{% block item %}{{ item }}{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_duplicate_required_or_scoped" {
  jinja(
    name="child",
    "{\"default\": \"default1\", \"seq\": [0, 1, 2]}",
    error="TemplateSyntaxError: expected token 'end of statement block', got 'scoped'",
    templates="{\"default1\": \"{% for item in seq %}[{% block item scoped scoped %}}{{% endblock %}}]{{% endfor %}}\", \"default2\": \"{% for item in seq %}[{% block item required required %}}{{% endblock %}}]{{% endfor %}}\", \"child\": \"{% if default %}{% extends default %}{% else %}{% extends 'default1' %}{% endif %}{%- block x %}CHILD{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestInheritance::test_duplicate_required_or_scoped #2" {
  jinja(
    name="child",
    "{\"default\": \"default2\", \"seq\": [0, 1, 2]}",
    error="TemplateSyntaxError: expected token 'end of statement block', got 'required'",
    templates="{\"default1\": \"{% for item in seq %}[{% block item scoped scoped %}}{{% endblock %}}]{{% endfor %}}\", \"default2\": \"{% for item in seq %}[{% block item required required %}}{{% endblock %}}]{{% endfor %}}\", \"child\": \"{% if default %}{% extends default %}{% else %}{% extends 'default1' %}{% endif %}{%- block x %}CHILD{% endblock %}\"}",
  )
}

///|
test "jinja test_inheritance TestBugFix::test_fixed_macro_scoping_bug" {
  jinja(
    name="test.html",
    "{}",
    output="                \n        \n            \n                outer_box\n                \n            \n        my_macro\n        \n        \n            \n        \n        ",
    templates="{\"test.html\": \"        {% extends 'details.html' %}\\n\\n        {% macro my_macro() %}\\n        my_macro\\n        {% endmacro %}\\n\\n        {% block inner_box %}\\n            {{ my_macro() }}\\n        {% endblock %}\\n            \", \"details.html\": \"        {% extends 'standard.html' %}\\n\\n        {% macro my_macro() %}\\n        my_macro\\n        {% endmacro %}\\n\\n        {% block content %}\\n            {% block outer_box %}\\n                outer_box\\n                {% block inner_box %}\\n                    inner_box\\n                {% endblock %}\\n            {% endblock %}\\n        {% endblock %}\\n        \", \"standard.html\": \"\\n        {% block content %}&nbsp;{% endblock %}\\n        \"}",
  )
}

///|
test "jinja test_inheritance TestBugFix::test_double_extends" {
  jinja(
    name="doublee",
    "{}",
    error="TemplateRuntimeError: extended multiple times",
    trim_blocks=true,
    templates="{\"layout\": \"|{% block block1 %}block 1 from layout{% endblock %}\\n|{% block block2 %}block 2 from layout{% endblock %}\\n|{% block block3 %}\\n{% block block4 %}nested block 4 from layout{% endblock %}\\n{% endblock %}|\", \"level1\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}block 1 from level1{% endblock %}\", \"level2\": \"{% extends \\\"level1\\\" %}\\n{% block block2 %}{% block block5 %}nested block 5 from level2{%\\nendblock %}{% endblock %}\", \"level3\": \"{% extends \\\"level2\\\" %}\\n{% block block5 %}block 5 from level3{% endblock %}\\n{% block block4 %}block 4 from level3{% endblock %}\\n\", \"level4\": \"{% extends \\\"level3\\\" %}\\n{% block block3 %}block 3 from level4{% endblock %}\\n\", \"working\": \"{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\", \"doublee\": \"{% extends \\\"layout\\\" %}\\n{% extends \\\"layout\\\" %}\\n{% block block1 %}\\n  {% if false %}\\n    {% block block2 %}\\n      this should work\\n    {% endblock %}\\n  {% endif %}\\n{% endblock %}\\n\"}",
  )
}

///|
test "jinja test_lexnparse TestLexer::test_raw1" {
  jinja(
    source="{% raw %}foo{% endraw %}|{%raw%}{{ bar }}|{% baz %}{%       endraw    %}",
    "{}",
    output="foo|{{ bar }}|{% baz %}",
  )
}

///|
test "jinja test_lexnparse TestLexer::test_raw2" {
  jinja(source="1  {%- raw -%}   2   {%- endraw -%}   3", "{}", output="123")
}

///|
test "jinja test_lexnparse TestLexer::test_raw3" {
  jinja(
    source="bar\n{% raw %}\n  {{baz}}2 spaces\n{% endraw %}\nfoo",
    "{\"baz\": \"test\"}",
    output="bar\n\n  {{baz}}2 spaces\nfoo",
    trim_blocks=true,
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLexer::test_raw4" {
  jinja(
    source="bar\n{%- raw -%}\n\n  \n  2 spaces\n space{%- endraw -%}\nfoo",
    "{}",
    output="bar2 spaces\n spacefoo",
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLexer::test_string_escapes" {
  jinja(source="{{ '\\x00' }}", "{}", output="\u{0}")
}

///|
test "jinja test_lexnparse TestLexer::test_string_escapes #2" {
  jinja(source="{{ '♨' }}", "{}", output="♨")
}

///|
test "jinja test_lexnparse TestLexer::test_string_escapes #3" {
  jinja(source="{{ 'ä' }}", "{}", output="ä")
}

///|
test "jinja test_lexnparse TestLexer::test_string_escapes #4" {
  jinja(source="{{ '\\t' }}", "{}", output="\t")
}

///|
test "jinja test_lexnparse TestLexer::test_string_escapes #5" {
  jinja(source="{{ '\\r' }}", "{}", output="\r")
}

///|
test "jinja test_lexnparse TestLexer::test_string_escapes #6" {
  jinja(source="{{ '\\n' }}", "{}", output="\n")
}

///|
test "jinja test_lexnparse TestLexer::test_string_escapes #7" {
  jinja(source="{{ \"♨\" }}", "{}", output="♨")
}

///|
test "jinja test_lexnparse TestLexer::test_bytefallback" {
  jinja(
    source="{{ 'foo'|pprint }}|{{ 'bär'|pprint }}",
    "{}",
    output="'foo'|'bär'",
  )
}

///|
test "jinja test_lexnparse TestLexer::test_normalizing" {
  jinja(source="1\n2\r\n3\n4\n", "{}", output="1\n2\n3\n4")
}

///|
test "jinja test_lexnparse TestLexer::test_trailing_newline" {
  jinja(source="", "{}", output="", keep_trailing_newline=true)
}

///|
test "jinja test_lexnparse TestLexer::test_trailing_newline #2" {
  jinja(
    source="no\nnewline",
    "{}",
    output="no\nnewline",
    keep_trailing_newline=true,
  )
}

///|
test "jinja test_lexnparse TestLexer::test_trailing_newline #3" {
  jinja(
    source="with\nnewline\n",
    "{}",
    output="with\nnewline\n",
    keep_trailing_newline=true,
  )
}

///|
test "jinja test_lexnparse TestLexer::test_trailing_newline #4" {
  jinja(
    source="with\nseveral\n\n\n",
    "{}",
    output="with\nseveral\n\n\n",
    keep_trailing_newline=true,
  )
}

///|
test "jinja test_lexnparse TestLexer::test_trailing_newline #5" {
  jinja(source="", "{}", output="")
}

///|
test "jinja test_lexnparse TestLexer::test_trailing_newline #6" {
  jinja(source="no\nnewline", "{}", output="no\nnewline")
}

///|
test "jinja test_lexnparse TestLexer::test_trailing_newline #7" {
  jinja(source="with\nnewline\n", "{}", output="with\nnewline")
}

///|
test "jinja test_lexnparse TestLexer::test_trailing_newline #8" {
  jinja(source="with\nseveral\n\n\n", "{}", output="with\nseveral\n\n")
}

///|
test "jinja test_lexnparse TestParser::test_balancing" {
  jinja(source="{{{'foo':'bar'}.foo}}", "{}", output="bar")
}

///|
test "jinja test_lexnparse TestParser::test_start_comment" {
  jinja(
    source="{# foo comment\nand bar comment #}\n{% macro blub() %}foo{% endmacro %}\n{{ blub() }}",
    "{}",
    output="\n\nfoo",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_slicing" {
  jinja(
    source="{{ [1, 2, 3][:] }}|{{ [1, 2, 3][::-1] }}",
    "{}",
    output="[1, 2, 3]|[3, 2, 1]",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_attr" {
  jinja(
    source="{{ foo.bar }}|{{ foo['bar'] }}",
    "{\"foo\": {\"bar\": 42}}",
    output="42|42",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_subscript" {
  jinja(
    source="{{ foo[0] }}|{{ foo[-1] }}",
    "{\"foo\": [0, 1, 2]}",
    output="0|2",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_tuple" {
  jinja(
    source="{{ () }}|{{ (1,) }}|{{ (1, 2) }}",
    "{}",
    output="()|(1,)|(1, 2)",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_math" {
  jinja(source="{{ (1 + 1 * 2) - 3 / 2 }}|{{ 2**3 }}", "{}", output="1.5|8")
}

///|
test "jinja test_lexnparse TestSyntax::test_div" {
  jinja(source="{{ 3 // 2 }}|{{ 3 / 2 }}|{{ 3 % 2 }}", "{}", output="1|1.5|1")
}

///|
test "jinja test_lexnparse TestSyntax::test_unary" {
  jinja(source="{{ +3 }}|{{ -3 }}", "{}", output="3|-3")
}

///|
test "jinja test_lexnparse TestSyntax::test_concat" {
  jinja(source="{{ [1, 2] ~ 'foo' }}", "{}", output="[1, 2]foo")
}

///|
test "jinja test_lexnparse TestSyntax::test_compare[1->-0]" {
  jinja(source="{{ 1 > 0 }}", "{}", output="True")
}

///|
test "jinja test_lexnparse TestSyntax::test_compare[1->=-1]" {
  jinja(source="{{ 1 >= 1 }}", "{}", output="True")
}

///|
test "jinja test_lexnparse TestSyntax::test_compare[2-<-3]" {
  jinja(source="{{ 2 < 3 }}", "{}", output="True")
}

///|
test "jinja test_lexnparse TestSyntax::test_compare[3-<=-4]" {
  jinja(source="{{ 3 <= 4 }}", "{}", output="True")
}

///|
test "jinja test_lexnparse TestSyntax::test_compare[4-==-4]" {
  jinja(source="{{ 4 == 4 }}", "{}", output="True")
}

///|
test "jinja test_lexnparse TestSyntax::test_compare[4-!=-5]" {
  jinja(source="{{ 4 != 5 }}", "{}", output="True")
}

///|
test "jinja test_lexnparse TestSyntax::test_compare_parens" {
  jinja(source="{{ i * (j < 5) }}", "{\"i\": 2, \"j\": 3}", output="2")
}

///|
test "jinja test_lexnparse TestSyntax::test_compare_compound[{{ 4 < 2 < 3 }}-False]" {
  jinja(
    source="{{ 4 < 2 < 3 }}",
    "{\"a\": 4, \"b\": 2, \"c\": 3}",
    output="False",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_compare_compound[{{ a < b < c }}-False]" {
  jinja(
    source="{{ a < b < c }}",
    "{\"a\": 4, \"b\": 2, \"c\": 3}",
    output="False",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_compare_compound[{{ 4 > 2 > 3 }}-False]" {
  jinja(
    source="{{ 4 > 2 > 3 }}",
    "{\"a\": 4, \"b\": 2, \"c\": 3}",
    output="False",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_compare_compound[{{ a > b > c }}-False]" {
  jinja(
    source="{{ a > b > c }}",
    "{\"a\": 4, \"b\": 2, \"c\": 3}",
    output="False",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_compare_compound[{{ 4 > 2 < 3 }}-True]" {
  jinja(
    source="{{ 4 > 2 < 3 }}",
    "{\"a\": 4, \"b\": 2, \"c\": 3}",
    output="True",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_compare_compound[{{ a > b < c }}-True]" {
  jinja(
    source="{{ a > b < c }}",
    "{\"a\": 4, \"b\": 2, \"c\": 3}",
    output="True",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_inop" {
  jinja(
    source="{{ 1 in [1, 2, 3] }}|{{ 1 not in [1, 2, 3] }}",
    "{}",
    output="True|False",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_collection_literal[[]]" {
  jinja(source="{{ [] }}", "{}", output="[]")
}

///|
test "jinja test_lexnparse TestSyntax::test_collection_literal[{}]" {
  jinja(source="{{ {} }}", "{}", output="{}")
}

///|
test "jinja test_lexnparse TestSyntax::test_collection_literal[()]" {
  jinja(source="{{ () }}", "{}", output="()")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[1-1]" {
  jinja(source="{{ 1 }}", "{}", output="1")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[123-123]" {
  jinja(source="{{ 123 }}", "{}", output="123")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[12_34_56-123456]" {
  jinja(source="{{ 12_34_56 }}", "{}", output="123456")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[1.2-1.2]" {
  jinja(source="{{ 1.2 }}", "{}", output="1.2")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[34.56-34.56]" {
  jinja(source="{{ 34.56 }}", "{}", output="34.56")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[3_4.5_6-34.56]" {
  jinja(source="{{ 3_4.5_6 }}", "{}", output="34.56")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[1e0-1.0]" {
  jinja(source="{{ 1e0 }}", "{}", output="1.0")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[10e1-100.0]" {
  jinja(source="{{ 10e1 }}", "{}", output="100.0")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[2.5e100-2.5e+100]" {
  jinja(source="{{ 2.5e100 }}", "{}", output="2.5e+100")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[2.5e+100-2.5e+100]" {
  jinja(source="{{ 2.5e+100 }}", "{}", output="2.5e+100")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[25.6e-10-2.56e-09]" {
  jinja(source="{{ 25.6e-10 }}", "{}", output="2.56e-09")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[1_2.3_4e5_6-1.234e+57]" {
  jinja(source="{{ 1_2.3_4e5_6 }}", "{}", output="1.234e+57")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[0-0]" {
  jinja(source="{{ 0 }}", "{}", output="0")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[0_00-0]" {
  jinja(source="{{ 0_00 }}", "{}", output="0")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[0b1001_1111-159]" {
  jinja(source="{{ 0b1001_1111 }}", "{}", output="159")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[0o123-83]" {
  jinja(source="{{ 0o123 }}", "{}", output="83")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[0o1_23-83]" {
  jinja(source="{{ 0o1_23 }}", "{}", output="83")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[0x123abc-1194684]" {
  jinja(source="{{ 0x123abc }}", "{}", output="1194684")
}

///|
test "jinja test_lexnparse TestSyntax::test_numeric_literal[0x12_3abc-1194684]" {
  jinja(source="{{ 0x12_3abc }}", "{}", output="1194684")
}

///|
test "jinja test_lexnparse TestSyntax::test_bool" {
  jinja(
    source="{{ true and false }}|{{ false or true }}|{{ not false }}",
    "{}",
    output="False|True|True",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_grouping" {
  jinja(
    source="{{ (true and false) or (false and true) and not false }}",
    "{}",
    output="False",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_django_attr" {
  jinja(source="{{ [1, 2, 3].0 }}|{{ [[1]].0.0 }}", "{}", output="1|1")
}

///|
test "jinja test_lexnparse TestSyntax::test_conditional_expression" {
  jinja(source="{{ 0 if true else 1 }}", "{}", output="0")
}

///|
test "jinja test_lexnparse TestSyntax::test_short_conditional_expression" {
  jinja(source="<{{ 1 if false }}>", "{}", output="<>")
}

///|
test "jinja test_lexnparse TestSyntax::test_short_conditional_expression #2" {
  jinja(
    source="<{{ (1 if false).bar }}>",
    "{}",
    error="UndefinedError: the inline if-expression on line 1 evaluated to false and no else section was defined.",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_filter_priority" {
  jinja(source="{{ \"foo\"|upper + \"bar\"|upper }}", "{}", output="FOOBAR")
}

///|
test "jinja test_lexnparse TestSyntax::test_constant_casing" {
  jinja(source="{{ True }}|{{ true }}|{{ TRUE }}", "{}", output="True|True|")
}

///|
test "jinja test_lexnparse TestSyntax::test_constant_casing #2" {
  jinja(
    source="{{ False }}|{{ false }}|{{ FALSE }}",
    "{}",
    output="False|False|",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_constant_casing #3" {
  jinja(source="{{ None }}|{{ none }}|{{ NONE }}", "{}", output="None|None|")
}

///|
test "jinja test_lexnparse TestSyntax::test_test_chaining" {
  jinja(source="{{ 42 is string or 42 is number }}", "{}", output="True")
}

///|
test "jinja test_lexnparse TestSyntax::test_string_concatenation" {
  jinja(source="{{ \"foo\" \"bar\" \"baz\" }}", "{}", output="foobarbaz")
}

///|
test "jinja test_lexnparse TestSyntax::test_operator_precedence" {
  jinja(source="{{ 2 * 3 + 4 % 2 + 1 - 2 }}", "{}", output="5")
}

///|
test "jinja test_lexnparse TestSyntax::test_raw2" {
  jinja(
    source="{% raw %}{{ FOO }} and {% BAR %}{% endraw %}",
    "{}",
    output="{{ FOO }} and {% BAR %}",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_const" {
  jinja(
    source="{{ true }}|{{ false }}|{{ none }}|{{ none is defined }}|{{ missing is defined }}",
    "{}",
    output="True|False|None|True|False",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_localset" {
  jinja(
    source="{% set foo = 0 %}{% for item in [1, 2] %}{% set foo = 1 %}{% endfor %}{{ foo }}",
    "{}",
    output="0",
  )
}

///|
test "jinja test_lexnparse TestSyntax::test_parse_unary" {
  jinja(source="{{ -foo[\"bar\"] }}", "{\"foo\": {\"bar\": 42}}", output="-42")
}

///|
test "jinja test_lexnparse TestSyntax::test_parse_unary #2" {
  jinja(
    source="{{ -foo[\"bar\"]|abs }}",
    "{\"foo\": {\"bar\": 42}}",
    output="42",
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip" {
  jinja(
    source="    {% if True %}\n    {% endif %}",
    "{}",
    output="\n",
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip_trim" {
  jinja(
    source="    {% if True %}\n    {% endif %}",
    "{}",
    output="",
    trim_blocks=true,
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_no_lstrip" {
  jinja(
    source="    {%+ if True %}\n    {%+ endif %}",
    "{}",
    output="    \n    ",
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip_blocks_false_with_no_lstrip" {
  jinja(source="    {% if True %}\n    {% endif %}", "{}", output="    \n    ")
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip_blocks_false_with_no_lstrip #2" {
  jinja(
    source="    {%+ if True %}\n    {%+ endif %}",
    "{}",
    output="    \n    ",
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip_endline" {
  jinja(
    source="    hello{% if True %}\n    goodbye{% endif %}",
    "{}",
    output="    hello\n    goodbye",
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip_inline" {
  jinja(
    source="    {% if True %}hello    {% endif %}",
    "{}",
    output="hello    ",
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip_nested" {
  jinja(
    source="    {% if True %}a {% if True %}b {% endif %}c {% endif %}",
    "{}",
    output="a b c ",
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip_left_chars" {
  jinja(
    source="    abc {% if True %}\n        hello{% endif %}",
    "{}",
    output="    abc \n        hello",
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip_embeded_strings" {
  jinja(
    source="    {% set x = \" {% str %} \" %}{{ x }}",
    "{}",
    output=" {% str %} ",
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip_preserve_leading_newlines" {
  jinja(
    source="\n\n\n{% set hello = 1 %}",
    "{}",
    output="\n\n\n",
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip_comment" {
  jinja(
    source="    {# if True #}\nhello\n    {#endif#}",
    "{}",
    output="\nhello\n",
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip_trim_blocks_comment" {
  jinja(
    source=" {# 1 space #}\n  {# 2 spaces #}    {# 4 spaces #}",
    "{}",
    output="    ",
    trim_blocks=true,
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestLstripBlocks::test_lstrip_trim_blocks_raw" {
  jinja(
    source="{{x}}\n{%- raw %} {% endraw -%}\n{{ y }}",
    "{\"x\": 1, \"y\": 2}",
    output="1 2",
    trim_blocks=true,
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_trim" {
  jinja(
    source="    {% if True %}\n    {% endif %}",
    "{}",
    output="        ",
    trim_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_no_trim" {
  jinja(
    source="    {% if True +%}\n    {% endif %}",
    "{}",
    output="    \n    ",
    trim_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_no_trim_outer" {
  jinja(
    source="{% if True %}X{% endif +%}\nmore things",
    "{}",
    output="X\nmore things",
    trim_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_lstrip_no_trim" {
  jinja(
    source="    {% if True +%}\n    {% endif %}",
    "{}",
    output="\n",
    trim_blocks=true,
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_trim_blocks_false_with_no_trim" {
  jinja(source="    {% if True %}\n    {% endif %}", "{}", output="    \n    ")
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_trim_blocks_false_with_no_trim #2" {
  jinja(source="    {% if True +%}\n    {% endif %}", "{}", output="    \n    ")
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_trim_blocks_false_with_no_trim #3" {
  jinja(source="    {# comment #}\n    ", "{}", output="    \n    ")
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_trim_blocks_false_with_no_trim #4" {
  jinja(source="    {# comment +#}\n    ", "{}", output="    \n    ")
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_trim_blocks_false_with_no_trim #5" {
  jinja(source="    {% raw %}{% endraw %}\n    ", "{}", output="    \n    ")
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_trim_blocks_false_with_no_trim #6" {
  jinja(source="    {% raw %}{% endraw +%}\n    ", "{}", output="    \n    ")
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_trim_nested" {
  jinja(
    source="    {% if True %}\na {% if True %}\nb {% endif %}\nc {% endif %}",
    "{}",
    output="a b c ",
    trim_blocks=true,
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_no_trim_nested" {
  jinja(
    source="    {% if True +%}\na {% if True +%}\nb {% endif +%}\nc {% endif %}",
    "{}",
    output="\na \nb \nc ",
    trim_blocks=true,
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_comment_trim" {
  jinja(
    source="    {# comment #}\n\n  ",
    "{}",
    output="\n  ",
    trim_blocks=true,
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_comment_no_trim" {
  jinja(
    source="    {# comment +#}\n\n  ",
    "{}",
    output="\n\n  ",
    trim_blocks=true,
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_multiple_comment_trim_lstrip" {
  jinja(
    source="   {# comment #}\n\n{# comment2 #}\n   \n{# comment3 #}\n\n ",
    "{}",
    output="\n   \n\n ",
    trim_blocks=true,
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_multiple_comment_no_trim_lstrip" {
  jinja(
    source="   {# comment +#}\n\n{# comment2 +#}\n   \n{# comment3 +#}\n\n ",
    "{}",
    output="\n\n\n   \n\n\n ",
    trim_blocks=true,
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_raw_trim_lstrip" {
  jinja(
    source="{{x}}{% raw %}\n\n    {% endraw %}\n\n{{ y }}",
    "{\"x\": 1, \"y\": 2}",
    output="1\n\n\n2",
    trim_blocks=true,
    lstrip_blocks=true,
  )
}

///|
test "jinja test_lexnparse TestTrimBlocks::test_raw_no_trim_lstrip" {
  jinja(
    source="{{x}}{% raw %}\n\n      {% endraw +%}\n\n{{ y }}",
    "{\"x\": 1, \"y\": 2}",
    output="1\n\n\n\n2",
    lstrip_blocks=true,
  )
}

///|
test "jinja test_loader TestLoaders::test_dict_loader" {
  jinja(
    name="justdict.html",
    "{}",
    output="FOO",
    templates="{\"justdict.html\": \"FOO\"}",
  )
}

///|
test "jinja test_loader TestLoaders::test_cache_loader_change" {
  jinja(name="foo", "{}", output="one", templates="{\"foo\": \"one\"}")
}

///|
test "jinja test_loader TestLoaders::test_cache_loader_change #2" {
  jinja(name="foo", "{}", output="two", templates="{\"foo\": \"two\"}")
}

///|
test "jinja test_loader TestLoaders::test_dict_loader_cache_invalidates" {
  jinja(name="foo", "{}", output="one", templates="{\"foo\": \"one\"}")
}

///|
test "jinja test_loader TestLoaders::test_dict_loader_cache_invalidates #2" {
  jinja(name="foo", "{}", output="two", templates="{\"foo\": \"two\"}")
}

///|
test "jinja test_pickle test_environment" {
  jinja(source="x={{ x }}", "{\"x\": 42}", output="x=42")
}

///|
test "jinja test_regression TestCorner::test_assigned_scoping" {
  jinja(
    source="\n        {%- for item in (1, 2, 3, 4) -%}\n            [{{ item }}]\n        {%- endfor %}\n        {{- item -}}\n        ",
    "{\"item\": 42}",
    output="[1][2][3][4]42",
  )
}

///|
test "jinja test_regression TestCorner::test_assigned_scoping #2" {
  jinja(
    source="\n        {%- for item in (1, 2, 3, 4) -%}\n            [{{ item }}]\n        {%- endfor %}\n        {%- set item = 42 %}\n        {{- item -}}\n        ",
    "{}",
    output="[1][2][3][4]42",
  )
}

///|
test "jinja test_regression TestCorner::test_assigned_scoping #3" {
  jinja(
    source="\n        {%- set item = 42 %}\n        {%- for item in (1, 2, 3, 4) -%}\n            [{{ item }}]\n        {%- endfor %}\n        {{- item -}}\n        ",
    "{}",
    output="[1][2][3][4]42",
  )
}

///|
test "jinja test_regression TestCorner::test_closure_scoping" {
  jinja(
    source="\n        {%- set wrapper = \"<FOO>\" %}\n        {%- for item in (1, 2, 3, 4) %}\n            {%- macro wrapper() %}[{{ item }}]{% endmacro %}\n            {{- wrapper() }}\n        {%- endfor %}\n        {{- wrapper -}}\n        ",
    "{}",
    output="[1][2][3][4]<FOO>",
  )
}

///|
test "jinja test_regression TestCorner::test_closure_scoping #2" {
  jinja(
    source="\n        {%- for item in (1, 2, 3, 4) %}\n            {%- macro wrapper() %}[{{ item }}]{% endmacro %}\n            {{- wrapper() }}\n        {%- endfor %}\n        {%- set wrapper = \"<FOO>\" %}\n        {{- wrapper -}}\n        ",
    "{}",
    output="[1][2][3][4]<FOO>",
  )
}

///|
test "jinja test_regression TestCorner::test_closure_scoping #3" {
  jinja(
    source="\n        {%- for item in (1, 2, 3, 4) %}\n            {%- macro wrapper() %}[{{ item }}]{% endmacro %}\n            {{- wrapper() }}\n        {%- endfor %}\n        {{- wrapper -}}\n        ",
    "{\"wrapper\": 23}",
    output="[1][2][3][4]23",
  )
}

///|
test "jinja test_regression TestBug::test_extends_output_bugs" {
  jinja(
    source="{% if expr %}{% extends \"parent.html\" %}{% endif %}[[{% block title %}title{% endblock %}]]{% for item in [1, 2, 3] %}({{ item }}){% endfor %}",
    "{\"expr\": false}",
    output="[[title]](1)(2)(3)",
    templates="{\"parent.html\": \"(({% block title %}{% endblock %}))\"}",
  )
}

///|
test "jinja test_regression TestBug::test_extends_output_bugs #2" {
  jinja(
    source="{% if expr %}{% extends \"parent.html\" %}{% endif %}[[{% block title %}title{% endblock %}]]{% for item in [1, 2, 3] %}({{ item }}){% endfor %}",
    "{\"expr\": true}",
    output="((title))",
    templates="{\"parent.html\": \"(({% block title %}{% endblock %}))\"}",
  )
}

///|
test "jinja test_regression TestBug::test_urlize_filter_escaping" {
  jinja(
    source="{{ \"http://www.example.org/<foo\"|urlize }}",
    "{}",
    output="<a href=\"http://www.example.org/&lt;foo\" rel=\"noopener\">http://www.example.org/&lt;foo</a>",
  )
}

///|
test "jinja test_regression TestBug::test_urlize_filter_closing_punctuation" {
  jinja(
    source="{{ \"(see http://www.example.org/?page=subj_<desc.h>)\"|urlize }}",
    "{}",
    output="(see <a href=\"http://www.example.org/?page=subj_&lt;desc.h&gt;\" rel=\"noopener\">http://www.example.org/?page=subj_&lt;desc.h&gt;</a>)",
  )
}

///|
test "jinja test_regression TestBug::test_loop_call_loop" {
  jinja(
    source="\n\n        {% macro test() %}\n            {{ caller() }}\n        {% endmacro %}\n\n        {% for num1 in range(5) %}\n            {% call test() %}\n                {% for num2 in range(10) %}\n                    {{ loop.index }}\n                {% endfor %}\n            {% endcall %}\n        {% endfor %}\n\n        ",
    "{}",
    output="\n\n        \n\n        \n            \n            \n                \n                    1\n                \n                    2\n                \n                    3\n                \n                    4\n                \n                    5\n                \n                    6\n                \n                    7\n                \n                    8\n                \n                    9\n                \n                    10\n                \n            \n        \n        \n            \n            \n                \n                    1\n                \n                    2\n                \n                    3\n                \n                    4\n                \n                    5\n                \n                    6\n                \n                    7\n                \n                    8\n                \n                    9\n                \n                    10\n                \n            \n        \n        \n            \n            \n                \n                    1\n                \n                    2\n                \n                    3\n                \n                    4\n                \n                    5\n                \n                    6\n                \n                    7\n                \n                    8\n                \n                    9\n                \n                    10\n                \n            \n        \n        \n            \n            \n                \n                    1\n                \n                    2\n                \n                    3\n                \n                    4\n                \n                    5\n                \n                    6\n                \n                    7\n                \n                    8\n                \n                    9\n                \n                    10\n                \n            \n        \n        \n            \n            \n                \n                    1\n                \n                    2\n                \n                    3\n                \n                    4\n                \n                    5\n                \n                    6\n                \n                    7\n                \n                    8\n                \n                    9\n                \n                    10\n                \n            \n        \n        \n\n        ",
  )
}

///|
test "jinja test_regression TestBug::test_old_macro_loop_scoping_bug" {
  jinja(
    source="{% for i in (1, 2) %}{{ i }}{% endfor %}{% macro i() %}3{% endmacro %}{{ i() }}",
    "{}",
    output="123",
  )
}

///|
test "jinja test_regression TestBug::test_partial_conditional_assignments" {
  jinja(
    source="{% if b %}{% set a = 42 %}{% endif %}{{ a }}",
    "{\"a\": 23}",
    output="23",
  )
}

///|
test "jinja test_regression TestBug::test_partial_conditional_assignments #2" {
  jinja(
    source="{% if b %}{% set a = 42 %}{% endif %}{{ a }}",
    "{\"b\": true}",
    output="42",
  )
}

///|
test "jinja test_regression TestBug::test_stacked_locals_scoping_bug" {
  jinja(
    source="# for j in [1, 2]:\n#   set x = 1\n#   for i in [1, 2]:\n#     print x\n#     if i % 2 == 0:\n#       set x = x + 1\n#     endif\n#   endfor\n# endfor\n# if a\n#   print 'A'\n# elif b\n#   print 'B'\n# elif c == d\n#   print 'C'\n# else\n#   print 'D'\n# endif\n    ",
    "{\"a\": 0, \"b\": false, \"c\": 42, \"d\": 42.0}",
    output="1111C",
    line_statement="#",
  )
}

///|
test "jinja test_regression TestBug::test_stacked_locals_scoping_bug_twoframe" {
  jinja(
    source="\n            {% set x = 1 %}\n            {% for item in foo %}\n                {% if item == 1 %}\n                    {% set x = 2 %}\n                {% endif %}\n            {% endfor %}\n            {{ x }}\n        ",
    "{\"foo\": [1]}",
    output="\n            \n            \n                \n                    \n                \n            \n            1\n        ",
  )
}

///|
test "jinja test_regression TestBug::test_call_with_args" {
  jinja(
    source="{% macro dump_users(users) -%}\n        <ul>\n          {%- for user in users -%}\n            <li><p>{{ user.username|e }}</p>{{ caller(user) }}</li>\n          {%- endfor -%}\n          </ul>\n        {%- endmacro -%}\n\n        {% call(user) dump_users(list_of_user) -%}\n          <dl>\n            <dl>Realname</dl>\n            <dd>{{ user.realname|e }}</dd>\n            <dl>Description</dl>\n            <dd>{{ user.description }}</dd>\n          </dl>\n        {% endcall %}",
    "{\"list_of_user\": [{\"username\": \"apo\", \"realname\": \"something else\", \"description\": \"test\"}]}",
    output="<ul><li><p>apo</p><dl>\n            <dl>Realname</dl>\n            <dd>something else</dd>\n            <dl>Description</dl>\n            <dd>test</dd>\n          </dl>\n        </li></ul>",
  )
}

///|
test "jinja test_regression TestBug::test_else_loop_bug" {
  jinja(
    source="\n            {% for x in y %}\n                {{ loop.index0 }}\n            {% else %}\n                {% for i in range(3) %}{{ i }}{% endfor %}\n            {% endfor %}\n        ",
    "{\"y\": []}",
    output="\n            \n                012\n            \n        ",
  )
}

///|
test "jinja test_regression TestBug::test_block_set_with_extends" {
  jinja(
    source="{% extends \"main\" %}{% set x %}42{% endset %}",
    "{}",
    output="[42]",
    templates="{\"main\": \"{% block body %}[{{ x }}]{% endblock %}\"}",
  )
}

///|
test "jinja test_regression TestBug::test_nested_for_else" {
  jinja(
    source="{% for x in y %}{{ loop.index0 }}{% else %}{% for i in range(3) %}{{ i }}{% endfor %}{% endfor %}",
    "{}",
    output="012",
  )
}

///|
test "jinja test_regression TestBug::test_macro_var_bug" {
  jinja(
    source="\n        {% set i = 1 %}\n        {% macro test() %}\n            {% for i in range(0, 10) %}{{ i }}{% endfor %}\n        {% endmacro %}{{ test() }}\n        ",
    "{}",
    output="\n        \n        \n            0123456789\n        \n        ",
  )
}

///|
test "jinja test_regression TestBug::test_macro_var_bug_advanced" {
  jinja(
    source="\n        {% macro outer() %}\n            {% set i = 1 %}\n            {% macro test() %}\n                {% for i in range(0, 10) %}{{ i }}{% endfor %}\n            {% endmacro %}{{ test() }}\n        {% endmacro %}{{ outer() }}\n        ",
    "{}",
    output="\n        \n            \n            \n                0123456789\n            \n        \n        ",
  )
}

///|
test "jinja test_regression TestBug::test_macro_scoping" {
  jinja(
    source="\n        {% set n=[1,2,3,4,5] %}\n        {% for n in [[1,2,3], [3,4,5], [5,6,7]] %}\n\n        {% macro x(l) %}\n          {{ l.pop() }}\n          {% if l %}{{ x(l) }}{% endif %}\n        {% endmacro %}\n\n        {{ x(n) }}\n\n        {% endfor %}\n        ",
    "{}",
    output="\n        \n        \n\n        \n\n        \n          3\n          \n          2\n          \n          1\n          \n        \n        \n        \n\n        \n\n        \n\n        \n          5\n          \n          4\n          \n          3\n          \n        \n        \n        \n\n        \n\n        \n\n        \n          7\n          \n          6\n          \n          5\n          \n        \n        \n        \n\n        \n        ",
  )
}

///|
test "jinja test_regression TestBug::test_scopes_and_blocks" {
  jinja(
    name="a.html",
    "{\"test\": \"x\"}",
    output="bar|x",
    templates="{\"a.html\": \"\\n                {%- set foo = 'bar' -%}\\n                {% include 'x.html' -%}\\n            \", \"b.html\": \"\\n                {%- set foo = 'bar' -%}\\n                {% block test %}{% include 'x.html' %}{% endblock -%}\\n                \", \"c.html\": \"\\n                {%- set foo = 'bar' -%}\\n                {% block test %}{% set foo = foo\\n                    %}{% include 'x.html' %}{% endblock -%}\\n            \", \"x.html\": \"{{ foo }}|{{ test }}\"}",
  )
}

///|
test "jinja test_regression TestBug::test_scopes_and_blocks #2" {
  jinja(
    name="b.html",
    "{\"test\": \"x\"}",
    output="bar|x",
    templates="{\"a.html\": \"\\n                {%- set foo = 'bar' -%}\\n                {% include 'x.html' -%}\\n            \", \"b.html\": \"\\n                {%- set foo = 'bar' -%}\\n                {% block test %}{% include 'x.html' %}{% endblock -%}\\n                \", \"c.html\": \"\\n                {%- set foo = 'bar' -%}\\n                {% block test %}{% set foo = foo\\n                    %}{% include 'x.html' %}{% endblock -%}\\n            \", \"x.html\": \"{{ foo }}|{{ test }}\"}",
  )
}

///|
test "jinja test_regression TestBug::test_scopes_and_blocks #3" {
  jinja(
    name="c.html",
    "{\"test\": \"x\"}",
    output="bar|x",
    templates="{\"a.html\": \"\\n                {%- set foo = 'bar' -%}\\n                {% include 'x.html' -%}\\n            \", \"b.html\": \"\\n                {%- set foo = 'bar' -%}\\n                {% block test %}{% include 'x.html' %}{% endblock -%}\\n                \", \"c.html\": \"\\n                {%- set foo = 'bar' -%}\\n                {% block test %}{% set foo = foo\\n                    %}{% include 'x.html' %}{% endblock -%}\\n            \", \"x.html\": \"{{ foo }}|{{ test }}\"}",
  )
}

///|
test "jinja test_regression TestBug::test_scopes_and_include" {
  jinja(
    name="child.html",
    "{}",
    output="42",
    templates="{\"include.html\": \"{{ var }}\", \"base.html\": \"{% include \\\"include.html\\\" %}\", \"child.html\": \"{% extends \\\"base.html\\\" %}{% set var = 42 %}\"}",
  )
}

///|
test "jinja test_regression TestBug::test_variable_reuse" {
  jinja(
    source="{% for x in x.y %}{{ x }}{% endfor %}",
    "{\"x\": {\"y\": [0, 1, 2]}}",
    output="012",
  )
}

///|
test "jinja test_regression TestBug::test_variable_reuse #2" {
  jinja(
    source="{% for x in x.y %}{{ loop.index0 }}|{{ x }}{% endfor %}",
    "{\"x\": {\"y\": [0, 1, 2]}}",
    output="0|01|12|2",
  )
}

///|
test "jinja test_regression TestBug::test_variable_reuse #3" {
  jinja(
    source="{% for x in x.y recursive %}{{ x }}{% endfor %}",
    "{\"x\": {\"y\": [0, 1, 2]}}",
    output="012",
  )
}

///|
test "jinja test_regression TestBug::test_double_caller" {
  jinja(
    source="{% macro x(caller=none) %}[{% if caller %}{{ caller() }}{% endif %}]{% endmacro %}{{ x() }}{% call x() %}aha!{% endcall %}",
    "{}",
    output="[][aha!]",
  )
}

///|
test "jinja test_regression TestBug::test_macro_blocks" {
  jinja(
    source="{% macro x() %}{% block foo %}x{% endblock %}{% endmacro %}{{ x() }}",
    "{}",
    output="x",
  )
}

///|
test "jinja test_regression TestBug::test_scoped_block" {
  jinja(
    source="{% set x = 1 %}{% with x = 2 %}{% block y scoped %}{{ x }}{% endblock %}{% endwith %}",
    "{}",
    output="2",
  )
}

///|
test "jinja test_regression TestBug::test_recursive_loop_filter" {
  jinja(
    source="\n        <?xml version=\"1.0\" encoding=\"UTF-8\"?>\n        <urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n          {%- for page in [site.root] if page.url != this recursive %}\n          <url><loc>{{ page.url }}</loc></url>\n          {{- loop(page.children) }}\n          {%- endfor %}\n        </urlset>\n        ",
    "{\"this\": \"/foo\", \"site\": {\"root\": {\"url\": \"/\", \"children\": [{\"url\": \"/foo\"}, {\"url\": \"/bar\"}]}}}",
    output="\n        <?xml version=\"1.0\" encoding=\"UTF-8\"?>\n        <urlset xmlns=\"http://www.sitemaps.org/schemas/sitemap/0.9\">\n          <url><loc>/</loc></url>\n          <url><loc>/bar</loc></url>\n        </urlset>\n        ",
  )
}

///|
test "jinja test_regression TestBug::test_empty_if" {
  jinja(
    source="{% if foo %}{% else %}42{% endif %}",
    "{\"foo\": false}",
    output="42",
  )
}

///|
test "jinja test_regression TestBug::test_subproperty_if" {
  jinja(
    source="{% if object1.subproperty1 is eq object2.subproperty2 %}42{% endif %}",
    "{\"object1\": {\"subproperty1\": \"value\"}, \"object2\": {\"subproperty2\": \"value\"}}",
    output="42",
  )
}

///|
test "jinja test_regression TestBug::test_set_and_include" {
  jinja(
    name="main",
    "{}",
    output="foobar",
    templates="{\"inc\": \"bar\", \"main\": \"{% set foo = \\\"foo\\\" %}{{ foo }}{% include \\\"inc\\\" %}\"}",
  )
}

///|
test "jinja test_regression TestBug::test_loop_include" {
  jinja(
    name="main",
    "{}",
    output="123",
    templates="{\"inc\": \"{{ i }}\", \"main\": \"{% for i in [1, 2, 3] %}{% include \\\"inc\\\" %}{% endfor %}\"}",
  )
}

///|
test "jinja test_regression TestBug::test_recursive_loop_bug" {
  jinja(
    source="{%- for value in values recursive %}1{% else %}0{% endfor -%}",
    "{\"values\": []}",
    output="0",
  )
}

///|
test "jinja test_regression TestBug::test_scoped_block_loop_vars" {
  jinja(
    source="Start\n{% for i in [\"foo\", \"bar\"] -%}\n{% block body scoped -%}\n{{ loop.index }}) {{ i }}{% if loop.last %} last{% endif -%}\n{%- endblock %}\n{% endfor -%}\nEnd",
    "{}",
    output="Start\n1) foo\n2) bar last\nEnd",
  )
}

///|
test "jinja test_regression TestBug::test_cached_extends[extends]" {
  jinja(
    name="base",
    "{}",
    output="x y",
    templates="{\"base\": \"{{ x }} {{ y }}\", \"main\": \"{% extends 'base' %}\"}",
    globals="{\"x\": \"x\", \"y\": \"y\"}",
  )
}

///|
test "jinja test_regression TestBug::test_cached_extends[include]" {
  jinja(
    name="base",
    "{}",
    output="x y",
    templates="{\"base\": \"{{ x }} {{ y }}\", \"main\": \"{% include 'base' %}\"}",
    globals="{\"x\": \"x\", \"y\": \"y\"}",
  )
}

///|
test "jinja test_regression TestBug::test_nested_loop_scoping" {
  jinja(
    source="{% set output %}{% for x in [1,2,3] %}hello{% endfor %}{% endset %}{{ output }}",
    "{}",
    output="hellohellohello",
  )
}

///|
test "jinja test_regression test_load_parameter_when_set_in_all_if_branches" {
  jinja(
    source="{% if True %}{{ a.b }}{% set a = 1 %}{% elif False %}{% set a = 2 %}{% else %}{% set a = 3 %}{% endif %}{{ a }}",
    "{\"a\": {\"b\": 0}}",
    output="01",
  )
}

///|
test "jinja test_regression test_unicode_whitespace[\\x0c]" {
  jinja(
    source="Lorem ipsum\n\u{c}\nMore text",
    "{}",
    output="Lorem ipsum\n\u{c}\nMore text",
  )
}

///|
test "jinja test_regression test_unicode_whitespace[\\x85]" {
  jinja(
    source="Lorem ipsum\n\nMore text",
    "{}",
    output="Lorem ipsum\n\nMore text",
  )
}

///|
test "jinja test_runtime test_loop_idx" {
  jinja(
    source="[{% for i in lst|reverse %}(len={{ loop.length }}, revindex={{ loop.revindex }}, index={{ loop.index }}, val={{ i }}){% endfor %}]",
    "{\"lst\": [10]}",
    output="[(len=1, revindex=1, index=1, val=10)]",
  )
}

///|
test "jinja test_runtime test_loop_idx0" {
  jinja(
    source="[{% for i in lst|reverse %}(len={{ loop.length }}, revindex0={{ loop.revindex0 }}, index0={{ loop.index0 }}, val={{ i }}){% endfor %}]",
    "{\"lst\": [10]}",
    output="[(len=1, revindex0=0, index0=0, val=10)]",
  )
}

///|
test "jinja test_security TestSandbox::test_template_data" {
  jinja(
    source="{% macro say_hello(name) %}<p>Hello {{ name }}!</p>{% endmacro %}{{ say_hello(\"<blink>foo</blink>\") }}",
    "{}",
    output="<p>Hello &lt;blink&gt;foo&lt;/blink&gt;!</p>",
    autoescape=true,
  )
}

///|
test "jinja test_tests TestTestsCase::test_defined" {
  jinja(
    source="{{ missing is defined }}|{{ true is defined }}",
    "{}",
    output="False|True",
  )
}

///|
test "jinja test_tests TestTestsCase::test_even" {
  jinja(source="{{ 1 is even }}|{{ 2 is even }}", "{}", output="False|True")
}

///|
test "jinja test_tests TestTestsCase::test_odd" {
  jinja(source="{{ 1 is odd }}|{{ 2 is odd }}", "{}", output="True|False")
}

///|
test "jinja test_tests TestTestsCase::test_lower" {
  jinja(
    source="{{ \"foo\" is lower }}|{{ \"FOO\" is lower }}",
    "{}",
    output="True|False",
  )
}

///|
test "jinja test_tests TestTestsCase::test_upper" {
  jinja(
    source="{{ \"FOO\" is upper }}|{{ \"foo\" is upper }}",
    "{}",
    output="True|False",
  )
}

///|
test "jinja test_tests TestTestsCase::test_equalto" {
  jinja(
    source="{{ foo is eq 12 }}|{{ foo is eq 0 }}|{{ foo is eq (3 * 4) }}|{{ bar is eq \"baz\" }}|{{ bar is eq \"zab\" }}|{{ bar is eq (\"ba\" + \"z\") }}|{{ bar is eq bar }}|{{ bar is eq foo }}",
    "{\"foo\": 12, \"bar\": \"baz\"}",
    output="True|False|True|True|False|True|True|False",
  )
}

///|
test "jinja test_tests TestTestsCase::test_compare_aliases[eq 2-True]" {
  jinja(source="{{ 2 is eq 2 }}", "{}", output="True")
}

///|
test "jinja test_tests TestTestsCase::test_compare_aliases[eq 3-False]" {
  jinja(source="{{ 2 is eq 3 }}", "{}", output="False")
}

///|
test "jinja test_tests TestTestsCase::test_compare_aliases[ne 3-True]" {
  jinja(source="{{ 2 is ne 3 }}", "{}", output="True")
}

///|
test "jinja test_tests TestTestsCase::test_compare_aliases[ne 2-False]" {
  jinja(source="{{ 2 is ne 2 }}", "{}", output="False")
}

///|
test "jinja test_tests TestTestsCase::test_compare_aliases[lt 3-True]" {
  jinja(source="{{ 2 is lt 3 }}", "{}", output="True")
}

///|
test "jinja test_tests TestTestsCase::test_compare_aliases[lt 2-False]" {
  jinja(source="{{ 2 is lt 2 }}", "{}", output="False")
}

///|
test "jinja test_tests TestTestsCase::test_compare_aliases[le 2-True]" {
  jinja(source="{{ 2 is le 2 }}", "{}", output="True")
}

///|
test "jinja test_tests TestTestsCase::test_compare_aliases[le 1-False]" {
  jinja(source="{{ 2 is le 1 }}", "{}", output="False")
}

///|
test "jinja test_tests TestTestsCase::test_compare_aliases[gt 1-True]" {
  jinja(source="{{ 2 is gt 1 }}", "{}", output="True")
}

///|
test "jinja test_tests TestTestsCase::test_compare_aliases[gt 2-False]" {
  jinja(source="{{ 2 is gt 2 }}", "{}", output="False")
}

///|
test "jinja test_tests TestTestsCase::test_compare_aliases[ge 2-True]" {
  jinja(source="{{ 2 is ge 2 }}", "{}", output="True")
}

///|
test "jinja test_tests TestTestsCase::test_compare_aliases[ge 3-False]" {
  jinja(source="{{ 2 is ge 3 }}", "{}", output="False")
}

///|
test "jinja test_tests TestTestsCase::test_sameas" {
  jinja(
    source="{{ foo is sameas false }}|{{ 0 is sameas false }}",
    "{\"foo\": false}",
    output="True|False",
  )
}

///|
test "jinja test_tests TestTestsCase::test_no_paren_for_arg1" {
  jinja(source="{{ foo is sameas none }}", "{\"foo\": null}", output="True")
}

///|
test "jinja test_tests TestTestsCase::test_greaterthan" {
  jinja(
    source="{{ 1 is greaterthan 0 }}|{{ 0 is greaterthan 1 }}",
    "{}",
    output="True|False",
  )
}

///|
test "jinja test_tests TestTestsCase::test_lessthan" {
  jinja(
    source="{{ 0 is lessthan 1 }}|{{ 1 is lessthan 0 }}",
    "{}",
    output="True|False",
  )
}

///|
test "jinja test_tests TestTestsCase::test_in" {
  jinja(
    source="{{ \"o\" is in \"foo\" }}|{{ \"foo\" is in \"foo\" }}|{{ \"b\" is in \"foo\" }}|{{ 1 is in ((1, 2)) }}|{{ 3 is in ((1, 2)) }}|{{ 1 is in [1, 2] }}|{{ 3 is in [1, 2] }}|{{ \"foo\" is in {\"foo\": 1}}}|{{ \"baz\" is in {\"bar\": 1}}}",
    "{}",
    output="True|True|False|True|False|True|False|True|False",
  )
}

///|
test "jinja test_tests test_name_undefined_in_if" {
  jinja(source="{% if x is defined %}{{ x is f }}{% endif %}", "{}", output="")
}

///|
test "jinja test_tests test_name_undefined_in_if #2" {
  jinja(
    source="{% if x is defined %}{{ x is f }}{% endif %}",
    "{\"x\": 1}",
    error="TemplateRuntimeError: No test named 'f' found.",
  )
}
