
scrape-lunar-pit-atlas:
	@python3 src/manual_scripts/scrape_pit_atlas.py

worker-build:
	@docker build -f Dockerfile.worker -t worker .

worker-build-no-cache:
	@docker build -f Dockerfile.worker -t worker --no-cache .

worker-start:
	@mkdir -p ${UTILITY_VOLUME}
	@mkdir -p ${UTILITY_VOLUME}/logs
	@chmod -R 777 ${UTILITY_VOLUME}
	@docker run -it --rm \
		--env-file .env \
		--add-host=host.docker.internal:host-gateway \
		-v $(UTILITY_VOLUME):/app/data \
		-u $(shell id -u):$(shell id -g) \
  		worker --loglevel=$(if $(LOG_LEVEL),$(LOG_LEVEL),INFO) || true

format:
	@poetry run black . --quiet

lint:
	@poetry run pylint src || true

typecheck:
	@poetry run mypy src || true

docker-clean:
	@docker image prune -f
