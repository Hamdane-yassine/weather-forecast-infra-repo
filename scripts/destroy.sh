#!/bin/bash

source env.sh

cd ../provisionning

terraform destroy -auto-approve

rm backend.tf -f

cd ../scripts