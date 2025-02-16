resource "aws_glue_job" "this" {
  name     = var.job_name
  role_arn = var.role_arn

  command {
    name            = "pythonshell"
    script_location = var.script_location
    python_version  = var.python_version
  }

  max_retries = var.max_retries

  # Merging default arguments with required ones (e.g., temporary directory)
  default_arguments = merge(
    {
      "--TempDir" = var.temp_dir
    },
    var.default_arguments
  )
}
