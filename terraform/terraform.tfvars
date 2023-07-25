# WAS stack configuration

###############################################################################
# Required inputs
###############################################################################
account_id  = "090511222473"
aws_region  = "us-east-1"
aws_profile = "lawrence"
domain      = "lawrencemcdaniel.com"


###############################################################################
# Optional inputs
###############################################################################
shared_resource_name = "fswl"
aws_auth_users = [
  {
    userarn  = "arn:aws:iam::320713933456:user/mcdaniel"
    username = "mcdaniel"
    groups   = ["system:masters"]
  }
]

kms_key_owners = [
  "arn:aws:iam::320713933456:user/mcdaniel"
]
tags = {
  Terraform   = "true"
  Platform    = "Full stack with Lawrence"
  Environment = "fswl"
}

# AWS EKS Kubernetes
# -------------------------------------

# valid choices: 'SPOT', 'ON_DEMAND'
capacity_type = "SPOT"
instance_types = ["t3.xlarge", "t3a.xlarge", "t2.xlarge"]

min_worker_node     = 2
desired_worker_node = 2
max_worker_node     = 10

