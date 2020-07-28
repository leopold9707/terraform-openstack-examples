# Terraform 학습

Terraform 학습 과정 중 생성한 소스코드 등을 기록한 repository

### Terraform installation on Centos7

GUI가 있는 경우 https://www.terraform.io/downloads.html 에서 다운 받을 수 있다. 아래는 CentOS7 터미널에서 커맨드로 다운 받는 방법이다.

```
$ sudo yum install wget unzip 
$ sudo wget https://releases.hashicorp.com/terraform/0.12.29/terraform_0.12.29_linux_amd64.zip
$ sudo unzip ./terraform_0.12.29_linux_amd64.zip –d /usr/local/bin ##다운 받은 .zip 파일은 /usr/local/bin 아래 압축 해제 해준다.
$ terraform -v ##잘 설치 되었는지 확인한다.
```

## Terraform introduction

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

Version used:
*   Terraform 0.12.8

## Openstack authentification
The OpenStack provider is used to interact with the many resources supported by OpenStack. The provider needs to be configured with the proper credentials before it can be used.

```
provider "openstack" {
  user_name   = "my-litle-user"
  tenant_name = "my-little-tenant"
  password    = "secret"
  auth_url    = "http://your-cloud-prodivder.com"
}
```

## Getting Started

Before terraform apply you must download provider plugin:

```
terraform init
```

Display plan before apply manifest
```
terraform plan
```

Apply manifest
```
terraform apply
```

Destroy stack
```
terraform destroy
```

## Documentation
[https://www.terraform.io/docs/providers/openstack/](https://www.terraform.io/docs/providers/openstack/)

[https://github.com/terraform-providers/terraform-provider-openstack/tree/master/examples/app-with-networking](https://www.terraform.io/docs/providers/openstack/)
