echo "POST /apikey"
#curl -s -H 'x-api-key:super-secret-123' -X POST https://api.example.com/article -H 'Content-Type: application/json' -d '{"username":"someone","text":"Daily note: to something else, butterfly", "appname": "local-test-app", "request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0"}' | jq .
curl -s -H 'x-api-key:super-secret-123' -X POST https://api.example.com/article -H 'Content-Type: application/json' -d '{"username":"someone","text":"Daily note: to something else, butterfly", request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0"}' | jq .

echo "GET /articles"
curl -v -H 'x-api-key:super-secret-223' khttps://api.example.com/articles | jq .

echo "GET /article/1"
curl -v -H 'x-api-key:super-secret-323' khttps://api.example.com/article/1 | jq .

