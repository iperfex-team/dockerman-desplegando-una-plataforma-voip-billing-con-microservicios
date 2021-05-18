![iPERFEX](https://www.iperfex.com/wp-content/uploads/2019/01/iPerfex_logo_naranja-e1546949425459.png)

# Webinar - DockerMAN: desplegando una plataforma VoIP Billing con Microservicios

Webinar hands-on de cómo transformar a través de Docker, una plataforma VoIP billing que antes podía instalarse en un solo servidor (o máquina virtual) o en 4 máquinas virtuales (para hacerlo escalable) a crear y desplegar microservicios en un solo servidor donde tendremos un Servidor Web, Base de Datos, Asterisk +N (más de 1), FastAGI. Mejorando la performance, logrando que sea escalable (desplegando la cantidad de contenedores que necesitemos) y que sea más Seguro. El Poder de Docker!!!

Para ellos vamos a utilizar :

- Docker para desplegar: Asterisk, Nginx y MariaDB. Se utiliza Debian como sistema base.

**Nota: El objetivo es mostrar las transformación de una plataforma VoIP a microservicios y no la plataforma billing en si misma.**


![webinar](https://github.com/iperfex-team/dockerman-desplegando-una-plataforma-voip-billing-con-microservicios/blob/main/dockerman-webina-billing.png)


## Dependencia

```bash
apt update
apt -y install vim curl screen mc git unzip net-tools links2 sudo nmap make mycli ufw htop
```

## Instalando Docker
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

## Instalando Docker Compose

```bash
curl -L "https://github.com/docker/compose/releases/download/1.29.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod 777 /usr/local/bin/docker-compose
```

## Creamos Volume 

```bash
docker volume create portainer_data
```

## Instalando Portainer

```bash
docker run -d --name=portainer  -e TZ='America/Argentina/Buenos_Aires' -p 8000:8000 -p 9000:9000 --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce
```

## Clone Repo

```bash
cd /usr/src
git clone https://github.com/iperfex-team/dockerman-desplegando-una-plataforma-voip-billing-con-microservicios.git
cd /usr/src/dockerman-desplegando-una-plataforma-voip-billing-con-microservicios
```
