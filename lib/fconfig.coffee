class Fconfig
  data:       {}
  dir:        process.cwd() + '/configs/'
  files:      []
  
  constructor: (settings)->
    @env_default = settings.env_default ? 'default'
    @env = process.env.NODE_ENV ? @env_default
    @dir = settings.dir     if settings.dir
    
    if settings.config
      @files.push @dir + settings.config
      do @parseConfigs
  
  # Parse config files by extending non-default
  # Load our files in order, merge default values with environment-
  # specific ones
  parseConfigs: ->
    for file in @files
      fc = require file
      
      # Prefill with default props when available
      if fc[@env_default]
        @data[@env_default] = fc[@env_default]
        delete fc[@env_default]
      
      for k, v of fc
        @data[k] = @_merge( @_merge(v, {}), @_merge(@data[@env_default], {}) )
      
  # Returns either of following
  # get() # All config properties
  # get(false, "development") # All config properties in dev.
  # get("key") # Key property in current env.
  # get("parent.child") # Dot-notated nested property
  get: (k, env) ->
    env = env ? @env
    return @data[env] unless k
    return @_getDotNotated(k, env) if ~k.indexOf "."
    @data[env][k]

  # Returns a property from @data by dot notation
  _getDotNotated: (k, env) ->
    walker = (o, i) -> o[i]
    k.split(".").reduce walker, @data[env]
    
  # Do a shallow copy of the first obj, overwritting the properties
  # in the second
  _merge: (a, b) ->
    b[k] = v for k, v of a
    b

module.exports = Fconfig
