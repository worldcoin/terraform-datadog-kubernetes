variable "env" {
  type = string
}

variable "service" {
  type    = string
  default = "Kubernetes"
}

variable "service_display_name" {
  description = "Readable version of service name of what you're monitoring."
  type        = string
  default     = null
}

variable "notification_channel" {
  type        = string
  description = "The @user or @pagerduty parameters that indicate to Datadog where to send the alerts"
}

variable "additional_tags" {
  type    = list(string)
  default = []
}

variable "filter_str" {
  type = string
}

variable "restricted_roles" {
  description = "A list of unique role identifiers to define which roles are allowed to edit the monitor."
  type        = list(string)
  default     = []
}

variable "state_metrics_monitoring" {
  type    = bool
  default = true
}

variable "name_prefix" {
  type    = string
  default = ""
}

variable "name_suffix" {
  type    = string
  default = ""
}

variable "filter_str_concatenation" {
  description = "If you use an IN expression you need to switch from , to AND"
  default     = ","
}

variable "priority_offset" {
  description = "For non production workloads we can +1 on the priorities"
  default     = 0
}
