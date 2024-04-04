#INGRESS NGINX
https://kubernetes.github.io/ingress-nginx/deploy/
#install ngnix ingress POD
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml
kubectl get pods --namespace=ingress-nginx
kubectl describe Ingressclasses nginx
#Check out Ingress Controller service and public IP (AKS/Services and Ingress/Services)
kubectl get service ingress-nginx-controller --namespace=ingress-nginx

#Create tripviewer ingress ,please wait for external address
#(AKS/Services and Ingress/Ingresses)
cd  ~/OpenHack/OpenHack-MyContainer/yaml
kubectl apply -f ingress-nginx.yaml
kubectl get ingress --watch
kubectl describe ingress nginx-ingress-tripviewer
INGRESSIP=$(kubectl get ingress -o jsonpath='{ .items[].status.loadBalancer.ingress[].ip }')
echo $INGRESSIP

#ok
curl http://$INGRESSIP
curl http://$INGRESSIP/UserProfile
curl http://$INGRESSIP/Trip
#ok
curl http://$INGRESSIP/api/trips/healthcheck
curl http://$INGRESSIP/api/poi/healthcheck
curl http://$INGRESSIP/api/user-java/healthcheck
#ok
curl http://$INGRESSIP/api/user/
curl http://$INGRESSIP/api/user
curl http://$INGRESSIP/api/trips
#ko
curl http://$INGRESSIP/api/trips/


#CleanUp deploy
kubectl delete -f ingress-nginx.yaml
kubectl delete -f tripviewer.yaml
kubectl delete -f poi.yaml
kubectl delete -f user-java.yaml
kubectl delete -f userprofile.yaml
kubectl delete -f trips.yaml
kubectl delete -f secret.yaml

#Create namespace
cd ~/OpenHack/OpenHack-MyContainer/yaml
kubectl create -f namespace.yaml
kubectl get namespace

#Create tripviewer ingress in namespace ,please wait for external address
kubectl apply -f tripviewer2.yaml
kubectl apply -f ingress-nginx2.yaml
kubectl -n playground get ingress --watch
INGRESSIP=$(kubectl -n playground get ingress -o jsonpath='{ .items[].status.loadBalancer.ingress[].ip }')
echo $INGRESSIP
curl http://$INGRESSIP

#CleanUp Tripviewer2
kubectl delete -f tripviewer2.yaml
kubectl delete -f ingress-nginx2.yaml
kubectl delete -f namespace.yaml

#CleanUp Ingress Controller
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.5.1/deploy/static/provider/cloud/deploy.yaml
#aks --> Custom Resources --> NginxIngressController --> delete
#or
kubectl delete ns ingress-nginx