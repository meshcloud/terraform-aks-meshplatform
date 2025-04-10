output "token_metering" {
  sensitive = true
  value     = kubernetes_secret.meshfed_metering_secret.data["token"]
}

output "expose_token" {
  value = "Expose the token with: terraform output -json token_metering "
}

