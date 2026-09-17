*This project has been created as part of the 42 curriculum by obachuri.*

---

# Inception - Studying Docker

---

## Description

This project aims to broaden your knowledge of system administration by using Docker.
 
### Project Architecture

![Chart - Project Architecture](inception-arch.png)


## Instructions

## Notes
- If you have access to run docker and to read files/folders - you could change or delete this files/folders. Rootless Docker solves this problem, but not completely.
```
	DATA_PATH = path_on_host_to_delete ;
	docker run --rm -v $(DATA_PATH):/data alpine sh -c 'rm -rf /data/*'
```


## Usage

Once the stack is running, the following endpoints are available:
- https://obachuri.42.fr — main WordPress admin
- https://obachuri.42.fr/wp-admin

## Resources
- [Docker documentation](https://docs.docker.com/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [NGINX documentation](https://nginx.org/en/docs/)
- [WordPress documentation](https://wordpress.org/documentation/)
- [WordPress & PHP-FPM Setup Guides](https://wiki.alpinelinux.org/wiki/WordPress)
- [MariaDB documentation](https://mariadb.com/kb/en/documentation/)
- [Redis documentation](https://redis.io/docs/)
- [OpenSSL documentation](https://www.openssl.org/docs/)
- [Start Bootstrap](https://startbootstrap.com/)
- [Prometheus - monitoring](https://prometheus.io/docs/instrumenting/exporters/)


### AI Usage
Tools Used: ChatGPT (GPT-5)

AI was used to conceptual understanding and to structuring this README to meet subject requirements.

## License

Part of the 42 curriculum project.
