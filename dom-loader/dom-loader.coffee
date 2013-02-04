# DOM Loader
# @author shallker.wang@profero.com
# @license MIT

class DOMLoader

  document = window.document

  @loaded: false
  @list: []

  @init: ->
    if @isLoaded() then @loaded = true
    else @listenLoad()
    return @

  @load: (fn)->
    return if typeof fn isnt 'function'
    return fn() if @loaded
    @list.push fn

  @listenLoad: (fn)->
    if document.addEventListener
      document.addEventListener 'DOMContentLoaded', @onLoad, false
      window.addEventListener 'load', @onLoad, false
    else
      document.attachEvent 'onreadystatechange', @onLoad
      window.attachEvent 'onload', @onLoad

  @isLoaded: ->
    document.readyState isnt "loading"

  @onLoad: =>
    @loaded = true
    while @list.length
      fn = @list.shift()
      fn()

@DOMLoader = DOMLoader.init()