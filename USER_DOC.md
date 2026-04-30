# User Documentation

## What This Stack Provides
This project deploys a WordPress website backed by MariaDB and served through Nginx over HTTPS.

The stack includes:

- Nginx as the public entry point on port 443;
- WordPress with PHP-FPM for the application layer;
- MariaDB for the database;
- persistent storage so data remains available after a restart.

## Start and Stop the Project
From the repository root:

- Start the stack with `make` or `make build`.
- Stop the stack with `make down`.
- Fully reset it with `make re`.

If the first launch is taking time, wait until the containers finish downloading images, generating the SSL certificate, and installing WordPress.

## Access the Website
Open `https://erico-ke.42.fr` in a browser.

The site uses a self-signed certificate, so the browser may show a warning on first access. This is expected for the project environment.

## Access the Administration Panel
The WordPress administration page is available at:

- `https://erico-ke.42.fr/wp-admin/`

Use the WordPress administrator account defined in `srcs/.env`.

## Credentials
Project credentials are stored in `srcs/.env`.

The main values are:

- database name and database user credentials for MariaDB;
- WordPress administrator credentials;
- WordPress regular user credentials;
- the domain name used by Nginx and WordPress.

The Makefile copies that file to `/home/erico-ke/.env` when the stack starts, so the same values are used by Docker Compose.

## Check That Services Are Running
You can verify the stack in several ways:

- Use `make` or `make build` and confirm that all containers start without errors.
- Open the website in a browser and confirm that WordPress loads over HTTPS.
- Check the containers with `docker ps` or `docker-compose ps`.
- View logs with `docker logs nginx`, `docker logs wp_php`, or `docker logs mariadb`.

## Notes for End Users
- Do not remove the data directory if you want to keep the database contents.
- If you run `make fclean`, the stack and its stored data are removed.
- If the domain does not open, make sure it resolves to your local machine in your hosts file.