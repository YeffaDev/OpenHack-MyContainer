#Create AKS cluster
az aks create \
  --resource-group $teamRG \
  --name akscluster$random \
  --enable-managed-identity \
  --node-count 1 \
  --generate-ssh-keys \
  --attach-acr $registryLoginServer

#Attach/detach registry
az aks update -n akscluster$random -g $teamRG --attach-acr $registryName
az aks update -n akscluster$random -g $teamRG --detach-acr $registryName

#Connect to AKS cluster
az aks get-credentials -g teamResources -n akscluster$random

#Verify integration with registry
az aks check-acr --name akscluster$random --resource-group teamResources --acr $registryName.azurecr.io

#Verify Role assigment (ACR pull)
az role assignment list --scope /subscriptions/2474e5ce-b2a1-43af-985f-87fd2029012b/resourceGroups/teamResources/providers/Microsoft.ContainerRegistry/registries/$registryName

#Create Namespace
kubectl create ns api
kubectl get ns api

#Secret deploy (update password)
kubectl create secret generic sql \
    --from-literal=SQL_USER=sqladminuFe8262 \
    --from-literal=SQL_PASSWORD=''
    --from-literal=SQL_SERVER='sqlserverufe8262.database.windows.net'
    --from-literal=SQL_DB='mydrivingDB'
#Decode secret
echo $(kubectl get secret sql --template={{.data.SQL_PASSWORD}} | base64 --decode )
#Encode plain test and edit secret
echo -n 'sqladminuFe8262' | base64
kubectl edit secrets sql-cred

#Secret yaml (update password)
apiVersion: v1
kind: Secret
metadata:
  name: sql
stringData:
  SQL_USER: sqladminyMi6049
  SQL_PASSWORD: 
  SQL_SERVER: sqlserveryMi6049.database.windows.net
  SQL_DBNAME: mydrivingDB

#POI (secret)
kubectl apply -f secret.yaml
kubectl delete -f poi_envvar.yaml
kubectl apply -f poi.yaml

#POI yaml
#Configure environment variables in Deployment yaml section, as described in README
#Update sqluser,sqlpw,sqlfdqn,container registry/image in yaml
#Note CPU/mem limit to avoid capacity issue
apiVersion: apps/v1
kind: Deployment
metadata:
  name: poi
spec:
  selector:
    matchLabels:
      app: poi
  replicas: 1
  template:
    metadata:
      labels:
        app: poi
    spec:
      containers:
      - image: "registryymi6049.azurecr.io/paoloceffa/poi:1.0"
        name: poi
        ports:
        - containerPort: 80
          protocol: TCP
        resources:
          limits:
            cpu: "0.2"
            memory: "256Mi"
          requests:
            cpu: "0.2"
            memory: "256Mi"
        envFrom:
        - secretRef:
            name: sql
        env:
        - name: "ASPNETCORE_ENVIRONMENT"
          value: "Production"
        - name: "CONFIG_FILES_PATH"
          value: "/secrets"
        - name: "DOTNET_SYSTEM_GLOBALIZATION_INVARIANT"
          value: "false"
        - name: "WEB_SERVER_BASE_URI"
          value: "http://0.0.0.0"
        - name: "WEB_PORT"
          value: "80"

---

apiVersion: v1
kind: Service
metadata:
  name: poi-service
  labels:
    run: poi-service
spec:
  selector:
    app: poi
  ports:
  - name: poi-http
    protocol: TCP
    port: 80
    targetPort: 80

---

#POI deployment
cd  ~/OpenHack/OpenHack-MyContainer/yaml
kubectl apply -f poi.yaml
kubectl delete -f poi.yaml

#POI describe
kubectl get pods --show-labels -o wide
pod=$(kubectl get pods -o wide -o jsonpath='{ .items[0].metadata.name }')
pod=$(kubectl get pods | awk 'FNR==2{print $1}')
kubectl describe po $pod
kubectl get svc poi
kubectl describe svc poi
kubectl get endpoints poi

#POI api
pod=$(kubectl get pods -o wide -o jsonpath='{ .items[0].metadata.name }')
kubectl exec $pod -- printenv | grep POI
kubectl exec $pod -it -- /bin/sh
env | grep POI
curl http://$POI_SERVICE_SERVICE_HOST:80/api/poi
exit