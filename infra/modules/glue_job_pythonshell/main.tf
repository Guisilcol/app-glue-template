resource "aws_glue_job" "this" {
  name     = var.job_name
  role_arn = var.role_arn
  max_capacity = var.dpu

  command {
    name            = "pythonshell"
    script_location = "${var.app_folder}/src/${var.main_script}"
    python_version  = var.python_version
  }

  max_retries = var.max_retries

  # Merging default arguments with required ones (e.g., temporary directory)
  default_arguments = merge(
    {
      "--TempDir" = var.temp_dir,
      "--extra-py-files" = "${var.app_folder}/dependencies/libs-0.1-py3-none-any.whl"
    },
    var.default_arguments
  )
}
