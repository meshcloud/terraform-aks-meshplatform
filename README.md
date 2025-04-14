# AKS meshPlatform Module

Terraform module to integrate AKS as a meshPlatform into meshStack instance. The output of this module is a set of Service Account credentials that need to be configured in meshStack as described in [meshcloud public docs](https://docs.meshcloud.io/docs/meshstack.how-to.integrate-meshplatform.html).

## Prerequisites

To run this module, you need:

- cluster admin permissions on the cluster
- [Terraform installed](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [kubectl installed](https://kubernetes.io/docs/tasks/tools/#kubectl)

To integrate an AKS cluster, you additionally need:

- An AKS cluster with [Azure AD enabled](https://learn.microsoft.com/en-us/azure/aks/managed-aad)
- Integrate [RBAC based user access](https://learn.microsoft.com/en-us/azure/aks/manage-azure-rbac) with the AKS cluster

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | >=3.0.2 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=4.26.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.15.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.13.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_meshcloud-service-account-meshfed-metering"></a> [meshcloud-service-account-meshfed-metering](#module\_meshcloud-service-account-meshfed-metering) | git::https://github.com/meshcloud/terraform-kubernetes-meshplatform.git//modules/meshcloud-service-account-meshfed-metering | v0.1.0 |
| <a name="module_meshcloud-service-account-meshfed-replicator"></a> [meshcloud-service-account-meshfed-replicator](#module\_meshcloud-service-account-meshfed-replicator) | git::https://github.com/meshcloud/terraform-kubernetes-meshplatform.git//modules/meshcloud-service-account-meshfed-replicator | v0.1.0 |
| <a name="module_replicator_service_principal"></a> [replicator\_service\_principal](#module\_replicator\_service\_principal) | ./modules/meshcloud-replicator-service-principal | n/a |

## Resources

| Name | Type |
|------|------|
| [kubernetes_namespace.meshcloud](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_owners"></a> [application\_owners](#input\_application\_owners) | List of user principals that should be added as owners to the replicator service principal. | `list(string)` | `[]` | no |
| <a name="input_create_password"></a> [create\_password](#input\_create\_password) | Create a password for the enterprise application. | `bool` | n/a | yes |
| <a name="input_metering_additional_rules"></a> [metering\_additional\_rules](#input\_metering\_additional\_rules) | n/a | <pre>list(object({<br/>    api_groups        = list(string)<br/>    resources         = list(string)<br/>    verbs             = list(string)<br/>    resource_names    = optional(list(string))<br/>    non_resource_urls = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_metering_enabled"></a> [metering\_enabled](#input\_metering\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | name of the namespace where the replicator and metering components should be deployed | `string` | `"meshcloud"` | no |
| <a name="input_replicator_additional_rules"></a> [replicator\_additional\_rules](#input\_replicator\_additional\_rules) | n/a | <pre>list(object({<br/>    api_groups        = list(string)<br/>    resources         = list(string)<br/>    verbs             = list(string)<br/>    resource_names    = optional(list(string))<br/>    non_resource_urls = optional(list(string))<br/>  }))</pre> | `[]` | no |
| <a name="input_replicator_enabled"></a> [replicator\_enabled](#input\_replicator\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_scope"></a> [scope](#input\_scope) | The scope of the service principal. The scope is usually the id of the aks subscription | `string` | n/a | yes |
| <a name="input_service_principal_name"></a> [service\_principal\_name](#input\_service\_principal\_name) | Display name of the replicator service principal. | `string` | n/a | yes |
| <a name="input_workload_identity_federation"></a> [workload\_identity\_federation](#input\_workload\_identity\_federation) | Enable workload identity federation instead of using a password by providing these additional settings. Usually you should receive the required settings when attempting to configure a platform with workload identity federation in meshStack. | `object({ issuer = string, subject = string })` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_metering_expose_token"></a> [metering\_expose\_token](#output\_metering\_expose\_token) | n/a |
| <a name="output_metering_token"></a> [metering\_token](#output\_metering\_token) | # METERING |
| <a name="output_replicator_expose_token"></a> [replicator\_expose\_token](#output\_replicator\_expose\_token) | n/a |
| <a name="output_replicator_service_principal"></a> [replicator\_service\_principal](#output\_replicator\_service\_principal) | Replicator Service Principal. |
| <a name="output_replicator_service_principal_password"></a> [replicator\_service\_principal\_password](#output\_replicator\_service\_principal\_password) | Password for Replicator Service Principal. |
| <a name="output_replicator_token"></a> [replicator\_token](#output\_replicator\_token) | n/a |
<!-- END_TF_DOCS -->
