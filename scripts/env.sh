#!/bin/bash

## Main variables

# Specify the name of the bucket for storing Terraform state
export TF_VAR_bucketName="terraform-state-bucket"

# Set the User ID for SSH connections to instances on Google Cloud Platform
export TF_VAR_gcpUserID="root"

# Specify the path to the private key file for SSH connections to instances
export TF_VAR_gcpPrivateKeyFile="$HOME/.ssh/google_compute_engine"

# Specify the path to the public key file for SSH connections to instances
export TF_VAR_gcpPublicKeyFile="$HOME/.ssh/google_compute_engine.pub"

# Define the ID of your Google Cloud Platform project
export TF_VAR_project="stdt-project"

# Define the ID of the selected Google Cloud Platform region
export TF_VAR_region="europe-west9"

# Define the ID of the selected Google Cloud Platform zone within the region
export TF_VAR_zone="europe-west9-a"

# Define the ID of the OS image to use for instances
export TF_VAR_osImage="ubuntu-os-cloud/ubuntu-2004-lts"

### Other variables used by Terraform

# Define the number of worker instances to be created
export TF_VAR_workersVMSCount=4

# Define the number of master instances to be created
export TF_VAR_mastersVMSCount=2

# Specify the type of virtual machine to use for instances
export TF_VAR_machineType="e2-standard-2"

# Define the path to your Google Cloud Platform service account key file
export TF_VAR_deployKeyName="../sdtd-sa.json"