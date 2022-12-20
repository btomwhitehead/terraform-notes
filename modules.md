# Modules

## Module naming convention

Module repositories must follow the `terraform-<PROVIDER>-<NAME>` 3 part naming
convention where:
- `<NAME>`: reflects the type of infrastructure the module manages
- `<PROVIDER>`: the main provider where it creates that infrastructure e.g. `azurerm`

## [Standard module structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

The standard module structure is a file and directory layout we recommend for
reusable modules distributed in separate repositories. Terraform tooling is
built to understand the standard module structure and use that structure to
generate documentation, index modules for the module registry, and more.

1. Root module. Terraform files must exist in the root directory of the repository.
  This should be the primary entrypoint for the module and is expected to be opinionated.

2. `README.md`. The root module and any nested modules should have README files.
  There should be a description of the module and what it should be used for.

3. Expected terraform files:
  1. `main.tf`. The main entrypoint of the module. For a simple module, this
    may be where all the resources are created. For a complex module, resource
    creation may be split into multiple files but any nested module calls should
    be in the main file.
  2. `variables.tf`. Contains all variable declarations. If no variables are
     defined, this file should still exist and be empty.
  3. `outputs.tf`. Contains all output variable declarations. If no outputs are
     defined, this file should still exist and be empty.

4. All variables and outputs should have descriptions.

5. `LICENSE`. The license under which this module is available. If you are publishing
  a module publicly, many organizations will not adopt a module unless a clear
  license is present. We recommend always having a license file, even if it is
  not an open source license.

6. Nested modules. Nested modules should exist under the modules/ subdirectory. If
  the root module includes calls to nested modules, they should use relative paths
  like `./modules/consul-cluster` so that Terraform will consider them to be part
  of the same repository or package, rather than downloading them again separately.

7. `examples/`. Examples of using the module should exist under the `examples/`
  subdirectory at the root of the repository. Each example may have a `README.md`
  to explain the goal and usage of the example. Examples for submodules should
  also be placed in the root `examples/` directory.

## [Module composition](https://developer.hashicorp.com/terraform/language/modules/develop/composition)

TODO

## [Terraform registry](https://registry.terraform.io/)

Terraform registry is a repository of terraform providers and modules
contributed by the community.

These modules can be used as is or can guide you on how to create your own
similar modules.

Verified modules are reviewed by HashiCorp and have a blue verification badge.
They are actively maintained to stay up to date with providers.

### Using modules from a registry

Make use of the `source` and `version` parameters as below:

```
module "vpc" {
  source  = "terraform-registry/source/path"
  version = "x.y.z"

  ...
}
```

### Publishing to a registry

Published modules support versioning, automatically generate documentation,
allow browsing version histories, show examples and READMEs, and more.

- Modules must use [Semantic Versioning](https://semver.org/).
- The module must follow the 3 part
  [module naming convention](#module-naming-convention).
- The module must follow the
  [standard module structure](#standard-module-structure).
- Public modules must be on GitHub and the repo must be a public.
