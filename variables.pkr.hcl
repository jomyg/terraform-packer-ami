################################################################
# Create a IAM programmatic user for the execution
###########################################################

variable "access-key" {
  default = "<access-key-from-aws-console-when-user-created>"
}

variable "secret-key" {
  default = "<secret-key-from-aws-console-when-user-created>"
}

variable "web_name" {
  default = "site-html"
}
