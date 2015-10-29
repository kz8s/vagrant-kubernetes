## Provisioning a Desktop Kubernetes Cluster within VirtualBox with Packer and Vagrant

### Prerequisites

* Packer (https://www.packer.io/)
* Vagrant (https://www.vagrantup.com/)
* VirtualBox (https://www.virtualbox.org/wiki/Downloads)
* kubectl (https://github.com/kubernetes/kubernetes/releases/tag/v1.0.6)

### Build

Build a base CentOS7 image and layer Kubernetes on top of it

```
sh build-all.sh
```

### Smoketesting the Cluster

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

### Installing a Capable kubeconfig

Here is the kubeconfig that lets you interact with this cluster
without having to specify options to kubectl.  Put this in
$HOME/.kube/config:

```
apiVersion: v1
clusters:
- cluster:
    server: http://localhost:8080
  name: vbox
contexts:
- context:
    cluster: vbox
  name: vbox
current-context: vbox
kind: Config
preferences: {}
```
