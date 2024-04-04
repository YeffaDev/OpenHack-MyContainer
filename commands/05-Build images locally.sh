#Refer to POI Readme and find put the matching dockerfile
#Edit POi dockerfiles/dockerfile_3 (POI application build dockerfile)
#set DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false to overcome an incompatibility issue that prevents the app from connecting to Azure SQL
ENV SQL_USER="sa" \
    SQL_PASSWORD="123Password" \
    SQL_SERVER="172.30.154.235" \
    SQL_DBNAME="mydrivingDB" \
    WEB_PORT=80 \
    WEB_SERVER_BASE_URI="http://0.0.0.0" \
    ASPNETCORE_ENVIRONMENT="Local" \
    DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    CONFIG_FILES_PATH="/secrets"

#Build POI application image
#copy src folder to local repo
#copy dockerfiles folder to local repo
cd ~/OpenHack/OpenHack-MyContainer/src/poi
#read POI README
#--no-cache : force Docker for a clean build of an image
sudo docker build --no-cache -f ../../dockerfiles/Dockerfile_3 -t "tripinsights/poi:1.0" .
sudo docker image list tripinsights/poi:1.0

#Run POI container
#Run docker on 8080 service port
sudo docker run -d -p 8080:80 --name poi -e 'SQL_USER=sa' -e 'SQL_PASSWORD=123Password' -e 'SQL_SERVER=172.30.154.235' -e 'SQL_DBNAME=mydrivingDB' -e 'ASPNETCORE_ENVIRONMENT=Local' tripinsights/poi:1.0
sudo docker ps -f name=poi
curl -i -X GET 'http://localhost:8080/api/poi'
#Exec API from inside the container on 80 container port
sudo docker inspect poi | grep IPAddress
curl -i -X GET 'http://172.17.0.3:80/api/poi'
#Stop POI Container
sudo docker stop poi
#Remove POI Container (if needed)
sudo docker rm poi

#Push repo to Azure registry
#Tag images, docker.io is optional, without tag is latest version
sudo docker tag docker.io/tripinsights/poi:1.0 $registryLoginServer/paoloceffa/poi
#Tag images, docker.io is optional, with version 1.0
sudo docker tag docker.io/tripinsights/poi:1.0 $registryLoginServer/paoloceffa/poi:1.0
#Push to the repository the 1.0 version
sudo docker push $registryLoginServer/paoloceffa/poi:1.0
#Push to the repository the "latest" version
sudo docker push $registryLoginServer/paoloceffa/poi
#Show repositories in registry
az acr repository list --name $registryName --output table
az acr repository show --name $registryName --repository paoloceffa/poi --output table
az acr repository show-tags --name $registryName --repository paoloceffa/poi --output table

#TRIPS source var (GO)
#trips/tripsgo/dataAccess.go
#pay attention to the credential_method : must be user/password
var (
    debug             = flag.Bool("debug", false, "enable debugging")
    password          = flag.String("password", getConfigValue("SQL_PASSWORD", "changeme"), "the database password")
    user              = flag.String("user", getConfigValue("SQL_USER", "sqladmin"), "the database user")
    port              = flag.Int("port", 1433, "the database port")
    server            = flag.String("server", getConfigValue("SQL_SERVER", "changeme.database.windows.net"), "the database server")
    database          = flag.String("d", getConfigValue("SQL_DBNAME", "mydrivingDB"), "db_name")
    credential_method = flag.String("c", getConfigValue("CREDENTIAL_METHOD", "username_and_password"), "method of authenticating into SQL DB")
    clientId          = flag.String("i", getConfigValue("IDENTITY_CLIENT_ID", ""), "the  identity client id")
)

#Build and push Trips (API)
cd  ~/OpenHack/OpenHack-MyContainer/src/trips 
#read README
sudo docker build --no-cache -f ../../dockerfiles/Dockerfile_4 -t "tripinsights/trips:1.0" .
sudo docker run -d -p 8080:80 --name trips -e 'SQL_USER=sa' -e 'SQL_PASSWORD=123Password' -e 'SQL_SERVER=172.30.154.235' -e 'OPENAPI_DOCS_URI=http://172.30.154.235' tripinsights/trips:1.0
curl -i -X GET 'http://localhost:8080/api/trips'
sudo sudo docker stop trips
sudo docker tag docker.io/tripinsights/trips:1.0 $registryLoginServer/paoloceffa/trips:1.0
sudo docker push $registryLoginServer/paoloceffa/trips:1.0
#Stop Container
sudo docker stop trips
#Remove Container (if needed)
sudo docker rm trips

#Build Tripviewer (website Front-End)
cd  ~/OpenHack/OpenHack-MyContainer/src/tripviewer/
#read README
sudo docker build --no-cache -f ../../dockerfiles/Dockerfile_1 -t "tripinsights/tripviewer:1.0" .
sudo docker run -d -p 8080:80 --name tripviewer -e "USERPROFILE_API_ENDPOINT=http://172.30.154.235" -e "TRIPS_API_ENDPOINT=http://172.30.154.235" tripinsights/tripviewer:1.0
#local browser : http://localhost:8080/
curl -i -X GET 'http://localhost:8080'
sudo docker stop tripviewer
sudo docker tag docker.io/tripinsights/tripviewer:1.0 $registryLoginServer/paoloceffa/tripviewer:1.0
sudo docker push $registryLoginServer/paoloceffa/tripviewer:1.0
#Stop Container
sudo docker stop tripviewer
#Remove Container (if needed)
sudo docker rm tripviewer

#Build userjava (User profile API)
cd  ~/OpenHack/OpenHack-MyContainer/src/user-java
#read README
sudo docker build --no-cache -f ../../dockerfiles/Dockerfile_0 -t "tripinsights/user-java:1.0" .
sudo docker run -d -p 8080:80 --name user-java -e "SQL_USER=sa" -e "SQL_PASSWORD=123Password" -e "SQL_SERVER=172.30.154.235" tripinsights/user-java:1.0
#Test
curl -i -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "createdAt": "2018-08-07", "deleted": false, "firstName": "Hacker","fuelConsumption": 0,"hardAccelerations": 0,"hardStops": 0, "lastName": "Test","maxSpeed": 0,"profilePictureUri": "https://pbs.twimg.com/profile_images/1003946090146693122/IdMjh-FQ_bigger.jpg", "ranking": 0,"rating": 0, "totalDistance": 0, "totalTime": 0, "totalTrips": 0,  "updatedAt": "2018-08-07", "userId": "hacker2" }' 'http://localhost:8080/api/user-java/aa1d876a-3e37-4a7a-8c9b-769ee6217ec2'
#Healthcheck
curl -i -X GET 'http://localhost:8080/api/user-java/healthcheck'
#Push
sudo docker tag docker.io/tripinsights/user-java:1.0 $registryLoginServer/paoloceffa/user-java:1.0
sudo docker push $registryLoginServer/paoloceffa/user-java:1.0
#Stop Container
sudo docker stop user-java
#Remove Container (if needed)
sudo docker rm user-java

#Build userprofile (User profile API)
cd  ~/OpenHack/OpenHack-MyContainer/src/userprofile
#read README
sudo docker build --no-cache -f ../../dockerfiles/Dockerfile_2 -t "tripinsights/userprofile:1.0" .
sudo docker run -d -p 8080:80 --name userprofile -e 'SQL_USER=sa' -e 'SQL_PASSWORD=123Password' -e 'SQL_SERVER=172.30.154.235' tripinsights/userprofile:1.0
curl -i -X GET 'http://localhost:8080/api/user'
sudo docker tag docker.io/tripinsights/userprofile:1.0 $registryLoginServer/paoloceffa/userprofile:1.0
sudo docker push $registryLoginServer/paoloceffa/userprofile:1.0
#Stop Container
sudo docker stop userprofile
#Remove Container (if needed)
sudo docker rm userprofile

#Kill all running containers (if needed)
sudo docker kill $(sudo docker ps -q)
sudo docker ps -a
#Delete all stopped containers
sudo docker rm $(sudo docker ps -a -q)

#Remove image container
sudo docker rmi tripinsights/poi:1.0
#Delete all images
sudo docker rmi $(sudo docker images -q)

#Prune : Remove unused images
https://docs.docker.com/config/pruning/
sudo docker image prune -a

#Remove stopped container
sudo docker container prune

#Prune everything but volumes
sudo docker system prune

#Prune everything including volumes
sudo docker system prune --volumes