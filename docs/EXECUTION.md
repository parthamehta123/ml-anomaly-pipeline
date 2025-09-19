# 🚀 Execution Checklist — ML Anomaly Detection Pipeline

This document provides a **step-by-step guide** to execute the pipeline end-to-end, useful for demos, recruiters, or interviews.

---

## ✅ 1. Local Setup

- [ ] Clone the repo:
  ```bash
  git clone https://github.com/parthamehta123/ml-anomaly-pipeline.git
  cd ml-anomaly-pipeline
  ```

- [ ] Create Python environment:
  ```bash
  python3 -m venv venv
  source venv/bin/activate
  pip install -r requirements.txt
  ```

---

## ✅ 2. Test ML Components Locally

- [ ] Generate synthetic dataset:
  ```bash
  python ml/generate_metrics.py
  python ml/preprocess.py
  python ml/train.py
  ```

- [ ] Run Prometheus exporter:
  ```bash
  python ml/prometheus_exporter.py
  # Visit http://localhost:8000/metrics
  ```

- [ ] Start API and test prediction:
  ```bash
  uvicorn api.app:app --reload --port 8080
  curl -X POST http://localhost:8080/predict -H "Content-Type: application/json"        -d '{"cpu_zscore": 2.1, "memory_zscore": 1.5}'
  ```

---

## ✅ 3. Provision Infrastructure (Terraform)

- [ ] Set AWS credentials:
  ```bash
  export AWS_PROFILE=your-profile
  export AWS_REGION=us-east-1
  ```

- [ ] Apply Terraform:
  ```bash
  cd terraform
  terraform init
  terraform apply -auto-approve
  ```

Creates: **VPC, EKS cluster, RDS (MLflow), S3 buckets**.

---

## ✅ 4. Build & Push Docker Images (ECR)

- [ ] Login to ECR:
  ```bash
  aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account_id>.dkr.ecr.us-east-1.amazonaws.com
  ```

- [ ] Build + push:
  ```bash
  docker build -t anomaly-api ./api
  docker tag anomaly-api:latest <account_id>.dkr.ecr.us-east-1.amazonaws.com/anomaly-api:latest
  docker push <account_id>.dkr.ecr.us-east-1.amazonaws.com/anomaly-api:latest
  ```

---

## ✅ 5. Deploy via ArgoCD

- [ ] Apply root app:
  ```bash
  kubectl apply -f gitops/root-app.yaml -n argocd
  ```

Deploys: **MLflow, Anomaly API, Prometheus, Grafana, Auto-remediator**.

---

## ✅ 6. Monitoring & Alerts

- [ ] Port-forward Grafana:
  ```bash
  kubectl port-forward svc/grafana 3000:80 -n monitoring
  ```
  Visit: [http://localhost:3000](http://localhost:3000)

- [ ] Confirm alerts (e.g., CPU > 85% triggers Slack).

---

## ✅ 7. CI/CD Workflow (GitHub Actions)

- [ ] On new MLflow version:
  - Mirror workflow pushes to ECR.
  - Auto-bump `mlflow_version` via PR.
  - Terraform Plan runs on PR.
  - Apply runs on merge.

- [ ] On failure:
  - ❌ Slack/Teams notify.
  - 🔄 Auto-rollback PR merged automatically.
  - ✅ Rollback success message posted.

---

## ✅ 8. Chaos Testing

- [ ] Delete a pod:
  ```bash
  kubectl delete pod <anomaly-api-pod> -n default
  ```

- [ ] Validate flow:
  - Prometheus detects anomaly.
  - Grafana alert fires.
  - Auto-remediator restarts pod.
  - Rollback/retrain triggered if persistent anomaly.

---

## 🎯 Demo Flow

1. Show **Prometheus metrics**.  
2. Kill pod → show **Grafana alert firing**.  
3. Show **Slack alert + rollback message**.  
4. Explain **Terraform auto-bump + rollback flow**.  
5. End with **Grafana dashboard + MLflow UI**.

---

💡 Tip: Use `tmux` or multiple terminals so you can run **kubectl logs**, **terraform output**, and **Slack notifications** side-by-side during the demo.
