variable "bucket_name" {
  type = string
  description = "Name of S3 bucket"
}

variable "tags" {
  description = "Tags to apply on the S3 bucket"
  type        = map(string)
  default     = {}
}

variable "region" {
  description = "AWS Region to deploy into"
  type        = string
  default     = "ap-southeast-1"
  validation {
    condition = contains([
      "ap-southeast-1", "ap-southeast-2", "ap-northeast-1", "ap-northeast-2", "ap-northeast-3", "ap-south-1"
    ], var.region)
    error_message = "AWS Region must be on of `ap-southeast-1`, `ap-southeast-2`, `ap-northeast-1`, `ap-northeast-2`, `ap-northeast-3` or `ap-south-1`"
  }
}

variable "new_variable" {
  default = ""
}