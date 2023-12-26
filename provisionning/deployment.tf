variable "gcpUserID" {}
variable "gcpPublicKeyFile" {}
variable "project" {}
variable "region" {}
variable "zone" {}
variable "deployKeyName" {}
variable "workersVMSCount" {}
variable "mastersVMSCount" {}
variable "machineType" {}
variable "osImage" {}

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
    ports    = ["22", "6443", "2379-2380", "10250", "10259", "10257", "30000-32767"]
  }

  source_ranges = ["192.168.7.0/24"]
}

resource "google_compute_firewall" "external" {
  name    = "allow-external"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22", "443", "80","8083","8082"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_address" "gateway-public-ip" {
  name   = "gateway-public-ip"
  region = var.region
}

resource "google_compute_instance" "gateway-server" {
  name           = "gateway-server"
  machine_type   = var.machineType
  zone           = var.zone
  tags           = ["gateway"]
  boot_disk {
    initialize_params {
      image = var.osImage
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.name
    network_ip = "192.168.7.30"
    access_config {
      nat_ip = google_compute_address.gateway-public-ip.address
    }
  }
}

resource "google_compute_instance" "master" {
  count          = var.mastersVMSCount
  name           = "master-${count.index}"
  machine_type   = var.machineType
  zone           = var.zone
  tags           = ["master"]

  boot_disk {
    initialize_params {
      image = var.osImage
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.name
    network_ip = "192.168.7.1${count.index}"
  }
}

resource "google_compute_instance" "worker" {

  count          = var.workersVMSCount
  name           = "worker-${count.index}"
  machine_type   = var.machineType
  zone           = var.zone
  tags           = ["worker"]

  boot_disk {
    initialize_params {
      image = var.osImage
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.default.name
    network_ip = "192.168.7.2${count.index}"
  }
}

# Cloud Router for Cloud NAT
resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  network = google_compute_network.default.name
  region  = var.region

  bgp {
    asn = 64514
  }
}

# Cloud NAT Configuration
resource "google_compute_router_nat" "nat_gateway" {
  name                               = "nat-gateway"
  router                             = google_compute_router.nat_router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

resource "google_compute_project_metadata" "default" {
  metadata = {
    ssh-keys = "${var.gcpUserID}:${file(var.gcpPublicKeyFile)}"
  }
}