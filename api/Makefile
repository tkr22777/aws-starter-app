.PHONY: spin-up-postgres-container

SUBNET="172.10.0.0/16"
NETWORK_NAME="white_app_net"

POSTGRES_INSTANCE_NAME="postgres-instance"
POSTGRES_HOST_IP="172.10.0.4"
POSTGRES_PASSWORD="abcd1234"

MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIRECTORY := $(notdir $(patsubst %/,%,$(dir $(MAKEFILE_PATH))))

spin-up-postgres-container:
	-docker network create --subnet=${SUBNET} ${NETWORK_NAME}
	-docker rm -f ${POSTGRES_INSTANCE_NAME} #cleanup existing instance
	docker run --net ${NETWORK_NAME} --ip ${POSTGRES_HOST_IP} -p 5432:5432 \
		--name ${POSTGRES_INSTANCE_NAME} -e POSTGRES_PASSWORD=${POSTGRES_PASSWORD} -i -t -d postgres

create-postgres-tables:
	create_table_script=$$(cat ./db/create_table.sql);\
	docker exec -it ${POSTGRES_INSTANCE_NAME} psql -U postgres -d postgres -c "$$create_table_script"

exec-postgres-container-cli:
	docker exec -it ${POSTGRES_INSTANCE_NAME} psql -U postgres -d postgres

