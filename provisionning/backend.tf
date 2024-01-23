# Configure the Terraform backend
terraform {
  backend "gcs" {
    bucket  = "bbe5253932b39faa-bucket-tfstate" # The name of the Google Cloud Storage bucket to store the Terraform state
    prefix  = "terraform/state" # The location within the bucket where the Terraform state should be stored
  }
}