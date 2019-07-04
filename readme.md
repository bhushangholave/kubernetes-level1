
Prerequisites:- 
1. Install terraform 
2. Install kubectl
3. Install gcloud
4. Create project on google cloud
5. Create service account and activate using command
    gcloud auth activate-service-account --key-file=$("/create-gcp-cluster/creads/serviceaccount.json")
6. run level1.sh script
7. if required install helm and add service account

Run level1.sh script
./level1.sh

In the context of test:
What was the node size chosen for the Kubernetes nodes? And why?
-> chosen node size for nodes g1-small as I am going to deploy guest-book application which requires cpu: 100m memory: 100Mi for each pod and each deployment in staging and production namespace.
-> we can take f1-micro but with this autoscaling can fail with insufficient memory because f1.micro has only 0.6 GB of memory 

What method was chosen to install the demo application and ingress controller on the cluster, justify the method used
-> chose Kubectl commands to install application and ingress on cluster
-> can use Helm and install application and ingress as well
-> For Helm we need to create service account and need to maintain tiller version which I face during my current development and there are development happening for tiller less helm but for now I would really want to stick with kubectl
reference
https://medium.com/virtuslab/think-twice-before-using-helm-25fbb18bc822


What would be your chosen solution to monitor the application on the cluster and why?
If we want standard monitoring-> 
-> Prometheus is one of the most popular monitoring tools used with Kubernetes. It's community-driven and a member of the Cloud Native Computing Foundation. This project, developed first by SoundCloud and afterward donated to the CNCF, is inspired by Google Borg Monitor.

-> Prometheus stores all its data as a time series. This data can be queried via the PromQL query language and visualized with a built-in expression browser. Since Prometheus is not a dashboard, it relies on Grafana for visualizing data.

If we want each container logs monitoring more details- Dynatrace


What additional components / plugins would you install on the cluster to manage it better? 

Deployment - kubespray
https://github.com/kubernetes-incubator/kubespray

Monitoring - Dynatrace
https://github.com/Dynatrace/dynatrace-oneagent-operator

Testing - kube-monkey
https://github.com/asobti/kube-monkey

Security - Kubesec.io
https://kubesec.io

Development - Helm
https://github.com/kubernetes/helm





