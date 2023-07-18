#creating ssm paramter


resource "aws_ssm_parameter" "ssm_paramter" {
  name        = "/auto-tag/A200095793/tag/team"
  description = "The parameter description"
  type        = "String"
  value       = "ACTH-automotive"

}