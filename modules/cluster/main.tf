###########################
# HA endpoint check
###########################
check "ha_endpoint" {
  assert {
    condition     = length(var.controlplane_nodes) <= 1 || var.cluster_endpoint != null
    error_message = "Multiple control plane nodes detected but cluster_endpoint is not set. All API traffic will route to ${var.controlplane_nodes[0]} only, which defeats HA. Set cluster_endpoint to a VIP or load balancer IP (e.g. kube-vip)."
  }
}

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