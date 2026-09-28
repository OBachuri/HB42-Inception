*This project has been created as part of the 42 curriculum by obachuri.*

---

# Inception - User Documentation

## 1. Overview

This project provides a complete web infrastructure running with Docker Compose.

The main request flow is:
```
                    Internet
                       |
                       v
                    NGINX
                       |
             +---------+---------+
             |                   |
             v                   v
         WordPress            Adminer
             |
       +-----+-----+
       |           |
       v           v
    MariaDB       Redis
```

Persistent files and database data are stored in Docker volumes or configured host directories.

Credentials are provided through Docker secrets.

The infrastructure can be started, stopped, monitored and recreated using Docker Compose.

### The main services:

| Service | Container Name | Role |
|---|---|---|
| **NGINX** | `nginx` | HTTPS web server and reverse proxy |
| **WordPress** | `wordpress` | CMS of Main website based on PHP-FPM |
| **MariaDB** | `mariadb` | Relational database backend (database used by WordPress)|
| **Redis** | `redis` | In-memory cache used to improve WordPress performance |
| **Adminer** | `adminer` | Web interface for managing the MariaDB database |
| **FTP Server** | `ftp_server` | FTP server for accessing WordPress files |
| **Simple Website** | `simple-site` | Static website about PacMan game|
| **Prometheus** | `prometheus` | Monitoring and metrics |

### Exposed Ports:

| Service | Host Port | Container Port | Protocol |
|---|---|---|---|
| NGINX | `443` | `443` | HTTPS |
| FTP Server | `21` | `21` | FTP Command |
| FTP Server | `21210-21220` | `21210-21220` | FTP Passive Data |
| Prometheus | `9090` | `9090` | HTTP |


## 2. Requirements

Before starting the project, make sure Docker and Docker Compose are installed.

Check Docker:

```docker --version```

Check Docker Compose:

```docker compose version```


## 3. Managing the Project

All operational commands must be executed using `make` from the repository root.

### 3.1. Configuration - Environment Variables & Credentials

Before starting the project, check the project configuration.

The main configuration is stored in `srcs/.env` file.

The .env file contains non-sensitive configuration such as the domain name and paths used by the project.

Passwords and other sensitive information are stored as Docker secrets.

Secrets stored in directory `secrets`:
| File                                | Purpose                                |
|-------------------------------------|----------------------------------------|
| `secrets/db_wp_user_password.txt`   | WordPress database user password       |
| `secrets/db_admin_password.txt`     | MariaDB admin password                 |
| `secrets/db_root_password.txt.txt`  | MariaDB root password                  |
| `secrets/mariadb_exporter_password.txt` | MariaDB user password for health checks and monitoring | 
| `secrets/ftp_user_password.txt`     | FTP user password                      |
| `secrets/wp_admin_password.txt`     | WordPress user password                |
| `secrets/wp_user_password.txt`      | WordPress admin password               |

To create example of secrets you could run:

```
make prepare
```

### 3.2. Starting the Project

```
make up
```

This command will:
* create the required host directories for persistent data,
* build the custom Docker images,
* start all services of the stack.

### 3.3. Stop the stack - stops and removes running containers
```
make down
```
### 3.4. Pause / Resume containers
**For all containers:**
```
make stop
make start
```
**For one container:**
```
make stop <container name>
make start <container name>
```

### 3.5. Clean containers and images
Stops stack, removes images and volumes created by Compose:
```
make clean
```

### 3.6. Full clean Up (full reset)
```
make fclean
```
Runs `make clean` and forcibly delete all persistent data on host in folders /home/\<USER\>/data/

## 4. Check services and health checks

### 4.1. Basic information and current status:
```
make info
```
Only status with health check:
```
docker compose -f srcs/docker-compose.yml ps
```

### 4.2. View logs
```
make logs <container name> 
docker compose -f srcs/docker-compose.yml logs <service_name>
docker compose -f srcs/docker-compose.yml logs -f
```

## 5. Access the website and the administration panel
- https://obachuri.42.fr - WordPress main page 
- https://obachuri.42.fr/wp-admin - WordPress admin panel 
- https://obachuri.42.fr/adminer - Adminer - SQL Database management in a single PHP file
- https://obachuri.42.fr/mysite - Simple html page
- https://obachuri.42.fr/game - PacMan game on pygbug+pygame
- http://obachuri.42.fr:9090 - Prometheus (monitoring)





