# Resources

## [Resource blocks](https://developer.hashicorp.com/terraform/language/resources/syntax)

Resource blocks define one or more infrastructure objects. A resource block
declares a resource of a certain type and a given name that are defined by the
first and second labels respectively as well as a body contained in `{` and `}`.

In the example below, we create a resource of type `aws_instance`, we assign it
a local name of `foo` and values are provided for two arguments, `ami` and
`instance_type`, within the resource body.

```terraform
resource "aws_instance" "foo" {
  ami           = "some-ami-identifier"
  instance_type = "some-instance-type"
}
```

Each resource type is implemented by some provider who will also publish
detailed documentation outlining it's purpose, arguments, attributes and
usage examples.

## [Resource behaviour](https://developer.hashicorp.com/terraform/language/resources/behavior)

### The apply process

To create or modify resources to match the configuration, a `terraform apply` must be run.
This will perform the following sequence of actions:

1. Create resources that exist in the configuration but not in the state.
2. Destroy resources that exist in the state but no longer exist in the configuration.
3. Update in-place resources whose arguments have changed.
4. Destroy and re-create resources whose arguments have changed but which cannot be updated in-place due to remote API limitations.

### Accessing resource attributes

Expressions within a Terraform module can access information about resources in the same module using resource attributes.
All providers list resource arguments and attributes in the provider documentation. These can then be used to create resources
based on information of others. For example, below we create a resource group, virtual network and subnet where attributes
are used as arguments to other resources defined later:

```terraform
resource "azurerm_resource_group" "foo" {
  name     = "foo"
  location = "West US"
}

resource "azurerm_virtual_network" "bar" {
  name                = "bar"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.foo.location
  resource_group_name = azurerm_resource_group.foo.name
}

resource "azurerm_subnet" "baz" {
  name                 = "baz"
  resource_group_name  = azurerm_resource_group.foo.name
  virtual_network_name = azurerm_virtual_network.bar.name
  address_prefix       = "10.0.1.0/24"
}
```

### Resource dependencies

The above example contains dependencies, because certain resources need to be created before one that references it can.
Terraform can infer dependencies based on the argument values that parameterise a resource block
such as in the previous example. Terraform can infer that because the subnet contains argument values from both the resource
group and virtual network, it must be created last. Similarly the virtual network argument values reference the resource
group's attributes and so the virtual network must be created after the resource group.

There are some situations where Terraform cannot infer dependencies. This could be for multiple reasons, such as using
[provisioners](./provisioners.md) or provider API limitations. In these cases, dependencies can be explicitly set using the
`depends_on` meta-argument below.

## Meta-arguments

Meta-arguments are special constructs in Terraform which are available for `resource` and `module`
blocks to simplify configurations.

### [provider](https://developer.hashicorp.com/terraform/language/meta-arguments/resource-provider)

The provider meta-argument specifies which provider configuration to use for a resource, overriding
Terraform's default behavior of selecting one based on the resource type name. Its value should
be an unquoted `<PROVIDER>.<ALIAS>` reference.

```terraform
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
writing a separate block for each one. Use a ` count = {integer} ` to specify the
number of created resources / modules.

When `count` is used, a `count` object is available for you to modify the
configuration for each instance. It has one attribute `count.index`, the
instance integer number.

If your instances are almost identical, `count` is appropriate. If some of their arguments
need distinct values that can't be directly derived from an integer, it's safer to
use `for_each`.

### [for_each](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

Iterate over a map or set of strings.

In blocks where `for_each` is set, an additional `each` object is available in expressions,
so you can modify the configuration of each instance. This object has two attributes:

- `each.key` — The map key (or set member) corresponding to this instance
- `each.value` — The map value corresponding to this instance

Example: iterate over a map of group names to locations:

```terraform
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

```terraform
resource "aws_iam_user" "the-accounts" {
  for_each = toset( ["Todd", "James", "Alice", "Dottie"] )
  name     = each.key
}
```

### [lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

The lifecycle nested block has several arguments that define how the
configuration is modified. The keys are:

- `create_before_destroy` (`bool`, default `false`): Create new resources before destroying ones that cannot be
  modified in place.
- `prevent_destroy` (`bool`, default `false`): Terraform to reject with an error any plan that would destroy the
  infrastructure object.
- `ignore_changes` (`list` of objects): Specify resource attributes that Terraform should ignore when planning updates
  to the associated remote object.
- `replace_triggered_by` (`list` of objects): Replace the resource when any of the referenced items change.
