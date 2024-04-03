#Application Gateway Ingress Controller

#Create network and public IP for the application-gateway
az group create --name appgw-RG --location westus
az network public-ip create -n myPublicIp -g appgw-RG --allocation-method Static --sku Standard
az network vnet create -n myVnet -g appgw-RG --address-prefix 10.0.0.0/16 --subnet-name mySubnet --subnet-prefix 10.0.0.0/24 

#Create application-gateway with public-ip
az network application-gateway create -n myApplicationGateway \
-g appgw-RG --sku Standard_v2 --public-ip-address myPublicIp \
--vnet-name myVnet --subnet mySubnet --priority 100

#Enable application-gateway on AKS
appgwId=$(az network application-gateway show -n myApplicationGateway -g appgw-RG -o tsv --query "id") 
az aks enable-addons -n akscluster$random -g teamResources -a ingress-appgw --appgw-id $appgwId

#Peer application-gateway network and aks-vnet network (bidirectional)
nodeResourceGroup=$(az aks show -n akscluster$random -g teamResources -o tsv --query "nodeResourceGroup")
aksVnetName=$(az network vnet list -g $nodeResourceGroup -o tsv --query "[0].name")

aksVnetId=$(az network vnet show -n $aksVnetName -g $nodeResourceGroup -o tsv --query "id")
az network vnet peering create -n AppGWtoAKSVnetPeering -g appgw-RG --vnet-name myVnet --remote-vnet $aksVnetId --allow-vnet-access

appGWVnetId=$(az network vnet show -n myVnet -g appgw-RG -o tsv --query "id")
az network vnet peering create -n AKStoAppGWVnetPeering -g $nodeResourceGroup --vnet-name $aksVnetName --remote-vnet $appGWVnetId --allow-vnet-access

#List peering
az network vnet peering list -g appgw-RG --vnet-name myVnet
az network vnet peering list -g $nodeResourceGroup  --vnet-name $aksVnetName
az network vnet peering show -g appgw-RG --vnet-name myVnet -n AppGWtoAKSVnetPeering
az network vnet peering show -g $nodeResourceGroup --vnet-name $aksVnetName -n AKStoAppGWVnetPeering

#Get Ingress
kubectl get ingressClass
kubectl describe ingressClass azure-application-gateway
kubectl get ValidatingWebhookConfiguration

#Apply ingress controller
kubectl apply -f ingress-agic.yaml
kubectl get ingress --watch
kubectl describe ingress integrated-ingress

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: integrated-ingress
  # annotations:
  #   kubernetes.io/ingress.class: azure/application-gateway
spec:
  ingressClassName: azure-application-gateway
  defaultBackend:
    service:
      name: tripviewer-service
      port:
        number: 80

#Clean-up
#https://learn.microsoft.com/en-us/azure/application-gateway/ingress-controller-disable-addon
kubectl delete -f ingress-agic.yaml

az network vnet peering delete -g appgw-RG --vnet-name myVnet -n AppGWtoAKSVnetPeering
az network vnet peering delete -g $nodeResourceGroup --vnet-name $aksVnetName -n AKStoAppGWVnetPeering

az aks disable-addons -n akscluster$random -g teamResources -a ingress-appgw

kubectl delete ingressClass azure-application-gateway
kubectl delete all --all -n app-routing-system

az group delete --name appgw-RG

#Delete AKS/CustomResources/AGIC resources