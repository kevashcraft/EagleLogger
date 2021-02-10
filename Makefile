
callsigns_build:
	docker build -t eaglelogger_callsigns -f build/callsigns.dockerfile callsigns

callsigns: callsigns_build
	docker run -it -v $(shell pwd)/callsigns:/callsigns -v $(shell pwd)/secret:/secret eaglelogger_callsigns bash

