all: train build deploy

train:
	python ml/train.py

build:
	docker build -t anomaly-api ./api

deploy:
	helml upgrade --install anomaly-api ./k8s/helm
