provider "aws" {
  profile = "aishwarya"
  region  = "eu-central-1"
}
# resource "aws_ecs_cluster" "foo" {
#   name = "white-hart"

#   setting {
#     name  = "containerInsights"
#     value = "enabled"
#   }
# }
# resource "aws_ecr_repository" "foo" {
#   name                 = "awsbatch/fetch_and_run"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = true
#   }
# }