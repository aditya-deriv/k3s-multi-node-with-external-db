resource "null_resource" "k3s_db_provisioner" {

  # ssh into the k3s-db node
  connection {
    type        = "ssh"
    user        = "admin"
    private_key = file("${path.module}/id_rsa")
    host        = aws_instance.k3s-db.public_ip
    timeout     = "1m"
  }

  # Provision the script using the template
  provisioner "file" {
    content = templatefile("${path.module}/scripts/db_init.tftpl", {
      k3s_master_1_private_ip = aws_instance.k3s-master-1.private_ip,
      k3s_master_2_private_ip = aws_instance.k3s-master-2.private_ip,
      k3s_worker_1_private_ip = aws_instance.k3s-worker-1.private_ip,
      k3s_worker_2_private_ip = aws_instance.k3s-worker-2.private_ip,
      k3s_lb_private_ip       = aws_instance.k3s-lb.private_ip,
      k3s_db_private_ip       = aws_instance.k3s-db.private_ip
    })
    destination = "/home/admin/db_node_setup.sh"
  }

  # Execute the script to setup DB
  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname k3s-db",
      "sudo sed -i '/- update_etc_hosts/d' /etc/cloud/cloud.cfg",
      "sudo mv /home/admin/db_node_setup.sh /opt/db_node_setup.sh",
      "chmod +x /opt/db_node_setup.sh",
      "bash -x /opt/db_node_setup.sh"
    ]
  }

}
