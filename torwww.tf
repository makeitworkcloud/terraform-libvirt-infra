/*
resource "libvirt_volume" "torwww" {
  pool   = "default"
  source = "https://download.fedoraproject.org/pub/fedora/linux/releases/42/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2"
  format = "qcow2"
  name   = "torwww.qcow2"
}

data "template_file" "torwww_meta_data" {
  template = file("${path.module}/cloud-init/torwww/meta_data.cfg")
}

data "template_file" "torwww_user_data" {
  template = file("${path.module}/cloud-init/torwww/cloud_init.cfg")
}

data "template_file" "torwww_network_config" {
  template = file("${path.module}/cloud-init/torwww/network_config.cfg")
}

resource "libvirt_cloudinit_disk" "torwww_commoninit" {
  name           = "torwww_commoninit.iso"
  meta_data      = data.template_file.torwww_meta_data.rendered
  user_data      = data.template_file.torwww_user_data.rendered
  network_config = data.template_file.torwww_network_config.rendered
  depends_on     = [data.template_file.torwww_meta_data, data.template_file.torwww_user_data, data.template_file.torwww_network_config]
}

resource "libvirt_domain" "torwww" {
  name        = "torwww"
  description = "Onion web mirror"
  cpu {
    mode = "host-passthrough"
  }
  vcpu      = "1"
  memory    = "8192"
  cloudinit = libvirt_cloudinit_disk.torwww_commoninit.id
  disk {
    volume_id = libvirt_volume.torwww.id
  }
  network_interface {
    network_name = "default"
  }
  network_interface {
    bridge = "nm-bridge"
  }
  graphics {
    type           = "vnc"
    listen_type    = "address"
    listen_address = "0.0.0.0"
    autoport       = true
  }
  boot_device {
    dev = ["cdrom", "hd"]
  }
  type       = "kvm"
  depends_on = [libvirt_volume.torwww, libvirt_cloudinit_disk.torwww_commoninit]
}

data "aap_organization" "torwww_org" {
  name       = "Default"
  depends_on = [libvirt_domain.torwww]
}

data "aap_inventory" "torwww_inventory" {
  name              = "libvirt-infra"
  organization_name = data.aap_organization.torwww_org.name
  depends_on        = [data.aap_organization.torwww_org]
}

resource "aap_host" "torwww" {
  name         = "torwww"
  description  = "Onion web mirror"
  inventory_id = data.aap_inventory.torwww_inventory.id
  enabled      = true
  variables = jsonencode({
    ansible_host            = "${data.sops_file.secret_vars.data["torwww_ip_addr"]}"
    ansible_ssh_common_args = "-o ProxyCommand=\"ssh -o StrictHostKeyChecking=no -W %h:%p ${data.sops_file.secret_vars.data["proxyhost"]}\""
  })
  depends_on = [data.aap_inventory.torwww_inventory]
}

data "aap_job_template" "configure_torwww" {
  name              = "configure_torwww"
  organization_name = data.aap_organization.torwww_org.name
  depends_on        = [data.aap_organization.torwww_org]
}

resource "aap_job" "torwww" {
  job_template_id = data.aap_job_template.configure_torwww.id
  depends_on      = [aap_host.torwww, data.aap_job_template.configure_torwww]
}
*/
