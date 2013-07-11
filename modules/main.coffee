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

  register: (module) ->
    @modules.push module

  init: () =>
    _.each @modules, (module) ->
      if module.active and module.scope.active()
        module.init()
        module.on()
  
  bind: (event, callback) ->
    ### Bind event to given callback ###
    if @events[event]
      @events[event] = [callback]
    else
      @events[event].push callback
  
  raise: (event, e) ->
    ### Raises the specified event ###
    _.each events[event], (f) -> f(e)


class Module
  constructor: (@title, @description, @scope, @init, _on, _off) ->
    @active = true
    @on = () -> @active = true; _on()
    @off = () -> @active = false; _off()


scopes = {
  'all': () -> true
  'portada': () -> document.URL.match(/mediavida\.com(\/)?(p\d+)$/) != null
  'forum': () -> document.URL.match(/\/foro\/[^\/]+(\/p\d+)?$/) != null
  'thread': () -> document.URL.match(/\/foro\/[^\/]+\/[^\/]+(\/\d+)?(#\d+)?$/) != null
}


class ModuleScope
  constructor: (@pages, @regex) ->

  active: () ->
    _.any(@pages, (p) -> scopes[p]()) or _.any(@regex, (r) -> document.URL.match(r) != null)


PT = new PowerTools
$(PT.init)

scope = new ModuleScope(['thread'])
module = new Module('modulo', 'desc', scope, (() -> console.log 'init'), (() -> console.log 'on'), (() -> console.log 'off'))

PT.register module

