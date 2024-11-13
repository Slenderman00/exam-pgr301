variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "S3 bucket name for storing generated images"
  type        = string
  default     = "pgr301-couch-explorers"
}

variable "image_path" {
  description = "the path where the image should be stored"
  type        = string
  default     = "63"
}

variable "prefix" {
  description = "Prefix for all resources"
  type        = string
  default     = "63"
}

variable "alert_email_address" {
  description = "Email address for alerts"
  type        = string
  default     = "spam@joar.me"
}