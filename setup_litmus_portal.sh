#!/bin/bash

systemctl disable firewalld
systemctl stop firewalld
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config


server_name="litmus-portal"
echo "$server_name" | tee /etc/hostname
hostnamectl set-hostname $server_name
exit

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
minikube start --driver=docker  -force
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

# Create a namespace for Litmus
kubectl create namespace litmus

# Install Litmus ChaosCenter

helm search repo litmuschaos
helm install chaos litmuschaos/litmus -namespace litmus --create-namespace
echo "Litmus Chaos Portal installation complete."

kubectl get svc -n litmus
kubectl port-forward svc/litmusportal-frontend-service -n litmus 9091:9091
kubectl get all -n litmus



## minikube config reset
minikube stop
minikube delete
docker system prune -a
sudo systemctl restart docker
