#Check AKS if running
az aks show --resource-group $teamRG --name akscluster$random --query '[powerState]'

#if not already done
kubectl config get-contexts
kubectl config use-context akscluster$random
#if needed
kubectl config delete-context aksclusterymi6049

#Connect to AKS cluster
az aks get-credentials -g teamResources -n akscluster$random

#Create namespace
cd  ~/OpenHack/OpenHack-MyContainer/yaml
kubectl create -f namespace.yaml
kubectl get namespace
kubectl get ns playground

#Persistent Volume
cd  ~/OpenHack/OpenHack-MyContainer/yaml
kubectl apply -f pv.yaml
# Status = Available
# Note that Volume is NON-namespaced
kubectl get PersistentVolume nfsdata

#Persistent Volume Claim
cd  ~/OpenHack/OpenHack-MyContainer/yaml
kubectl apply -f pvc.yaml
#Bound to volume nfsdata 
# Note that Claim is namespaced    
kubectl -n playground get PersistentVolumeClaim nfsdataclaim

#Create POD
cd  ~/OpenHack/OpenHack-MyContainer/yaml
kubectl apply -f nfs-nginx.yaml
pod=$(kubectl -n playground get pods -o json | jq -r '.items[] | select(.metadata.name | test("nginx-nfs")).metadata.name')
echo $pod
kubectl -n playground exec -it $pod -- /bin/bash
cd /usr/share/nginx/html/web-app
ls
echo "hello test1" > test1.txt
cat test1.txt
cd /usr/share/nginx/html
touch test2.txt
ls
exit

#Terminate and re-create POD
kubectl delete -f nfs-nginx.yaml
kubectl apply -f nfs-nginx.yaml
pod=$(kubectl -n playground get pods -o json | jq -r '.items[] | select(.metadata.name | test("nginx-nfs")).metadata.name')
echo $pod
kubectl -n playground exec -it $pod -- /bin/bash
cat /usr/share/nginx/html/web-app/test1.txt
ls /usr/share/nginx/html/test2.txt
exit

#CleanUp
kubectl delete -f nfs-nginx.yaml
kubectl delete -f pvc.yaml
kubectl delete -f pv.yaml
kubectl delete -f namespace.yaml




