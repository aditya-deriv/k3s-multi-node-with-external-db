resource "aws_security_group" "k3s-lb-sg" {
  name        = "k3s-lb-sg"
  description = "HAproxy LB Node SG"
  vpc_id      = data.aws_subnet.nodes.vpc_id

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.public_ip.response_body}/32"]
  }

  ingress {
    description = "Kube-API Server"
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = [data.aws_subnet.nodes.cidr_block]
  }

  ingress {
    description = "ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["${data.http.public_ip.response_body}/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
