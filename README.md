Here's the full English translation of your `README.md` for the **Raspberry Pi 5 Server Configuration** project:

```markdown
# Raspberry Pi 5 - Server Configuration

This repository contains the configuration and scripts needed to deploy and manage server infrastructure on a **Raspberry Pi 5** using **Docker, Cloudflare Tunnel, and GitHub Actions**.

---

## **Architecture**
![Untitled-2025-02-02-2053](https://github.com/user-attachments/assets/c6bde141-1749-43af-a587-58dcb20208b4)

---

## **Features**
✔ Automated deployment with **Docker Compose**  
✔ Use of **Cloudflare Tunnel** to route traffic without exposing the IP address  
✔ Docker images hosted on **GitHub Container Registry (GHCR.io)**  
✔ **Watchtower** for automatic container updates  
✔ Monitoring with **Prometheus, Grafana, and Loki**  

---

## 📂 **Repository Structure**
```
📦 config-repo
├── 📄 docker-compose.yml  # Main Docker Compose file (8.3 KB)
├── 📄 prometheus.yml      # Prometheus configuration file
├── 📄 promtail-config.yml # Promtail (Loki) config file
├── 📂 ntfy/               # Notification service configuration
├── 📂 postfix/            # Email server configuration
├── 📂 vault/              # Secret management and HashiCorp Vault
└── 📄 README.md           # Repository documentation

---

## 🛠️ **Server Installation**

### 🔹 **1. Clone this repository on the Raspberry Pi**
```bash
git clone https://github.com/your-user/config-repo.git ~/config-repo
cd ~/config-repo
````

### 🔹 **2. Run the installation script**

```bash
chmod +x deploy.sh
./deploy.sh
```

📌 **This script:**
✅ Installs **Docker and Docker Compose**
✅ Sets up the **Cloudflare Tunnel**
✅ Downloads and runs services with **Docker Compose**

---

## 🛠️ **Included Services**

| **Service**               | **Port** | **Description**            |
| ------------------------- | -------- | -------------------------- |
| **API Gateway (Traefik)** | 80/443   | Load balancing and routing |
| **Auth Service**          | 8081     | Authentication and JWT     |
| **User Service**          | 8082     | Profiles and followers     |
| **Album Service**         | 8083     | Albums and photos          |
| **Likes Service**         | 8084     | Like system                |
| **Notification Service**  | 8085     | Real-time notifications    |
| **PostgreSQL**            | 5432     | Main database              |
| **Redis**                 | 6379     | Cache for performance      |
| **MinIO**                 | 9000     | Image/video storage        |
| **NATS/Mosquitto**        | 4222     | Message broker for events  |
| **Prometheus**            | 9090     | System monitoring          |
| **Grafana**               | 3000     | Metrics visualization      |
| **Loki**                  | 3100     | Centralized logging        |

---

## 🌐 **Cloudflare Tunnel Configuration**

### 🔹 **1. Log into Cloudflare Tunnel**

```bash
cloudflared tunnel login
```

### 🔹 **2. Create and configure the tunnel**

```bash
cloudflared tunnel create nostos-tunnel
```

### 🔹 **3. Configure traffic in `/etc/cloudflared/config.yml`**

```yaml
tunnel: nostos-tunnel
credentials-file: /etc/cloudflared/nostos-tunnel.json
ingress:
  - hostname: nostos-globe.me
    service: http://localhost:80
  - service: http_status:404
```

### 🔹 **4. Enable tunnel to start automatically**

```bash
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

---

## 🔄 **Automatic Updates with Watchtower**

To automatically update containers when new versions are pushed to **GitHub Container Registry**:

```bash
docker run -d --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower --interval 300 --cleanup
```

📌 **Watchtower will check every 5 minutes for updates and apply them automatically.**

---

## 🛠️ **Container Management**

### 📌 **View all running containers**

```bash
docker ps
```

### 📌 **Restart a specific container**

```bash
docker restart auth-service
```

### 📌 **Stop and remove a container**

```bash
docker stop auth-service && docker rm auth-service
```

### 📌 **Manually update a container from GitHub Container Registry**

```bash
docker pull ghcr.io/your-user/auth-service:latest
docker stop auth-service
docker rm auth-service
docker run -d --name auth-service -p 8081:8081 ghcr.io/your-user/auth-service:latest
```

---

## 📌 **CI/CD with GitHub Actions**

Each microservice has its own repository, and GitHub Actions automates deployment.

### **Example CI/CD Workflow (`.github/workflows/deploy.yml`)**

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
      - name: Access Raspberry Pi via SSH
        uses: appleboy/ssh-action@master
        with:
          host: ${{ secrets.SERVER_IP }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SSH_PRIVATE_KEY }}
          script: |
            cd ~/services/auth-service
            git pull origin main
            docker pull ghcr.io/your-user/auth-service:latest
            docker stop auth-service || true
            docker rm auth-service || true
            docker run -d --name auth-service -p 8081:8081 ghcr.io/your-user/auth-service:latest
```

📌 **Each push to `main` in a microservice repo will automatically update its container on the Raspberry Pi.**

```

Would you like this exported as a `.md` file or need help localizing it for a GitHub repository?
```
