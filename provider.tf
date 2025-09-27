terraform {
  required_version = "> 1.3"

  backend "s3" {}

  required_providers {
    aap = {
      source = "registry.terraform.io/ansible/aap"
    }
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.7.6"
    }
    sops = {
      source = "carlpett/sops"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}

provider "libvirt" {
  uri = data.sops_file.secret_vars.data["libvirt_uri"]
}

provider "aap" {
  host     = data.sops_file.secret_vars.data["aap_controller"]
  username = data.sops_file.secret_vars.data["aap_username"]
  password = data.sops_file.secret_vars.data["aap_password"]
}

provider "sops" {}
