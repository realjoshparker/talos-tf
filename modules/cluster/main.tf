###########################
# Machine secrets
###########################
resource "talos_machine_secrets" "this" {}

data "talos_client_configuration" "this" {
  cluster_name         = var.cluster_name
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoints            = local.controlplane_nodes
  nodes                = local.controlplane_nodes
}

###########################
# Bootstrap
###########################
resource "talos_machine_bootstrap" "this" {
  node                 = var.controlplane_nodes[0]
  client_configuration = talos_machine_secrets.this.client_configuration

  depends_on = [
    talos_machine_configuration_apply.controlplane,
    talos_machine_configuration_apply.worker
  ]

  lifecycle {
    ignore_changes = all
  }
}

###########################
# Kubeconfig
###########################
resource "talos_cluster_kubeconfig" "this" {
  client_configuration = talos_machine_secrets.this.client_configuration
  endpoint             = local.cluster_endpoint
  node                 = var.controlplane_nodes[0]

  depends_on = [
    talos_machine_bootstrap.this
  ]
}