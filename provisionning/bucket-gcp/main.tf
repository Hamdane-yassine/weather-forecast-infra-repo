variable "project" {}
variable "region" {}
variable "zone" {}
variable "deployKeyName" {}

# [START storage_kms_encryption_tfstate]
resource "google_kms_key_ring" "terraform_state" {
  name     = "${random_id.bucket_prefix.hex}-bucket-tfstate"
  project = var.project
  location = "europe-west9"
}

resource "google_kms_crypto_key" "terraform_state_bucket" {
  name            = "test-terraform-state-bucket"
  key_ring        = google_kms_key_ring.terraform_state.id
  rotation_period = "86400s"

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_project_iam_member" "default" {
  project = var.project
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-1069236696272@gs-project-accounts.iam.gserviceaccount.com"
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name          = "${random_id.bucket_prefix.hex}-bucket-tfstate"
  project = var.project
  force_destroy = false
  location      = "EUROPE-WEST9"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
  encryption {
    default_kms_key_name = google_kms_crypto_key.terraform_state_bucket.id
  }
  depends_on = [
    google_project_iam_member.default
  ]
}

output "bucketName" {
  value = google_storage_bucket.default.name
}