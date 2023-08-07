.DEFAULT_GOAL := run

## DEV

.PHONY: run
run: clean build_image run_container

.PHONY: clean
clean: kill_container
	- docker rm app_dev_latest
	- docker rmi app_dev:latest

.PHONY: build_image
build_image:
	docker build --file docker/Dockerfile.dev --tag app_dev:latest .

.PHONY: run_container
run_container:
	docker run --rm \
	--publish 127.0.0.1:5000:5000 \
	--mount type=bind,source=.,target=/app \
	--name app_dev_latest \
	app_dev:latest

.PHONY: kill_container
kill_container:
	-@ docker kill app_dev_latest

.PHONY: shell
shell:
	docker exec -it app_dev_latest /bin/bash

## PROD

.PHONY: prod
prod: build_image_prod

.PHONY: run_prod
run_prod: clean_prod build_image_prod run_container_prod

.PHONY: clean_prod
clean_prod: kill_container_prod
	-@ docker rm app_prod_latest
	-@ docker rmi app_prod:latest

.PHONY: build_image_prod
build_image_prod:
	docker build --file docker/Dockerfile.prod --tag app_prod:latest .

.PHONY: run_container_prod
run_container_prod:
	-@ docker rm app_prod_latest
	docker run --rm --publish 127.0.0.1:5000:5000 --name app_prod_latest app_prod:latest

.PHONY: kill_container_prod
kill_container_prod:
	-@ docker kill app_prod_latest

.PHONY: shell_prod
shell_prod:
	docker exec -it app_prod_latest /bin/sh

## MISC

.PHONY: nuke
nuke:
	- docker ps | cut -w -f1 | grep -v CONTAINER | xargs -n 1 docker kill
	- docker container ls -a | cut -w -f1 | grep -v CONTAINER | xargs -n 1 docker rm
	- docker volume ls | cut -w -f2 | grep -v VOLUME | xargs -n 1 docker volume rm
	- docker image ls | cut -w -f3 | grep -v IMAGE | xargs -n 1 docker image rm -f
	- docker builder prune -a -f
