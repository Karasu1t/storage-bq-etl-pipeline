# Storage
resource "google_storage_bucket" "storage-data" {
  name          = "${var.environment}-${var.project}-data"
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