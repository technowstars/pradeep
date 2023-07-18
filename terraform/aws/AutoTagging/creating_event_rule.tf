#creating event rule
resource "aws_cloudwatch_event_rule" "auto_tag_event_rule" {
  name        = "auto_tag_event_rule_tf247"
  description = "Capture each AWS Console Sign In"

  event_pattern = <<EOF
{
  "source": ["aws.ec2","aws.s3"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["ec2.amazonaws.com","s3.amazonaws.com"],
    "eventName": ["RunInstances","CreateBucket"]
  }
}
EOF
}


# attaching target

resource "aws_cloudwatch_event_target" "auto_tag_cw_target" {
  rule      = aws_cloudwatch_event_rule.auto_tag_event_rule.name
  target_id = "Lambda"
  arn = aws_lambda_function.auto_tag_lambda_fun.arn
  
}