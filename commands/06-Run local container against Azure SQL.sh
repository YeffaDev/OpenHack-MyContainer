#Run the dataload against the Azure SQL-DB (if needed)
#Remember to open firewall to your public IP
sudo docker run --network bridge -e SQLFQDN=$sqlfqdn -e SQLUSER=$sqluser -e SQLPASS=$sqlpass -e SQLDB=$sqldb  $registryName.azurecr.io/dataload:1.0

#Test POI container against Azure SQL-DB
#Remember to open firewall to youer public IP
sudo docker run -d -p 8080:80 --name poi -e "SQL_USER=$sqluser" -e "SQL_PASSWORD=$sqlpass" -e "SQL_SERVER=$sqlfqdn" -e "SQL_DBNAME=$sqldb" -e 'ASPNETCORE_ENVIRONMENT=Local' tripinsights/poi:1.0
curl -i -X GET 'http://localhost:8080/api/poi'
sudo docker stop poi

#Test TRIPS container against Azure SQL-DB
sudo docker run -d -p 8080:80 --name trips -e "SQL_USER=$sqluser" -e "SQL_PASSWORD=$sqlpass" -e "SQL_SERVER=$sqlfqdn" -e "SQL_DBNAME=$sqldb" -e "OPENAPI_DOCS_URI=http://0.0.0.0" tripinsights/trips:1.0
curl -i -X GET 'http://localhost:8080/api/trips'
sudo docker stop trips

#Test USER-JAVA container against Azure SQL-DB
sudo docker run -d -p 8080:80 --name user-java -e "SQL_USER=$sqluser" -e "SQL_PASSWORD=$sqlpass" -e "SQL_SERVER=$sqlfqdn" tripinsights/user-java:1.0
#Test
curl -i -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "createdAt": "2018-08-07", "deleted": false, "firstName": "Hacker4","fuelConsumption": 0,"hardAccelerations": 0,"hardStops": 0, "lastName": "Hacker4_test","maxSpeed": 0,"profilePictureUri": "https://pbs.twimg.com/profile_images/1003946090146693122/IdMjh-FQ_bigger.jpg", "ranking": 0,"rating": 0, "totalDistance": 0, "totalTime": 0, "totalTrips": 0,  "updatedAt": "2018-08-07", "userId": "hacker4" }' 'http://localhost:8080/api/user-java/aa1d876a-3e37-4a7a-8c9b-769ee6217ec4'
#Healthcheck
curl -i -X GET 'http://localhost:8080/api/user-java/healthcheck'
#Stop
sudo docker stop user-java

#Test USERPROFILE container against Azure SQL-DB
sudo docker run -d -p 8080:80 --name userprofile -e "SQL_USER=$sqluser" -e "SQL_PASSWORD=$sqlpass" -e "SQL_SERVER=$sqlfqdn" tripinsights/userprofile:1.0
curl -i -X GET 'http://localhost:8080/api/user'
sudo docker stop userprofile

LINUX connection
#remote-ssh extension
#sqlservr container: This program requires a machine with at least 2000 megabytes of memory.
chmod 400 ubuntu-ufe8262_key.pem
ssh -i ubuntu-ufe8262_key.pem azureuser@20.66.40.222
