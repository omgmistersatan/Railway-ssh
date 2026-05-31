FROM debian:bookworm-slim

# Variáveis padrão (podem ser sobrescritas no runtime)
ENV PORT=8080 \
    USERNAME=admin \
    PASSWORD=admin

# Instala dependências
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        wget curl git python3 python3-pip neofetch ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Instala ttyd
RUN wget -qO /usr/local/bin/ttyd \
    https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

# Configuração do bash (feito em build, não runtime)
RUN echo "neofetch" >> /root/.bashrc && \
    echo "cd /root" >> /root/.bashrc && \
    echo "export PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\\$ '" >> /root/.bashrc

# Garante root:root explicitamente
USER root

# Porta padrão (fixa, já que variável não funciona aqui)
EXPOSE 8080

# Comando principal
CMD ttyd -p ${PORT} -c ${USERNAME}:${PASSWORD} /bin/bash
