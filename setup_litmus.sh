#https://www.linuxtechi.com/install-minikube-on-rhel-rockylinux-almalinux/
#https://stackoverflow.com/questions/47173463/how-to-access-local-kubernetes-minikube-dashboard-remotely/54960906#54960906

systemctl disable firewalld
systemctl stop firewalld
setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf repolist
dnf install docker-ce docker-ce-cli containerd.io -y

systemctl enable --now docker
usermod -aG docker $USER
newgrp docker

# kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
cp kubectl /usr/local/bin/ && sudo chmod +x /usr/local/bin/kubectl
kubectl version --client


# minikube 
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube

minikube start --driver docker --force
minikube status
minikube ip

kubectl cluster-info
kubectl get nodes

kubectl create deployment test-minikube --image=k8s.gcr.io/echoserver:1.10
kubectl expose deployment test-minikube --type=NodePort --port=8080
kubectl get deployment,pods,svc
minikube service test-minikube --url
 curl $from_above_url
minikube addons list
minikube addons enable dashboard
minikube addons enable ingress
kubectl proxy –address=’0.0.0.0′ –disable-filter=true
minikube dashboard --url
 
#### LITMUS

kubectl apply -f https://litmuschaos.github.io/litmus/litmus-operator-v1.13.8.yaml
kubectl get pods -n litmus

kubectl apply -f https://hub.litmuschaos.io/api/chaos/master?file=faults/kubernetes/container-kill/fault.yaml

## kill pod
kubectl apply -f chaosengine.yaml

# Monitor the Experiment
kubectl describe chaosengine example-chaosengine -n default

