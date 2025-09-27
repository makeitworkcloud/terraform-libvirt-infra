variable "name" {
  description = "The name of the libvirt domain (virtual machine) and related resources."
  type        = string
}

variable "description" {
  description = "Description for the libvirt domain (virtual machine)."
  type        = string
}

variable "vcpu" {
  description = "Number of virtual CPUs to assign to the domain."
  type        = number
}

variable "memory" {
  description = "Amount of memory (in MB) to assign to the domain."
  type        = number
}

variable "boot_image_url" {
  description = "URL for the base QCOW2 image used as the boot disk."
  type        = string
}

variable "boot_image_name" {
  description = "Name for the boot disk volume created from the QCOW2 image."
  type        = string
}

variable "extra_volumes" {
  description = <<EOF
List of additional volumes to attach to the domain. Each object should contain:
  - name: Name of the volume.
  - size: Size of the volume in bytes.
  - block_device: Device path to attach (e.g., /dev/vdb).
Example:
[
  {
    name        = "runner-var-lib-docker.qcow2"
    size        = 107374182400
    block_device = "/dev/vdb"
  }
]
EOF
  type = list(object({
    name         = string
    size         = number
    block_device = string
  }))
  default = []
}

variable "cloudinit_meta_data_template" {
  description = "The template content for cloud-init meta-data configuration."
  type        = string
}

variable "cloudinit_meta_data_vars" {
  description = "Variable map for the cloud-init meta-data template."
  type        = map(string)
}

variable "cloudinit_user_data_template" {
  description = "The template content for cloud-init user-data configuration."
  type        = string
}

variable "cloudinit_user_data_vars" {
  description = "Variable map for the cloud-init user-data template. Set to {} if not used."
  type        = map(string)
}

variable "cloudinit_network_config_template" {
  description = "The template content for cloud-init network configuration."
  type        = string
}

variable "cloudinit_network_config_vars" {
  description = "Variable map for the cloud-init network configuration template."
  type        = map(string)
}

variable "hostname" {
  description = "Hostname for the VM. Used for naming and cloud-init."
  type        = string
}

variable "private_ip_addr" {
  description = "Private IP address to assign to the VM (used for network config and inventory)."
  type        = string
}

variable "proxyhost" {
  description = "Proxy host for SSH connection, used in ansible_ssh_common_args."
  type        = string
}

variable "enable_aap" {
  description = "Whether to provision Ansible Automation Platform (AAP) resources for this domain."
  type        = bool
  default     = true
}

variable "aap_org_name" {
  description = "Name of the Ansible Automation Platform (AAP) organization."
  type        = string
}

variable "aap_inventory_name" {
  description = "Name of the AAP inventory to use."
  type        = string
}

variable "aap_job_template_name" {
  description = "Name of the AAP job template to run."
  type        = string
}