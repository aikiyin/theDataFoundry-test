# module to create and config lambda and base roles and policies
module "weather_api_data_ingestor_lambda" {
  source             = "./modules/lambda_base"
  function_name      = "weather-api-data-ingestor"
  timeout            = 60
}

resource "aws_cloudwatch_event_rule" "weather_api_data_lambda_event_rule" {
  name = "weather-api-data-lambda-event-rule"
  description = "Trigger lambda every 1 hour"
  schedule_expression = "rate(1 hour)"
}

resource "aws_cloudwatch_event_target" "weather_api_data_lambda_target" {
  arn = module.weather_api_data_ingestor_lambda.lambda_function
  rule = aws_cloudwatch_event_rule.weather_api_data_lambda_event_rule.name
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_rw_fallout_retry_step_deletion_lambda" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = "weather-api-data-ingestor"
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.weather_api_data_lambda_event_rule.arn
}


resource "aws_iam_role_policy_attachment" "weather_api_data_ingestor_role" {
  role       = module.weather_api_data_ingestor_lambda.lambda_execution_role
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}