#Run SQL server locally
# -e : Set environment variables
sudo docker run -e 'ACCEPT_EULA=Y' -e SA_PASSWORD='123Password' -p 1433:1433 --name sqlserver -d mcr.microsoft.com/mssql/server:2017-latest
sudo docker images mcr.microsoft.com/mssql/server
sudo docker ps -f name=sqlserver
sudo docker inspect sqlserver
#if needed
sudo docker start sqlserver
sudo docker stop sqlserver
sudo docker rm sqlserver

#Create database
sudo docker exec -it sqlserver "bash"
/opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P "123Password"
CREATE DATABASE mydrivingDB;
SELECT Name from sys.databases;
GO
exit
exit

#Connection to local DB from outside the container
ifconfig
ip addr | grep eth0
IP="172.30.154.235"
#launch sqlcmd from your PC
sqlcmd -S 172.30.154.235,1433 -U SA -P "123Password"
#launch SqlServerManagementStudio,DBeaver from your PC

#docker login to ACR (option 1)
docker login $registryLoginServer --username $registryName

#docker login to ACR (option 2)
echo $registryPassword | sudo docker login $registryLoginServer -u $registryName --password-stdin

#az acr login to ACR (option 3)
#Docker must be installed on your machine. Once done, use 'docker logout ' to log out.
sudo az acr login --name $registryName --username $registryName --password $registryPassword

#Add sample data to the local SQL database (option 1)
#Pull image "dataload" from Azure registry in TeamResources resource group (option 1)
#Dataload image is pulled automatically to local docker registry
#Run container against local DB
sudo docker run --name dataload --network bridge -e SQLFQDN=172.30.154.235 -e SQLUSER=sa -e SQLPASS='123Password' -e SQLDB=mydrivingDB $registryName.azurecr.io/dataload:1.0
 #The container exit after run
sudo docker ps -a -f name=dataload

#Add sample data to the local SQL database (option 1)
#Pull image "dataload" from public repo in docker-hub (dockerhub is default if you omit registry) (option 2)
#https://hub.docker.com/r/openhack/data-load
sudo docker run --name=dataload --network bridge -e SQLFQDN=172.30.154.235 -e SQLUSER=sa -e SQLPASS='123Password' -e SQLDB=mydrivingDB docker.io/openhack/data-load:v1
sudo docker ps -a -f name=dataload



