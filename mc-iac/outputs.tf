output "instance_external_ip" {
  description = "The external public IP address of the Minecraft VM instance."
  value       = google_compute_instance.mc_instance.network_interface[0].access_config[0].nat_ip
}
