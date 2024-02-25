#Azure Container Registry
https://learn.microsoft.com/en-us/azure/container-registry/container-registry-intro
#ACR is a managed registry service based on the open-source Docker Registry 2.0. Create and maintain Azure container registries to store and manage your container images and related artifacts.
#Use Azure container registries with your existing container development and deployment pipelines, or use Azure Container Registry Tasks to build container images in Azure. 
#Build on demand, or fully automate builds with triggers such as source code commits and base image updates.

#Show repository
az group list --output table
az acr repository list --name $registryName --output table
sudo az acr login --name $registryName --username $registryName --password $registryPassword

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

#SQL server
#Add yourpublic IP to SQL server Network
#use Azure Query editor to query tables on mydrivingDB



