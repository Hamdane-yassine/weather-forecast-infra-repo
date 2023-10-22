#!/bin/sh

cat > hosts <<EOF
[all]
$(gcloud compute instances list | grep -v NAME | awk '{ print $5 }')

[workers]
$(gcloud compute instances list --filter="(tags.items:worker)" | grep -v NAME | awk '{ print $5 }')

[masters]
$(gcloud compute instances list --filter="(tags.items:master)" | grep -v NAME | awk '{ print $5 }')

[all:vars]
ansible_ssh_user=$(printenv GCP_userID)
ansible_ssh_private_key_file=$(printenv GCP_privateKeyFile)
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOF