# Deploying infra with terraform

## TLDR commands

```
terraform init
```
Fetch required plugins

```
terraform plan
```
Determine how the state would change based on current IAC changes compared to
what is defined on provider.

```
terraform apply
```
Plan and apply changes. You can also specify targets with `-target` option.

```
terraform destroy
```
Destroy all remote objects managed by a particular Terraform configuration. You
can also specify targets with `-target` option.

```
terraform refresh
```
Reads the current settings from all managed remote objects and updates the Terraform state to match.
This is typically performed as the first step in many of the above commands.

## Launch EC2 instance

See [aws docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs).

Steps to creating `first_ec2.md`:

1. Create user for `terraform` with `Administrators` group (already set up)
2. Download keys and set up `.aws/` directory like you would for AWSCLI
3. Get init provider code from main docs, set up to use `.aws` credentials
4. Add `data` for AMI, it searches the region's AMI registry for a specific user
   ID and value string with wildcard
5. Create `aws_instance` resource using the AMI ID, name and instance type
6. Check plan wiith `terraform plan`
7. Apply state with `terraform apply`
8. Kill off VM after with `terraform destroy`

## Resources, providers and modules

### Providers

Providers are the plugins that Terraform uses to manage those resources. Every supported service or infrastructure platform has a provider that defines which resources are available and performs API calls to manage those resources.

This can range from cloud providers like AWS to devops services like Github to frameworks like Kubernetes that
can be self hosted.

When you add a new provider, run `terraform init` to fetch all required plugins
with specified versions.

Terraform registry contains both official providers maintained by HashiCorp and community providers!

Note that different providers will have different methods of authentication, and
this usually is due to IAM differences between each provider.

#### Provider architecture

Terraform scripts code is interpreted by terraform that uses provider plugins to interact with the udnerlying
provider services. These interactions will include getting state or actioning tf
scripts on the provider services.

This is done via some API or SDK, such as boto, Azure CLI, etc.

#### Provider versioning

Plugins are versioned separately to terraform and new versions may be published
to work with updated provider APIs.

Versions can be set using constrants of the form:

- `>= x.y`: Greater than equal to `x.y`
- `<= x.y`: Less than or equal to `x.y`
- `~>x.0`: Any version in `x.y` range
- `>=x.y,<=a.b`: Any version between `x.y` and `a.b`

Terraform uses a lock file system where provider version, URL, the constraint
and file hashes called `.terraform.lock.hcl`. If you change the provider version
to something that doesn't contain the lock file version, it will throw and error
if you init or try use it. You can get a compatible version by running:

```
terraform init -upgrade
```

When running init, it will default to using the latest version matching the
constraint.

### Resources

Resources are the individual services offered by the provider.

#### Resource naming

Names will be created by `<resource_type>.<resource_name>`. E.g.

```
resource "aws_instance" "foo" {
...
}
```
will have a target name of `aws_instance.foo`.

### Modules

Modules are reusable Terraform configurations that can be called and configured by other configurations.
Most modules manage a few closely related resources from a single provider. 

## Terraform state

Terraform must store state about your managed infrastructure and configuration. This state is used by
Terraform to map real world resources to your configuration, keep track of metadata, and to improve
performance for large infrastructures.

This state is stored by default in a local JSON file named `terraform.tfstate`, but it can also be stored
remotely, which works better in a team environment. For the most part, don't manually modify this file.

The `resources` list contains, for each resource, all values specified by the
user as well as all the defaults which were auto filled by the provider.

Plan, destroy and apply commands will refresh state before doing anything else.

### States

- Desired state: the state that the code implies
- Current state: the actual deployed state as per the state file
- Plan: State changes required to get from current state to desired state

### Weird behaviours

Weird things can happen if you modify configurations on the website. One case is
that if you change something from a default value that was not specified in
code, terraform will not change it back to the default later on. This is because
it was not specified! If you were to hard code the default and then modify it on
the interface, it will revert the changes to the specified default.

TLDR: The more verbose the terraform code, the more robust it will be to these
permutations.

Or just don't change things on the interface ever.
