# Storage
resource "google_storage_bucket" "noetl-data" {
  name          = "${var.environment}-${var.project}-noetl-data"
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

resource "google_storage_bucket" "etl-data" {
  name          = "${var.environment}-${var.project}-etl-data"
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