# Storage
module "storage" {
  source      = "../../modules/storage"
  id          = local.id
  project     = local.project
  environment = local.environment
}

# bq
module "bq" {
  source      = "../../modules/bq"
  email       = local.email
}
