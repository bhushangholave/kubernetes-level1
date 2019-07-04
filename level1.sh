#!/bin/bash

set -e


cd "$(dirname "$0")"
BASEDIR=$(dirname "$0")
gcpclusterscript= ${BASEDIR}/01-create-gcp-cluster/run.sh
# create gke cluster
sh ${gcpclusterscript}

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.24.1/deploy/mandatory.yaml 

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/nginx-0.24.1/deploy/provider/cloud-generic.yaml 

#see load balancer created 
kubectl get services -o wide ingress-nginx --namespace=ingress-nginx

# create namespace staging and production
kubectl create namespace staging

kubectl create namespace production

#deploy guest book application
kubectl apply -f ${BASEDIR}/guest-book/all-in-one-staging.yml --namespace=staging

kubectl apply -f ${BASEDIR}/guest-book/all-in-one-staging.yml --namespace=production

Expose frontend services as type=LoadBalancer
kubectl expose deployment frontend --type=LoadBalancer --name=frontend-staging --namespace=staging

kubectl expose deployment frontend --type=LoadBalancer --name=frontend-production --namespace=production

#Ingress resource for services exposed staging and production
kubectl apply -f ${BASEDIR}/assing-DNS/ingress.yml



# activate auto-scaler for autoscaling on cpu-percentage=50%
kubectl autoscale deployment frontend --cpu-percent=20 --min=1 --max=10 --namespace=staging

kubectl autoscale deployment frontend --cpu-percent=20 --min=1 --max=10 --namespace=production


# block to check auto-scaler in production cluster

kubectl run --namespace=staging load-generator --image=busybox /bin/sh -- '-c' 'while true; do wget -q -O- http://frontend.staging.svc.cluster.local; done';
kubectl get hpa --namespace=staging

kubectl get deployment frontend --namespace=staging


# block to check auto-scaler in production cluster
kubectl run --namespace=production load-generator --image=busybox /bin/sh -- '-c' 'while true; do wget -q -O- http://frontend.production.svc.cluster.local; done';

kubectl get hpa --namespace=production

kubectl get deployment frontend --namespace=production



