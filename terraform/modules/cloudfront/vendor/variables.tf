variable "name" {}

variable "certificate_arn" { 
  description = "Existing certificate arn."
}

variable "domains" {
  type = "list"
  default = []
}

variable "bucket_name" {
  default = "tf-cf-bucket"
}

variable "bucket_domain_name" {
  type = "string"
}


variable "compress" {
  default = "false"
}
  
variable "ipv6_enabled" {
  default = "true"
}

variable "comment" {
  default = "Managed by Terraform"
}

variable "price_class" {
  default = "PriceClass_100"
}

variable "viewer_protocol_policy" {
  #default = "allow-all"
  default = "redirect-to-https"
}

variable "allowed_methods" {
  type = "list"
  default  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
}
variable "cached_methods" { 
  type = "list"
  default = ["GET", "HEAD"]
}

variable "min_ttl" {
  default = "0"
}
variable "max_ttl" {
  default = "31536000"
}
variable "default_ttl" {
  default = "60"
}

variable "tags" {
  default = {}
}
