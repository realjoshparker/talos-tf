locals {
  cluster_endpoint       = coalesce(var.cluster_endpoint, var.controlplane_nodes[0])
  cluster_endpoint_https = "https://${coalesce(var.cluster_endpoint, var.controlplane_nodes[0])}:6443"

  # Convert control plane node list to a set for use in for_each
  controlplane_nodes = toset(var.controlplane_nodes)
  worker_nodes       = toset(var.worker_nodes)

  # Per-node machine config patch that sets the install disk (first discovered disk on that node)
  # and the custom installer image built with the configured extensions
  controlplane_install_patches = {
    for node in local.controlplane_nodes :
    node => yamlencode({
      machine = {
        install = {
          disk  = try(tolist(data.talos_machine_disks.controlplane[node].disks[*].dev_path)[0], null)
          image = "factory.talos.dev/installer/${talos_image_factory_schematic.controlplane.id}:${var.talos_version}"
        }
      }
    })
  }

  worker_install_patches = {
    for node in local.worker_nodes :
    node => yamlencode({
      machine = {
        install = {
          disk  = try(tolist(data.talos_machine_disks.worker[node].disks[*].dev_path)[0], null)
          image = "factory.talos.dev/installer/${talos_image_factory_schematic.worker.id}:${var.talos_version}"
        }
      }
    })
  }
}
