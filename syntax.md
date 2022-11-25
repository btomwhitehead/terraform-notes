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

## Variables

Variables are comprised of three types:

- input variables: parameters for a Terraform module
- output values: return values for a terraform module
- local values: a feature to assign a short name to an expression

### [Input variables](https://developer.hashicorp.com/terraform/language/values/variables)

Input variables let you customize aspects of Terraform modules without altering the
module's own source code. This functionality allows you to share modules across
different Terraform configurations, making your module composable and reusable.

Typical example:
```
variable "some_variable_name" {
  type        = <data type>
  description = <some readeable description>
  default     = <some sane default>
}
```

There are other additional fields: `validation`, sensitive`, `nullable`.

## [Output values](https://developer.hashicorp.com/terraform/language/values/outputs)

Output values make information about your infrastructure available on the command
line, and can expose information for other Terraform configurations to use.
Two common usecases are returning information from a child module to a parent
module or outputting information from a root module to the CLI.

Typical example:
```
output "some_name" {
  value       = <some resource expression>
  description = <some readable description>
}
```

There are two additional fields: `sensitive` and `depends_on`.

## [Local values](https://developer.hashicorp.com/terraform/language/values/locals)

A local value assigns a name to an expression, so you can use the name multiple
times within a module instead of repeating the expression.

Typical example:
```
locals {
  service_name = "forum"
  owner        = "Community Team"
}
```

Use local values to centralise a definition of a single value or result that is used in
many places and that value is likely to be changed in future.

## Data types
### maps
### lists

Store multiple items as a single variable in a sequential order. Lists are
indexed.

### sets

Sets are used to store multiple items as a single variable. Sets are unordered
and each element must be unique. Types also need to be the same, so mixed type
elements will be cast to the most general type .

Defining a set with curly brackets:
```
{"foo", "bar"}
[
  "bar",
  "foo",
]
```

The [toset](https://developer.hashicorp.com/terraform/language/functions/toset)
function casts a list of elements to a set.

Casting a list of mixed types to set:
```
toset(["foo", "bar", 1])
[
  "bar",
  "foo",
  "1",
]
```

Note that `toset()` will purge duplicates:
```
toset(["foo", "bar", "foo"])
[
  "bar",
  "foo",
]
```

## Conditional expressions

## Local values

## Terraform functions

### zipmap function

Construct a map from a list of keys and list of values:
`zipmap(keyslist, valueslist)`.

```
> zipmap(["a", "b"], [1, 2])
{
  "a" = 1
  "b" = 2
}
```

## Meta-arguments

### `providers`

### `depends_on`

### `count`

TODO

Count paramerters can create issues when indexing over lists if the underlying
list is modified. It is preferable to use maps/ sets and a for_each iterator where
possible.

### `for_each`

Iterate over a map or set of strings.

In blocks where for_each is set, an additional each object is available in expressions,
so you can modify the configuration of each instance. This object has two attributes:

- `each.key` — The map key (or set member) corresponding to this instance
- `each.value` — The map value corresponding to this instance

Example: iterate over a map of group names to locations:
```
resource "azurerm_resource_group" "rg" {
  for_each = {
    a_group = "eastus"
    another_group = "westus2"
  }
  name     = each.key
  location = each.value
}
```

Example: Iterate over a set of user names:
```
resource "aws_iam_user" "the-accounts" {
  for_each = toset( ["Todd", "James", "Alice", "Dottie"] )
  name     = each.key
}
```

## Splat expression

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

## Dynamic block

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
