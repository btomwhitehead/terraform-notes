# Syntax

## HCL configuration syntax

### Arguments

An argument assigns an argument value to a particular argument name:
```
image_id = "abc123"
```

### Blocks

A block is a container for other content:
```
block_type "label_1" ... "label_n" {
  argument_name_1 = argument_value_1

  another_block {
    # ...
  }
}
```
- A block has a type specified as the first keyword.
- Each block type defines how many labels must follow the type keyword.
- The block body is delimited by the { and } characters. Within the block body,
  further arguments and blocks may be nested.

### Identifiers

Argument names, block type names, and the names of most Terraform-specific constructs
like resources, input variables, etc. are all identifiers.

### Comments

Use `#` for single line by default. Terraform will also accept
`//` for single lines, `/*` and `*/` for multi-line.

## Expressions

### [Functions](https://developer.hashicorp.com/terraform/language/functions)

The Terraform language has a number of built-in functions that can be used in expressions to
transform and combine values. These are similar to the operators but all follow a common syntax:

```
<FUNCTION NAME>(<ARGUMENT 1>, <ARGUMENT 2>)
```

Note: There are only built in functions, there is no support for user defined functions!

#### Expanding Function Arguments

List / set / tuple function arguments can be expanded using the `...` syntax,
e.g.
```
min([55, 2453, 2]...)
```
is equivalent to:
```
min(55, 2453, 2)
```
### [Strings and templates](https://developer.hashicorp.com/terraform/language/expressions/strings)

Terraform supports both a quoted syntax and a "heredoc" syntax for strings.

#### Quoted strings

Quotes strings use backslashes for escape sequences with some common special characters like:

- `\n`: Newline
- `\r`: Carriage Return
- `\t`:	Tab
- `\"`:	Literal quote
- `\\`:	Literal backslash
- `$${`: Literal `${`, without beginning an interpolation sequence.
- `%%{`: Literal `%{`, without beginning a template directive sequence.

#### Heredoc Strings

Terraform supports indented Heredoc strings as well as the usual undindented kind, for example:
```
block {
  value = <<-EOT
  hello
    world
  EOT
}
```
renders the `value` as:
```
hello
  world
```

Hererdocs also support the last two escape sequences above, `$${`, and `%%{`.

#### String templates

Templates let you directly embed expressions into a string literal, to dynamically construct strings from other values.

A `${ ... }` sequence is an interpolation, which evaluates the expression given between the markers. For example `"Hello, ${var.name}!"` with `var.name = "Tom"` produces `"Hello, Tom!"`.

A `%{ ... }` sequence is a directive, which allows for conditional results and iteration over collections. For example `"Hello, %{ if var.name != "" }${var.name}%{ else }unnamed%{ endif }!"` with `var.name = "Tom"` returns `"Hello, Tom!"` and with `var.name = ""` returns `"Hello, unnnamed!"`.

### [Conditionals](https://developer.hashicorp.com/terraform/language/expressions/conditionals)

Syntax is of the form:
```
condition ? true_val : false_val
```
If condition is `true` then the result is `true_val`. If condition is `false` then the
result is `false_val`.

The condition can be any expression that resolves to a boolean value. This will usually
be an expression that uses the equality, comparison, or logical operators.

The two result values may be of any type, but they must both be of the same type.

### [For](https://developer.hashicorp.com/terraform/language/expressions/for)

A for expression creates a complex type value by transforming another complex type value.
Each element in the input value can correspond to either one or zero values in the result,
and an arbitrary expression can be used to transform each input element into an output element.

#### Examples

Iterate over lists with if statement:
```
[for s in var.list : upper(s) if s != ""]
```

Iterate over map of strings, concatenating keys and values into a list:
```
[for k, v in var.map : "${k}_${v}"]
```

Filtering maps of objects based on an object's value:
```
variable "users" {
  type = map(object({
    is_admin = bool
  }))
}

locals {
  admin_users = {
    for name, user in var.users : name => user
    if user.is_admin
  }
  regular_users = {
    for name, user in var.users : name => user
    if !user.is_admin
  }
}
```

### [Arithmetic and logical operators](https://developer.hashicorp.com/terraform/language/expressions/operators)

Equality:
- `==`: equality
- `!=`: not equal to

Logical:
- `a||b`: or operator
- `a&&b`: and operator
- `!a`: negative

All arithmetic ones are standard.

### [Splat](https://developer.hashicorp.com/terraform/language/expressions/splat)

A splat expression provides a more concise way to express a common operation that
could otherwise be performed with a for expression.

If var.list is a list of objects that all have an attribute id, then a list of
the ids could be produced with the following for expression:
```
[for o in var.list : o.id]
```
This is equivalent to the following splat expression:
```
var.list[*].id
```

### [Dynamic blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)

Dynamically construct repeateable nested blocks using an iterator over a list or map variable.

If `iterator` is not specified, it will default to the name of the dynamic block
being created.

```
variable "sg_groups" {
  type = list(nunmber)
  default = [8200, 8201, 8203]
}

resource "aws_security_group" "dynamicsg" {
  name        = "dynamic-sg"
  description = "Ingress for Vault"

  dynamic "ingress" {
    for_each = var.sg_ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  dynamic "egress" {
    for_each = var.sg_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```
