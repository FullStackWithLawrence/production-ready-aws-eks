[![Source code](https://img.shields.io/static/v1?logo=github&label=Git&style=flat-square&color=brightgreen&message=Source%20code)](https://github.com/FullStackWithLawrence/009-scikit-learn-random-forest)
[![Documentation](https://img.shields.io/static/v1?&label=Documentation&style=flat-square&color=000000&message=Documentation)](https://github.com/FullStackWithLawrence/009-scikit-learn-random-forest)
[![AGPL License](https://img.shields.io/github/license/overhangio/tutor.svg?style=flat-square)](https://www.gnu.org/licenses/agpl-3.0.en.html)
[![hack.d Lawrence McDaniel](https://img.shields.io/badge/hack.d-Lawrence%20McDaniel-orange.svg)](https://lawrencemcdaniel.com)

# Production-Ready AWS Elastic Kubernetes Service

This is the source code for my [Blog Article](https://blog.lawrencemcdaniel.com/production-ready-aws-elastic-kubernetes-service/) and [FullStackWithLawrence Youtube Video](https://www.youtube.com/watch?v=vVgUT4okdsY).

[![Watch the video](https://i3.ytimg.com/vi/vVgUT4okdsY/maxresdefault.jpg)](https://www.youtube.com/watch?v=vVgUT4okdsY)

Terraform scaffolding to create a production-ready Kubernetes cluster running inside its own VPC. Sets up spot pricing for EC2 instances, and installs and configures commonly needed packages including:

- nginx-ingress-controller
- cert-manager
- metrics-server
- prometheus
- vertical pod autoscaler (vpa)

Consists of the following source code: 

```console
-------------------------------------------------------------------------------
Language                     files          blank        comment           code
-------------------------------------------------------------------------------
HCL                             39            318            457           1410
Text                             1            118              0            553
Markdown                         2            101              0            260
JSON                             1              0              0            176
YAML                            10              1              3            163
-------------------------------------------------------------------------------
SUM:                            53            538            460           2562
-------------------------------------------------------------------------------
```

## Usage

```console
foo@bar:~$ git clone https://github.com/FullStackWithLawrence/010-most-important-kubernetes-video.git
foo@bar:~$ cd 010-most-important-kubernetes-video
foo@bar:~$ terraform init
foo@bar:~$ terraform apply
```

## How To Setup Your Local Environment

This document describes how to deploy a [Managed Kubernetes Service Cluster](https://aws.amazon.com/eks/) with [AWS cloud infrastructure](https://aws.amazon.com/).

This is a [Terraform](https://www.terraform.io/) based installation methodology that reliably automates the complete build, management and destruction processes of all resources. [Terraform](https://www.terraform.io/) is an [infrastructure-as-code](https://en.wikipedia.org/wiki/Infrastructure_as_code) command line tool that will create and configure all of the software and cloud infrastructure resources that are needed for running EKS. These Terraform scripts will install and configure all cloud infrastructure resources and system software on which EKS depends. This process will take around 15 minutes to complete and will generate copious amounts of console output.

Terraform will create a dedicated [AWS Virtual Private Network (VPC)](https://aws.amazon.com/vpc/) to contain all other resources that it creates. This VPC serves as an additional 'chinese wall' that prevents these AWS resources and system software packages from being able to interact with any other AWS resources that might already exist in your AWS account. This additional layer is strongly recommended, and you will incur negligable additional AWS cost for adding this additional layer of security protection.

This EKS application stack consists of the following:

* a AWS S3 bucket and DynamoDB table for managing Terraform state
* a dedicated [AWS VPC](https://aws.amazon.com/vpc/)
* a dedicated [AWS EKS Kubernetes cluster](https://aws.amazon.com/eks/)
  * a configurable [Managed Node Group](https://docs.aws.amazon.com/eks/latest/userguide/managed-node-groups.html) with on-demand and spot-priced tier options
  * AWS EKS Add-on [EFS CSI Driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
  * AWS EKS Add-on [EBS CSI Driver](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
  * AWS EKS Add-on [VPC CNI](https://docs.aws.amazon.com/eks/latest/userguide/managing-vpc-cni.html)
  * AWS EKS Add-on [kube-proxy](https://docs.aws.amazon.com/eks/latest/userguide/eks-add-ons.html)
  * AWS EKS Add-on [CoreDNS](https://docs.aws.amazon.com/eks/latest/userguide/managing-coredns.html)
* Kubernetes [Vertical Pod Autoscaler](https://docs.aws.amazon.com/eks/latest/userguide/vertical-pod-autoscaler.html)
* Kubernetes [Metrics Server](https://github.com/kubernetes-sigs/metrics-server)
* Kubernetes [Prometheus](https://prometheus.io/)
* Kubernetes [cert-manager](https://cert-manager.io/)
* Kubernetes [Nginx Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/)
* Kubernetes [Karpenter](https://karpenter.sh/)

**WARNINGS**:

**1. The EKS service will create many AWS resources in other parts of your AWS account including EC2, VPC, IAM and KMS. You should not directly modify any of these resources, as this could lead to unintended consequences in the safe operation of your Kubernetes cluster up to and including permanent loss of access to the cluster itself.**

**2. Terraform is a memory intensive application. For best results you should run this on a computer with at least 4Gib of free memory.**

## I. Installation Prerequisites

Quickstart for Linux & macOS operating systems.

**Prerequisite:** Obtain an [AWS IAM User](https://aws.amazon.com/iam/) with administrator priviledges, access key and secret key.

Ensure that your environment includes the latest stable releases of the following software packages:

* [aws cli](https://aws.amazon.com/cli/)
* [kubectl (Kubernetes cli)](https://kubernetes.io/docs/tasks/tools/)
* [terraform](https://www.terraform.io/)
* [helm](https://helm.sh/)
* [k9s](https://k9scli.io/)

### Install required software packages using Homebrew

If necessary, install [Homebrew](https://brew.sh/)

```console
/bin/bash -c "$(curl -fsSL https://github.com//Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/ubuntu/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

Use homebrew to install all required packages.

```console
brew install awscli kubernetes-cli terraform helm k9s
```

### Configure the AWS CLI

To configure the AWS CLI run the following command:

```console
aws configure
```

This will interactively prompt for your AWS IAM user access key, secret key and preferred region.

### Install Helm charts

Helm helps you manage Kubernetes applications. Based on yaml 'charts', Helm helps you define, install, and upgrade even the most complex Kubernetes applications. Wolfram Application Server depends on multiple large complex subsystems, and fortunately, vendor-supported Helm charts are available for each of these.

Helm charts first need to be downloaded and added to your local Helm repository. The helm charts will be automatically executed by Terraform at the appropriate time, so there is nothing further that you need to do beyond adding these charts to your local helm repository.

```console
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm repo add jetstack https://charts.jetstack.io
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts/
helm repo add cowboysysop https://cowboysysop.github.io/charts/
helm repo update
```

### Setup Terraform

Terraform is a declarative open-source infrastructure-as-code software tool created by HashiCorp. This repo leverages Terraform to create all cloud infrastructure as well as to install and configure all software packages that run inside of Kubernetes. Terraform relies on an S3 bucket for storing its state data, and a DynamoDB table for managing a semaphore lock during operations.

Use these three environment variables for creating the uniquely named resources that the Terraform modules in this repo will be expecting to find at run-time.

**IMPORTANT: these three settings should be consistent with the values your set in terraform.tfvars in the next section.**

```console
AWS_ACCOUNT=012345678912      # add your 12-digit AWS account number here
AWS_PROFILE=default           # any valid aws cli profile name
AWS_REGION=us-east-1          # any valid AWS region code.
AWS_ENVIRONMENT=fswl          # any valid string. Keep it short -- 3 characters is ideal.
```

To verify your AWS CLI identify

```console
aws --version
aws sts get-caller-identity
```

If necessary you can force the aws cli to recoginize your aws profile name with this command.

```console
export AWS_PROFILE=default
aws sts get-caller-identity
```

The IAM user returned in the console output should match the IAM username you set above.

Next create an AWS S3 Bucket

```console
AWS_S3_BUCKET="${AWS_ACCOUNT}-terraform-tfstate-${AWS_ENVIRONMENT}"
aws s3api create-bucket --bucket $AWS_S3_BUCKET --region $AWS_REGION --profile $AWS_PROFILE --create-bucket-configuration LocationConstraint=$AWS_REGION
```

Then create a DynamoDB table

```console
AWS_DYNAMODB_TABLE="terraform-state-lock-${AWS_ENVIRONMENT}"
aws dynamodb create-table --profile $AWS_PROFILE --region $AWS_REGION --table-name $AWS_DYNAMODB_TABLE  \
               --attribute-definitions AttributeName=LockID,AttributeType=S  \
               --key-schema AttributeName=LockID,KeyType=HASH --provisioned-throughput  \
               ReadCapacityUnits=1,WriteCapacityUnits=1
```

## II. Deploy EKS

### Step 1. Checkout the repository

```console
git clone https://github.com/FullStackWithLawrence/010-most-important-kubernetes-video.git
```

### Step 2. Change directory to terraform

```console
cd 010-most-important-kubernetes-video/terraform/
```

### Step 3. Configure your Terraform backend

Edit the following snippet so that bucket, region and dynamodb_table are consistent with your values of $AWS_REGION, $AWS_S3_BUCKET, $AWS_DYNAMODB_TABLE

```console
vim terraform/terraform.tf
```

```terraform
  backend "s3" {
    bucket         = "012345678912-terraform-tfstate-fswl"
    key            = "fswl/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-fswl"
    profile        = "default"
    encrypt        = false
  }
````

### Step 4. Configure your environment by setting Terraform global variable values

```console
vim terraform/terraform.tfvars
```

Required inputs are as follows:

```terraform
account_id           = "012345678912"
aws_region           = "us-east-1"
domain               = "example.com"
shared_resource_name = "fswl"
```

And there are additional optional inputs include the folowing:

```terraform
tags                 = {}
aws_profile          = "default"
aws_auth_users       = []
kms_key_owners       = []
shared_resource_name = "fswl"
cidr                 = "192.168.0.0/20"
private_subnets      = ["192.168.4.0/24", "192.168.5.0/24"]
public_subnets       = ["192.168.1.0/24", "192.168.2.0/24"]
cluster_version      = "1.27"
capacity_type        = "SPOT"
min_worker_node      = 2
desired_worker_node  = 2
max_worker_node      = 10
disk_size            = 30
instance_types       = ["t3.2xlarge", "t3a.2xlarge", "t2.2xlarge"]
```

### Step 5. Run the following command to set up EKS

The Terraform modules in this repo rely extensively on calls to other third party Terraform modules published and maintained by [AWS](https://registry.terraform.io/namespaces/terraform-aws-modules). These modules will be downloaded by Terraform so that these can be executed locally from your computer. Noteworth examples of such third party modules include:

* [terraform-aws-modules/vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest)
* [terraform-aws-modules/eks](https://registry.terraform.io/modules/terraform-aws-modules/eks/aws/latest)

```console
terraform init
```

Screen output should resemble the following:

![terraform-plan](https://github.com/FullStackWithLawrence/010-most-important-kubernetes-video/blob/main/doc/terraform-plan.png)

To deploy all resources run the following

```console
terraform apply
```

You can optionally run Terraform modules individually. Some examples include

```console
terraform apply -target=module.eks
terraform apply -target=module.metricsserver
terraform apply -target=module.prometheus
terraform apply -target=module.ingress_controller
```

### Step 5. Interact with the AWS EKS Kubernetes cluster

the AWS CLI provides a handy command-line tool for configuring kubectl for your new AWS EKS Kubernetes cluster. 

```console
AWS_REGION=us-east-1
EKS_CLUSTER_NAME=fswl
aws eks --region $AWS_REGION update-kubeconfig --name $EKS_CLUSTER_NAME --alias $EKS_CLUSTER_NAME
```

Use this command to verify that kubectl can access Kubernetes cluster resources.

```console
$ kubectl get namespaces
NAME                 STATUS   AGE
default              Active   3h
ingress-controller   Active   101m
kube-node-lease      Active   3h
kube-public          Active   3h
kube-system          Active   3h
metrics-server       Active   106m
prometheus           Active   105m
vpa                  Active   106m
```

Afterwards, you can use k9s, a text-based gui, to view and interact with Kubernetes resources. k9s relies on kubectl to communicate with the AWS EKS Kuberenetes cluster.


```console
k9s
```

After successfully running the Terraform script the k9s home screen should look similiar to the following:

![k9s home screen](https://github.com/FullStackWithLawrence/010-most-important-kubernetes-video/blob/main/doc/up-and-running.png "K9s Home Screen")

### Step 6. Check out a real URL end point that your new cluster is hosting

Coincidentally, the Prometheur Helm chart also installs an application named Grafana which includes a web-based console that will be accessible from the URL endpoint 'https://grafana.fswl.yourdomain.com'.

You can retrieve your custom credentials from the following Kubernetes secrets:
(noting that your password will be different from the value shown in the screen shot example)

![Grafana credentials](https://github.com/FullStackWithLawrence/010-most-important-kubernetes-video/blob/main/doc/grafana-signin-credentials.png "Grafana Sign In")

Once your logged in you should see a Grafana home page similar to the following:

![Grafana home page](https://github.com/FullStackWithLawrence/010-most-important-kubernetes-video/blob/main/doc/grafana-home-page.png "Grafana Home Screen")

### Trouble Shooting

#### Error: Incompatible provider version

This is a known shortcoming of Terraform when run on macOS M1 platforms. See this [Terraform discussion forum thread](https://discuss.hashicorp.com/t/template-v2-2-0-does-not-have-a-package-available-mac-m1/35099/14) for trouble shooting ideas.

```console
│
│ Provider registry.terraform.io/hashicorp/template v2.2.0 does not have a package available for your current platform, darwin_arm64.
│
│ Provider releases are separate from Terraform CLI releases, so not all providers are available for all platforms. Other versions of this provider may have different platforms supported.
```

#### Error loading state: BucketRegionError: incorrect region, the bucket is not in

You'll encounter this error if the AWS region code in which you are attempting to deploy to does not match the region for the AWS S3 bucket you created.

#### Error: Error acquiring the state lock

Terraform sets a 'lock' in the AWS DynamoDB table that you created in the Terraform Setup above. If a Terraform operation fails then on your next operation attempt you will likely encounter the following error response, indicating that the Terraform state is currently locked.

```console
│ Error: Error acquiring the state lock
│
│ Error message: ConditionalCheckFailedException: The conditional request failed
│ Lock Info:
│   ID:        e1bd1079-86dc-0cd5-ea98-4d8c5ddb4d5a
│   Path:      123456789012-terraform-tfstate-fswl/fswl/terraform.tfstate
│   Operation: OperationTypeApply
│   Who:       ubuntu@ip-192-168-2-200
│   Version:   1.5.2
│   Created:   2023-07-10 17:11:39.939826727 +0000 UTC
│   Info:
│
│
│ Terraform acquires a state lock to protect the state from being written
│ by multiple users at the same time. Please resolve the issue above and try
│ again. For most commands, you can disable locking with the "-lock=false"
│ flag, but this is not recommended.

```

You can optionally execute the Terraform scripts without a lock, as follows:

```console
terraform apply -lock=false
```


## Contributing

Give back to the open source community! If you have good ideas for how to improve this code then by all means, please seize the day and share your improvements by creating a pull request: fork this repo, make your changes, and then open a pull request; most of which can be done directly from Github.

### Local development

This being the low budget one-man-band operation that it is, I'm reliant on the automated coding style enforcement and syntax checking capabilities of [pre-commit](https://pre-commit.com/), [black](https://pypi.org/project/black/) and [flake8](https://flake8.pycqa.org/), so you'll want to install these amazing tools **prior** to attempting a PR as I've also installed automated [Github Actions](https://github.com/features/actions) [CI](https://en.wikipedia.org/wiki/Continuous_integration) tools that will run these tests on all commits.

```console
foo@bar:~$ pip install -r requirements-dev.txt
foo@bar:~$ pre-commit install
pre-commit installed at .git/hooks/pre-commit
foo@bar:~$ 
foo@bar:~$ pre-commit
```

![pre-commit output](https://github.com/FullStackWithLawrence/010-most-important-kubernetes-video/blob/main/doc/pre-commit.png)

