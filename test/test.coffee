assert = require("chai").assert
Fconfig = require '../'

describe "Config is correct in default environment", ->

  before ->
    @config = new Fconfig
      config:      "config.coffee"
      dir:         process.cwd() + "/example/"
      env:         "development"
      env_default: "development"    

  it "Returns correctly with regular  the correct port", ->
    assert.equal @config.get("port"), 3333

  it "Executes a closure before returning it", ->
    assert.isNotFunction @config.get("fn")
    assert.ok            @config.get("fn")

  it "Can reach into objects with dot notation", ->
    assert.equal @config.get("nested.element"), true

  it "Can return all environments", ->
    # Make sure that we got three top-level object 
    # props for each of our environments (prod, env & testing)
    assert.equal Object.keys(@config.getAll()).length, 3

  it "Can get config keys for a specific env", ->
    assert.equal @config.get("port", "production"), 5555

  it "Can change environment", ->
    @config.changeEnv "production"
    assert.equal @config.env, "production"

describe "Config is correct in non-default environments", ->

  before ->
    @config = new Fconfig
      config:      "config.coffee"
      dir:         process.cwd() + "/example/"
      env:         "testing"
      env_default: "development"    

  it "Uses the correct port", ->
    assert.equal @config.get("port"), 4444