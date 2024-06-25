# CKS Exam preparation

## Config file strucure (examples)

### Api Server

- Encryption at Rest: Used for specifying encryption configuration in the apiserver:

```yaml
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
```

- Audit Logging

```yaml
apiVersion: audit.k8s.io/v1
kind: Policy
rules:
- level: Metadata
```

- Admission control config file: ImagePullPolicyWebhook sets the image policy. Normally the kubeconfig file is set to use the kube-apiserver credentials in `/etc/kubernetes/pki`

TODO: Determine where can you restrict the docker repositories you can download from

```yaml
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ImagePolicyWebhook
  configuration:
    imagePolicy:
      kubeConfigFile: /etc/kubernetes/controlconf/webhook.kubeconfig
      allowTTL: 50
      denyTTL: 50
      retryBackoff: 500
      defaultAllow: true
```

## Config files of interest path

### ETCD

- `var/lib/etcd`: Normally where `etcd` storage is

### Api Server

- `/var/lib/kubernetes/encryption-at-rest.yaml`: Normally where the encryption configuration for the apiserver is stored (it's determined by the parameter `--encryption-provider-config`)

### Kubelet

- `/var/lib/kubelet/config.yaml`: Normally where the kubelet config is stored

## Config files options of interest

### Kubelet

- In kubelet config (`/var/lib/kubelet/config.yaml`) `authentication.anonymous.enabled` controls authentication in `kubelet`

- In kubelet config (`/var/lib/kubelet/config.yaml`) `authorization.mode: Webhook|AlwaysAllow|AlwaysDeny` controls authorization in `kubelet`

## Command options of interest

### ETCD

- `--endpoints`: URL of etcd server
- `--insecure-skip-tls-verify`: Skip server cert validation
- `--insecure-transport=false`: Use TLS
- `ETCDCTL_API=3`: Variable to specify the API version to use
- `--cert`: Client certificate
- `--key`: Client key
- `--authorization-mode=RBAC|AlwaysAllow|AlwaysDeny|Node`: authorization mode

## Commands of interest

### Api Server

- `--tls-cert-file`: Cert to enable TLS in API server
- `--tls-private-key-file`: Key of the TLS certificate for the API server
- `--token-auth-file`: Path to csv to enable token based authentication
- `--client-ca-file`: Path to CA certificate to authenticate client requests (mTLS)
- `--encryption-provider-config`: Path to encryption provider config to encrypt data before writting to ETCD
- `--audit-policy-file`: Path where the policy file config is stored
- `--audit-log-path`
- `--enable-admission-plugins`: Enable kube-apiserver admission-plugins
- `--admission-control-config-file`: Path to admission control config file

### `kubectl`

- `--token`: Pass token to aexamplesuthenticate to API server

### Certificates

- `openssl genrsa -out key.key 2048`: Generate 2048 bits RSA key
- `openssl req -new -req -key key.key -subj="/CN=COMMON-NAME -out certificate.csr`: Generate certificate signing request
- `openssl x509 -req -in ca.csr -signkey ca.key -CAcreateserial -out ca.crt .days 1000`: Self-sign certificate signing request
- Creating configuration for CSR: 
```shell
cat > some.cnf <<EOF
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
IP.1 = 123.123.123.123
IP.2 = 127.0.0.1
EOF
```
- `openssl req -new -key key.key -subj "/CN=some" .out some.csr -config some.cnf`: Generate CSR with config file
- `openssl x509 -req -in some.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out some.crt -days 100`: Sign certificate with CA

- `openssl x509 -req -in some.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out some.crt -days 100 -extfile some.cnf -extensions v3_req`: Sign certificate with CA and config file

- `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ingress.key -out ingress.crt -subj="/CN=example.internal/O=security"`: Create self-signed certificate for an ingress

### ETCD

- `etcdctl put key value`: Write key value to etcd
- `etcdctl get key`: Get value from etcd
- `etcdctl del key`: Remove key from etcd

### Logging

- `journalctl -e -u kube-apiserver|etcd|kubelet`: See events in `journalctl` filtering by process and starting from the latest ones

## Notes

- `kubeadm` creates certificates for `kube-apiserver` valid for 10.96.0.1 and internal IP addresses by default