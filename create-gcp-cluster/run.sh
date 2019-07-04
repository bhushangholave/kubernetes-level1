#!/bin/bash
cd "$(dirname "$0")"

terraform init
terraform plan
terraform apply
gcloud container clusters get-credentials $(terraform output cluster_name) --zone $(terraform output cluster_zone)