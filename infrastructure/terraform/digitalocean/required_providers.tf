terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.27.1"  # Specify the version of the DigitalOcean provider
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"  # Specify the version of the TLS provider
    }
  }
}
