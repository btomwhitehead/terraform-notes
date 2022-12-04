# Define variables in centralised file
# reference variables in other scripts as
# var.<variable name>
#
# Note the default can be overrided by another definition at command line
# with option -var var_name=value
#
# If no default is supplied, it will ask at command line
#
# Also: defaults can be overridden in terraform.tfvars
variable "vpn_cidr" {
  default = "116.50.30.50/32"
}
