resource "kubernetes_secret" "druid_secret" {
  metadata {
    name      = "druid-secret"
    namespace = var.namespace
  }

  data = {
    aws_access_key     = base64encode(var.aws_access_key)
    aws_secret_key     = base64encode(var.aws_secret_key)
    aws_region         = base64encode(var.aws_region)
    aws_bucket_index   = base64encode(var.aws_bucket_index)
    aws_bucket_storage = base64encode(var.aws_bucket_storage)
  }

  type = "Opaque"
}

