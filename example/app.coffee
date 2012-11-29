config = require("../lib/fconfig.js")
config = new config
  config:      "config.coffee"
  dir:         process.cwd() + '/example/' # Default is the /configs subfolder in your project
  env_default: "development" # Default is "default"

# Get all config properties
allconfig = config.get()

# Get all config properties for a specific environment
prodconfig = config.get(false, "production")

# Get nested config properties by dot notation
host = config.get "database.host"

