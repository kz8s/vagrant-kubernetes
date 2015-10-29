#!/bin/bash

set -ux

cat <<EOF | kubectl --kubeconfig=kubernetes-configs/kubeconfig create -f -
apiVersion: v1
kind: Pod
metadata:
  name: busybox
  namespace: default
spec:
  containers:
  - image: busybox
    command:
      - sleep
      - "3600"
    imagePullPolicy: IfNotPresent
    name: busybox
  restartPolicy: Always
EOF

# Wait for busybox to be Running
STATUS=$(kubectl --kubeconfig=kubernetes-configs/kubeconfig get --no-headers pods | grep busybox | awk '{print $3}')
while [ "$STATUS" != "Running" ]; do
    sleep 5
    STATUS=$(kubectl --kubeconfig=kubernetes-configs/kubeconfig get --no-headers pods | grep busybox | awk '{print $3}')
done

# Wait for kube-dns to settle
watch kubectl --kubeconfig=kubernetes-configs/kubeconfig exec busybox nslookup kubernetes
