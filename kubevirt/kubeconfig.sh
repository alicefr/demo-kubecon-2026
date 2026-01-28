#!/bin/bash

VM=$1
CONFIG=$(pwd)/k3s-kubeconfig.yaml
kill -9 $(pgrep virtctl)

set -ex

virtctl ssh root@vmi/$VM -i $HOME/.ssh/coreos.key -c "cat /etc/rancher/k3s/k3s.yaml" &> $CONFIG
virtctl  port-forward vmi/$VM 6443:6443 &
echo "export KUBECONFIG=$CONFIG"
