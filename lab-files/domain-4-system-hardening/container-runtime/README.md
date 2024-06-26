## Containerd

### Kernel module load

#### bootup

```shell
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF
```

#### immediately

```shell
modprobe overlay
modprobe br_netfilter
```

### Apply sysctl config

```shell
cat <<EOF | sudo tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF
```
1. net.bridge.bridge-nf-call-iptables = 1

  Purpose: Enables the use of iptables for filtering traffic on network bridges.
  High-Level Function: This setting allows the kernel to pass bridged IPv4 traffic through iptables rules, providing network security and control over packets that traverse bridges. This is critical for Kubernetes networking, where containers often communicate across bridges.

2. net.ipv4.ip_forward = 1

  Purpose: Enables IP forwarding.
  High-Level Function: This setting allows the system to forward packets between different network interfaces. It is essential for routing traffic between pods and services in Kubernetes, enabling network communication across different nodes in a cluster.
  
3. net.bridge.bridge-nf-call-ip6tables = 1

  Purpose: Enables the use of ip6tables for filtering IPv6 traffic on network bridges.
  High-Level Function: This setting allows the kernel to pass bridged IPv6 traffic through ip6tables rules, similar to the IPv4 setting but for IPv6 traffic. It is necessary for managing and securing IPv6 traffic in containerized environments.



### Annex

#### Overlay kernel module

overlay refers to OverlayFS, a union filesystem for Linux. OverlayFS allows for the layering of file systems, which is particularly useful in container environments to efficiently manage changes by overlaying a writable layer on top of a read-only base, reducing duplication and optimizing storage.

#### br_netfilter kernel module

br_netfilter is a Linux kernel module that enables network filtering (such as firewall rules) on bridge interfaces. It integrates network bridge operations with the iptables filtering framework, allowing control over traffic that passes through bridge interfaces, which is essential for managing network security and performance in bridged networking envirbridge-nf-call-ip6tables = 1

#### sysctl

sysctl is a command-line utility in Unix-like operating systems (including Linux) that allows you to view, set, and manage kernel parameters at runtime. These parameters control various aspects of the system's behavior and performance

## Links
