/*
resource "libvirt_volume" "runner" {
  pool   = "default"
  source = "https://download.fedoraproject.org/pub/fedora/linux/releases/42/Cloud/x86_64/images/Fedora-Cloud-Base-Generic-42-1.1.x86_64.qcow2"
  format = "qcow2"
  name   = "runner.qcow2"
}

resource "libvirt_volume" "runner-var-lib-docker" {
  name = "runner-var-lib-docker.qcow2"
  size = 107374182400
}

data "template_file" "meta_data" {
  template = file("${path.module}/cloud-init/runner_meta_data.cfg")
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud-init/runner_cloud_init.cfg")
}

data "template_file" "network_config" {
  template = file("${path.module}/cloud-init/runner_network_config.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name           = "commoninit.iso"
  meta_data      = data.template_file.meta_data.rendered
  user_data      = data.template_file.user_data.rendered
  network_config = data.template_file.network_config.rendered
  depends_on     = [data.template_file.meta_data, data.template_file.user_data, data.template_file.network_config]
}

resource "libvirt_domain" "runner" {
  name        = "runner"
  description = "GitHub Actions self-hosted runner"
  cpu {
    mode = "host-passthrough"
  }
  vcpu      = "1"
  memory    = "8192"
  cloudinit = libvirt_cloudinit_disk.commoninit.id
  disk {
    volume_id = libvirt_volume.runner.id
  }
  disk {
    volume_id    = libvirt_volume.runner-var-lib-docker.id
    block_device = "/dev/vdb"
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
  type = "kvm"
  lifecycle {
    ignore_changes = [disk.1.block_device]
  }
  depends_on = [libvirt_volume.runner, libvirt_volume.runner-var-lib-docker, libvirt_cloudinit_disk.commoninit]
}

resource "aap_host" "runner" {
  name         = "runner"
  description  = "GitHub Actions self-hosted runner"
  inventory_id = 2
  enabled      = true
  variables = jsonencode({
    ansible_host            = "${data.sops_file.secret_vars.data["runner_ip_addr"]}"
    ansible_ssh_common_args = "-o ProxyCommand=\"ssh -o StrictHostKeyChecking=no -W %h:%p ${data.sops_file.secret_vars.data["proxyhost"]}\""
  })
  depends_on = [libvirt_domain.runner]
}

resource "aap_job" "runner" {
  job_template_id = 9
  depends_on      = [aap_host.runner]
}
*/
