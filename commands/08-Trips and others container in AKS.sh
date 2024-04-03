#TRIPS deployment
cd ~/OpenHack/OpenHack-MyContainer/yaml
kubectl apply -f trips.yaml
pod=$(kubectl get pods -o json | jq -r '.items[] | select(.metadata.name | test("trips-")).metadata.name')
kubectl exec $pod -it -- /bin/sh
env | grep TRIPS
curl http://$TRIPS_SERVICE_SERVICE_HOST:80/api/trips
curl -i -X GET 'http://localhost:80/api/trips/healthcheck'
exit
kubectl get svc trips-service

#USER-JAVA deployment
cd ~/OpenHack/OpenHack-MyContainer/yaml
kubectl apply -f user-java.yaml
pod=$(kubectl get pods -o json | jq -r '.items[] | select(.metadata.name | test("user-java")).metadata.name')
kubectl logs $pod
kubectl exec $pod -it -- /bin/sh
env | grep JAVA
curl -i -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "createdAt": "2018-08-07", "deleted": false, "firstName": "Hacker","fuelConsumption": 0,"hardAccelerations": 0,"hardStops": 0, "lastName": "Test","maxSpeed": 0,"profilePictureUri": "https://pbs.twimg.com/profile_images/1003946090146693122/IdMjh-FQ_bigger.jpg", "ranking": 0,"rating": 0, "totalDistance": 0, "totalTime": 0, "totalTrips": 0,  "updatedAt": "2018-08-07", "userId": "hacker2" }' 'http://localhost:80/api/user-java/aa1d876a-3e37-4a7a-8c9b-769ee6217ec2'
curl -i -X GET 'http://localhost:80/api/user-java/healthcheck'
exit
kubectl get svc user-java-service -o wide

#USERPROFILE deployment
cd ~/OpenHack/OpenHack-MyContainer/yaml
kubectl apply -f userprofile.yaml
pod=$(kubectl get pods -o json | jq -r '.items[] | select(.metadata.name | test("userprofile")).metadata.name')
kubectl exec $pod -it -- /bin/sh
env | grep PROFILE
curl http://$USERPROFILE_SERVICE_SERVICE_HOST:80/api/user
exit
kubectl get svc userprofile-service

#TRIPVIEWER deployment
cd ~/OpenHack/OpenHack-MyContainer/yaml
kubectl apply -f tripviewer.yaml
kubectl get svc tripviewer-service
pod=$(kubectl get pods -o json | jq -r '.items[] | select(.metadata.name | test("tripviewer")).metadata.name')
kubectl exec $pod -it -- /bin/sh
env | grep TRIPVIEWER
curl -i -X GET 'http://tripviewer-service:80'
curl http://trips-service:80/api/trips
curl http://poi-service:80/api/poi
curl http://userprofile-service:80/api/user
curl -i -X PATCH --header 'Content-Type: application/json' --header 'Accept: application/json' -d '{ "fuelConsumption":90, "hardStops":74371 }' 'http://user-java-service:80/api/user-java/aa1d876a-3e37-4a7a-8c9b-769ee6217ec1'
exit