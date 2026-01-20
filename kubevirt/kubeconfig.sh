#!/bin/bash

set -e

VM=demovm
CONFIG=$(pwd)/k3s-kubeconfig.yaml

virtctl ssh root@vmi/$VM -i /home/afrosi/.ssh/coreos.key -c "cat /etc/rancher/k3s/k3s.yaml" &> $CONFIG
virtctl  port-forward vmi/$VM 6443:6443 &
#IP=$(kcli info vm $VM | grep ip | awk -F ":" '{ print $2 }' | tr -d " ")
#sed -i "s|server: https://127.0.0.1:6443|server: https://$IP:6443|g" $CONFIG
echo "export KUBECONFIG=$CONFIG"
