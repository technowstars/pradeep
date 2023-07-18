# creating role for cloud trail

resource "aws_iam_role" "auto_tag_cloud_trail_role" {
  name = "auto_tag_cloud_trail_role_tf247"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
  })
  
}

# creating policy for role

resource "aws_iam_role_policy" "auto_tag_role_policy" {
  name = "auto_tag_role_policy_tf247"
  role = aws_iam_role.auto_tag_cloud_trail_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    "Statement": [
        {
            "Sid": "AWSCloudTrailCreateLogStream2014110",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream"
            ],
            "Resource": [
                "arn:aws:logs:eu-central-1:013833933065:log-group:${aws_cloudwatch_log_group.auto_tag_cloudWatch_log.id}:*"
            ]
        },
        {
            "Sid": "AWSCloudTrailPutLogEvents20141101",
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:eu-central-1:013833933065:log-group:${aws_cloudwatch_log_group.auto_tag_cloudWatch_log.id}:*"
            ]
        }
    ]
  })
}


resource "aws_cloudtrail" "auto_tag_cloudTrail" {
  name                          = "auto_tag_cloudTrail_tf247"
  enable_logging = true
  s3_bucket_name                = aws_s3_bucket.auto-tag-s3-bucket.id
  s3_key_prefix                 = "prefix"
  cloud_watch_logs_role_arn = "${aws_iam_role.auto_tag_cloud_trail_role.arn}"
  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.auto_tag_cloudWatch_log.arn}:*"
  include_global_service_events = false

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

}

# creating cloud watch log group
resource "aws_cloudwatch_log_group" "auto_tag_cloudWatch_log" {
  name = "auto_tag_cloudWatch_log_tf247"
}

