resource "libvirt_volume" "boot" {
  source = var.boot_image_url
  format = "qcow2"
  name   = var.boot_image_name
}

resource "libvirt_volume" "extra" {
  count = length(var.extra_volumes)
  name  = var.extra_volumes[count.index].name
  size  = var.extra_volumes[count.index].size
}

data "template_file" "meta_data" {
  template = var.cloudinit_meta_data_template
  vars     = var.cloudinit_meta_data_vars
}

data "template_file" "user_data" {
  template = var.cloudinit_user_data_template
  vars     = var.cloudinit_user_data_vars
}

data "template_file" "network_config" {
  template = var.cloudinit_network_config_template
  vars     = var.cloudinit_network_config_vars
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "${var.name}_commoninit.iso"
  meta_data      = data.template_file.meta_data.rendered
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  depends_on     = [data.template_file.meta_data, data.template_file.user_data, data.template_file.network_config]
}

resource "libvirt_domain" "vm" {
  name        = var.name
  description = var.description
  cpu {
    mode = "host-passthrough"
  }
  vcpu      = var.vcpu
  memory    = var.memory
  cloudinit = libvirt_cloudinit_disk.commoninit.id

  disk {
    volume_id = libvirt_volume.boot.id
  }

  dynamic "disk" {
    for_each = libvirt_volume.extra
    content {
      volume_id    = disk.value.id
      block_device = var.extra_volumes[disk.key].block_device
    }
  }

  lifecycle {
    ignore_changes = [disk]
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
  depends_on = [libvirt_volume.boot, libvirt_cloudinit_disk.commoninit]
}

data "aap_organization" "org" {
  count      = var.enable_aap ? 1 : 0
  name       = var.aap_org_name
  depends_on = [libvirt_domain.vm]
}

data "aap_inventory" "inventory" {
  count             = var.enable_aap ? 1 : 0
  name              = var.aap_inventory_name
  organization_name = data.aap_organization.org[0].name
  depends_on        = [data.aap_organization.org]
}

resource "aap_host" "host" {
  count        = var.enable_aap ? 1 : 0
  name         = var.name
  description  = var.description
  inventory_id = data.aap_inventory.inventory[0].id
  enabled      = true
  variables = jsonencode({
    ansible_host            = var.private_ip_addr
    ansible_ssh_common_args = "-o ProxyCommand=\"ssh -o StrictHostKeyChecking=no -W %h:%p ${var.proxyhost}\""
  })
  depends_on = [data.aap_inventory.inventory]
}

data "aap_job_template" "job_template" {
  count             = var.enable_aap ? 1 : 0
  name              = var.aap_job_template_name
  organization_name = data.aap_organization.org[0].name
  depends_on        = [data.aap_organization.org]
}

resource "aap_job" "job" {
  count           = var.enable_aap ? 1 : 0
  job_template_id = data.aap_job_template.job_template[0].id
  depends_on      = [aap_host.host, data.aap_job_template.job_template]
}