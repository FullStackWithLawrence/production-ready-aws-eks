#------------------------------------------------------------------------------
# written by: Miguel Afonso
#             https://www.linkedin.com/in/mmafonso/
#
# date: Aug-2021
#
# usage: build an EKS cluster load balancer
#------------------------------------------------------------------------------
variable "domain" {
  type = string
}

variable "namespace" {
  type    = string
  default = "was"
}

variable "cert_manager_namespace" {
  type    = string
  default = "cert-manager"
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "tags" {
  description = "A map of tags to add to all resources. Tags added to launch configuration or templates override these values for ASG Tags only."
  type        = map(string)
  default     = {}
}
