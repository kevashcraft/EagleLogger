default: dev

.PHONY: build

callsigns_build:
	docker build -t eaglelogger_callsigns -f build/callsigns.dockerfile callsigns

callsigns: callsigns_build
	docker run -it -v $(shell pwd)/callsigns:/callsigns -v $(shell pwd)/secret:/secret eaglelogger_callsigns bash

build:
	docker build -t eaglelogger_dev -f build/development.dockerfile app

bash: build
	docker run -it -v $(shell pwd)/app:/app eaglelogger_dev bash

dev: build
	docker run -p 38888:8080 -v $(shell pwd)/app:/app eaglelogger_dev

prod_build:
	docker build -f build/production.dockerfile -t kevashcraft/eaglelogger:latest .

prod_push: prod_build
	docker push kevashcraft/eaglelogger:latest

upgrade: prod_build prod_push
	helm upgrade eaglelogger build/chart

install: prod_push
	helm install eaglelogger build/chart
