# Ingress

- Without rewrite

```bash
http://<ingress-url>/articles/18 --> http://dummy-ingest-api:8080/articles/18
```

- Example

```bash
curl -s http://<ingress_url>/articles/18 | jq .
{
  "id": 18,
  "username": "gonza",
  "text": "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa"
}
```
