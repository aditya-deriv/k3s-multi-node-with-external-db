resource "aws_instance" "k3s-db" {
  ami                    = data.aws_ami.debian_amd64.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.nodes_key_pair.key_name
  monitoring             = true
  subnet_id              = data.aws_subnet.nodes.id
  vpc_security_group_ids = [aws_security_group.k3s-db-sg.id]
  tags                   = { Name = "k3s-db" }
}