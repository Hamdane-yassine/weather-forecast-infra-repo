variable "gcpUserID" {}
variable "gcpPublicKeyFile" {}
variable "project" {}
variable "region" {}
variable "zone" {}
variable "deployKeyName" {}
variable "workersVMSCount" {}
variable "mastersVMSCount" {}
variable "machineType" {}

provider "google" {
  credentials = file(var.deployKeyName)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

resource "google_compute_network" "default" {
  name                    = "sdtd-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name            = "sdtd-sub-network"
  network         = google_compute_network.default.name
  ip_cidr_range   = "10.240.0.0/24"
}

resource "google_compute_firewall" "internal" {
  name    = "allow-internal"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "tcp"
  }

  source_ranges = [ "10.240.0.0/24","10.200.0.0/16" ]
}

resource "google_compute_firewall" "external" {
  name    = "allow-external"
  network = google_compute_network.default.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "udp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22", "6443"]
  }

  source_ranges = [ "0.0.0.0/0" ]
}

resource "google_compute_address" "default" {
  name = google_compute_network.default.name
}

resource "google_compute_instance" "master" {

  count           = var.mastersVMSCount
  name            = "master-${count.index}"
  machine_type    = var.machineType
  zone            = var.zone
  can_ip_forward  = true

  tags = ["master"]

  boot_disk {
    initialize_params {
      image = "centos-cloud/centos-7-v20231010"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.name
    network_ip = "10.240.0.1${count.index}"

    access_config {
      // Ephemeral IP
    }
  }
  
  service_account {
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }

  metadata_startup_script = "apt-get install -y python"
}

resource "google_compute_instance" "worker" {

  count        = var.workersVMSCount
  name         = "worker-${count.index}"
  machine_type = var.machineType
  zone         = var.zone
  can_ip_forward  = true

  tags = ["worker"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }
  
  network_interface {
    subnetwork = google_compute_subnetwork.default.name
    network_ip = "10.240.0.2${count.index}"

    access_config {
      // Ephemeral IP
    }
  }

  service_account {
    scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
  }

  metadata = {
    pod-cidr = "10.200.${count.index}.0/24"
  }

  metadata_startup_script = "apt-get install -y python"
}

resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "${var.gcpUserID}:${file(var.gcpPublicKeyFile)}"
  }
}