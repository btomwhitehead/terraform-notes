# [CLI commands](https://developer.hashicorp.com/terraform/cli/commands)

```
terraform [global options] <subcommand> [args]
```

Main commands:
- `init`          Prepare your working directory for other commands
- `validate`      Check whether the configuration is valid
- `plan`          Show changes required by the current configuration
- `apply`         Create or update infrastructure
- `destroy`       Destroy previously-created infrastructure

Other useful commands:
- `fmt`           Reformat your configuration in the standard style
- `workspace`     Workspace management
- `force-unlock`  Release a stuck lock on the current workspace
- `graph`         Generate a Graphviz graph of the steps in an operation in DOT
                  format
- `refresh`       Update the state to match remote systems

### terraform `plan` and `apply

The following options customize how Terraform will produce its plan. You
can also use these options when you run "terraform apply" without passing
it a saved plan, in order to plan and apply in a single command.

- `-destroy`            Select the "destroy" planning mode, which creates a plan
                        to destroy all objects currently managed by this
                        Terraform configuration instead of the usual behavior.

- `-refresh-only`       Select the "refresh only" planning mode, which checks
                        whether remote objects still match the outcome of the
                        most recent Terraform apply but does not propose any
                        actions to undo any changes made outside of Terraform.

- `-refresh=false`      Skip checking for external changes to remote objects
                        while creating the plan. This can potentially make
                        planning faster, but at the expense of possibly planning
                        against a stale record of the remote system state.

- `-replace=resource`   Force replacement of a particular resource instance using
                        its resource address. If the plan would've normally
                        produced an update or no-op action for this instance,
                        Terraform will plan to replace it instead. You can use
                        this option multiple times to replace more than one object.

- `-target=resource`    Limit the planning operation to only the given module,
                        resource, or resource instance and all of its
                        dependencies. You can use this option multiple times to
                        include more than one object. This is for exceptional
                        use only.

- `-var 'foo=bar'`      Set a value for one of the input variables in the root
                        module of the configuration. Use this option more than
                        once to set more than one variable.

- `-var-file=filename`  Load variable values from the given file, in addition
                        to the default files terraform.tfvars and *.auto.tfvars.
                        Use this option more than once to include more than one
                        variables file.

- `-out=path`           Write a plan file to the given path. This can be used as
                        input to the "apply" command.

terraform `apply` only:

- `-auto-approve`       Skip interactive approval of plan before applying.

- `-backup=path`        Path to backup the existing state file before
                        modifying. Defaults to the "-state-out" path with
                        ".backup" extension. Set to "-" to disable backup.

- `-state=path`         Path to read and save state (unless state-out
                        is specified). Defaults to "terraform.tfstate".

- `-state-out=path`     Path to write state to that is different than
                        "-state". This can be used to preserve the old
                        state.

The first step of a terraform plan is to update the state of each resource
followed by determining the changes that need to occur.

## [Debugging CLI commands](https://www.terraform.io/internals/debugging)

Config logging via environment variables:

- `TF_LOG`: One of `TRACE`, `DEBUG`, `INFO`, `WARN` or `ERROR`
- `TF_LOG_PATH`= Path, e.g. `./terraform.log`
