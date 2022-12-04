# Variables to use as conditionals for example
variable "owner" {
  type = string
}

locals {
  dev = {
    tags = {
      owner = var.owner
      env   = "dev"
    }
    instance_type = "t2.nano"
  }
  prod = {
    tags = {
      # Useful to create values from conditionals!
      owner = var.owner == "tom" ? "maybe tom" : var.owner
      env   = "prod"
    }
    instance_type = "t2.micro"
  }
}

# You can probably do this with an iterator over the map anyway
resource "aws_instance" "dev" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = local.dev.instance_type
  tags          = local.dev.tags
}

resource "aws_instance" "prod" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = local.prod.instance_type
  tags          = local.prod.tags
}
