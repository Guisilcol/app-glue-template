variable "job_name" {
  description = "The name of the Glue Job"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role that the Glue Job will assume"
  type        = string
}

variable "script_location" {
  description = "The S3 location of the Python script for the Glue Job"
  type        = string
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
