# [Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

You can use provisioners to model specific actions on the local machine or on a
remote machine in order to prepare servers or other infrastructure objects for service.

Uses:

- Passing data into VMs and other compute resources
- Running configuration management software on VMs and other compute resources

**Note: Provisioners should only be used as a last resort. For most common
situations there are better alternatives. For more information, see the
sections above.**

## Provisioners

There are many with support for configuration management software, but the
primary two are  `local-exec` and `remote-exec` for normal CLI commands and scripts and
`file` for copying files and directories.

### [The `self` object](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax#the-self-object)

Expressions in provisioner blocks cannot refer to their parent resource by name.
Instead, they can use the special `self` object.

The `self` object represents the provisioner's parent resource, and has all of
that resource's attributes. For example, use `self.public_ip` to reference an
aws_instance's public_ip attribute.

### [local-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

Run some command on the local machine where the terraform apply is being run.

```terraform
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
  e.g. `interpreter = ["/bin/bash", "-c"]`.
- `environment`: Block of key value pairs representing the environment of the
  executed command. inherits the current process environment. E.g.
  `environment = {FOO = "bar"}`.

### [remote-exec](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

Run some command directly on some remote server.

```terraform
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

### [file](https://developer.hashicorp.com/terraform/language/resources/provisioners/file)

```terraform
resource "aws_instance" "this" {
  ...

  provisioner "file" {
    source      = "local/path/to/file_or_directory/"
    destination = "/destination/path"
    ...
  }
}
```

The arguments are:

- `destination`: The destination path to write to on the remote system.
- `source`: The source file or directory. Specify it either relative to the current working directory or as an absolute path.
- `content`: The direct content to copy on the destination.

One and only one of `source` and `content` is required.

## `when` meta-argument

The `when` meta-argument specifies when Terraform will execute the provisioner.

When `when = destroy`, the provisioner will run when the resource it is defined
within is destroyed. `Similarly,`when = create` will run immediately after the
resource is provisioned. The default behaviour is `when = create`.

If a creation-time provisioner fails, the resource is marked as tainted.
Creation-time provisioners are also only run at creation, not during any
subsequent updates.

Destroy provisioners are run before the resource is destroyed. If they fail,
Terraform will error and rerun the provisioners again on the next terraform apply.
Destroy-time provisioners can only run if they remain in the configuration at the
time a resource is destroyed.

## `on_failure` meta-argument

The `on_failure` meta-argument tells terraform what to do when a provisioner
fails. The default mode  is `on_failure = fail` and the apply will fail. The allowed
values are:

- `continue`: Ignore the error and continue with creation or destruction.
- `fail`: Raise an error and stop applying (the default behavior). If this is a creation
  provisioner, taint the resource.
