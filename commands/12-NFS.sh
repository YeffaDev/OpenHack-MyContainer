#Azure login
az login --tenant 9208f13d-c8b7-455e-81c5-27dd5f363a02 --use-device-code
az account set --subscription 2474e5ce-b2a1-43af-985f-87fd2029012b
az account show

rg_st="RG-myaks-storage"
#location must be the same as AKS
location="westus"
stacc="aksmyst$random"
share="export"
echo $rg_st;echo $location;echo $stacc;echo $share


#Storage Account
az group create \
    --name $rg_st \
    --location $location \
    --output none
    
az storage account create \
    --resource-group $rg_st \
    --name $stacc \
    --location $location \
    --kind FileStorage \
    --sku Premium_LRS \
    --enable-large-file-share \
    --output none
    
az storage share-rm create \
    --resource-group $rg_st \
    --storage-account $stacc \
    --name $share \
    --root-squash RootSquash \
    --quota 1024 \
    --enabled-protocols NFS \
    --output none
    
az storage account update --https-only false \
 --name $stacc --resource-group $rg_st

#Create Private Endpoint

#Update AKS MC resources RG
rg_aks_net="MC_teamResources_aksclusteryad4447_westus"

#MC aks_vnet
aks_vnet=$(az network vnet list \
--resource-group $rg_aks_net \
--query '[].[name]' \
--output tsv)
echo $aks_vnet

#MC aks_subnet
aks_subnet=$(az network vnet subnet list \
--resource-group $rg_aks_net \
--vnet-name $aks_vnet \
--query '[].[name]' \
--output tsv)
echo $aks_subnet

subnetid=$(az network vnet subnet show \
 --name $aks_subnet --resource-group $rg_aks_net \
 --vnet-name $aks_vnet --query id --output tsv)
echo $subnetid

#Storage id
stid=$(az storage account list \
 --resource-group $rg_st --query '[].[id]' --output tsv)
echo $stid
 
#Private Endpoint
endpoint=$(az network private-endpoint create \
 --resource-group $rg_st \
 --name "${stacc}_pe" \
 --nic-name "${stacc}_pe_nic" \
 --location $location \
 --subnet $subnetid \
 --private-connection-resource-id $stid \
 --group-id "file" \
 --connection-name "${stacc}_connection" \
 --query "id" -o tsv)
 echo $endpoint

#Create DNS zone

dnszonename="privatelink.file.core.windows.net"

dnsZone=$(az network private-dns zone create \
 --resource-group $rg_aks_net \
 --name $dnszonename --query "id" -o tsv)
echo $dnsZone

 #MC vnet id
 vnetid=$(az network vnet show \
 --resource-group  $rg_aks_net \
 --name $aks_vnet --query id --output tsv)
 echo $vnetid

#Create Virtual Network link (AKS net)
virtual-network-link=$(az network private-dns link vnet create \
 --resource-group $rg_aks_net \
 --zone-name $dnszonename \
 --name "${aks_vnet}_dnslink" \
 --virtual-network $vnetid \
 --registration-enabled false)

#endpoint nic (storage)
endpoint_nic=$(az network private-endpoint show \
 --ids $endpoint \
 --query "networkInterfaces[0].id" -o tsv)
echo $endpoint_nic

#endpoint ip (storage)
endpoint_ip=$(az network nic show \
  --ids $endpoint_nic \
  --query "ipConfigurations[0].privateIPAddress" -o tsv)
echo $endpoint_ip

#Create Record A in DNS zone (AKS net)
az network private-dns record-set a create \
 --resource-group $rg_aks_net \
 --zone-name $dnszonename \
 --name $stacc

#Create record entry IP
az network private-dns record-set a add-record \
 --resource-group $rg_aks_net \
 --zone-name $dnszonename  \
 --record-set-name $stacc \
 --ipv4-address $endpoint_ip