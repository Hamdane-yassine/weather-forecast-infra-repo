# Configure the Terraform backend
provider "google" {
  credentials = file(var.deployKeyName)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

terraform {
  backend "gcs" {
    bucket  = "bbe5253932b39faa-bucket-tfstate" # The name of the Google Cloud Storage bucket to store the Terraform state
    prefix  = "terraform/state" # The location within the bucket where the Terraform state should be stored
  }
}