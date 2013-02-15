class Fconfig
  config: {}
  dir:    process.cwd() + '/configs/'
  files:  []
  
  constructor: (opts) ->
    
    # Setup the default fallback environment which is "development" as standard
    # Then setup the CURRENT enviroment that we use ATM
    # Throw an error if we couldn't determine what env to pick
    # Last - override config path if we have given one
    @env_default = opts.env_default ? 'development'

    if !opts.env
      throw new Error "Couldn't determine current enviroment to base config upon"

    @env = opts.env

    @dir = opts.dir if opts.dir
    
    throw new Error "No config file given" unless opts.config

    @files.push @dir + opts.config

    do @parseConfigs
  
  # Parse config files by extending non-default configs with
  # the default environments config
  parseConfigs: ->
    
    configs = require @files[0]

    # Append default environments config to this.configs
    @config[@env_default] = configs[@env_default]

    # Append non-default environment-configs to this.configs
    for k, v of configs

      if k isnt @env_default
        # Recursive merge to avoid reference headaches
        @config[k] = @_recursiveMerge(@_recursiveMerge({}, configs[@env_default]), v)
      
  # Returns either of following
  # get()                     # All config properties for current env
  # get(false, "development") # All config properties in dev.
  # get("key")                # Key property in current env.
  # get("parent.child")       # Dot-notated nested property
  get: (k, env) ->
    env = env ? @env

    return @config[env] unless k
    return @_getDotNotated(k, env) if ~k.indexOf "."

    if typeof @config[env][k] is 'function'
      return @config[env][k]()
    else
      @config[env][k]

  # Returns the complete parsed config object with all environments
  getAll: ->
    @config

  # Returns a property from @config by dot notation
  _getDotNotated: (k, env) ->
    walker = (o, i) -> o[i]
    k.split(".").reduce walker, @config[env]

  # Changes the current environment
  changeEnv: (env) ->
    @env = env

  # Make recursive merging of two objects, oerriding props
  # in the first object with props from the second
  _recursiveMerge: (obj1, obj2) ->
    
    for prop of obj2
      try
        if obj2[prop].constructor is Object
          obj1[prop] = @_recursiveMerge(obj1[prop], obj2[prop])
        else
          obj1[prop] = obj2[prop]
      catch err
        obj1[prop] = obj2[prop]

    obj1
    
module.exports = Fconfig
