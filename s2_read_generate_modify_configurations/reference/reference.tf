provider "aws" {
  region     = "us-west-2"
}

resource "aws_instance" "myec2" {
   ami = "ami-082b5a644766e0e6f"
   instance_type = "t2.micro"
}

# Create an elastic IP
resource "aws_eip" "lb" {
  vpc      = true
}

# get the instance id and associate it with the elastic IP
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.myec2.id
  allocation_id = aws_eip.lb.id
}

resource "aws_security_group" "allow_tls" {
  name        = "kplabs-security-group"

  # Note you need to speficy ingress and egress if needed
  # #idr blocks need to include a subnet - not just up
  # So we need to do some string interpolation to add it
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.lb.public_ip}/32"]
  }
}
