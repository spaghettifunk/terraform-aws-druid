resource "kubernetes_secret" "druid_secret" {
  metadata {
    name      = "druid-secret"
    namespace = "test"
  }

  data = {
    aws_access_key     = ""
    aws_bucket_index   = ""
    aws_bucket_storage = ""
    aws_region         = ""
    aws_secret_key     = ""
  }

  type = "Opaque"
}

