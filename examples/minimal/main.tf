module "druid" {
  source = "git@github.com:spaghettifunk/druid-terraform.git"

  aws_access_key     = "your-aws-access-key"
  aws_secret_key     = "your-aws-secret-key"
  aws_region         = "your-aws-region"
  aws_bucket_storage = "s3-bucket-storage"
  aws_bucket_index   = "s3-bucket-index"
}
