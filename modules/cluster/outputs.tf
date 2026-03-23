output "cluster_endpoint" {
  value       = local.cluster_endpoint
  description = "Cluster API endpoint hostname or IP (resolved from var.cluster_endpoint, falling back to the first control plane node)"
}

output "cluster_endpoint_https" {
  value       = local.cluster_endpoint_https
  description = "Cluster API endpoint as a full https URL (e.g. https://192.168.1.2:6443)"
}

output "kubeconfig" {
  value       = talos_cluster_kubeconfig.this.kubeconfig_raw
  description = "kubeconfig for the Talos cluster"
  sensitive   = true
}

output "talosconfig" {
  value       = data.talos_client_configuration.this.talos_config
  description = "talosconfig for interacting with cluster nodes via talosctl"
  sensitive   = true
}

output "machine_secrets" {
  value       = talos_machine_secrets.this.machine_secrets
  description = "Talos machine secrets — back these up; required to recover the cluster if state is lost"
  sensitive   = true
}