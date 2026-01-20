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
complet production nginxfile 
```nginx
http {
    # http block: Yahan se Nginx ka HTTP processing start hota hai
    # Is block ke andar server, upstream, cache waghera define hotay hain


    # =============================
    # LOAD BALANCER
    # =============================
    upstream app_servers {
        # upstream ka matlab backend servers ka group

        server 10.0.1.10:7000;
        # Pehla backend server, IP aur port jahan app chal rahi hai

        server 10.0.1.11:7000;
        # Doosra backend server, load yahan bhi distribute hoga

        # ip_hash;
        # (optional) Agar uncomment karo to same client hamesha same backend par jaye
        # Ye sticky sessions ke liye use hota hai
    }


    # =============================
    # HTTP → HTTPS
    # =============================
    server {
        listen 80;
        # Port 80 par HTTP requests sun raha hai

        server_name example.com www.example.com;
        # Kaun se domains ke liye ye server kaam kare

        return 301 https://$host$request_uri;
        # Har HTTP request ko HTTPS par permanently redirect kar do
    }


    # =============================
    # HTTPS SERVER
    # =============================
    server {
        listen 443 ssl http2;
        # Port 443 par HTTPS requests
        # ssl = encryption enable
        # http2 = fast HTTP/2 protocol enable

        server_name example.com www.example.com;
        # HTTPS ke liye domains define

        ssl_certificate /etc/letsencrypt/live/example.com/fullchain.pem;
        # SSL certificate file ka path (Let’s Encrypt)

        ssl_certificate_key /etc/letsencrypt/live/example.com/privkey.pem;
        # SSL private key ka path

        ssl_protocols TLSv1.2 TLSv1.3;
        # Sirf secure TLS versions allow

        ssl_ciphers HIGH:!aNULL:!MD5;
        # Strong encryption ciphers allow, weak ones block


        # =============================
        # SECURITY HEADERS
        # =============================
        add_header X-Frame-Options DENY;
        # Website ko iframe me load hone se roakta hai (clickjacking protection)

        add_header X-Content-Type-Options nosniff;
        # Browser ko content type guess karne se roakta hai

        add_header X-XSS-Protection "1; mode=block";
        # Basic XSS (cross-site scripting) protection


        # =============================
        # STATIC FILES (DIRECT SERVE)
        # =============================
        location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2|ttf|eot|otf)$ {
            # Ye regex static files (JS, CSS, images, fonts) match karta hai

            root /var/www/html;
            # Static files ka actual folder jahan se Nginx serve karega

            expires 30d;
            # Browser ko bolo 30 din tak file cache kar ke rakhe

            access_log off;
            # Static files ke liye access log band (performance improve hoti hai)

            add_header Cache-Control "public";
            # Browser aur CDN dono ko caching allow
        }


        # =============================
        # REVERSE PROXY
        # =============================
        location / {
            # Baqi sari requests (dynamic content) yahan aayengi

            proxy_pass http://app_servers;
            # Request ko backend servers ke group ko forward karo

            proxy_http_version 1.1;
            # Backend ke sath HTTP/1.1 use karo (keepalive ke liye)

            proxy_set_header Host $host;
            # Client ne jo domain request kiya wo backend ko bhejo

            proxy_set_header X-Real-IP $remote_addr;
            # Client ka real IP backend ko bhejo

            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            # Agar multiple proxies ho to poori IP chain bhejo

            proxy_set_header X-Forwarded-Proto $scheme;
            # Backend ko batao request HTTP se aayi ya HTTPS se
        }
    }
}
```
