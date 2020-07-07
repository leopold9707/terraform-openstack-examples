#!/bin/bash

su - centos
yum install -y git
git clone -b taco-v20.05 --single-branch https://github.com/openinfradev/tacoplay.git ~/tacoplay
