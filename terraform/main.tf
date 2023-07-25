#------------------------------------------------------------------------------
# written by: Lawrence McDaniel
#             https://lawrencemcdaniel.com/
#
# date:       jul-2023
#
# usage: create a Wolfram Application Service stack, consisting of the following:
#       - VPC
#       - EKS cluster + managed node group + EBS CSI Driver, CNI, kube-proxy, CoreDNS
#       - Kubernetes cert-manager
#       - Kubernetes Nginx ingress controller
#       - Kubernetes Prometheus
#       - Kubernetes vertical pod autoscaler
#------------------------------------------------------------------------------

module "eks" {
  source = "../modules/eks"

  root_domain          = var.domain
  domain               = "${var.shared_resource_name}.${var.domain}"
  shared_resource_name = var.shared_resource_name

  account_id = var.account_id
  aws_region = var.aws_region

  cidr                = var.cidr
  private_subnets     = var.private_subnets
  public_subnets      = var.public_subnets
  namespace           = var.shared_resource_name
  cluster_version     = var.cluster_version
  disk_size           = var.disk_size
  instance_types      = var.instance_types
  desired_worker_node = var.desired_worker_node
  min_worker_node     = var.min_worker_node
  max_worker_node     = var.max_worker_node
  capacity_type       = var.capacity_type
  aws_auth_users      = var.aws_auth_users
  kms_key_owners      = var.kms_key_owners

}

module "vpa" {
  source = "../modules/kubernetes_vpa"

  depends_on = [module.eks]
}

module "cert_manager" {
  source = "../modules/kubernetes_cert_manager"

  domain     = "${var.shared_resource_name}.${var.domain}"
  namespace  = var.shared_resource_name
  aws_region = var.aws_region

  depends_on = [module.eks]

}

module "metricsserver" {
  source = "../modules/kubernetes_metricsserver"

  depends_on = [module.eks]
}


module "prometheus" {
  source = "../modules/kubernetes_prometheus"

  domain         = "${var.shared_resource_name}.${var.domain}"
  cluster_issuer = "${var.shared_resource_name}.${var.domain}"

  depends_on = [module.eks, module.metricsserver]
}

module "ingress_controller" {
  source = "../modules/kubernetes_ingress_controller"

  domain = "${var.shared_resource_name}.${var.domain}"

  depends_on = [module.eks]
}
