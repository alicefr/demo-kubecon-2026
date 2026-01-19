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
