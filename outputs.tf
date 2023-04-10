
output "k3s-db_private_ip" {
  value = aws_instance.k3s-db.private_ip
}

output "k3s-master-1_private_ip" {
  value = aws_instance.k3s-master-1.private_ip
}

output "k3s-master-2_private_ip" {
  value = aws_instance.k3s-master-2.private_ip
}

output "k3s-lb_private_ip" {
  value = aws_instance.k3s-lb.private_ip
}

output "k3s-worker-1_private_ip" {
  value = aws_instance.k3s-worker-1.private_ip
}

output "k3s-worker-2_private_ip" {
  value = aws_instance.k3s-worker-2.private_ip
}

output "k3s-bastion_public_ip" {
  value = aws_instance.k3s-bastion.public_ip
}
output "k3s-bastion_private_ip" {
  value = aws_instance.k3s-bastion.private_ip
}
