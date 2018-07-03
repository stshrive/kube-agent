# kube-agent

kube-agent is a custom VSTS agent container with Python3, kubectl and msftkube preinstalled.

## Deployment
The kube-agent yaml is a kubernetes deployment specification with a docker-volume precreated for containers. To use the deployment, replace <token> with an appropriate VSTS account PAT and <pool> with the name of agent pool configured on the VSTS account.

Packaged on Docker Hub:
https://hub.docker.com/r/stshriv/kube-agent/

## Tagging and Versioning
When tagging our images, we wish to use the build version of msftkube which are based on succesful VSTS builds. This results in images that will be tagged as follows.

`kube-agent:<msftkube-build-id>`.

 e.g. `kube-agent:1094096`

To build the latest version of this container you will need access to the VSTS build definition of msftkube. 

Within a VSTS build definition you can retrieve the build IDs for tagging and versioning a docker image

e.g.
`ci/version.sh -v <api-version> -d <build-definition> -t <PAT> -a <account> -p <project> -b <branch-name> -s <build-status> -u <username> -c <number-of-builds-to-retrieve>`

## Continuous Integration

### setup.sh
*setup.sh* is the first stage for continuous integration on a VSTS agent machine. This script installs other continuous integration dependencies on the agent machine to ensure the default VSTS agents can run the scripts. Simply add a Shell++ task to your build definition and set the script path to ci/setup.sh with no parameters.

### version.sh
*version.sh* handles collecting the build IDs from a specified build definition so we can tag our images using them. version.sh handles calling into get_version.py.

To run version.sh use a Shell++ task with the filepath set to ci/version.sh

Parameters:

| Short Command |    Full Command    |  Type  | Required |   Default Value   |           Description           |
|---------------|--------------------|--------|----------|-------------------|---------------------------------|
|      -a       | --account          | string | required |                   | VSTS account name               |
|      -b       | --branch           | string |          |'refs/heads/master'| VSTS Build Branch               |
|      -c       | --count            |  int   |          |        0          | The number of builds to return  |
|      -d       | --definition       |  int   | required |                   | The build definition ID         |
|      -e       | --environmentOutput| string |          |                   | Script output                   |
|      -p       | --project          | string | required |                   | VSTS Project within the account |
|      -s       | --buildstatus      | string |          |                   | build status filter             |
|      -t       | --token            | string |          |     NoneType      | User token to access account    |
|      -u       | --user             | string |          |     NoneType      | Username associated with token  |
|      -v       | --version          | float  |          |       4.1         | VSTS REST API version           |
|      -V       | --verbose          | boolean|          |      False        | Print verbose output            |

### render.sh
*render.sh* handles the creation of version specific dockerfiles by substituting placeholder text within dockerfile.template.

Use Shell++ script with the filepath set to ci/render.sh and provide the following parameters.
1. Versions (file): A file containing the versions from version.sh. This file is specified with the -e parameter above.
2. Output (filename): render will append to a file the full filepath of all dockerfiles generated after performing template substitution. Each line will contain `<docker file location> <build id/version>` for use in the build step of continuous integration.
3. The placeholder text to substitute. 

### build.sh
*build.sh* handles docker build and push commands and can take up to 4 arguments.

Use Shell++ task with the script path set to ci/build.sh
1. (required) Dockerfiles. This should be the same file generated by render.sh output parameter.
2. (optional) Container Registry. If using a custom container registry, provide the registries login endpoint.
3. (optional) Registry Username. If using a custom container registry, used to provide a username to login to the registry via a docker login command
4. (optional) Registry Password. If using a custom container registry, used to provide a password to login to the registry via a docker login command.

Note that if any optional parameter is specified, all three optional parameters should be used.

## Build Definition
To setup a build definition, do the following.

1. Call setup.sh. If running on a custom agent with dependencies pre-installed, you may skip calling setup.sh
2. Call version.sh
3. Call render.sh
4. Call build.sh
