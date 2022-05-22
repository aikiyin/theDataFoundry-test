resource "null_resource" "install_python_dependencies" {
  triggers = {
    always_run = timestamp()
  }
  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/install_python.sh"

    environment = {
      function_name = var.function_name
      path_module   = path.module
      path_cwd      = path.cwd
    }
  }
}

resource "aws_lambda_function" "lambda" {
  function_name = var.function_name

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  role        = aws_iam_role.lambda_execution_role.arn
  handler     = "${var.function_name}.main"
  runtime     = "python3.8"
  timeout     = var.timeout
  memory_size = var.memory_size

  depends_on = [null_resource.install_python_dependencies]

}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "${var.function_name}-lambda-execution-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust_policy.json
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution_role" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
