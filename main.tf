resource "hcloud_firewall" "myfirewall" {
  name = "my-firewall"
  rule {
    description = "allow ssh traffic"
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }
}

resource "hcloud_network" "project_private_network" {
  name     = " Project Private Network"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "project_private_network_subnet" {
  type         = "cloud"
  network_id   = hcloud_network.project_private_network.id
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

resource "hcloud_server" "cp" {
  name               = "mgmtcp0"
  delete_protection  = false
  rebuild_protection = false
  location           = var.location
  image              = var.image
  server_type        = var.server_type
  firewall_ids       = [ hcloud_firewall.myfirewall.id ]
  ssh_keys           = [ data.hcloud_ssh_key.beta-lab_pubkey.id ]
  network {
    network_id = hcloud_network.project_private_network.id
  }
  connection {
    private_key = file("~/.ssh/id_ed25519")
    host        = self.ipv4_address
  }
  provisioner "remote-exec" {
    inline = [
      "apt update",
    ]
  }
  # make sure network subnet is already created before server creation:
  # (do not use ID attribute in 'depends_on'!)
  depends_on = [
    hcloud_network_subnet.project_private_network_subnet
  ]
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



