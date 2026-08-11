variable "project_name" {
  description = "Project name used to prefix cloud resources"
  type        = string
}

# Supplied by the platform as TF_VAR_ssh_public_key and kept declared so the
# matched-pair contract stays visible, but the Droplet references the key by
# fingerprint via the data source in main.tf — DigitalOcean already holds this
# public key at the account level.
variable "ssh_public_key" {
  description = "SSH public key the platform registered on the DO account"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ssh_key_name" {
  description = "Name of the platform-registered DO SSH key. Empty means derive it as udap-<project_name>, which is what the DO agent uses."
  type        = string
  default     = ""
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
