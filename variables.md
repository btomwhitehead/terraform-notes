# Variables

Variables are comprised of three types:

- input variables: parameters for a Terraform module
- output values: return values for a terraform module
- local values: a feature to assign a short name to an expression

## [Input variables](https://developer.hashicorp.com/terraform/language/values/variables)

Input variables let you customize aspects of Terraform modules without altering the
module's own source code. This functionality allows you to share modules across
different Terraform configurations, making your module composable and reusable.

Typical example:
```
variable "some_variable_name" {
  type        = <data type>
  description = <some readeable description>
  default     = <some sane default>

  # Additional fields
  validation = <some HCL validation rule, in addition to type constraint>
  sensitive  = <Redact this field in all terraform console / cloud output>
  nullable   = <Sepecify if the variable can be set to null, defaults to true>
}
```

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

  # Additional fields
  sensitive  = <Redact this field in all terraform console / cloud output>
  depends_on = <Resource ID that must be created before this resource, only use as a last resort when dependencies cannot be inferred>
}
```

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

## [Data types](https://developer.hashicorp.com/terraform/language/values/variables#type-constraints)

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
