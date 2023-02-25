# Seleccionar imagen base de Docker
FROM ubuntu:latest

ENV TOKEN=__TOKEN__
ENV NAME=__NAME__
ENV REPO=__REPO__
ENV OWNER=__OWNER__

# Actualizar el sistema y instalar dependencias necesarias
RUN apt-get update && \
    apt-get install -y \
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
        wget

# Instalar Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Instalar Powershell Az
RUN wget -q 'https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb'
RUN dpkg -i packages-microsoft-prod.deb
RUN apt-get update 
RUN apt-get install -y powershell

RUN pwsh -command "& {Install-Module -Name Az -AllowClobber -Scope AllUsers -Force}" \
    && pwsh -command "& {Install-Module -Name Pester -Scope AllUsers -Force}" \
    && pwsh -command "& {Install-Module -Name Az.Subscription -Scope AllUsers -AllowPrerelease -Force}"

# Descargar y descomprimir el runner de GitActions
RUN curl -O -L https://github.com/actions/runner/releases/download/v2.298.0/actions-runner-linux-x64-2.298.0.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.298.0.tar.gz
RUN rm -rf ./actions-runner-linux-x64-2.298.0.tar.gz

# Configurar el runner
RUN ./config.sh \
    --url https://github.com/${OWNER}/${REPO} \
    --token ${TOKEN} \
    --name ${NAME} 

# Establecer el directorio de trabajo
WORKDIR /_work



# Ejecutar el runner
CMD ["./run.sh"]
