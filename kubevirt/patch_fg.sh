#!/bin/bash

kubectl patch kubevirt kubevirt -n kubevirt \
	--type=merge --patch \
	'{"spec": {"configuration": {"developerConfiguration": {"featureGates": ["WorkloadEncryptionSEV","HotplugVolumes", "VMExport"]}}}}'
