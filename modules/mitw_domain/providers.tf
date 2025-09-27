terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
    template = {
      source = "hashicorp/template"
    }
    aap = {
      source = "registry.terraform.io/ansible/aap"
    }
  }
}
