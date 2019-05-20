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
  default = "r5.xlarge"
}

variable "tags" {
  type    = "map"
  default = {}
}
