## Instructions

1. Place admission configuration in a directory mounted to `kube-apiserver`

2. Add the `--admission-control-config-file` option in `kube-apiserver` manifest pointing to the admission configuration file

3. Create a new namespace and try to deploy a privileged pod in it (It should fail)