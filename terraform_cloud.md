# Terraform cloud

## [Overview](https://developer.hashicorp.com/terraform/cloud-docs/overview)

### Common features

- Remote state management instead of using other `backend` types. Allows for storing multiple timestamped state files. This is helpful especially for
  rolling back to past states if some state file manipulation is not successful.
- Access state from other workspaces using terraform cloud data sources.
- Remove execution of terraform scripts on terraform cloud agents
- VCS integration on pull requests, creating speculative plans when PRs are
  opened and displaying plan on PR page
- Private module registry of private and public modules and providers. These
  are versioned using tags and SEMER
- Integrations for sending notifications, a full API for managing cloud
  workspaces and more, task runners for external systems during provisioning
  cycle
- Variable sets: Groups of variabbles that can be mapped to multiple workspaces

### Additional paid features

- Self hosted cloud agents
- Cost estimation: Display costs during plan stage
- Access control and governance: using team assignments and team based permissions
- Policy control: Define and enforce policy-as-code using Sentinel or OPA frameworks
  to ensure resources are provisioned according to your governance principles (such as limiting VM sizes)

### [Projects](https://developer.hashicorp.com/terraform/tutorials/cloud/projects)

- Group workspaces into projects
TODO

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
  - API-driven: Integetrate with the terraform API

### [Private registry](https://developer.hashicorp.com/terraform/registry/private)

TODO

## Policy-as-code and Hashicorp Sentinel

## [Terraform enterprise](https://developer.hashicorp.com/terraform/enterprise)

- Terraform Enterprise is a self-hosted distribution of Terraform Cloud with no resource limits and with additional
  enterprise-grade architectural features like audit logging and SAML single sign-on.
- It can be installed and used on a fully air-gapped network if required.

## Debugging tips

- Note how the CLI doesnt show whats hapening on the tf agent
- set an environment type variable on the variables page of a workspace: `TF_LOG`...

See [terraform debugging guide](https://developer.hashicorp.com/terraform/internals/debugging).
