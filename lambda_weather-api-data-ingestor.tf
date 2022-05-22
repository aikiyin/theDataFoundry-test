# module to create and config lambda and base roles and policies
module "weather_api_data_ingestor_lambda" {
  source             = "./modules/lambda_base"
  function_name      = "weather-api-data-ingestor"
  timeout            = 60
}

module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"
  create_bus = false

  rules = {
    crons = {
      description         = "Trigger for a Lambda"
      schedule_expression = "rate(1 hour)"
    }
  }

  targets = {
    crons = [
      {
        name  = "weather_api_data_ingestor_lambda_hourly_schedule"
        arn   = module.weather_api_data_ingestor_lambda.lambda_function
        input = jsonencode({ "job" : "cron-by-rate" })
      }
    ]
  }
}

resource "aws_iam_role_policy_attachment" "weather_api_data_ingestor_role" {
  role       = module.weather_api_data_ingestor_lambda.lambda_execution_role
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}