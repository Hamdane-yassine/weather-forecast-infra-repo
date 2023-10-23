# Script to setup main variables
#!/bin/bash

## Main variables

# User ID on GCP
export GCP_userID="root"

# Private key to use to connect to GCP
export GCP_privateKeyFile="$HOME/.ssh/google_compute_engine"

# Name of your GCP project
export TF_VAR_project="stdt-project"

# Name of your selected GCP region
export TF_VAR_region="europe-west9"

# Name of your selected GCP zone
export TF_VAR_zone="europe-west9-a"


### Other variables used by Terrform

# Number of Workers created
export TF_VAR_workersVMSCount=2

# Number of Masters created
export TF_VAR_mastersVMSCount=1

# VM type
export TF_VAR_machineType="e2-standard-2"

# Prefix for you VM instances
export TF_VAR_instanceName="tf-instance"

# Prefix of your GCP deployment key
export TF_VAR_deployKeyName="../sdtd-sa.json"

# Remove the existing key file if it exists
if [ -f "$GCP_privateKeyFile" ]; then
    rm "$GCP_privateKeyFile" -f
fi

# Generate the RSA key pair
ssh-keygen -t rsa -P "" -f "$GCP_privateKeyFile" -C "$GCP_userID" -b 2048

cd ../provisionning

terraform init 

terraform apply -auto-approve

cd ../scripts

source create-hosts.sh

sleep 20

# just to check if everything is good
ansible all -i hosts -m ping
