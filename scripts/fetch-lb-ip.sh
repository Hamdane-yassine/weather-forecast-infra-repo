#!/bin/bash

# Create or clear the file
cat > ../configuration/lb-ip <<EOF
$(gcloud compute instances list --filter="name:gateway-server" | grep -v NAME | awk '{ print $4 }'):6443
EOF

