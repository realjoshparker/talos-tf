# talos-tf

OpenTofu module for provisioning [Talos Linux](https://www.talos.dev/) Kubernetes clusters. Handles machine secrets, node configuration, custom installer images via the Talos Image Factory, and cluster bootstrapping.

## Features

- Generates and manages Talos machine secrets
- Builds custom installer images with extensions via [Talos Image Factory](https://factory.talos.dev/)
- Applies machine configuration to control plane and worker nodes
- Bootstraps the cluster and retrieves kubeconfig/talosconfig
- Supports per-node-type config patches and extensions
- Enforces etcd quorum (1, 3, or 5 control plane nodes)

## Requirements

| Tool | Version |
|------|---------|
| OpenTofu | >= 1.11 |
| siderolabs/talos provider | ~> 0.10 |

Nodes must already be booted into Talos maintenance mode and reachable over the network before running `tofu apply`.

## Usage

```hcl
module "cluster" {
  source = "github.com/your-org/talos-tf//modules/cluster"

  cluster_name       = "my-cluster"
  cluster_endpoint   = "192.168.1.2"
  kubernetes_version = "1.32.0"
  talos_version      = "v1.9.0"

  controlplane_nodes = ["192.168.1.2", "192.168.1.3", "192.168.1.4"]
  worker_nodes       = ["192.168.1.5", "192.168.1.6"]

  global_extensions = ["nfs-utils"]

  controlplane_config_patches = [
    file("${path.module}/patches/global.yaml"),
  ]
}

output "kubeconfig" {
  value     = module.cluster.kubeconfig
  sensitive = true
}
```

### Retrieving credentials

```bash
# Write kubeconfig
tofu output -raw kubeconfig > ~/.kube/config

# Write talosconfig
tofu output -raw talosconfig > ~/.talos/config

# Back up machine secrets (store securely — required for cluster recovery)
tofu output -json machine_secrets > machine_secrets.json
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->

## Config patches

Patches are standard Talos machine config fragments in YAML format. Pass them as strings using `file()`:

```hcl
controlplane_config_patches = [
  file("${path.module}/patches/global.yaml"),
  file("${path.module}/patches/controlplane-extra.yaml"),
]
```

See the [Talos configuration reference](https://www.talos.dev/latest/reference/configuration/) for available fields.

## Examples

A full working example is in [examples/cluster/](examples/cluster/).

## Contributing

Commit messages follow [Conventional Commits](https://www.conventionalcommits.org/). Releases are automated via [release-please](https://github.com/googleapis/release-please) on merge to `main`.
