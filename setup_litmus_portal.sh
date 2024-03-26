# Install Helm
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Add LitmusChaos Helm repository
helm repo add litmuschaos https://litmuschaos.github.io/litmus-helm/
helm repo update
helm repo list
helm list

# Create a namespace for Litmus
kubectl create namespace litmus

# Install Litmus ChaosCenter
helm search repo litmuschaos
helm install chaos litmuschaos/litmus --namespace litmus --debug

kubectl get svc -n litmus
kubectl port-forward service/chaos-litmus-frontend-service  -n litmus 9091:9091
kubectl get all -n litmus

## uninstall helm
helm list --all-namespaces
helm uninstall chaos-center -n litmus
helm uninstall chaos-core -n litmus
