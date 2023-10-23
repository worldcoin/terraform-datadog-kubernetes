locals {
  daemonset_incomplete_filter = coalesce(
    var.daemonset_incomplete_filter_override,
    var.filter_str
  )
}

module "daemonset_incomplete" {
  source = "git@github.com:worldcoin/terraform-datadog-generic-monitor?ref=v1.0.0"

  name             = "Daemonset Incomplete"
  query            = "min(${var.daemonset_incomplete_evaluation_period}):max:kubernetes_state.daemonset.scheduled{${local.daemonset_incomplete_filter}} by {kube_daemon_set,kube_cluster_name} - min:kubernetes_state.daemonset.ready{${local.daemonset_incomplete_filter}} by {kube_daemon_set,kube_cluster_name} > 0"
  alert_message    = "Kubernetes Daemonset {{kube_daemon_set}} is incomplete. Missing pod count:{{value}}"
  recovery_message = "Kubernetes Daemonset {{kube_daemon_set}} has recovered"

  # monitor level vars
  enabled            = var.state_metrics_monitoring && var.daemonset_incomplete_enabled
  alerting_enabled   = var.daemonset_incomplete_alerting_enabled
  critical_threshold = var.daemonset_incomplete_critical
  # no warning threshold for this monitor
  priority = min(var.daemonset_incomplete_priority + var.priority_offset, 5)
  docs     = var.daemonset_incomplete_docs
  note     = var.daemonset_incomplete_note

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
