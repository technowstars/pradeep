terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.1"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "primary" {
  name     = "golden-image"
  location = "West Europe"
}

data "azurerm_virtual_network" "existing_vnet" {
  name                = "VNET-SPOKE-AMS-2452"
  resource_group_name = "RG-VNET-SPOKE-AMS-2452"
}

data "azurerm_subnet" "PvtSubnet" {
  name                 = "Subnet-1"
  virtual_network_name = data.azurerm_virtual_network.existing_vnet.name
  resource_group_name  = data.azurerm_virtual_network.existing_vnet.resource_group_name

}

resource "azurerm_network_interface" "golden-image" {
  name                = "golden-image-nic"
  location            = azurerm_resource_group.primary.location
  resource_group_name = azurerm_resource_group.primary.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.PvtSubnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "goldenvm" {
  name                = "sflpgoldvm"
  resource_group_name = azurerm_resource_group.primary.name
  location            = "West Europe"
  size                = "Standard_B2as_v2"
  admin_username      = "sflpadmin"
  admin_password      = "Sflp000@Project"
  network_interface_ids = [
    azurerm_network_interface.golden-image.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsDesktop"
    offer     = "windows-11"
    sku       = "win11-21h2-avd"
    version   = "latest"
  }
}

resource "azurerm_virtual_machine_extension" "vm_extension_install" {
  depends_on=[azurerm_windows_virtual_machine.goldenvm]
  name                       = "vm_extension_install"
  virtual_machine_id         = azurerm_windows_virtual_machine.goldenvm.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.9"
  auto_upgrade_minor_version = true
  protected_settings = <<SETTINGS
  {
    "commandToExecute": "powershell -command \"[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String('${base64encode(data.template_file.tf.rendered)}')) | Out-File -filepath install.ps1\" && powershell -ExecutionPolicy Unrestricted -File install.ps1"
  }
  SETTINGS
}

data "template_file" "tf" {
    template = "${file("install.ps1")}"
}