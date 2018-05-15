FROM ubuntu:16.04
FROM microsoft/vsts-agent:ubuntu-16.04
FROM python

RUN apt-get -qq update 
RUN apt-get -qq install -y python3-pip

RUN pip install --upgrade pip
RUN pip -q install https://msftkube.blob.core.windows.net/public/msftkube-1.0.874864-py3-none-any.whl
