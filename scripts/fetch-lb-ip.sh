#!/bin/bash

# Create or clear the file
cat > ../configuration/lb-ip <<EOF
$(gcloud compute instances list --filter="name:load-balancer-1" | grep -v NAME | awk '{ print $5 }'):6443
EOF

