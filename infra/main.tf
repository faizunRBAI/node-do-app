# The SSH keypair is owned by the UDAP platform, not by this state: the DO
# agent uploads the public key to the ACCOUNT at cloud-prepare (as
# "udap-<project>") and reuses it on every later run. DigitalOcean rejects a
# second registration of the same public key with
# "422 SSH Key is already in use on your account", so a
# `resource "digitalocean_ssh_key"` here can never apply — it is looked up
# instead. Do not convert this back into a resource.
locals {
  ssh_key_name = var.ssh_key_name != "" ? var.ssh_key_name : "udap-${var.project_name}"
}

data "digitalocean_ssh_key" "main" {
  name = local.ssh_key_name
}

resource "digitalocean_droplet" "app" {
  name     = "${var.project_name}-droplet"
  region   = var.region
  size     = var.droplet_size
  image    = var.droplet_image
  ssh_keys = [data.digitalocean_ssh_key.main.fingerprint]

  tags = ["${var.project_name}", "managed-by-udap"]
}

resource "digitalocean_firewall" "app" {
  name        = "${var.project_name}-firewall"
  droplet_ids = [digitalocean_droplet.app.id]

  # Allow SSH from anywhere
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow HTTP from anywhere
  inbound_rule {
    protocol         = "tcp"
    port_range       = "80"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  # Allow all outbound traffic
  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}
