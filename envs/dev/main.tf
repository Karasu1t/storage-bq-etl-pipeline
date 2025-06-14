# Storage
module "storage" {
  source      = "../../modules/storage"
  id          = local.id
  project     = local.project
  environment = local.environment
}
