# Custom VPC network for isolation and security
resource "google_compute_network" "mc_network" {
  name                    = "mc-network"
  auto_create_subnetworks = true
}

# Firewall rule allowing TCP port 25565 (Minecraft default port) and TCP port 22 (SSH access)
resource "google_compute_firewall" "mc_firewall" {
  name    = "mc-allow-minecraft-ssh"
  network = google_compute_network.mc_network.name

  allow {
    protocol = "tcp"
    ports    = ["25565", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["minecraft-server"]
}

# Google Compute Engine VM Instance running Ubuntu 22.04 LTS
resource "google_compute_instance" "mc_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  tags = ["minecraft-server"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
      size  = 20
      type  = "pd-standard"
    }
  }

  network_interface {
    network = google_compute_network.mc_network.name

    access_config {
      # Allocates an external ephemeral IP so users can connect
    }
  }

  metadata = {
    # Enables standard SSH key management via Google Cloud OS Login
    enable-oslogin = "TRUE"
  }
}
