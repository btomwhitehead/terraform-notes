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

You can use provisioners to model specific actions on the local machine or on a
remote machine in order to prepare servers or other infrastructure objects for service.

Uses:
- Passing data into VMs and other compute resources
- Running configuration management software on VMs and other compute resources

**Note: Provisioners should only be used as a last resort. For most common
situations there are better alternatives. For more information, see the
sections above.**

### Provisioners

There are many with support for configuration management software, but the main
two are  `local-exec` and `remote-exec` for normal CLI commands and scripts and
`file` for copying files and directories.

#### [The `self` object](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax#the-self-object)

Expressions in provisioner blocks cannot refer to their parent resource by name.
Instead, they can use the special `self` object.

The `self` object represents the provisioner's parent resource, and has all of
that resource's attributes. For example, use `self.public_ip` to reference an
aws_instance's public_ip attribute.

#### [local-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

Run some command on the local machine where the terraform apply is being run.

```
resource "aws_instance" "this" {
  ...

  provisioner "local-exec" {
    command = "some command to run on local machine"
    ...
  }
}
```

- command: The command to execute.
- `working_dir`: If provided, specifies the working directory where command will
  be executed.
- `interpreter`: A list of interpreter arguments used to execute the command,
  e.g. `["/bin/bash", "-c"]`.
- `environment`: Block of key value pairs representing the environment of the
  executed command. inherits the current process environment. E.g. `{FOO = "bar"}`.
- `when`: Specifies when Terraform will execute the command. E.g., `when = destroy`.

#### [remote-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

Run some command directly on some remote server.

```
resource "aws_instance" "this" {
  ...

  provisioner "remote-exec" {

    connection {
      host = "host address"
      type = "{ssh|winrm}"

      ...

    }

    inline = [
        command_0,
        command_1,
        ...
    ]

    script = "local/path/to/script"

    script = [
      "local/path/to/script_0",
      "local/path/to/script_1",
      ...
    ]

    ...
  }
}
```

There are many ways to configure the remote connection in the connection block.
See the
[connection block](https://developer.hashicorp.com/terraform/language/resources/provisioners/connection)
documentation for more information.

Commands can be specified with at most one of the following arguments:
- `inline`: This is a list of command strings.
- `script`: This is a path (relative or absolute) to a local script that will
  be copied to the remote resource and then executed.
- `scripts`: This is a list of paths (relative or absolute) to local scripts
  that will be copied to the remote resource and then executed.

#### [file](https://developer.hashicorp.com/terraform/language/resources/provisioners/file)

```
resource "aws_instance" "this" {
  ...

  provisioner "file" {
    source      = "local/path/to/file_or_directory/"
    destination = "/destination/path"
    ...
  }
}
```

- `destination`: The destination path to write to on the remote system.
- `source`: The source file or directory. Specify it either relative to the current working directory or as an absolute path.
- `content`: The direct content to copy on the destination.
