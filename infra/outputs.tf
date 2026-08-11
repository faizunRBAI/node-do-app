output "droplet_ip" {
  description = "Public IP address of the app Droplet"
  value       = digitalocean_droplet.app.ipv4_address
}

output "droplet_id" {
  description = "DigitalOcean Droplet ID"
  value       = digitalocean_droplet.app.id
}
