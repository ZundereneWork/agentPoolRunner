# Seleccionar imagen base de Docker
FROM ubuntu:latest

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
        python3-wheel

# Instalar Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

# Instalar Powershell Az
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
RUN pwsh -Command Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
RUN pwsh -Command Install-Module -Name Az -Force

# Descargar y descomprimir el runner de GitActions
RUN curl -O -L https://github.com/actions/runner/releases/download/v2.298.0/actions-runner-linux-x64-2.298.0.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.298.0.tar.gz
RUN rm -rf ./actions-runner-linux-x64-2.298.0.tar.gz

# Configurar el runner
RUN ./config.sh \
    --url https://github.com/OWNER/REPO \
    --token TOKEN \
    --name NAME \
    --work WORK

# Establecer el directorio de trabajo
WORKDIR /_work



# Ejecutar el runner
CMD ["./run.sh"]
