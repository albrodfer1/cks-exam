## before applying the config

- create certificates:

```shell
openssl genrsa -out bouncer.key 2048
cat > bouncer.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = 10.0.1.147
IP.2 = 127.0.0.1
DNS.1 = image-bouncer-webhook
EOF
openssl req -new -key bouncer.key -out bouncer.csr -subj "/CN=image-bouncer-webhook/O=security" -config bouncer.cnf
openssl x509 -req -in bouncer.csr -out bouncer.crt -extfile bouncer.cnf -extensions v3_req -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial

# create secret
kubectl create secret tls tls-image-bouncer-webhook --cert=bouncer.crt --key=bouncer.key
```

## after applying the config 

- add to pod spec:
  ```yaml
  hostAliases:
  - ip: "10.0.1.147"
    hostnames:
    - image-bouncer-webhook
  ```
  
- run `kubectl run --image nginx test`: It should reject it as it's using the latest branch