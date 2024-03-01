# Infrastructure-for-web-application
Basic Infrastructure to publish a web application (frontend and backend) on the Internet.

<p align="center">
  <img src="docs/Infrastructure For Webapp.drawio.png"/>
</p>

## Requirements

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

## Deploy the resources

1. Clone this repository.

```shell
git clone https://github.com/pierolenzo/Infrastructure-for-web-application.git

```

2. Start with `core-infra` to create core infrastructure (cluster, VPC)

```shell
cd Infrastructure-for-web-application/core-infra/
terraform init
terraform plan
terraform apply
```

3. Deploy a backend service

```shell
cd ../be-services
```
* into file `env/prod/terraform.tfvars`
  * configure the variable `docker_image_url`  with your docker image

```shell
terraform init
terraform plan -var-file=./env/prod/terraform.tfvars
terraform apply -var-file=./env/prod/terraform.tfvars
```

4.  deploy a frontend service

```shell
cd ../fe-services
```

* into file `env/prod/terraform.tfvars`
  * configure the variable `docker_image_url`  with your docker image
  * If you want to use your own domain configured in route53, set the variable `create_route53_record = true` and put the domain name in `domain_name`.
   > [!NOTE] 
   > an alternative, set "create_route53_record" to "false" if you don't have a domain and want to test the infrastructure quickly.

```shell
terraform init
terraform plan -var-file=./env/prod/terraform.tfvars
terraform apply -var-file=./env/prod/terraform.tfvars
```

I you don't have your domain name, point the below URL with your browser

```shell
Outputs:

application_url = "https://webapp-prod-xxxxxxxx.eu-south-1.elb.amazonaws.com"
```

> [!WARNING]  
> The TLS certificate is self signed, in a prod enviroment change it.