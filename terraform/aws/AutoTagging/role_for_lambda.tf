# creating role for lambda


resource "aws_iam_role" "iam_role_for_lambda" {
  name = "auto_tag_role_lambda_tf2477"

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


#creating policies for that role

resource "aws_iam_policy" "policy_for_lambda" {
  name        = "policy_for_labda_tf247"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
        {
            "Sid": "ec2ResourceAutoTaggerObserveAnnotate",
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2:DescribeInstances",
                "ec2:DescribeVolumes"
            ],
            "Resource": "*"
        },
        {
            "Sid": "ec2ResourceAutoTaggerCreateUpdate",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "ec2:CreateTags",
                "logs:CreateLogGroup",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:ec2:*:013833933065:instance/*",
                "arn:aws:ec2:*:013833933065:volume/*",
                "arn:aws:logs:eu-central-1:013833933065:log-group:/aws/lambda/auto_tag_lambda_fun:log-stream:*",
                "arn:aws:logs:eu-central-1:013833933065:log-group:/aws/lambda/auto_tag_lambda_fun"
            ]
        },
        {
            "Sid": "ec2ResourceAutoTaggerRead",
            "Effect": "Allow",
            "Action": [
                "iam:ListRoleTags",
                "iam:ListUserTags",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams",
                "logs:GetLogEvents",
                "ssm:GetParametersByPath"
            ],
            "Resource": [
                "arn:aws:iam::013833933065:user/*",
                "arn:aws:iam::013833933065:role/*",
                "arn:aws:logs:eu-central-1:013833933065:log-group:/aws/lambda/auto_tag_lambda_fun:log-stream:*",  
                "arn:aws:logs:eu-central-1:013833933065:log-group:/aws/lambda/auto_tag_lambda_fun",
                "arn:aws:ssm:*:013833933065:parameter/*"
            ]
        }
    ]
}
EOF
}
#i think we need to change value for lambbda


resource "aws_iam_role_policy_attachment" "lambda_logs-auto-tag" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = aws_iam_policy.policy_for_lambda.arn
}
