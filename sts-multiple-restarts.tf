locals {
  sts_multiple_restarts_filter = coalesce(
    var.sts_multiple_restarts_filter_override,
    "${var.filter_str}${var.filter_str_concatenation}kube_stateful_set:*"
  )
}

module "sts_multiple_restarts" {
  source = "git@github.com:worldcoin/terraform-datadog-generic-monitor?ref=v1.1.0"

  name  = "Statefulset Multiple Restarts"
  query = "max(${var.sts_multiple_restarts_evaluation_period}):clamp_min(max:kubernetes.containers.restarts{${local.sts_multiple_restarts_filter}} by {kube_stateful_set} - hour_before(max:kubernetes.containers.restarts{${local.sts_multiple_restarts_filter}} by {kube_stateful_set}), 0) > ${var.sts_multiple_restarts_critical}"

  # alert specific configuration
  require_full_window = true
  alert_message       = "Kubernetes Statefulset {{kube_stateful_set.name}} has more than {{threshold}} ({{value}}) restarts within one hour"
  recovery_message    = "Kubernetes Statefulset {{kube_stateful_set.name}} is now at {{value}} restarts of the last hour"

  # monitor level vars
  enabled              = var.sts_multiple_restarts_enabled
  alerting_enabled     = var.sts_multiple_restarts_alerting_enabled
  warning_threshold    = var.sts_multiple_restarts_warning
  critical_threshold   = var.sts_multiple_restarts_critical
  priority             = min(var.sts_multiple_restarts_priority + var.priority_offset, 5)
  docs                 = var.sts_multiple_restarts_docs
  note                 = var.sts_multiple_restarts_note
  notification_channel = try(coalesce(var.sts_multiple_restarts_notification_channel_override, var.notification_channel), "")

  # module level vars
  env                  = var.env
  service              = var.service
  service_display_name = var.service_display_name
  additional_tags      = var.additional_tags
  restricted_roles     = var.restricted_roles
  name_prefix          = var.name_prefix
  name_suffix          = var.name_suffix
}
