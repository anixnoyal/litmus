#https://www.linuxtechi.com/install-minikube-on-rhel-rockylinux-almalinux/
#https://stackoverflow.com/questions/47173463/how-to-access-local-kubernetes-minikube-dashboard-remotely/54960906#54960906

systemctl disable firewalld
systemctl stop firewalld
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

# docker
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf repolist
dnf install docker-ce docker-ce-cli containerd.io -y

usermod -aG docker $USER
newgrp docker
systemctl enable --now docker

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl
mv ./kubectl /usr/local/bin/kubectl
kubectl version --client

# minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-latest.x86_64.rpm
sudo rpm -ivh minikube-latest.x86_64.rpm

minikube start --driver=docker  --force

minikube status
minikube ip

kubectl cluster-info
kubectl get nodes

## minikube config reset
minikube stop
minikube delete
docker system prune -a
sudo systemctl restart docker
