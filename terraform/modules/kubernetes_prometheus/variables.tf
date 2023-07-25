#------------------------------------------------------------------------------
# written by: Lawrence McDaniel
#             https://lawrencemcdaniel.com/
#
# date: jul-2023
#
# usage: create an EKS cluster
#------------------------------------------------------------------------------


variable "domain" {
  type = string
}

variable "cluster_issuer" {
  type = string
}
