# 🧪 ML Anomaly Pipeline Chaos Test + Deployment Runbook

This runbook demonstrates how to **deploy and validate the full pipeline** — from infrastructure bring-up → anomaly detection → chaos injection → alerts → remediation.

---

## 0. 📦 Prerequisites

- AWS account with permissions for:  
  - EKS, S3, RDS, IAM, Step Functions, Lambda, FIS  
- Local tools installed:  
  - `terraform`, `kubectl`, `awscli`, `argocd`, `helm`  
- Repo cloned:  
  ```bash
  git clone https://github.com/parthamehta123/ml-anomaly-pipeline.git
  cd ml-anomaly-pipeline
  ```

---

## 1. ☁️ Deploy Infra with Terraform

```bash
cd terraform
terraform init
terraform apply
```

This provisions:  
- EKS cluster  
- S3 bucket for metrics & models  
- RDS Postgres for MLflow  
- IAM roles for Prometheus, Grafana, Lambda, Step Functions  

Validate:  
```bash
aws eks update-kubeconfig --name ml-anomaly-eks
kubectl get nodes
```

---

## 2. 🚀 Deploy Apps with ArgoCD

Apply the **root app**:  
```bash
kubectl apply -f gitops/root-app.yaml -n argocd
```

ArgoCD will deploy:  
- Prometheus (`monitoring` ns)  
- Grafana (`monitoring` ns)  
- MLflow (`mlflow` ns)  
- Anomaly API (`ml` ns)  
- Remediation Operator (`ml` ns)  

Validate:  
```bash
kubectl get applications -n argocd
kubectl get pods -n monitoring
kubectl get pods -n mlflow
kubectl get pods -n ml
```

---

## 3. 📊 Validate Services

- **Prometheus**:
  ```bash
  kubectl port-forward svc/prometheus-kube-prometheus-prometheus 9090:9090 -n monitoring
  open http://localhost:9090
  ```

- **Grafana**:
  ```bash
  kubectl port-forward svc/grafana 3000:80 -n monitoring
  open http://localhost:3000
  ```

- **Anomaly API**:
  ```bash
  kubectl port-forward svc/anomaly-api 8080:80 -n ml
  curl -X POST http://localhost:8080/predict     -H "Content-Type: application/json"     -d '{"cpu_zscore": 2.1, "memory_zscore": 1.5}'
  ```

Expected output:
```json
{"anomaly": false, "score": 0.07, "forecast": 49.7}
```

---

## 4. 🔥 Inject Chaos

### Option A: Kubernetes Chaos Mesh
```bash
kubectl apply -f k8s/chaos-pod-kill.yaml -n ml
```
👉 Kills one `anomaly-api` pod for 60s every 5 minutes.  

### Option B: AWS FIS
```bash
terraform apply -target=aws_fis_experiment_template.cpu_stress
aws fis start-experiment --experiment-template-id <template-id>
```
👉 Stresses worker nodes for 2 minutes.  

---

## 5. 🚨 Observe Alerts

- Grafana dashboards:
  - **Anomaly Detection** (CPU/memory/disk IO z-scores)  
  - **Locust Load Test** (req/sec, latency, failures)  

- Alerts expected:
  - High CPU (>85% for 1m)  
  - High error rate (>5% for 2m)  
  - `anomaly=true` from model  

Alerts routed to **Slack / PagerDuty**.  

---

## 6. 🔄 Auto-Remediation

- **K8s Operator** → reschedules pods on failures  
- **Lambda + Step Functions** → retraining pipeline:
  - Champion vs Challenger comparison  
  - MLflow logs validation  
  - Deploys new model if better  

---

## 7. ✅ Validate Recovery

- Check pod health:
  ```bash
  kubectl get pods -n ml
  ```
- Confirm alerts clear in Grafana.  
- Verify retraining in MLflow dashboard.  

---

## 8. 📝 Summary

- **Terraform** provisioned infra  
- **ArgoCD** deployed ML + monitoring stack  
- **Prometheus/Grafana** observed anomalies  
- **Chaos Mesh/FIS** injected failures  
- **Anomaly detector** flagged spikes  
- **Alerts** fired → Slack/PagerDuty  
- **Auto-remediation** rescheduled pods + retrained models  
- Pipeline self-healed end-to-end 🚀  
