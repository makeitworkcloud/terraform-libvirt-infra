/*resource "libvirt_volume" "runner" {
  name           = "runner.qcow2"
  base_volume_id = libvirt_volume.template-server.id
}

resource "libvirt_volume" "runner-var-lib-docker" {
  name = "runner-var-lib-docker.qcow2"
  size = 107374182400
}

resource "libvirt_domain" "runner" {
  name        = "runner"
  description = "GitHub Actions self-hosted runner"
  cpu {
    mode = "host-passthrough"
  }
  vcpu   = "1"
  memory = "8192"
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
  type       = "kvm"
  depends_on = [libvirt_volume.runner, libvirt_volume.runner-var-lib-docker]
}

resource "aap_job" "runner" {
  job_template_id = 9
  depends_on      = [libvirt_domain.runner]
}*/
