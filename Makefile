# This file is just for convenience during development. Has no impact on the project itself. Feel free to use or ignore

SHELL := /bin/bash
VENV_NAME := .env
SRC := $(shell find jamulizer -name "*.py" -print -o -path ./.env -prune)

all: build test

build: .build.ts

.build.ts:
	python3 -m venv $(VENV_NAME)
	$(VENV_NAME)/bin/pip install -r requirements.txt
	@touch $@

run: .build.ts
	$(VENV_NAME)/bin/python -m jamulizer

clean:
	rm -f .*.ts;

distclean: clean
	rm -rf $(VENV_NAME)

clean_pyc:
	find . -name "*.pyc" -delete

check: test
test: build .tests.ts

lint: build .pylint.ts

.tests.ts: $(SRC)
	$(VENV_NAME)/bin/pytest
	@touch $@

.pylint.ts: $(SRC)
	$(VENV_NAME)/bin/pylint --rcfile=.pylintrc --reports n -f colorized $(filter %.py, $?)
	@touch $@

