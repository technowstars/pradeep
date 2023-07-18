resource "aws_iam_role_policy" "restore_policy_one" {
  name = "aws_restore_policy_one"
  role = aws_iam_role.role_backup_terraform.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            "Effect": "Allow",
            "Action": [
                "dynamodb:RestoreTableFromBackup"
            ],
            "Resource": "arn:aws:dynamodb:*:*:table/*/backup/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:CreateVolume",
                "ec2:DeleteVolume"
            ],
            "Resource": [
                "arn:aws:ec2:*::snapshot/*",
                "arn:aws:ec2:*:*:volume/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeImages",
                "ec2:DescribeInstances",
                "ec2:DescribeSnapshots",
                "ec2:DescribeVolumes"
            ],
            "Resource": "*"
        },
       
        {
            "Effect": "Allow",
            "Action": [
                "elasticfilesystem:Restore",
                "elasticfilesystem:CreateFilesystem",
                "elasticfilesystem:DescribeFilesystems",
                "elasticfilesystem:DeleteFilesystem"
            ],
            "Resource": "arn:aws:elasticfilesystem:*:*:file-system/*"
        },
        {
            "Effect": "Allow",
            "Action": "kms:DescribeKey",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:Encrypt",
                "kms:GenerateDataKey",
                "kms:ReEncryptTo",
                "kms:ReEncryptFrom"
            ],
            "Resource": "*",
            "Condition": {
                "StringLike": {
                    "kms:ViaService": [
                        "dynamodb.*.amazonaws.com",
                        "ec2.*.amazonaws.com",
                        "elasticfilesystem.*.amazonaws.com",
                        "rds.*.amazonaws.com",
                        "redshift.*.amazonaws.com"
                    ]
                }
            }
        },
    ]
  })
}


resource "aws_iam_role_policy" "restore_policy_two" {
  name = "aws_restore_policy_two"
  role = aws_iam_role.role_backup_terraform.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
       {
            "Effect": "Allow",
            "Action": "kms:CreateGrant",
            "Resource": "*",
            "Condition": {
                "Bool": {
                    "kms:GrantIsForAWSResource": "true"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ebs:CompleteSnapshot",
                "ebs:StartSnapshot",
                "ebs:PutSnapshotBlock"
            ],
            "Resource": "arn:aws:ec2:*::snapshot/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "rds:CreateDBInstance"
            ],
            "Resource": "arn:aws:rds:*:*:db:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DeleteSnapshot",
                "ec2:DeleteTags"
            ],
            "Resource": "arn:aws:ec2:*::snapshot/*",
            "Condition": {
                "Null": {
                    "aws:ResourceTag/aws:backup:source-resource": "false"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "ec2:CreateTags",
            "Resource": [
                "arn:aws:ec2:*::snapshot/*",
                "arn:aws:ec2:*:*:instance/*"
            ],
            "Condition": {
                "ForAllValues:StringEquals": {
                    "aws:TagKeys": [
                        "aws:backup:source-resource"
                    ]
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:RunInstances"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:TerminateInstances"
            ],
            "Resource": "arn:aws:ec2:*:*:instance/*"
        }, 
    ]
  })
}


resource "aws_iam_role_policy" "restore_policy_three" {
  name = "aws_restore_policy_three"
  role = aws_iam_role.role_backup_terraform.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            "Effect": "Allow",
            "Action": [
                "redshift:DescribeTableRestoreStatus"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAccountAttributes",
                "ec2:DescribeAddresses",
                "ec2:DescribeAvailabilityZones",
                "ec2:DescribeSecurityGroups",
                "ec2:DescribeSubnets",
                "ec2:DescribeVpcs",
                "ec2:DescribeInternetGateways"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "timestream:StartAwsRestoreJob",
                "timestream:GetAwsRestoreStatus",
                "timestream:ListTables",
                "timestream:ListTagsForResource",
                "timestream:ListDatabases",
                "timestream:DescribeTable",
                "timestream:DescribeDatabase"
            ],
            "Resource": [
                "arn:aws:timestream:*:*:database/*/table/*",
                "arn:aws:timestream:*:*:database/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "timestream:DescribeEndpoints"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
  })
}