resource "azurerm_resource_group" "aks-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "leo-vn" {
  name                = "${var.prefix}-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "leo-sn" {
  name                 = "${var.prefix}-subnet"
  virtual_network_name = azurerm_virtual_network.leo-vn.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = ["10.1.0.0/22"]
}


resource "azurerm_kubernetes_cluster" "aks-leo-cluster" {
  name                = "${var.prefix}-aks-cluster"
  location            = azurerm_resource_group.aks-rg.location
  resource_group_name = azurerm_resource_group.aks-rg.name
  dns_prefix          = var.prefix
  kubernetes_version  = var.kubernetes_version
  
  role_based_access_control {
		enabled = true
	}
  api_server_authorized_ip_ranges = [
		"64.0.0.0/16"
	]
  default_node_pool {
    name                = "default"
    node_count          = 2
    vm_size             = "Standard_E4s_v3"
    type                = "VirtualMachineScaleSets"
    availability_zones  = ["1", "2"]
    enable_auto_scaling = true
    min_count           = 2
    max_count           = 4
    os_disk_size_gb     = 50

    # Required for advanced networking
    vnet_subnet_id = azurerm_subnet.leo-sn.id
  }


  service_principal {
    client_id     = var.backend_client_id
    client_secret = var.backend_client_secret
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = var.backend_ssh_key
    }
  }
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
    network_policy    = "calico"
  }

  tags = {
    Environment = var.environment
  }

  addon_profile {
    aci_connector_linux {
      enabled = false
    }


    azure_policy {
      enabled = false
    }

    http_application_routing {
      enabled = false
    }

    kube_dashboard {
      enabled = false
    }

    oms_agent {
      enabled = true
    }
  }
}
