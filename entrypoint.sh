#!/bin/bash
set -e

# Valida se a senha foi fornecida
if [ -z "${ROOT_PASSWORD}" ]; then
  echo "[ERRO] ROOT_PASSWORD não definida! Defina a variável de ambiente antes de iniciar."
  exit 1
fi

# Define a senha do root
echo "root:${ROOT_PASSWORD}" | chpasswd

# Configura o token do ngrok
ngrok config add-authtoken "${NGROK_AUTH_TOKEN}"

# Inicia o túnel ngrok em background
ngrok tcp 22 --log=stdout > /var/log/ngrok.log 2>&1 &

echo "[*] ngrok iniciado. Verifique /var/log/ngrok.log para o endereço do túnel."

# Inicia o SSH em foreground
exec /usr/sbin/sshd -D
