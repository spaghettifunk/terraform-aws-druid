terraform {
  required_version = "= v0.11.11"

  backend "s3" {
    bucket = "state-tf-rtl"
    key    = "di"
    region = "eu-west-1"
  }
}
