
resource "kubectl_manifest" "vpa-metricsserver" {
  yaml_body = file("${path.module}/yml/verticalpodautoscalers/vpa-metricsserver.yaml")
  depends_on = [
    helm_release.metrics_server
  ]
}
