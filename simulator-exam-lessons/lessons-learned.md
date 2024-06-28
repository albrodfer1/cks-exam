## Lessons learned

- `kube-apiserver` has an option `--kubernetes-service-node-port` to be exposed on a nodeport

- path in etcd where secrets are stored `/registry/secrets/<namespace>/<secret-name>`

- `kubectl get all` when you don't know which permissions you have

- check always for exec permissions

- `crictl pods --name pod-name` to find containers matching a pod

### find a pod running a specific syscall

```shell
# ssh to the worker
ssh worker
# get the pod id
crictl pods --name pod-name
# get the containter id
crictl ps --pod pod-id
# inspect the pod to get the process name
crictl inspect containter-id
# get the process id
ps aux | grep process-name
# use strace to find the traces
strace -p pid
```
