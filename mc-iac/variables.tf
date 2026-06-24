variable "project_id" {
  description = "The GCP Project ID"
  type        = string
  default     = "walkboys-mc-fun-one"
}

variable "region" {
  description = "The GCP Region"
  type        = string
  default     = "us-west3"
}

variable "zone" {
  description = "The GCP Zone"
  type        = string
  default     = "us-west3-a"
}

variable "instance_name" {
  description = "The name of the VM instance"
  type        = string
  default     = "mc-fun-one"
}

variable "machine_type" {
  description = "The machine type for the Minecraft server"
  type        = string
  default     = "e2-medium"
}
