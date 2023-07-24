resource "aws_iam_role" "lambda_role" {
name   = "EC2_start"
assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
resource "aws_iam_policy" "iam_policy_for_lambda" {
 
 name         = "aws_iam_policy_for_EC2_start"
 path         = "/"
 description  = "AWS IAM Policy for managing aws lambda role"
 policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:Start*",
                "ec2:DescribeTags",
                "logs:*",
                "ec2:DescribeInstanceTypes",
                "ec2:Stop*",
                "ec2:DescribeInstanceStatus"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}
 
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
 role        = aws_iam_role.lambda_role.name
 policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}
 
data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/python/index.py_zip"
}
 
resource "aws_lambda_function" "terraform_lambda_func" {
filename                       = "${path.module}/python/index.py_zip"
function_name                  = "EC2_start_Lambda_Function"
role                           = aws_iam_role.lambda_role.arn
handler                        = "index.lambda_handler"
runtime                        = "python3.9"
depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]

}
# create eventbrigde
resource "aws_cloudwatch_event_rule" "eventbrigde-rule" {
  name = "EC2_Start_rule"
  description = "retry scheduled MON-FRI 9am IST"
  schedule_expression = "cron(30 3 ? * MON-FRI *)"
}
resource "aws_cloudwatch_event_target" "target_id" {
    rule = aws_cloudwatch_event_rule.eventbrigde-rule.name
    target_id = "Lambda"
    arn = aws_lambda_function.terraform_lambda_func.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name =aws_lambda_function.terraform_lambda_func.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.eventbrigde-rule.arn
}