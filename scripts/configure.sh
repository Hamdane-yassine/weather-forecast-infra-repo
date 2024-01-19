#!/bin/bash

cd /tmp/scripts

source env.sh

source generate-ips.sh

source create-hosts.sh

source haproxy.sh

source fetch-lb-ip.sh

cd /tmp/configuration

mkdir etcd 2> /dev/null

ansible-playbook configure-lb.yaml

ansible-playbook conf-k8s-modules.yaml

ansible-playbook install-config-containerd.yaml

ansible-playbook install-k8s-tools.yaml

ansible-playbook master-playbook.yaml

ansible-playbook worker-playbook.yaml

ansible-playbook deploy-argocd.yaml

ansible-playbook helm-prometheus-grafana.yaml

ansible-playbook update-lb-ports.yaml

cd /tmp