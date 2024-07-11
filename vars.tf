variable "location" {
  type        = string
  description = "Which Hetzner location to use"
  default     = "fsn1"
}

variable "image" {
  type        = string
  description = "os image"
  default     = "debian-12"
}

variable "server_type" {
  type = string
  description = "server type"
  default = "cx21"
}

variable "pubkey_fpr" {
  type = string
  description = "fingerprint of pubkey to deploy to servers"
  }
