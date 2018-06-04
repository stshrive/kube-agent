FROM stshriv/vstsdropdownloadcore AS app
FROM microsoft/vsts-agent:ubuntu-16.04-docker-17.12.0-ce-standard

# Get vstsdropdownloadcore's built drop downloader application
copy --from=app /app/* /app/

RUN apt-get -qq update

# Install Python2.7 and Python2.7 dependencies
RUN apt-get -qq install -y --no-install-recommends \
                python2.7 \
                python-pip \
                python-dev

RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python2.7 get-pip.py

RUN pip2 -q install --upgrade pip
RUN pip2 -q install setuptools
RUN pip2 -q install azure azure-cli

# Install Azure CLI
#ENV AZ_REPO $(lsb_release -cs)
#RUN echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main " | \
#    tee /etc/apt/sources.list.d/azure-cli.list

#RUN curl -L https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
#RUN apt-get -qq install -y --no-install-recommends \
#                apt-transport-https \
#                azure-cli

# Install Python3 and Python 3 dependencies
RUN apt-get -qq install -y --no-install-recommends \
                python3 \
                python3-pip

RUN pip3 -q install --upgrade pip
RUN pip3 -q install setuptools

# MSFTKube
RUN rm -rf ~/.cache/pip
RUN pip3 -q install https://msftkube.blob.core.windows.net/public/msftkube-1.0.874864-py3-none-any.whl
#
RUN pip3 -q install applicationinsights==0.11.3

# Install kubctl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.10.3/bin/linux/amd64/kubectl
