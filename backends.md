# Backends

Backends determine where terraform stores its state.

Backend blocks are defined by:

```
terraform {
  backend "remote" {
    organization = "example_corp"

    workspaces {
      name = "my-app-prod"
    }
  }
}
```

TODO: explain

Once a backend block has been modified, you need to reinitialise the project
using `terraform init`.

TODO: partial configuration notes

## Backend types

### `local`

The default backend is local, where state is stored locally in the project
directory in a file named `terraform.tfstate`.

### `remote`

### `s3`

### `azurerm`

### Terraform cloud

## State file contents


