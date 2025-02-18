module "glue_job" {
  source = "./modules/glue_job_pythonshell"

  job_name    = var.glue_job_name
  role_arn    = var.glue_role_arn

  app_folder  = "s3://${var.source_code_bucket}/${var.source_code_folder_key}"
  main_script = var.source_code_main_file_key

  dpu            = var.dpu
  python_version = "3"
  max_retries    = 0
  temp_dir       = "s3://${var.source_code_bucket}/temp"
  default_arguments = {}
}