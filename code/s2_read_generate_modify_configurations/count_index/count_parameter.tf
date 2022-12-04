# Create two identical instances
resource "aws_instance" "instance" {
  ami           = "ami-082b5a644766e0e6f"
  instance_type = "t2.micro"
  count         = 2
}

# Create 3 iam users and use the count.index in their names
resource "aws_iam_user" "users" {
  count = 3
  name  = "user-${count.index}"
}

# We can make a list to index with the count.index value!
variable "iam_names" {
  type    = list(any)
  default = ["foo", "bar", "baz"]
}

resource "aws_iam_user" "better-users" {
  count = 3
  name  = "user-${var.iam_names[count.index]}"
}
