output "lambda_function" {
  value = aws_lambda_function.lambda.arn
}

output "lambda_execution_role" {
  value = aws_iam_role.lambda_execution_role.name
}
