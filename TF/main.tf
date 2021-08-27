provider "azurerm" {
    version = ">=2.0.0"
    subscription_id = var.var_subscription_id
    client_id = var.var_client_id
    tenant_id = var.var_tenant_id
    client_secret = var.var_client_secret
    features{}
}

terraform {
    backend "azurerm" {
        resource_group_name = "DEV_RG"
        storage_account_name = "strvdev"
        container_name = "dev"
        key = "mainfile1.tfstate"
    }
}

resource "azurerm_resource_group" "RG" {
    name     = var.var_RG_name
    location = var.var_location
}

resource "azurerm_storage_account" "STG" {
   name = var.var_Storage_name
   resource_group_name = azurerm_resource_group.RG.name
   location = var.var_location
   account_tier = var.var_account_tier
   account_replication_type = var.var_account_replication_type
 }


//module "storage_account" {
// source = "./TF/modules"
// var_location = var.var_location
//  var_storage_name = var.var_Storage_name
//  var_account_tier = var.var_account_tier
//  var_account_replication_type = var.var_account_replication_type  
//}
