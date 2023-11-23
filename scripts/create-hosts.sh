#!/bin/sh

# Fetch all instances
all_instances=$(gcloud compute instances list | grep -v NAME | awk '{ print $5 }')

# Fetch worker instances
worker_instances=$(gcloud compute instances list --filter="(tags.items:worker)" | grep -v NAME | awk '{ print $5 }')

# Fetch master instances
master_instances=$(gcloud compute instances list --filter="(tags.items:master)" | grep -v NAME | awk '{ print $5 }')

# Fetch load balancer instance
load_balancer_instance=$(gcloud compute instances list --filter="name:load-balancer-1" | grep -v NAME | awk '{ print $5 }')

# Determine the first master (assuming the first one in the list)
first_master=$(echo "$master_instances" | head -n 1)

# Determine other masters (excluding the first one)
other_masters=$(echo "$master_instances" | grep -v "$first_master")

# Exclude load balancer from all instances
all_without_load_balancer=$(echo "$all_instances" | grep -v "$load_balancer_instance")

cat > hosts <<EOF
[lb]
$load_balancer_instance

[nodes]
$all_without_load_balancer

[workers]
$worker_instances

[firstMaster]
$first_master

[otherMasters]
$other_masters

[all:vars]
ansible_ssh_user=$(printenv TF_VAR_gcpUserID)
ansible_ssh_private_key_file=$(printenv TF_VAR_gcpPrivateKeyFile)
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF