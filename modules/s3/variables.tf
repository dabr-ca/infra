variable "slug" {
  description = "It will be interpolated into a unique bucket name."
  type        = string
  nullable    = false
}

variable "public" {
  description = "Whether this bucket should be public-readable."
  type        = bool
  default     = false
}
