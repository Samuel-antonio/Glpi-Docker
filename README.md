# Introdução

Instale e execute uma instância GLPI com docker

## Default accounts

More info in the 📄[Documentação](https://glpi-install.readthedocs.io/en/latest/install/wizard.html#end-of-installation)

| Usuário/Senha     	|      Função        	|
|---------------------|---------------------|
| glpi/glpi          	| admin account     	|
| tech/tech          	| technical account 	|
| normal/normal      	| "normal" account  	|
| post-only/postonly 	| post-only account 	|

# Implantar com CLI

### Deploy GLPI 
```sh
docker run --name mariadb -e MARIADB_ROOT_PASSWORD=8Yqvj/W]!Hd2gKku -e MARIADB_DATABASE=glpi -e MARIADB_USER=glpi -e MARIADB_PASSWORD=Uqn)agJ(&Hb*U8#5 -d mariadb:10.7
docker run --name glpi --link mariadb:mariadb -p 8080:80 -d samuelantonio512/glpi
```

## Deploy GLPI with existing database
```sh
docker run --name glpi --link yourdatabase:mariadb -p 8080:80 -d samuelantonio512/glpi
```

## Deploy GLPI with database and persistence data

For an usage on production environnement or daily usage, it's recommanded to use container with volumes to persistent data.

* First, create MariaDB container with volume

```sh
docker run --name mariadb -e MARIADB_ROOT_PASSWORD=Uqn)agJ(&Hb*U8#5 -e MARIADB_DATABASE=glpidb -e MARIADB_USER=glpi_user -e MARIADB_PASSWORD=glpi --volume /var/lib/mysql:/var/lib/mysql -d mariadb:10.7
```

* Then, create GLPI container with volume and link MariaDB container

```sh
docker run --name glpi --link mariadb:mariadb --volume /var/www/html/glpi:/var/www/html/glpi -p 8080:80 -d samuelantonio512/glpi
```

Enjoy :)

## Deploy a specific release of GLPI
Default, docker run will use the latest release of GLPI.
For an usage on production environnement, it's recommanded to set specific release.
Here an example for release 9.1.6 :
```sh
docker run --name glpi --hostname glpi --link mariadb:mariadb --volume /var/www/html/glpi:/var/www/html/glpi -p 8080:80 --env "VERSION_GLPI=9.1.6" -d samuelantonio512/glpi
```

# Deploy with docker-compose

## Deploy without persistence data ( for quickly test )
```yaml
version: "3.8"

services:
#MariaDB Container
  mariadb:
    image: mariadb:10.7
    container_name: mariadb
    hostname: mariadb
    environment:
      - MARIADB_ROOT_PASSWORD=password
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

## Deploy a specific release

```yaml
version: "3.8"

services:
#MariaDB Container
  mariadb:
    image: mariadb:10.7
    container_name: mariadb
    hostname: mariadb
    environment:
      - MARIADB_ROOT_PASSWORD=8Yqvj/W]!Hd2gKku
      - MARIADB_DATABASE=glpi
      - MARIADB_USER=glpi
      - MARIADB_PASSWORD=Uqn)agJ(&Hb*U8#5

#GLPI Container
  glpi:
    image: samuelantonio512/glpi
    container_name : glpi
    hostname: glpi
    environment:
      - VERSION_GLPI=9.5.6
    ports:
      - "8080:80"
```

## Deploy with persistence data

To deploy with docker compose, you use *docker-compose.yml* and *mariadb.env* file.
You can modify **_mariadb.env_** to personalize settings like :

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
    image: mariadb:10.7
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
      - TIMEZONE=Europe/Brussels
    restart: always
```

To deploy, just run the following command on the same directory as files

```sh
docker-compose up -d
```

# Environnment variables

## TIMEZONE
If you need to set timezone for Apache and PHP

From commande line
```sh
docker run --name glpi --hostname glpi --link mariadb:mariadb --volumes-from glpi-data -p 8080:80 --env "TIMEZONE=Europe/Brussels" -d samuelantonio512/glpi
```

From docker-compose

Modify this settings
```yaml
environment:
     TIMEZONE=America/Sao_Paulo
```
"# glpi" 
"# glpi" 

