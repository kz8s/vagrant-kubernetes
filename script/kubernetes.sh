#!/bin/bash

set -ux

echo "==> Bootstrap packages"
yum -y install ntp
systemctl start ntpd
systemctl enable ntpd

echo "==> Install Kubernetes"
yum makecache && yum install -y kubernetes-client kubernetes-master kubernetes-node cockpit-kubernetes etcd

echo "==> Configuring Kubernetes"

for i in config apiserver kubelet controller-manager; do
   cp -v /tmp/$i /etc/kubernetes/$i
done

mkdir -p /etc/ssl/private
mkdir -p /etc/ssl/certs

cp -v /tmp/apiserver.crt /etc/ssl/certs/apiserver.crt
cp -v /tmp/apiserver.key /etc/ssl/private/apiserver.key
cp -v /tmp/ca.pem /etc/ssl/certs/cacert.pem

cp -v /tmp/kubeconfig /etc/kubernetes/kubeconfig

for SERVICES in etcd kube-apiserver kube-controller-manager kube-scheduler kube-proxy kubelet docker; do
    systemctl enable  $SERVICES
    systemctl restart $SERVICES
    systemctl status  $SERVICES
done

ADDONS_DIRECTORY=/etc/kubernetes/addons
mkdir -p $ADDONS_DIRECTORY

cp /tmp/*.yaml $ADDONS_DIRECTORY/

kubectl create -f $ADDONS_DIRECTORY/kubesystem-namespace.yaml
kubectl create -f $ADDONS_DIRECTORY/skydns.yaml

# Wait for kube-dns to come up
STATUS=$(kubectl --no-headers --namespace=kube-system get pods | grep ^kube-dns | awk '{print $3}')
while [ "$STATUS" != "Running" ]; do
    sleep 5
    STATUS=$(kubectl --no-headers --namespace=kube-system get pods | grep ^kube-dns | awk '{print $3}')
done

