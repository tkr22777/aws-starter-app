.PHONY: spin_up_postgres_container

SUBNET="172.10.0.0/16"
NETWORK_NAME="white_app_net"

APP_IP="172.10.0.3"

POSTGRES_INSTANCE_NAME="postgres_instance"
POSTGRES_HOST_IP="172.10.0.4"
POSTGRES_PASSWORD="abcd1234"

DOCKER_CONTAINER_PORT="8000"
DOCKER_IMAGE_NAME="user_setting_app"
DOCKER_CONTAINER_NAME="user_setting_app_instance"

MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIRECTORY := $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))

test:
	# the test script

start:
	uvicorn main:app --reload

spin_up_dockerized_service:
	-docker network create --subnet=${SUBNET} ${NETWORK_NAME}
	-docker rm -f ${DOCKER_CONTAINER_NAME} #cleanup existing instance
	docker run --net ${NETWORK_NAME} --ip ${APP_IP} \
		--env POSTGRES_HOST_IP=${POSTGRES_HOST_IP} \
		-p ${DOCKER_CONTAINER_PORT}:8000 --name ${DOCKER_CONTAINER_NAME} -i -t ${DOCKER_IMAGE_NAME}

build_docker_image:
	docker build --no-cache=true -t ${DOCKER_IMAGE_NAME} .
	
spin_up_postgres_container:
	-docker network create --subnet=${SUBNET} ${NETWORK_NAME}
	-docker rm -f ${POSTGRES_INSTANCE_NAME} #cleanup existing instance
	docker run --net ${NETWORK_NAME} --ip ${POSTGRES_HOST_IP} -p 5432:5432 \
		--name ${POSTGRES_INSTANCE_NAME} -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} -i -t -d postgres:13

create_postgres_tables:
	create_table_script=$$(cat ./db/create_table.sql);\
	docker exec -it ${POSTGRES_INSTANCE_NAME} psql -U postgres -d postgres -c "$$create_table_script"

exec_postgres_container_cli:
	docker exec -it ${POSTGRES_INSTANCE_NAME} psql -U postgres -d postgres
