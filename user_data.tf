resource "random_uuid" "master_node_token" {}

data "template_file" "db_user_data" {
  template = file("${path.module}/scripts/db_init.sh")
}

data "template_file" "master_1_user_data" {
  template = file("${path.module}/scripts/master_1_init.sh")

  vars = {
    k3s_master_nodes_token = random_uuid.master_node_token.result,
    k3s_db_private_ip      = aws_instance.k3s-db.private_ip
  }
}

data "template_file" "master_2_user_data" {
  template = file("${path.module}/scripts/master_2_init.sh")

  vars = {
    k3s_master_nodes_token = random_uuid.master_node_token.result,
    k3s_db_private_ip      = aws_instance.k3s-db.private_ip
  }
}

data "template_file" "lb_user_data" {
  template = file("${path.module}/scripts/lb_init.sh")

  vars = {
    k3s_master_1_private_ip = aws_instance.k3s-master-1.private_ip,
    k3s_master_2_private_ip = aws_instance.k3s-master-2.private_ip
  }
}

data "template_file" "worker_1_user_data" {
  template = file("${path.module}/scripts/worker_1_init.sh")

  vars = {
    k3s_lb_private_ip      = aws_instance.k3s-lb.private_ip,
    k3s_master_nodes_token = random_uuid.master_node_token.result
  }
}

data "template_file" "worker_2_user_data" {
  template = file("${path.module}/scripts/worker_2_init.sh")

  vars = {
    k3s_lb_private_ip      = aws_instance.k3s-lb.private_ip,
    k3s_master_nodes_token = random_uuid.master_node_token.result
  }
}
