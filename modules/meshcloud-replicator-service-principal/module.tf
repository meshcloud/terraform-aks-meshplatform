data "azurerm_subscription" "aks" {
  subscription_id = var.scope
}

//---------------------------------------------------------------------------
// Role Definition for the Replicator on the specified Scope
//---------------------------------------------------------------------------
resource "azurerm_role_definition" "meshcloud_replicator" {
  name        = "${var.service_principal_name}-base"
  scope       = data.azurerm_subscription.aks.id
  description = "Permissions required by meshStack replicator in order to configure subscriptions and manage users"

  permissions {
    actions = [
      "Microsoft.Resources/subscriptions/read",
      "Microsoft.Authorization/roleAssignments/*"

    ]
  }

  assignable_scopes = [
    data.azurerm_subscription.aks.id
  ]
}

//---------------------------------------------------------------------------
// Queries Entra ID for information about well-known application IDs.
// Retrieve details about the service principal
//---------------------------------------------------------------------------

data "azuread_application_published_app_ids" "well_known" {}

data "azuread_service_principal" "msgraph" {
  client_id = data.azuread_application_published_app_ids.well_known.result.MicrosoftGraph
}

//---------------------------------------------------------------------------
// Create New application in Microsoft Entra ID
//---------------------------------------------------------------------------
data "azuread_application_template" "enterprise_app" {
  # will create the application based on this template ID to have features like Provisioning
  # available in the enterprise application
  template_id = "8adf8e6e-67b2-4cf2-a259-e3dc5476c621"
}
resource "azuread_application" "meshcloud_replicator" {
  display_name = var.service_principal_name
  owners       = var.application_owners
  template_id  = data.azuread_application_template.enterprise_app.template_id
  feature_tags {
    enterprise = true
  }

  web {
    implicit_grant {
      access_token_issuance_enabled = false
    }
  }
}

//---------------------------------------------------------------------------
// Create new Enterprise Application and associate it with the application
//---------------------------------------------------------------------------
resource "azuread_service_principal" "meshcloud_replicator" {
  client_id = azuread_application.meshcloud_replicator.client_id
  owners    = var.application_owners
  feature_tags {
    enterprise = true
  }
  # creating an application base on the template, makes a enterprise application being created
  # to use that enterprise application we have to include use_existing line.
  # there is caveat here, if an error happens during destorying this enterprise app, Terraform
  # might not display it https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal#use_existing
  use_existing = true
}

//---------------------------------------------------------------------------
// Assign the created ARM role to the Enterprise application
//---------------------------------------------------------------------------
resource "azurerm_role_assignment" "meshcloud_replicator" {
  scope              = data.azurerm_subscription.aks.id
  role_definition_id = azurerm_role_definition.meshcloud_replicator.role_definition_resource_id
  principal_id       = azuread_service_principal.meshcloud_replicator.object_id
}

//---------------------------------------------------------------------------
// Assign Entra ID Roles to the Enterprise application
//---------------------------------------------------------------------------
resource "azuread_app_role_assignment" "meshcloud_replicator-directory" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["Directory.Read.All"]
  principal_object_id = azuread_service_principal.meshcloud_replicator.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
  depends_on          = [azuread_application.meshcloud_replicator]
}

resource "azuread_app_role_assignment" "meshcloud_replicator-group" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["Group.ReadWrite.All"]
  principal_object_id = azuread_service_principal.meshcloud_replicator.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
  depends_on          = [azuread_application.meshcloud_replicator]
}

resource "azuread_app_role_assignment" "meshcloud_replicator-user" {
  app_role_id         = data.azuread_service_principal.msgraph.app_role_ids["User.Invite.All"]
  principal_object_id = azuread_service_principal.meshcloud_replicator.object_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
  depends_on          = [azuread_application.meshcloud_replicator]
}
