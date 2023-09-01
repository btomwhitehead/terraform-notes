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

### Terraform settings

What is set in the `terraform {}` block. Options include:

- `required_version`: Version of terraform required
- `required_providers`: Sources, versions of required providers
- `cloud`: Terraform cloud configuration
