resource "local_file" "kubernetes_config" {
  content  = azurerm_kubernetes_cluster.bosscluster.kube_config_raw
  filename = "kubeconfig.yaml"
}
