#!/bin/bash

source env.sh

cd ../provisionning

terraform destroy -auto-approve

cd ../scripts

rm hosts

cd ../configuration

rm haproxy.cfg

rm lb-ip

rm argocd-pwd

rm admin.conf

rm k8s_join_info.yml

cd ../scripts