data "sops_file" "secret_vars" {
  source_file = "${path.module}/secrets/secrets.yaml"
}

module "runner" {
  source      = "./modules/mitw_domain"
  name        = "runner"
  description = "GitHub Actions self-hosted runner"
  memory      = 8192
  extra_volumes = [
    {
      name         = "runner-var-lib-docker.qcow2"
      size         = 107374182400
      block_device = "/dev/vdb"
    }
  ]
  cloudinit_meta_data_template      = file("${path.module}/cloud-init/meta_data.cfg")
  cloudinit_meta_data_vars          = { hostname = "runner" }
  cloudinit_user_data_template      = file("${path.module}/cloud-init/runner/cloud_init.cfg")
  cloudinit_user_data_vars          = { ssh_authorized_key = data.sops_file.secret_vars.data["ssh_admin_pubkey"] }
  cloudinit_network_config_template = file("${path.module}/cloud-init/network_config.cfg")
  cloudinit_network_config_vars     = { private_ip_addr = data.sops_file.secret_vars.data["runner_ip_addr"] }
  private_ip_addr                   = data.sops_file.secret_vars.data["runner_ip_addr"]
  proxyhost                         = data.sops_file.secret_vars.data["proxyhost"]
  enable_aap                        = true
}

module "torwww" {
  source                            = "./modules/mitw_domain"
  name                              = "torwww"
  description                       = "Tor hidden service web mirror"
  memory                            = 4096
  cloudinit_meta_data_template      = file("${path.module}/cloud-init/meta_data.cfg")
  cloudinit_meta_data_vars          = { hostname = "torwww" }
  cloudinit_user_data_template      = file("${path.module}/cloud-init/torwww/cloud_init.cfg")
  cloudinit_user_data_vars          = { ssh_authorized_key = data.sops_file.secret_vars.data["ssh_admin_pubkey"] }
  cloudinit_network_config_template = file("${path.module}/cloud-init/network_config.cfg")
  cloudinit_network_config_vars     = { private_ip_addr = data.sops_file.secret_vars.data["torwww_ip_addr"] }
  private_ip_addr                   = data.sops_file.secret_vars.data["torwww_ip_addr"]
  proxyhost                         = data.sops_file.secret_vars.data["proxyhost"]
  enable_aap                        = true
}
