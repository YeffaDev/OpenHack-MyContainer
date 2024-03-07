#INGRESS NGINX
https://kubernetes.github.io/ingress-nginx/deploy/
#install ngnix ingress container
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml
kubectl get service ingress-nginx-controller --namespace=ingress-nginx
kubectl get pods --namespace=ingress-nginx
kubectl describe Ingressclasses nginx
#Get ingress EXTERNAL-IP
kubectl get service ingress-nginx-controller --namespace=ingress-nginx
#Create tripviewer ingress,wait for external address
kubectl apply -f ingress-nginx.yaml
kubectl get ingress --watch
kubectl describe ingress nginx-ingress-tripviewer
INGRESSIP=$(kubectl get ingress -o jsonpath='{ .items[].status.loadBalancer.ingress[].ip }')
curl http://$INGRESSIP
curl http://$INGRESSIP/Trip
curl http://$INGRESSIP/UserProfile
curl http://$INGRESSIP/api/trips/healthcheck
curl http://$INGRESSIP/api/poi/healthcheck
curl http://$INGRESSIP/api/user-java/healthcheck
curl http://$INGRESSIP/api/user

#Cleanup
kubectl delete -f ingress-nginx.yaml
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml
#aks --> Custom Resources --> NginxIngressController --> delete
#or
kubectl delete ns ingress-nginx