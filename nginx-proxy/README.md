# NGINX PROXY

```bash
cd /usr/src
git clone https://github.com/iperfex-team/dockerman-desplegando-una-plataforma-voip-billing-con-microservicios.git
cd /usr/src/dockerman-desplegando-una-plataforma-voip-billing-con-microservicios
cp -fr nginx-proxy/ /root/
```

```bash
docker network create NGINX_PROXY
```

```bash
cd /root/nginx-proxy
docker-compose up -d 
```
