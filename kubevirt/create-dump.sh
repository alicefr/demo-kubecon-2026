#!/bin/bash

VM=$1
set -x

virtctl memory-dump remove $VM
kubectl delete pvc $VM-dump

virtctl memory-dump get $VM \
	--create-claim \
	--claim-name=$VM-dump

kubectl wait vm $VM \
	--for=jsonpath='{.status.memoryDumpRequest.phase}'=Completed \
	--timeout=300s
