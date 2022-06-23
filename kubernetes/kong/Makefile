ADMIN_HOST			:= 172.42.42.246 
ADMIN_PORT			:= 8001
PROXY_HOST 			:= 172.42.42.245
PROXY_PORT 			:= 8080

export .

config:
	@curl http://172.42.42.246:8081/ | jq .

services:
	@curl http://172.42.42.246:8001/services | jq .

routes:
	@curl http://172.42.42.246:8001/routes | jq .

plugins:
	@curl http://172.42.42.246:8001/plugins | jq .

consumers:
	@curl http://172.42.42.246:8001/consumers | jq .

key-auths:
	@curl http://172.42.42.246:8001/key-auths | jq . 

api/post:
	@./test_api.sh

proxy/ip:
	@echo "Serivces with rate limit in 5"
	@echo "curl -H Host:ip.example.com http://172.42.42.245/ip"
	@for i in `seq 1 10` ; do curl -H Host:ip.kong.example.com http://172.42.42.245/ip ; echo "" ; done

proxy/article:
	@echo "> Test without apikey"
	@echo "curl -H Host:api.example.com http://172.42.42.245/api/v1/article/1"
	@curl -H Host:api.example.com http://172.42.42.245/api/v1/article/1 | jq .
	@echo ""
	@echo "> Test with apikey in header"
	@echo "curl -H Host:api.example.com -H apikey:super-secret-123 http://172.42.42.245/api/v1/article/1"
	@curl -H Host:api.example.com http://172.42.42.245/api/v1/article/1 | jq .
	@echo ""
	@echo "> Test with apikey in querystring"
	@echo "curl -H Host:api.example.com http://172.42.42.245/api/v1/article/1?apikey=super-secret-123"
	@curl -H Host:api.example.com http://172.42.42.245/api/v1/article/1?apikey=super-secret-123 | jq .

k/pods:
	@kubectl get pods -n kong

k/svc:
	@kubectl get svc -n kong

cm/reload:
	@kubectl delete cm kong-config -n kong
	@kubectl create cm kong-config -n kong --from-file=kong.yml
	@kubectl delete pods -l app.kubernetes.io/component=app,app.kubernetes.io/instance=kong -n kong
	@sh testapi.sh

watch:
	@watch -n 2 'kubectl get all -n kong'

echo/create:
	@kubectl apply -f https://bit.ly/echo-service -n ingest
