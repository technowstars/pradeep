locals {
  backups = {
    schedule  = "cron(30 5 * * ? *)" /* UTC Time */
    retention = 1 // days
  }
}

resource "aws_backup_vault" "ami_backup_vs" {
  name        = "aws_ami_backup_vs"
 
}


resource "aws_backup_plan" "ami_backup_plan_vs" {
  name = "aws_ami_backup_plan_vs"

  rule {
    rule_name         = "tf_backup_rule_vs"
    target_vault_name = aws_backup_vault.ami_backup_vs.name
    schedule          = local.backups.schedule
    start_window      = 60
    completion_window = 120

    lifecycle {
      delete_after = local.backups.retention
    }
  }
  
}

resource "aws_backup_selection" "ami_backup_selection_vs" {
  iam_role_arn = aws_iam_role.role_backup_terraform.arn
  name         = "aws_ami_backup_selection_vs"
  plan_id      = aws_backup_plan.ami_backup_plan_vs.id

  resources = [
    aws_instance.ami_instance_server.arn
  ]
}