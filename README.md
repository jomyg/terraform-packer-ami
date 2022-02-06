# Packer Golden Image Builder (AWS)
[![Builds](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

---

## Description
Packer is a tool for build a golden images also packer is lightwight. As of here, I have used to provision the image using a packer|terraform script.

-----
### How to install packer on your machine
Reference: [packer download](https://www.packer.io/downloads)
```sh
wget https://releases.hashicorp.com/packer/1.7.3/packer_1.7.3_linux_amd64.zip
unzip packer_1.7.3_linux_amd64.zip
mv packer /usr/bin/
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
