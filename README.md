# jenkins-minikube
Terraform plan to create a simple jenkins instance running in Minikube and using an alternate Docker daemon

-----------------------
Steps to run on Mac (this assumes you have terraform and minikube setup properly).  

1) terraform init
2) terraform apply
3) the jenkins url will be in the output (minikube ip with defined port)
4) To get the jenkins password use : printf $(kubectl get secret --namespace jenkins jenkins -o jsonpath="{.data.jenkins-admin-password}" | base64 --decode);echo
5) login with username admin and previous password
