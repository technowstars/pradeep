data "aws_iam_policy_document" "backup_role_assume_role_policy" {
    statement {
      sid     = "AssumeServiceRole"
      actions = ["sts:AssumeRole"]
      effect  = "Allow"
      
    principals {
        type        = "Service"
        identifiers = ["backup.amazonaws.com"]
        }
    }
}

# data "aws_iam_policy" "backup_policy" {
#   arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
# }

# data "aws_iam_policy" "restore_policy" {
#   arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForRestores"
# }

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "pass-role-policy-doc" {
  statement {
    sid       = "ExamplePassRole"
    actions   = ["iam:PassRole"]
    effect    = "Allow"
    resources = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/*"]
  }
}

resource "aws_iam_role" "role_backup_terraform" {
    name               = "role_backup_terraform_one"
    description        = "Allows the AWS Backup Service to take scheduled backups"
    assume_role_policy = data.aws_iam_policy_document.backup_role_assume_role_policy.json
}


# resource "aws_iam_role_policy" "backup_policy_role" {
#     name = "aws_backup_policy_role"
#     role = aws_iam_role.role_backup_terraform.id
#     policy = data.aws_iam_policy.backup_policy.policy

# }

# resource "aws_iam_role_policy" "restore_policy_role" {
#     name = "aws_restore_policy_role"
#     role = aws_iam_role.role_backup_terraform.id
#     policy = data.aws_iam_policy.restore_policy.policy

# }
