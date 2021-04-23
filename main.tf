provider "helm" {
  kubernetes {
    config_context_cluster = "minikube"
    config_path            = "~/.kube/config"
  }
}
provider "kubernetes" {
  config_context_cluster = "minikube"
  config_path            = "~/.kube/config"
}

locals {
  argo_namespace       = "argo"
  monitoring_namespace = "monitoring"
}

resource "kubernetes_namespace" "argo-namespace" {
  metadata {
    name = local.argo_namespace
  }
}

resource "kubernetes_namespace" "monitoring-namespace" {
  metadata {
    name = local.monitoring_namespace
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = local.monitoring_namespace

  # Find ServiceMonitor in all namespaces
  # More: https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md#prometheusioscrape
  set {
    name  = "prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues"
    value = false
  }
  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = false
  }
  depends_on = [
    kubernetes_namespace.monitoring-namespace
  ]
}

resource "helm_release" "argo-workflow" {
  name       = "argo-workflow"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo"
  version    = "0.15.2"
  namespace  = local.argo_namespace
  set {
    name  = "controller.serviceMonitor.enabled"
    value = true
  }
  set {
    name  = "controller.metricsConfig.enabled"
    value = true
  }

  depends_on = [
    kubernetes_namespace.argo-namespace,
		helm_release.prometheus # Needs ServiceMonitor
  ]
}

