run_service_locally:
	POSTGRES_HOST=localhost \
	POSTGRES_DB=postgres \
	POSTGRES_USER=postgres \
	POSTGRES_PASSWORD=abcd1234 \
	uvicorn main:app --reload

test:
	pytest # pytest must be installed `pip install pytest`

build_service_image:
	docker build --no-cache=true -t user_setting_app .

run_service_container:
	docker-compose up -d --build api
	# docker run -p 8000:8000 --name user_setting_app-instance -i -t -d user_setting_app

run_postgres_contianer:
	docker-compose up -d postgres_db
