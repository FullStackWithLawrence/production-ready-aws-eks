
data "template_file" "ingress-grafana" {
  template = file("${path.module}/yml/ingress-grafana.yaml.tpl")
  vars = {
    domain         = var.domain
    cluster_issuer = var.cluster_issuer
  }
}

resource "kubectl_manifest" "ingress-grafana" {
  yaml_body = data.template_file.ingress-grafana.rendered

  depends_on = [
    helm_release.prometheus
  ]
}
