# KubeVirt setup demo
## Enable SEV/SNP in KubeVirt
```console
./patch_fg.sh
``` 
## Create the VM
```console
./create-secret.sh
```
Create and atart the VM:
```console
$ kubectl apply -f vm-conf.yaml
```
