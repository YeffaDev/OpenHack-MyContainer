#Loadbalancer (yaml)
#When you create a LoadBalancer-type Service, you also create an underlying Azure load balancer resource. The load balancer is configured to distribute traffic to the pods in your Service on a given port.
#Cloud Load Balancer provide externally accessible IP address that sends traffic to the correct port on your cluster nodes

apiVersion: v1
kind: Service
metadata:
  name: tripviewer-service-lb
spec:
  selector:
    app: tripviewer
  ports:
    - port: 8765
      targetPort: 80
  type: LoadBalancer

#LoadBalancer Cluster-IP,External-IP,Endpoint(tripviewer pod)
kubectl apply -f loadbalancer.yaml
kubectl get svc tripviewer-service-lb
kubectl describe services tripviewer-service-lb
kubectl get pod -o wide

#Loadbalancer imperative
kubectl expose deployment tripviewer --port=8765 --target-port=80 \
        --name=tripviewer-service-lb --type=LoadBalancer
kubectl delete service tripviewer-service-lb

#Stop AKS
az aks stop --name akscluster$random --resource-group teamResources