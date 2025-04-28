variable "service_principal_name" {
  type        = string
  default     = null
  description = "Display name of the replicator service principal."
}

variable "create_password" {
  type        = bool
  description = "Create a password for the enterprise application."
}

variable "workload_identity_federation" {
  default     = null
  description = "Enable workload identity federation instead of using a password by providing these additional settings. Usually you should receive the required settings when attempting to configure a platform with workload identity federation in meshStack."
  type        = object({ issuer = string, access_subject = string })
}

variable "application_owners" {
  type        = list(string)
  description = "List of user principals that should be added as owners to the replicator service principal."
  default     = []
}

variable "scope" {
  type        = string
  description = "The scope of the service principal. The scope is usually the id of the aks subscription"
}
