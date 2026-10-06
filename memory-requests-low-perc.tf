locals {
  memory_requests_low_perc_filter = coalesce(
    var.memory_requests_low_perc_filter_override,
    var.filter_str
  )

  # Completed jobs retain request metrics but no longer reserve node memory.
  memory_requests_low_perc_active_filter = var.filter_str_concatenation == "," ? "${local.memory_requests_low_perc_filter},!pod_phase:succeeded,!pod_phase:failed,node:*" : "(${local.memory_requests_low_perc_filter}) AND NOT pod_phase:succeeded AND NOT pod_phase:failed AND node:*"
}

module "memory_requests_low_perc" {
  source = "git@github.com:worldcoin/terraform-datadog-generic-monitor?ref=v1.3.0"

  # Retired pod-phase series must not be interpolated into current reservations.
  name             = "Node Regular Container Memory Requests as a Percentage of Allocatable High"
  query            = "min(${var.memory_requests_low_perc_evaluation_period}):( sum:kubernetes_state.container.memory_requested{${local.memory_requests_low_perc_active_filter}} by {kube_cluster_name,node}.fill(null) / max:kubernetes_state.node.memory_allocatable{${local.memory_requests_low_perc_filter}} by {kube_cluster_name,node} ) * 100 > ${var.memory_requests_low_perc_critical}"
  alert_message    = "Regular-container memory requests on node {{node.name}} exceed the configured percentage of allocatable memory"
  recovery_message = "Regular-container memory requests on node {{node.name}} have recovered below the configured percentage of allocatable memory"

  # monitor level vars
  enabled            = var.memory_requests_low_perc_enabled
  alerting_enabled   = var.memory_requests_low_perc_alerting_enabled
  critical_threshold = var.memory_requests_low_perc_critical
  warning_threshold  = var.memory_requests_low_perc_warning
  priority           = min(var.memory_requests_low_perc_priority + var.priority_offset, 5)
  docs               = var.memory_requests_low_perc_docs
  note               = var.memory_requests_low_perc_note

  # module level vars
  env                  = var.env
  service              = var.service
  service_display_name = var.service_display_name
  notification_channel = var.notification_channel
  additional_tags      = var.additional_tags
  name_prefix          = var.name_prefix
  name_suffix          = var.name_suffix
}
