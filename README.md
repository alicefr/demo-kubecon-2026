# KubeVirt setup demo

This demo shows how you can create KubeVirt VMs with k3s and dump the memory of the VM to extract a secret. In this case, it is a demo app built in app that prints the password give with a PUT request. If the VM is a confidential VM, the memory is encrypted and the secrets are in clear text.

## Environment preparation
```console
$ cd kubevirt
```
### Enable SEV/SNP and memory dumps in KubeVirt
```console
./patch_fg.sh
``` 

### Install CDI
```bash
./install-cdi.sh
```

### Create the VM
```console
./create-secret.sh
```
Create and start the VM:
```console
$ kubectl apply -f vm-conf.yaml
```
### Get the second cluster kubeconfig
```console
./kubeconfig.sh
```
### Export the kubeconfig and deploy the application in the second cluster
```bash
$ kubectl apply -f ../app/deploy-app-demo.yaml 
{"component":"portforward","level":"info","msg":"opening new tcp tunnel to 6443","pos":"tcp.go:34","timestamp":"2026-01-28T07:48:36.859513Z"}
{"component":"portforward","level":"info","msg":"handling tcp connection for 6443","pos":"tcp.go:47","timestamp":"2026-01-28T07:48:36.872967Z"}
{"component":"portforward","level":"info","msg":"opening new tcp tunnel to 6443","pos":"tcp.go:34","timestamp":"2026-01-28T07:48:36.906365Z"}
{"component":"portforward","level":"info","msg":"handling tcp connection for 6443","pos":"tcp.go:47","timestamp":"2026-01-28T07:48:36.918636Z"}
deployment.apps/demo created
service/demo-service created
```
### Demo

Access the application. The `export-app.sh` expose the application running in the second cluster to the host.
```console
unset KUBECONFIG
$ ./export-app.sh
Service app-api successfully created for virtualmachine demovm
App avilable at 172.19.0.2:31492
$ curl -X POST -d "password=supersecretpassword" 172.19.0.2:31492
Login Successful
```

Create the dump. The `virtctl` command creates a memory dump of the VM on a PVC.
```console
$ ./create-dump.sh demovm
+ virtctl memory-dump remove demovm
error removing memory dump association, Operation cannot be fulfilled on virtualmachine.kubevirt.io "demovm": can't remove memory dump association for vm demovm, no association found
+ kubectl delete pvc demovm-dump
Error from server (NotFound): persistentvolumeclaims "demovm-dump" not found
+ virtctl memory-dump get demovm --create-claim --claim-name=demovm-dump
PVC default/demovm-dump created
Successfully submitted memory dump request of VM demovm
+ kubectl wait vm demovm '--for=jsonpath={.status.memoryDumpRequest.phase}=Completed' --timeout=300s
virtualmachine.kubevirt.io/demovm condition met
```

Inspect the dump file

```console
$ kubectl get pvc
NAME                                STATUS   VOLUME                                     CAPACITY     ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
demovm-dump                         Bound    pvc-00712eeb-3172-4b11-84da-fd81bcbed9fa   4453302272   RWO            standard       <unset>                 5m17s
persistent-state-for-demovm-jdc9f   Bound    pvc-feb29b1f-bf3a-4de7-87f0-991c139f0bb4   10Mi         RWO            standard       <unset>                 24m
$ kubectl apply -f fetch-dump.yaml
job.batch/dump-demovm created
~/src/demo-kubecon-2026/fetch-dump on   main
 k get po
NAME                         READY   STATUS             RESTARTS       AGE
dump-demovm-qxlk2            1/1     Running            0              3s
virt-launcher-demovm-cqlxh   3/3     Running            0              40m
$ kubectl logs dump-demovm-qxlk2
$ kubectl logs dump-demovm-qxlk2 -f
[*] DUMPED DATA: password=supersecretpassword
password=supersecretpasswordari/537.36
password=supersecretpassword
[*] DUMPED DATA: password=supersecretpassword
"secretpassword"
secretpassword
        if "secretpassword" in post_data:
2026-01-28T07:52:54.560146531Z stdout F [*] DUMPED DATA: password=supersecretpassword
2026-01-28T07:56:53.2489558Z stdout F [*] DUMPED DATA: password=supersecretpassword
[*] DUMPED DATA: password=supersecretpassword
[*] DUMPED DATA: password=supersecretpassword
password=supersecretpassword
[*] DUMPED DATA: password=supersecretpassword
[*] DUMPED DATA: password=supersecretpassword
[*] DUMPED DATA: password=supersecretpassword
```
