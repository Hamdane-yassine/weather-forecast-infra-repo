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

