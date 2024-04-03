#POI PORT-FORWARD (POD)
#Port 80 is forwarded to 28015 on your local computer
pod=$(kubectl get pods -o json | jq -r '.items[] | select(.metadata.name | test("poi-")).metadata.name')
kubectl get po $pod --template='{{(index (index .spec.containers 0).ports 0).containerPort}}{{"\n"}}'
kubectl port-forward $pod 28015:80
#http://127.0.0.1:28015/api/poi
curl http://127.0.0.1:28015/api/poi

#TRIPSVIEWER PORT-FORWARD (SERVICE)
kubectl port-forward service/tripviewer-service 28015:80

#Only my computer is able to reach the local IP
#http://127.0.0.1:28015
curl http://127.0.0.1:28015/
#Top bar is working, page link to API are not working
