#WSL2 resolv bug
#https://github.com/hashicorp/terraform/issues/30549
vi /etc/resolve.conf
nameserver 8.8.8.8

#Azure
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

az ad sp create-for-rbac --name "SP-WorkShop" --role="Owner" --scopes="/subscriptions/2474e5ce-b2a1-43af-985f-87fd2029012b"

{
  "appId": "2111dfc1-e4ff-4524-aaf6-b0c7e748cfca",
  "displayName": "SP-WorkShop",
  "password": "q9v8Q~yeqERX._GURvh3_OS8jfeKHzARB6NDtbBP",
  "tenant": "9208f13d-c8b7-455e-81c5-27dd5f363a02"
}

az ad sp list --filter "displayname eq 'SP-WorkShop'" --output table

export ARM_CLIENT_ID="2111dfc1-e4ff-4524-aaf6-b0c7e748cfca"
export ARM_CLIENT_SECRET="q9v8Q~yeqERX._GURvh3_OS8jfeKHzARB6NDtbBP"
export ARM_SUBSCRIPTION_ID="2474e5ce-b2a1-43af-985f-87fd2029012b"
export ARM_TENANT_ID="9208f13d-c8b7-455e-81c5-27dd5f363a02"

az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
az vm list-sizes --location westus
az account list-locations