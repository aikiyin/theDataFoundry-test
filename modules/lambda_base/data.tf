data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${var.function_name}/build/"
  output_path = "deploy/${var.function_name}/deploy.zip"
  depends_on  = [null_resource.install_python_dependencies]
}

data "aws_iam_policy_document" "lambda_trust_policy" {
  statement {
    sid    = ""
    effect = "Allow"

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }

    actions = ["sts:AssumeRole"]
  }
}
