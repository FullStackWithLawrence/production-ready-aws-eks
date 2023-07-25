data "aws_route53_zone" "domain" {
  name = var.domain
}

data "template_file" "cluster-issuer" {
  template = file("${path.module}/manifests/cluster-issuer.yml.tpl")
  vars = {
    domain         = var.domain
    namespace      = var.namespace
    aws_region     = var.aws_region
    hosted_zone_id = data.aws_route53_zone.domain.id
  }
}

resource "kubectl_manifest" "cluster-issuer" {
  yaml_body = data.template_file.cluster-issuer.rendered

  depends_on = [
    module.cert_manager_irsa,
    helm_release.cert-manager,
    aws_iam_policy.cert_manager_policy,
  ]
}
