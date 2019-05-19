# Instructions

```bash
minikube delete
```

```bash
minikube start \
  --cpus=2 \
  --memory=3072 \
  --kubernetes-version="v1.14.0" \
  --vm-driver=virtualbox \
  --extra-config=kubelet.authentication-token-webhook=true \
  --extra-config=kubelet.authorization-mode=Webhook
```

  * `--authentication-token-webhook=true`: Enables a ServiceAccount token to authenticate against the kubelets
  * `--authorization-mode=Webhook`: Enables the kubelet to perform an RBAC request to the API to validate if Prometheus is allowed to access a resource


```bash
kubectl apply -f ./bootstrap/
kubectl rollout status deployment/prometheus-deployment -n monitoring 
```

```bash
kubectl apply -f ./services/
kubectl rollout status deployment/hey-deployment -n default
```
