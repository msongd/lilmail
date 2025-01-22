PROJ_NAME := lilmail
DOCKER_VERSION := 1
APP_NAME := LittleMail

docker-dev:
	docker build --build-arg APP_NAME=$(APP_NAME) -t $(PROJ_NAME):dev .
