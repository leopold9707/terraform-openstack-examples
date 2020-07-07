#!/bin/bash

# yum update -y
# yum install -y epel-release git
# yum install -y python-pip
# yum update -y

yum install git
git clone -b taco-v20.05 --single-branch https://github.com/openinfradev/tacoplay.git /home/centos/tacoplay
