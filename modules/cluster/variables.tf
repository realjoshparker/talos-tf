variable "cluster_name" {
  type        = string
  description = "Name of the Talos cluster"
}

variable "cluster_endpoint" {
  type        = string
  description = "Endpoint for the Talos cluster API (e.g. https://192.168.1.100:6443)"
  default     = null
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version to deploy (e.g. 1.32.0)"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+\\.[0-9]+$", var.kubernetes_version))
    error_message = "kubernetes_version must be a semver string like 1.32.0"
  }
}

variable "talos_version" {
  type        = string
  description = "Talos version to use (e.g. v1.9.0)"

  validation {
    condition     = can(regex("^v[0-9]+\\.[0-9]+\\.[0-9]+$", var.talos_version))
    error_message = "talos_version must be a semver string prefixed with v, e.g. v1.9.0"
  }
}

variable "controlplane_config_patches" {
  type        = list(string)
  description = "List of Talos machine configuration patch strings (YAML content). Use file() in the calling module to load from disk."
  default     = []
}

variable "worker_config_patches" {
  type        = list(string)
  description = "List of Talos machine configuration patch strings (YAML content). Use file() in the calling module to load from disk."
  default     = []
}

variable "controlplane_nodes" {
  type        = list(string)
  description = "List of control plane node IPs or hostnames. Must be 1, 3, or 5 nodes for etcd quorum."
  default     = []

  validation {
    condition     = length(var.controlplane_nodes) > 0
    error_message = "At least one control plane node must be provided."
  }

  validation {
    condition     = contains([1, 3, 5], length(var.controlplane_nodes))
    error_message = "Control plane node count must be 1, 3, or 5 for etcd quorum."
  }
}

variable "worker_nodes" {
  type        = list(string)
  description = "List of worker node IPs or hostnames"
  default     = []
}

variable "disk_selector" {
  type        = string
  description = "Talos disk selector expression used to identify the install disk on each node"
  default     = "disk.size > 6u * GB"
}

variable "global_extensions" {
  type        = list(string)
  description = "List of Talos extensions to include in the custom installer image for all machine types (e.g. ['nfs-utils', '^iscsi-tools'])"
  default     = []
}

variable "controlplane_extensions" {
  type        = list(string)
  description = "List of Talos extensions to include in the custom installer image (e.g. ['nfs-utils', '^iscsi-tools'])"
  default     = []
}

variable "worker_extensions" {
  type        = list(string)
  description = "List of Talos extensions to include in the custom installer image (e.g. ['nfs-utils', '^iscsi-tools'])"
  default     = []
}

variable "reset_controlplane_on_destroy" {
  type        = bool
  description = "Whether to reset control plane nodes when destroying the cluster. This will wipe all data on the control plane nodes."
  default     = false
}

variable "reset_worker_on_destroy" {
  type        = bool
  description = "Whether to reset worker nodes when destroying the cluster. This will wipe all data on the worker nodes."
  default     = false
}