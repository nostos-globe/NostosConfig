FROM debian:bullseye-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    postfix mailutils libsasl2-modules && \
    apt-get clean

COPY main.cf /etc/postfix/main.cf

CMD ["postfix", "start-fg"]