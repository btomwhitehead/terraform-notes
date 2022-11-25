# Resources

## [Resource blocks](https://developer.hashicorp.com/terraform/language/resources/syntax)

TODO

## [Resource behaviour](https://developer.hashicorp.com/terraform/language/resources/behavior)

TODO

## Meta-arguments

Meta-argumenrts are special constructs in Terraform which are available for Resource and Module
blocks to simplify configurations.

### [provider](https://developer.hashicorp.com/terraform/language/meta-arguments/resource-provider)

The provider meta-argument specifies which provider configuration to use for a resource, overriding
Terraform's default behavior of selecting one based on the resource type name. Its value should
be an unquoted `<PROVIDER>.<ALIAS>` reference.
```
provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  alias  = "usw2"
  region = "us-west-2"
}

module "example" {
  source    = "./example"
  providers = {
    aws = aws.usw2
  }
}
```

### [depends_on](https://developer.hashicorp.com/terraform/language/meta-arguments/depends_on)

Use the depends_on meta-argument to handle hidden resource or module dependencies that
Terraform cannot automatically infer. The value is a list of references to other resources
or child modules, e.g.: `depends_on = [provider_some_resource_type.name]`.

### [count](https://developer.hashicorp.com/terraform/language/meta-arguments/count)

A way to create several similar objects (like a fixed pool of compute instances) without
writing a separate block for each one. Use a `count = `<integer>` to specify the
number of created resources / modules.

When `count` is used, a `count` object is available for you to modify the
configuration for each instance. It has one attribute `count.index`, the
instance integer number.

If your instances are almost identical, `count` is appropriate. If some of their arguments
need distinct values that can't be directly derived from an integer, it's safer to
use `for_each`.

### [for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

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

### [lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

The lifecycle nested block has several arguments that define how the
configuration is modified. The keys are:
- `create_before_destroy (`bool`, default `false`): Create new resources before
  destroying ones that cannot be modified in place.
- `prevent_destroy` (`bool`, default `false): Terraform to reject with an error
  any plan that would destroy the infrastructure object.
- `ignore_changes (`list` of objects): Specify resource attributes that Terraform
  should ignore when planning updates to the associated remote object.
- `replace_triggered_by (`list` of objects): Replace the resource when any of
  the referenced items change.

## [Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

TODO
