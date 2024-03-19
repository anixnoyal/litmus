#https://www.linuxtechi.com/install-minikube-on-rhel-rockylinux-almalinux/

dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf repolist
dnf install docker-ce docker-ce-cli containerd.io -y

systemctl start docker
usermod -aG docker $USER
newgrp docker
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
cp kubectl /usr/local/bin/ && sudo chmod +x /usr/local/bin/kubectl
kubectl version --client


# minikube 
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube

minikube start --driver docker --force
minikube status
minikube ip

#### LITMUS

kubectl apply -f https://litmuschaos.github.io/litmus/litmus-operator-v1.13.8.yaml
kubectl get pods -n litmus
kubectl apply -f https://hub.litmuschaos.io/api/chaos/1.13.8?file=charts/generic/experiments.yaml
