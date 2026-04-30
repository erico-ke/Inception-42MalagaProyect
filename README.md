*This project has been created as part of the 42 curriculum by erico-ke.*

# Inception

## Description
Inception is a Docker-based infrastructure project that deploys a small but complete web stack with MariaDB, WordPress, PHP-FPM, and Nginx.

The goal is to build and orchestrate the services from source using custom Dockerfiles, configuration files, and startup scripts. The stack runs on a single host, exposes the website over HTTPS, and keeps the database and application data persistent across container restarts.

## Project Description
This repository includes the project sources needed to build the infrastructure:

- a root `Makefile` to create the data directories, prepare the environment, and start or stop the stack;
- `srcs/docker-compose.yml` to define the services, networks, ports, and volumes;
- a MariaDB image with a custom configuration file and initialization script;
- a WordPress image with PHP-FPM setup and first-run application bootstrapping;
- an Nginx image configured as the HTTPS reverse proxy and entry point.

Docker is used to isolate each service, define explicit dependencies, and keep the deployment reproducible. The application is assembled from small, service-specific images instead of relying on prebuilt all-in-one containers.

### Main Design Choices
- MariaDB runs in its own container and stores its data on the host so the database survives container recreation.
- WordPress runs with PHP-FPM and is reached only through Nginx.
- Nginx terminates TLS and forwards PHP requests to the WordPress container.
- The services communicate through a dedicated Docker network instead of exposing internal ports to the host.
- Credentials and service settings are centralized in `srcs/.env` and copied to `/home/erico-ke/.env` by the Makefile when the stack starts.

### Required Comparisons
#### Virtual Machines vs Docker
- Virtual machines virtualize a full operating system for each guest and usually consume more CPU, memory, and disk space.
- Docker shares the host kernel and isolates processes with containers, which makes startup faster and the stack lighter.
- For this project, Docker is a better fit because the goal is to deploy several coordinated services with minimal overhead, not to emulate full independent machines.

#### Secrets vs Environment Variables
- Secrets are designed to store sensitive data outside the image and provide stricter handling than plain text configuration.
- Environment variables are simpler to use and are sufficient for this educational project, but they are easier to expose accidentally.
- This stack uses a `.env` file because it is straightforward to integrate with Docker Compose and the project requirements, while still keeping credentials out of the Dockerfiles themselves.

#### Docker Network vs Host Network
- A Docker network isolates containers and lets them talk to each other through service names such as `mariadb` and `wordpress`.
- Host networking removes that isolation and exposes the container directly on the host network namespace.
- This project uses a dedicated Docker network because it keeps the internal services separated, makes the topology explicit, and allows the Nginx container to reach WordPress without exposing internal ports.

#### Docker Volumes vs Bind Mounts
- Bind mounts map a specific host path into a container, which makes the storage location explicit and easy to inspect.
- Docker volumes are managed by Docker and are more portable across environments.
- This project uses a bind mount for MariaDB data so the database files live in `/home/erico-ke/data/mariadb`, and it uses a Docker-managed volume for WordPress files so the application content persists without tying it to a specific host path.

## Instructions
1. Install Docker, Docker Compose, and Make.
2. Edit `srcs/.env` if you want to change the domain name, database credentials, or WordPress credentials.
3. Add the domain used by the project to your local hosts file if needed, so `erico-ke.42.fr` resolves to your machine.
4. Run `make` or `make build` from the repository root.
5. Open `https://erico-ke.42.fr` in your browser and accept the self-signed certificate warning if shown.

Useful Make targets:

- `make` starts the stack.
- `make build` rebuilds the images and starts the stack.
- `make down` stops the containers.
- `make re` fully resets the stack and starts it again.
- `make clean` stops the stack and removes Docker artifacts aggressively.
- `make fclean` removes containers, volumes, and local project data.

## Resources
- Docker documentation: https://docs.docker.com/
- Docker Compose documentation: https://docs.docker.com/compose/
- MariaDB documentation: https://mariadb.com/kb/en/documentation/
- WordPress documentation: https://wordpress.org/documentation/
- Nginx documentation: https://nginx.org/en/docs/
- PHP-FPM documentation: https://www.php.net/manual/en/install.fpm.php
