# File Portal
# @description Upload files on HTML
# @dependencies jQuery
# @author shallker.wang@profero.com

Events =
  bind: (ev, callback) ->
    evs   = ev.split(' ')
    calls = @hasOwnProperty('_callbacks') and @_callbacks or= {}

    for name in evs
      calls[name] or= []
      calls[name].push(callback)
    this

  one: (ev, callback) ->
    @bind ev, ->
      @unbind(ev, arguments.callee)
      callback.apply(this, arguments)

  trigger: (args...) ->
    ev = args.shift()

    list = @hasOwnProperty('_callbacks') and @_callbacks?[ev]
    return unless list

    for callback in list
      if callback.apply(this, args) is false
        break
    true

  unbind: (ev, callback) ->
    unless ev
      @_callbacks = {}
      return this

    list = @_callbacks?[ev]
    return this unless list

    unless callback
      delete @_callbacks[ev]
      return this

    for cb, i in list when cb is callback
      list = list.slice()
      list.splice(i, 1)
      @_callbacks[ev] = list
      break
    this

Debuger = 
  debuger: 'Debuger' 
  debug: false

  log: (args...)->
    console.log @debuger, args if @debug

moduleKeywords = ['included', 'extended']

class Module

  @include: (obj) ->
    throw new Error('include(obj) requires obj') unless obj
    for key, value of obj when key not in moduleKeywords
      @::[key] = value

  @extend: (obj) ->
    throw new Error('extend(obj) requires obj') unless obj
    for key, value of obj when key not in moduleKeywords
      @[key] = value

class Portal extends Module

  @include Events
  @include Debuger

  el: null
  debug: true
  debuger: 'Portal'

  constructor: (options)->
    for option, value of options
      @[option] = value
    @portal()

  portal: ->

  _evStop: (ev)->
    ev.stopPropagation()
    ev.preventDefault()

class DropZone extends Portal

  debuger: 'DropZone'
  className: 'file-portal-drop-zone'

  constructor: (options)->
    super
    @initialize()

  initialize: ->
    @listen()

  listen: ->
    @el.addEventListener 'dragenter', @onDragenter
    @el.addEventListener 'dragover', @onDragover
    @el.addEventListener 'drop', @onDrop

  onDragenter: (dragenter)=>
    @log 'onDragenter', dragenter
    @_evStop dragenter
    @trigger 'dragenter'

  onDragover: (dragover)=>
    @log 'onDragover', dragover
    @_evStop dragover
    @trigger 'dragover'

  onDrop: (drop)=>
    @log 'onDrop', drop
    @_evStop drop
    @trigger 'drop', drop

class DelegateDropZone extends DropZone

  selector: ''
  debuger: 'DelegateDropZone'

  constructor: (options)->
    super

  listen: ->
    # $(document).on 'dragenter', @delegater, @onDragenter
    # $(document).on 'dragover', @delegater, @onDragover
    # $(document).on 'drop', @delegater, @onDrop
    $(document).delegate @selector, 'dragenter', @onDelegateDragenter
    $(document).delegate @selector, 'dragover', @onDelegateDragover
    $(document).delegate @selector, 'drop', @onDelegateDrop

  onDelegateDragenter: (dragenter)=>
    @log 'onDelegateDragenter', dragenter
    @onDragenter dragenter

  onDelegateDragover: (dragover)=>
    @log 'onDelegateDragover', dragover
    @onDragover dragover

  onDelegateDrop: (drop)=>
    @log 'onDelegateDrop', drop
    @el = drop.currentTarget
    @onDrop drop

class FileBrowser extends Portal

  debuger: 'FileBrowser'
  className: 'file-portal-file-browser'

  constructor: (options)->
    super
    @initialize()

  initialize: ->
    @appendElInputFile()
    @listen()
 
  appendElInputFile: ->
    @elInputFile = $(@inputFileHtml).appendTo('body').get(0)

  listen: ->
    $(@el).click @onClick
    $(@elInputFile).change @onChange

  onClick: (click)=>
    @log 'onClick', click
    @_evStop click
    @trigger 'click', click
    $(@elInputFile).click()

  onChange: (change)=>
    @log 'onChange', change
    @_evStop change
    @trigger 'change', change

  inputFileHtml:
    """
    <input type="file" style="display: none; opacity: 0;">
    """

class DelegateFileBrowser extends FileBrowser

  selector: ''
  debuger: 'DelegateFileBrowser'

  constructor: (options)->
    super

  listen: ->
    $(document).delegate @selector, 'click', @onDelegateClick
    $(@elInputFile).change @onChange

  onDelegateClick: (click)=>
    @log 'onDelegateClick', click
    @el = click.currentTarget
    @onClick click

class Uploader extends Module

  @include Events
  @include Debuger

  url: ''
  method: 'GET'
  async: true
  header: {}
  listener: {}
  uploadListener: {}
  debug: true
  debuger: 'Uploader'

  constructor: (options = {})->
    for option, value of options
      @[option] = value
    @initialize()

  initialize: ->
    @xhr = new XMLHttpRequest
    @listenRequest()
    @listenUpload()
    @open()
    @setHeader()

  listenRequest: ->
    @xhr.addEventListener ev, func for ev, func of @listener
    @xhr.addEventListener 'progress', @onProgress
    @xhr.addEventListener 'load', @onLoad
    @xhr.addEventListener 'error', @onError
    @xhr.addEventListener 'abort', @onAbort
    @xhr.addEventListener 'loadend', @onLoadend
    @xhr.addEventListener 'readystatechange', @onReadystateChange

  onProgress: (progress)=>
    @log 'onProgress', progress

  # The transfer is complete
  onLoad: (load)=>
    @log 'onLoad', load

  # An error occurred while transferring the file
  onError: (error)=>
    @log 'onError', error

  # The transfer has been canceled by the user
  onAbort: (abort)=>
    @log 'onAbort', abort

  onLoadend: (loadend)=>
    @log 'onLoadend', loadend

  onReadystateChange: (change)=>
    @log 'onReadystateChange', change
    @trigger @xhr.status, @xhr if @xhr.readyState is 4

  listenUpload: ->
    @xhr.upload.addEventListener ev, func for ev, func of @uploadListener

  setHeader: ->
    @xhr.setRequestHeader name, value for name, value of @header

  open: ->
    @xhr.open @method, @url, @async

  send: (data = null)->
    @xhr.send data
    @xhr

  sendFormData: (data)->
    formData = new FormData
    for name, value of data
      formData.append name, value
    @send formData 

class FilePortal

  @dropZone: (el, options = {})->
    options.el = el
    new DropZone options

  @fileBrowser: (el, options = {})->
    options.el = el
    new FileBrowser options

  @delegateDropZone: (selector, options = {})->
    options.selector = selector
    new DelegateDropZone options

  @delegateFileBrowser: (selector, options = {})->
    options.selector = selector
    new DelegateFileBrowser options

  @uploader: (options)->
    new Uploader options

module.exports = FilePortal