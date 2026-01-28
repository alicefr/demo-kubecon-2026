## Build
```bash
$ podman build --network host -t demo:kubecon2026 .
```
## Run
```bash
$ podman run --name demo -td -p 8080:80 localhost/demo:kubecon2026 
```

Credentials:
```
user=demoUser
password=demopassword
```

## Expose service and create a password

```console
./export-app.sh 
Service app-api successfully created for virtualmachine demovm
App avilable at 172.19.0.2:31492

curl -X POST -d "password=supersecretpassword" 172.19.0.2:31492
```
