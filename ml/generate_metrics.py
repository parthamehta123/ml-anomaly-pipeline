import pandas as pd, numpy as np, random

def generate_metrics(n=1000, anomaly_ratio=0.02, out_file="metrics.csv"):
    np.random.seed(42)
    cpu = np.random.normal(50, 10, n)
    mem = np.random.normal(60, 15, n)
    disk = np.random.normal(100, 20, n)
    anomalies = np.random.choice(n, int(n*anomaly_ratio), replace=False)
    for i in anomalies:
        cpu[i] = random.uniform(90,100); mem[i]=random.uniform(90,100); disk[i]=random.uniform(200,300)
    df = pd.DataFrame({"cpu": cpu, "memory": mem, "disk_io": disk})
    df.to_csv(out_file, index=False)
    print(f"Generated {n} rows with anomalies -> {out_file}")

if __name__ == "__main__": generate_metrics()
