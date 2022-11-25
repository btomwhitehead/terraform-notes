# Syntax

## Variables

### defs
### data types
### maps
### lists
### count, count_index

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

## for_each iterator

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
## Comments

Use `#` for single line by default. Terraform will also accept
`//` for single lines, `/*` and `*/` for multi-line.

## SET

## for_each

