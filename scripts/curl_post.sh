echo "POST /apikey"
curl -s -X POST http://localhost:9080/article -H 'Content-Type: application/json' -d '{"appname":"gonzalo-app","apikey":"super-secret-123"}' | jq .

echo "GET /apikeys"
curl -s http://localhost:9080/apikey | jq .

echo "GET /apikey/1"
curl -s http://localhost;9080/apikey/1 | jq .
