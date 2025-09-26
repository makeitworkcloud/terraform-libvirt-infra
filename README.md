<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | > 1.3 |
| <a name="requirement_libvirt"></a> [libvirt](#requirement\_libvirt) | 0.7.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aap"></a> [aap](#provider\_aap) | n/a |
| <a name="provider_libvirt"></a> [libvirt](#provider\_libvirt) | 0.7.6 |
| <a name="provider_sops"></a> [sops](#provider\_sops) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| aap_host.runner | resource |
| aap_job.runner | resource |
| [libvirt_cloudinit_disk.runner_commoninit](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.6/docs/resources/cloudinit_disk) | resource |
| [libvirt_domain.runner](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.6/docs/resources/domain) | resource |
| [libvirt_volume.runner](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.6/docs/resources/volume) | resource |
| [libvirt_volume.runner-var-lib-docker](https://registry.terraform.io/providers/dmacvicar/libvirt/0.7.6/docs/resources/volume) | resource |
| aap_inventory.runner_inventory | data source |
| aap_job_template.configure_runner | data source |
| aap_organization.runner_org | data source |
| [sops_file.secret_vars](https://registry.terraform.io/providers/carlpett/sops/latest/docs/data-sources/file) | data source |
| [template_file.meta_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.network_config](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.user_data](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->