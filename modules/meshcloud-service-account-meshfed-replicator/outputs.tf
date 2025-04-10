output "token_replicator" {
  sensitive = true
  value     = kubernetes_secret.meshfed_service_secret.data["token"]
}

output "expose_token" {
  value = "Expose the token with: terraform output -json token_replicator"
}
