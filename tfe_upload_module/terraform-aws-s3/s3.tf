resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}-bucket"
  tags   = merge({ "region" : var.region }, var.tags)
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_config" {
  bucket = aws_s3_bucket.bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
