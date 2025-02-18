
resource "aws_s3_object" "app_files" {
  for_each = { for file in fileset("../app", "**/*") : file => file }
  
  bucket = var.source_code_bucket
  key    = "${var.source_code_folder_key}/${each.value}"
  source = "../app/${each.value}"
  etag   = filemd5("../app/${each.value}")
}