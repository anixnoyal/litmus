#### litmus infra operator 

kubectl apply -f https://litmuschaos.github.io/litmus/litmus-operator-v1.13.8.yaml
kubectl get pods -n litmus

kubectl apply -f https://hub.litmuschaos.io/api/chaos/master?file=faults/kubernetes/container-kill/fault.yaml

## kill pod
kubectl apply -f chaosengine.yaml

# Monitor the Experiment
kubectl describe chaosengine example-chaosengine -n default
