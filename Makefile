include .env
.DEFAULT_GOAL := all 

NAME = task-api
VERSION = 1.0.0

all: install build-front ## Run pipeline

install: ## install server and frontend dependencies locally
	npm install
	cd ./frontend && yarn install
	cd ./backend && yarn install

build-front: ## run locally
	cd ./frontend && npm run build

run-front: ## run locally port 8080
	cd frontend && npm start

run-target: ## run target
	DOCKER_BUILDKIT=1 docker build  -t $(NAME):$(VERSION) --target=$(TARGET) .


build-image: ## build docker image
	make run-target TARGET=release

run-docker: build-image ## run server on docker
	DOCKER_BUILDKIT=1 \
	docker run --rm \
		-e PORT=$(PORT) \
		-e JWT_SECRET=$(JWT_SECRET) \
		-e DATABASE_URL=$(DATABASE_URL) \
		--network host \
		$(NAME):$(VERSION)

run: ## run locally
	NODE_ENV=development \
	JWT_SECRET=$(JWT_SECRET) \
	PORT=$(PORT_DEV) \
	DATABASE_URL=$(DATABASE_URL) \
	node backend/src/index.js


sql-scripts:
	cd backend/src/db/sql_scripts && \
	DATABASE_URL=$(DATABASE_URL)  node run_migrations.js

lint: ## format code
	cd ./frontend && npm run format
	npm run format
	cd ./frontend && npm run lint
	npm run lint
	cd ../backend && npm run format

run-postgres:  ##@postgres run postgres on docker
	DOCKER_BUILDKIT=1 \
	docker run  \
	-e POSTGRES_HOST_AUTH_METHOD=trust \
	--rm \
	-v $(CURDIR)/postgres-data:/var/lib/postgresql/data \
	-p 5436:5432 \
	postgres:16.3

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'