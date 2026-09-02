locals {
  datadog_agent_filter = coalesce(
    var.datadog_agent_filter_override,
    var.filter_str
  )

  # Scope to the Datadog Agent's own DaemonSet (Helm release name is "datadog")
  # so this checks agent health, not just node presence.
  datadog_agent_daemonset_filter = "${local.datadog_agent_filter}${var.filter_str_concatenation}kube_daemon_set:datadog"
}

module "datadog_agent" {
  source = "git@github.com:worldcoin/terraform-datadog-generic-monitor?ref=v1.3.0"

  name              = "Datadog agent not running"
  query             = "min(${var.datadog_agent_evaluation_period}):max:kubernetes_state.daemonset.desired{${local.datadog_agent_daemonset_filter}} by {kube_cluster_name} - min:kubernetes_state.daemonset.ready{${local.datadog_agent_daemonset_filter}} by {kube_cluster_name} > 0"
  alert_message     = "Datadog Agent DaemonSet is incomplete in Cluster: {{kube_cluster_name.name}}. Missing pod count: {{value}}"
  recovery_message  = "Datadog Agent DaemonSet is complete again in Cluster: {{kube_cluster_name.name}}"
  no_data_timeframe = var.datadog_agent_no_data_timeframe
  notify_no_data    = var.datadog_agent_notify_no_data
  no_data_message   = "No data for Datadog Agent DaemonSet health in Cluster: {{kube_cluster_name.name}}"

  # monitor level vars
  enabled            = var.state_metrics_monitoring && var.datadog_agent_enabled
  alerting_enabled   = var.datadog_agent_alerting_enabled
  critical_threshold = 0
  # no warning threshold for this monitor
  priority = min(var.datadog_agent_priority + var.priority_offset, 5)
  docs     = var.datadog_agent_docs
  note     = var.datadog_agent_note

  # module level vars
  env                  = var.env
  service              = var.service
  service_display_name = var.service_display_name
  notification_channel = var.notification_channel
  additional_tags      = var.additional_tags
  name_prefix          = var.name_prefix
  name_suffix          = var.name_suffix
}
