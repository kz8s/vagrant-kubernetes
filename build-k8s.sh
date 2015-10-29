#!/bin/bash

set -ux

rm -rf artifacts/centos71-kubernetes/
rm -rf box/virtualbox/centos71-kubernetes-x64-1.0.0.box

vagrant destroy --force centos-7.1-x64
vagrant box remove --force centos71-kubernetes

packer build -machine-readable centos71-kubernetes-virtualbox.json

vagrant up --provider=virtualbox
