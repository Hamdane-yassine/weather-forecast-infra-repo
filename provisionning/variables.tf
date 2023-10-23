
variable "gce_ssh_user" {
  default = "root"
}
variable "gce_ssh_pub_key_file" {
default = "~/.ssh/google_compute_engine.pub"
}

variable "project" {
  default = "stdt-project"
}

variable "region" {
  default = "europe-west9"
}

variable "zone" {
  default = "europe-west9-a"
}

variable "instanceName" {
  default = "terraform-instance"
}

variable "deployKeyName" {
  default = "../sdtd-sa.json"
}

variable "workersVMSCount" {
  default = 2
}

variable "mastersVMSCount" {
  default = 1
}

variable "machineType" {
  default = "e2-standard-2"
}

