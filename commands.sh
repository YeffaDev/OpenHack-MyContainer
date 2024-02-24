#WSL2 resolv bug
#https://github.com/hashicorp/terraform/issues/30549
vi /etc/resolve.conf
nameserver 8.8.8.8

#Pre-requisite 1 : deploy the lab
#Pre-requisite 2 : create new github repo

#Variables
teamRG="TeamResources"
registryName="registryufe8262"
registryLoginServer="registryufe8262.azurecr.io"

#Azure login
az login --tenant 9208f13d-c8b7-455e-81c5-27dd5f363a02 --use-device-code
az account set --subscription 2474e5ce-b2a1-43af-985f-87fd2029012b
az account show

[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "9208f13d-c8b7-455e-81c5-27dd5f363a02",
    "id": "2474e5ce-b2a1-43af-985f-87fd2029012b",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Visual Studio Professional Avanade Paolo",
    "state": "Enabled",
    "tenantId": "9208f13d-c8b7-455e-81c5-27dd5f363a02",
    "user": {
      "name": "paolo.ceffa@avanade.com",
      "type": "user"
    }
  }
]
