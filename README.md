
---

## ✅ FINAL NGINX `README.md`

````markdown
# 🚀 NGINX DevOps Project

This repository contains a complete, production-style setup for using **NGINX** as a:

- Reverse Proxy
- Load Balancer
- HTTPS Gateway
- Caching Layer

It also includes real-world DevOps interview questions and answers related to NGINX.

---

## 📦 1. Install NGINX on Ubuntu

```bash
sudo apt update
sudo apt install nginx -y
````

---

## ⚙️ 2. NGINX Service Commands

| Action  | Command                        |
| ------- | ------------------------------ |
| Start   | `sudo systemctl start nginx`   |
| Stop    | `sudo systemctl stop nginx`    |
| Status  | `sudo systemctl status nginx`  |
| Restart | `sudo systemctl restart nginx` |
| Reload  | `sudo systemctl reload nginx`  |

---

## 📁 3. About `/etc/nginx/`

| Path                          | Description                     |
| ----------------------------- | ------------------------------- |
| `/etc/nginx/nginx.conf`       | Main config file                |
| `/etc/nginx/sites-available/` | Site-specific configs           |
| `/etc/nginx/sites-enabled/`   | Enabled site configs (symlinks) |
| `/etc/nginx/conf.d/`          | Additional config snippets      |
| `/var/log/nginx/`             | NGINX logs                      |

---

## 📂 4. Project Files Overview (Inside This Repo)

| File/Folder        | Purpose                              |
| ------------------ | ------------------------------------ |
| `reverse_proxy`    | NGINX config for reverse proxy setup |
| `load_balancer`    | NGINX config for load balancing      |
| `https_nginx_file` | HTTPS/SSL config with certs          |
| `index.html`       | Sample static site to serve          |
| `Dockerfile`       | Docker setup for NGINX (if needed)   |
| `port`             | Your app running on port 7000        |

---

## 🚀 5. How to Use This Project

### Step 1: Copy config to `/etc/nginx/`

Example:

```bash
sudo cp reverse_proxy /etc/nginx/sites-available/myapp
sudo ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/
```

(Repeat for `load_balancer` or `https_nginx_file` as needed.)

---

### Step 2: Test Config

```bash
sudo nginx -t
```

✅ Make sure it says: `syntax is ok` and `test is successful`

---

### Step 3: Reload NGINX

```bash
sudo systemctl reload nginx
```

---

### Step 4: Access Your Application

* If using reverse proxy: visit `http://your-server-ip`
* If using HTTPS config: visit `https://yourdomain.com`
* Your app should be running on `http://localhost:7000` internally

---

## 🧠 DevOps Q&A — NGINX Interview Scenarios

---

### 1. **What is NGINX and why is it used in DevOps?**

**Answer:**
NGINX is a high-performance web server that can also act as a reverse proxy, load balancer, and cache. It’s used in DevOps for routing traffic efficiently, handling SSL, and distributing requests.

---

### 2. **Web Server vs Reverse Proxy?**

* Web server: serves static content (HTML, CSS)
* Reverse proxy: forwards requests to backend apps

**Scenario:**
App on port 7000 → accessed via port 80 using NGINX.

---

### 3. **How to configure reverse proxy in NGINX?**

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://127.0.0.1:7000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

### 4. **How to configure load balancing?**

```nginx
upstream backend {
    server 10.0.0.10:7000;
    server 10.0.0.11:7000;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}
```

---

### 5. **How to enable HTTPS?**

```nginx
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate     /etc/ssl/certs/example.crt;
    ssl_certificate_key /etc/ssl/private/example.key;

    location / {
        proxy_pass http://127.0.0.1:7000;
    }
}
```

Get free certs via Let's Encrypt:

```bash
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout localhost.key \
  -out localhost.crt \
  -subj "/CN=localhost"

sudo mkdir -p /etc/nginx/ssl
sudo cp localhost.crt /etc/nginx/ssl/
sudo cp localhost.key /etc/nginx/ssl/

sudo chmod 600 /etc/nginx/ssl/localhost.*

```

---

### 6. **What is caching in NGINX?**

```nginx
location / {
    proxy_cache my_cache;
    proxy_cache_valid 200 1h;
    proxy_pass http://backend;
}
```

Reduces backend load and improves performance.

---

### 7. **How to check config?**

```bash
sudo nginx -t
```

---

### 8. **How to reload NGINX without downtime?**

```bash
sudo systemctl reload nginx
```

---

### 9. **How to fix 502 Bad Gateway?**

Check:

* Is backend app running?
* Is proxy_pass IP/port correct?
* Are firewall rules OK?

---

### 10. **How to rate-limit in NGINX?**

```nginx
limit_req_zone $binary_remote_addr zone=mylimit:10m rate=5r/s;

server {
    location / {
        limit_req zone=mylimit burst=10;
        proxy_pass http://backend;
    }
}
```

Prevents abuse and DoS.

---

## 🙏 Thanks for Visiting This Repo

Feel free to contribute or suggest improvements.
Made with ❤️ by **Salman Khan**
