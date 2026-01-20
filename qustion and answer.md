# Nginx DevOps Interview Cheat Sheet

---

## 2️⃣ Configuration / Practical Questions

### 1. HTTP → HTTPS redirect kaise karenge?

**Answer (English):**
To redirect HTTP to HTTPS, use a separate server block listening on port 80 with a `return 301` directive.

```nginx
server {
    listen 80;
    server_name example.com www.example.com;

    # Redirect all HTTP requests to HTTPS
    return 301 https://$host$request_uri;
}
```

**Explanation:**

* `listen 80` → HTTP port
* `return 301 https://$host$request_uri` → Permanent redirect to HTTPS preserving host and path

---

### 2. Load balancing kaise setup karenge?

**Answer:**
Use an upstream block with multiple backend servers.

```nginx
upstream backend {
    server 192.168.1.101:80 weight=10;
    server 192.168.1.102:80 weight=5;
}

server {
    listen 443 ssl;
    server_name example.com;

    location / {
        proxy_pass http://backend;
    }
}
```

**Explanation:**

* `upstream backend` → Define backend servers
* `weight` → Relative request distribution
* `proxy_pass http://backend` → Forward request to backend group

---

### 3. Reverse proxy ka use kahan aur kyun hota hai?

**Answer:**
Reverse proxy forwards client requests to backend servers. Benefits: load balancing, SSL termination, caching, security.

**Example:**

```nginx
location / {
    proxy_pass http://backend_app;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
```

---

### 4. Rate-limiting aur connection limiting kaise karte ho?

**Answer:**

```nginx
# Rate limit
limit_req_zone $binary_remote_addr zone=req_limit:10m rate=10r/m;

location /api {
    limit_req zone=req_limit burst=5;
    limit_conn conn_limit 10;
    proxy_pass http://backend;
}
```

**Explanation:**

* `limit_req_zone` → Define memory zone for tracking IPs
* `rate=10r/m` → Max 10 requests per minute
* `limit_conn` → Max simultaneous connections per IP

---

### 5. Basic Authentication setup kaise karte ho?

**Answer:**

```nginx
location /admin {
    auth_basic "Admin Login";
    auth_basic_user_file /etc/nginx/.htpasswd;
    proxy_pass http://backend;
}
```

**Steps to create `.htpasswd`:**

```bash
sudo apt install apache2-utils
sudo htpasswd -c /etc/nginx/.htpasswd username
```

---

## 3️⃣ Security / DevOps Focused Questions

### 1. Brute-force attacks se Nginx ko kaise secure karte ho?

* Use **rate limiting** (`limit_req`) and **connection limiting** (`limit_conn`)
* Optional: integrate with **Fail2Ban** for IP blocking

---

### 2. Fail2Ban ke sath Nginx kaise integrate hota hai?

* Install `fail2ban`
* Create jail for Nginx:

```ini
[nginx-http-auth]
enabled  = true
filter   = nginx-http-auth
port     = http,https
logpath  = /var/log/nginx/error.log
maxretry = 3
```

* Fail2Ban monitors logs and blocks IPs that fail auth

---

### 3. IP allow/deny ka use kab aur kaise karte ho?

```nginx
location /admin {
    allow 192.168.1.10;
    allow 192.168.1.20;
    deny 192.168.1.30;
    deny all;
}
```

**Explanation:** Restrict access to admin areas to specific IPs

---

### 4. SSL configuration aur TLS versions ka kya importance hai?

* `ssl_protocols TLSv1.2 TLSv1.3;` → Only secure protocols allowed
* `ssl_ciphers HIGH:!aNULL:!MD5;` → Strong ciphers only
* Importance: Prevent insecure connections, protect sensitive data

---

### 5. Security headers kaise set karte ho?

```nginx
add_header X-Frame-Options "DENY";
add_header X-Content-Type-Options "nosniff";
add_header X-XSS-Protection "1; mode=block";
```

* Protect against clickjacking, MIME sniffing, XSS attacks

---

## 4️⃣ Performance / Tuning Questions

### 1. Worker_connections aur worker_processes ka matlab kya hai?

* `worker_processes` → Number of Nginx processes handling connections
* `worker_connections` → Max connections per worker
* Total simultaneous connections ≈ `worker_processes * worker_connections`

---

### 2. Caching kaise configure karenge?

```nginx
location /static/ {
    root /var/www/html;
    expires 30d;
}
```

* `expires` → Browser caches static files to reduce load

---

### 3. Gzip compression enable kaise karenge?

```nginx
gzip on;
gzip_types text/plain text/css application/javascript application/json;
```

* Compress responses → Faster page load, less bandwidth

---

### 4. Rate limiting & connection limiting ka impact kya hai?

* Prevents brute-force and DDoS attacks
* Too low → Can block legitimate users
* Too high → Ineffective against attacks

---

### 5. Keepalive_timeout aur buffering ka kya role hai?

* `keepalive_timeout` → Reuse TCP connection for multiple requests
* `proxy_buffering` → Buffer backend responses → Improve performance

---

## 5️⃣ Scenario / Problem Solving

### 1. Site slow, Nginx logs errors. Kya troubleshoot karoge?

* Check `access.log` and `error.log`
* Look for 502, 504 errors → Backend down
* Check worker_processes / worker_connections
* Use `top`, `htop`, `netstat` for resource bottlenecks

---

### 2. High traffic ke liye Nginx load balancing kaise setup karoge?

* Use `upstream` block with multiple backend servers
* Optional: `least_conn` or `ip_hash` for session persistence

---

### 3. Multiple backend apps, user requests route?

```nginx
location /app1 { proxy_pass http://app1_backend; }
location /app2 { proxy_pass http://app2_backend; }
```

* Each URL path points to corresponding backend

---

### 4. Secure admin panel, specific IP + password?

```nginx
location /admin {
    allow 192.168.1.10;
    allow 192.168.1.20;
    deny all;

    auth_basic "Admin Login";
    auth_basic_user_file /etc/nginx/.htpasswd;
}
```

Perfect! 😎 I’ll focus **only on the Optional / Advanced Topics** section and make it **clear, ready for interview reference** in English with short explanations and examples.

---

# 📝 Nginx Optional / Advanced Topics

### 1. Nginx + Docker

**Purpose:** Run Nginx in a container for easy deployment and isolation.

**Example Dockerfile:**

```dockerfile
FROM nginx:alpine

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/nginx.conf

# Copy website files
COPY html/ /usr/share/nginx/html/

# Expose HTTP & HTTPS
EXPOSE 80 443
```

**Explanation:**

* `FROM nginx:alpine` → lightweight Nginx image
* Config & HTML files are mounted inside container
* Can also mount SSL certificates as volumes

---

### 2. Nginx + Kubernetes Ingress

**Purpose:** Acts as Ingress controller to route traffic to multiple Kubernetes services.

**Example (Ingress YAML):**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
spec:
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: backend-service
            port:
              number: 80
```

**Explanation:**

* Routes external traffic to internal services
* Can manage SSL, path-based routing, and load balancing

---

### 3. Rate-limit + Geo-blocking

**Purpose:** Protect Nginx from malicious traffic based on request rate or geographic location.

**Example:**

```nginx
http {
    geo $blocked_country {
        default 0;
        US 1;  # Block traffic from US for example
    }

    limit_req_zone $binary_remote_addr zone=req_limit:10m rate=10r/m;

    server {
        if ($blocked_country) {
            return 403;
        }

        location /api {
            limit_req zone=req_limit burst=5;
            proxy_pass http://backend;
        }
    }
}
```

**Explanation:**

* Blocks requests from specific countries
* Rate-limits requests per IP

---

### 4. Monitoring

**Purpose:** Integrate Nginx metrics with Prometheus/Grafana for performance and traffic insights.

**Example:**

* Enable Nginx stub status:

```nginx
location /nginx_status {
    stub_status;
    allow 127.0.0.1;
    deny all;
}
```

* Use Prometheus exporter to scrape metrics
* Visualize connections, requests, response codes in Grafana

---

### 5. Log Analysis

**Purpose:** Parse Nginx access and error logs to understand traffic patterns, errors, and performance issues.

**Commands/Tools:**

```bash
# Top 10 most frequent client IPs
awk '{print $1}' /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -10

# Top 10 requested URLs
awk '{print $7}' /var/log/nginx/access.log | sort | uniq -c | sort -nr | head -10
```


### 1. What is NGINX?

**Answer:**
NGINX is a software that helps serve websites fast. It acts as a web server and can also send requests to other servers (called reverse proxy).

---

### 2. What is the difference between NGINX and Apache?

**Answer:**
NGINX is faster and can handle many users at the same time easily. Apache is older and slower because it creates a new process for each user.

---

### 3. How to set up NGINX as a reverse proxy?

**Answer:**
You tell NGINX to send all web requests to another server like this:

```nginx
location / {
    proxy_pass http://backend-server;
}
```

---

### 4. How to enable SSL (HTTPS) in NGINX?

**Answer:**
You need SSL certificate files and then add these lines in config:

```nginx
listen 443 ssl;
ssl_certificate /path/to/cert.pem;
ssl_certificate_key /path/to/key.pem;
```

---

### 5. What is load balancing in NGINX?

**Answer:**
If you have many servers, load balancing splits user traffic between them so no single server gets too busy.

---

### 6. Scenario: NGINX is slow when many users connect. What to do?

**Answer:**

* Increase number of worker processes (match CPU cores)
* Increase max connections per worker
* Use caching if possible
* Check backend server status

---

### 7. How to allow access only from some IP addresses in NGINX?

**Answer:**

```nginx
location /admin {
    allow 192.168.1.0/24;
    deny all;
}
```

---

## Database Questions

### 8. What is a database?

**Answer:**
A database is a place to store data like user info, products, etc., for your app.

---

### 9. What is the difference between relational and NoSQL databases?

**Answer:**
Relational databases (like MySQL) store data in tables with relations.
NoSQL databases (like MongoDB) store data more flexibly in documents or key-value pairs.

---

### 10. What is replication in databases?

**Answer:**
Replication means copying data from one database server to others. This helps keep data safe and makes it available even if one server fails.

---

### 11. Scenario: Database becomes slow. What should you check?

**Answer:**

* Check slow queries and fix them
* Add indexes on tables
* Check server CPU and memory usage
* Use caching to reduce load

---

### 12. How to backup and restore MySQL database?

**Answer:**

Backup:

```bash
mysqldump -u user -p dbname > backup.sql
```

Restore:

```bash
mysql -u user -p dbname < backup.sql
```

---

### 13. What does ACID mean in databases?

**Answer:**
ACID stands for rules that keep database transactions safe:

* Atomicity: All or nothing in a transaction
* Consistency: Data stays correct
* Isolation: Transactions don’t interfere
* Durability: Data is saved even if system crashes

---

### 14. Scenario: How to change database schema with no downtime?

**Answer:**

* Make changes step-by-step, backward compatible
* Use migration tools like Flyway or Liquibase
* Test changes before applying to live system

