FROM microsoft/vsts-agent:ubuntu-16.04-docker-17.06.0-ce-standard

RUN apt-get -qq update
RUN apt-get -qq install -y --no-install-recommends \
                python3

RUN pip3 -q install --upgrade pip
RUN pip3 -q install setuptools
RUN pip3 -q install https://msftkube.blob.core.windows.net/public/msftkube-1.0.874864-py3-none-any.whl
