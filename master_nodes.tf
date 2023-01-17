resource "aws_instance" "k3s-master-1" {
  ami                    = data.aws_ami.debian_amd64.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.nodes_key_pair.key_name
  monitoring             = true
  subnet_id              = data.aws_subnet.nodes.id
  vpc_security_group_ids = [aws_security_group.k3s-master-sg.id]
  tags                   = { Name = "k3s-master-1" }
}


resource "aws_instance" "k3s-master-2" {
  ami                    = data.aws_ami.debian_amd64.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.nodes_key_pair.key_name
  monitoring             = true
  subnet_id              = data.aws_subnet.nodes.id
  vpc_security_group_ids = [aws_security_group.k3s-master-sg.id]
  tags                   = { Name = "k3s-master-2" }
}
