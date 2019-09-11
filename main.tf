provider "google" {
  project = "${var.project_id}"
  region  = "asia-northeast1"
}

resource "google_storage_bucket" "bucket" {
  name = "linzy-food-bucket"
  location = "ASIA"
}

resource "google_storage_bucket_object" "archive" {
  name   = "index.zip"
  bucket = "${google_storage_bucket.bucket.name}"
  source = "./main.zip"
}

resource "google_cloudfunctions_function" "main" {
  name                  = "data-ingestion"
  description           = "Search food which nearby yourself through Line BOT."
  runtime               = "nodejs8"

  available_memory_mb   = 128
  source_archive_bucket = "${google_storage_bucket.bucket.name}"
  source_archive_object = "${google_storage_bucket_object.archive.name}"
  trigger_http          = true
  timeout               = 60
  entry_point           = "search"
}