# Instructions

```bash
minikube delete
```

```bash
minikube start \
  --cpus=2 \
  --memory=2048 \
  --kubernetes-version="v1.14.0" \
  --vm-driver=virtualbox
```

```bash
kubectl apply -f monitoring-namespace.yaml
```

```bash
kubectl apply -f prometheus-operator-rbac.yaml
kubectl apply -f prometheus-operator-deployment.yaml
kubectl rollout status deployment/prometheus-operator -n monitoring
```

```bash
kubectl apply -f prometheus-rbac.yaml
kubectl apply -f prometheus-server.yaml
kubectl rollout status statefulset/prometheus-k8s -n monitoring
```

```bash
kubectl apply -f prometheus-service.yaml
minikube service prometheus-service -n monitoring
```

```bash
kubectl apply -f hey-deployment.yaml
kubectl rollout status deployment/hey-deployment -n default
```

```bash
kubectl apply -f hey-service.yaml
minikube service hey-service -n default
```

```bash
kubectl apply -f prometheus-servicemonitor.yaml
kubectl apply -f hey-servicemonitor.yaml
kubectl get servicemonitors --all-namespaces
```
