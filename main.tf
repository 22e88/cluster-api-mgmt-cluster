resource "hcloud_server" "cp" {
  name               = "mgmtcp0"
  delete_protection  = false
  rebuild_protection = false
  location           = var.location
  image              = var.image
  server_type        = var.server_type
  ssh_keys = [ data.hcloud_ssh_key.beta-lab_pubkey.id ]

  connection {
    private_key = file("~/.ssh/id_ed25519")
    host        = self.ipv4_address
  }
  provisioner "remote-exec" {
    inline = [
      "apt update",
    ]
  }
}

data "hcloud_ssh_key" "beta-lab_pubkey" {
  fingerprint = var.pubkey_fpr
}

## Generate inventory file to be used for ansible
resource "local_file" "ansible_inventory" {
  filename = "ansible/inventory/hosts.yaml"
  content = "${hcloud_server.cp.name} ansible_host=${hcloud_server.cp.ipv4_address} ansible_user=root"
  depends_on = [hcloud_server.cp]
}



