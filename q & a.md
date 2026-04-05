
## 1. What is Nginx?

Nginx is a **web server, reverse proxy, and load balancer** used for high-performance web applications.

---

## 2. Why is Nginx faster than Apache?

👉 Nginx is faster because it uses one process to handle many users at the same time.

👉 Apache is slower because it creates one thread or process for each user.
---

## 3. What is event-driven architecture?

A model where a small number of processes handle many requests asynchronously → **high performance & low memory usage**.

---

## 4. What is a worker process?

A process that handles incoming client requests.

---

## 5. What does the master process do?

It manages configuration and controls worker processes.

---

## 6. What is a reverse proxy?

A server that forwards client requests to backend servers and returns the response.

---

## 7. What is load balancing?

Distributing incoming traffic across multiple servers.

---

## 8. What load balancing methods does Nginx support?

* Round Robin (default)
* Least Connections
* IP Hash

---

## 9. What does `try_files` do?

It checks if files or directories exist and serves them; otherwise returns a fallback (e.g., 404).

---

## 10. What is a `location` block?

It defines how Nginx handles requests based on URL patterns.

---

## 11. Difference between `root` and `alias`?

* `root`: appends request URI to path
* `alias`: replaces the path completely

---

## 12. How do you handle 404 errors?

```nginx
error_page 404 /404.html;
```

---

## 13. Why is Nginx good for static files?

It serves files directly from disk without extra processing.

---

## 14. What is caching in Nginx?

Storing responses temporarily to improve performance.

---

## 15. How to enable SSL in Nginx?

```nginx
listen 443 ssl;
ssl_certificate /path/to/cert;
ssl_certificate_key /path/to/key;
```

---

## 16. What is Gzip compression?

It reduces response size to improve load speed.

---

## 17. Where are Nginx logs stored?

* access.log
* error.log

---

## 18. How do you test Nginx configuration?

```bash
nginx -t
```

---

## 19. Reload vs Restart?

* Reload: applies changes without downtime
* Restart: stops and starts the server

---

## 20. What is a 502 Bad Gateway error?

It means the backend server is not responding or is misconfigured.

---

