provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

# -------------------------
# VPC + Subnet
# -------------------------
resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  mtu                     = 1460
}

resource "google_compute_subnetwork" "subnet" {
  name          = var.subnet_name
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id

  private_ip_google_access = var.private_google_access
}

# -------------------------
# Firewall rules
# NOTE: For real-world security, restrict source_ranges to your IP.
# -------------------------
resource "google_compute_firewall" "allow_ssh" {
  name    = "${var.network_name}-allow-ssh"
  network = google_compute_network.vpc.name

  direction     = "INGRESS"
  source_ranges = var.ssh_source_ranges
  target_tags   = var.instance_tags

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_rdp" {
  name    = "${var.network_name}-allow-rdp"
  network = google_compute_network.vpc.name

  direction     = "INGRESS"
  source_ranges = var.rdp_source_ranges
  target_tags   = var.instance_tags

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
}

resource "google_compute_firewall" "allow_icmp" {
  name    = "${var.network_name}-allow-icmp"
  network = google_compute_network.vpc.name

  direction     = "INGRESS"
  source_ranges = var.icmp_source_ranges
  target_tags   = var.instance_tags

  allow {
    protocol = "icmp"
  }
}

# Optional: allow internal traffic inside the subnet (handy for labs)
resource "google_compute_firewall" "allow_internal" {
  count   = var.create_internal_allow_rule ? 1 : 0
  name    = "${var.network_name}-allow-internal"
  network = google_compute_network.vpc.name

  direction     = "INGRESS"
  source_ranges = [var.subnet_cidr]
  target_tags   = var.instance_tags

  allow { protocol = "tcp" }
  allow { protocol = "udp" }
  allow { protocol = "icmp" }
}

# -------------------------
# VM Instance (Debian)
# -------------------------
resource "google_compute_instance" "epic_interconnect_vm" {
  name         = var.vm_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = var.instance_tags

  boot_disk {
    initialize_params {
      image = var.boot_image
      size  = var.boot_disk_size_gb
      type  = var.boot_disk_type
    }
  }

  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.subnet.id

    # Ephemeral public IP (matches your screenshot style)
    access_config {}
  }

  metadata = var.instance_metadata
}
