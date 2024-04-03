#Loadbalancer (yaml)
#When you create a LoadBalancer-type Service, you also create an underlying Azure load balancer resource. The load balancer is configured to distribute traffic to the pods in your Service on a given port.
#Cloud Load Balancer provide externally accessible IP address that sends traffic to the correct port on your cluster nodes

#loadbalancer.yaml
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

#LoadBalancer service expose port 8765
cd ~/OpenHack/OpenHack-MyContainer/yaml
kubectl apply -f loadbalancer.yaml
#get external IP
kubectl get svc tripviewer-service-lb
kubectl describe services tripviewer-service-lb
#select "app=tripviewer" POD
kubectl get pod -o wide --show-labels

#Other users should able to reach the public IP
#http://13.93.238.215:8765/
curl http://13.93.238.215:8765/

#Loadbalancer imperative
kubectl expose deployment tripviewer --port=8765 --target-port=80 \
        --name=tripviewer-service-lb --type=LoadBalancer

#Remove LoadBalancer service
kubectl delete service tripviewer-service-lb

#Stop AKS
az aks stop --name akscluster$random --resource-group teamResources