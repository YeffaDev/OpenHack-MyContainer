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

#Fork Microsoft repo to your github
#Clone from your repo
mkdir ~/Openhack
cd ~/Openhack
git clone https://github.com/YeffaDev/OpenHack-Microsoft.git
#The deployment script expects to be run from the byos/containers/deploy directory. Scripts use relative paths based on that expectation
cd ~/OpenHack/OpenHack-Microsoft/byos/containers/deploy
#modify the deploy.sh script with Ubuntu2204 image
#declare imagename="Ubuntu2204" to modify the Ubuntu distribution
#az vm create -n internal-vm -g $teamRG --admin-username azureuser --generate-ssh-keys --public-ip-address "" --image $imagename --vnet-name vnet --subnet vm-subnet
#westeu region has all the feature needed by the lab
az account list-locations --output table | grep europe
./deploy.sh -l "westus"

#Environment variables
random="ymi6049"
teamRG="teamResources"
proctorRG="proctorResources"
vm="internal-vm"

#Internal VM
az vm stop --name $vm --resource-group $teamRG

#SQL variables
sqlfqdn=sqlserver$random.database.windows.net
sqluser=sqladmin$random
sqlpass=pG0ot9Zc1
sqldb=mydrivingDB

#Registry variables
registryName="registry$random"
registryLoginServer="registry$random.azurecr.io"
registryPassword="$(az acr credential show -n $registryName -g $teamRG --query 'passwords[0].value' --output tsv)"

#SQL variables (echo)
echo sqlfqdn=$sqlfqdn;echo sqluser=$sqluser;echo sqlpass=$sqlpass;echo sqldb=$sqldb
sqlfqdn=sqlserverymi6049.database.windows.net
sqluser=sqladminymi6049
sqlpass=pG0ot9Zc1
sqldb=mydrivingDB

#Registry variables (echo)
echo registryName=$registryName;echo registryLoginServer=registryLoginServer;echo registryPassword=$registryPassword
registryName=registryymi6049
registryLoginServer=registryLoginServer
registryPassword=UT8jRuyt34otXkxr8x1ThHSHTDaJ/Db52AbKfgKpxD+ACRBSVchE

