echo "POST /apikey - Gonzalo"
curl -s -X POST http://localhost:9080/apikey -H 'Content-Type: application/json' -d '{"appname":"gonzalo-app","apikey":"super-secret-123", "description": "DevOps Key"}' | jq .

echo "POST /apikey - Ramiro"
curl -s -X POST http://localhost:9080/apikey -H 'Content-Type: application/json' -d '{"appname":"ramiro-app","apikey":"super-secret-223", "description": "Dev Key"}' | jq .

echo "GET /apikeys"
curl -s http://localhost:9080/apikeys | jq .

echo "GET /apikey/1"
curl -s http://localhost:9080/apikey/1 | jq .
curl -s http://localhost:9080/apikey/2 | jq .
