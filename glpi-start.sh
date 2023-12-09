#!/bin/bash

VERSION_GLPI="10.0.10"

# Se TIMEZONE não estiver definido, defina um valor padrão
if [[ -z "${TIMEZONE}" ]]; then 
    echo "TIMEZONE is unset, setting to UTC"; 
    TIMEZONE="UTC"
fi

# Configurar timezone no PHP
echo "date.timezone = \"$TIMEZONE\"" > /etc/php/8.3/apache2/conf.d/timezone.ini
echo "date.timezone = \"$TIMEZONE\"" > /etc/php/8.3/cli/conf.d/timezone.ini

SRC_GLPI=$(curl -s https://api.github.com/repos/glpi-project/glpi/releases/tags/${VERSION_GLPI} | jq .assets[0].browser_download_url | tr -d \")
TAR_GLPI=$(basename ${SRC_GLPI})
FOLDER_GLPI=glpi/
FOLDER_WEB=/var/www/html/

# Verificar se TLS_REQCERT está presente
if !(grep -q "TLS_REQCERT" /etc/ldap/ldap.conf)
then
    echo "TLS_REQCERT isn't present"
    echo -e "TLS_REQCERT\tnever" >> /etc/ldap/ldap.conf
fi

# Baixar e extrair as fontes do GLPI
if [ "$(ls ${FOLDER_WEB}${FOLDER_GLPI})" ];
then
    echo "GLPI is already installed"
else
    wget -P ${FOLDER_WEB} ${SRC_GLPI}
    tar -xzf ${FOLDER_WEB}${TAR_GLPI} -C ${FOLDER_WEB}
    rm -Rf ${FOLDER_WEB}${TAR_GLPI}
    chown -R www-data:www-data ${FOLDER_WEB}${FOLDER_GLPI}
fi

# Adaptar a configuração do Apache conforme necessário para a versão do GLPI instalada
echo -e "<VirtualHost *:80>\n\tDocumentRoot /var/www/html/glpi/public\n\n\t<Directory /var/www/html/glpi/public>\n\t\tRequire all granted\n\t\tRewriteEngine On\n\t\tRewriteCond %{REQUEST_FILENAME} !-f\n\t\n\t\tRewriteRule ^(.*)$ index.php [QSA,L]\n\t</Directory>\n\n\tErrorLog /var/log/apache2/error-glpi.log\n\tLogLevel warn\n\tCustomLog /var/log/apache2/access-glpi.log combined\n</VirtualHost>" > /etc/apache2/sites-available/000-default.conf

# Adicionar a diretiva ServerName para suprimir o aviso
echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Adicionar tarefa agendada via cron e habilitar
echo "*/2 * * * * www-data /usr/bin/php /var/www/html/glpi/front/cron.php &>/dev/null" > /etc/cron.d/glpi

# Iniciar o serviço cron
service cron start

# Ativar o módulo rewrite do Apache
a2enmod rewrite && service apache2 restart  && service apache2 stop

# Iniciar o serviço Apache em primeiro plano
/usr/sbin/apache2ctl -D FOREGROUND
