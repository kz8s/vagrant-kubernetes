## Provisioning a Desktop Kubernetes Cluster within VirtualBox with Packer and Vagrant

### Prerequisites

* Packer (https://www.packer.io/)
* Vagrant (https://www.vagrantup.com/)
* VirtualBox (https://www.virtualbox.org/wiki/Downloads)

### Build

Build a base CentOS7 image and layer Kubernetes on top of it

```
sh build-all.sh
```

As part of its action, this script downloads the ISO image for
CentOS7.  The first time you run it may take 20-30 minutes, depending
on your network.  This ISO image is cached, so subsequent runs will
take significantly less time.

### Smoketesting the Cluster

Download a Kubernetes release tarball and extract
[kubectl](https://github.com/kubernetes/kubernetes/releases/tag/v1.0.6)
from it.

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

```
kubectl cluster-info
Kubernetes master is running at http://localhost:8080
KubeDNS is running at http://localhost:8080/api/v1/proxy/namespaces/kube-system/services/kube-dns
```
