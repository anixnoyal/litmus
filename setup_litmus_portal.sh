#!/bin/bash

systemctl disable firewalld
systemctl stop firewalld
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config


server_name="litmus-portal"
echo "$server_name" | tee /etc/hostname
hostnamectl set-hostname $server_name
exit

dnf install -y git

# Install kubectl
echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
echo "kubectl installed successfully."

# Install Docker
echo "Installing Docker..."
sudo dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf install -y docker-ce --nobest
sudo systemctl start docker
sudo systemctl enable docker
echo "Docker installed successfully."

systemctl enable --now docker
usermod -aG docker $USER
newgrp docker

# Install Minikube
echo "Installing Minikube..."
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -ivh minikube-latest.x86_64.rpm
echo "Minikube installed successfully."


# Start Minikube with Docker driver
echo "Starting Minikube with Docker driver..."

minikube start --docker-env HTTP_PROXY=$HTTP_PROXY --docker-env HTTPS_PROXY=$HTTPS_PROXY --docker-env NO_PROXY=$NO_PROXY --driver=docker  --force


minikube start --driver=docker  --force
minikube logs --file=logs.txt`
minikube status
minikube ip
kubectl cluster-info
kubectl get nodes

# Install Helm
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
echo "Helm installed successfully."

# Add LitmusChaos Helm repository
helm repo add litmuschaos https://litmuschaos.github.io/litmus-helm/
helm repo update
helm repo list
helm list
helm search repo litmuschaos

# Create a namespace for Litmus
kubectl create namespace litmus



helm install chaos litmuschaos/litmus --namespace=litmus --set portal.frontend.service.type=NodePort

# Install Litmus core
helm search repo litmuschaos
helm install chaos-core litmuschaos/litmus-core --namespace litmus --debug

# Install Litmus ChaosCenter
helm search repo litmuschaos
helm install chaos litmuschaos/litmus --namespace litmus --debug
echo "Litmus Chaos Portal installation complete."

kubectl get svc -n litmus
kubectl port-forward svc/litmusportal-frontend-service -n litmus 9091:9091
kubectl get all -n litmus



## uninstall helm
helm list --all-namespaces
helm uninstall chaos-center -n litmus
helm uninstall chaos-core -n litmus

## minikube config reset
minikube stop
minikube delete
docker system prune -a
sudo systemctl restart docker

{
  "proxies": {
    "default": {
      "httpProxy": "http://proxy.example.com:8080",
      "httpsProxy": "http://proxy.example.com:8080",
      "noProxy": "localhost,127.0.0.1,.example.com"
    }
  }
}

