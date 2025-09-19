# 🎤 Demo Script — ML Anomaly Detection Pipeline

This is a guided demo script showing **what to say** and **what to do** at each step when presenting the project.

---

## 1. Intro (Set the Stage)
**Say:**  
> “This project demonstrates how I can bring together machine learning, observability, and cloud automation into a production-grade anomaly detection pipeline. It predicts failures, auto-remediates issues, and even rolls back infrastructure changes automatically if something goes wrong.”  

**Show:**  
- Repo README badges (Terraform, MLflow, Build passing).  
- Highlight **Features** section briefly.  

---

## 2. Local ML Demo
**Say:**  
> “First, I can run the ML logic locally. We simulate infrastructure metrics, preprocess them, and train an Isolation Forest + ARIMA hybrid model for anomaly detection.”  

**Do:**  
```bash
python ml/generate_metrics.py
python ml/train.py
uvicorn api.app:app --reload --port 8080
```
- Show API response from `curl`.  
- Emphasize: “This same model is what we’ll deploy on Kubernetes.”  

---

## 3. Terraform Infra
**Say:**  
> “Now let’s bring up the cloud infra with Terraform. It provisions EKS, RDS for MLflow, and S3 for model artifacts. All fully IaC-driven.”  

**Do:**  
```bash
cd terraform
terraform apply -auto-approve
```
- Show resources in AWS Console (EKS cluster, S3, RDS).  
- Emphasize: “Everything is reproducible, idempotent, and managed as code.”  

---

## 4. Docker + ECR
**Say:**  
> “The anomaly detection API is containerized. We push it into ECR for Kubernetes to pull securely.”  

**Do:**  
```bash
docker build -t anomaly-api ./api
docker push <ECR_URI>/anomaly-api:latest
```

---

## 5. Deploy with ArgoCD
**Say:**  
> “Now we deploy via GitOps. ArgoCD syncs the MLflow server, anomaly API, and monitoring stack.”  

**Do:**  
```bash
kubectl apply -f gitops/root-app.yaml -n argocd
```
- Open ArgoCD UI, show apps syncing.  

---

## 6. Monitoring & Alerts
**Say:**  
> “Prometheus scrapes metrics every 5s. Grafana dashboards visualize them, and alerts integrate with Slack.”  

**Do:**  
```bash
kubectl port-forward svc/grafana 3000:80 -n monitoring
```
- Show Grafana dashboard.  
- Emphasize Slack alert integration.  

---

## 7. Chaos Test
**Say:**  
> “Let’s simulate a pod crash. Watch how the pipeline detects anomalies, fires an alert, and remediates.”  

**Do:**  
```bash
kubectl delete pod <anomaly-api-pod> -n default
```
- Show Grafana alert firing.  
- Show Slack alert.  
- Show pod restarting automatically.  

---

## 8. CI/CD + Rollback
**Say:**  
> “The CI/CD workflow auto-bumps MLflow versions and applies Terraform. If apply fails, it opens a rollback PR, auto-merges it, and posts success back to Slack and Teams.”  

**Show:**  
- Mermaid diagram in README.  
- GitHub Actions logs (bump PR, rollback job).  
- Slack rollback notification.  

---

## 9. Closing
**Say:**  
> “This project brings together MLOps, SRE automation, and GitOps best practices. It shows I can design resilient AI-driven infrastructure that scales, self-heals, and reduces SRE toil.”  

---

⚡ **Pro-tip for delivery:**  
- Keep each section ~2 minutes.  
- Show a terminal window + browser side-by-side (Grafana/ArgoCD).  
- Use Slack on-screen for alerts.  
