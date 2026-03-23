variable "cluster_name" {
  description = "Name of the Talos cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "Kubernetes API endpoint for the cluster"
  type        = string
  default     = null
}

variable "kubernetes_version" {
  description = "Kubernetes version to deploy"
  type        = string
  default     = "1.35.0"
}

variable "talos_version" {
  description = "Talos OS version to deploy"
  type        = string
  default     = "v1.12.5"
}

variable "disk_selector" {
  description = "Disk selector expression for Talos installation"
  type        = string
  default     = "disk.size > 6u * GB"
}

variable "global_extensions" {
  description = "System extensions to install on all nodes"
  type        = list(string)
  default     = []
}

variable "controlplane_nodes" {
  description = "List of control plane node IP addresses"
  type        = list(string)
  default     = []
}

variable "controlplane_extensions" {
  description = "System extensions to install on control plane nodes"
  type        = list(string)
  default     = []
}

variable "controlplane_config_patches" {
  description = "List of config patch file paths for control plane nodes"
  type        = list(string)
  default     = []
}

variable "reset_controlplane_on_destroy" {
  description = "Whether to reset control plane nodes on destroy"
  type        = bool
  default     = false
}

variable "worker_nodes" {
  description = "List of worker node IP addresses"
  type        = list(string)
  default     = []
}

variable "worker_extensions" {
  description = "System extensions to install on worker nodes"
  type        = list(string)
  default     = []
}

variable "worker_config_patches" {
  description = "List of config patch file paths for worker nodes"
  type        = list(string)
  default     = []
}

variable "reset_worker_on_destroy" {
  description = "Whether to reset worker nodes on destroy"
  type        = bool
  default     = false
}
