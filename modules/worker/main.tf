variable "private_subnet_id" {}
variable "k3s_lb_private_ip" {}
variable "ami_id" {}
variable "key_name" {}
variable "k3s_master_nodes_token" {}
variable "worker_count" {}

resource "aws_instance" "k3s-worker" {
  ami                         = var.ami_id
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  count                       = var.worker_count
  user_data                   = data.template_file.worker_user_data.rendered
  key_name                    = var.key_name
  monitoring                  = true
  subnet_id                   = var.private_subnet_id
  vpc_security_group_ids      = [aws_security_group.k3s-worker-sg.id]
  tags                        = { Name = "k3s-worker-${count.index}" }
}

data "template_file" "worker_user_data" {
  template = file("scripts/worker_init.sh")

  vars = {
    k3s_lb_private_ip      = var.k3s_lb_private_ip,
    k3s_master_nodes_token = var.k3s_master_nodes_token
  }
}

output "k3s-worker_private_ip" {
  value = aws_instance.k3s-worker.*.private_ip
}
