# Variables

## Define variables

```
variable "var_name" {
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
