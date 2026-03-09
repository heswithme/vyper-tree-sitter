[
  "def"
  "struct"
  "interface"
  "event"
  "flag"
  "if"
  "elif"
  "else"
  "for"
  "in"
  "return"
  "assert"
  "pass"
  "import"
  "from"
  "as"
] @keyword

(comment) @comment
(string) @string
(integer) @number
(boolean) @constant.builtin

(decorator
  name: (identifier) @attribute)

(function_signature
  name: (identifier) @function)

(struct_declaration
  name: (identifier) @type)

(interface_declaration
  name: (identifier) @type)

(event_declaration
  name: (identifier) @type)

(flag_declaration
  name: (identifier) @type)
