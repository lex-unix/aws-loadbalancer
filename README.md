An example repo of how to create application load balancer in AWS using Terraform.

## Infra components

Create a VPC with four subnets in two AZs: one private and one public in each AZ.

Create three security groups to allow: HTTP, SSH, and ICMP (for `ping`) traffic. SSH and ICMP are not mandatory,
and are used for debugging purposes only.

Create two EC2 instances: a bastion host and a web application (base NGINX web server). The bastion host is not mandatory,
and used for debugging purposes only. The bastion host is placed in public subnet, while the web application is in private.

Create a single target group “nginx” and attach the web application to it. Create one listener to forward HTTP traffic
to the “nginx” target group. Finally, create the application load balancer itself and place it in two public subnets.
Attach the load balancer to the listener.

## Prerequisites

I don’t use API credentials to authenticate my AWS account. Instead, I use SSO sessions.
You should modify these files to suit your needs:

```hcl
# providers.tf
provider "aws" {
  profile = "<your profile>" # or refer to docs for other authentication methods
  region  = "<your region>"
}
```

```hcl
# aws-nginx.pkr.hcl
source "amazon-ebs" "nginx" {
  profile = "<your profile>" # or refer to docs for other authentication methods
  # rest of the code...
}

```

Before you run `terraform apply`, you should create an AMI first. This is done to avoid creating a NAT gateway for outbound
traffic in private subnets when installing Nginx on your instances. Instead, you install Nginx on your AMI,
so that when you launch your instance from this AMI, that instance has Nginx already installed.
I use [Packer](https://developer.hashicorp.com/packer) for this, so you should have it installed.

To do so:

```sh
cd ./ami

packer init .

packer aws-nginx.pkr.hcl
```

> [!IMPORTANT]
> After you're done, you should go to the AWS console and delete the AMI manually, as Packer only builds images and doesn’t manage them.

After you’ve finished building the image, run `terraform apply` in the repository root directory.

You can verify that everything is working correctly by running:

```sh
curl "http://$(terraform output -raw lb_dns_name)"
```

The response should be similar to this:

```html
<!doctype html>
<html>
  <head>
    <title>Welcome to Nginx!</title>
  </head>
  <body>
    <h1>Hello from AWS!</h1>
    <p>This Nginx server was automatically configured using cloud-init.</p>
  </body>
</html>
```
