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

resource "google_compute_instance" "load-balancer-1" {
  name           = "load-balancer-1"
  machine_type   = var.machineType
  zone           = var.zone
  can_ip_forward = true

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.name
    network_ip = "192.168.7.12"
    access_config {
      nat_ip = google_compute_address.load_balancer_address_1.address
    }
  }

}

resource "google_compute_network" "default" {
  name                    = "sdtd-network"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name          = "sdtd-sub-network"
  network       = google_compute_network.default.name
  ip_cidr_range = "192.168.7.0/24"
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
    ports    = ["22", "6443", "2379-2380", "10250", "10259", "10257", "30000-32767","8081","8082"]
  }

  source_ranges = ["0.0.0.0/0"]
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
    ports    = ["22", "6443", "443", "80", "30000-32767","8081","8082"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "load_balancer_address_1" {
  name   = "load-balancer"
  region = var.region
}

resource "google_compute_instance" "master" {

  count          = var.mastersVMSCount
  name           = "master-${count.index}"
  machine_type   = var.machineType
  zone           = var.zone
  can_ip_forward = true

  tags = ["master"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.name
    network_ip = "192.168.7.1${count.index}"

    access_config {
      # nat_ip = google_compute_address.master_address[count.index].address
    }
  }

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }
}

resource "google_compute_instance" "worker" {

  count          = var.workersVMSCount
  name           = "worker-${count.index}"
  machine_type   = var.machineType
  zone           = var.zone
  can_ip_forward = true

  tags = ["worker"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.name
    network_ip = "192.168.7.2${count.index}"

    access_config {
      # nat_ip = google_compute_address.worker_address[count.index].address
    }
  }

  service_account {
    scopes = ["compute-rw", "storage-ro", "service-management", "service-control", "logging-write", "monitoring"]
  }

  metadata = {
    pod-cidr = "10.200.${count.index}.0/24"
  }

}

resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "${var.gcpUserID}:${file(var.gcpPublicKeyFile)}"
  }
}
