terraform {
  required_providers {
    aap = {
      source = "registry.terraform.io/ansible/aap"
    }
    libvirt = {
      source = "dmacvicar/libvirt"
    }
    template = {
      source = "hashicorp/template"
    }
  }
}
