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


cordova_build: build
	docker build -t eaglelogger_cordova -f build/cordova.dockerfile .

cordova: cordova_build
	docker run \
			-it \
			-v $(shell pwd)/cordova-ios:/cordova-ios \
			-v $(shell pwd)/dist:/dist \
			-v $(shell pwd)/res:/res \
			-v $(shell pwd)/app/src:/app/src \
			-v $(shell pwd)/app/public:/app/public \
			-v $(shell pwd)/build/build-app:/bin/build-app \
			-v $(shell pwd)/build/build-apk:/bin/build-apk \
			-v $(shell pwd)/build/build-resources:/bin/build-resources \
			-v $(shell pwd)/build/build-cordova-ios:/bin/build-cordova-ios \
			-v $(shell pwd)/build/config-ios.xml:/cordova/eaglelogger/config-ios.xml \
			-v $(shell pwd)/build/config.xml:/cordova/eaglelogger/config.xml \
			eaglelogger_cordova bash

cordova_prod: cordova_build
	docker run \
		-it \
		-v $(shell pwd)/dist:/dist \
		-v $(shell pwd)/secret:/secret \
		-v $(shell pwd)/app/src:/app/src \
		-v $(shell pwd)/res:/res \
		-v $(shell pwd)/app/public:/app/public \
		-v $(shell pwd)/build/config.xml:/cordova/eaglelogger/config.xml \
	eaglelogger_cordova bash -c " \
		build-app; \
		cd /cordova/eaglelogger; \
		rm -rf www; \
		mv /app/dist www; \
		build-resources; \
		cordova build android \
			--release \
			-- \
			--keystore /secret/eaglelogger.keystore \
			--alias kevins-apps \
			--storePassword=$(keystore_pass) \
			--password=$(keystore_pass) && \
			cp /cordova/eaglelogger/platforms/android/app/build/outputs/apk/release/app-release.apk /dist/app-release.apk"

