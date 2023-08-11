DOCKER_IMAGE_NAME="user_setting_app"

test:
	# the test script

start:
	uvicorn main:app --reload

spin_up_dockerized_service:
	docker-compose up -d api

build_docker_image:
	docker build --no-cache=true -t ${DOCKER_IMAGE_NAME} .
	
spin_up_postgres_container:
	docker-compose up -d postgres_db

