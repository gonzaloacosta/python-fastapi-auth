echo "POST /article"
#curl -v -H 'Content-Type: application/json' -H 'apikey:super-secret-123' -X POST http://api.example.com/api/v1/article -d '{"username":"someone","text":"Daily note: to something else, butterfly", "appname": "local-test-app-gonzalo", "request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0"}' | jq .

curl -v -H 'Content-Type: application/json' -H 'apikey:super-secret-123' -X POST http://api.example.com/api/v1/article -d '{"username":"someone","text":"Daily note: to something else, butterfly", "wait_time": "0"}' | jq .

#echo "GET /articles"
#curl -s -H 'apikey:super-secret-123' http://api.example.com/api/v1/articles | jq .

echo "GET /echo"
curl -v http://echo.example.com/echo

echo "GET /article/1"
curl -s -H 'apikey:super-secret-223' http://api.example.com/api/v1/article/1 | jq .

