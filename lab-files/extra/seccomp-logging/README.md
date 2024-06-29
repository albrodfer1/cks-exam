# Instructions

1. check logs for syscalls in `/var/log/syslog`: `grep syscall /var/log/syscall` (no one should appear)

2. Copy `audit.json` to `/var/lib/kubelet/seccomp`

3. Run the pod configured to run the seccomp profile

4. Check the logs again