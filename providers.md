# Providers

Terraform relies on plugins called providers to interact with cloud providers, SaaS providers, and other APIs.

Each provider adds a set of resource types and/or data sources that Terraform can manage and most providers
are dedicated to a single infrastructure platform.

Some providers exist to provide utility functions such as generating strings or making API calls.

Providers are versioned and distributed independently of Terraform itself and are commonly distributed through the
[Terraform Registry](https://registry.terraform.io/).

Each provider has its own versioned documentation, describing its resource types and their arguments.

## Provider version

In order to use a provider, a source and version needs to be specified in the `terraform {}` configuration block.
Here we are using the `azurerm` provider.

```terraform
terraform {
  ...

  required_providers {

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.38"
    }

    ...

  }
}
```

All providers are versioned according to [Semantic Versioning](https://semver.org/) and the syntax `~>3.38` means
that any version greater or equal to 3.38 and less than 4.0 is permitted.

## Provider configuration

Provider configurations belong in the root module of a Terraform configuration and all child modules receive their
provider configurations from the root module.

A provider configuration is created using a provider block:

```terraform
provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}
```

Providers also support an `alias` meta argument, if different parts of configuration require different providers.
One use case is deploying to multiple Azure subscriptions, where we use an alias for another subscription:

```terraform
provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_b_id
  alias           = "subscription_b"
}
```

Then we can deploy a resource group into each subscription using the default provider and aliased provider:

```terraform
resource "azurerm_resource_group" "foo" {
  name     = "foo"
  location = "West US"
}

resource "azurerm_resource_group" "bar" {
  name     = "bar"
  location = "West US"
  provider = azurerm.subscription_b
}
```
