# Script to create the infra in gcp
#!/bin/bash

source env.sh

# Remove the existing key file if it exists
if [ -f "$TF_VAR_gcpPrivateKeyFile" ]; then
    rm "$TF_VAR_gcpPrivateKeyFile" -f
fi

# Generate the RSA key pair
ssh-keygen -t rsa -P "" -f "$TF_VAR_gcpPrivateKeyFile" -C "$TF_VAR_gcpUserID" -b 2048

# Change directory to the provisioning folder
cd ../provisionning

if gcloud storage ls | grep -q "bucket-tfstate"; then
cat <<EOF > backend.tf
terraform {
  backend "gcs" {
    bucket  = "bucket-tfstate"
    prefix  = "terraform/state"
  }
}
EOF
terraform init -force-copy
terraform apply -auto-approve
else

# Initialize Terraform
terraform init 

# Apply Terraform configuration with auto-approval
# Run the Terraform apply command and capture the output
terraform apply -auto-approve

# Create the backend.tf file with the extracted bucketName
cat <<EOF > backend.tf
terraform {
  backend "gcs" {
    bucket  = "bucket-tfstate"
    prefix  = "terraform/state"
  }
}
EOF

terraform init -force-copy
fi
# Move back to the scripts folder
cd ../scripts

# Source the create-hosts script
source create-hosts.sh

# Pause for 20 seconds to allow for setup completion
sleep 20

# Check if all connections are successful
ansible all -i hosts -m ping