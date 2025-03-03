##############################
# Provider/Backend Variables #
##############################
variable "aws_region" {
  description = "AWS region to provision resources"
  type        = string
}

##############################
# Source code variables      #
##############################

variable "source_code_bucket" {
  description = "S3 bucket where the Glue Job script is stored"
  type        = string
}

variable "source_code_folder_key" {
  description = "S3 key (path) for the Glue Job script within the bucket"
  type        = string
}

variable "source_code_main_file_key" {
  description = "S3 key (path) for the main script file within the bucket"
  type        = string
}

##############################
# Resource Variables         #
##############################
variable "glue_job_name" {
  description = "Name of the Glue Job"
  type        = string
}

variable "glue_role_arn" {
  description = "ARN of the IAM Role that the Glue Job will assume"
  type        = string
}

variable "dpu" {
  description = "Number of DPUs to allocate to the Glue Job"
  type        = number
}



