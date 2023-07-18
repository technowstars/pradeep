# #creating zip

data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir = "${path.module}/python/"
  output_path = "${path.module}/python/lambda.py_zip"
}



# #creating lambda

resource "aws_lambda_function" "auto_tag_lambda_fun" {
filename                       = "${path.module}/python/lambda.py_zip"
function_name                  = "auto_tag_lambda_fun_tf247"
role                           = aws_iam_role.iam_role_for_lambda.arn
handler                        = "lambda.lambda_handler"
runtime                        = "python3.7"
depends_on                     = [aws_iam_role_policy_attachment.lambda_logs-auto-tag]
}



resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auto_tag_lambda_fun.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.auto_tag_event_rule.arn
  
}
