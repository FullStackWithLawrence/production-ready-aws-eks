[![Source code](https://img.shields.io/static/v1?logo=github&label=Git&style=flat-square&color=brightgreen&message=Source%20code)](https://github.com/FullStackWithLawrence/009-scikit-learn-random-forest)
[![Documentation](https://img.shields.io/static/v1?&label=Documentation&style=flat-square&color=000000&message=Documentation)](https://github.com/FullStackWithLawrence/009-scikit-learn-random-forest)
[![AGPL License](https://img.shields.io/github/license/overhangio/tutor.svg?style=flat-square)](https://www.gnu.org/licenses/agpl-3.0.en.html)
[![hack.d Lawrence McDaniel](https://img.shields.io/badge/hack.d-Lawrence%20McDaniel-orange.svg)](https://lawrencemcdaniel.com)

# The Most Important Kubernetes Video You'll Ever Watch

Simple scaffolding to create a production-ready Kubernetes cluster on AWS Elastic Kubernetes Service using Terraform.

This is the source code for FullStackWithLawrence Youtube Video -- "????".

## Usage

```console
foo@bar:~$ git clone https://github.com/FullStackWithLawrence/010-most-important-kubernetes-video.git
foo@bar:~$ cd 010-most-important-kubernetes-video
foo@bar:~$ terraform init
foo@bar:~$ terraform apply
```

### Prerequistes

- an account on AWS
- awscli
- terraform

### If You're New to Terraform


### If You're New to AWS Elastic Kubernetes Service



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

![pre-commit output](https://github.com/FullStackWithLawrence/009-scikit-learn-random-forest/blob/main/doc/pre-commit.png)
