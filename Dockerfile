FROM nginx:latest
EXPOSE 80
WORKDIR /app
USER root

COPY webpage.html ./template_webpage.html
COPY nginx.conf ./template_nginx.conf
COPY config.json ./template_config.json
COPY client_config.json ./template_client_config.json
COPY entrypoint.sh ./
COPY mikutap.zip ./
COPY warp-yxip ./

RUN apt-get update && apt-get install -y wget unzip qrencode iproute2 systemctl openssh-server && \
    wget -O cloudflared.deb https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb && \
    dpkg -i cloudflared.deb && \
    rm -f cloudflared.deb && \
    wget -O temp.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip temp.zip xray && \
    rm -f temp.zip && \
    chmod -v 755 xray entrypoint.sh

# Uncomment to install official warp client
# RUN wget -O warp.deb https://pkg.cloudflareclient.com/uploads/cloudflare_warp_2023_3_398_1_amd64_002e48d521.deb && \
#    dpkg -i warp.deb || true && \
#    rm -f warp.deb && \
#    apt -y --fix-broken install && \
#    mkdir -p /root/.local/share/warp && \
#    echo "yes" > /root/.local/share/warp/accepted-tos.txt

ENTRYPOINT [ "./entrypoint.sh" ]
