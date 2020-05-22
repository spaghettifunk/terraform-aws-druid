locals {
  druid_image = "${format("%s/%s:%s", var.druid_image_registry, var.druid_image_repository, var.druid_image_tag)}"
  
}
