# Storage
resource "google_storage_bucket" "noetl-data" {
  name          = "${var.environment}-${var.project}-noetl-data"
  location      = "ASIA-NORTHEAST1"
  force_destroy = true
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 2
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_storage_bucket" "etl-data" {
  name          = "${var.environment}-${var.project}-etl-data"
  location      = "ASIA-NORTHEAST1"
  force_destroy = true
  uniform_bucket_level_access = true

  lifecycle_rule {
    condition {
      age = 2
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

resource "google_storage_bucket" "source" {
  name          = "${var.environment}-${var.project}-etl-script"
  location      = "ASIA-NORTHEAST1"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 2
    }
    action {
      type = "Delete"
    }
  }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

# Storage Original data(From seaborn dataset)
resource "google_storage_bucket_object" "iris-data" {
  name   = "iris.csv"
  source = "../../data/iris.csv"
  bucket = "${var.environment}-${var.project}-noetl-data"

  depends_on = [google_storage_bucket.noetl-data]
}

resource "google_storage_bucket_object" "iris-blank-data" {
  name   = "raw/iris_blank.csv"
  source = "../../data/iris_blank.csv"
  bucket = "${var.environment}-${var.project}-etl-data"

  depends_on = [google_storage_bucket.etl-data]
}

resource "google_storage_bucket_object" "etl-source" {
  name   = "function.zip"
  source = "../../src/function.zip"
  bucket = "${var.environment}-${var.project}-etl-script"

  depends_on = [google_storage_bucket.source]
}

resource "google_storage_bucket_iam_member" "function_sa_object_viewer" {

  for_each = {
    "noetl"   = google_storage_bucket.noetl-data.name
    "etl"     = google_storage_bucket.etl-data.name
    "script"  = google_storage_bucket.source.name
  }

  bucket = each.value
  role   = "roles/storage.objectViewer"
  member = "serviceAccount:${var.etl_sa}"
}

resource "google_project_iam_member" "function_sa_bigquery_user" {
  project = var.id
  role    = "roles/bigquery.user"
  member  = "serviceAccount:${var.etl_sa}"
}

resource "google_project_iam_member" "function_sa_bigquery_data_editor" {

  project = var.id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${var.etl_sa}"
}

