terraform {
 backend "gcs" {
   bucket  = "bbe5253932b39faa-bucket-tfstate"
   prefix  = "terraform/state"
 }
}