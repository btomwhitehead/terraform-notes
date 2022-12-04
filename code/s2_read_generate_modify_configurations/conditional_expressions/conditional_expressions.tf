# Declare variable

variable "is_prod" {
  type = bool
}

# This is definitely not a good idea but it illustrates the point
# Create 3 instances if is_prod false 
#
# Expression is of the form:
# <condition> ? <true_value> : <false_value>
resource "aws_instance" "dev" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = "t2.nano"
  count = var.is_prod == false ? 1 : 0
}

resource "aws_instance" "prod" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = "t2.micro"
  count = var.is_prod == true ? 2 : 0
}
