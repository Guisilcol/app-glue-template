output "job_name" {
  description = "The name of the created Glue Job"
  value       = aws_glue_job.this.name
}

output "job_arn" {
  description = "The ARN of the created Glue Job"
  value       = aws_glue_job.this.arn
}
