resource "aws_instance" "public_instance" {
  ami           = "ami-0e2031728ef69a466"
  instance_type = "t2.micro"
  #vpc_security_group_ids = "${aws_security_group.aws_batch_compute_environment_security_group.id}"
  #Ssubnet_id = aws_subnet.sample.id
  associate_public_ip_address = true
  tags = {
    Name = "Batch-job"
  }
  user_data = <<EOF
#!/bin/bash
sudo su
yum install -y docker
systemctl status docker
systemctl start docker
docker version
EOF
}
