FROM microsoft/vsts-agent:ubuntu-16.04-docker-17.06.0-ce-standard
FROM python

RUN apt-get -qq update && install -y --no-install-recommendds \
    python3-pip

RUN pip -q install --upgrade pip
RUN pip -q install https://msftkube.blob.core.windows.net/public/msftkube-1.0.874864-py3-none-any.whl
