#!/bin/bash

source env.sh

cd ../provisionning

terraform destroy -auto-approve

cd ../scripts

rm hosts

cd ../configuration

rm haproxy.cfg

rm lb-ip

cd ../scripts