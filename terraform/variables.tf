#

###############################################################################
# General AWS Deployment Options
###############################################################################
variable "account_id" {
  description = "Your 12-digit AWS account number"
  default     = "01234567891"
  type        = string
}
variable "aws_region" {
  description = "A region code describing the location of the physical AWS data center in which all resources will be deployed."
  default     = "us-east-1"
  type        = string
}

variable "aws_profile" {
  description = "the AWS CLI creates a profile for you in your home folder ~/.aws/credentials. You can create other profiles if you wish."
  default     = "default"
  type        = string
}

variable "domain" {
  description = "A root domain managed as an AWS Route53 HostedZone in your AWS account: example.com"
  type        = string
}

variable "shared_resource_name" {
  description = "A short string value to identify the subdomain of your WAS installation as well as all resources that Terraform will create."
  default     = "was"
  type        = string
}

variable "tags" {
  description = "User-defined AWS resource tracking tags to add to all resources that Terraform creates"
  type        = map(string)
  default = {
    Terraform   = "true"
    Platform    = "Wolfram Application Server"
    Environment = "was"
  }
}

###############################################################################
# AWS Virtual Private Network Options
###############################################################################
variable "cidr" {
  description = "The subnet pattern to be used for all Terraform-managed resources requiring network configuration."
  type        = string
  default     = "192.168.0.0/20"
}

variable "private_subnets" {
  description = "The CIDR's of the two internal subnetworks that Terraform with automatically create for you."
  type        = list(string)
  default     = ["192.168.4.0/24", "192.168.5.0/24"]
}
variable "public_subnets" {
  description = "the CIDRs of the two public subnets that Terraform will automatically create for you."
  type        = list(string)
  default     = ["192.168.1.0/24", "192.168.2.0/24"]
}



###############################################################################
# AWS EKS variables
###############################################################################
variable "cluster_version" {
  description = "The version of Kubernetes for your AWS EKS Kubernetes cluster"
  default     = "1.27"
  type        = string
}

variable "disk_size" {
  description = "The number of gigabytes of storages to allocate to each Linux server node supporting your Kubernetes cluster"
  default     = "30"
  type        = number
}

variable "instance_types" {
  description = "the range of AWS EC2 instance types that Kubernetes will attempt to acquire from the AWS EC2 spot market"
  type        = list(string)
  default     = ["t3.2xlarge", "t3a.2xlarge", "t2.2xlarge"]
}

variable "desired_worker_node" {
  description = "The number of AWS EC2 Linux worker instances to create and assigned to your Kubernetes cluster"
  default     = "2"
  type        = number
}

variable "min_worker_node" {
  description = "The minimum permitted number of AWS EC2 Linux worker instances to be assigned to your Kubernetes cluster"
  default     = "2"
  type        = number
}

variable "max_worker_node" {
  description = "The maximum permitted number of AWS EC2 Linux worker instances to be assigned to your Kubernetes cluster when scaling"
  default     = "10"
  type        = number
}

variable "capacity_type" {
  description = "Pricing scheme to be used by AWS EC2 when acquiring Linux server instances for your cluster. Valid options are: ON_DEMAND, SPOT, RESERVED"
  default     = "SPOT"
  type        = string
}

variable "aws_auth_users" {
  description = "Additional IAM users to add to the aws-auth configmap in order to provide admin access to Kubernetes resources. If unset then only the Kubernetes cluster creator will have access to the cluster."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}

variable "kms_key_owners" {
  description = "Additional IAM users to add to AWS Key Management Service private key used for encrypting Kubernetes resources. These IAM users should exactly match your aws_auth_users list entries"
  type        = list(any)
  default     = []
}


###############################################################################
# Kubernetes Minio Deployment Options
###############################################################################
variable "tenantPoolsServers" {
  description = "The number of Kubernetes pods to create for the WAS minio client. Min.io recommends 4 or more."
  type        = number
  default     = 4
}
variable "tenantPoolsVolumesPerServer" {
  description = "The number of AWS EBS drive volumes to create and add to each Kubernetes Linux server node, per tenant pool. Min.io recommends 4 or more."
  type        = number
  default     = 4
}
variable "tenantPoolsSize" {
  description = "The number of gigabytes of storage to allocate to each minio tenant pool AWS EBS volume"
  type        = string
  default     = "10Gi"
}
variable "tenantPoolsStorageClassName" {
  description = "The kind of Kubernetes Storage Class to use for each Minio tenant pool AWS EBS volume"
  type        = string
  default     = "gp2"
}


###############################################################################
# Kubernetes Wolfram Application Server Deployment Options
###############################################################################
variable "was_active_web_elements_server_version" {
  description = "the Docker Hub version. See see https://hub.docker.com/r/wolframapplicationserver/active-web-elements-server/tags"
  type        = string
  default     = "3.1.5"
}
variable "was_endpoint_manager_version" {
  description = "the Docker Hub version. See see https://hub.docker.com/r/wolframapplicationserver/endpoint-manager/tags"
  type        = string
  default     = "1.2.1"
}
variable "was_resource_manager_version" {
  description = "the Docker Hub version. See see https://hub.docker.com/r/wolframapplicationserver/resource-manager/tags"
  type        = string
  default     = "1.2.1"
}
