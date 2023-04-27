variable "private_subnet_id" {}
variable "k3s_db_private_ip" {}
variable "ami_id" {}
variable "key_name" {}
variable "k3s_master_nodes_token" {}
variable "master_count" {}

resource "aws_instance" "k3s-master" {
  ami                         = var.ami_id
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  count                       = var.master_count
  user_data                   = data.template_file.master_user_data.rendered
  key_name                    = var.key_name
  monitoring                  = true
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.k3s-master-sg.id]
  tags                        = { Name = "k3s-master-${count.index}" }
}

data "template_file" "master_user_data" {
  template = file("scripts/master_init.sh")

  vars = {
    k3s_master_nodes_token = var.k3s_master_nodes_token,
    k3s_db_private_ip      = var.k3s_db_private_ip
  }
}

output "k3s-master_private_ip" {
  value = aws_instance.k3s-master.*.private_ip
}
