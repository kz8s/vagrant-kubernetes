#!/bin/bash

set -ux

vagrant destroy --force centos-7.1-x64
vagrant box remove --force centos71-kubernetes
vagrant up --provider=virtualbox
