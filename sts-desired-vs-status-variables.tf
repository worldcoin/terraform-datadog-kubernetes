variable "sts_desired_vs_status_enabled" {
  type    = bool
  default = true
}

variable "sts_desired_vs_status_warning" {
  type    = number
  default = 1
  # warning at 1 difference
}

variable "sts_desired_vs_status_critical" {
  type    = number
  default = 10
  # critical at 10 difference
}

variable "sts_desired_vs_status_evaluation_period" {
  type    = string
  default = "last_15m"
}

variable "sts_desired_vs_status_note" {
  type    = string
  default = ""
}

variable "sts_desired_vs_status_docs" {
  type    = string
  default = "The amount of expected pods to run minus the actual number"
}

variable "sts_desired_vs_status_filter_override" {
  type    = string
  default = ""
}

variable "sts_desired_vs_status_alerting_enabled" {
  type    = bool
  default = true
}

variable "sts_desired_vs_status_no_data_timeframe" {
  type    = number
  default = null
}

variable "sts_desired_vs_status_notify_no_data" {
  type    = bool
  default = false
}

variable "sts_desired_vs_status_ok_threshold" {
  type    = number
  default = null
}

variable "sts_desired_vs_status_priority" {
  description = "Number from 1 (high) to 5 (low)."

  type    = number
  default = 3
}
