# ✅ Load balancer backend servers
```nginx
upstream app_servers {
    server 10.0.1.10:7000;
    server 10.0.1.11:7000;
    # Optional: sticky sessions
    # ip_hash;
}
```

# ✅ HTTP -> HTTPS redirect
```nginx
server {
    listen 80;
    server_name example.com www.example.com;

    return 301 https://$host$request_uri;
}
```

# ✅ HTTPS Reverse Proxy with Caching for Static Assets
```nginx
server {
    listen 443 ssl;
    server_name example.com www.example.com;

    # 🔐 SSL Certificates (Replace with your actual paths)
    ssl_certificate     /etc/letsencrypt/live/example.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;

    # ✅ Recommended SSL settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # 🚀 Caching static assets (like JS, CSS, images)
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|otf)$ {
        expires 30d;
        access_log off;
        add_header Cache-Control "public";
        proxy_pass http://app_servers;
    }

    # 🔄 Reverse Proxy for all other routes
    location / {
        proxy_pass http://app_servers;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        # Optional: enable simple proxy cache (not for dynamic APIs)
        # proxy_cache my_cache;
        # proxy_cache_valid 200 1m;
    }
}
```
