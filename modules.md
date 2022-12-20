# Modules

## Module naming convention

Module repositories must follow the `terraform-<PROVIDER>-<NAME>` 3 part naming
convention where:
- `<NAME>`: reflects the type of infrastructure the module manages
- `<PROVIDER>`: the main provider where it creates that infrastructure e.g. `azurerm`

## [Standard module structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

The standard module structure is the recommended file and directory layout for
reusable modules distributed in separate repositories. Terraform tooling is
built to understand the standard module structure and use that structure to
generate documentation, index modules for the module registry, and more.

1. Root module: Terraform files must exist in the root directory of the repository.
  This should be the primary entrypoint for the module and is expected to be opinionated.

2. `README.md`: The root module and any nested modules should have README files.
  There should be a description of the module and what it should be used for.

3. Expected terraform files:
  1. `main.tf`: The main entrypoint of the module. For a simple module, this
    may be where all the resources are created. For a complex module, resource
    creation may be split into multiple files but any nested module calls should
    be in the main file.
  2. `variables.tf`: Contains all variable declarations. If no variables are
     defined, this file should still exist and be empty.
  3. `outputs.tf`: Contains all output variable declarations. If no outputs are
     defined, this file should still exist and be empty.
  4. `versions.tf`: Contains any `terraform {}` block configurations required by
     the module, such as `required_provider` blocks. If no configurations are
     defined, this file should still exist and be empty.

4. All variables and outputs should have descriptions.

5. `LICENSE`: The license under which this module is available. If you are publishing
  a module publicly, many organizations will not adopt a module unless a clear
  license is present. We recommend always having a license file, even if it is
  not an open source license.

6. `modules/`: Nested modules should exist under this subdirectory. If the root
  module includes calls to nested modules, they should use relative paths
  like `./modules/module_a` so that Terraform will consider them to be part
  of the same repository or package, rather than downloading them again separately.

7. `examples/`: Examples of using the module should exist under the `examples/`
  subdirectory at the root of the repository. Each example may have a `README.md`
  to explain the goal and usage of the example. Examples for submodules should
  also be placed in the root `examples/` directory.

## [Module composition](https://developer.hashicorp.com/terraform/language/modules/develop/composition)

The use of modules transform the configuration from a flat strcture to a
heirachal structure as each module has its own set of resources and
possibly child modules.

In most cases it is strongly recommended to keep the module tree flat,
with only one level of child modules.

This flat structure is called module
[composition](https://en.wikipedia.org/wiki/Composability), because
it takes multiple composable building-block modules and assembles
them together to produce a larger system. Instead of a module embedding
its dependencies, creating and managing its own copy, the module
receives its dependencies from the root module, which can therefore
connect the same modules in different ways to produce different results.

### [Dependency inversion](https://developer.hashicorp.com/terraform/language/modules/develop/composition#dependency-inversion)

A
[dependency inversion](https://en.wikipedia.org/wiki/Dependency_inversion_principle)
approach improves flexibility for future refactoring. Writing modules
that take dependencies in the form of identifiers makes the module
agnostic of how those identifiers are obtained by the parent module:
they can arise from outputs of other modules, data blocks or variables.

#### Conditional creation of objects

In situations where the same module is used across multiple environments, it's common
to see that some necessary object already exists in some environments but needs to be
created in other environments.

Rather than trying to write a module that itself tries to detect whether something
exists and create it if not, we recommend applying the dependency inversion approach:
making the module accept the object it needs as an argument, via an input variable.

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

- Modules must use [Semantic Versioning](https://semver.org/). Versions need to
  be set via git tags on the version control system.
- The module must follow the 3 part
  [module naming convention](#module-naming-convention).
- The module must follow the
  [standard module structure](#standard-module-structure).
- Public modules must be on GitHub and the repo must be a public.

## [terraform-docs](https://github.com/terraform-docs/terraform-docs)

A utility to generate documentation from Terraform modules in various output formats.

The simplest case creates a `README.md` with tables for requirements,
providers, input variables and output variables:

```
terraform-docs markdown table --output-file README.md .
```
