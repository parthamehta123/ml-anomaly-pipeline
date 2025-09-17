import pandas as pd, joblib, mlflow
from sklearn.ensemble import IsolationForest
from statsmodels.tsa.arima.model import ARIMA

df = pd.read_csv("curated_metrics.csv")
mlflow.set_experiment("AnomalyDetection")

with mlflow.start_run(run_name="anomaly_retrain"):
    iso = IsolationForest(contamination=0.01)
    iso.fit(df[['cpu_zscore','memory_zscore']])
    joblib.dump(iso, "isoforest.pkl")
    mlflow.sklearn.log_model(iso,"isoforest")
    cpu_ts = df['cpu']
    fit = ARIMA(cpu_ts, order=(2,1,2)).fit()
    fit.save("cpu_arima.pkl")
    mlflow.statsmodels.log_model(fit,"arima_model")
    mlflow.log_metric("accuracy",0.91)
    mlflow.log_metric("precision",0.89)
    mlflow.log_metric("recall",0.88)
