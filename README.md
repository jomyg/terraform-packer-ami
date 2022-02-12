# Packer Golden Image Builder (AWS)
[![Builds](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

---

## Description
Packer is a tool for build a golden images also packer is lightwight. As of here, I have used to provision the image using a packer script.

## Pre-requisites:

1) AWS IAM account needed for the AMI build using the packer
2) Basic knowledge about AWS services especially AMI, EC2 and userdata.

-----
### How to install packer on your machine
Reference: [packer download](https://www.packer.io/downloads)
```sh
wget https://releases.hashicorp.com/packer/1.7.3/packer_1.7.3_linux_amd64.zip
unzip packer_1.7.3_linux_amd64.zip
mv packer /usr/bin/
```
## Behind the code:

### main.pkr.hcl
```
# -----------------------------------------------
# Timestamp variable declaration on running time
# -----------------------------------------------
locals { timestamp = regex_replace(timestamp(), "[- TZ:]", "") }

#--------------------------------------------------
# AMI (Golden image) Creation 
#--------------------------------------------------
source "amazon-ebs" "apache" {

  source_ami_filter {
    filters = {
      virtualization-type = "hvm"
      name                = "amzn2-ami-hvm-2.0.*.1-x86_64-ebs"
      root-device-type    = "ebs"
    }
    owners      = ["amazon"]
    most_recent = true
  }
  ami_name      = "PACKER-TEST ${local.timestamp}"
  region        = "ap-south-1"
  instance_type = "t2.micro"
  ssh_username  = "ec2-user"

  ###### IAM USER calling##################
  access_key = "${var.access-key}"
  secret_key = "${var.secret-key}"
  tags = {
    Env  = "PACKER-TEST"
    Name = "PACKER-TEST-${var.web_name}"
  }
}

### TO BUILD

build {
  sources = ["source.amazon-ebs.apache"]
  provisioner "file" {
    source      = "siteinstallation.sh"
    destination = "~/siteinstallation.sh"
  }
  provisioner "shell" {
    inline = ["sudo bash ~/siteinstallation.sh"]
  }
}
```
### siteinstallation.sh <<-- User data for AMI creation
```
#!/bin/bash
yum install httpd unzip -y
## Below is downloading a html site template from tooplate site
wget https://www.tooplate.com/download/2126_antique_cafe   
mv 2126_antique_cafe 2126_antique_cafe.zip
unzip 2126_antique_cafe.zip
sudo cp -rvf 2126_antique_cafe/* /var/www/html/
sudo chown apache. /var/www/html/ -R
sudo systemctl restart httpd
sudo systemctl enable httpd
```
### variables.pkr.hcl
```
################################################################
# Create a IAM programmatic user for the execution
###########################################################

variable "access-key" {
  default = "<access-key-from-aws-console-when-user-created>"
}

variable "secret-key" {
  default = "<secret-key-from-aws-console-when-user-created>"
}

variable "web_name" {
  default = "site-html"
}
```
Check packer version using
```sh
packer version
```
----

### To execute the project

```
packer init .
packer fmt .
packer validate .
packer build .
```

### Conclusion

#### When we have run this code, First an Ec2 will create with above userdata and it will get terminated automatically once AMI creation is done from the created EC2
