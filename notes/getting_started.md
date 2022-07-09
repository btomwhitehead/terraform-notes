# Getting started

## Choosing IAC tools

### Infrastructure orchestration vs configuration management

#### Infrastructure orchestration

Primary role is to provision cloud resources.

Examples inlude Terraform, CloudFormation

#### Config management

Primary role is to install and manage software on existing servers.

Examples include SaltStack, Anisible, Chef, etc.

Some config management software can also do some infrastructure management, but
it is not the primary goal and often limited in this regard.

#### Integration of config and infrastructure orchestration tools

Some work well together! TODO

### Important considerations

1. Is your infrastructure going to be vendor specific in long term?
2. Are you planning to have a multicloud / hybrid infrastructure?
3. How well does it integrate with existing config management tools?
4. Price and support?

## Installation

See [Terraform downloads](https://www.terraform.io/downloads).
