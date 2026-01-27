#!/bin/bash

set -xe 
kubectl create secret generic vm-ign-conf --from-file=userdata=k3s-vm-conf.ign
