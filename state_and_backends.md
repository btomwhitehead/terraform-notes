# Terraform state

Terraform requires some mechanism to map config to the real world.

Terraform expects that each remote object is bound to only one resource instance in the configuration.
If a remote object is bound to multiple resource instances, the mapping from configuration to the remote object in the
state becomes ambiguous, and Terraform may behave unexpectedly.

Alongside the mappings between resources and remote objects, Terraform also tracks metadata such as resource dependencies.
This is required to understand what resources may need to be modified once an upstream dependency changes as well as
determining which order changes need to be applied in. For instance, a virtual network must be created before a subnet on
it.

Additionally, terraform caches resource attribute values in the state file to improve performance. This is most important
when using large configurations as querying every resource's attributes is time consuming.

State files are stored in a [backend](#backends) in `json` format.

## State inspection and modification

Command:

```sh
terraform state
```

Subcommands:

```sh
Subcommands:
    list                List resources in the state
    mv                  Move an item in the state
    pull                Pull current state and output to stdout         (rarely useful)
    push                Update remote state from a local state file     (rarely useful)
    replace-provider    Replace provider in the state
    rm                  Remove instances from the state
    show                Show a resource in the state
```

### Some examples

List all resources in a specific module defined in the root of the script:

```sh
terraform state list module.some_module_name
```

Show info about a specific resource:

```sh
terraform state show module.some_module_name.provider_resource_name.instance_name
```

Move item in a state without destroying and recreating it, in this case a module:

```sh
terraform state mv module.some_module_name module.some_other_module_name
```

Manually download and output the state from some remote backend in `json`:

```sh
terraform state pull
```

Delete an item from a terraform state, so that it is no longer managed by terraform:

```sh
terraform state rm provider_resource_name.instance_name
```

Replace AWS provider with a public fork that has some desired additional features:

```sh
terraform state replace-provider hashicorp/aws registry.acme.corp/acme/aws
```

## Backends

Backends determine where terraform stores its state as well as managing write access to it to avoid it being corrupted.

Backend blocks are defined by:

```terraform
terraform {
  backend "backend_type" {
    ...
  }
}
```

Once a backend block has been modified, you need to reinitialise the project
using `terraform init`.

## State file locking

Whenever a write operation is being performed, terraform locks the state file to ensure that it is not corrupted by an
apply at the same time.

State file locking is implemented differently for different backends. Some do not support state locking at all.

## Backend types

There are many backend types!

- `local`
- `remote`
- `s3`
- `azurerm`
- `consul`
- `cos`
- `gcs`
- `http`
- `Kubernetes`
- `oss`
- `pg`

### [`local`](https://developer.hashicorp.com/terraform/language/settings/backends/local)

The default backend is local, where state is stored locally in the project
directory in a file named `terraform.tfstate` by default. The workspace dir can
also be set if needed.

```terraform
terraform {
  backend "local" {
    path = "relative/path/to/terraform.tfstate"
    workspace_dir = "./"
  }
}
```

While an apply is in progress, the state lock is written to a file in
`.terraform/.terraform.tfstate.lock.info` containing an ID, the path to the
state file and some other info. This file is automatically deleted when the
lock is released.

### [`remote`](https://developer.hashicorp.com/terraform/language/settings/backends/remote)

The remote backend is unique among all other Terraform backends because it can both store state snapshots and execute
operations for Terraform Cloud's CLI-driven run workflow.

As of Terraform v1.1.0 and Terraform Enterprise v202201-1, it is recommended to use
[Terraform Cloud](./terraform_cloud.md) instead of this backend.

### [`s3`](https://developer.hashicorp.com/terraform/language/settings/backends/s3)

Store the state as a given key in a given bucket on Amazon S3.

Configuration:

```terraform
terraform {
  backend "s3" {
    bucket          = "mybucket"
    region          = "us-east-1"
    key             = "network/terraform.tfstate"
    dynamo_db_table = "terraform_state_locking"
  }
}
```

Note that the access credentials need to also be supplied via some mechanism. This mostly aligns with the
authentication method used when configuring the primary cloud provider.

This backend supports
[state locking via Dynamo DB](https://developer.hashicorp.com/terraform/language/settings/backends/s3#dynamodb-state-locking)
by setting the `dynamodb_table` field to an existing DynamoDB table name. The table requires a string primary key field
called `LockID` to work correctly. Additional
[DynamoDB permissions](https://developer.hashicorp.com/terraform/language/settings/backends/s3#dynamodb-table-permissions)
and other configurations are required.

### [`azurerm`](https://developer.hashicorp.com/terraform/language/settings/backends/azurerm)

Stores the state as a Blob with the given Key within the Blob Container within the Blob Storage Account. This backend supports
state locking with built in blob storage lease capabilities.

Configuration with service principal:

```terraform
terraform {
  backend "azurerm" {
    resource_group_name  = "some_resource_group_name"
    storage_account_name = "some_account_name"
    container_name       = "container_name"
    key                  = "some_state.terraform.tfstate"
  }
}
```

## Connecting to remote state backends

The [terraform provider](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs)
[`terraform_remote_state` data source](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state)
uses the latest state snapshot from a specified state backend to retrieve the root module output values from some other
Terraform configuration.

For example, query another state using:

```terraform
data "terraform_remote_state" "foo" {
  backend = "s3"

  ...
}
```

And use the root level outputs in other definitions:

```terraform
resource "aws_instance" "bar" {
  # ...
  subnet_id = data.terraform_remote_state.foo.outputs.subnet_id
}
```

## Connecting to terraform cloud

The same can be done (as well as other features) using [tfe provider](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs)
[`tfe_outputs` data source](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/data-sources/outputs).

For example, query another state using:

```terraform
data "tfe_outputs" "foo" {
  organization = "my-org"
  workspace = "my-workspace"
}
```

The relevant root level outputs can be used in new definitions:

```terraform
resource "aws_instance" "bar" {
  subnet_id = data.tfe_outputs.foo.outputs.subnet_id
}
```

## Terraform import

`terraform import` lets you bring existing resources under terraform management by importing the resources into the
state. It cannot generate terraform configurations and the user is required to define it.

### Workflow

1. Identify the existing infrastructure you will import.
2. Create configurations for the infrastructure that you wish to import by defining resource blocks.
3. Import infrastructure into your Terraform state file using
  `terraform import <terraform resource ID> <provider resource ID>`.
  E.g. `terraform import aws_instance.this i-0f3ea6...`.
4. Run a `terraform plan` and update the terraform configuration so that it matches the desired infrastructure and no changes
  are suggested by the plan.
5. Apply the configuration to update your Terraform state.

See [tutorial](https://developer.hashicorp.com/terraform/tutorials/state/state-import) for an example of the workflow.

## Dependency lock file

Terraform configurations may have external dependencies in the form of providers and modules. Version constraints
within the configuration itself determine which versions of dependencies are potentially compatible, but after
selecting a specific version of each dependency Terraform stores this decision in a dependency lock file so that results
are repeatable in the future. Only provider versions are stored in this file and modules will always be set to the
latest available version subject to its version constraints.

A dependency lock file is created by running `terraform init` and is stored as `.terraform.lock.hcl` in the root of the script.

If a particular provider has no existing recorded selection, Terraform will select the newest available version
that matches the given version constraint, and then update the lock file to include that selection. If a particular
provider already has a selection recorded in the lock file, Terraform will always re-select that version for
installation, even if a newer version has become available. You can override that behavior with
`terraform init -upgrade`, in which case Terraform will disregard the existing selections.

For further information see the [Dependency lock file docs](https://developer.hashicorp.com/terraform/language/files/dependency-lock).
