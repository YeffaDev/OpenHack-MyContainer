#WSL2 resolv bug
#https://github.com/hashicorp/terraform/issues/30549
vi /etc/resolve.conf
nameserver 8.8.8.8

#Azure
az login --tenant qqqqq-qqqqq-qqqqq-qqqqq-qqqqqqqqq --use-device-code
az account set --subscription wwww-wwww-wwww-wwww-wwwww
az account show

[
  {
    "cloudName": "AzureCloud",
    "homeTenantId": "qqqqq-qqqqq-qqqqq-qqqqq-qqqqqqqqq",
    "id": "wwww-wwww-wwww-wwww-wwwww",
    "isDefault": true,
    "managedByTenants": [],
    "name": "Visual Studio Professional Avaxxxxx rrrrrrrrr",
    "state": "Enabled",
    "tenantId": "qqqqq-qqqqq-qqqqq-qqqqq-qqqqqqqqq",
    "user": {
      "name": "zzzz.xxxx@ccccc.vvv",
      "type": "user"
    }
  }
]

az ad sp create-for-rbac --name "SP-WorkShop" --role="Owner" --scopes="/subscriptions/wwww-wwww-wwww-wwww-wwwww"

{
  "appId": "iiiiiiiiiiiiiiiiiiiiiiiiiiiiii",
  "displayName": "SP-WorkShop",
  "password": "yyyyyyyyyyyyyyyyyyyyyyyyyyy",
  "tenant": "qqqqq-qqqqq-qqqqq-qqqqq-qqqqqqqqq"
}

az ad sp list --filter "displayname eq 'SP-WorkShop'" --output table

export ARM_CLIENT_ID="iiiiiiiiiiiiiiiiiiiiiiiii"
export ARM_CLIENT_SECRET="yyyyyyyyyyyyyyyyyyyyyyyyyyy"
export ARM_SUBSCRIPTION_ID="wwww-wwww-wwww-wwww-wwwww"
export ARM_TENANT_ID="qqqqq-qqqqq-qqqqq-qqqqq-qqqqqqqqq"

az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
az vm list-sizes --location westus
az account list-locations