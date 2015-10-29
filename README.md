# Provisioning a Desktop Kubernetes Cluster within VirtualBox with Packer and Vagrant

## Prerequisites

* Packer (https://www.packer.io/)
* Vagrant (https://www.vagrantup.com/)
* kubectl (https://github.com/kubernetes/kubernetes/releases/tag/v1.0.6)
* VirtualBox 

## From Scratch Build

Build a base CentOS7 image and layer Kubernetes on top of it

```
sh build-all.sh
```

### Kubernetes build only

If you have a good base CentOS image, use it and layer Kubernetes on top of it

```
sh build-k8s.sh
```

### Vagrant only

If you have a good Kubernetes build, build the Vagrant machine only

```
sh build-vagrant.sh
```

## Smoke testing the final image

Smoke test the cluster by creating a trivial process in a busybox
container, then exec into that container to do an nslookup on the
Kubernetes system service.

```
sh smoketest.sh
```

When the cluster has settled, you should see this output from the
nslookup command the smoketest launches

```
Every 2.0s: kubectl --kubeconfig=kubernetes-configs/kubeconfig exec busybox nslookup kubernetes        

Server:    192.168.0.53
Address 1: 192.168.0.53

Name:      kubernetes
Address 1: 192.168.0.1
```

Cleanup the smoketest busybox container

```
kubectl --kubeconfig=kubernetes-configs/kubeconfig delete pod busybox
```
