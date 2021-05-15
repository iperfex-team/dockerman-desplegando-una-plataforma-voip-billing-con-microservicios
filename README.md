# DockerMAN desplegando una plataforma VoIP Billing con Microservicios

## Dependencia

```bash
apt update
apt -y install vim curl screen mc git unzip net-tools links2 sudo nmap make mycli ufw
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
