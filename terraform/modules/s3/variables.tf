variable "bucket_names" {
  type = list(string)
}

variable "enable_versioning" {
  type    = bool
  default = true
}
