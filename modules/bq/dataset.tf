resource "google_bigquery_dataset" "dataset" {
  dataset_id                  = "iris_dataset"
  friendly_name               = "test"
  location                    = "ASIA-NORTHEAST1"
  default_table_expiration_ms = 3600000

  access {
    role          = "OWNER"
    user_by_email = google_service_account.bqowner.email
  }

  access {
    role   = "OWNER"
    user_by_email = "${var.email}"
  }

}

resource "google_service_account" "bqowner" {
  account_id = "bqowner"
}