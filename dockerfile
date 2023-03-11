# Seleccionar imagen base de Docker
FROM ubuntu:latest

# Actualizar el sistema y instalar dependencias necesarias
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        curl \
        sudo \
        git \
        jq \
        iproute2 \
        procps \
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        software-properties-common \
        python3 \
        python3-pip \
        python3-setuptools \
        python3-wheel \
        wget \
        gcc \
        g++ \
        make \
        gnupg 

# Install dependencia de los pack de node 
RUN curl -sL https://deb.nodesource.com/setup_18.x | sudo bash -
RUN apt-get update && apt-get install -y nodejs

# Instalar Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Instalar Helm
RUN curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" |  tee /etc/apt/sources.list.d/helm-stable-debian.list
RUN apt-get update
RUN apt-get install helm

# Instalar AZ CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Instalar Powershell Az
RUN wget -q 'https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb'
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update 
RUN apt-get install -y powershell

RUN pwsh -command "& {Install-Module -Name Az -AllowClobber -Scope AllUsers -Force}" \
    && pwsh -command "& {Install-Module -Name Pester -Scope AllUsers -Force}" \
    && pwsh -command "& {Install-Module -Name Az.Subscription -Scope AllUsers -AllowPrerelease -Force}"

# cd into the user directory, download and unzip the github actions runner
RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

# Añadir un usuario sin permisos de root para ejecutar el runner
RUN useradd -m -s /bin/bash runner && \
    chown -R runner:runner /actions-runner
USER runner

# Copiar el script de entrada y hacerlo ejecutable
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Definir el script de entrada
ENTRYPOINT ["/actions-runner/entrypoint.sh"]
