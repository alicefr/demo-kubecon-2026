#!/bin/bash


VM=$1
virtctl expose virtualmachine $VM \
  --name app-api \
  --port 30080 \
  --target-port 30080 \
  --type NodePort

IP=$(kubectl get no kind-control-plane -o jsonpath='{.status.addresses[?(@.type=="InternalIP")].address}')
PORT=$(kubectl get svc app-api -o jsonpath='{.spec.ports[0].nodePort}')

echo "App avilable at $IP:$PORT"
