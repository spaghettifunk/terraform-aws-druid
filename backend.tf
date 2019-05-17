terraform {
  required_version = "= v0.11.11"

  # enable it again once I have a real AWS account
  # backend "s3" {
  #   bucket = "markthub-tf-state"
  #   key    = "infrastructure"
  #   region = "eu-west-1"
  # }
}
