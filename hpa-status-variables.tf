variable "hpa_status_enabled" {
  type    = bool
  default = true
}

variable "hpa_status_evaluation_period" {
  type    = string
  default = "last_15m"
}

variable "hpa_status_note" {
  type    = string
  default = ""
}

variable "hpa_status_docs" {
  type    = string
  default = "The Horizontal Pod Autoscaler automatically scales the number of Pods in a replication controller, deployment, replica set or stateful set based on observed CPU utilization\nWhen the HPA is unavailable, the situation could arise that not enough resources are provisioned to handle the incoming load\nhttps://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/"
}

variable "hpa_status_filter_override" {
  type    = string
  default = ""
}

variable "hpa_status_alerting_enabled" {
  type    = bool
  default = true
}

variable "hpa_status_no_data_timeframe" {
  type    = number
  default = null
}

variable "hpa_status_notify_no_data" {
  type    = bool
  default = false
}

variable "hpa_status_ok_threshold" {
  type    = number
  default = null
}

variable "hpa_status_priority" {
  description = "Number from 1 (high) to 5 (low)."

  type    = number
  default = 3
}
