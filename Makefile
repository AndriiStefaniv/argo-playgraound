help: ## Show this help
	@egrep -h '\s##\s' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-30s\033[0m %s\n", $$1, $$2}'

start: ## Start Minikube if not started, deploy all and submit 15 workflows. Warning: Re-creates ~/.kube/config
	minikube status || minikube start
	terraform init
	terraform apply -auto-approve
	for i in {0..14}; do \
		argo submit -n argo https://raw.githubusercontent.com/argoproj/argo-workflows/master/examples/hello-world.yaml --serviceaccount argo; \
	done
	argo submit -n argo --watch https://raw.githubusercontent.com/argoproj/argo-workflows/master/examples/hello-world.yaml --serviceaccount argo
	argo delete -n argo --prefix hello-world

grafana:  ## Open Grafana in default browser
	echo "username 'admin' and password 'prom-operator'"
	minikube service prometheus-grafana -n monitoring

clean: ## Delete Minikube and Terraform State
	minikube delete
	rm -rf .terraform* terraform*
