# Introdução

Instale e execute uma instância GLPI 10.0.10 com docker


## Contas padrão

Mais informações na 📄[Documentação](https://glpi-install.readthedocs.io/en/latest/install/wizard.html#end-of-installation)
 ___________________________________________
| Usuário/Senha     	|      Função        	|
|---------------------|---------------------|
| glpi/glpi          	| admin account     	|
| tech/tech          	| technical account 	|
| normal/normal      	| "normal" account  	|
| post-only/postonly 	| post-only account 	|

# Implantar com CLI

### Deploy GLPI 
```sh
docker run --name mariadb -e MARIADB_ROOT_PASSWORD=c -e MARIADB_DATABASE=glpi -e MARIADB_USER=glpi -e MARIADB_PASSWORD=Uqn)agJ(&Hb*U8#5 -d mariadb:10.11
docker run --name glpi --link mariadb:mariadb -p 8080:80 -d samuelantonio512/glpi
```

### Implante GLPI com banco de dados existente
```sh
docker run --name glpi --link yourdatabase:mariadb -p 8080:80 -d samuelantonio512/glpi
```

## Implante GLPI com banco de dados e dados de persistência

Para uso em ambiente de produção ou uso diário, é recomendado utilizar container com volumes para dados persistentes.

* Primeiro, crie o contêiner MariaDB com volume

```sh
docker run --name mariadb -e MARIADB_ROOT_PASSWORD=Uqn)agJ(&Hb*U8#5 -e MARIADB_DATABASE=glpidb -e MARIADB_USER=glpi_user -e MARIADB_PASSWORD=glpi --volume /var/lib/mysql:/var/lib/mysql -d mariadb:10.11
```

* Em seguida, crie o contêiner GLPI com volume e vincule o contêiner MariaDB

```sh
docker run --name glpi --link mariadb:mariadb --volume /var/www/html/glpi:/var/www/html/glpi -p 8080:80 -d samuelantonio512/glpi
```

# Implantar com docker-compose

### Implante sem dados de persistência (para teste rápido)

```yaml
version: "3.8"

services:
#MariaDB Container
  mariadb:
    image: mariadb:10.11
    container_name: mariadb
    hostname: mariadb
    environment:
      - MARIADB_ROOT_PASSWORD=Uqn)agJ(&Hb*U8#5
      - MARIADB_DATABASE=glpi
      - MARIADB_USER=glpi
      - MARIADB_PASSWORD=Uqn)agJ(&Hb*U8#5

#GLPI Container
  glpi:
    image: samuelantonio512/glpi
    container_name : glpi
    hostname: glpi
    ports:
      - "8080:80"
```


## Implante com dados de persistência

Para implantar com docker compose, você usa os arquivos *docker-compose.yml* e *mariadb.env*.
Você pode modificar **_mariadb.env_** para personalizar configurações como:

* MariaDB root password
* GLPI database
* GLPI user database
* GLPI user password


### mariadb.env
```
MARIADB_ROOT_PASSWORD=8Yqvj/W]!Hd2gKku
MARIADB_DATABASE=glpi
MARIADB_USER=glpi
MARIADB_PASSWORD=Uqn)agJ(&Hb*U8#5
```

### docker-compose .yml
```yaml
version: "3.2"

services:
#MariaDB Container
  mariadb:
    image: mariadb:10.11
    container_name: mariadb
    hostname: mariadb
    volumes:
      - /var/lib/mysql:/var/lib/mysql
    env_file:
      - ./mariadb.env
    restart: always

#GLPI Container
  glpi:
    image: samuelantonio512/glpi
    container_name : glpi
    hostname: glpi
    ports:
      - "8080:80"
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
      - /var/www/html/glpi/:/var/www/html/glpi
    environment:
      - TIMEZONE=America/Sao_Paulo
    restart: always
```

Para implantar, basta executar o seguinte comando no mesmo diretório dos arquivos

```sh
docker-compose up -d
```

# Variáveis ​​de ambiente

### FUSO HORÁRIO
Se você precisar definir o fuso horário para Apache e PHP

Da linha de comando
```sh
docker run --name glpi --hostname glpi --link mariadb:mariadb --volumes-from glpi-data -p 8080:80 --env "TIMEZONE=America/Sao_Paulo" -d samuelantonio512/glpi
```

Do docker-compose

Modifique estas configurações
```yaml
environment:
     TIMEZONE=America/Sao_Paulo
```

