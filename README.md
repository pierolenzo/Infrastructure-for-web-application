# Infrastructure-for-web-application
Infrastructure to publish a web application (frontend and backend) on the Internet.

<p align="center">
  <img src="docs/Infrastructure For Webapp.drawio.png"/>
</p>

## Prerequisites

* [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)

* [Git](https://github.com/git-guides/install-git) (tested version 2.27.0)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions)
* AWS test account with administrator role access
* Configure the AWS credentials on your machine `~/.aws/credentials`. You need to use the following format:

```shell
[AWS_PROFILE_NAME]
aws_access_key_id = Replace_with_the_correct_access_Key
aws_secret_access_key = Replace_with_the_correct_secret_Key
```

* Export the AWS profile name

```bash
export AWS_PROFILE=your_profile_name
```

## Install the resources

* Fork this repository.

* Clone your forked repository to your laptop.

```shell
git clone https://github.com/pierolenzo/Infrastructure-for-web-application.git
```

* Start with `core-infra` to create cluster, VPC

```shell
cd Infrastructure-for-web-application/core-infra/

terraform init
terraform plan
terraform apply
```
* Now we can deploy a backend service

```shell
cd ../be-services
terraform init
terraform plan
terraform apply
```
* Now we can deploy a frontend service

```shell
cd ../fe-services
terraform init
terraform plan
terraform apply
```

You can use the ALB URL from terraform output to access the load balanced service. 
