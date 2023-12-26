#!/bin/bash

# Ensure Terraform output is available
if [ -z "$(command -v terraform)" ]; then
    echo "Terraform is not installed or not in PATH."
    exit 1
fi

# Fetch Bastion IP from Terraform output
GATEWAY_IP=$(gcloud compute instances list --filter="name:gateway-server" | grep -v NAME | awk '{ print $5 }')

if [ -z "$GATEWAY_IP" ]; then
    echo "Failed to fetch Bastion IP address."
    exit 1
fi

# Update SSH config
cat > ~/.ssh/config <<EOF
Host gateway-server
    HostName $GATEWAY_IP
    User root
    IdentityFile ~/.ssh/google_compute_engine
    ForwardAgent yes
    StrictHostKeyChecking no

Host 192.168.7.*
    User root
    IdentityFile ~/.ssh/google_compute_engine
    ProxyJump gateway-server
EOF

echo $GATEWAY_IP