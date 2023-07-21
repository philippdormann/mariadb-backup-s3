FROM ubuntu:22.04
# WORKDIR /s3backup
RUN apt update && apt install -y wget gnupg pigz pbzip2 xz-utils \
        && apt install -y mariadb-client-10.6 \
        && wget https://dl.minio.io/client/mc/release/linux-amd64/mc -O /sbin/mc && chmod +x /sbin/mc \
        && apt remove -y wget && apt autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh .
ENTRYPOINT ["bash","entrypoint.sh"]
# ENTRYPOINT ["tail", "-f", "/dev/null"]
