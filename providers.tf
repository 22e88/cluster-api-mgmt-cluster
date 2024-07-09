terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.47.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "=2.2.3"
    }
  }
  required_version = ">= 0.13"
}


