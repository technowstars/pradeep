resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs_instance_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  name = "ecs_instance_role"
  role = aws_iam_role.ecs_instance_role.name
}

resource "aws_iam_role" "aws_batch_service_role" {
  name = "aws_batch_service_role"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "batch.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  role       = aws_iam_role.aws_batch_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

# resource "aws_security_group" "sample" {
#   name = "aws_batch_compute_environment_security_group"


#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


# resource "aws_vpc" "sample" {
#   cidr_block = "10.1.0.0/16"

# }
data "aws_vpc" "default" {
  default = true
}
# Retrieves the subnet ids in the default vpc
data "aws_subnet_ids" "all_default_subnets" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "security_group" {
  name        = "compute_environmentsecurity_group"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "EC2 Security Group"
  }
}
# resource "aws_default_subnet" "default_az1" {
#   availability_zone = "eu-central-1"

#   tags = {
#     Name = "Default subnet for eu-central-1"
#   }
# }
# }
# resource "aws_subnet" "sample" {
#   vpc_id     = aws_vpc.sample.id
#   cidr_block =  "10.1.1.0/24"
#   tags = {
#     Name = "sample"
#   }


# resource "aws_subnet" "sample" {
#  # name = "compute_subnet"
#   vpc_id     = aws_vpc.sample.id
#   cidr_block = "10.1.1.0/24"
#   map_public_ip_on_launch = true
# }


resource "aws_batch_compute_environment" "aws-batch-compute_environments" {
  compute_environment_name = "aws-batch-compute_environments"

  compute_resources {
    instance_role = aws_iam_instance_profile.ecs_instance_role.arn

    instance_type = [
      "optimal",
    ]

    max_vcpus     = 4
    min_vcpus     = 0
    desired_vcpus = 1

    security_group_ids = [
      aws_security_group.security_group.id,
    ]

    subnets = data.aws_subnet_ids.all_default_subnets.ids

    type = "EC2"
  }

  service_role = aws_iam_role.aws_batch_service_role.arn
  type         = "MANAGED"
  depends_on   = [aws_iam_role_policy_attachment.aws_batch_service_role]
}
