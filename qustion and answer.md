# Easy DevOps Interview Questions & Answers: NGINX and Database

---

## NGINX Questions

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

