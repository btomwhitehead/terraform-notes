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

### [functions](https://developer.hashicorp.com/terraform/language/functions)

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

### [for](https://developer.hashicorp.com/terraform/language/expressions/for)

TODO

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

### [dynamic blocks](https://developer.hashicorp.com/terraform/language/expressions/dynamic-blocks)

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
