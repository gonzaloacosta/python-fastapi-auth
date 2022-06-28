USERNAME				:= gonzalo
REPOSITORY  		:= gonzaloacosta
IMAGE						:= python-fastapi-auth
HOST_PORT 			:= 9080
HOST_IP					:= auth.example.com 
CONTAINER_PORT	:= 80
VERSION					:= 0.0.11
BRANCH					:= master

py/venv:
	@python3 -m venv venv
	@pip3 install -r requirements.txt

py/activate:
	@source venv/bin/activate

py/run:
	@cd app && uvicorn main:app --host $(HOST_IP) --port $(HOST_PORT) --reload

test:
	@echo "$(shell date) - GET /"
	@curl -kv https://$(HOST_IP):$(HOST_PORT) | jq .
	@echo ""
	@echo "$(shell date) - POST /apikey"
	@curl -kv -X POST https://$(HOST_IP):$(HOST_PORT)/apikey -H 'Content-Type: application/json' -d "{\"appname\":\"gonzalo-appname\",\"apikey\":\"super-secret-123\"}" | jq .
	@echo ""
	@echo "GET /apikeys"
	@curl -s -X GET https://$(HOST_IP):$(HOST_PORT)/apikeys | jq .
	@echo ""
	@echo "GET /1"
	@curl -s https://$(HOST_IP):$(HOST_PORT)/apikey/1 | jq .
	@echo ""
	@echo "GET /2"
	@curl -s http://$(HOST_IP):$(HOST_PORT)/apikey/2 | jq .
	@echo ""
	@echo "GET /2"
	@curl -s http://$(HOST_IP):$(HOST_PORT)/auth?apikey=super-secret-123 | jq .
	@echo ""

g/checkout:
	@git checkout $(BRANCH)

g/commit:
	@git commit -am "bump $(VERSION)"

g/push:
	@git commit -am "bump $(VERSION)"
	@git push -u origin $(BRANCH)

g/pull:
	@git fetch --force
	@git pull

docs:
	@open http://$(HOST_IP):$(HOST_PORT)/docs

d/build:
	@docker build -t $(REPOSITORY)/$(IMAGE):$(VERSION) .

d/image:
	@docker image -f $(REPOSITORY)/$(IMAGE):$(VERSION)

d/push:
	@docker push $(REPOSITORY)/$(IMAGE):$(VERSION)

d/bump:
	@docker build -t $(REPOSITORY)/$(IMAGE):$(VERSION) .
	@docker tag $(REPOSITORY)/$(IMAGE):$(VERSION) $(REPOSITORY)/$(IMAGE):latest
	@docker push $(REPOSITORY)/$(IMAGE):$(VERSION)
	@docker push $(REPOSITORY)/$(IMAGE):latest

d/rebuild:
	@docker stop $(USERNAME)-$(IMAGE)
	@docker rm $(USERNAME)-$(IMAGE)
	@docker run --rm -d --name $(USERNAME)-$(IMAGE) -p $(HOST_PORT):$(CONTAINER_PORT) $(REPOSITORY)/$(IMAGE):$(VERSION)

d/run:
	@docker run --rm -d --name $(USERNAME)-$(IMAGE) -p $(HOST_PORT):$(CONTAINER_PORT) $(REPOSITORY)/$(IMAGE):$(VERSION)

d/status:
	@docker ps -f name=$(USERNAME)-$(IMAGE)

k/apply:
	@kubectl apply -f kubernetes/*.yaml

watch:
	@watch -n 5 'kubectl get all -n ingest'

test/local/1:
	@echo "local > auth"
	@curl -v -H 'x-forwarded-uri:/api/v1/articles?apikey=super-secret-123' http://localhost:9080/auth

test/local/2:
	@echo "local > apikys"
	@curl -v http://localhost:9080/apikeys | jq .

test/api/1:
	@echo "api gateway > auth > backend: query string parameter"
	@curl -v http://api.example.com/api/v1/article/1\?apikey=super-secret-223 | jq .

test/api/2:
	@echo "header"
	@echo "curl -H apikey:super-secret-223 http://api.example.com/api/v1/article/1 | jq ."
	@curl -v -H apikey:super-secret-223 http://api.example.com/api/v1/article/1 | jq .

test/api/3:
	@echo "post article ramiro"
	@curl -v -X POST http://api.example.com/api/v1/article -H 'apikey:super-secret-223' -H 'Content-Type: application/json' -d '{"username":"ramiro","text":"Another day in the office", "appname": "local-test-app", "request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0"}' | jq .

test/api/4:
	@echo "post article gonzalo"
	@curl -v -X POST http://api.example.com/api/v1/article\?apikey=super-secret-123 -H 'Content-Type: application/json' -d '{"username":"gonzalo","text":"Another day in the office",  "request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0"}' | jq .
