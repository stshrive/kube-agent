# kube-agent

kube-agent is a custom VSTS agent container with Python3, kubectl and msftkube preinstalled.

## Deployment
Use the kube-agent yaml is a kubernetes deployment specification with a docker-volume precreated for containers. To use the deployment, replace <token> with an appropriate VSTS account PAT and <pool> with the name of agent pool configured on the VSTS account.

Packaged on Docker Hub:
https://hub.docker.com/r/stshriv/kube-agent/

## Tagging and Versioning
msftkube versions are based on succesful VSTS builds. To build the latest version of this container you will need access to the VSTS build definition of msftkube. 

By using the following command in a VSTS build definition you can retrieve the build IDs for tagging and versioninsg a docker image:

`python3 ./get_version.py -v <api-version> -d <build-definition> -t <PAT> -a <account> -p <project> -s <build-status> -u <username> -c <number-of-builds-to-retrieve>`
