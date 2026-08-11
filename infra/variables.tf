variable "project_name" {
  description = "Project name used to prefix cloud resources"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key injected into the Droplet at launch"
  type        = string
  sensitive   = true
}

variable "region" {
  description = "DigitalOcean region"
  type        = string
  default     = "nyc1"
}

variable "droplet_size" {
  description = "Droplet size slug"
  type        = string
  default     = "s-1vcpu-1gb"
}

variable "droplet_image" {
  description = "Droplet base image"
  type        = string
  default     = "ubuntu-22-04-x64"
}

variable "do_token" {
  description = "DigitalOcean API token"
  type        = string
  sensitive   = true
}
