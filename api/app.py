import joblib
from fastapi import FastAPI
from pydantic import BaseModel
import os

BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

# Load models (make sure you trained them first!)
iso = joblib.load(os.path.join(BASE_DIR, "isoforest.pkl"))
arima = joblib.load(os.path.join(BASE_DIR, "cpu_arima.pkl"))

app = FastAPI()

class Features(BaseModel):
    cpu_zscore: float
    memory_zscore: float

@app.post("/predict")
def predict(features: Features):
    # Example inference using Isolation Forest
    X = [[features.cpu_zscore, features.memory_zscore]]
    anomaly_score = iso.decision_function(X)[0]
    is_anomaly = iso.predict(X)[0] == -1

    # Example ARIMA forecast
    forecast = arima.forecast(steps=1).iloc[0]

    return {
        "anomaly": bool(is_anomaly),
        "score": float(anomaly_score),
        "forecast": float(forecast)
    }
