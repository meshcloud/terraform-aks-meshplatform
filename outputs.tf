## METERING
output "metering_token" {
  value     = length(module.meshcloud-service-account-meshfed-metering) > 0 ? module.meshcloud-service-account-meshfed-metering[0].token_metering : null
  sensitive = true
}

output "metering_expose_token" {
  value = "Expose the token with: terraform output -json metering_token"
}


## REPLICATOR

output "replicator_token" {
  value     = length(module.meshcloud-service-account-meshfed-replicator) > 0 ? module.meshcloud-service-account-meshfed-replicator[0].token_replicator : null
  sensitive = true
}

output "replicator_expose_token" {
  value = "Expose the token with: terraform output -json replicator_token"
}

output "replicator_service_principal" {
  description = "Replicator Service Principal."
  value       = length(module.replicator_service_principal) > 0 ? module.replicator_service_principal[0].credentials : null
}

output "replicator_service_principal_password" {
  description = "Password for Replicator Service Principal."
  value       = length(module.replicator_service_principal) > 0 ? module.replicator_service_principal[0].application_client_secret : null
  sensitive   = true
}
