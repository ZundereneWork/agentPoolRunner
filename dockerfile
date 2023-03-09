# Seleccionar imagen base de Docker
FROM ubuntu:latest


# set the github runner version
ARG RUNNER_VERSION="2.283.3"


# update the base packages and add a non-sudo user
RUN apt-get update -y && apt-get upgrade -y && useradd -m docker


# install python and the packages the your code depends on along with jq so we can parse JSON
# add additional packages as necessary
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip


# Install dependencia de los pack de node 

RUN curl -sL https://deb.nodesource.com/setup_18.x |  bash -
RUN apt-get update && apt-get install -y nodejs

# Instalar Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Instalar Helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor |  tee /usr/share/keyrings/helm.gpg > /dev/null
RUN apt-get install apt-transport-https --yes
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" |  tee /etc/apt/sources.list.d/helm-stable-debian.list
RUN apt-get update
RUN apt-get install helm

# Instalar AZ CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb |  bash

# Instalar Powershell Az
RUN wget -q 'https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb'
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update 
RUN apt-get install -y powershell

RUN pwsh -command "& {Install-Module -Name Az -AllowClobber -Scope AllUsers -Force}" \
    && pwsh -command "& {Install-Module -Name Pester -Scope AllUsers -Force}" \
    && pwsh -command "& {Install-Module -Name Az.Subscription -Scope AllUsers -AllowPrerelease -Force}"

# install some additional dependencies
RUN chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

#
# copy over the start.sh script
COPY start.sh start.sh

# make the script executable
RUN chmod +x start.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
