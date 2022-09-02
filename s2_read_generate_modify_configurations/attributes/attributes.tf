# Attributes are essentially properties of resources - you can see all in
# tfstate
#
# Outputs are a way to return attribute values like return statements in other
# languages.

provider "aws" {
  region     = "us-west-2"
  profile = "terraform"
}

resource "aws_eip" "lb" {
  vpc      = true
}

output "eip" {
  value = aws_eip.lb.public_ip
}

resource "aws_s3_bucket" "mys3" {
  bucket = "btomwhitehead-test-012"
}

output "mys3bucket" {
  value = aws_s3_bucket.mys3.bucket_domain_name
}

# Outputs:
# 
# eip = "54.70.11.11"
# mys3bucket = "btomwhitehead-test-012.s3.amazonaws.com"
#
# In general see: providers:resource:attribute reference for a list of attributes
# to return via output.
