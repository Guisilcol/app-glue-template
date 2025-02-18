variable "job_name" {
  description = "The name of the Glue Job"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role that the Glue Job will assume"
  type        = string
}

variable "app_folder" {
  description = "The S3 path location of the folder of Python script for the Glue Job"
  type        = string
}

variable "main_script" {
  description = "the key name from the value passed in 'app_folder'"
  type        = string
}

variable "dpu" {
  description = "The number of DPUs to allocate for the Glue Job. Valid numbers: 0.0625 or 1"
  type        = number
}

variable "python_version" {
  description = "The Python version to be used by the Glue Job (e.g., '3')"
  type        = string
  default     = "3"
}

variable "max_retries" {
  description = "The maximum number of retries for the Glue Job"
  type        = number
  default     = 0
}

variable "temp_dir" {
  description = "The S3 path for the temporary directory used by the Glue Job"
  type        = string
}

variable "default_arguments" {
  description = "A map of additional default arguments for the Glue Job"
  type        = map(string)
  default     = {}
}
