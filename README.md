# terraform notes

## Index

1. [cli](./cli.md)
2. [syntax](./syntax.md)
3. [providers](./providers.md)
4. [variables](./variables.md)
5. [resources](./resources.md)
6. [provisioners](./provisioners.md)
7. [data sources](./data_sources.md)
8. [modules](./modules.md)
9. [State and backends](./state_and_backends.md)
10. [terraform cloud](./terraform_cloud.md)
11. [hashicorp vault](./hashicorp_vault.md)

## Misc

### Load order and Semantics

Terrraform generally loads all the config files with extensions `.tf` or
`.tf.json` within a directory in alphabetical order.

Theres no real notion of namespacing without using terraform modules. Resource
names are required to be unique across modules or the entire workspace.

### Terraform settings block

Terraform requires a `terraform {}` configuration block in the root of the script.
This block may be used to configure:

- `required_version` argument: The version of Terraform to use.
- `required_providers` block: Sources, versions of all required providers.
- `cloud` block: Terraform cloud configuration information.

For example:

```terraform
terraform {

  cloud {
    organization = "EXPLORE-CORE"

    workspaces {
      tags = ["foo"]
    }
  }

  required_version = "~> 1.4"

  required_providers {

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.38"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.4"
    }
  }
}
```

For more info, see [terraform cloud configuration](./terraform_cloud.md#configuration) and
[provider configuration](./providers.md#provider-configuration).
