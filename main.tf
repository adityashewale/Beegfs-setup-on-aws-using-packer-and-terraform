provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "beegfs-setup" {
  ami           = "ami-0ed5a4fdd2efdcba2"
  instance_type = "t2.micro"

  tags = {
    Name = "beegfs setup client and server"
  }
}
