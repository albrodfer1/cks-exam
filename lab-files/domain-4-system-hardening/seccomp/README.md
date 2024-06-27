1. Load seccomp profiles to both nodes

```shell
ssh -i ~/.ssh/aws-key ubuntu@${PUBLIC_IP_1} sudo mkdir -p /var/lib/kubelet/seccomp/profiles
ssh -i ~/.ssh/aws-key ubuntu@${PUBLIC_IP_2} sudo mkdir -p /var/lib/kubelet/seccomp/profiles

ssh -i ~/.ssh/aws-key ubuntu@${PUBLIC_IP_1} sudo chown ubuntu:ubuntu /var/lib/kubelet/seccomp/profiles
ssh -i ~/.ssh/aws-key ubuntu@${PUBLIC_IP_2} sudo chown ubuntu:ubuntu /var/lib/kubelet/seccomp/profiles

scp -i ~/.ssh/aws-key lab-files/domain-4-system-hardening/seccomp/*.json ubuntu@${PUBLIC_IP_1}:/var/lib/kubelet/seccomp/profiles
scp -i ~/.ssh/aws-key lab-files/domain-4-system-hardening/seccomp/*.json ubuntu@${PUBLIC_IP_2}:/var/lib/kubelet/seccomp/profiles

ssh -i ~/.ssh/aws-key ubuntu@${PUBLIC_IP_1} sudo chown root:root /var/lib/kubelet/seccomp/profiles
ssh -i ~/.ssh/aws-key ubuntu@${PUBLIC_IP_2} sudo chown root:root /var/lib/kubelet/seccomp/profiles
```

2. Apply `pods.yaml`

3. Pods 2 and 3 should not start because of missing required syscalls

4. Check the `syslog` to see the audit logs for pod 1

```shell
grep syscall /var/log/syslog
```

5. cleanup deleting pods