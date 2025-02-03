#  Configuración del Servidor - Raspberry Pi 5

Este repositorio contiene la configuración y scripts necesarios para desplegar y administrar la infraestructura del servidor en una **Raspberry Pi 5** utilizando **Docker, Cloudflare Tunnel y GitHub Actions**.


## **Arquitectura**
![Sin titulo-2025-02-02-2053](https://github.com/user-attachments/assets/c6bde141-1749-43af-a587-58dcb20208b4)

---

## **Características**
✔ Despliegue automatizado con **Docker Compose**.  
✔ Uso de **Cloudflare Tunnel** para redirigir tráfico sin exponer la IP.  
✔ Imágenes Docker alojadas en **GitHub Container Registry (GHCR.io)**.  
✔ **Watchtower** para actualización automática de contenedores.  
✔ Monitorización con **Prometheus, Grafana y Loki**.  

---

## 📂 **Estructura del Repositorio**
```
📦 config-repo
 ├── 📄 docker-compose.yml  # Definición de infraestructura y servicios compartidos
 ├── 📄 .env                 # Variables de entorno (no compartir en público)
 ├── 📂 cloudflare/          # Configuración del túnel Cloudflare
 ├── 📂 monitoring/          # Configuración de Prometheus, Grafana y Loki
 ├── 📂 database/            # Configuración inicial de PostgreSQL
 ├── 📄 deploy.sh            # Script de instalación y despliegue
 ├── 📄 README.md            # Documentación del repositorio
```

---

## 🛠️ **Instalación del Servidor**
### 🔹 **1. Clonar este repositorio en la Raspberry Pi**
```bash
git clone https://github.com/tu-usuario/config-repo.git ~/config-repo
cd ~/config-repo
```

### 🔹 **2. Ejecutar el Script de Instalación**
```bash
chmod +x deploy.sh
./deploy.sh
```
📌 **Este script:**  
✅ Instala **Docker y Docker Compose**.  
✅ Configura **Cloudflare Tunnel**.  
✅ Descarga y ejecuta los servicios con **Docker Compose**.  

---

## 🛠️ **Servicios Incluidos**
| **Servicio**           | **Puerto** | **Descripción** |
|----------------------|-----------|----------------|
| **API Gateway (Traefik)** | 80/443 | Balanceo de carga y enrutamiento |
| **Auth Service** | 8081 | Autenticación y JWT |
| **User Service** | 8082 | Perfiles y seguidores |
| **Album Service** | 8083 | Álbumes y fotos |
| **Likes Service** | 8084 | Sistema de likes |
| **Notification Service** | 8085 | Notificaciones en tiempo real |
| **PostgreSQL** | 5432 | Base de datos principal |
| **Redis** | 6379 | Caché para mejorar rendimiento |
| **MinIO** | 9000 | Almacenamiento de imágenes/videos |
| **NATS/Mosquitto** | 4222 | Message Broker para eventos |
| **Prometheus** | 9090 | Monitoreo del sistema |
| **Grafana** | 3000 | Visualización de métricas |
| **Loki** | 3100 | Logging centralizado |

---

## 🌐 **Configuración de Cloudflare Tunnel**
### 🔹 **1. Iniciar sesión en Cloudflare Tunnel**
```bash
cloudflared tunnel login
```
### 🔹 **2. Crear y configurar el túnel**
```bash
cloudflared tunnel create nostos-tunnel
```
### 🔹 **3. Configurar el tráfico en `/etc/cloudflared/config.yml`**
```yaml
tunnel: nostos-tunnel
credentials-file: /etc/cloudflared/nostos-tunnel.json
ingress:
  - hostname: nostos-globe.me
    service: http://localhost:80
  - service: http_status:404
```
### 🔹 **4. Iniciar el túnel automáticamente**
```bash
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

---

## 🔄 **Automatización de Actualizaciones con Watchtower**
Para actualizar los contenedores automáticamente cuando haya nuevas versiones en **GitHub Container Registry**:
```bash
docker run -d --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower --interval 300 --cleanup
```
📌 **Watchtower revisará cada 5 minutos si hay nuevas imágenes y las actualizará automáticamente.**

---

## 🛠️ **Administración de Contenedores**
### 📌 **Ver todos los contenedores en ejecución**
```bash
docker ps
```
### 📌 **Reiniciar un contenedor específico**
```bash
docker restart auth-service
```
### 📌 **Detener y eliminar un contenedor**
```bash
docker stop auth-service && docker rm auth-service
```
### 📌 **Actualizar manualmente un contenedor desde GitHub Container Registry**
```bash
docker pull ghcr.io/usuario/auth-service:latest
docker stop auth-service
docker rm auth-service
docker run -d --name auth-service -p 8081:8081 ghcr.io/usuario/auth-service:latest
```

---

## 📌 **CI/CD con GitHub Actions**
Cada microservicio tiene su propio repositorio y GitHub Actions automatiza el despliegue.
### **Ejemplo de Workflow de CI/CD (`.github/workflows/deploy.yml`)**
```yaml
name: Deploy Auth Service

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Acceder a Raspberry Pi via SSH
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SERVER_IP }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd ~/services/auth-service
            git pull origin main
            docker pull ghcr.io/usuario/auth-service:latest
            docker stop auth-service || true
            docker rm auth-service || true
            docker run -d --name auth-service -p 8081:8081 ghcr.io/usuario/auth-service:latest
```
📌 **Cada push a `main` en un microservicio actualizará automáticamente su contenedor en la Raspberry Pi.**

