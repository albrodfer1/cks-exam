## Extra exsercise: Enable mTLS

1. Generate CA:

```shell
openssl req -x509 -sha256 -newkey rsa:4096 -keyout ca-nginx.key -out ca-nginx.crt -days 356 -nodes -subj '/CN=My Cert Authority'
```

2. Create secret storing CA:

```shell
kubectl create secret generic ca-nginx-secret --from-file=ca.crt=ca-nginx.crt
```

3. Generate CSR:

```shell
openssl req -new -newkey rsa:4096 -keyout client.key -out client.csr -nodes -subj '/CN=My Client'
```

4. Sign certificate:

```shell
openssl x509 -req -sha256 -days 365 -in client.csr -CA ca-nginx.crt -CAkey ca-nginx.key -CAcreateserial -out client.crt
```

5. Apply `ingress-mtls.yaml`. You should receive a message like this when you make a `curl`:

```html
<html>
<head><title>400 No required SSL certificate was sent</title></head>
<body>
<center><h1>400 Bad Request</h1></center>
<center>No required SSL certificate was sent</center>
<hr><center>nginx</center>
</body>
</html>
```

and this when you pass the proper certificates:

```html
<html>
<head><title>503 Service Temporarily Unavailable</title></head>
<body>
<center><h1>503 Service Temporarily Unavailable</h1></center>
<hr><center>nginx</center>
</body>
</html>
```