#Destroy NFS
az network private-endpoint delete \
 --resource-group $rg_st \
  --name "${stacc}_pe"

az network private-endpoint create
az network private-dns link vnet delete \
 --resource-group $rg_aks_net \
 -n ${aks_vnet}_dnslink \
 -z $dnszonename

az network private-dns zone delete \
 --resource-group $rg_aks_net \
 --name $dnszonename

az group delete --name $rg_st

#Stop AKS
az aks stop --name akscluster$random --resource-group teamResources
nodeResourceGroup=$(az aks show -n akscluster$random -g teamResources -o tsv --query "nodeResourceGroup")

#Delete lab
az group delete --name teamResources
az group delete --name $nodeResourceGroup
az group delete --name proctorResources