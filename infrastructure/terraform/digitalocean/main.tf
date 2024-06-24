# main.tf
provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_project" "cks" {
  name        = "CKS"
  description = "A project for educational purposes"
  purpose     = "education"
  environment = "development"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "digitalocean_ssh_key" "cks" {
  name       = "CKS SSH Key"
  public_key = tls_private_key.example.public_key_openssh
}

resource "digitalocean_vpc" "vpc" {
  name     = "cks-vpc"
  region   = "lon1"
  ip_range = "10.10.0.0/16"
}

resource "digitalocean_droplet" "droplet1" {
  name     = "cks-droplet-1"
  image    = "ubuntu-22-04-x64"
  region   = "lon1"
  size     = "s-2vcpu-2gb"
  ssh_keys = [digitalocean_ssh_key.cks.id]
  vpc_uuid = digitalocean_vpc.vpc.id
}

resource "digitalocean_droplet" "droplet2" {
  name     = "cks-droplet-2"
  image    = "ubuntu-22-04-x64"
  region   = "lon1"
  size     = "s-2vcpu-2gb"
  ssh_keys = [digitalocean_ssh_key.cks.id]
  vpc_uuid = digitalocean_vpc.vpc.id
}

resource "digitalocean_firewall" "cks_firewall" {
  name = "cks-firewall"

  droplet_ids = [
    digitalocean_droplet.droplet1.id,
    digitalocean_droplet.droplet2.id
  ]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [var.allowed_ip_range]
  }

  inbound_rule {
    protocol         = "tcp"
    port_range       = "6443"
    source_addresses = [var.allowed_ip_range]
  }

  outbound_rule {
    protocol         = "tcp"
    port_range       = "all"
    destination_addresses = ["0.0.0.0/0"]
  }
}

output "droplet1_public_ip" {
  value = digitalocean_droplet.droplet1.ipv4_address
}

output "droplet2_public_ip" {
  value = digitalocean_droplet.droplet2.ipv4_address
}

output "ssh_private_key" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}
