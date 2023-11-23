#!/bin/bash

## Main variables

# Specify the name of the bucket
export TF_VAR_bucketName="terraform-state-bucket"

# Set the User ID on Google Cloud Platform
export TF_VAR_gcpUserID="root"

# Specify the private key to use for connecting to Google Cloud Platform
export TF_VAR_gcpPrivateKeyFile="$HOME/.ssh/google_compute_engine"

# Specify the public key to use for connecting to Google Cloud Platform
export TF_VAR_gcpPublicKeyFile="$HOME/.ssh/google_compute_engine.pub"

# Define the name of your Google Cloud Platform project
export TF_VAR_project="stdt-project"

# Define the name of the selected Google Cloud Platform region
export TF_VAR_region="europe-west9"

# Define the name of the selected Google Cloud Platform zone
export TF_VAR_zone="europe-west9-a"


### Other variables used by Terraform

# Define the number of workers to be created
export TF_VAR_workersVMSCount=3

# Define the number of masters to be created
export TF_VAR_mastersVMSCount=2

# Specify the type of virtual machine
export TF_VAR_machineType="e2-standard-2"

# Define the prefix of your Google Cloud Platform deployment key
export TF_VAR_deployKeyName="../sdtd-sa.json"
