# Escolhendo uma imagem Debian
FROM debian:11.6

LABEL org.opencontainers.image.authors="Samuel Antônio" \
      maintainer="samuel_neto17@hotmail.com"

# Não interromper a instalação para fazer perguntas
ENV DEBIAN_FRONTEND noninteractive

# Argumento para a versão do PHP
ARG PHP_VERSION=8.3

# Atualizar e instalar dependências
RUN apt-get update && \
    apt-get install -y \
       ca-certificates \
       apt-transport-https \
       lsb-release \
       wget \
       curl && \
    curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
       apache2 \
       php${PHP_VERSION} \
       php${PHP_VERSION}-mysql \
       php${PHP_VERSION}-ldap \
       php${PHP_VERSION}-xmlrpc \
       php${PHP_VERSION}-imap \
       php${PHP_VERSION}-curl \
       php${PHP_VERSION}-gd \
       php${PHP_VERSION}-mbstring \
       php${PHP_VERSION}-xml \
       php-cas \
       php${PHP_VERSION}-intl \
       php${PHP_VERSION}-zip \
       php${PHP_VERSION}-bz2 \
       php${PHP_VERSION}-redis \
       cron \
       jq \
       libldap-2.4-2 \
       libldap-common \
       libsasl2-2 \
       libsasl2-modules \
       libsasl2-modules-db \
       vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copiar e executar o script de inicialização para instalação e inicialização do GLPI
COPY glpi-start.sh /opt/
RUN chmod +x /opt/glpi-start.sh

# Configuração do ponto de entrada
ENTRYPOINT ["/opt/glpi-start.sh"]
WORKDIR /var/www/html

# Exposição das portas
EXPOSE 80 443
