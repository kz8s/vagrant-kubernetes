## Provisioning a desktop Kubernetes cluster within VirtualBox with Packer and Vagrant

Build a single-machine Kubernetes cluster for local development purposes.  Master and single node reside
on the same VirtualBox VM.  skydns is included in the cluster, so service lookup by name works.

### Prerequisites

To proceed, you must have the following tools installed and on your PATH:

* Packer (https://www.packer.io/)
* Vagrant (https://www.vagrantup.com/)
* VirtualBox (https://www.virtualbox.org/wiki/Downloads)

You will also need an executable kubectl toward the end of these
instructions.  Download a Kubernetes release tarball and extract
[kubectl](https://github.com/kubernetes/kubernetes/releases/tag/v1.0.6)
from it.

### Build

Build a base CentOS7 image and layer Kubernetes on top of it

```
sh build-all.sh
```

As part of its action, this script downloads the ISO image for
CentOS7.  The first time you run it may take 20-30 minutes, depending
on your network.  This ISO image is cached, so subsequent runs will
take significantly less time.

#### Tweaking the Kubernetes configuration

Cluster configuration is easily modified by changing configs in ./kubernetes-configs, followed
by rebuilding the Kubernetes bits through Packer.  Changes to the Kubernetes configuration do not require a full rebuild
of the underlying CentOS box:

```
$ rm -rf artifacts/centos71-kubernetes box/virtualbox/centos71-kubernetes-x64-1.0.0.box
$ vagrant global-status | grep centos-7.1-x64 | awk '{print "vagrant destroy --force " $1}'  | sh
$ vagrant box remove --force centos71-kubernetes

$ packer build centos71-kubernetes-virtualbox.json

$ vagrant up --provider=virtualbox
```

### Smoketesting the cluster

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

### Installing a capable kubeconfig

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
