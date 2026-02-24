# Kubernetes Namespace
resource "kubernetes_namespace_v1" "meshcloud" {
  metadata {
    name = var.namespace
  }
}

moved {
  from = kubernetes_namespace.meshcloud
  to   = kubernetes_namespace_v1.meshcloud
}

module "replicator_service_principal" {
  count                  = var.replicator_enabled || var.service_principal_name != null ? 1 : 0
  scope                  = var.scope
  source                 = "./modules/meshcloud-replicator-service-principal"
  service_principal_name = var.service_principal_name
  create_password        = var.create_password
  workload_identity_federation = var.workload_identity_federation == null ? null : {
    issuer         = var.workload_identity_federation.issuer,
    access_subject = var.workload_identity_federation.access_subject
  }
  application_owners = var.application_owners
}

module "meshcloud-service-account-meshfed-metering" {
  count                     = var.metering_enabled ? 1 : 0
  source                    = "git::https://github.com/meshcloud/terraform-kubernetes-meshplatform.git//modules/meshcloud-service-account-meshfed-metering?ref=v0.2.0"
  namespace                 = kubernetes_namespace_v1.meshcloud.metadata.0.name
  existing_clusterrole_name = var.existing_clusterrole_name_metering
  name_suffix               = var.kubernetes_name_suffix_metering
  additional_rules          = var.metering_additional_rules
}

module "meshcloud-service-account-meshfed-replicator" {
  count                     = var.replicator_enabled ? 1 : 0
  source                    = "git::https://github.com/meshcloud/terraform-kubernetes-meshplatform.git//modules/meshcloud-service-account-meshfed-replicator?ref=v0.2.0"
  namespace                 = kubernetes_namespace_v1.meshcloud.metadata.0.name
  existing_clusterrole_name = var.existing_clusterrole_name_replicator
  name_suffix               = var.kubernetes_name_suffix_replicator
  additional_rules          = var.replicator_additional_rules
}
