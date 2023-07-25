#------------------------------------------------------------------------------
# written by: Lawrence McDaniel
#             https://lawrencemcdaniel.com/
#
# date:       jul-2023
#
# usage: create an EKS cluster
#------------------------------------------------------------------------------
terraform {
  required_version = "~> 1.3"

  required_providers {
    local = "~> 2.2"

    template = {
      source  = "hashicorp/template"
      version = "~> 2.2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.8"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.22"
    }
  }
}
