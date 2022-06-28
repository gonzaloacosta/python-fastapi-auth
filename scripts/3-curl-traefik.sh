# do not work
#curl -s -H 'x-api-key:super-secret-123' -X POST http://api.example.com/article-H 'Content-Type: application/json' -d '{"username":"gonzalo","text":"Se derrumba todo el cierlo, se convierte en un recuerdo", "request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0"}' 

# work and do not inject appname
curl -s -H 'x-api-key:super-secret-123' -X POST http://api.example.com/article -H 'Content-Type: application/json' -d '{"username":"gonzalo","text":"Se derrumba todo el cierlo, se convierte en un recuerdo", "request_id": "ac832ad4-c9c9-4eda-82ac-651233d23f2b", "wait_time": "0", "appname": "gonzalo-app"}' 
