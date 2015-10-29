#!/bin/bash

set -u

rm -rf ./artifacts/* box/*

vagrant global-status | grep centos-7.1-x64 | awk '{print "vagrant destroy --force " $1}'  | sh
vagrant box remove --force centos71-kubernetes

packer build -machine-readable centos71-base-virtualbox.json
packer build -machine-readable centos71-kubernetes-virtualbox.json

vagrant up --provider=virtualbox
