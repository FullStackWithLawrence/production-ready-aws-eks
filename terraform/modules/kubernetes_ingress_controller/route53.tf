#------------------------------------------------------------------------------
# written by: Miguel Afonso
#             https://www.linkedin.com/in/mmafonso/
#
# date: Aug-2021
#
# usage: create DNS records for EKS cluster load balancer
#------------------------------------------------------------------------------
data "aws_route53_zone" "domain" {
  name = var.domain
}
data "aws_elb_hosted_zone_id" "main" {}
data "kubernetes_service" "ingress_nginx_controller" {
  metadata {
    name      = "common-ingress-nginx-controller"
    namespace = var.namespace
  }

  depends_on = [helm_release.ingress_nginx_controller]
}

resource "aws_route53_record" "naked" {
  zone_id = data.aws_route53_zone.domain.id
  name    = var.domain
  type    = "A"

  alias {
    name                   = data.kubernetes_service.ingress_nginx_controller.status[0].load_balancer[0].ingress[0].hostname
    zone_id                = data.aws_elb_hosted_zone_id.main.id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wildcard" {
  zone_id = data.aws_route53_zone.domain.id
  name    = "*.${var.domain}"
  type    = "A"

  alias {
    name                   = data.kubernetes_service.ingress_nginx_controller.status[0].load_balancer[0].ingress[0].hostname
    zone_id                = data.aws_elb_hosted_zone_id.main.id
    evaluate_target_health = true
  }
}
