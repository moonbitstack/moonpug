///|
test "i18n #0 escaped" {
  i18n(
    "{% trans %}Hello{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hallo",
    autoescape=true,
  )
}

///|
test "i18n #0" {
  i18n(
    "{% trans %}Hello{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hallo",
  )
}

///|
test "i18n #1 escaped" {
  i18n(
    "{% trans %}Unknown{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Unknown",
    autoescape=true,
  )
}

///|
test "i18n #1" {
  i18n(
    "{% trans %}Unknown{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Unknown",
  )
}

///|
test "i18n #2 escaped" {
  i18n(
    "{% trans user=name %}Hello {{ user }}!{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hallo Ann!",
    autoescape=true,
  )
}

///|
test "i18n #2" {
  i18n(
    "{% trans user=name %}Hello {{ user }}!{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hallo Ann!",
  )
}

///|
test "i18n #3 escaped" {
  i18n(
    "{% trans %}Hello {{ name }}!{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hello Ann!",
    autoescape=true,
  )
}

///|
test "i18n #3" {
  i18n(
    "{% trans %}Hello {{ name }}!{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hello Ann!",
  )
}

///|
test "i18n #4 escaped" {
  i18n(
    "{% trans count=n %}{{ count }} item{% pluralize %}{{ count }} items{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="3 Dinge",
    autoescape=true,
  )
}

///|
test "i18n #4" {
  i18n(
    "{% trans count=n %}{{ count }} item{% pluralize %}{{ count }} items{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="3 Dinge",
  )
}

///|
test "i18n #5 escaped" {
  i18n(
    "{% trans num=n %}{{ num }} apple{% pluralize %}{{ num }} apples{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="3 apples",
    autoescape=true,
  )
}

///|
test "i18n #5" {
  i18n(
    "{% trans num=n %}{{ num }} apple{% pluralize %}{{ num }} apples{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="3 apples",
  )
}

///|
test "i18n #6 escaped" {
  i18n(
    "{% trans num=n %}{{ num }} apple{% pluralize num %}{{ num }} apples{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="3 apples",
    autoescape=true,
  )
}

///|
test "i18n #6" {
  i18n(
    "{% trans num=n %}{{ num }} apple{% pluralize num %}{{ num }} apples{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="3 apples",
  )
}

///|
test "i18n #7 escaped" {
  i18n(
    "{% trans num=one %}{{ num }} apple{% pluralize %}{{ num }} apples{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="1 apple",
    autoescape=true,
  )
}

///|
test "i18n #7" {
  i18n(
    "{% trans num=one %}{{ num }} apple{% pluralize %}{{ num }} apples{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="1 apple",
  )
}

///|
test "i18n #8 escaped" {
  i18n(
    "{% trans %}Bye{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Tschüss <b>",
    autoescape=true,
  )
}

///|
test "i18n #8" {
  i18n(
    "{% trans %}Bye{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Tschüss <b>",
  )
}

///|
test "i18n #9 escaped" {
  i18n(
    "{% trans %}{{ html }} and more{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="&lt;i&gt;x&lt;/i&gt; and more",
    autoescape=true,
  )
}

///|
test "i18n #9" {
  i18n(
    "{% trans %}{{ html }} and more{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="<i>x</i> and more",
  )
}

///|
test "i18n #10 escaped" {
  i18n(
    "{% trans x=html %}{{ x }}!{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="&lt;i&gt;x&lt;/i&gt;!",
    autoescape=true,
  )
}

///|
test "i18n #10" {
  i18n(
    "{% trans x=html %}{{ x }}!{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="<i>x</i>!",
  )
}

///|
test "i18n #11 escaped" {
  i18n(
    "{% trans \"menu\" %}Open{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Öffnen",
    autoescape=true,
  )
}

///|
test "i18n #11" {
  i18n(
    "{% trans \"menu\" %}Open{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Öffnen",
  )
}

///|
test "i18n #12 escaped" {
  i18n(
    "{% trans \"shop\" num=n %}{{ num }} box{% pluralize %}{{ num }} boxes{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="3 boxes",
    autoescape=true,
  )
}

///|
test "i18n #12" {
  i18n(
    "{% trans \"shop\" num=n %}{{ num }} box{% pluralize %}{{ num }} boxes{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="3 boxes",
  )
}

///|
test "i18n #13 escaped" {
  i18n(
    "{% trans trimmed %}\n  Hello\n    {{ name }}!\n{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hello Ann!",
    autoescape=true,
  )
}

///|
test "i18n #13" {
  i18n(
    "{% trans trimmed %}\n  Hello\n    {{ name }}!\n{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hello Ann!",
  )
}

///|
test "i18n #14 escaped" {
  i18n(
    "{% trans notrimmed %}\n  spaced  {% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="\n  spaced  ",
    autoescape=true,
  )
}

///|
test "i18n #14" {
  i18n(
    "{% trans notrimmed %}\n  spaced  {% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="\n  spaced  ",
  )
}

///|
test "i18n #15 escaped" {
  i18n(
    "{% trans %}100%% sure{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="100%% sure",
    autoescape=true,
  )
}

///|
test "i18n #15" {
  i18n(
    "{% trans %}100%% sure{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="100%% sure",
  )
}

///|
test "i18n #16 escaped" {
  i18n(
    "{% trans a=1, b=2 %}{{ a }} and {{ b }}{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="1 and 2",
    autoescape=true,
  )
}

///|
test "i18n #16" {
  i18n(
    "{% trans a=1, b=2 %}{{ a }} and {{ b }}{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="1 and 2",
  )
}

///|
test "i18n #17 escaped" {
  i18n(
    "{{ _('Hello') }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hallo",
    autoescape=true,
  )
}

///|
test "i18n #17" {
  i18n(
    "{{ _('Hello') }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hallo",
  )
}

///|
test "i18n #18 escaped" {
  i18n(
    "{{ gettext('Hello %(user)s!', user=name) }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hallo Ann!",
    autoescape=true,
  )
}

///|
test "i18n #18" {
  i18n(
    "{{ gettext('Hello %(user)s!', user=name) }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hallo Ann!",
  )
}

///|
test "i18n #19 escaped" {
  i18n(
    "{{ gettext('Hello %(user)s!', user=html) }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hallo &lt;i&gt;x&lt;/i&gt;!",
    autoescape=true,
  )
}

///|
test "i18n #19" {
  i18n(
    "{{ gettext('Hello %(user)s!', user=html) }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hallo <i>x</i>!",
  )
}

///|
test "i18n #20 escaped" {
  i18n(
    "{{ ngettext('%(num)d apple', '%(num)d apples', n) }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="3 Äpfel",
    autoescape=true,
  )
}

///|
test "i18n #20" {
  i18n(
    "{{ ngettext('%(num)d apple', '%(num)d apples', n) }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="3 Äpfel",
  )
}

///|
test "i18n #21 escaped" {
  i18n(
    "{{ ngettext('%(num)d apple', '%(num)d apples', one) }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="1 Apfel",
    autoescape=true,
  )
}

///|
test "i18n #21" {
  i18n(
    "{{ ngettext('%(num)d apple', '%(num)d apples', one) }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="1 Apfel",
  )
}

///|
test "i18n #22 escaped" {
  i18n(
    "{{ ngettext('x', 'xs', 2) }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="xs",
    autoescape=true,
  )
}

///|
test "i18n #22" {
  i18n(
    "{{ ngettext('x', 'xs', 2) }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="xs",
  )
}

///|
test "i18n #23 escaped" {
  i18n(
    "{{ pgettext('menu', 'Open') }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Öffnen",
    autoescape=true,
  )
}

///|
test "i18n #23" {
  i18n(
    "{{ pgettext('menu', 'Open') }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Öffnen",
  )
}

///|
test "i18n #24 escaped" {
  i18n(
    "{{ pgettext('menu', 'Close') }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Close",
    autoescape=true,
  )
}

///|
test "i18n #24" {
  i18n(
    "{{ pgettext('menu', 'Close') }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Close",
  )
}

///|
test "i18n #25 escaped" {
  i18n(
    "{{ npgettext('shop', '%(num)d box', '%(num)d boxes', n) }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="3 Kisten",
    autoescape=true,
  )
}

///|
test "i18n #25" {
  i18n(
    "{{ npgettext('shop', '%(num)d box', '%(num)d boxes', n) }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="3 Kisten",
  )
}

///|
test "i18n #26 escaped" {
  i18n(
    "{{ gettext('Bye') }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Tschüss <b>",
    autoescape=true,
  )
}

///|
test "i18n #26" {
  i18n(
    "{{ gettext('Bye') }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Tschüss <b>",
  )
}

///|
test "i18n #27 escaped" {
  i18n(
    "{{ _('50%% off') }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="50% off",
    autoescape=true,
  )
}

///|
test "i18n #27" {
  i18n(
    "{{ _('50%% off') }}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="50% off",
  )
}

///|
test "i18n #28 escaped" {
  i18n(
    "{% trans %}a{% pluralize %}b{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    error="TemplateSyntaxError: pluralize without variables",
    autoescape=true,
  )
}

///|
test "i18n #28" {
  i18n(
    "{% trans %}a{% pluralize %}b{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    error="TemplateSyntaxError: pluralize without variables",
  )
}

///|
test "i18n #29 escaped" {
  i18n(
    "{% trans count=n %}{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="",
    autoescape=true,
  )
}

///|
test "i18n #29" {
  i18n(
    "{% trans count=n %}{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="",
  )
}

///|
test "i18n #30 escaped" {
  i18n(
    "{% trans %}{% trans %}{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    error="TemplateSyntaxError: trans blocks can't be nested; did you mean `endtrans`?",
    autoescape=true,
  )
}

///|
test "i18n #30" {
  i18n(
    "{% trans %}{% trans %}{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    error="TemplateSyntaxError: trans blocks can't be nested; did you mean `endtrans`?",
  )
}

///|
test "i18n #31 escaped" {
  i18n(
    "{% trans %}{{ name|upper }}{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    error="TemplateSyntaxError: expected token 'end of print statement', got '|'",
    autoescape=true,
  )
}

///|
test "i18n #31" {
  i18n(
    "{% trans %}{{ name|upper }}{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    error="TemplateSyntaxError: expected token 'end of print statement', got '|'",
  )
}

///|
test "i18n #32 escaped" {
  i18n(
    "{% trans user=name|upper %}Hello {{ user }}!{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hallo ANN!",
    autoescape=true,
  )
}

///|
test "i18n #32" {
  i18n(
    "{% trans user=name|upper %}Hello {{ user }}!{% endtrans %}",
    "{\"name\": \"Ann\", \"n\": 3, \"one\": 1, \"html\": \"<i>x</i>\"}",
    output="Hallo ANN!",
  )
}
