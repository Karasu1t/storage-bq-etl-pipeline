resource "google_cloudfunctions_function" "etl_function" {
  name        = "${var.environment}-${var.project}-etl-function"
  runtime     = "python310"
  entry_point = "etl_handler"
  region      = var.gcp_region
  project = var.id
  source_archive_bucket = var.source_bucket
  source_archive_object = var.script
  trigger_http           = true
  available_memory_mb    = 512
  environment_variables = {
    DATASET = var.dataset
  }
  service_account_email = google_service_account.etl_sa.email
}

resource "google_cloudfunctions_function_iam_member" "invoker" {
  project        = var.id
  region         = var.gcp_region
  cloud_function = google_cloudfunctions_function.etl_function.name
  role           = "roles/cloudfunctions.invoker"
  member         = "serviceAccount:terraform@${var.id}.iam.gserviceaccount.com"
}

resource "google_service_account" "etl_sa" {
  project = var.id
  account_id   = "etl-function-sa"
  display_name = "Service Account for ETL Function"
}

resource "google_project_iam_member" "function_storage" {
  project = var.id
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${google_service_account.etl_sa.email}"
}

resource "google_project_iam_member" "function_bigquery" {
  project = var.id
  role   = "roles/bigquery.dataEditor"
  member = "serviceAccount:${google_service_account.etl_sa.email}"
}