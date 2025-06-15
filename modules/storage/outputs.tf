output "source_bucket" {
  value = google_storage_bucket.source.name
}

output "script" {
  value = google_storage_bucket_object.etl-source.name
}
