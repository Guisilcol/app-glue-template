resource "aws_s3_object" "app_files" {
  for_each = { for file in fileset(var.app_local_path, "**/*") : file => file }
  
  bucket = var.source_code_bucket
  key    = "${var.source_code_folder_key}/${each.value}"
  source = "${var.app_local_path}/${each.value}"
  etag   = filemd5("${var.app_local_path}/${each.value}")
}