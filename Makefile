name = Inception
all:
	@printf "Configuring ${name}...\\n"
	@if [ ! -d "/home/erico-ke/data/" ]; then \
		mkdir -p /home/erico-ke/data/; \
	fi
	@if [ ! -d "/home/erico-ke/data/mariadb" ]; then \
		mkdir -p /home/erico-ke/data/mariadb; \
	fi
	@if [ ! -d "/home/erico-ke/data/wordpress" ]; then \
		mkdir -p /home/erico-ke/data/wordpress; \
	fi
	@cp ./srcs/.env /home/erico-ke/
	@docker-compose -f ./srcs/docker-compose.yml --env-file /home/erico-ke/.env up -d

build:
	@printf "Building ${name} configuration...\\n"
	@if [ ! -d "/home/erico-ke/data/" ]; then \
		mkdir -p /home/erico-ke/data/; \
	fi
	@if [ ! -d "/home/erico-ke/data/mariadb" ]; then \
		mkdir -p /home/erico-ke/data/mariadb; \
	fi
	@if [ ! -d "/home/erico-ke/data/wordpress" ]; then \
		mkdir -p /home/erico-ke/data/wordpress; \
	fi
	@docker-compose -f ./srcs/docker-compose.yml --env-file /home/erico-ke/.env up -d --build

down:
	@printf "Stopping ${name}...\\n"
	@docker-compose -f ./srcs/docker-compose.yml --env-file /home/erico-ke/.env down

re: fclean all

clean: down
	@printf "Cleaning ${name}...\\n"
	@docker system prune -a
	@sudo chmod -R 777 /home/erico-ke/data
	@sudo rm -rf /home/erico-ke/data/wordpress/*
	@sudo rm -rf /home/erico-ke/data/mariadb/*

fclean:
	@printf "Full cleaning ${name}...\\n"
	@sudo rm -rf /home/erico-ke/data/mariadb/*
	@sudo rm -rf /home/erico-ke/data/wordpress/*
	@sudo rm -rf /home/erico-ke/data/*
	@sudo rm -rf /home/erico-ke/data
	@docker stop $$(docker ps -qa)
	@docker system prune --all --force --volumes
	#@docker rm $$(docker ps -a -q) --force
	@docker network prune --force
	@docker volume prune --force
	@docker volume rm $$(docker volume ls -q)
	@rm /home/erico-ke/.env

.PHONY	: all build down re clean fclean