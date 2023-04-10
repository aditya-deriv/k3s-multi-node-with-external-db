resource "aws_key_pair" "nodes_key_pair" {
  key_name   = "k3s-nodes-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCjmEgZzzSaPXVAy65cFvvwhWORG736+WUtlJUzLZ1IvA2vuGzLpEoplJHBGlHY03n/YhCAv23HzlXMvsdbvwobvwm="
}
