# Terraform cloud

## [Overview](https://developer.hashicorp.com/terraform/cloud-docs/overview)

### Common features

- Remote state management instead of using other `backend` types. Allows for storing multiple timestamped state files.
  This is helpful especially for rolling back to past states if some state file manipulation is not successful.
- Access state from other workspaces using terraform cloud data sources.
- Remove execution of terraform scripts on terraform cloud agents.
- VCS integration on pull requests, creating speculative plans when PRs are opened and displaying plan on the PR page.
- Private module registry of private and public modules and providers. These are versioned using tags and SEMER.
- Integrations for sending notifications, a full API for managing cloud workspaces and more, task runners for
  external systems during provisioning cycle.
- Variable sets: Groups of variables that can be mapped to multiple workspaces.

### Additional paid features

- Self hosted cloud agents.
- Cost estimation: Display costs during plan stage.
- Access control and governance: using team assignments and team based permissions.
- Policy control: Define and enforce policy-as-code using Sentinel or OPA frameworks to ensure resources are
  provisioned according to your governance principles (such as limiting VM sizes).

### [Workspaces](https://developer.hashicorp.com/terraform/cloud-docs/workspaces)

A workspace contains:

- A series of timestamped state versions
- A history of run history, including summaries, logs, etc.
- variables:
  - Environment variables: those set in the terraform agent remote shell
  - Terraform variables: those that are used in `variable` blocks
  - Secrets stored as variables in a write-only format
- Workspace projects, tags, status metadata for governance purposes such as workspace grouping and filtering
- A workflow, one of:
  - Version control: integrate with a repository and pull requests
  - CLI-driven: Remote runs triggered from CLI
  - API-driven: Integrate with the terraform API

### [Projects](https://developer.hashicorp.com/terraform/tutorials/cloud/projects)

Terraform Cloud projects exist to organise workspaces according to an organisation's resource usage and ownership patterns
such teams, business units, or services. Projects additionally assist to manage workspace permissions as group access
can be granted directly to a project.

### [Private registry](https://developer.hashicorp.com/terraform/registry/private)

Terraform Cloud has a private registry capability so that custom providers and modules can be securely and easily shared
across a company. Providers or modules can be imported from ADO/Github/Gitlab and support versioning, unlike loading a module
directly from a version control source where it uses the latest commit from a branch.

## CLI configuration

Terraform Cloud can be configured for CLI usage with `cloud {}` block in the `terraform {}` block such as:

```terraform
terraform {

  cloud {
    organization = "EXPLORE-CORE"

    workspaces {
      tags = ["foo"]
    }
  }

  ...
```

## [Terraform enterprise](https://developer.hashicorp.com/terraform/enterprise)

- Terraform Enterprise is a self-hosted distribution of Terraform Cloud with no resource limits and with additional
  enterprise-grade architectural features like audit logging and SAML single sign-on.
- It can be installed and used on a fully air-gapped network if required.
