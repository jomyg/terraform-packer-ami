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
