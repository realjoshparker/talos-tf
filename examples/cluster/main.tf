module "cluster" {
  source = "../../modules/cluster"

  cluster_name     = var.cluster_name
  cluster_endpoint = var.cluster_endpoint

  kubernetes_version = var.kubernetes_version
  talos_version      = var.talos_version

  # Global config
  global_extensions = var.global_extensions
  disk_selector     = var.disk_selector

  # Control plane config
  controlplane_config_patches   = [for p in var.controlplane_config_patches : file(p)]
  controlplane_nodes            = var.controlplane_nodes
  controlplane_extensions       = var.controlplane_extensions
  reset_controlplane_on_destroy = var.reset_controlplane_on_destroy

  # Worker config
  worker_config_patches   = [for p in var.worker_config_patches : file(p)]
  worker_nodes            = var.worker_nodes
  worker_extensions       = var.worker_extensions
  reset_worker_on_destroy = var.reset_worker_on_destroy
}
