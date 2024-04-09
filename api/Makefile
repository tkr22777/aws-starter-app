run_service_locally:
	POSTGRES_HOST=localhost \
	POSTGRES_DB=postgres \
	POSTGRES_USER=postgres \
	POSTGRES_PASSWORD=abcd1234 \
	uvicorn main:app --reload

GIT_COMMIT_HASH := $(shell git rev-parse --short HEAD)
AWS_ECR_REPO_NAME := "user_setting_app"
AWS_ECR_REPO_URL := "894135990422.dkr.ecr.us-east-2.amazonaws.com/user_setting_app"

test:
	pytest # pytest must be installed `pip install pytest`

build_image:
	docker build --no-cache=true -t user_setting_app:$(GIT_COMMIT_HASH) .
	docker tag user_setting_app:$(GIT_COMMIT_HASH) $(AWS_ECR_REPO_URL):$(GIT_COMMIT_HASH)

push_image_to_ecr:
	docker push $(AWS_ECR_REPO_URL):$(GIT_COMMIT_HASH)

list_ecr_images:
	aws ecr list-images --repository-name $(AWS_ECR_REPO_NAME)

delete_current_image_from_ecr:
	aws ecr batch-delete-image --repository-name $(AWS_ECR_REPO_NAME) --image-ids imageTag=$(GIT_COMMIT_HASH)

run_service_container:
	docker-compose up -d --build api
	# docker run -p 8000:8000 --name user_setting_app-instance -i -t -d user_setting_app

run_postgres_contianer:
	docker-compose up -d postgres_db