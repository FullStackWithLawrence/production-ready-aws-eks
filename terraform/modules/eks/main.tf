#------------------------------------------------------------------------------
# written by: Lawrence McDaniel
#             https://lawrencemcdaniel.com/
#
# date: jul-2023
#
# usage: create an EKS cluster
#------------------------------------------------------------------------------
data "aws_availability_zones" "available" {
}

data "aws_route53_zone" "root_domain" {
  name = var.root_domain
}

resource "aws_route53_zone" "subdomain" {
  name = var.domain
}
resource "aws_route53_record" "subdomain-ns" {
  zone_id = data.aws_route53_zone.root_domain.zone_id
  name    = aws_route53_zone.subdomain.name
  type    = "NS"
  ttl     = "600"
  records = aws_route53_zone.subdomain.name_servers
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name                 = var.shared_resource_name
  cidr                 = var.cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_ipv6          = false
  enable_dns_support   = true

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.shared_resource_name}" = "owned"
    "karpenter.sh/discovery"                            = var.shared_resource_name
    "kubernetes.io/role/internal-elb"                   = "1"
  }
  public_subnet_tags = {
    "kubernetes.io/cluster/${var.shared_resource_name}" = "shared"
    "kubernetes.io/role/elb"                            = "1"
  }

  tags = var.tags
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.15"

  cluster_name                    = var.shared_resource_name
  cluster_version                 = var.cluster_version
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnets
  create_cloudwatch_log_group     = false
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  enable_irsa                     = true
  tags                            = var.tags

  create_kms_key            = true
  manage_aws_auth_configmap = true
  aws_auth_users            = var.aws_auth_users
  kms_key_owners            = var.kms_key_owners


  cluster_addons = {
    vpc-cni    = {}
    coredns    = {}
    kube-proxy = {}
    aws-ebs-csi-driver = {
      service_account_role_arn = aws_iam_role.AmazonEKS_EBS_CSI_DriverRoleWAS.arn
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "WAS: Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      cidr_blocks = ["192.168.0.0/16"]
    }
    egress_all = {
      description      = "WAS: Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  eks_managed_node_groups = {
    eks = {
      name              = "${var.shared_resource_name}-worker-nodes"
      capacity_type     = var.capacity_type
      enable_monitoring = false
      desired_size      = var.desired_worker_node
      max_size          = var.max_worker_node
      min_size          = var.min_worker_node
      disk_size         = var.disk_size
      instance_types    = var.instance_types

      labels = {
        node-group = var.namespace
      }

    }
  }

  iam_role_additional_policies = {
    WorkersAdditionalPolicies = aws_iam_policy.worker_policy.arn
    AmazonEBSCSIDriverPolicy  = data.aws_iam_policy.AmazonEBSCSIDriverPolicy.arn
  }

}

#------------------------------------------------------------------------------
#                             SUPPORTING RESOURCES
#------------------------------------------------------------------------------

resource "aws_iam_policy" "worker_policy" {
  name        = "node-workers-policy-${var.shared_resource_name}"
  description = "Node Workers IAM policies"

  policy = file("${path.module}/node-workers-policy.json")
}

resource "kubernetes_namespace" "was" {
  metadata {
    name = var.namespace
  }

  depends_on = [module.eks]
}
