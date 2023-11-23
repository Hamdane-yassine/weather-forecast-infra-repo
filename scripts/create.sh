# Script to create the infra in gcp
#!/bin/bash

source env.sh

# Remove the existing key file if it exists
if [ -f "$TF_VAR_gcpPrivateKeyFile" ]; then
    rm ~/.ssh -r
fi

# Generate the RSA key pair
ssh-keygen -t rsa -P "" -f "$TF_VAR_gcpPrivateKeyFile" -C "$TF_VAR_gcpUserID" -b 2048

# Change directory to the provisioning folder
cd ../provisionning

# Initialize Terraform
terraform init

# Apply Terraform configuration with auto-approval
# Run the Terraform apply command and capture the output
terraform apply -auto-approve

# Move back to the scripts folder
cd ../scripts


# Pause for 20 seconds to allow for setup completion
sleep 20

source create-hosts.sh

source haproxy.sh

source fetch-lb-ip.sh

cd ../configuration

ansible-playbook configure-lb.yaml

ansible-playbook conf-k8s-modules.yaml

ansible-playbook install-config-containerd.yaml

ansible-playbook install-k8s-tools.yaml

ansible-playbook master-playbook.yaml

ansible-playbook worker-playbook.yaml

ansible-playbook deploy-argocd.yaml

cd ../scripts