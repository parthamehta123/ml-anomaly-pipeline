import pandas as pd

def preprocess(file_path="metrics.csv"):
    df = pd.read_csv(file_path)
    df['cpu_zscore'] = (df['cpu']-df['cpu'].mean())/df['cpu'].std()
    df['memory_zscore'] = (df['memory']-df['memory'].mean())/df['memory'].std()
    df.to_csv("curated_metrics.csv", index=False)

if __name__ == "__main__": preprocess()