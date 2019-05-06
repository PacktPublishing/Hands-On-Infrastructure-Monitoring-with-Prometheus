# Instructions

```bash
minikube delete
```

```bash
minikube start \
  --cpus=2 \
  --memory=3072 \
  --kubernetes-version="v1.14.0" \
  --vm-driver=virtualbox
```

## Operator

```bash
kubectl apply -f ./operator/bootstrap/
kubectl rollout status deployment/prometheus-operator -n monitoring
```

```bash
kubectl apply -f ./operator/deploy/
kubectl rollout status statefulset/prometheus-k8s -n monitoring
```

```bash
kubectl apply -f ./operator/monitor/
kubectl get servicemonitors --all-namespaces
```

## cAdvisor

```bash
kubectl apply -f ./cadvisor/
kubectl rollout status daemonset/cadvisor -n monitoring
```

## kube-state-metrics

```bash
kubectl apply -f ./kube-state-metrics/
kubectl rollout status deployment/kube-state-metrics -n monitoring
```

## Pushgatewy

```bash
kubectl apply -f ./pushgateway/
kubectl rollout status deployment/pushgateway -n monitoring
```
