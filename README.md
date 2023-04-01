# terraform notes

## Index

1. [cli](./cli.md)
2. [syntax](./syntax.md)
3. [variables](./variables.md)
4. [resources](./resources.md)
5. [provisioners](./provisioners.md)
6. [data sources](./data_sources.md)
7. [modules](./modules.md)
8. [State and backends](./state_and_backends.md)
9. [terraform cloud](./terraform_cloud.md)

Notes for terrafrorm associate course notes: https://www.udemy.com/course/terraform-beginner-to-advanced/

TODO: update

## Load order and Semantics

Terrraform generally loads all the config files with extensions `.tf` or
`.tf.json` within a directory in alphabetical order.

Theres no real notion of namespacing without using terraform modules. Resource
names are required to be unique across modules or the entire workspace.

## Terraform settings

What is set in the `terraform {}` block. Options include:

- `required_version`: Version of terraform required
- `required_providers`: Sources, versions of required providers
- `cloud`: Terraform cloud configuration

## Terraform provisioners

## Troubleshooting

### Dealing with large infrastructure (hacks)

All cloud vendors have API limits which can be hit when making changes to
large infrastructure. The following tips can help reduce the total API calls:

- Chunk the resources into smaller standalone scripts when possible.
- Bypass the refresh step of plan / apply with `-refresh=false` flag.
- Specify specific targets that you want to modify, that are resources, resource
  instances or modules using the `-target=resouce` flag.
