#!/bin/bash

# Set the Kubernetes namespace where Prometheus and Grafana will be installed
NAMESPACE="monitoring"

# Create the namespace
echo "Creating namespace $NAMESPACE..."
kubectl create namespace $NAMESPACE

# Before starting, we need to install Helm
echo "Installing Helm..."
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Add helm repo for Prometheus
echo "Adding Helm repo for Prometheus..."
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Update Helm repo
echo "Updating Helm repo..."
helm repo update

# Install Prometheus using Helm
echo "Installing Prometheus..."
helm install kube-prometheus-stack prometheus-community/kube-prometheus-stack --namespace $NAMESPACE

# Wait for Prometheus to be ready
echo "Waiting for Prometheus to be ready..."
kubectl wait --for=condition=ready pod -l app=prometheus -n $NAMESPACE

# Check grafana address and port
kubectl logs -n $NAMESPACE deployment/kube-prometheus-stack-grafana -c grafana | grep "address:"

# forward grafana port
kubectl port-forward -n $NAMESPACE deployment/kube-prometheus-stack-grafana 3000

# forward prometheus port
kubectl port-forward -n $NAMESPACE deployment/kube-prometheus-stack-prometheus 9090


# ------------------- Grafana ------------------- #
# # Get the Grafana admin password
# echo "Getting Grafana admin password..."
# kubectl get secret --namespace $NAMESPACE grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# # Get the Grafana service URL
# echo "Getting Grafana service URL..."
# kubectl get svc --namespace $NAMESPACE grafana -o jsonpath="{.status.loadBalancer.ingress[0].ip}" ; echo
