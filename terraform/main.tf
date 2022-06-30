resource "aws_eip" "control" {
  instance = aws_instance.control.id
  vpc      = true

  tags = merge(var.default_tags, {
    Name = "${var.service_name_lowercase}.control.eip"
  })
}

resource "aws_instance" "control" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = "t3.small"
  subnet_id              = aws_subnet.public-a.id
  key_name               = aws_key_pair.acloudguru.key_name
  vpc_security_group_ids = [aws_security_group.ansible.id]
  user_data_base64       = filebase64("userdata.sh")
  iam_instance_profile   = aws_iam_instance_profile.control.id

  tags = merge(var.default_tags, {
    Name = "${var.service_name_lowercase}.control.ec2"
  })

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    iops                  = "3000"
    throughput            = "125"
    volume_size           = "8"
    volume_type           = "gp3"

    tags = merge(var.default_tags, {
      Name = "${var.service_name_lowercase}.control.ebs"
    })
  }

  lifecycle {
    ignore_changes = [
      user_data_base64,
    ]
  }
}
