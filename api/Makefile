test:
	# the test script

start:
	uvicorn main:app --reload

spin_up_dockerized_service:
	docker-compose up -d api
	#docker run -p 80:8000 --name user_setting_app-instance -i -t -d user_setting_app


build_docker_image:
	docker build --no-cache=true -t user_setting_app .
	
spin_up_postgres_container:
	docker-compose up -d postgres_db

