

# resource "aws_batch_job_definition" "test" {
#   name = "aws-batch-jobdefination"
#   type = "container"
#   platform_capabilities = [
#     "FARGATE",
#   ]

#   container_properties = <<CONTAINER_PROPERTIES
# {
#   "command": ["mapjob.sh", "60"],
#   "image": "013833933065.dkr.ecr.eu-central-1.amazonaws.com/python",
#   "fargatePlatformConfiguration": {
#     "platformVersion": "LATEST"
#   },
#   "resourceRequirements": [
#      {"type": "VCPU", "value": "0.25"},
#     {"type": "MEMORY", "value": "512"}
#   ],
#   "executionRoleArn": "${aws_iam_role.ecs_instance_role.arn}"
# }
# CONTAINER_PROPERTIES
# }


resource "aws_batch_job_definition" "test" {
  name = "aws_batch_job_definition"
  type = "container"

  container_properties = <<CONTAINER_PROPERTIES
{
    "command": [],
    "image": "abhi2305/febonacci_batch",
    "resourceRequirements": [
    {"type": "VCPU", "value": "1"},
    {"type": "MEMORY", "value": "256"}
  ],
    "volumes": [
      {
        "host": {
          "sourcePath": "/tmp"
        },
        "name": "tmp"
      }
    ],
    "environment": [
        {"name": "FOO", "value": "60"},
        {"name": "BATCH_FILE_TYPE","value": "script"},
        {"name": "BATCH_FILE_S3_URL","value": "s3://aws-batch-job-s3-bucket/mapjob.sh"}
    ],
    "mountPoints": [
        {
          "sourceVolume": "tmp",
          "containerPath": "/tmp",
          "readOnly": false
        }
    ],
    "ulimits": [
      {
        "hardLimit": 1024,
        "name": "nofile",
        "softLimit": 1024
      }
    ],
    "executionRoleArn": "arn:aws:iam::013833933065:role/ecsTaskExecutionRole"
    
}
CONTAINER_PROPERTIES
}