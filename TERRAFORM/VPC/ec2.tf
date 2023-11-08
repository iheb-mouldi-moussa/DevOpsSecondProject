/*data "aws_ami" "instance" {
  most_recent = "true"
  owners = ["ubuntu"]

  filter {
    name   = "name"
    values = [""]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
*/
resource "aws_security_group" "SG-Servers" {
  vpc_id = aws_vpc.main_vpc.id
  name = "serversSG"
  dynamic "ingress" {
    for_each = [0]
    iterator = port
    content {
      from_port = port.value
      to_port = port.value
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    for_each = [0]
    iterator = port
    content {
      from_port = port.value
      to_port = port.value
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_key_pair" "ServersKey" {
  public_key = file(var.path_to_key)
  key_name = var.key_name

}

resource "aws_instance" "Server" {
  ami = "ami-00983e8a26e4c9bd9"
  instance_type = "t2.micro"
  key_name = aws_key_pair.ServersKey.key_name
  security_groups = [aws_security_group.SG-Servers.id]
  subnet_id = aws_subnet.main_public_subnet.id
  vpc_security_group_ids = [aws_security_group.SG-Servers.id]
  for_each = toset(["Jenkins_Master", "Ansible_Server", "Jenkins_Slave"])
  tags = {
    Name = each.key
  }
}