source "azure-arm" "managed-image-build" {

    use_interactive_auth     = var.use_interactive_auth
    client_id                = var.use_interactive_auth == true ? null : var.client_id
    client_secret            = var.use_interactive_auth == true ? null : var.client_secret
    tenant_id                = var.use_interactive_auth == true ? null : var.tenant_id
    subscription_id          = var.subscription_id

    os_type                  = var.os_type
    image_publisher          = var.image_publisher
    image_offer              = var.image_offer
    image_sku                = var.image_sku
    image_version            = var.image_version

    shared_image_gallery_destination {
        subscription         = var.subscription_id
        resource_group       = var.resource_group_name
        gallery_name         = var.shared_image_gallery_name
        image_name           = var.managed_image_name
        image_version        = var.managed_image_version
        replication_regions  = var.shared_image_gallery_destination_locations
        storage_account_type = var.storage_account_type
    }
    managed_image_resource_group_name = var.resource_group_name
    managed_image_name = local.managed_image_name

    location                 = var.location

    vm_size                  = var.vm_size

    azure_tags               = local.tags

    communicator             = "winrm"
    pause_before_connecting  = "5m"
    winrm_use_ssl            = true
    winrm_insecure           = true
    winrm_timeout            = "30m"
    winrm_username           = "packer"

}