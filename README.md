# Overview
Example of [Argo-Workflow](https://argoproj.github.io/argo-workflows/) with [Prometheus](https://prometheus.io/) + [Grafana](https://grafana.com/) deployed into [Minikube](https://minikube.sigs.k8s.io/) using [Terraform](https://www.terraform.io/).

# Requirements
- [Kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Argo CLI](https://github.com/argoproj/argo-workflows/releases)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [Terraform CLI](https://www.terraform.io/downloads.html)
- [Makefile](https://en.wikipedia.org/wiki/Make_(software)#Makefile)

# TL;DR
## Run
Start Minikube if not started, deploy all and submit 15 workflows. **Warning**: Re-creates ~/.kube/config
```sh
make start # it's safe to run many times
```
## Play
Open Grafana in default browser. Default username `admin` and password `prom-operator`.
```sh
make grafana
```
Try to search [any default metric](https://argoproj.github.io/argo-workflows/metrics/#default-controller-metrics):
![Screenshot 2021-04-23 at 23 58 17](https://user-images.githubusercontent.com/8834789/115930508-46816e00-a492-11eb-9a2a-43d42508ba28.png)

## Clean
Delete Minikube and Terraform State
```sh
make clean
```

