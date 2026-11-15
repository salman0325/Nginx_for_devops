# Complete A to Z Guide: Apache Tomcat + Apache Server + Java Maven Project Deployment

Let's understand Tomcat from zero and then deploy one complete Java-based Maven project on Tomcat using Linux commands.

The goal is that you should be able to:

1. Understand what Apache and Tomcat are.
2. Install Tomcat on Linux (Ubuntu).
3. Understand every important Linux command.
4. Configure Tomcat users and permissions.
5. Start and stop Tomcat using shortcuts.
6. Create a Java Maven web application.
7. Build a WAR file.
8. Deploy your project on Tomcat.
9. Access your project through a browser.
10. Update your project after deployment without reinstalling Tomcat.
11. Troubleshoot common errors.

---

# PART 1: What is Apache?

There are two different technologies that people commonly call Apache.

## 1\. Apache HTTP Server

Apache HTTP Server  is a web server.

Its main job is to receive HTTP requests from users and serve websites.

For example:

- User enters `www.example.com`.
- Apache receives the request.
- Apache serves HTML, CSS, JavaScript, images, etc.

Its default port is:

text

```text
80 (HTTP)
443 (HTTPS)
```

## 2\. Apache Tomcat

Apache Tomcat  is a Java web application server (more precisely, a servlet container).

Its main job is to run Java web applications.

For example:

- You develop a Java web application.
- You build a WAR file using Maven.
- You deploy that WAR file on Tomcat.
- Tomcat runs your application.
- Users access your application through a browser.

Default Tomcat port:

text

```text
8080
```

## Apache vs Tomcat

| Apache HTTP Server | Apache Tomcat |
| --- | --- |
| Web server | Java servlet container |
| Mainly serves static content | Runs Java web applications |
| Default port 80 | Default port 8080 |
| Supports PHP through additional modules | Supports Java Servlets and JSP |
| Handles HTTP requests | Executes Java web application logic |

**Remember: Apache is an organization/project name. Apache HTTP Server and Apache Tomcat are two different products.**

---

# PART 2: How Java + Maven + Tomcat Work Together

Understand this flow:

text

```text
Developer
    |
    v
Java Application
    |
    v
Maven Build Tool
    |
    v
WAR File
    |
    v
Apache Tomcat
    |
    v
Browser
    |
    v
http://localhost:8080/myapp
```

### What is Java?

Java is a programming language used to develop applications.

### What is Maven?

Apache Maven  is a build automation tool.

It helps you:

- Compile Java code.
- Download dependencies.
- Run tests.
- Package applications.
- Generate JAR and WAR files.

### What is a WAR file?

WAR stands for Web Application Archive.

Example:

text

```text
myapp.war
```

It contains your Java web application and its required web resources.

Tomcat can deploy this WAR file.

**Important:** A regular Java JAR application is not automatically deployable on Tomcat. For this tutorial, we will create a Java web application packaged as a WAR.

# PART 3: Install Java, Maven and Tomcat on Ubuntu

We will use:

- Operating system: Ubuntu Linux
- Java: JDK 17
- Build tool: Maven
- Server: Apache Tomcat 11
- Project: Java Servlet Web Application

Tomcat 11 requires Java 17 or later. Also, Tomcat 10 and 11 use `jakarta.*` packages instead of the older `javax.*` packages.  Apache Tomcat+1

## Step 1: Update Linux

bash

```bash
sudo apt update
sudo apt upgrade -y
```

Meaning:

- `sudo`: Run command with administrator privileges.
- `apt`: Ubuntu package manager.
- `update`: Update package information.
- `upgrade`: Upgrade installed packages.
- `-y`: Automatically confirm installation prompts.

## Step 2: Install Java

bash

```bash
sudo apt install openjdk-17-jdk -y
```

Check Java:

bash

```bash
java -version
```

Check Java compiler:

bash

```bash
javac -version
```

Check Java location:

bash

```bash
which java
```

Check Java environment:

bash

```bash
echo $JAVA_HOME
```

If JAVA\_HOME is empty, configure it:

bash

```bash
sudo vi /etc/profile.d/java.sh
```

Add:

bash

```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
```

Save and exit.

Apply:

bash

```bash
source /etc/profile.d/java.sh
```

Verify:

bash

```bash
echo $JAVA_HOME
```

Note: The path above assumes a standard 64-bit Ubuntu installation. Check your actual JDK directory if it differs.

## Step 3: Install Maven

bash

```bash
sudo apt install maven -y
```

Check:

bash

```bash
mvn -version
```

You should see Java and Maven version information.

Official Maven installation guide: [Apache Maven Installation](<https://maven.apache.org/install?utm_source=chatgpt.com>)

---

# PART 4: Download and Install Apache Tomcat

## Step 1: Go to the opt directory

bash

```bash
cd /opt
```

What is `/opt`?

It is a Linux directory commonly used for installing additional software.

For example:

text

```text
/opt
   |
   |--- apache-tomcat
   |
   |--- apache-maven
   |
   |--- other software
```

## Step 2: Download Tomcat

Official download website:

[Apache Tomcat Official Download Page](<https://tomcat.apache.org/download-11?utm_source=chatgpt.com>)

For this tutorial, use Tomcat 11.

You can download the binary archive using:

bash

```bash
cd /opt

sudo wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.29/bin/apache-tomcat-11.0.29.tar.gz
```

This is the download URL for the Linux `.tar.gz` distribution.

## Step 3: Extract Tomcat

bash

```bash
sudo tar -xvzf apache-tomcat-11.0.29.tar.gz
```

Meaning:

- `tar`: Archive management command.
- `x`: Extract.
- `v`: Show extracted files.
- `z`: Handle gzip compression.
- `f`: Specify archive filename.

Now check:

bash

```bash
ls -lrt
```

You should see:

text

```text
apache-tomcat-11.0.29
apache-tomcat-11.0.29.tar.gz
```

## Step 4: Rename Tomcat directory

To make future commands easier:

bash

```bash
sudo mv apache-tomcat-11.0.29 apache-tomcat
```

Now:

text

```text
/opt/apache-tomcat
```

This will be our permanent Tomcat installation directory.

## Step 5: Give execution permissions

bash

```bash
sudo chmod +x /opt/apache-tomcat/bin/*.sh
```

This allows the shell scripts to execute.

Check:

bash

```bash
ls -l /opt/apache-tomcat/bin/
```

Important directories inside Tomcat:

text

```text
apache-tomcat/
    |
    |--- bin/
    |      startup.sh
    |      shutdown.sh
    |      catalina.sh
    |
    |--- conf/
    |      server.xml
    |      tomcat-users.xml
    |
    |--- logs/
    |
    |--- webapps/
    |
    |--- lib/
    |
    |--- temp/
    |
    |--- work/
```

### What are these directories?

| Directory | Purpose |
| --- | --- |
| bin | Start and stop scripts |
| conf | Configuration files |
| logs | Server logs |
| webapps | Deployed Java applications |
| lib | Tomcat libraries |
| temp | Temporary files |
| work | Compiled JSP and working files |

---

# PART 5: Start and Stop Tomcat

## Start Tomcat

bash

```bash
cd /opt/apache-tomcat/bin
```

Run:

bash

```bash
sudo ./startup.sh
```

Expected output:

text

```text
Tomcat started.
```

## Stop Tomcat

bash

```bash
sudo ./shutdown.sh
```

## Check Tomcat process

bash

```bash
ps -ef | grep tomcat
```

## Check port 8080

bash

```bash
sudo ss -ltnp | grep 8080
```

## Open Tomcat in your browser

text

```text
http://YOUR_SERVER_IP:8080
```

If you're testing on your own Ubuntu machine:

text

```text
http://localhost:8080
```

You should see the Tomcat welcome page.

**What happens internally?**

When you execute:

bash

```bash
startup.sh
```

Tomcat starts its Java process and listens for HTTP requests on port 8080.

When you execute:

bash

```bash
shutdown.sh
```

Tomcat shuts down that process gracefully.

---

# PART 6: Create Shortcuts for Tomcat

You mentioned these commands:

bash

```bash
sudo stoptomcat
sudo starttomcat
```

We can configure exactly that.

First, create symbolic links.

### Start shortcut

bash

```bash
sudo ln -s /opt/apache-tomcat/bin/startup.sh /usr/local/bin/starttomcat
```

### Stop shortcut

bash

```bash
sudo ln -s /opt/apache-tomcat/bin/shutdown.sh /usr/local/bin/stoptomcat
```

Notice:

- Correct directory: `/usr/local/bin`
- Not `/user/bin`
- `ln -s` creates a symbolic link.

Now execute:

bash

```bash
sudo starttomcat
```

Stop:

bash

```bash
sudo stoptomcat
```

Check:

bash

```bash
ls -l /usr/local/bin/starttomcat
ls -l /usr/local/bin/stoptomcat
```

You have now created your own Tomcat commands\!

---

# PART 7: Configure Tomcat Users

Tomcat provides a Manager application through which you can deploy and manage web applications.

Its URL is:

text

```text
http://localhost:8080/manager/html
```

However, you need to configure a user with the appropriate role.

## Step 1: Open tomcat-users.xml

bash

```bash
sudo vi /opt/apache-tomcat/conf/tomcat-users.xml
```

Go to the bottom, before:

xml

```xml
</tomcat-users>
```

Add:

xml

```xml
<role rolename="manager-gui"/>

<user username="admin"
      password="ChangeThisStrongPassword"
      roles="manager-gui"/>
```

Save the file.

In VI:

- Press `i` to enter insert mode.
- Write your configuration.
- Press `Esc`.
- Type `:wq`.
- Press Enter.

## Step 2: Understand the roles

| Role | Purpose |
| --- | --- |
| manager-gui | Access Manager web interface |
| manager-script | Access Manager through scripts/API |
| manager-status | View server status |
| manager-jmx | Access JMX proxy |

For this tutorial, `manager-gui` is enough.

## Step 3: Manager access configuration

Open:

bash

```bash
sudo vi /opt/apache-tomcat/webapps/manager/META-INF/context.xml
```

Tomcat normally restricts Manager access to localhost using a Remote Address Valve.

**Important:** Do not remove this restriction or expose the Manager application publicly just to make remote deployment work. Keep management access restricted to localhost or a trusted administrative network.

Restart Tomcat:

bash

```bash
sudo stoptomcat
sudo starttomcat
```

Then open:

text

```text
http://localhost:8080/manager/html
```

Log in using your configured username and password.

For production environments, use strong credentials, HTTPS and restricted administrative access.

# PART 8: Create One Complete Java Maven Project

Now we will create a real Java web application.

Our project name:

text

```text
salman-app
```

The application will display:

text

```text
Welcome to Salman Java Application!
Tomcat is running successfully.
```

## Step 1: Create project directory

bash

```bash
cd /home
mkdir salman
cd salman
```

Create project:

bash

```bash
mkdir salman-app
cd salman-app
```

Create the directory structure:

bash

```bash
mkdir -p src/main/java/com/salman
mkdir -p src/main/webapp
```

Your project structure will be:

text

```text
salman-app/
    |
    |--- pom.xml
    |
    |--- src/
           |
           |--- main/
                  |
                  |--- java/
                  |      |
                  |      |--- com/
                  |             |
                  |             |--- salman/
                  |                    |
                  |                    |--- HomeServlet.java
                  |
                  |--- webapp/
                         |
                         |--- index.html
```

## Step 2: Create pom.xml

bash

```bash
vi pom.xml
```

Add:

xml

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
         https://maven.apache.org/xsd/maven-4.0.0.xsd">

    <modelVersion>4.0.0</modelVersion>

    <groupId>com.salman</groupId>
    <artifactId>salman-app</artifactId>
    <version>1.0</version>

    <packaging>war</packaging>

    <name>Salman Java Application</name>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>

        <dependency>
            <groupId>jakarta.servlet</groupId>
            <artifactId>jakarta.servlet-api</artifactId>
            <version>6.1.0</version>
            <scope>provided</scope>
        </dependency>

    </dependencies>

    <build>
        <finalName>salman-app</finalName>

        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.13.0</version>
            </plugin>
        </plugins>

    </build>

</project>
```

### Understand important Maven terms

| Term | Meaning |
| --- | --- |
| groupId | Organization or project group |
| artifactId | Project name |
| version | Project version |
| packaging | JAR or WAR |
| dependencies | External libraries |
| provided | Library supplied by the server |
| finalName | Final generated WAR filename |

**Important:** We use `packaging` as `war` because Tomcat deploys Java web applications packaged as WAR files.

## Step 3: Create Java Servlet

bash

```bash
vi src/main/java/com/salman/HomeServlet.java
```

Add:

java

```java
package com.salman;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        response.getWriter().println(
            "<html>" +
            "<body>" +
            "<h1>Welcome to Salman Java Application!</h1>" +
            "<h2>Tomcat is running successfully.</h2>" +
            "</body>" +
            "</html>"
        );
    }
}
```

This is a Java Servlet.

A Servlet handles HTTP requests.

For example:

text

```text
Browser
   |
   v
GET /salman-app/home
   |
   v
Tomcat
   |
   v
HomeServlet.java
   |
   v
HTML Response
```

## Step 4: Create index.html

bash

```bash
vi src/main/webapp/index.html
```

Add:

HTMLWrap linesCopy codePreview

```html
<!DOCTYPE html>
<html>
<head>
    <title>Salman Application</title>
</head>
<body>

    <h1>Welcome to My Java Project</h1>

    <p>My first Maven and Tomcat application.</p>

    <a href="home">Click Here</a>

</body>
</html>
```

Save the file.

---

# PART 9: Build the Maven Project

This is one of the most important sections.

Go to the project root:

bash

```bash
cd /home/salman/salman-app
```

Check files:

bash

```bash
ls
```

Expected:

text

```text
pom.xml
src
```

## Step 1: Clean the project

bash

```bash
mvn clean
```

What does clean do?

It deletes the previous build output, normally the `target` directory.

## Step 2: Package the project

bash

```bash
mvn package
```

What does package do?

1. Compiles Java files.
2. Resolves dependencies.
3. Runs tests if configured.
4. Packages the application.
5. Creates a WAR file.

You can run both commands together:

bash

```bash
mvn clean package
```

You may also use:

bash

```bash
mvn clean package -DskipTests
```

This skips tests, which can be useful during development but should not replace testing before production deployment.

## Step 3: Check target directory

bash

```bash
ls
```

You should now see:

text

```text
pom.xml
src
target
```

Go inside:

bash

```bash
cd target
```

Check:

bash

```bash
ls -lrt
```

Expected:

text

```text
salman-app.war
```

This is your final deployment file.

**Remember this relationship:**

text

```text
Java Source Code
       |
       v
    Maven
       |
       v
     Build
       |
       v
    target/
       |
       v
 salman-app.war
```

---

# PART 10: Deploy WAR File on Tomcat

Now we have:

text

```text
/opt/apache-tomcat
```

And:

text

```text
/home/salman/salman-app/target/salman-app.war
```

We need to copy the WAR file into Tomcat's `webapps` directory.

## Step 1: Stop Tomcat

bash

```bash
sudo stoptomcat
```

## Step 2: Copy WAR file

bash

```bash
sudo cp /home/salman/salman-app/target/salman-app.war /opt/apache-tomcat/webapps/
```

Understand:

- `cp`: Copy files.
- First path: Source file.
- Second path: Destination directory.

## Step 3: Start Tomcat

bash

```bash
sudo starttomcat
```

Tomcat will automatically detect and deploy the WAR file.

## Step 4: Check deployment

bash

```bash
ls -lrt /opt/apache-tomcat/webapps/
```

You should see:

text

```text
ROOT/
docs/
examples/
host-manager/
manager/
salman-app.war
salman-app/
```

The extracted `salman-app` directory indicates that Tomcat has expanded the WAR file.

## Step 5: Open your application

Open your browser:

text

```text
http://YOUR_SERVER_IP:8080/salman-app/
```

For the Servlet:

text

```text
http://YOUR_SERVER_IP:8080/salman-app/home
```

If using the same machine:

text

```text
http://localhost:8080/salman-app/
```

Congratulations\! You have deployed your first Java Maven project on Apache Tomcat.

---

# PART 11: Most Important Tomcat Commands

These are the commands you should practice regularly.

| Command | Purpose |
| --- | --- |
| `sudo starttomcat` | Start Tomcat |
| `sudo stoptomcat` | Stop Tomcat |
| `sudo ./startup.sh` | Start Tomcat directly |
| `sudo ./shutdown.sh` | Stop Tomcat directly |
| `ps -ef \| grep tomcat` | Check Tomcat process |
| `sudo ss -ltnp \| grep 8080` | Check port 8080 |
| `ls /opt/apache-tomcat/webapps` | Check deployed applications |
| `ls /opt/apache-tomcat/logs` | Check log files |
| `tail -f /opt/apache-tomcat/logs/catalina.out` | Monitor logs |
| `sudo chmod +x filename.sh` | Give execution permission |
| `sudo chown -R user:user directory` | Change ownership |
| `sudo cp file destination` | Copy files |
| `sudo mv old new` | Move or rename |
| `sudo rm filename` | Remove a file |

## Important Linux commands from your notes

| Command | Explanation |
| --- | --- |
| `mkdir salman` | Create directory |
| `cd salman` | Enter directory |
| `pwd` | Display current directory |
| `touch a.txt` | Create empty file |
| `cp a.txt b.txt` | Copy file |
| `mv a.txt b.txt` | Rename or move file |
| `ls` | List files |
| `ls -lrt` | List files by modification time |
| `ls -la` | Show hidden files and permissions |
| `rm a.txt` | Delete file |
| `rm -r directory` | Delete directory recursively |
| `vi filename` | Edit file |
| `cat filename` | Display file content |
| `sudo` | Run as administrator |
| `wget URL` | Download a file |
| `tar -xvzf file.tar.gz` | Extract a compressed archive |

**Very important warning about your command:**

bash

```bash
rm -rf *
```

This deletes everything in the current directory recursively and without confirmation.

Never execute it unless you have checked your current location and are absolutely certain you want to delete everything there.

Use:

bash

```bash
pwd
ls
```

before deleting anything.

# PART 12: What Happens When You Make Changes After Deployment?

This is probably the most important thing to understand in real DevOps work.

Suppose you have already deployed your project:

text

```text
/opt/apache-tomcat/webapps/salman-app.war
```

Your application is running:

text

```text
http://localhost:8080/salman-app/
```

Now your manager asks you:

"Please change the welcome message and deploy the latest code."

What will you do?

You do NOT need to install Tomcat again.

You only need to build a new WAR and deploy it.

## Scenario 1: Update existing Java code

Open your Java file:

bash

```bash
cd /home/salman/salman-app

vi src/main/java/com/salman/HomeServlet.java
```

Change:

java

```java
<h1>Welcome to Salman Java Application!</h1>
```

To:

java

```java
<h1>Welcome to Updated Java Application!</h1>
```

## Scenario 2: Build the updated project

bash

```bash
mvn clean package
```

Your new WAR will be generated:

text

```text
target/salman-app.war
```

## Scenario 3: Deploy the updated WAR

Stop Tomcat:

bash

```bash
sudo stoptomcat
```

Remove the previous deployed WAR and application directory:

bash

```bash
sudo rm -f /opt/apache-tomcat/webapps/salman-app.war

sudo rm -rf /opt/apache-tomcat/webapps/salman-app
```

Copy the new WAR:

bash

```bash
sudo cp target/salman-app.war /opt/apache-tomcat/webapps/
```

Start Tomcat:

bash

```bash
sudo starttomcat
```

Open:

text

```text
http://localhost:8080/salman-app/
```

You will see the updated application.

**This process is called redeployment.**

In production, first back up the existing WAR and use a controlled deployment procedure to avoid losing a working version.

## Scenario 3: What if a completely new project comes?

Suppose tomorrow you receive another project:

text

```text
employee-management
```

You do not need another Tomcat installation.

You can deploy another WAR:

bash

```bash
sudo cp employee-management.war /opt/apache-tomcat/webapps/
```

Tomcat automatically deploys it.

Your webapps directory:

text

```text
webapps/
    |
    |--- manager/
    |
    |--- ROOT/
    |
    |--- salman-app.war
    |
    |--- employee-management.war
```

Applications:

text

```text
http://localhost:8080/salman-app/

http://localhost:8080/employee-management/
```

**One Tomcat server can host multiple Java web applications.**

---

# PART 13: Important Tomcat Configuration Files

You should know these four files.

## 1\. server.xml

Location:

bash

```bash
/opt/apache-tomcat/conf/server.xml
```

Purpose:

- Configure server ports.
- Configure HTTP connectors.
- Configure HTTPS connectors.
- Configure hosts.
- Configure server-level settings.

For example:

xml

```xml
<Connector port="8080"
           protocol="HTTP/1.1"
           connectionTimeout="20000"/>
```

If you change port 8080 to 9090, your application URL changes to:

text

```text
http://localhost:9090/salman-app/
```

## 2\. tomcat-users.xml

Location:

bash

```bash
/opt/apache-tomcat/conf/tomcat-users.xml
```

Purpose:

- Configure Tomcat users.
- Configure roles.
- Configure Manager access.

## 3\. context.xml

Location:

bash

```bash
/opt/apache-tomcat/conf/context.xml
```

Purpose:

- Application context configuration.
- Resource configuration.
- Session-related settings.
- Application behavior.

There can also be an application-specific context.xml.

## 4\. web.xml

Location:

text

```text
Your project/src/main/webapp/WEB-INF/web.xml
```

Purpose:

- Configure servlets.
- Configure filters.
- Configure listeners.
- Configure welcome pages.
- Configure application settings.

---

# PART 14: Tomcat Logs and Troubleshooting

In real DevOps jobs, you will frequently work with logs.

Suppose your application is not opening.

What will you do?

## 1\. Check whether Tomcat is running

bash

```bash
ps -ef | grep tomcat
```

## 2\. Check whether port 8080 is listening

bash

```bash
sudo ss -ltnp | grep 8080
```

## 3\. Check Tomcat logs

bash

```bash
cd /opt/apache-tomcat/logs
```

List logs:

bash

```bash
ls -lrt
```

Read the main log:

bash

```bash
tail -100 catalina.out
```

Continuously monitor:

bash

```bash
tail -f catalina.out
```

Exit using:

text

```text
CTRL + C
```

## Common Tomcat errors

| Error | Possible reason | Solution |
| --- | --- | --- |
| 404 Not Found | Incorrect application URL | Check WAR name and context path |
| 500 Internal Server Error | Java application error | Check application logs |
| 403 Forbidden | Access restriction | Check Manager permissions |
| 8080 already in use | Another process uses port | Identify the process |
| Tomcat not starting | Java or configuration problem | Check logs |
| ClassNotFoundException | Missing dependency | Check Maven dependencies |
| UnsupportedClassVersionError | Java version mismatch | Check JDK versions |
| Permission denied | Incorrect file permissions | Check ownership and permissions |

### Important: Check firewall

If you are accessing Tomcat from another machine, Ubuntu firewall may block port 8080.

Check:

bash

```bash
sudo ufw status
```

If external access is required, configure the firewall to allow only trusted sources rather than exposing Tomcat management interfaces publicly.

---

# PART 15: Understand the Complete DevOps Deployment Workflow

Now imagine you work in a company as a Junior DevOps Engineer.

Developers write Java code.

You manage the deployment.

This is a common workflow:

text

```text
       Developer
           |
           |
           v
      Java Source Code
           |
           v
          Git
           |
           v
       GitHub/GitLab
           |
           v
         Jenkins
           |
           v
         Maven
           |
           v
      mvn clean package
           |
           v
       WAR File
           |
           v
     Apache Tomcat
           |
           v
      Port 8080
           |
           v
         Browser
```

Let's understand each component.

| Technology | Responsibility |
| --- | --- |
| Java | Application development |
| Git | Version control |
| GitHub | Store source code |
| Jenkins | Automate deployment |
| Maven | Build Java project |
| WAR | Application deployment package |
| Tomcat | Run Java web application |
| Linux | Host the application |
| Nginx | Reverse proxy (optional) |

Eventually, you can automate the deployment process using Jenkins.

Instead of manually executing:

bash

```bash
mvn clean package
```

And:

bash

```bash
sudo cp target/salman-app.war /opt/apache-tomcat/webapps/
```

Jenkins can perform the build and deployment steps automatically.

---

# PART 16: Your Complete Tomcat Practical Command Sheet

Save these commands for practice.

### A. Linux basic commands

bash

```bash
mkdir salman

cd salman

pwd

touch a.txt

touch b.txt

mkdir project

ls

ls -lrt

ls -la

cp a.txt b.txt

mv a.txt new.txt

cat new.txt

vi new.txt

cd ..

```

### B. Install Java and Maven

bash

```bash
sudo apt update

sudo apt install openjdk-17-jdk -y

java -version

javac -version

sudo apt install maven -y

mvn -version
```

### C. Install Tomcat

bash

```bash
cd /opt

sudo wget https://dlcdn.apache.org/tomcat/tomcat-11/v11.0.29/bin/apache-tomcat-11.0.29.tar.gz

sudo tar -xvzf apache-tomcat-11.0.29.tar.gz

sudo mv apache-tomcat-11.0.29 apache-tomcat

sudo chmod +x /opt/apache-tomcat/bin/*.sh
```

### D. Create Tomcat shortcuts

bash

```bash
sudo ln -s /opt/apache-tomcat/bin/startup.sh /usr/local/bin/starttomcat

sudo ln -s /opt/apache-tomcat/bin/shutdown.sh /usr/local/bin/stoptomcat
```

### E. Start and stop

bash

```bash
sudo starttomcat

sudo stoptomcat
```

### F. Check Tomcat

bash

```bash
ps -ef | grep tomcat

sudo ss -ltnp | grep 8080

ls -lrt /opt/apache-tomcat/webapps/

tail -f /opt/apache-tomcat/logs/catalina.out
```

### G. Build Java project

bash

```bash
cd /home/salman/salman-app

mvn clean

mvn package

mvn clean package

ls

cd target

ls -lrt
```

### H. Deploy project

bash

```bash
sudo stoptomcat

sudo cp /home/salman/salman-app/target/salman-app.war /opt/apache-tomcat/webapps/

sudo starttomcat
```

### I. Check deployed project

bash

```bash
ls -lrt /opt/apache-tomcat/webapps/
```

Browser:

text

```text
http://localhost:8080/salman-app/
```

---

# PART 17: What Should You Learn After Tomcat?

For a Java-based DevOps project, I recommend learning in this order:

| Level | Technology | What you learn |
| --- | --- | --- |
| 1 | Linux | Commands, directories, permissions |
| 2 | Java | Application basics |
| 3 | Maven | Build WAR/JAR |
| 4 | Tomcat | Deploy Java applications |
| 5 | Git | Clone, commit, push, pull |
| 6 | GitHub | Source code management |
| 7 | Jenkins | CI/CD automation |
| 8 | SonarQube | Code quality |
| 9 | Nexus | Artifact management |
| 10 | Docker | Containerize applications |
| 11 | Kubernetes | Container orchestration |
| 12 | Nginx | Reverse proxy and web traffic |

Official learning resources:

- [Apache Tomcat Documentation](<https://tomcat.apache.org/tomcat-11.0-doc/?utm_source=chatgpt.com>)
- [Apache Maven Documentation](<https://maven.apache.org/guides/?utm_source=chatgpt.com>)
- [Java Documentation](<https://docs.oracle.com/en/java/?utm_source=chatgpt.com>)

---

# PART 18: Interview Questions You Should Know

**Q1. What is Apache Tomcat?**

Tomcat is an open-source Java servlet container used to run Java web applications.

**Q2. What is the default Tomcat port?**

8080.

**Q3. Where do we deploy WAR files?**

Inside:

text

```text
/opt/apache-tomcat/webapps/
```

**Q4. What is the difference between JAR and WAR?**

- JAR: Java Archive, commonly used for libraries and standalone Java applications.
- WAR: Web Application Archive, used for deploying Java web applications on servlet containers such as Tomcat.

**Q5. How do you start Tomcat?**

bash

```bash
sudo /opt/apache-tomcat/bin/startup.sh
```

**Q6. How do you stop Tomcat?**

bash

```bash
sudo /opt/apache-tomcat/bin/shutdown.sh
```

**Q7. What is the purpose of the webapps directory?**

It stores Java web applications deployed on Tomcat.

**Q8. What is the purpose of the conf directory?**

It stores Tomcat configuration files.

**Q9. What is Maven?**

Maven is a Java build automation and dependency management tool.

**Q10. What does****`mvn clean package`****do?**

It removes previous build output, compiles the project, runs configured tests and generates the application package.

**Q11. Can one Tomcat server run multiple applications?**

Yes. Multiple WAR applications can be deployed on the same Tomcat instance.

**Q12. What happens if you change Java code after deployment?**

Build a new WAR and redeploy it. You do not need to reinstall Tomcat.

---

## My recommendation: Complete this one practical project

Don't just memorize commands. Practice this complete scenario:

1. Install Java.
2. Install Maven.
3. Download Tomcat.
4. Start Tomcat.
5. Create Tomcat shortcuts.
6. Configure a Manager user.
7. Create a Java Maven project.
8. Run `mvn clean package`.
9. Find the WAR inside `target`.
10. Deploy the WAR to Tomcat.
11. Open the application in your browser.
12. Change the Java code.
13. Build a new WAR.
14. Redeploy the updated WAR.
15. Check Tomcat logs when something goes wrong.
16. Deploy a second application on the same Tomcat.

\*\*Once you can perform these 16 tasks without looking at the notes, you will have a solid practical foundation in Java application deployment using Tomcat.\*\*
