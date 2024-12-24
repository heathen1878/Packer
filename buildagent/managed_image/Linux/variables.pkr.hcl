variable tenant_id {
    type = string
    description = "The AAD instance the subscription is associated wiht, can be implied by subscription id - can use environment variable e.g. PKR_VAR_tenant_id"
    default = null
}

variable use_interactive_auth {
    type = bool
    description = "Boolean to determine whether to use interactive login or service principal - useful for pipelines."
    default = false
}

variable client_id {
    type = string
    description = "Azure Service Principal client id - can use environment variable e.g. PKR_VAR_client_id"
    default = ""
}

variable client_secret {
    type = string
    description = "Azure Service Principal client password / secret - can use environment variable e.g. PKR_VAR_client_secret"
    default = ""
    sensitive = true
}

variable location {
    type = string
    description = "The Azure region"
    default = ""
}

variable subscription_id {
    type = string
    description = "The subscription to use - can use environment variable e.g. PKR_VAR_subscription_id"
    default = ""
}

variable os_type {
    type = string
    description = "Windows or Linux"
    default = "Linux"
}

variable image_publisher {
    type = string
    description = "MicrosoftWindowsServer or Canonical"
    default = "Canonical"
}
    
variable image_offer {
    type = string
    description = "Use az vm image list-offers --location [location] --publisher [MicrosoftWindowsServer|Canonical] --query [].name"
    default = "0001-com-ubuntu-server-focal"
}
    
variable image_sku {
    type = string
    description = "Use vm image list-skus --location [location] --publisher [MicrosoftWindowsServer|Canonical] --offer [WindowsServer|0001-com-ubuntu-server-focal] --query [].name"
    default = "20_04-lts"
}
    
variable image_version {
    type = string
    description = "Use az vm image list --location [location] --publisher [MicrosoftWindowsServer|Canonical] --offer [WindowsServer|0001-com-ubuntu-server-focal] --sku [2019-Datacenter|20_04-lts] --all"
    default = "latest"
}

variable resource_group_name {
    type = string
    description = "The resource group where the shared image gallery exists"
    default = "Packer"
}

variable shared_image_gallery_name {
    type = string
    description = "The shared image gallery where the managed image will be stored"
    default = "Packer"
}

variable managed_image_name {
    type = string
    description = "The image defintion name"
}

variable managed_image_version {
    type = string
    description = "The managed image version e.g. 1.0.0"
}

variable shared_image_gallery_destination_locations {
    type = list(string)
    description = "A list of regions"
    default = ["North Europe"]
}

variable storage_account_name {
    type = string
    description = "Storage Account Name"
    default = "st"
}

variable storage_account_type {
    type = string
    description = "Storage Account type - defaults to Standard LRS"
    default = "Standard_LRS"
}

variable vm_size {
    type = string
    description = "VM hardware sku used for building - defaults to Standard A1"
    default = "Standard_A1"
}

variable azure_tags {
    type = map(string)
    description = "A map of tags"
    default = {
        IaC = "ARM"
        applicationName = "Packer"
    }
}

locals {
    capture_container_name = "${lower(var.os_type)}-images"
    tags = merge(var.azure_tags, {
        location = var.location
        }
    )

    managed_image_name = format("%s-%s", var.managed_image_name, formatdate("DDMMhhmm", timestamp()))
    storage_account = "${lower(var.storage_account_name)}"
    
}
