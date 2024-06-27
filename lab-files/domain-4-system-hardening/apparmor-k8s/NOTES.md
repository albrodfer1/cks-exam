Execute the following to check that apparmor profile is running in the container:

```shell
kubectl exec hello-apparmor -- cat /proc/1/attr/current
```