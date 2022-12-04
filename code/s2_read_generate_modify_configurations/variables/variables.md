# Variables

See [Types and variables](https://www.terraform.io/language/expressions/types)
and some examples at
[terraform-aws-elb/variables.tf ](https://github.com/terraform-aws-modules/terraform-aws-elb/blob/master/variables.tf)

## Define variables

```
variable "var_name" {
  description = "Some text description"
  type = string
  default = "var_default"
}
```

Note, default isn't required.

## Overriding variables

### `terraform.tfvars`

```
var_name="var_value"
```

### Alternatively named `custom_terraform.tfvars`

Same as above but use `terraform plan -var-file=filename`

### Env

Use prefix `TF_VAR_*`:

```
export TF_VAR_var_name="var_value"
```

## Data types

Best practice to set value types within variable definitions.

- `string`: `"foo"`
- `number`: `15`, `1.23`
- `bool`: `true` or `false`
- `list(type)`: `["foo", "bar"]`
- `map(type)`: `{name = "Tom", age = 31}`

`null` value exists as well! If you set an argument of a resource to null,
Terraform behaves as though you had completely omitted it — it will use the
argument's default value if it has one, or raise an error if the argument is mandatory. 

## Indexing maps and lists

### Example definitions

List
```
variable "a" {
  tyoe - list(string)
  default = ["foo", "bar"]
}
```

Map
```
variable "b" {
  type = map(string)
  default = {foo = "bar"}
}
```

The above can be referenced in new resources with the following:

```
variable "aws_instance" "foo" {
  ami = var.b["foo"]
  instance_type = var.a[0]
}
```
