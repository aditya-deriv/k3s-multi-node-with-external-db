resource "random_uuid" "master_node_token" {}

resource "null_resource" "k3s_master_1_provisioner" {

  triggers = {
    order = null_resource.k3s_lb_provisioner.id
  }

  # ssh into the k3s-master-1 node
  connection {
    type        = "ssh"
    user        = "admin"
    private_key = file("${path.module}/id_rsa")
    host        = aws_instance.k3s-master-1.public_ip
    timeout     = "1m"
  }

  # Provision the script using the template
  provisioner "file" {
    content = templatefile("${path.module}/scripts/master_init.tftpl", {
      k3s_master_nodes_token  = random_uuid.master_node_token.result,
      k3s_master_1_private_ip = aws_instance.k3s-master-1.private_ip,
      k3s_master_2_private_ip = aws_instance.k3s-master-2.private_ip,
      k3s_worker_1_private_ip = aws_instance.k3s-worker-1.private_ip,
      k3s_worker_2_private_ip = aws_instance.k3s-worker-2.private_ip,
      k3s_lb_private_ip       = aws_instance.k3s-lb.private_ip,
      k3s_db_private_ip       = aws_instance.k3s-db.private_ip
    })
    destination = "/home/admin/master_node_setup.sh"
  }

  # Execute the script to setup k3s
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname k3s-master-1",
      "sudo sed -i '/- update_etc_hosts/d' /etc/cloud/cloud.cfg",
      "sudo mv /home/admin/master_node_setup.sh /opt/master_node_setup.sh",
      "chmod +x /opt/master_node_setup.sh",
      "bash -x /opt/master_node_setup.sh"
    ]
  }

}

resource "null_resource" "k3s_master_2_provisioner" {

  triggers = {
    order = null_resource.k3s_master_1_provisioner.id
  }

  # ssh into the k3s-master-2 node
  connection {
    type        = "ssh"
    user        = "admin"
    private_key = file("${path.module}/id_rsa")
    host        = aws_instance.k3s-master-2.public_ip
    timeout     = "1m"
  }

  # Provision the script using the template
  provisioner "file" {
    content = templatefile("${path.module}/scripts/master_init.tftpl", {
      k3s_master_nodes_token  = random_uuid.master_node_token.result,
      k3s_master_1_private_ip = aws_instance.k3s-master-1.private_ip,
      k3s_master_2_private_ip = aws_instance.k3s-master-2.private_ip,
      k3s_worker_1_private_ip = aws_instance.k3s-worker-1.private_ip,
      k3s_worker_2_private_ip = aws_instance.k3s-worker-2.private_ip,
      k3s_lb_private_ip       = aws_instance.k3s-lb.private_ip,
      k3s_db_private_ip       = aws_instance.k3s-db.private_ip
    })
    destination = "/home/admin/master_node_setup.sh"
  }

  # Execute the script to setup k3s
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname k3s-master-2",
      "sudo sed -i '/- update_etc_hosts/d' /etc/cloud/cloud.cfg",
      "sudo mv /home/admin/master_node_setup.sh /opt/master_node_setup.sh",
      "chmod +x /opt/master_node_setup.sh",
      "bash -x /opt/master_node_setup.sh"
    ]
  }

}
