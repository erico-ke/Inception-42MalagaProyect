# Developer Documentation

## Prerequisites
Before setting up the project, make sure the following tools are installed:

- Docker;
- Docker Compose;
- Make;
- a browser for testing the HTTPS site;
- optionally, `curl` and `docker logs` for troubleshooting.

## Project Configuration
The main configuration files are:

- `srcs/.env` for service variables and credentials;
- `srcs/docker-compose.yml` for the service topology;
- `srcs/requirements/mariadb/conf/mariadb.cnf` for MariaDB settings;
- `srcs/requirements/nginx/conf/nginx.conf` for Nginx reverse-proxy and TLS settings;
- `srcs/requirements/mariadb/tools/init.sh` for database initialization;
- `srcs/requirements/wordpress/tools/wordpress.sh` for WordPress bootstrapping.

If you need to change passwords, the database name, or the domain, edit `srcs/.env` before launching the stack.

## Build and Launch
From the repository root:

1. Run `make` to create the host data directories, copy the environment file, and start the stack.
2. Run `make build` if you want to force a rebuild of the images before starting.

The Makefile will prepare the following host path:

- `/home/erico-ke/data/mariadb` for MariaDB persistence.

It also creates `/home/erico-ke/data/wordpress` as part of the standard project layout, but WordPress persistence itself is handled by the Docker-managed volume `wordpress_files`.

The stack is launched with Docker Compose using `srcs/docker-compose.yml` and the copied environment file at `/home/erico-ke/.env`.

## Useful Container and Volume Commands
The Makefile covers the common lifecycle actions:

- `make down` stops the stack;
- `make re` removes the current stack state and starts again;
- `make clean` stops the stack and removes images, networks, and local data aggressively;
- `make fclean` removes containers, volumes, and the copied environment file.

When deeper inspection is needed, these Docker commands are useful:

- `docker ps` to list running containers;
- `docker-compose -f srcs/docker-compose.yml --env-file /home/erico-ke/.env ps` to inspect the compose project;
- `docker logs <container>` to read container output;
- `docker volume ls` to list volumes;
- `docker volume inspect wordpress_files` to inspect the WordPress volume;
- `docker inspect mariadb` or `docker inspect nginx` to review container settings.

## Data Storage and Persistence
This project persists data in two different ways:

- MariaDB stores its data in a bind mount at `/home/erico-ke/data/mariadb`.
- WordPress files persist in the Docker-managed volume `wordpress_files`.

This means the application survives container recreation, but `make fclean` and the Docker pruning commands used by the cleanup targets can remove the stored data.

## Launch Flow Overview
At startup:

1. The Makefile prepares the host directories and copies the environment file.
2. MariaDB starts first and creates the database and users from the environment variables.
3. WordPress downloads the upstream package, configures `wp-config.php`, installs WordPress, and creates the initial users.
4. Nginx starts last and serves the site over HTTPS on port 443.

## Troubleshooting Tips
- If the site is unreachable, check that the domain resolves locally and that port 443 are free.
- If WordPress cannot connect to the database, confirm that the values in `srcs/.env` match the running MariaDB container.
- If the containers fail after a cleanup, recreate the data directories and run `make build` again.