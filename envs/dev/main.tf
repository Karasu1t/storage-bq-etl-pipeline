# Storage
module "storage" {
  source      = "../../modules/storage"
  id          = local.id
  project     = local.project
  environment = local.environment

  etl_sa      = module.function.etl_sa
}

# bq
module "bq" {
  source      = "../../modules/bq"
  email       = local.email
}

# Function
module "function" {
  source      = "../../modules/functions"
  id          = local.id
  project     = local.project
  environment = local.environment
  gcp_region  = local.gcp_region

  dataset       = module.bq.dataset
  source_bucket = module.storage.source_bucket
  script        = module.storage.script
}

