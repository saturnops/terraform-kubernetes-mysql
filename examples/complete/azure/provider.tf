provider "azurerm" {
  features {}
}

data "azurerm_kubernetes_cluster" "primary" {
  name                = ""
  resource_group_name = ""
}

provider "kubernetes" {
  host                   = data.azurerm_kubernetes_cluster.primary.kube_config.0.host
  username               = data.azurerm_kubernetes_cluster.primary.kube_config.0.username
  password               = data.azurerm_kubernetes_cluster.primary.kube_config.0.password
  client_certificate     = base64decode(data.azurerm_kubernetes_cluster.primary.kube_config.0.client_certificate)
  client_key             = base64decode(data.azurerm_kubernetes_cluster.primary.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.primary.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.primary.kube_config.0.host
    client_key             = base64decode(data.azurerm_kubernetes_cluster.primary.kube_config.0.client_key)
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.primary.kube_config.0.client_certificate)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.primary.kube_config.0.cluster_ca_certificate)
  }
}
