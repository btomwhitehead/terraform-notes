# Data sources

Data sources allow Terraform to use information about existing resources defined outside of a Terraform configuration or from local files.

Note, data blocks are executed before resource blocks and so they cannot be used to query information about resources defined in the current configuration.

## [Data blocks](https://developer.hashicorp.com/terraform/language/data-sources#using-data-sources)

A data source is accessed via a data block:

```terraform
data "azurerm_resource_group" "this" {
  name = "some_resource_group_name"
}
```

In the above case, the data block requests that Terraform read from a given data source, `auzrerm_resource_group`, and export the result under the given local, `this`.

The arguments to a data block are defined by the provider. In this instance, we only need to define a single argument, `name`.

## [Local-only data sources](https://developer.hashicorp.com/terraform/language/data-sources#local-only-data-sources)

Most data sources correspond to infrastructure objects, where the data is
queried form an external API. Local-only operate differently as the result
exists temporarily and the values are caculated every time a plan is run.

Two common cases are `local_file` and `template_file` data sources.

### [local_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/data-sources/file)

The `local_file` data source reads a file from the local filesystem.

In the following example a file is read from disk and is uploaded to a key vault:

```terraform
data "local_file" "foo" {
  filename = "${path.module}/foo.bar"
}

resource "azurerm_key_vault_secret" "foo" {
  name         = "foo-bar"
  value        = data.local_file.foo.content
  key_vault_id = azurerm_key_vault.example.id
}
```

Arguments:

- `filename`: Path to the file that will be read.

### [template_file](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file)

The `template_file` data source renders a template from a template string, which is usually loaded from an external file.

```terraform
data "template_file" "this" {
  template = "${file(foo.bar)}"
  vars = {
    foo = "bar"
  }
}
```

Arguments:

- `template`: The contents of the template, as a string using [Terraform template syntax](https://developer.hashicorp.com/terraform/language/expressions#string-templates). It is common practice to use the `file()` function to load the template source from a file.
- `vars`: Optional variables for interpolation within the template. Values must all be primitives datatypes such as `string` and `number`.

## Meta-arguments

Similar to resource blocks, data blocks have a set of meta-argumenrts to simplify configurations. The meta-arguments work similarly to [resource meta-arguments](./resources.md#meta-arguments) with the exception of the `lifecycle` meta-arguement.
