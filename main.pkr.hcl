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
