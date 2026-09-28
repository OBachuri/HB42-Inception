*This project has been created as part of the 42 curriculum by obachuri.*

---

# Inception - Developer documentation

## 1. Prerequisites

| Requirement        | Notes                                         |
|--------------------|-----------------------------------------------|
| **Docker Engine**  | Must support Compose V2  (v20.10+)            |
| **Docker Compose** | Must be available as `docker compose` (v2.0+) |
| **GNU Make**       | Used for project shortcuts                    |
| **Git**            | To clone the repository                       |

`install_docker_deb.sh` - can be used to install **Docker** and **Docker compose** on Debian based system.


### 1.1. DNS on host

Add lint in /etc/hosts file on host:
```
127.0.0.1 obachuri.42.fr
```

## 2 Clone the repository

```bash
git clone <repository-url> inseption
cd inseption
```

## 3. Configuration & Secrets Setup

## 3.1. Environment variable (file:  srcs/.env):
Environment variable stored in file srcs/.env. The file containing domain definitions, usernames, and relative paths to secrets files.

## 3.2. Secrets Directory (secrets/):

Place plain text password files in the `secrets/` directory on the host:

| File                                | Purpose                                |
|-------------------------------------|----------------------------------------|
| `secrets/db_wp_user_password.txt`   | WordPress database user password       |
| `secrets/db_admin_password.txt`     | MariaDB admin password                 |
| `secrets/db_root_password.txt.txt`  | MariaDB root password                  |
| `secrets/mariadb_exporter_password.txt` | MariaDB user password for health checks and monitoring | 
| `secrets/ftp_user_password.txt`     | FTP user password                      |
| `secrets/wp_admin_password.txt`     | WordPress user password                |
| `secrets/wp_user_password.txt`      | WordPress admin password               |

## 3.3. Automatic Preparation 

```
make prepare
```
This create host volume storage directories under `/home/<USER_LOG>/data/`(`mariadb`, `wordpress`, `redis`) and Secrets files with random password if file not exist but requred.

## 4. Build & Launch

To build and start the entire stack:

```text
make up
```

## 5. Container & Volume Management

### 5.1. Container Management

* **`make up`** - Start existing containers without rebuilding images.
* **`make stop`** - Stop running containers without removing them.
* **`make start`** - Start stopped containers.
* **`make down`** - Stop and remove running containers and networks.


### 5.2. Inspection & Debugging

* **`make info`** - Display a comprehensive status overview of the stack.
* **`make logs`** - Tail real-time console output from all running services (`docker compose logs -f`).

### 5.3. Cleanup & Maintenance
* **`make clean`** - Stop containers, remove them along with networks, built images, and Docker internal volumes.
* **`make fclean`** - Perform a full system reset: runs `make clean` and recursively deletes all host storage directory contents in `/home/<USER_LOG>/data/*`.
* **`make re`** - make fclean + make up.

## 6. Data Storage & Persistence

Project data is permanently stored on the host filesystem and mounted into containers via **bind mounts**.

### Host Storage Location

All application data stored inside folder /home/\<User\>/data on the host machine:
* wp_db - MariaDB Database
* wp_files - WordPress Files
* v_nginx_cert - Certificate for HTTPS
* v_redis - Redis Cache
* v_prometheus_tsd - Prometheus data store



