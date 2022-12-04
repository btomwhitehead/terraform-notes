# Read from aws_ami data source
# For a specific image owner ("amazon" in this case)
# Get IDs associated with the wildcard values in filter
# Select the most recent ID form the list (most_recent = true)
data "aws_ami" "app_ami" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "instance-1" {
    ami = data.aws_ami.app_ami.id
   instance_type = "t2.micro"
}

# Additional filters info:
# https://docs.aws.amazon.com/cli/latest/reference/ec2/describe-instances.html#options
