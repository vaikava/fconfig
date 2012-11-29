fconfig
============
*fconfig* is a minimal configuration library for node.js, inspired by
the config class of the *ZEND PHP framework*.

It allows multi-environment configurations to be read from either static
`.JSON`-files or dynamic `.js` & `.coffee`-files.

By organising your configuration in environment-specific blocks and configuring
*fconfig* accordingly, you only have to write minimal configuration as non-default
configurations automatically base themselves upon the default environment.

Ie. anything that is declared in `development` is automatically extended to other
environments such as `production` when `development` is set as your default environment.
*(See example below)*


Example configuration
============

	# /configs/config.coffee
	development: 
	  sendEmails: false
	  database:
	    host: "127.0.0.1"
		
	# This block will extend the above "development" block so only
	# specify what needs to differ here
	production:
	  database:
	    host: "192.168.1.30"

	# app.coffee
	fconfig = require "fconfig"
	config =  new fconfig
	  config:      "config.coffee"
	  env_default: "development" # Set the development-block as default


See the `example/app.coffee` file for more details.


Installation
============
	
	npm install fconfig


Roadmap
============
* Deep merging of objects
* Unit tests


License
============
See `LICENSE` file.

> Copyright (c) 2012 Joakim B

