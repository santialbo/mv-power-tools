###
// ==UserScript==
// @name        mv-power-tools
// @namespace   santialbo/mv-power-tools
// @version     0
// @description Adds extra features for mediavida.com
// @grant       GM_addStyle
// @include     http://www.mediavida.com/*
// @require     http://code.jquery.com/jquery-1.10.1.min.js
// @require     http://cdn.jsdelivr.net/tipsy/1.0/javascripts/jquery.tipsy.js
// @require     http://cdn.craig.is/js/mousetrap/mousetrap.min.js
// @require     http://cdnjs.cloudflare.com/ajax/libs/underscore.js/1.4.4/underscore-min.js
// ==/UserScript==
###

class PowerTools
  version: 1
  modules: []
  events: {}
  settings: {}
  scopes:
    all:       () -> document.URL.match /./
    portada:   () -> document.URL.match /mediavida\.com(\/)?(p\d+)$/
    favorites: () -> document.URL.match /\/foro\/favoritos$/
    spy:       () -> document.URL.match /\/foro\/spy$/
    forum:     () -> document.URL.match /\/foro\/((?!(spy|favoritos|\/|\?)).)+(\/p\d+)?$/
    thread:    () -> document.URL.match /\/foro\/[^\/\?]+\/[^\/\?]+(\/\d+)?(#\d+)?$/
    compose:   () -> document.URL.match /\/foro\/post\.php\?fid=\d+$/
    reply:     () -> document.URL.match /\/foro\/post\.php\?tid=\d+$/
    profile:   () -> document.URL.match /\/id\/[^\/]+$/

  register: (module) ->
    @modules.push module

  init: () =>
    _.each @modules, (module) ->
      if module.active and _.any(module.scopes, (f) -> f())
        module.init()
        module.on()
  
  bind: (event, callback) ->
    ###
    Bind event to given callback
    ###
    if @events[event]
      @events[event] = [callback]
    else
      @events[event].push callback
  
  raise: (event, e) ->
    ###
    Raises the specified event
    ###
    _.each events[event], (f) -> f(e)


class Module
  constructor: (@title, @description, @scopes, @init, _on, _off) ->
    ###
    Creates a new module.
      @title: Title/name of the module.
      @description: Brief description of the module.
      @scopes: list of functions that will run the module if any returns true.
      @init: Function that initializes the module. Runs only once.
      _on: Function that will turn on the script. Runs every time the script is activated.
      _off: Function that will turn off the script. Runs every time the script is deactivated.
    ###
    @active = true
    @on = () -> @active = true; _on()
    @off = () -> @active = false; _off()

PT = new PowerTools
$(PT.init)

scopes = [PT.scopes.forum]
module = new Module('modulo', 'desc', scopes, (() -> console.log 'init'), (() -> console.log 'on'), (() -> console.log 'off'))

PT.register module
