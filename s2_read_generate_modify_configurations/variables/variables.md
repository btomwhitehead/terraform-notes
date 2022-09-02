# Variables

See [Types and variables](https://www.terraform.io/language/expressions/types)

## Define variables

```
variable "var_name" {
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
- `list`: `["foo", "bar"]`
- `map`: `{name = "Tom", age = 31}`

`null` value exists as well! If you set an argument of a resource to null,
Terraform behaves as though you had completely omitted it — it will use the
argument's default value if it has one, or raise an error if the argument is mandatory. 
