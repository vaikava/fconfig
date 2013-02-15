REPORTER ?= spec

test: compile lint
	@./node_modules/.bin/mocha \
	--require coffee-script \
	--compilers coffee:coffee-script \
	--reporter $(REPORTER) \
	$(ARGS)

compile:
	@./node_modules/.bin/coffee -c ./lib/fconfig

lint:
	@./node_modules/.bin/coffeelint -f .coffeelint.json -r ./lib 
	
.PHONY: test compile