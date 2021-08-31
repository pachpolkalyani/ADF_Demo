
terraform {
backend "azurerm" {
resource_group_name = "rg-cloudquickpocs"
storage_account_name = "ccpsazuretf0001"
container_name = "ccpterrraformstatefile"
key = "ccpsterraform.tfstate"
}
}
provider "azurerm" {
  version = "~>2.20.0"
  features {}
}


resource "azurerm_storage_account" "adf_storage" {
  name                     = "strvdevdemo"
  resource_group_name      = var.resource-group-dev
  location                 = var.resource-location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  tags = {
    environment = "dev"
    do          = "delete"
  }
}

resource "azurerm_storage_container" "adf_storage_source_01" {
  name                  = "adfstoragesource01"
  storage_account_name  = azurerm_storage_account.adf_storage.name
  container_access_type = "public"
}

resource "azurerm_storage_container" "adf_storage_target_01" {
  name                  = "adfstoragetarget01"
  storage_account_name  = azurerm_storage_account.adf_storage.name
  container_access_type = "public"
}

resource "azurerm_data_factory" "adf_test" {
  name                = "Azure_ADF_Demo"
  resource_group_name = var.resource-group-dev
  location            = var.resource-location

  #github_configuration {
   # account_name    = "pachpolkalyani"
   # branch_name     = "adf_dev"
  #  git_url         = "https://github.com"
    #repository_name = "ADF_dev"
   # root_folder     = "/adf_artifacts"
 # }

}

resource "azurerm_data_factory_linked_service_azure_blob_storage" "adf_blob_link_01" {
  name                = "adfbloblink01"
  resource_group_name = var.resource-group-dev
  data_factory_name   = azurerm_data_factory.adf_test.name
  connection_string   = azurerm_storage_account.adf_storage.primary_connection_string

}

resource "azurerm_data_factory_dataset_azure_blob" "adf_ds_blob_01" {
  name                = "adfdsblob01"
  resource_group_name = var.resource-group-dev
  data_factory_name   = azurerm_data_factory.adf_test.name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.adf_blob_link_01.name
  path                = azurerm_storage_container.adf_storage_source_01.name

 }

resource "azurerm_data_factory_dataset_azure_blob" "adf_ds_blob_02" {
  name                = "adfdsblob02"
  resource_group_name = var.resource-group-dev
  data_factory_name   = azurerm_data_factory.adf_test.name
  linked_service_name = azurerm_data_factory_linked_service_azure_blob_storage.adf_blob_link_01.name
  path                = azurerm_storage_container.adf_storage_target_01.name

}

resource "azurerm_data_factory_pipeline" "adf_pipeline_01" {
  name                = "adfpipeline01"
  resource_group_name = var.resource-group-dev
  data_factory_name   = azurerm_data_factory.adf_test.name
}
