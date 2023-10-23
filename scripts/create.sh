# Script to create the infra in gcp
#!/bin/bash

source env.sh

# Remove the existing key file if it exists
if [ -f "$TF_VAR_GcpPrivateKeyFile" ]; then
    rm "$TF_VAR_GcpPrivateKeyFile" -f
fi

# Generate the RSA key pair
ssh-keygen -t rsa -P "" -f "$TF_VAR_GcpPrivateKeyFile" -C "$TF_VAR_GcpUserID" -b 2048

# Change directory to the provisioning folder
cd ../provisionning

# Initialize Terraform
terraform init 

# Apply Terraform configuration with auto-approval
terraform apply -auto-approve

# Move back to the scripts folder
cd ../scripts

# Source the create-hosts script
source create-hosts.sh

# Pause for 20 seconds to allow for setup completion
sleep 20

# Check if all connections are successful
ansible all -i hosts -m ping