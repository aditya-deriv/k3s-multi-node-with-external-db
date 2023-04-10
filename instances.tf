resource "aws_instance" "k3s-bastion" {
  ami                    = data.aws_ami.debian_amd64.id
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.nodes_key_pair.key_name
  monitoring             = true
  subnet_id              = aws_subnet.public-subnet.id
  vpc_security_group_ids = [aws_security_group.k3s-bastion-sg.id]
  tags                   = { Name = "k3s-bastion" }
  depends_on             = [aws_subnet.public-subnet]
}

resource "aws_instance" "k3s-db" {
  ami                         = data.aws_ami.debian_amd64.id
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  user_data                   = data.template_file.db_user_data.rendered
  key_name                    = aws_key_pair.nodes_key_pair.key_name
  monitoring                  = true
  subnet_id                   = aws_subnet.private-subnet.id
  vpc_security_group_ids      = [aws_security_group.k3s-db-sg.id]
  tags                        = { Name = "k3s-db" }
  depends_on                  = [aws_nat_gateway.nat-gw]
}

resource "aws_instance" "k3s-master-1" {
  ami                         = data.aws_ami.debian_amd64.id
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  user_data                   = data.template_file.master_1_user_data.rendered
  key_name                    = aws_key_pair.nodes_key_pair.key_name
  monitoring                  = true
  subnet_id                   = aws_subnet.private-subnet.id
  vpc_security_group_ids      = [aws_security_group.k3s-master-sg.id]
  tags                        = { Name = "k3s-master-1" }
  depends_on                  = [aws_instance.k3s-db]
}

resource "aws_instance" "k3s-master-2" {
  ami                         = data.aws_ami.debian_amd64.id
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  user_data                   = data.template_file.master_2_user_data.rendered
  key_name                    = aws_key_pair.nodes_key_pair.key_name
  monitoring                  = true
  subnet_id                   = aws_subnet.private-subnet.id
  vpc_security_group_ids      = [aws_security_group.k3s-master-sg.id]
  tags                        = { Name = "k3s-master-2" }
  depends_on                  = [aws_instance.k3s-master-1]
}

resource "aws_instance" "k3s-lb" {
  ami                         = data.aws_ami.debian_amd64.id
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  private_ip                  = "10.0.1.10"
  user_data                   = data.template_file.lb_user_data.rendered
  key_name                    = aws_key_pair.nodes_key_pair.key_name
  monitoring                  = true
  subnet_id                   = aws_subnet.private-subnet.id
  vpc_security_group_ids      = [aws_security_group.k3s-lb-sg.id]
  tags                        = { Name = "k3s-lb" }
  depends_on                  = [aws_instance.k3s-master-2]
}

resource "aws_instance" "k3s-worker-1" {
  ami                         = data.aws_ami.debian_amd64.id
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  user_data                   = data.template_file.worker_1_user_data.rendered
  key_name                    = aws_key_pair.nodes_key_pair.key_name
  monitoring                  = true
  subnet_id                   = aws_subnet.private-subnet.id
  vpc_security_group_ids      = [aws_security_group.k3s-worker-sg.id]
  tags                        = { Name = "k3s-worker-1" }
  depends_on                  = [aws_instance.k3s-lb]
}

resource "aws_instance" "k3s-worker-2" {
  ami                         = data.aws_ami.debian_amd64.id
  associate_public_ip_address = false
  instance_type               = "t2.micro"
  user_data                   = data.template_file.worker_2_user_data.rendered
  key_name                    = aws_key_pair.nodes_key_pair.key_name
  monitoring                  = true
  subnet_id                   = aws_subnet.private-subnet.id
  vpc_security_group_ids      = [aws_security_group.k3s-worker-sg.id]
  tags                        = { Name = "k3s-worker-2" }
  depends_on                  = [aws_instance.k3s-worker-1]
}
