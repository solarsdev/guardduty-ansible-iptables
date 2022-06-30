
resource "aws_security_group" "ansible" {
  name        = "${var.service_name_lowercase}.ansible.sg"
  description = "Ansible server security group"
  vpc_id      = aws_vpc.main.id

  lifecycle {
    create_before_destroy = true
  }

  ingress {
    description = "All traffic from Worker IP"
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = "${var.worker_ip}/32"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.default_tags, {
    Name = "${var.service_name_lowercase}.ansible.sg"
  })
}
