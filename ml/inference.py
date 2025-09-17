import pandas as pd, joblib
from statsmodels.tsa.arima.model import ARIMAResults

iso = joblib.load("isoforest.pkl")
arima = ARIMAResults.load("cpu_arima.pkl")

def predict(metrics:dict):
    df=pd.DataFrame([metrics])
    anomaly=iso.predict(df[['cpu_zscore','memory_zscore']])[0]==-1
    forecast=arima.forecast(steps=1)[0]
    return {"anomaly":bool(anomaly),"forecast_cpu":float(forecast)}
