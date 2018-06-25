# kube-agent

kube-agent is a custom VSTS agent container with Python3, kubectl and msftkube preinstalled.

## Deployment
The kube-agent yaml is a kubernetes deployment specification with a docker-volume precreated for containers. To use the deployment, replace <token> with an appropriate VSTS account PAT and <pool> with the name of agent pool configured on the VSTS account.

Packaged on Docker Hub:
https://hub.docker.com/r/stshriv/kube-agent/

## Tagging and Versioning
msftkube versions are based on succesful VSTS builds. To build the latest version of this container you will need access to the VSTS build definition of msftkube. 

By using the following command in a VSTS build definition you can retrieve the build IDs for tagging and versioning a docker image:

`python3 ./get_version.py -v <api-version> -d <build-definition> -t <PAT> -a <account> -p <project> -b <branch-name> -s <build-status> -u <username> -c <number-of-builds-to-retrieve>`

## Release Definition Setup
To setup a release definition, run setup.sh, ci.sh, and render.sh in sequential order.

1. setup.sh installs the requisite dependencies on a shared vsts agent. If you are running on a custom agent which already has the dependencies installed you may skip calling setup.sh

2. ci.sh handles calling get_version.py in a vsts release definition. Provide ci.sh with the same parameters as get_version.

3. render.sh is used to create a dockerfile for each version returned by get_version.py. dockerfile.template provides a baseline dockerfile for building images with available msftkube wheels.
