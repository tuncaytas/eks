# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0



data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "tuncayeks"  # Specify your S3 bucket name
    key    = "tf-state/eks/terraform.tfstate"  # Specify the path to your state file within the bucket
    region = "us-east-1"  # Specify the AWS region where the S3 bucket is located
  }
}

# Retrieve EKS cluster configuration
data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
    command     = "aws"
  }
}

data "kubernetes_service" "nginx" {
  depends_on = [helm_release.nginx]
  metadata {
    name = "nginx"
  }
}