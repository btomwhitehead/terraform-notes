# See: https://www.terraform.io/cdktf/concepts/functions
# Note: Does not support user functions!

locals {
  time = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())
}

variable "region" {
  default = "ap-south-1"
}

variable "tags" {
  type = list
  default = ["firstec2","secondec2"]
}

# Create a map of AMI identifiers for a specific image in a given region
variable "ami" {
  type = map
  default = {
    "us-east-1" = "ami-0323c3dd2da7fb37d"
    "us-west-2" = "ami-0d6621c01e8c2de2c"
    "ap-south-1" = "ami-0470e33cd681b2476"
  }
}

resource "aws_key_pair" "loginkey" {
  key_name   = "login-key"
  public_key = file("~/.ssh/id_ed25519.pub")
}

# lookup: Get the correct AMI for the specific region
# element: grab a gag from the list using int index of VM 
resource "aws_instance" "app-dev" {
   ami = lookup(var.ami, var.region)
   instance_type = "t2.micro"
   key_name = aws_key_pair.loginkey.key_name
   count = 2

   tags = {
     Name = element(var.tags, count.index)
   }
}

output "timestamp" {
  value = local.time
}
