#!/bin/bash

# Parse output.json
output=$(cat output.json)

# Fetch load balancer instance
gateway_server_instance=$(echo "$output" | jq -r '.gateway_ip')

# Create or clear the file
cat > ../configuration/lb-ip <<EOF
$gateway_server_instance:6443
EOF