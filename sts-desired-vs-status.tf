locals {
  sts_desired_vs_status_filter = coalesce(
    var.sts_desired_vs_status_filter_override,
    var.filter_str
  )
}

module "sts_desired_vs_status" {
  source = "git@github.com:worldcoin/terraform-datadog-generic-monitor?ref=v1.1.0"

  name             = "Desired pods vs current pods (Statefulsets)"
  query            = "avg(${var.sts_desired_vs_status_evaluation_period}):max:kubernetes_state.statefulset.replicas_desired{${local.sts_desired_vs_status_filter}} by {kube_cluster_name} - max:kubernetes_state.statefulset.replicas_ready{${local.sts_desired_vs_status_filter}} by {kube_cluster_name} > ${var.sts_desired_vs_status_critical}"
  alert_message    = "Kubernetes is having trouble getting all the pods to start. (Based on replicas number in all the statefulset)"
  recovery_message = "All pods described in statefulset have started"
  notify_no_data   = true
  no_data_message  = "Kubernetes State data missing for {{kube_cluster_name.name}}"

  # monitor level vars
  enabled            = var.state_metrics_monitoring && var.sts_desired_vs_status_enabled
  alerting_enabled   = var.sts_desired_vs_status_alerting_enabled
  critical_threshold = var.sts_desired_vs_status_critical
  warning_threshold  = var.sts_desired_vs_status_warning
  priority           = min(var.sts_desired_vs_status_priority + var.priority_offset, 5)
  docs               = var.sts_desired_vs_status_docs
  note               = var.sts_desired_vs_status_note

  # module level vars
  env                  = var.env
  service              = var.service
  service_display_name = var.service_display_name
  notification_channel = var.notification_channel
  additional_tags      = var.additional_tags
  restricted_roles     = var.restricted_roles
  name_prefix          = var.name_prefix
  name_suffix          = var.name_suffix
}
