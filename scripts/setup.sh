# Script to setup main variables
#!/bin/bash

## Main variables

# User ID on GCP
export GCP_userID="hamdaneyassine10"

# Private key to use to connect to GCP
export GCP_privateKeyFile="$HOME/.ssh/google_compute_engine"

# Name of your GCP project
export TF_VAR_project="stdt-project"

# Name of your selected GCP region
export TF_VAR_region="europe-west9"

# Name of your selected GCP zone
export TF_VAR_zone="europe-west9-a"


### Other variables used by Terrform

# Number of VMs created
export TF_VAR_machineCount=3

# VM type
export TF_VAR_machineType="e2-standard-2"

# Prefix for you VM instances
export TF_VAR_instanceName="tf-instance"

# Prefix of your GCP deployment key
export TF_VAR_deployKeyName="sdtd-sa.json"
