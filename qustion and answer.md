
# DevOps Interview Questions and Answers: NGINX & Databases

---

## NGINX Questions

### 1. What is NGINX and what are its common uses?

**Answer:**
NGINX is a high-performance HTTP server, reverse proxy, and load balancer. It is commonly used to serve static content, proxy requests to backend servers, and perform load balancing.

---

### 2. What is the difference between NGINX and Apache?

**Answer:**

* NGINX uses an event-driven architecture, handling many connections efficiently.
* Apache uses a process-driven model, spawning new processes per connection.
* NGINX is better for high concurrency and static content, Apache offers more extensive features and .htaccess support.

---

### 3. How do you configure NGINX as a reverse proxy?

**Answer:**
In the NGINX configuration file:

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://backend_server;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

---

### 4. How can you enable SSL in NGINX?

**Answer:**
By adding the `listen 443 ssl` directive and specifying the certificate and key paths:

```nginx
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://backend;
    }
}
```

---

### 5. What is load balancing in NGINX and how do you configure it?

**Answer:**
Load balancing distributes traffic across multiple backend servers to improve performance and reliability. Configuration example:

```nginx
upstream backend {
    server backend1.example.com;
    server backend2.example.com;
}

server {
    listen 80;

    location / {
        proxy_pass http://backend;
    }
}
```

---

### 6. What are some common NGINX directives used for performance tuning?

**Answer:**

* `worker_processes` — Number of worker processes
* `worker_connections` — Maximum connections per worker
* `keepalive_timeout` — Timeout for keep-alive connections
* `client_max_body_size` — Max client request body size

---

### 7. Scenario: Your NGINX server is slow when handling many simultaneous connections. What do you check?

**Answer:**

* Check `worker_processes` and increase to number of CPU cores
* Increase `worker_connections` for more simultaneous connections
* Monitor resource usage (CPU, memory)
* Enable caching if possible
* Check backend server health

---

### 8. How do you restrict access to certain IPs in NGINX?

**Answer:**

```nginx
location /admin {
    allow 192.168.1.0/24;
    deny all;
}
```

---

### 9. What is the difference between `include` and `load_module` in NGINX config?

**Answer:**

* `include` inserts config files at runtime for modularity.
* `load_module` loads binary dynamic modules into NGINX.

---

### 10. How do you enable Gzip compression in NGINX?

**Answer:**

```nginx
gzip on;
gzip_types text/plain application/json text/css application/javascript;
gzip_min_length 256;
```

---

## Database Questions

### 11. What types of databases are commonly used in DevOps environments?

**Answer:**
Relational databases like MySQL, PostgreSQL; NoSQL databases like MongoDB, Redis, Cassandra.

---

### 12. What is database replication and why is it important?

**Answer:**
Replication copies data from one database server (master) to others (slaves) for redundancy, high availability, and load balancing.

---

### 13. What is the difference between a primary key and a foreign key?

**Answer:**

* Primary key uniquely identifies a row in a table.
* Foreign key is a field that links to a primary key in another table.

---

### 14. What is connection pooling?

**Answer:**
Connection pooling reuses database connections to improve performance and reduce overhead in opening/closing connections.

---

### 15. Scenario: Your application is experiencing slow database queries under load. How would you troubleshoot?

**Answer:**

* Analyze slow query logs
* Check indexing on tables
* Monitor resource usage on DB server
* Optimize queries or schema
* Consider read replicas or caching layers

---

### 16. How do you backup and restore a MySQL database?

**Answer:**

* Backup: `mysqldump -u user -p dbname > backup.sql`
* Restore: `mysql -u user -p dbname < backup.sql`

---

### 17. What is ACID in databases?

**Answer:**
ACID stands for Atomicity, Consistency, Isolation, Durability — properties ensuring reliable transaction processing.

---

### 18. How do you monitor database performance in production?

**Answer:**
Use tools like `pg_stat_activity` (Postgres), `SHOW PROCESSLIST` (MySQL), Prometheus exporters, or cloud provider monitoring solutions.

---

### 19. Scenario: You want to migrate your database schema with minimal downtime. How do you approach this?

**Answer:**

* Use online schema migration tools like Liquibase or Flyway
* Apply backward-compatible changes first
* Roll out application updates incrementally
* Perform tests on staging environment

---

### 20. What is database sharding and when would you use it?

**Answer:**
Sharding splits a large database into smaller pieces (shards) distributed across servers to improve performance and scalability. Use it when the dataset is too large for a single server.

---

If you want, I can prepare a `README.md` file with these Q&As for you as well. Would you like that?
