## Run privilege pod in all possible namespaces

```shell
for level in "privileged"  "baseline" "restricted"
do 
  for mode in "enforce" "audit" "warn"
  do
    kubectl delete po -n ${mode}-${level} privileged
    kubectl run -n ${mode}-${level} --image nginx --privileged=true privileged
  done
done
```

## When the mode is audit

It adds the following annotation to the audit event: `pod-security.kubernetes.io/audit-violations` (only if audit is capturing the events)
