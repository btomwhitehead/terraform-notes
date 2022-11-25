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

### Type keywords

There are three type keywords:

- `string`: string values, e.g. `"foo"`
- `number`: numeric values, e.g. `1.2`
- `bool`: Booleans, e.g. `true` or `false`
- `any`: A placeholder

The keyword any is a special construct that serves as a placeholder for a type yet to be decided.
`any` is not itself a type: when interpreting a value against a type constraint containing `any`,
Terraform will attempt to find a single actual type that could replace the any keyword to produce
a valid result.

The Terraform language will automatically convert number and bool values to string values when
needed, and vice-versa as long as the string contains a valid representation of a number or
boolean value.

### Type constructors

#### `list`

- `list(...)`: a sequence of values identified by consecutive whole numbers
  starting with zero.
- Type constructor: `list(<TYPE>)`
- Type constructor example: `list(string)`

A list can only be converted to a tuple if it has exactly the required number of elements.

#### `set`

- `set(...)`: a collection of unique values that do not have any secondary
  identifiers or ordering.
- Type constructor: `set(<TYPE>)`
- Type constructor example: `set(string)`

```
{"foo", "bar"}
[
  "bar",
  "foo",
]
```
When a list or tuple is converted to a set, duplicate values are discarded and the ordering of
elements is lost. When a set is converted to a list or tuple, the elements will be in an arbitrary
order.

The [toset](https://developer.hashicorp.com/terraform/language/functions/toset)
function casts a list of elements to a set. Note that `toset()` will purge duplicates.
```
toset(["foo", "bar", 1, "foo"])
[
  "bar",
  "foo",
  "1",
]
```

#### `map`

- `map(...)`: a collection of values where each is identified by a string label.
- Type constructor: `map(<TYPE>)`
- Type constructor example: `map(string)`

#### `tuple`

- `tuple(...)`: a sequence of elements identified by consecutive whole numbers
  starting with zero, where each element has its own type.
- Type constructor: `tuple([<TYPE>, ...])`
- Type constructor example: `tuple([string, string, bool])`

#### `object`

- `object(...)`: a collection of named attributes that each have their own type.
- Type constructor: `object({<ATTR NAME> = <TYPE>, ... })`
- Type constructor example: `object({ a=string, b=string })`

Terraform typically returns an error when it does not receive a value for specified
object attributes. When you mark an attribute as optional, Terraform instead inserts
a default value for the missing attribute. This allows the receiving module to
describe an appropriate fallback behavior.

To mark attributes as optional, use the optional modifier in the object type
constraint:

```
object({
  a = string                # a required attribute
  b = optional(string)      # an optional attribute
  c = optional(number, 127) # an optional attribute with default value
})
```

A map (or a larger object) can be converted to an object if it has at least the keys
required by the object schema. Any additional attributes are discarded during conversion.

## Conditional expressions

## Terraform functions

See [functions overview](https://developer.hashicorp.com/terraform/language/functions)
for a list of all functions.

The Terraform language has a number of built-in functions that can be used in expressions to
transform and combine values. These are similar to the operators but all follow a common syntax:

```
<FUNCTION NAME>(<ARGUMENT 1>, <ARGUMENT 2>)
```

Note: There are only built in functions, there is no support for user defined functions!

### Expanding Function Arguments

List / set / tuple function arguments can be expanded using the `...`  syntax,
e.g.
```
min([55, 2453, 2]...)
```
is equivalent to:
```
min(55, 2453, 2)
```

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
