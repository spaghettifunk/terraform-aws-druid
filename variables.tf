variable "aws_region" {
  type    = "string"
  default = "eu-west-1"
}

variable "aws_azs" {
  type    = "list"
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "instance_type" {
  type    = "string"
  default = "m5.large"
}

variable "tags" {
  type    = "map"
  default = {}
}
