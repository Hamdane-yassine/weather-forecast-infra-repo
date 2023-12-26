#!/bin/sh

# Fetch worker instances
worker_instances=$(gcloud compute instances list --filter="(tags.items:worker)" | grep -v NAME | awk '{ print $4 }')

# Fetch master instances
master_instances=$(gcloud compute instances list --filter="(tags.items:master)" | grep -v NAME | awk '{ print $4 }')

# Fetch load balancer instance
gateway_server_instance=$(gcloud compute instances list --filter="name:gateway-server" | grep -v NAME | awk '{ print $4 }')

# Determine the first master (assuming the first one in the list)
first_master=$(echo "$master_instances" | head -n 1)

# Determine other masters (excluding the first one)
other_masters=$(echo "$master_instances" | grep -v "$first_master")

cat > hosts <<EOF
[gateway]
$gateway_server_instance

[nodes]
$worker_instances
$first_master
$other_masters

[workers]
$worker_instances

[firstMaster]
$first_master

[otherMasters]
$other_masters

[all:vars]
ansible_ssh_user=$(printenv TF_VAR_gcpUserID)
ansible_ssh_private_key_file=/tmp/google_compute_engine
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF