FROM debian:stable-slim

# Argumentos de build
ARG NGROK_AUTH_TOKEN
ARG ROOT_PASSWORD

# Variáveis de ambiente
ENV ROOT_PASSWORD=${ROOT_PASSWORD} \
    NGROK_AUTH_TOKEN=${NGROK_AUTH_TOKEN} \
    DEBIAN_FRONTEND=noninteractive

# Atualiza e instala dependências em uma única camada
RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
        openssh-server \
        wget \
        unzip \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Baixa e instala o ngrok
RUN wget -q -O /tmp/ngrok.zip https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip && \
    unzip /tmp/ngrok.zip -d /usr/local/bin/ && \
    rm /tmp/ngrok.zip && \
    chmod +x /usr/local/bin/ngrok

# Configura o SSH
RUN mkdir -p /run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    echo "UseDNS no" >> /etc/ssh/sshd_config

# Script de inicialização
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 80 443 3306 5130 5131 5132 5133 5134 5135 8080 8888

CMD ["/entrypoint.sh"]
