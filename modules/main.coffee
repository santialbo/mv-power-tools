class PowerTools
  version: '0.3.0'
  modules: []
  events: {}
  settings: {}
  scopes:
    all:        _.once () -> not document.URL.match /\.(gif|jpe?g|png)$/
    loggedIn:   _.once () -> $('li.logout').length > 0
    main:       _.once () -> document.URL.match /mediavida\.com(\/)?(p\d+)(#.*)?$/
    favorites:  _.once () -> document.URL.match /\/foro\/favoritos(#.*)?$/
    spy:        _.once () -> document.URL.match /\/foro\/spy(#.*)?$/
    forum:      _.once () -> document.URL.match /\/foro\/((?!(spy|favoritos|\/|\?)).)+(\/p\d+)?(#.*)?$/
    thread:     _.once () -> document.URL.match /\/foro\/[^\/\?]+\/[^\/\?]+(\/\d+)?(#.*)?$/
    threadLive: _.once () -> document.URL.match /\/foro\/[^\/\?]+\/[^\/\?]+\/live(#.*)?$/
    compose:    _.once () -> document.URL.match /\/foro\/post\.php\?fid=\d+(&.*=.*)?(#.*)?$/
    reply:      _.once () -> document.URL.match /\/foro\/post\.php\?tid=\d+(&.*=.*)?(#.*)?$/
    profile:    _.once () -> document.URL.match /\/id\/[^\/]+(#.*)?$/
    dark:       _.once () -> $('#main').css('background-color') == 'rgb(47, 56, 62)'

  options:
    set: (key, object) -> localStorage.setItem 'pt-' + key, JSON.stringify object
    get: (key) -> JSON.parse localStorage.getItem('pt-' + key)
    exists: (key) -> localStorage.getItem('pt-' + key) != null
    remove: (key) -> localStorage.removeItem('pt-' + key)

  constructor: () ->
    if not @options.exists 'active-modules'
      @options.set 'active-modules', {}

  register: (module) ->
    activeModules = @options.get 'active-modules'
    if module.name of activeModules
      module.active = activeModules[module.name]
    else
      activeModules[module.name] = module.active
      @options.set 'active-modules', activeModules
    @modules.push module

  init: () =>
    _.each @modules, (module) ->
      if module.canRun() and module.active
        module.on()

  bind: (event, callback) ->
    ###
    Bind event to given callback
    ###
    if @events[event]
      @events[event].push callback
    else
      @events[event] = [callback]

  unbind: (event, callback) ->
    @events[event].splice @events[event].indexOf(callback), 1
  
  raise: (event, e) ->
    ###
    Raises the specified event
    ###
    if event of @events
      _.each @events[event], (f) -> f(e)


class Module
  constructor: (@name, @title, @description, @scopes, @general, _init, _on, _off) ->
    ###
    Creates a new module.
      @name: Identifier of the module.
      @title: Title of the module.
      @description: Brief description of the module.
      @scopes: list of functions that will run the module if any returns true.
      @general: if true, this module runs always (e.g settings panel).
      _init: Function that initializes the module. Runs only once.
      _on: Function that will turn on the script. Runs every time the script is activated.
      _off: Function that will turn off the script. Runs every time the script is deactivated.
    ###
    @active = true
    @init = if _init then _.once _init
    @on = () ->
      @active = true
      @init()
      if _on then _on()
    @off = () ->
      @active = false
      if _off then _off()

  canRun: () ->
    _.any @scopes, (f) -> f()

  toggle: () ->
    activeModules = PT.options.get 'active-modules'
    activeModules[@name] = not activeModules[@name]
    PT.options.set 'active-modules', activeModules


PT = new PowerTools
$(document).ready PT.init
