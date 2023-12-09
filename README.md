# GLPI com Docker

Este repositório facilita a instalação e execução do GLPI usando Docker. O código é compatível com a versão 10.0.10 do GLPI.

## Contas Padrão

| Usuário/Senha | Função              |
|---------------|---------------------|
| glpi/glpi      | Conta de administrador  |
| tech/tech      | Conta técnica       |
| normal/normal  | Conta "normal"      |
| post-only/postonly | Conta de postagem apenas |

## Implantação com CLI

### Deploy GLPI 
```sh
docker run --name mariadb -e MARIADB_ROOT_PASSWORD=sua_senha_root -e MARIADB_DATABASE=glpi -e MARIADB_USER=glpi -e MARIADB_PASSWORD=sua_senha_glpi -d mariadb:10.7
docker run --name glpi --link mariadb:mariadb -p 8080:80 -d samuelantonio512/glpi:10.0.10
```
## Implante GLPI com banco de dados existente
```sh
docker run --name glpi --link seu_banco_de_dados:mariadb -p 8080:80 -d samuelantonio512/glpi:10.0.10
```
# Implantação com Docker Compose

```sh
version: "3.8"

services:
  mariadb:
    image: mariadb:10.7
    container_name: mariadb
    hostname: mariadb
    environment:
      - MARIADB_ROOT_PASSWORD=sua_senha_root
      - MARIADB_DATABASE=glpi
      - MARIADB_USER=glpi
      - MARIADB_PASSWORD=sua_senha_glpi

  glpi:
    image: samuelantonio512/glpi:10.0.10
    container_name: glpi
    hostname: glpi
    ports:
      - "8080:80"

```
### Para implantar, execute:

```sh
docker-compose up -d
```

# Variáveis de Ambiente

## Fuso Horário

### Se precisar definir o fuso horário para Apache e PHP:

```sh
docker run --name glpi --hostname glpi --link mariadb:mariadb -p 8080:80 --env "TIMEZONE=America/Sao_Paulo" -d samuelantonio512/glpi:10.0.10

```

```sh
environment:
  TIMEZONE=America/Sao_Paulo
```


Para mais detalhes, consulte a 📄[Documentação](https://glpi-install.readthedocs.io/en/latest/install/wizard.html#end-of-installation)

Este README simplificado e foca a versão 10.0.10 do GLPI e fornece comandos diretos para implantação com Docker ou Docker Compose. Lembre-se de substituir "sua_senha_root" e "sua_senha_glpi" pelas senhas desejadas.


