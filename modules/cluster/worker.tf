###########################
# Get Disk Information
###########################
data "talos_machine_disks" "worker" {
  for_each = local.worker_nodes

  client_configuration = talos_machine_secrets.this.client_configuration
  node                 = each.value
  selector             = var.disk_selector
}

###########################
# Machine configuration
###########################
data "talos_machine_configuration" "worker" {
  for_each = local.worker_nodes

  cluster_endpoint = local.cluster_endpoint_https
  cluster_name     = var.cluster_name
  machine_type     = "worker"

  kubernetes_version = var.kubernetes_version
  talos_version      = var.talos_version

  machine_secrets = talos_machine_secrets.this.machine_secrets
  config_patches  = concat(var.worker_config_patches, [local.worker_install_patches[each.value]])
}

resource "talos_machine_configuration_apply" "worker" {
  for_each = local.worker_nodes

  client_configuration        = talos_machine_secrets.this.client_configuration
  machine_configuration_input = data.talos_machine_configuration.worker[each.value].machine_configuration
  node                        = each.value
  endpoint                    = each.value

  on_destroy = {
    reset = var.reset_worker_on_destroy
  }
}

###########################
# Schematic
###########################
data "talos_image_factory_extensions_versions" "worker" {
  talos_version = var.talos_version
  filters = {
    names = concat(var.global_extensions, var.worker_extensions)
  }
}

resource "talos_image_factory_schematic" "worker" {
  schematic = yamlencode(
    {
      customization = {
        systemExtensions = {
          officialExtensions = sort(tolist(data.talos_image_factory_extensions_versions.worker.extensions_info[*].name))
        }
      }
    }
  )
}