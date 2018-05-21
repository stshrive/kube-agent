# kube-agent

kube-agent is a custom VSTS agent container with Python3, kubectl and msftkube preinstalled.

## Deployment
Use the kube-agent yaml is a kubernetes deployment specification with a docker-volume precreated for containers. To use the deployment, replace <token> with an appropriate VSTS account PAT and <pool> with the name of agent pool configured on the VSTS account.

Packaged on Docker Hub:
https://hub.docker.com/r/stshriv/kube-agent/
