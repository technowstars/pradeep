resource "aws_batch_job_queue" "test_queue" {
  name     = "test-terraform-job-queue"
  state    = "ENABLED"
  priority = 100
  compute_environments = [
    aws_batch_compute_environment.aws-batch-compute_environments.arn,

  ]
}