#!/bin/bash

# Set the name and namespace for your Kubernetes sandbox
SANDBOX_NAME="my-sandbox"
NAMESPACE="k8s-sandbox"

# Build the Docker image for your application
docker build -t k8s-sandbox .

# Tag the Docker image for use with Kubernetes
docker tag k8s-sandbox aus10va/k8s-sandbox:latest

# Push the Docker image to your Docker registry
docker push aus10va/k8s-sandbox:latest

# Create the Kubernetes namespace
kubectl create namespace $NAMESPACE

# Deploy your application to Kubernetes
kubectl apply -f deployment.yaml -n $NAMESPACE

# Expose your application to the outside world
kubectl expose deployment k8s-sandbox --type=LoadBalancer --port=80 --target-port=8080 -n $NAMESPACE

# Wait for the LoadBalancer IP address to be assigned
while true; do
  LB_IP=$(kubectl get svc k8s-sandbox -n $NAMESPACE -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
  if [[ ! -z "$LB_IP" ]]; then
    break
  fi
  sleep 10
done

# Print the URL for accessing your application
echo "Your application is now available at http://$LB_IP"
