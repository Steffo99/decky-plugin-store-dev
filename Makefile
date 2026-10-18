.PHONY: Makefile
help:
	@echo "Read the Makefile plz"

autoformat/black:
	black plugin_store/ tests/

autoformat/isort:
	isort plugin_store/ tests/

autoformat: autoformat/black autoformat/isort

lint/flake8:
	poetry run flake8 plugin_store/ tests/

lint/isort:
	poetry run isort --check --diff plugin_store/ tests/

lint/black:
	poetry run black --check --diff plugin_store/ tests/

lint/mypy:
	PYTHON_PATH=./plugin_store poetry run mypy plugin_store/ tests/

lint: lint/black lint/isort lint/flake8 lint/mypy

migrations/apply:
	alembic upgrade head

migrations/autogenerate:
	alembic revision --autogenerate

migrations/create:
	alembic revision

dc/build:
	docker compose -f compose.local.yaml build

dc/%:
	docker compose -f compose.local.yaml run -w /app plugin_store poetry run make $*

deps/lock:
	poetry lock --no-update

deps/upgrade:
	poetry lock

test:
	SQLALCHEMY_WARN_20=1 poetry run pytest ./tests