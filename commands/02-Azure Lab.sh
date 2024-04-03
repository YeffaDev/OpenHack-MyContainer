#Azure login
az login --tenant 9208f13d-c8b7-455e-81c5-27dd5f363a02 --use-device-code
az account set --subscription 2474e5ce-b2a1-43af-985f-87fd2029012b
az account show

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

#SQL server
#Add your public IP to the SQL server "Security / Networking"
#use Azure Query editor to query tables on mydrivingDB

#Set Environment Variables from script output
random="ymi6049"
teamRG="teamResources"
proctorRG="proctorResources"
vm="internal-vm"

#Internal VM
az vm stop --name $vm --resource-group $teamRG

#SQL variables
#SQL pass redacted for safety reason
sqlfqdn=sqlserver$random.database.windows.net
sqluser=sqladmin$random
sqlpass=
sqldb=mydrivingDB
echo sqlfqdn=$sqlfqdn;echo sqluser=$sqluser;echo sqlpass=$sqlpass;echo sqldb=$sqldb

#Registry variables
registryName="registry$random"
registryLoginServer="registry$random.azurecr.io"
registryPassword="$(az acr credential show -n $registryName -g $teamRG --query 'passwords[0].value' --output tsv)"
echo registryName=$registryName;echo registryLoginServer=$registryLoginServer;echo registryPassword==$registryPassword

#SQL variables (echo)
sqlfqdn=sqlserverymi6049.database.windows.net
sqluser=sqladminymi6049
sqlpass=
sqldb=mydrivingDB

#Registry variables (echo)
registryName=registryymi6049
registryLoginServer=registryymi6049.azurecr.io
registryPassword=

#Azure Container Registry
https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro
#ACR is a managed registry service based on the open-source Docker Registry 2.0. Create and maintain Azure container registries to store and manage your container images and related artifacts.
#Use Azure container registries with your existing container development and deployment pipelines, or use Azure Container Registry Tasks to build container images in Azure. 
#Build on demand, or fully automate builds with triggers such as source code commits and base image updates.

#Show repository
az group list --output table
az acr repository list --name $registryName --output table

#Azure Container Intances (proctor resources)
https://learn.microsoft.com/en-us/azure/container-instances/
#Azure Container Instances offers the fastest and simplest way to run a container in Azure, without having to manage any virtual machines and without having to adopt a higher-level service.
#run dataload container from ACR dataload image --> load data in SQL database --> (once executed, the container is "terminated")
az container list --resource-group $proctorRG --output table
az container show --resource-group $proctorRG --name dataload --output table
az container logs -g $proctorRG --name dataload

#Azure Container Intances (team resources)
https://techcommunity.microsoft.com/t5/itops-talk-blog/how-to-query-azure-resources-using-the-azure-cli/ba-p/360147
az container list --resource-group $teamRG --output table
az container list --resource-group $teamRG --query "[].{Name:name,Location:location}" --output table
simulatorName="simulator-app-$registryName"
simulatorfqdn=$(az container show -n $simulatorName -g $teamRG --query 'ipAddress.fqdn' --out tsv)
az container show -n $simulatorName -g $teamRG

