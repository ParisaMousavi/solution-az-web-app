module "rg_name" {
  source             = "github.com/ParisaMousavi/az-naming//rg?ref=2022.10.07"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}

module "resourcegroup" {
  # https://{PAT}@dev.azure.com/{organization}/{project}/_git/{repo-name}
  source   = "github.com/ParisaMousavi/az-resourcegroup?ref=2022.10.07"
  location = var.location
  name     = module.rg_name.result
  tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}

module "app_plan_name" {
  source             = "github.com/ParisaMousavi/az-naming//app-service-plan?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}

module "app_service_plan" {
  source              = "github.com/ParisaMousavi/az-app-service-plan?ref=main"
  name                = module.app_plan_name.result
  location            = module.resourcegroup.location
  resource_group_name = module.resourcegroup.name
  os_type             = "Windows"
  worker_count        = 1
  sku_name            = "F1"
  additional_tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}

module "web_app_name" {
  source             = "github.com/ParisaMousavi/az-naming//app-service-plan?ref=main"
  prefix             = var.prefix
  name               = var.name
  stage              = var.stage
  location_shortname = var.location_shortname
}

module "web_app" {
  source              = "github.com/ParisaMousavi/az-app-service?ref=main"
  name                = module.web_app_name.result
  location            = module.resourcegroup.location
  resource_group_name = module.resourcegroup.name
  app_service_plan_id = module.app_service_plan.id
  custom_domain = {
    enabled = false
  }
  additional_tags = {
    CostCenter = "ABC000CBA"
    By         = "parisamoosavinezhad@hotmail.com"
  }
}
