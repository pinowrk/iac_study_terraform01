
resource "aws_instance" "this" {
  ami           = "ami-04ca38f0293e74e57"
  instance_type = "t2.micro"

  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.this.id]
  associate_public_ip_address = true

  user_data                   = file("${path.module}/user_data.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "iac-study-terraform01-ec2"
  }
}

resource "random_id" "this" {
  byte_length = 8
}

data "aws_subnet" "this" {
  id = var.subnet_id
}

resource "aws_security_group" "this" {
  vpc_id = data.aws_subnet.this.vpc_id
  name   = "iac-study-terraform01-ec2-sg-${random_id.this.hex}"
}

resource "aws_security_group_rule" "ssh" {
  count = var.allow_ssh ? 1 : 0

  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

#########################################################
## HTTPのSGは双方向依存回避のため、
## ソースをALBのSG IDに指定するためALB側に記載
#########################################################
