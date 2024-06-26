# Gatekeeper

TODO: Make it work

## Pre-requisites enable AdmissionWebhooks

```yaml
# admission configuraion
apiVersion: apiserver.config.k8s.io/v1
kind: AdmissionConfiguration
plugins:
- name: ValidatingAdmissionWebhook
  configuration:
    apiVersion: apiserver.config.k8s.io/v1
    kind: WebhookAdmissionConfiguration
    kubeConfigFile: /etc/kubernetes/pki/admission_kube_config.yaml
- name: MutatingAdmissionWebhook
  configuration:
    apiVersion: apiserver.config.k8s.io/v1
    kind: WebhookAdmissionConfiguration
    kubeConfigFile: /etc/kubernetes/pki/admission_kube_config.yaml
```

```yaml
# admission kube config
apiVersion: v1
kind: Config
  #clusters:
  #- cluster:
  #  certificate-authority: /etc/kubernetes/pki/ca.crt
  #  server: https://image-bouncer-webhook:30080/image_policy
  #name: bouncer_webhook
  #contexts:
  #- context:
  #  cluster: bouncer_webhook
  #  user: api-server
  #name: bouncer_validator
  #current-context: bouncer_validator
  #preferences: {}
users:
- name: api-server
  user:
    client-certificate: /etc/kubernetes/pki/apiserver.crt
    client-key:  /etc/kubernetes/pki/apiserver.key
```

## Introduction

Install gatekeeper:

```shell
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/v3.16.3/deploy/gatekeeper.yaml
```