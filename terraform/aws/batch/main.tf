resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name             = "TestTable2"
  hash_key         = "jobID"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "jobID"
    type = "S"
  }
}
#s3
resource "aws_s3_bucket" "batch" {
  bucket = "aws-batch-job-s3-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }
}
