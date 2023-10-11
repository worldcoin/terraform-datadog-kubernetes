
![Datadog](https://imgix.datadoghq.com/img/about/presskit/logo-v/dd_vertical_purple.png)

[//]: # (This file is generated. Do not edit, module description can be added by editing / creating module_description.md)

# Terraform module for Datadog Kubernetes

This module mainly check on Kubernetes resource level and cluster health.
System level monitoring can best be implemented with the [system module](https://github.com/kabisa/terraform-datadog-system).
Docker/Container level monitoring can best be implemented with the [docker module](https://github.com/kabisa/terraform-datadog-docker-container).

# Recent changes:

- switch from kubernetes_state to kubernetes_state_core as a default https://docs.datadoghq.com/integrations/kubernetes_state_core/?tab=helm
- upgrade provider to ~> 3.12

This module is part of a larger suite of modules that provide alerts in Datadog.
Other modules can be found on the [Terraform Registry](https://registry.terraform.io/search/modules?namespace=kabisa&provider=datadog)

We have two base modules we use to standardise development of our Monitor Modules:
- [generic monitor](https://github.com/kabisa/terraform-datadog-generic-monitor) Used in 90% of our alerts
- [service check monitor](https://github.com/kabisa/terraform-datadog-service-check-monitor)

Modules are generated with this tool: https://github.com/kabisa/datadog-terraform-generator

# Example Usage

```terraform
module "kubernetes" {
  source = "kabisa/kubernetes/datadog"

  notification_channel = "mail@example.com"
  service              = "Kubernetes"
  env                  = "prd"
  filter_str           = "kube_cluster_name:production"
}

```


[Module Variables](#module-variables)

Monitors:

| Monitor name    | Default enabled | Priority | Query                  |
|-----------------|------|----|------------------------|
| [CPU Limits Low Perc State](#cpu-limits-low-perc-state) | False | 3  | `max(last_5m):( sum:kubernetes_state.container.cpu_limit{tag:xxx} by {host,kube_cluster_name} / sum:kubernetes_state.node.cpu_capacity{tag:xxx} by {host,kube_cluster_name}) * 100 > 100` |
| [CPU Limits Low Perc](#cpu-limits-low-perc) | True | 3  | `max(last_5m):(sum:kubernetes.cpu.limits{tag:xxx} by {host,kube_cluster_name} / max:system.cpu.num_cores{tag:xxx} by {host,kube_cluster_name}) * 100 > 100` |
| [CPU Limits Low](#cpu-limits-low) | False | 3  | `min(last_5m):max:system.cpu.num_cores{tag:xxx} by {kube_cluster_name,host} - sum:kubernetes.cpu.limits{tag:xxx} by {kube_cluster_name,host} < ${-30}` |
| [CPU On Dns Pods High](#cpu-on-dns-pods-high) | True | 2  | `avg(last_30m):avg:docker.cpu.usage{tag:xxx} by {kube_cluster_name,host,container_name} > 85` |
| [CPU Requests Low Perc State](#cpu-requests-low-perc-state) | False | 3  | `max(last_5m):( sum:kubernetes_state.container.cpu_requested{tag:xxx} by {host,kube_cluster_name} / sum:kubernetes_state.node.cpu_capacity{tag:xxx} by {host,kube_cluster_name} ) * 100 > 95` |
| [CPU Requests Low Perc](#cpu-requests-low-perc) | True | 3  | `max(last_5m):100 * sum:kubernetes.cpu.requests{tag:xxx} by {kube_cluster_name,host} / max:system.cpu.num_cores{tag:xxx} by {kube_cluster_name,host} > 95` |
| [CPU Requests Low](#cpu-requests-low) | False | 3  | `max(last_5m):max:system.cpu.num_cores{tag:xxx} by {kube_cluster_name,host} - sum:kubernetes.cpu.requests{tag:xxx} by {kube_cluster_name,host} < 0.5` |
| [Daemonset Incomplete](#daemonset-incomplete) | True | 2  | `min(last_15m):max:kubernetes_state.daemonset.scheduled{tag:xxx} by {kube_daemon_set,kube_cluster_name} - min:kubernetes_state.daemonset.ready{tag:xxx} by {kube_daemon_set,kube_cluster_name} > 0` |
| [Daemonset Multiple Restarts](#daemonset-multiple-restarts) | True | 3  | `max(last_15m):clamp_min(max:kubernetes.containers.restarts{tag:xxx} by {kube_daemon_set} - hour_before(max:kubernetes.containers.restarts{tag:xxx} by {kube_daemon_set}), 0) > 5.0` |
| [Datadog Agent](#datadog-agent) | True | 2  | `avg(last_5m):avg:datadog.agent.running{tag:xxx} by {host,kube_cluster_name} < 1` |
| [Deploy Desired Vs Status](#deploy-desired-vs-status) | True | 3  | `avg(last_15m):max:kubernetes_state.deployment.replicas_desired{tag:xxx} by {kube_cluster_name} - max:kubernetes_state.deployment.replicas_available{tag:xxx} by {kube_cluster_name} > 10` |
| [Deployment Multiple Restarts](#deployment-multiple-restarts) | True | 3  | `max(last_15m):clamp_min(max:kubernetes.containers.restarts{tag:xxx} by {kube_deployment} - hour_before(max:kubernetes.containers.restarts{tag:xxx} by {kube_deployment}), 0) > 5.0` |
| [Hpa Status](#hpa-status) | True | 3  | `avg(last_15m):avg:kubernetes_state.hpa.condition{tag:xxx} by {hpa,kube_namespace,status,condition} < 1` |
| [Memory Limits Low Perc State](#memory-limits-low-perc-state) | False | 3  | `max(last_5m):( sum:kubernetes_state.container.memory_limit{tag:xxx} by {host,kube_cluster_name} / sum:kubernetes_state.node.memory_allocatable{tag:xxx} by {host,kube_cluster_name}) * 100 > 100` |
| [Memory Limits Low Perc](#memory-limits-low-perc) | True | 3  | `max(last_5m):( max:kubernetes.memory.limits{tag:xxx}  by {host,kube_cluster_name}/ max:system.mem.total{tag:xxx} by {host,kube_cluster_name}) * 100 > 100` |
| [Memory Limits Low](#memory-limits-low) | False | 3  | `avg(last_5m):max:system.mem.total{tag:xxx} by {host,kube_cluster_name} - max:kubernetes.memory.limits{tag:xxx} by {host,kube_cluster_name} < 3000000000` |
| [Memory Requests Low Perc State](#memory-requests-low-perc-state) | False | 3  | `max(last_5m):( max:kubernetes_state.container.memory_requested{tag:xxx} / max:kubernetes_state.node.memory_allocatable{tag:xxx} ) * 100 > 95` |
| [Memory Requests Low Perc](#memory-requests-low-perc) | True | 3  | `max(${var.cpu_requests_low_perc_evaluation_period}):( max:kubernetes.memory.requests{${local.cpu_requests_low_perc_filter}} / max:system.mem.total{${local.cpu_requests_low_perc_filter}} ) * 100 > ${var.cpu_requests_low_perc_critical}` |
| [Memory Requests Low](#memory-requests-low) | False | 3  | `avg(last_5m):max:system.mem.total{tag:xxx} by {host,kube_cluster_name} - max:kubernetes.memory.requests{tag:xxx} by {host,kube_cluster_name} < 3000000000` |
| [Network Unavailable](#network-unavailable) | True | 3  | `avg(last_5m):max:kubernetes_state.node.by_condition{tag:xxx AND condition:networkunavailable AND (status:true OR status:unknown)} by {kube_cluster_name,host} > ` |
| [Node Diskpressure](#node-diskpressure) | True | 3  | `avg(last_5m):max:kubernetes_state.node.by_condition{tag:xxx AND condition:diskpressure AND (status:true OR status:unknown)} by {kube_cluster_name,host} > ` |
| [Node Memory Used Percent](#node-memory-used-percent) | True | 2  | `avg(last_5m):( 100 * max:kubernetes.memory.usage{tag:xxx} by {host,kube_cluster_name} ) / max:system.mem.total{tag:xxx} by {host,kube_cluster_name} > 90` |
| [Node Memorypressure](#node-memorypressure) | True | 3  | `avg(last_5m):max:kubernetes_state.node.by_condition{tag:xxx AND condition:memorypressure AND (status:true OR status:unknown)} by {kube_cluster_name,host} > ` |
| [Node Ready](#node-ready) | True | 2  | `avg(last_5m):count_nonzero(sum:kubernetes_state.node.by_condition{tag:xxx AND (NOT condition:ready) AND (status:true OR status:unknown)} by {kube_cluster_name,host}) > 1` |
| [Node Status](#node-status) | True | 2  | `avg(last_5m):avg:kubernetes_state.node.status{tag:xxx} by {kube_cluster_name,node} < 1` |
| [Persistent Volumes](#persistent-volumes) | True | 3  | `avg(last_5m):max:kubernetes_state.persistentvolume.by_phase{tag:xxx AND phase:failed} > 1` |
| [Pid Pressure](#pid-pressure) | True | 3  | `avg(last_5m):max:kubernetes_state.node.by_condition{tag:xxx AND condition:pidpressure AND (status:true OR status:unknown)} by {kube_cluster_name,host} > ` |
| [Pod Count Per Node High](#pod-count-per-node-high) | True | 2  | `min(last_10m):sum:kubernetes.pods.running{tag:xxx} by {host} > 100.0` |
| [Pod Ready](#pod-ready) | True | 3  | `min(last_30m):sum:kubernetes_state.pod.count{tag:xxx} by {kube_cluster_name,kube_namespace} - sum:kubernetes_state.pod.ready{tag:xxx} by {kube_cluster_name,kube_namespace} > 0` |
| [Pod Restarts](#pod-restarts) | False | 2  | `change(avg(last_10m),last_10m):exclude_null(avg:kubernetes.containers.restarts{tag:xxx} by {pod_name}) > 5` |
| [Pods Failed](#pods-failed) | True | 3  | `min(last_10m):default_zero(max:kubernetes_state.pod.status_phase{phase:failed${var.filter_str_concatenation}tag:xxx} by {kube_namespace}) > ` |
| [Pods Pending](#pods-pending) | True | 3  | `min(last_10m):default_zero(max:kubernetes_state.pod.status_phase{phase:pending${var.filter_str_concatenation}tag:xxx} by {kube_namespace}) > ` |
| [Replicaset Incomplete](#replicaset-incomplete) | True | 3  | `min(last_15m):max:kubernetes_state.replicaset.replicas_desired{tag:xxx} by {kube_replica_set,kube_cluster_name} - min:kubernetes_state.replicaset.replicas_ready{tag:xxx} by {kube_replica_set,kube_cluster_name} > ` |
| [Replicaset Unavailable](#replicaset-unavailable) | True | 2  | `max(last_5m):( ${local.rs_pods_ready} ) / ${local.rs_pods_desired} / ( ${local.rs_pods_desired} - 1 ) <= 0` |

# Getting started developing
[pre-commit](http://pre-commit.com/) was used to do Terraform linting and validating.

Steps:
   - Install [pre-commit](http://pre-commit.com/). E.g. `brew install pre-commit`.
   - Run `pre-commit install` in this repo. (Every time you clone a repo with pre-commit enabled you will need to run the pre-commit install command)
   - That’s it! Now every time you commit a code change (`.tf` file), the hooks in the `hooks:` config `.pre-commit-config.yaml` will execute.

## CPU Limits Low Perc State

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Query:
```terraform
max(last_5m):( sum:kubernetes_state.container.cpu_limit{tag:xxx} by {host,kube_cluster_name} / sum:kubernetes_state.node.cpu_capacity{tag:xxx} by {host,kube_cluster_name}) * 100 > 100
```

| variable                                    | default                                  | required | description                                                                                          |
|---------------------------------------------|------------------------------------------|----------|------------------------------------------------------------------------------------------------------|
| cpu_limits_low_perc_state_enabled           | False                                    | No       | CPU state limits are only available when the state metrics api is deployed https://github.com/kubernetes/kube-state-metrics |
| cpu_limits_low_perc_state_warning           | 95                                       | No       |                                                                                                      |
| cpu_limits_low_perc_state_critical          | 100                                      | No       |                                                                                                      |
| cpu_limits_low_perc_state_evaluation_period | last_5m                                  | No       |                                                                                                      |
| cpu_limits_low_perc_state_note              | ""                                       | No       |                                                                                                      |
| cpu_limits_low_perc_state_docs              | If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | No       |                                                                                                      |
| cpu_limits_low_perc_state_filter_override   | ""                                       | No       |                                                                                                      |
| cpu_limits_low_perc_state_alerting_enabled  | True                                     | No       |                                                                                                      |
| cpu_limits_low_perc_state_no_data_timeframe | None                                     | No       |                                                                                                      |
| cpu_limits_low_perc_state_notify_no_data    | False                                    | No       |                                                                                                      |
| cpu_limits_low_perc_state_ok_threshold      | None                                     | No       |                                                                                                      |
| cpu_limits_low_perc_state_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                                                     |


## CPU Limits Low Perc

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Query:
```terraform
max(last_5m):(sum:kubernetes.cpu.limits{tag:xxx} by {host,kube_cluster_name} / max:system.cpu.num_cores{tag:xxx} by {host,kube_cluster_name}) * 100 > 100
```

| variable                              | default                                  | required | description                      |
|---------------------------------------|------------------------------------------|----------|----------------------------------|
| cpu_limits_low_perc_enabled           | True                                     | No       |                                  |
| cpu_limits_low_perc_warning           | 95                                       | No       |                                  |
| cpu_limits_low_perc_critical          | 100                                      | No       |                                  |
| cpu_limits_low_perc_evaluation_period | last_5m                                  | No       |                                  |
| cpu_limits_low_perc_note              | ""                                       | No       |                                  |
| cpu_limits_low_perc_docs              | If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | No       |                                  |
| cpu_limits_low_perc_filter_override   | ""                                       | No       |                                  |
| cpu_limits_low_perc_alerting_enabled  | True                                     | No       |                                  |
| cpu_limits_low_perc_no_data_timeframe | None                                     | No       |                                  |
| cpu_limits_low_perc_notify_no_data    | False                                    | No       |                                  |
| cpu_limits_low_perc_ok_threshold      | None                                     | No       |                                  |
| cpu_limits_low_perc_priority          | 3                                        | No       | Number from 1 (high) to 5 (low). |


## CPU Limits Low

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Query:
```terraform
min(last_5m):max:system.cpu.num_cores{tag:xxx} by {kube_cluster_name,host} - sum:kubernetes.cpu.limits{tag:xxx} by {kube_cluster_name,host} < ${-30}
```

| variable                         | default                                  | required | description                                                                                          |
|----------------------------------|------------------------------------------|----------|------------------------------------------------------------------------------------------------------|
| cpu_limits_low_enabled           | False                                    | No       | This monitor is based on absolute values and thus less useful. Prefer setting cpu_limits_low_perc_enabled to true. |
| cpu_limits_low_warning           | 0                                        | No       |                                                                                                      |
| cpu_limits_low_critical          | ${-30}                                   | No       |                                                                                                      |
| cpu_limits_low_evaluation_period | last_5m                                  | No       |                                                                                                      |
| cpu_limits_low_note              | ""                                       | No       |                                                                                                      |
| cpu_limits_low_docs              | If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | No       |                                                                                                      |
| cpu_limits_low_filter_override   | ""                                       | No       |                                                                                                      |
| cpu_limits_low_alerting_enabled  | True                                     | No       |                                                                                                      |
| cpu_limits_low_no_data_timeframe | None                                     | No       |                                                                                                      |
| cpu_limits_low_notify_no_data    | False                                    | No       |                                                                                                      |
| cpu_limits_low_ok_threshold      | None                                     | No       |                                                                                                      |
| cpu_limits_low_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                                                     |


## CPU On Dns Pods High

Query:
```terraform
avg(last_30m):avg:docker.cpu.usage{tag:xxx} by {kube_cluster_name,host,container_name} > 85
```

| variable                               | default                                  | required | description                                                                                          |
|----------------------------------------|------------------------------------------|----------|------------------------------------------------------------------------------------------------------|
| cpu_on_dns_pods_high_enabled           | True                                     | No       |                                                                                                      |
| cpu_on_dns_pods_high_warning           | 70                                       | No       |                                                                                                      |
| cpu_on_dns_pods_high_critical          | 85                                       | No       |                                                                                                      |
| cpu_on_dns_pods_high_evaluation_period | last_30m                                 | No       |                                                                                                      |
| cpu_on_dns_pods_high_note              | ""                                       | No       |                                                                                                      |
| cpu_on_dns_pods_high_docs              | ""                                       | No       |                                                                                                      |
| cpu_on_dns_pods_high_filter_override   | ""                                       | No       |                                                                                                      |
| dns_filter_tags                        | ['kube_service:kube-dns', 'short_image:coredns', 'short_image:ucp-coredns', 'short_image:ucp-kube-dns'] | No       | Getting all the DNS containers by default is hard to do.
What we try is to make a list of datadog tags / filters that should help us find those
We then build a filter in the following way: ($originalfilterstring) AND (item1 OR item2 OR item3...)
If that doesn't work for your use-cause you can override the filter list or use cpu_on_dns_pods_high_filter_override |
| cpu_on_dns_pods_high_alerting_enabled  | True                                     | No       |                                                                                                      |
| cpu_on_dns_pods_high_no_data_timeframe | None                                     | No       |                                                                                                      |
| cpu_on_dns_pods_high_notify_no_data    | False                                    | No       |                                                                                                      |
| cpu_on_dns_pods_high_ok_threshold      | None                                     | No       |                                                                                                      |
| cpu_on_dns_pods_high_priority          | 2                                        | No       | Number from 1 (high) to 5 (low).                                                                     |


## CPU Requests Low Perc State

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Query:
```terraform
max(last_5m):( sum:kubernetes_state.container.cpu_requested{tag:xxx} by {host,kube_cluster_name} / sum:kubernetes_state.node.cpu_capacity{tag:xxx} by {host,kube_cluster_name} ) * 100 > 95
```

| variable                                      | default                                  | required | description                                                                                          |
|-----------------------------------------------|------------------------------------------|----------|------------------------------------------------------------------------------------------------------|
| cpu_requests_low_perc_state_enabled           | False                                    | No       | CPU state limits are only available when the state metrics api is deployed https://github.com/kubernetes/kube-state-metrics |
| cpu_requests_low_perc_state_warning           | 80                                       | No       |                                                                                                      |
| cpu_requests_low_perc_state_critical          | 95                                       | No       |                                                                                                      |
| cpu_requests_low_perc_state_evaluation_period | last_5m                                  | No       |                                                                                                      |
| cpu_requests_low_perc_state_note              | ""                                       | No       |                                                                                                      |
| cpu_requests_low_perc_state_docs              | If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | No       |                                                                                                      |
| cpu_requests_low_perc_state_filter_override   | ""                                       | No       |                                                                                                      |
| cpu_requests_low_perc_state_alerting_enabled  | True                                     | No       |                                                                                                      |
| cpu_requests_low_perc_state_no_data_timeframe | None                                     | No       |                                                                                                      |
| cpu_requests_low_perc_state_notify_no_data    | False                                    | No       |                                                                                                      |
| cpu_requests_low_perc_state_ok_threshold      | None                                     | No       |                                                                                                      |
| cpu_requests_low_perc_state_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                                                     |


## CPU Requests Low Perc

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Query:
```terraform
max(last_5m):100 * sum:kubernetes.cpu.requests{tag:xxx} by {kube_cluster_name,host} / max:system.cpu.num_cores{tag:xxx} by {kube_cluster_name,host} > 95
```

| variable                                | default                                  | required | description                      |
|-----------------------------------------|------------------------------------------|----------|----------------------------------|
| cpu_requests_low_perc_enabled           | True                                     | No       |                                  |
| cpu_requests_low_perc_warning           | 80                                       | No       |                                  |
| cpu_requests_low_perc_critical          | 95                                       | No       |                                  |
| cpu_requests_low_perc_evaluation_period | last_5m                                  | No       |                                  |
| cpu_requests_low_perc_note              | ""                                       | No       |                                  |
| cpu_requests_low_perc_docs              | If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | No       |                                  |
| cpu_requests_low_perc_filter_override   | ""                                       | No       |                                  |
| cpu_requests_low_perc_alerting_enabled  | True                                     | No       |                                  |
| cpu_requests_low_perc_no_data_timeframe | None                                     | No       |                                  |
| cpu_requests_low_perc_notify_no_data    | False                                    | No       |                                  |
| cpu_requests_low_perc_ok_threshold      | None                                     | No       |                                  |
| cpu_requests_low_perc_priority          | 3                                        | No       | Number from 1 (high) to 5 (low). |


## CPU Requests Low

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Query:
```terraform
max(last_5m):max:system.cpu.num_cores{tag:xxx} by {kube_cluster_name,host} - sum:kubernetes.cpu.requests{tag:xxx} by {kube_cluster_name,host} < 0.5
```

| variable                           | default                                  | required | description                                                                                          |
|------------------------------------|------------------------------------------|----------|------------------------------------------------------------------------------------------------------|
| cpu_requests_low_enabled           | False                                    | No       | This monitor is based on absolute values and thus less useful. Prefer setting cpu_requests_low_perc_enabled to true. |
| cpu_requests_low_warning           | 1                                        | No       |                                                                                                      |
| cpu_requests_low_critical          | 0.5                                      | No       |                                                                                                      |
| cpu_requests_low_evaluation_period | last_5m                                  | No       |                                                                                                      |
| cpu_requests_low_note              | ""                                       | No       |                                                                                                      |
| cpu_requests_low_docs              | If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | No       |                                                                                                      |
| cpu_requests_low_filter_override   | ""                                       | No       |                                                                                                      |
| cpu_requests_low_alerting_enabled  | True                                     | No       |                                                                                                      |
| cpu_requests_low_no_data_timeframe | None                                     | No       |                                                                                                      |
| cpu_requests_low_notify_no_data    | False                                    | No       |                                                                                                      |
| cpu_requests_low_ok_threshold      | None                                     | No       |                                                                                                      |
| cpu_requests_low_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                                                     |


## Daemonset Incomplete

In kubernetes a daemonset is responsible for running the same pod across all Nodes. An example for when this fails, is when the image cannot be pulled, the pod fails to initialize or no resources are available on the cluster\nThis alert is raised when (desired - running) > 0

Query:
```terraform
min(last_15m):max:kubernetes_state.daemonset.scheduled{tag:xxx} by {kube_daemon_set,kube_cluster_name} - min:kubernetes_state.daemonset.ready{tag:xxx} by {kube_daemon_set,kube_cluster_name} > 0
```

| variable                               | default                                  | required | description                                                              |
|----------------------------------------|------------------------------------------|----------|--------------------------------------------------------------------------|
| daemonset_incomplete_enabled           | True                                     | No       |                                                                          |
| daemonset_incomplete_critical          | 0                                        | No       | alert is raised when (desired - running) > daemonset_incomplete_critical |
| daemonset_incomplete_evaluation_period | last_15m                                 | No       |                                                                          |
| daemonset_incomplete_note              | ""                                       | No       |                                                                          |
| daemonset_incomplete_docs              | In kubernetes a daemonset is responsible for running the same pod across all Nodes. An example for when this fails, is when the image cannot be pulled, the pod fails to initialize or no resources are available on the cluster\nThis alert is raised when (desired - running) > 0 | No       |                                                                          |
| daemonset_incomplete_filter_override   | ""                                       | No       |                                                                          |
| daemonset_incomplete_alerting_enabled  | True                                     | No       |                                                                          |
| daemonset_incomplete_no_data_timeframe | None                                     | No       |                                                                          |
| daemonset_incomplete_notify_no_data    | False                                    | No       |                                                                          |
| daemonset_incomplete_ok_threshold      | None                                     | No       |                                                                          |
| daemonset_incomplete_priority          | 2                                        | No       | Number from 1 (high) to 5 (low).                                         |


## Daemonset Multiple Restarts

If a container restarts once, it can be considered 'normal behaviour' for K8s. A Daemonset restarting multiple times though is a problem

Query:
```terraform
max(last_15m):clamp_min(max:kubernetes.containers.restarts{tag:xxx} by {kube_daemon_set} - hour_before(max:kubernetes.containers.restarts{tag:xxx} by {kube_daemon_set}), 0) > 5.0
```

| variable                                                  | default                                  | required | description                      |
|-----------------------------------------------------------|------------------------------------------|----------|----------------------------------|
| daemonset_multiple_restarts_enabled                       | True                                     | No       |                                  |
| daemonset_multiple_restarts_warning                       | None                                     | No       |                                  |
| daemonset_multiple_restarts_critical                      | 5.0                                      | No       |                                  |
| daemonset_multiple_restarts_evaluation_period             | last_15m                                 | No       |                                  |
| daemonset_multiple_restarts_note                          | ""                                       | No       |                                  |
| daemonset_multiple_restarts_docs                          | If a container restarts once, it can be considered 'normal behaviour' for K8s. A Daemonset restarting multiple times though is a problem | No       |                                  |
| daemonset_multiple_restarts_filter_override               | ""                                       | No       |                                  |
| daemonset_multiple_restarts_alerting_enabled              | True                                     | No       |                                  |
| daemonset_multiple_restarts_no_data_timeframe             | None                                     | No       |                                  |
| daemonset_multiple_restarts_notify_no_data                | False                                    | No       |                                  |
| daemonset_multiple_restarts_ok_threshold                  | None                                     | No       |                                  |
| daemonset_multiple_restarts_name_prefix                   | ""                                       | No       |                                  |
| daemonset_multiple_restarts_name_suffix                   | ""                                       | No       |                                  |
| daemonset_multiple_restarts_priority                      | 3                                        | No       | Number from 1 (high) to 5 (low). |
| daemonset_multiple_restarts_notification_channel_override | ""                                       | No       |                                  |


## Datadog Agent

Query:
```terraform
avg(last_5m):avg:datadog.agent.running{tag:xxx} by {host,kube_cluster_name} < 1
```

| variable                        | default  | required | description                      |
|---------------------------------|----------|----------|----------------------------------|
| datadog_agent_enabled           | True     | No       |                                  |
| datadog_agent_evaluation_period | last_5m  | No       |                                  |
| datadog_agent_note              | ""       | No       |                                  |
| datadog_agent_docs              | ""       | No       |                                  |
| datadog_agent_filter_override   | ""       | No       |                                  |
| datadog_agent_alerting_enabled  | True     | No       |                                  |
| datadog_agent_no_data_timeframe | None     | No       |                                  |
| datadog_agent_notify_no_data    | False    | No       |                                  |
| datadog_agent_ok_threshold      | None     | No       |                                  |
| datadog_agent_priority          | 2        | No       | Number from 1 (high) to 5 (low). |


## Deploy Desired Vs Status

The amount of expected pods to run minus the actual number

Query:
```terraform
avg(last_15m):max:kubernetes_state.deployment.replicas_desired{tag:xxx} by {kube_cluster_name} - max:kubernetes_state.deployment.replicas_available{tag:xxx} by {kube_cluster_name} > 10
```

| variable                                   | default                                  | required | description                      |
|--------------------------------------------|------------------------------------------|----------|----------------------------------|
| deploy_desired_vs_status_enabled           | True                                     | No       |                                  |
| deploy_desired_vs_status_warning           | 1                                        | No       |                                  |
| deploy_desired_vs_status_critical          | 10                                       | No       |                                  |
| deploy_desired_vs_status_evaluation_period | last_15m                                 | No       |                                  |
| deploy_desired_vs_status_note              | ""                                       | No       |                                  |
| deploy_desired_vs_status_docs              | The amount of expected pods to run minus the actual number | No       |                                  |
| deploy_desired_vs_status_filter_override   | ""                                       | No       |                                  |
| deploy_desired_vs_status_alerting_enabled  | True                                     | No       |                                  |
| deploy_desired_vs_status_no_data_timeframe | None                                     | No       |                                  |
| deploy_desired_vs_status_notify_no_data    | False                                    | No       |                                  |
| deploy_desired_vs_status_ok_threshold      | None                                     | No       |                                  |
| deploy_desired_vs_status_priority          | 3                                        | No       | Number from 1 (high) to 5 (low). |


## Deployment Multiple Restarts

If a container restarts once, it can be considered 'normal behaviour' for K8s. A Deployment restarting multiple times though is a problem

Query:
```terraform
max(last_15m):clamp_min(max:kubernetes.containers.restarts{tag:xxx} by {kube_deployment} - hour_before(max:kubernetes.containers.restarts{tag:xxx} by {kube_deployment}), 0) > 5.0
```

| variable                                                   | default                                  | required | description                      |
|------------------------------------------------------------|------------------------------------------|----------|----------------------------------|
| deployment_multiple_restarts_enabled                       | True                                     | No       |                                  |
| deployment_multiple_restarts_warning                       | None                                     | No       |                                  |
| deployment_multiple_restarts_critical                      | 5.0                                      | No       |                                  |
| deployment_multiple_restarts_evaluation_period             | last_15m                                 | No       |                                  |
| deployment_multiple_restarts_note                          | ""                                       | No       |                                  |
| deployment_multiple_restarts_docs                          | If a container restarts once, it can be considered 'normal behaviour' for K8s. A Deployment restarting multiple times though is a problem | No       |                                  |
| deployment_multiple_restarts_filter_override               | ""                                       | No       |                                  |
| deployment_multiple_restarts_alerting_enabled              | True                                     | No       |                                  |
| deployment_multiple_restarts_no_data_timeframe             | None                                     | No       |                                  |
| deployment_multiple_restarts_notify_no_data                | False                                    | No       |                                  |
| deployment_multiple_restarts_ok_threshold                  | None                                     | No       |                                  |
| deployment_multiple_restarts_name_prefix                   | ""                                       | No       |                                  |
| deployment_multiple_restarts_name_suffix                   | ""                                       | No       |                                  |
| deployment_multiple_restarts_priority                      | 3                                        | No       | Number from 1 (high) to 5 (low). |
| deployment_multiple_restarts_notification_channel_override | ""                                       | No       |                                  |


## Hpa Status

The Horizontal Pod Autoscaler automatically scales the number of Pods in a replication controller, deployment, replica set or stateful set based on observed CPU utilization\nWhen the HPA is unavailable, the situation could arise that not enough resources are provisioned to handle the incoming load\nhttps://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/

Query:
```terraform
avg(last_15m):avg:kubernetes_state.hpa.condition{tag:xxx} by {hpa,kube_namespace,status,condition} < 1
```

| variable                     | default                                  | required | description                      |
|------------------------------|------------------------------------------|----------|----------------------------------|
| hpa_status_enabled           | True                                     | No       |                                  |
| hpa_status_evaluation_period | last_15m                                 | No       |                                  |
| hpa_status_note              | ""                                       | No       |                                  |
| hpa_status_docs              | The Horizontal Pod Autoscaler automatically scales the number of Pods in a replication controller, deployment, replica set or stateful set based on observed CPU utilization\nWhen the HPA is unavailable, the situation could arise that not enough resources are provisioned to handle the incoming load\nhttps://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/ | No       |                                  |
| hpa_status_filter_override   | ""                                       | No       |                                  |
| hpa_status_alerting_enabled  | True                                     | No       |                                  |
| hpa_status_no_data_timeframe | None                                     | No       |                                  |
| hpa_status_notify_no_data    | False                                    | No       |                                  |
| hpa_status_ok_threshold      | None                                     | No       |                                  |
| hpa_status_priority          | 3                                        | No       | Number from 1 (high) to 5 (low). |


## Memory Limits Low Perc State

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Query:
```terraform
max(last_5m):( sum:kubernetes_state.container.memory_limit{tag:xxx} by {host,kube_cluster_name} / sum:kubernetes_state.node.memory_allocatable{tag:xxx} by {host,kube_cluster_name}) * 100 > 100
```

| variable                                       | default                                  | required | description                                                                                          |
|------------------------------------------------|------------------------------------------|----------|------------------------------------------------------------------------------------------------------|
| memory_limits_low_perc_state_enabled           | False                                    | No       | Memory state limits are only available when the state metrics api is deployed https://github.com/kubernetes/kube-state-metrics |
| memory_limits_low_perc_state_warning           | 95                                       | No       |                                                                                                      |
| memory_limits_low_perc_state_critical          | 100                                      | No       |                                                                                                      |
| memory_limits_low_perc_state_evaluation_period | last_5m                                  | No       |                                                                                                      |
| memory_limits_low_perc_state_note              | ""                                       | No       |                                                                                                      |
| memory_limits_low_perc_state_docs              | If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | No       |                                                                                                      |
| memory_limits_low_perc_state_filter_override   | ""                                       | No       |                                                                                                      |
| memory_limits_low_perc_state_alerting_enabled  | True                                     | No       |                                                                                                      |
| memory_limits_low_perc_state_no_data_timeframe | None                                     | No       |                                                                                                      |
| memory_limits_low_perc_state_notify_no_data    | False                                    | No       |                                                                                                      |
| memory_limits_low_perc_state_ok_threshold      | None                                     | No       |                                                                                                      |
| memory_limits_low_perc_state_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                                                     |


## Memory Limits Low Perc

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Query:
```terraform
max(last_5m):( max:kubernetes.memory.limits{tag:xxx}  by {host,kube_cluster_name}/ max:system.mem.total{tag:xxx} by {host,kube_cluster_name}) * 100 > 100
```

| variable                                 | default                                  | required | description                      |
|------------------------------------------|------------------------------------------|----------|----------------------------------|
| memory_limits_low_perc_enabled           | True                                     | No       |                                  |
| memory_limits_low_perc_warning           | 95                                       | No       |                                  |
| memory_limits_low_perc_critical          | 100                                      | No       |                                  |
| memory_limits_low_perc_evaluation_period | last_5m                                  | No       |                                  |
| memory_limits_low_perc_note              | ""                                       | No       |                                  |
| memory_limits_low_perc_docs              | If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | No       |                                  |
| memory_limits_low_perc_filter_override   | ""                                       | No       |                                  |
| memory_limits_low_perc_alerting_enabled  | True                                     | No       |                                  |
| memory_limits_low_perc_no_data_timeframe | None                                     | No       |                                  |
| memory_limits_low_perc_notify_no_data    | False                                    | No       |                                  |
| memory_limits_low_perc_ok_threshold      | None                                     | No       |                                  |
| memory_limits_low_perc_priority          | 3                                        | No       | Number from 1 (high) to 5 (low). |


## Memory Limits Low

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Query:
```terraform
avg(last_5m):max:system.mem.total{tag:xxx} by {host,kube_cluster_name} - max:kubernetes.memory.limits{tag:xxx} by {host,kube_cluster_name} < 3000000000
```

| variable                            | default                                  | required | description                                                                                          |
|-------------------------------------|------------------------------------------|----------|------------------------------------------------------------------------------------------------------|
| memory_limits_low_enabled           | False                                    | No       | This monitor is based on absolute values and thus less useful. Prefer setting memory_limits_low_perc_enabled to true. |
| memory_limits_low_warning           | 4000000000                               | No       |                                                                                                      |
| memory_limits_low_critical          | 3000000000                               | No       |                                                                                                      |
| memory_limits_low_evaluation_period | last_5m                                  | No       |                                                                                                      |
| memory_limits_low_note              | ""                                       | No       |                                                                                                      |
| memory_limits_low_docs              | If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | No       |                                                                                                      |
| memory_limits_low_filter_override   | ""                                       | No       |                                                                                                      |
| memory_limits_low_alerting_enabled  | True                                     | No       |                                                                                                      |
| memory_limits_low_no_data_timeframe | None                                     | No       |                                                                                                      |
| memory_limits_low_notify_no_data    | False                                    | No       |                                                                                                      |
| memory_limits_low_ok_threshold      | None                                     | No       |                                                                                                      |
| memory_limits_low_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                                                     |


## Memory Requests Low Perc State

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Query:
```terraform
max(last_5m):( max:kubernetes_state.container.memory_requested{tag:xxx} / max:kubernetes_state.node.memory_allocatable{tag:xxx} ) * 100 > 95
```

| variable                                         | default                                  | required | description                                                                                          |
|--------------------------------------------------|------------------------------------------|----------|------------------------------------------------------------------------------------------------------|
| memory_requests_low_perc_state_enabled           | False                                    | No       | Memory state limits are only available when the state metrics api is deployed https://github.com/kubernetes/kube-state-metrics |
| memory_requests_low_perc_state_warning           | 85                                       | No       |                                                                                                      |
| memory_requests_low_perc_state_critical          | 95                                       | No       |                                                                                                      |
| memory_requests_low_perc_state_evaluation_period | last_5m                                  | No       |                                                                                                      |
| memory_requests_low_perc_state_note              | ""                                       | No       |                                                                                                      |
| memory_requests_low_perc_state_docs              | If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | No       |                                                                                                      |
| memory_requests_low_perc_state_filter_override   | ""                                       | No       |                                                                                                      |
| memory_requests_low_perc_state_alerting_enabled  | True                                     | No       |                                                                                                      |
| memory_requests_low_perc_state_no_data_timeframe | None                                     | No       |                                                                                                      |
| memory_requests_low_perc_state_notify_no_data    | False                                    | No       |                                                                                                      |
| memory_requests_low_perc_state_ok_threshold      | None                                     | No       |                                                                                                      |
| memory_requests_low_perc_state_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                                                     |


## Memory Requests Low Perc

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Query:
```terraform
max(${var.cpu_requests_low_perc_evaluation_period}):( max:kubernetes.memory.requests{${local.cpu_requests_low_perc_filter}} / max:system.mem.total{${local.cpu_requests_low_perc_filter}} ) * 100 > ${var.cpu_requests_low_perc_critical}
```

| variable                                   | default                                  | required | description                      |
|--------------------------------------------|------------------------------------------|----------|----------------------------------|
| memory_requests_low_perc_enabled           | True                                     | No       |                                  |
| memory_requests_low_perc_warning           | 85                                       | No       |                                  |
| memory_requests_low_perc_critical          | 95                                       | No       |                                  |
| memory_requests_low_perc_evaluation_period | last_5m                                  | No       |                                  |
| memory_requests_low_perc_note              | ""                                       | No       |                                  |
| memory_requests_low_perc_docs              | If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | No       |                                  |
| memory_requests_low_perc_filter_override   | ""                                       | No       |                                  |
| memory_requests_low_perc_alerting_enabled  | True                                     | No       |                                  |
| memory_requests_low_perc_no_data_timeframe | None                                     | No       |                                  |
| memory_requests_low_perc_notify_no_data    | False                                    | No       |                                  |
| memory_requests_low_perc_ok_threshold      | None                                     | No       |                                  |
| memory_requests_low_perc_priority          | 3                                        | No       | Number from 1 (high) to 5 (low). |


## Memory Requests Low

If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/

Query:
```terraform
avg(last_5m):max:system.mem.total{tag:xxx} by {host,kube_cluster_name} - max:kubernetes.memory.requests{tag:xxx} by {host,kube_cluster_name} < 3000000000
```

| variable                              | default                                  | required | description                                                                                          |
|---------------------------------------|------------------------------------------|----------|------------------------------------------------------------------------------------------------------|
| memory_requests_low_enabled           | False                                    | No       | This monitor is based on absolute values and thus less useful. Prefer setting memory_requests_low_perc_enabled to true. |
| memory_requests_low_warning           | 4000000000                               | No       |                                                                                                      |
| memory_requests_low_critical          | 3000000000                               | No       |                                                                                                      |
| memory_requests_low_evaluation_period | last_5m                                  | No       |                                                                                                      |
| memory_requests_low_note              | ""                                       | No       |                                                                                                      |
| memory_requests_low_docs              | If the node where a Pod is running has enough of a resource available, it's possible (and allowed) for a container to use more of a resource than its request for that resource specifies. However, a container is not allowed to use more than its resource limit. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/ | No       |                                                                                                      |
| memory_requests_low_filter_override   | ""                                       | No       |                                                                                                      |
| memory_requests_low_alerting_enabled  | True                                     | No       |                                                                                                      |
| memory_requests_low_no_data_timeframe | None                                     | No       |                                                                                                      |
| memory_requests_low_notify_no_data    | False                                    | No       |                                                                                                      |
| memory_requests_low_ok_threshold      | None                                     | No       |                                                                                                      |
| memory_requests_low_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                                                     |


## Network Unavailable

All your nodes need network  connections, and this status indicates that there’s something wrong with a node’s network connection. Either it wasn’t set up properly (due to route exhaustion or a misconfiguration), or there’s a physical problem with the network connection to your hardware.

Query:
```terraform
avg(last_5m):max:kubernetes_state.node.by_condition{tag:xxx AND condition:networkunavailable AND (status:true OR status:unknown)} by {kube_cluster_name,host} > 
```

| variable                              | default                                  | required | description                                                             |
|---------------------------------------|------------------------------------------|----------|-------------------------------------------------------------------------|
| network_unavailable_enabled           | True                                     | No       |                                                                         |
| network_unavailable_critical          | 0                                        | No       | alert is raised when (desired - running) > network_unavailable_critical |
| network_unavailable_evaluation_period | last_5m                                  | No       |                                                                         |
| network_unavailable_note              | ""                                       | No       |                                                                         |
| network_unavailable_docs              | All your nodes need network  connections, and this status indicates that there’s something wrong with a node’s network connection. Either it wasn’t set up properly (due to route exhaustion or a misconfiguration), or there’s a physical problem with the network connection to your hardware. | No       |                                                                         |
| network_unavailable_filter_override   | ""                                       | No       |                                                                         |
| network_unavailable_alerting_enabled  | True                                     | No       |                                                                         |
| network_unavailable_no_data_timeframe | None                                     | No       |                                                                         |
| network_unavailable_notify_no_data    | False                                    | No       |                                                                         |
| network_unavailable_ok_threshold      | None                                     | No       |                                                                         |
| network_unavailable_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                        |


## Node Diskpressure

Disk pressure is a condition indicating that a node is using too much disk space or is using disk space too fast, according to the thresholds you have set in your Kubernetes configuration. This is important to monitor because it might mean that you need to add more disk space, if your application legitimately needs more space. Or it might mean that an application is misbehaving and filling up the disk prematurely in an unanticipated manner. Either way, it’s a condition which needs your attention.

Query:
```terraform
avg(last_5m):max:kubernetes_state.node.by_condition{tag:xxx AND condition:diskpressure AND (status:true OR status:unknown)} by {kube_cluster_name,host} > 
```

| variable                            | default                                  | required | description                                                           |
|-------------------------------------|------------------------------------------|----------|-----------------------------------------------------------------------|
| node_diskpressure_enabled           | True                                     | No       |                                                                       |
| node_diskpressure_critical          | 0                                        | No       | alert is raised when (desired - running) > node_diskpressure_critical |
| node_diskpressure_evaluation_period | last_5m                                  | No       |                                                                       |
| node_diskpressure_note              | ""                                       | No       |                                                                       |
| node_diskpressure_docs              | Disk pressure is a condition indicating that a node is using too much disk space or is using disk space too fast, according to the thresholds you have set in your Kubernetes configuration. This is important to monitor because it might mean that you need to add more disk space, if your application legitimately needs more space. Or it might mean that an application is misbehaving and filling up the disk prematurely in an unanticipated manner. Either way, it’s a condition which needs your attention. | No       |                                                                       |
| node_diskpressure_filter_override   | ""                                       | No       |                                                                       |
| node_diskpressure_alerting_enabled  | True                                     | No       |                                                                       |
| node_diskpressure_no_data_timeframe | None                                     | No       |                                                                       |
| node_diskpressure_notify_no_data    | False                                    | No       |                                                                       |
| node_diskpressure_ok_threshold      | None                                     | No       |                                                                       |
| node_diskpressure_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                      |


## Node Memory Used Percent

Query:
```terraform
avg(last_5m):( 100 * max:kubernetes.memory.usage{tag:xxx} by {host,kube_cluster_name} ) / max:system.mem.total{tag:xxx} by {host,kube_cluster_name} > 90
```

| variable                                   | default  | required | description                      |
|--------------------------------------------|----------|----------|----------------------------------|
| node_memory_used_percent_enabled           | True     | No       |                                  |
| node_memory_used_percent_warning           | 80       | No       |                                  |
| node_memory_used_percent_critical          | 90       | No       |                                  |
| node_memory_used_percent_evaluation_period | last_5m  | No       |                                  |
| node_memory_used_percent_note              | ""       | No       |                                  |
| node_memory_used_percent_docs              | ""       | No       |                                  |
| node_memory_used_percent_filter_override   | ""       | No       |                                  |
| node_memory_used_percent_alerting_enabled  | True     | No       |                                  |
| node_memory_used_percent_no_data_timeframe | None     | No       |                                  |
| node_memory_used_percent_notify_no_data    | False    | No       |                                  |
| node_memory_used_percent_ok_threshold      | None     | No       |                                  |
| node_memory_used_percent_priority          | 2        | No       | Number from 1 (high) to 5 (low). |


## Node Memorypressure

Memory pressure is a resourcing condition indicating that your node is running out of memory. Similar to CPU resourcing, you don’t want to run out of memory. You especially need to watch for this condition because it could mean there’s a memory leak in one of your applications.

Query:
```terraform
avg(last_5m):max:kubernetes_state.node.by_condition{tag:xxx AND condition:memorypressure AND (status:true OR status:unknown)} by {kube_cluster_name,host} > 
```

| variable                              | default                                  | required | description                                                             |
|---------------------------------------|------------------------------------------|----------|-------------------------------------------------------------------------|
| node_memorypressure_enabled           | True                                     | No       |                                                                         |
| node_memorypressure_critical          | 0                                        | No       | alert is raised when (desired - running) > node_memorypressure_critical |
| node_memorypressure_evaluation_period | last_5m                                  | No       |                                                                         |
| node_memorypressure_note              | ""                                       | No       |                                                                         |
| node_memorypressure_docs              | Memory pressure is a resourcing condition indicating that your node is running out of memory. Similar to CPU resourcing, you don’t want to run out of memory. You especially need to watch for this condition because it could mean there’s a memory leak in one of your applications. | No       |                                                                         |
| node_memorypressure_filter_override   | ""                                       | No       |                                                                         |
| node_memorypressure_alerting_enabled  | True                                     | No       |                                                                         |
| node_memorypressure_no_data_timeframe | None                                     | No       |                                                                         |
| node_memorypressure_notify_no_data    | False                                    | No       |                                                                         |
| node_memorypressure_ok_threshold      | None                                     | No       |                                                                         |
| node_memorypressure_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                        |


## Node Ready

Checks to see if the node is in ready status or not

Query:
```terraform
avg(last_5m):count_nonzero(sum:kubernetes_state.node.by_condition{tag:xxx AND (NOT condition:ready) AND (status:true OR status:unknown)} by {kube_cluster_name,host}) > 1
```

| variable                     | default                                  | required | description                      |
|------------------------------|------------------------------------------|----------|----------------------------------|
| node_ready_enabled           | True                                     | No       |                                  |
| node_ready_critical          | 1                                        | No       |                                  |
| node_ready_evaluation_period | last_5m                                  | No       |                                  |
| node_ready_note              | ""                                       | No       |                                  |
| node_ready_docs              | Checks to see if the node is in ready status or not | No       |                                  |
| node_ready_filter_override   | ""                                       | No       |                                  |
| node_ready_alerting_enabled  | True                                     | No       |                                  |
| node_ready_no_data_timeframe | None                                     | No       |                                  |
| node_ready_notify_no_data    | False                                    | No       |                                  |
| node_ready_ok_threshold      | None                                     | No       |                                  |
| node_ready_priority          | 2                                        | No       | Number from 1 (high) to 5 (low). |


## Node Status

This cluster state metric provides a high-level overview of a node’s health and whether the scheduler can place pods on that node. It runs checks on the following node conditions\nhttps://kubernetes.io/docs/concepts/architecture/nodes/#condition

Query:
```terraform
avg(last_5m):avg:kubernetes_state.node.status{tag:xxx} by {kube_cluster_name,node} < 1
```

| variable                      | default                                  | required | description                      |
|-------------------------------|------------------------------------------|----------|----------------------------------|
| node_status_enabled           | True                                     | No       |                                  |
| node_status_evaluation_period | last_5m                                  | No       |                                  |
| node_status_note              | ""                                       | No       |                                  |
| node_status_docs              | This cluster state metric provides a high-level overview of a node’s health and whether the scheduler can place pods on that node. It runs checks on the following node conditions\nhttps://kubernetes.io/docs/concepts/architecture/nodes/#condition | No       |                                  |
| node_status_filter_override   | ""                                       | No       |                                  |
| node_status_alerting_enabled  | True                                     | No       |                                  |
| node_status_no_data_timeframe | None                                     | No       |                                  |
| node_status_notify_no_data    | False                                    | No       |                                  |
| node_status_ok_threshold      | None                                     | No       |                                  |
| node_status_priority          | 2                                        | No       | Number from 1 (high) to 5 (low). |


## Persistent Volumes

Query:
```terraform
avg(last_5m):max:kubernetes_state.persistentvolume.by_phase{tag:xxx AND phase:failed} > 1
```

| variable                             | default  | required | description                      |
|--------------------------------------|----------|----------|----------------------------------|
| persistent_volumes_enabled           | True     | No       |                                  |
| persistent_volumes_warning           | 0        | No       |                                  |
| persistent_volumes_critical          | 1        | No       |                                  |
| persistent_volumes_evaluation_period | last_5m  | No       |                                  |
| persistent_volumes_note              | ""       | No       |                                  |
| persistent_volumes_docs              | ""       | No       |                                  |
| persistent_volumes_filter_override   | ""       | No       |                                  |
| persistent_volumes_alerting_enabled  | True     | No       |                                  |
| persistent_volumes_no_data_timeframe | None     | No       |                                  |
| persistent_volumes_notify_no_data    | False    | No       |                                  |
| persistent_volumes_ok_threshold      | None     | No       |                                  |
| persistent_volumes_priority          | 3        | No       | Number from 1 (high) to 5 (low). |


## Pid Pressure

PID pressure is a rare condition where a pod or container spawns too many processes and starves the node of available process IDs. Each node has a limited number of process IDs to distribute amongst running processes; and if it runs out of IDs, no other processes can be started. Kubernetes lets you set PID thresholds for pods to limit their ability to perform runaway process-spawning, and a PID pressure condition means that one or more pods are using up their allocated PIDs and need to be examined.

Query:
```terraform
avg(last_5m):max:kubernetes_state.node.by_condition{tag:xxx AND condition:pidpressure AND (status:true OR status:unknown)} by {kube_cluster_name,host} > 
```

| variable                       | default                                  | required | description                                                      |
|--------------------------------|------------------------------------------|----------|------------------------------------------------------------------|
| pid_pressure_enabled           | True                                     | No       |                                                                  |
| pid_pressure_critical          | 0                                        | No       | alert is raised when (desired - running) > pid_pressure_critical |
| pid_pressure_evaluation_period | last_5m                                  | No       |                                                                  |
| pid_pressure_note              | ""                                       | No       |                                                                  |
| pid_pressure_docs              | PID pressure is a rare condition where a pod or container spawns too many processes and starves the node of available process IDs. Each node has a limited number of process IDs to distribute amongst running processes; and if it runs out of IDs, no other processes can be started. Kubernetes lets you set PID thresholds for pods to limit their ability to perform runaway process-spawning, and a PID pressure condition means that one or more pods are using up their allocated PIDs and need to be examined. | No       |                                                                  |
| pid_pressure_filter_override   | ""                                       | No       |                                                                  |
| pid_pressure_alerting_enabled  | True                                     | No       |                                                                  |
| pid_pressure_no_data_timeframe | None                                     | No       |                                                                  |
| pid_pressure_notify_no_data    | False                                    | No       |                                                                  |
| pid_pressure_ok_threshold      | None                                     | No       |                                                                  |
| pid_pressure_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                 |


## Pod Count Per Node High

Query:
```terraform
min(last_10m):sum:kubernetes.pods.running{tag:xxx} by {host} > 100.0
```

| variable                                  | default  | required | description                      |
|-------------------------------------------|----------|----------|----------------------------------|
| pod_count_per_node_high_enabled           | True     | No       |                                  |
| pod_count_per_node_high_warning           | 90.0     | No       |                                  |
| pod_count_per_node_high_critical          | 100.0    | No       |                                  |
| pod_count_per_node_high_warning_recovery  | None     | No       |                                  |
| pod_count_per_node_high_critical_recovery | None     | No       |                                  |
| pod_count_per_node_high_evaluation_period | last_10m | No       |                                  |
| pod_count_per_node_high_note              | ""       | No       |                                  |
| pod_count_per_node_high_docs              | ""       | No       |                                  |
| pod_count_per_node_high_filter_override   | ""       | No       |                                  |
| pod_count_per_node_high_alerting_enabled  | True     | No       |                                  |
| pod_count_per_node_high_no_data_timeframe | None     | No       |                                  |
| pod_count_per_node_high_notify_no_data    | False    | No       |                                  |
| pod_count_per_node_high_ok_threshold      | None     | No       |                                  |
| pod_count_per_node_high_name_prefix       | ""       | No       |                                  |
| pod_count_per_node_high_name_suffix       | ""       | No       |                                  |
| pod_count_per_node_high_priority          | 2        | No       | Number from 1 (high) to 5 (low). |


## Pod Ready

A pod may be running but not available, meaning it is not ready and able to accept traffic. This is normal during certain circumstances, such as when a pod is newly launched or when a change is made and deployed to the specification of that pod. But if you see spikes in the number of unavailable pods, or pods that are consistently unavailable, it might indicate a problem with their configuration.\nhttps://www.datadoghq.com/blog/monitoring-kubernetes-performance-metrics/

Query:
```terraform
min(last_30m):sum:kubernetes_state.pod.count{tag:xxx} by {kube_cluster_name,kube_namespace} - sum:kubernetes_state.pod.ready{tag:xxx} by {kube_cluster_name,kube_namespace} > 0
```

| variable                    | default                                  | required | description                      |
|-----------------------------|------------------------------------------|----------|----------------------------------|
| pod_ready_enabled           | True                                     | No       |                                  |
| pod_ready_evaluation_period | last_30m                                 | No       |                                  |
| pod_ready_note              | ""                                       | No       |                                  |
| pod_ready_docs              | A pod may be running but not available, meaning it is not ready and able to accept traffic. This is normal during certain circumstances, such as when a pod is newly launched or when a change is made and deployed to the specification of that pod. But if you see spikes in the number of unavailable pods, or pods that are consistently unavailable, it might indicate a problem with their configuration.\nhttps://www.datadoghq.com/blog/monitoring-kubernetes-performance-metrics/ | No       |                                  |
| pod_ready_filter_override   | ""                                       | No       |                                  |
| pod_ready_alerting_enabled  | True                                     | No       |                                  |
| pod_ready_no_data_timeframe | None                                     | No       |                                  |
| pod_ready_notify_no_data    | False                                    | No       |                                  |
| pod_ready_ok_threshold      | None                                     | No       |                                  |
| pod_ready_priority          | 3                                        | No       | Number from 1 (high) to 5 (low). |


## Pod Restarts

Query:
```terraform
change(avg(last_10m),last_10m):exclude_null(avg:kubernetes.containers.restarts{tag:xxx} by {pod_name}) > 5
```

| variable                       | default  | required | description                                                                       |
|--------------------------------|----------|----------|-----------------------------------------------------------------------------------|
| pod_restarts_enabled           | False    | No       | Deprecated in favour of multiple restarts monitoring for Daemonset and Deployment |
| pod_restarts_warning           | 3        | No       |                                                                                   |
| pod_restarts_critical          | 5        | No       |                                                                                   |
| pod_restarts_evaluation_period | last_10m | No       |                                                                                   |
| pod_restarts_note              | ""       | No       |                                                                                   |
| pod_restarts_docs              | ""       | No       |                                                                                   |
| pod_restarts_filter_override   | ""       | No       |                                                                                   |
| pod_restarts_alerting_enabled  | True     | No       |                                                                                   |
| pod_restarts_no_data_timeframe | None     | No       |                                                                                   |
| pod_restarts_notify_no_data    | False    | No       |                                                                                   |
| pod_restarts_ok_threshold      | None     | No       |                                                                                   |
| pod_restarts_priority          | 2        | No       | Number from 1 (high) to 5 (low).                                                  |


## Pods Failed

https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/

Query:
```terraform
min(last_10m):default_zero(max:kubernetes_state.pod.status_phase{phase:failed${var.filter_str_concatenation}tag:xxx} by {kube_namespace}) > 
```

| variable                      | default                                  | required | description                      |
|-------------------------------|------------------------------------------|----------|----------------------------------|
| pods_failed_enabled           | True                                     | No       |                                  |
| pods_failed_warning           | None                                     | No       |                                  |
| pods_failed_critical          | 0.0                                      | No       |                                  |
| pods_failed_evaluation_period | last_10m                                 | No       |                                  |
| pods_failed_note              | ""                                       | No       |                                  |
| pods_failed_docs              | https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/ | No       |                                  |
| pods_failed_filter_override   | ""                                       | No       |                                  |
| pods_failed_alerting_enabled  | True                                     | No       |                                  |
| pods_failed_no_data_timeframe | None                                     | No       |                                  |
| pods_failed_notify_no_data    | False                                    | No       |                                  |
| pods_failed_ok_threshold      | None                                     | No       |                                  |
| pods_failed_name_prefix       | ""                                       | No       |                                  |
| pods_failed_name_suffix       | ""                                       | No       |                                  |
| pods_failed_priority          | 3                                        | No       | Number from 1 (high) to 5 (low). |


## Pods Pending

https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/

Query:
```terraform
min(last_10m):default_zero(max:kubernetes_state.pod.status_phase{phase:pending${var.filter_str_concatenation}tag:xxx} by {kube_namespace}) > 
```

| variable                       | default                                  | required | description                      |
|--------------------------------|------------------------------------------|----------|----------------------------------|
| pods_pending_enabled           | True                                     | No       |                                  |
| pods_pending_warning           | None                                     | No       |                                  |
| pods_pending_critical          | 0.0                                      | No       |                                  |
| pods_pending_evaluation_period | last_10m                                 | No       |                                  |
| pods_pending_note              | ""                                       | No       |                                  |
| pods_pending_docs              | https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/ | No       |                                  |
| pods_pending_filter_override   | ""                                       | No       |                                  |
| pods_pending_alerting_enabled  | True                                     | No       |                                  |
| pods_pending_no_data_timeframe | None                                     | No       |                                  |
| pods_pending_notify_no_data    | False                                    | No       |                                  |
| pods_pending_ok_threshold      | None                                     | No       |                                  |
| pods_pending_name_prefix       | ""                                       | No       |                                  |
| pods_pending_name_suffix       | ""                                       | No       |                                  |
| pods_pending_priority          | 3                                        | No       | Number from 1 (high) to 5 (low). |


## Replicaset Incomplete

In kubernetes a Replicaset is responsible for making sure a specific number of pods run. An example for a reason when that's not is the case, is when the image cannot be pulled, the pod fails to initialize or no resources are available on the cluster\nThis alert is raised when (desired - running) > 0

Query:
```terraform
min(last_15m):max:kubernetes_state.replicaset.replicas_desired{tag:xxx} by {kube_replica_set,kube_cluster_name} - min:kubernetes_state.replicaset.replicas_ready{tag:xxx} by {kube_replica_set,kube_cluster_name} > 
```

| variable                                | default                                  | required | description                                                               |
|-----------------------------------------|------------------------------------------|----------|---------------------------------------------------------------------------|
| replicaset_incomplete_enabled           | True                                     | No       |                                                                           |
| replicaset_incomplete_critical          | 0                                        | No       | alert is raised when (desired - running) > replicaset_incomplete_critical |
| replicaset_incomplete_evaluation_period | last_15m                                 | No       |                                                                           |
| replicaset_incomplete_note              | There's also a monitor defined for when the replicaset is completely unavailable | No       |                                                                           |
| replicaset_incomplete_docs              | In kubernetes a Replicaset is responsible for making sure a specific number of pods run. An example for a reason when that's not is the case, is when the image cannot be pulled, the pod fails to initialize or no resources are available on the cluster\nThis alert is raised when (desired - running) > 0 | No       |                                                                           |
| replicaset_incomplete_filter_override   | ""                                       | No       |                                                                           |
| replicaset_incomplete_alerting_enabled  | True                                     | No       |                                                                           |
| replicaset_incomplete_no_data_timeframe | None                                     | No       |                                                                           |
| replicaset_incomplete_notify_no_data    | False                                    | No       |                                                                           |
| replicaset_incomplete_ok_threshold      | None                                     | No       |                                                                           |
| replicaset_incomplete_priority          | 3                                        | No       | Number from 1 (high) to 5 (low).                                          |


## Replicaset Unavailable

In kubernetes a Replicaset is responsible for making sure a specific number of pods runs. An example for a reason when that's not is the case, is when the image cannot be pulled, the pod fails to initialize or no resources are available on the cluster\nThis alert is raised when running == 0 and desired > 1

Query:
```terraform
max(last_5m):( ${local.rs_pods_ready} ) / ${local.rs_pods_desired} / ( ${local.rs_pods_desired} - 1 ) <= 0
```

| variable                                 | default                                  | required | description                                   |
|------------------------------------------|------------------------------------------|----------|-----------------------------------------------|
| replicaset_unavailable_enabled           | True                                     | No       |                                               |
| replicaset_unavailable_critical          | 0                                        | No       | alert is raised when (desired - running) == 0 |
| replicaset_unavailable_evaluation_period | last_5m                                  | No       |                                               |
| replicaset_unavailable_note              | There's also a monitor defined for when the replicaset is only partially available | No       |                                               |
| replicaset_unavailable_docs              | In kubernetes a Replicaset is responsible for making sure a specific number of pods runs. An example for a reason when that's not is the case, is when the image cannot be pulled, the pod fails to initialize or no resources are available on the cluster\nThis alert is raised when running == 0 and desired > 1 | No       |                                               |
| replicaset_unavailable_filter_override   | ""                                       | No       |                                               |
| replicaset_unavailable_alerting_enabled  | True                                     | No       |                                               |
| replicaset_unavailable_no_data_timeframe | None                                     | No       |                                               |
| replicaset_unavailable_notify_no_data    | False                                    | No       |                                               |
| replicaset_unavailable_ok_threshold      | None                                     | No       |                                               |
| replicaset_unavailable_priority          | 2                                        | No       | Number from 1 (high) to 5 (low).              |


## Module Variables

| variable                 | default    | required | description                                                                          |
|--------------------------|------------|----------|--------------------------------------------------------------------------------------|
| env                      |            | Yes      |                                                                                      |
| service                  | Kubernetes | No       |                                                                                      |
| service_display_name     | None       | No       | Readable version of service name of what you're monitoring.                          |
| notification_channel     |            | Yes      | The @user or @pagerduty parameters that indicate to Datadog where to send the alerts |
| additional_tags          | []         | No       |                                                                                      |
| filter_str               |            | Yes      |                                                                                      |
| locked                   | True       | No       | Makes sure only the creator or admin can modify the monitor.                         |
| state_metrics_monitoring | True       | No       |                                                                                      |
| name_prefix              | ""         | No       |                                                                                      |
| name_suffix              | ""         | No       |                                                                                      |
| filter_str_concatenation | ,          | No       | If you use an IN expression you need to switch from , to AND                         |
| priority_offset          | 0          | No       | For non production workloads we can +1 on the priorities                             |


